//--------------------------------------------------------------------------------------
//
// MIT License
// 
// Copyright (c) 2023 Advanced Micro Devices, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice (including the 
// next paragraph) shall be included in all copies or substantial portions 
// of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Description   : Pipelined transport connection between DCMACs, for NoC comparison
//                 purposes only
//                 Multiple pipeline stages to allow for SLR crossings
//--------------------------------------------------------------------------------------

// Handy defines
`define RP_SEG_S_M_PORT(SegNum) \
    input  [127:0] axiseg_s``SegNum``_tdata,       \
    input          axiseg_s``SegNum``_tuser_ena,   \
    input          axiseg_s``SegNum``_tuser_eop,   \
    input          axiseg_s``SegNum``_tuser_err,   \
    input  [3:0]   axiseg_s``SegNum``_tuser_mty,   \
    input          axiseg_s``SegNum``_tuser_sop,   \
    output [127:0] axiseg_m``SegNum``_tdata,       \
    output         axiseg_m``SegNum``_tuser_ena,   \
    output         axiseg_m``SegNum``_tuser_eop,   \
    output         axiseg_m``SegNum``_tuser_err,   \
    output [3:0]   axiseg_m``SegNum``_tuser_mty,   \
    output         axiseg_m``SegNum``_tuser_sop

`define RP_PORT_REMAP(SegNum) \
    assign axiseg_m``SegNum``_tdata      = axiseg_egr_tdata[SEG_DW*``SegNum``+:SEG_DW];           \
    assign axiseg_m``SegNum``_tuser_ena  = axiseg_egr_tuser_ena[``SegNum``];                      \
    assign axiseg_m``SegNum``_tuser_eop  = axiseg_egr_tuser_eop[``SegNum``];                      \
    assign axiseg_m``SegNum``_tuser_err  = axiseg_egr_tuser_err[``SegNum``];                      \
    assign axiseg_m``SegNum``_tuser_mty  = axiseg_egr_tuser_mty[SEG_MTYW*``SegNum``+:SEG_MTYW];   \
    assign axiseg_m``SegNum``_tuser_sop  = axiseg_egr_tuser_sop[``SegNum``];                      \
    assign axiseg_ing_tdata[SEG_DW*``SegNum``+:SEG_DW]          = axiseg_s``SegNum``_tdata;       \
    assign axiseg_ing_tuser_ena[``SegNum``]                     = axiseg_s``SegNum``_tuser_ena;   \
    assign axiseg_ing_tuser_eop[``SegNum``]                     = axiseg_s``SegNum``_tuser_eop;   \
    assign axiseg_ing_tuser_err[``SegNum``]                     = axiseg_s``SegNum``_tuser_err;   \
    assign axiseg_ing_tuser_mty[SEG_MTYW*``SegNum``+:SEG_MTYW]  = axiseg_s``SegNum``_tuser_mty;   \
    assign axiseg_ing_tuser_sop[``SegNum``]                     = axiseg_s``SegNum``_tuser_sop


// Module declaration
module bd_noc_wrapper (
    input  wire       arstn,
    input  wire       m_aclk,
    input  wire       s_aclk,
    `RP_SEG_S_M_PORT(0),
    `RP_SEG_S_M_PORT(1),
    `RP_SEG_S_M_PORT(2),
    `RP_SEG_S_M_PORT(3),
    `RP_SEG_S_M_PORT(4),
    `RP_SEG_S_M_PORT(5),
    `RP_SEG_S_M_PORT(6),
    `RP_SEG_S_M_PORT(7),
    input  wire [3:0] axiseg_ready_out,
    input  wire [2:0] axiseg_tid_in,
    output wire [2:0] axiseg_tid_out,
    input  wire       axiseg_valid_in,
    output wire [3:0] axiseg_valid_out,
    output reg        err_alignment_egr,
    output reg  [3:0] err_overflow_ing
);


//****************************************************************
//  Parameters
//****************************************************************

localparam integer NUM_SEG            = 8;
localparam integer SEG_TID_W          = 3;
localparam integer SEG_DW             = 128;
localparam integer SEG_MTYW           = $clog2(SEG_DW/8);
localparam integer PIPELINE_STAGES    = 5;

// pipeline includes Nx[data, mty, ena, sop, eop, err], valid, tid
localparam integer PIPELINE_W  = NUM_SEG*(SEG_DW+SEG_MTYW+1+1+1+1)+1+SEG_TID_W;

localparam integer ING_FIFO_D       = 128;
localparam integer EGR_FIFO_D       = 128;
localparam integer ING_FIFO_W       = PIPELINE_W-1;  // no valid
localparam integer EGR_AF_LEVEL     = EGR_FIFO_D-PIPELINE_STAGES-5;
localparam integer NUM_EGR_FIFOS    = 4;
localparam integer NUM_SEG_PER_FIFO = 2;
localparam integer EGR_FIFO_W       = NUM_SEG_PER_FIFO*(SEG_DW+SEG_MTYW+1+1+1+1)+SEG_TID_W+2;  // add tag

localparam integer MIN_FIFO_FILL = EGR_FIFO_D/4;


//****************************************************************
//  Signal Declarations
//****************************************************************

logic                  local_m_rstn;
logic                  local_s_rstn;

// ingress/egress mapping to/from ports
logic [NUM_SEG*SEG_DW-1:0]       axiseg_ing_tdata;
logic [NUM_SEG-1:0]              axiseg_ing_tuser_ena;
logic [NUM_SEG-1:0]              axiseg_ing_tuser_sop;
logic [NUM_SEG-1:0]              axiseg_ing_tuser_eop;
logic [NUM_SEG-1:0]              axiseg_ing_tuser_err;
logic [NUM_SEG*SEG_MTYW-1:0]     axiseg_ing_tuser_mty;
logic [NUM_SEG*SEG_DW-1:0]       axiseg_egr_tdata;
logic [NUM_SEG-1:0]              axiseg_egr_tuser_ena;
logic [NUM_SEG-1:0]              axiseg_egr_tuser_sop;
logic [NUM_SEG-1:0]              axiseg_egr_tuser_eop;
logic [NUM_SEG-1:0]              axiseg_egr_tuser_err;
logic [NUM_SEG*SEG_MTYW-1:0]     axiseg_egr_tuser_mty;

// ingress reg
logic [SEG_TID_W-1:0]            axiseg_ing_reg_tid;
logic                            axiseg_ing_reg_valid;
logic [NUM_SEG*SEG_DW-1:0]       axiseg_ing_reg_tdata;
logic [NUM_SEG-1:0]              axiseg_ing_reg_tuser_ena;
logic [NUM_SEG-1:0]              axiseg_ing_reg_tuser_sop;
logic [NUM_SEG-1:0]              axiseg_ing_reg_tuser_eop;
logic [NUM_SEG-1:0]              axiseg_ing_reg_tuser_err;
logic [NUM_SEG*SEG_MTYW-1:0]     axiseg_ing_reg_tuser_mty;

// ingress FIFO
logic [ING_FIFO_W-1:0]        ingfifo_wdata;
logic                         ingfifo_wen, ingfifo_wfull, ingfifo_wrst_busy;
logic [ING_FIFO_W-1:0]        ingfifo_rdata;
logic                         ingfifo_ren, ingfifo_rvalid, ingfifo_rempty;
logic [$clog2(ING_FIFO_D):0]  ingfifo_rcnt;
logic                         ingfifo_min_fill = 0;
logic                         ingfifo_min_fill_reached = 0;

// pipeline stages
(* shreg_extract = "no" *) (* srl_style = "register" *) logic [PIPELINE_W-1:0]  pipeline_data [PIPELINE_STAGES-1:0];
// pipeline fields
logic [SEG_TID_W-1:0]            pipe_tid;
logic                            pipe_valid;
logic [NUM_SEG*SEG_DW-1:0]       pipe_tdata;
logic [NUM_SEG-1:0]              pipe_tuser_ena;
logic [NUM_SEG-1:0]              pipe_tuser_sop;
logic [NUM_SEG-1:0]              pipe_tuser_eop;
logic [NUM_SEG-1:0]              pipe_tuser_err;
logic [NUM_SEG*SEG_MTYW-1:0]     pipe_tuser_mty;

// misc egress
logic [1:0]                      tag = 0;
logic [1:0]                      axiseg_egr_tag_raw [NUM_EGR_FIFOS-1:0];
logic [SEG_TID_W-1:0]            axiseg_egr_tid_raw [NUM_EGR_FIFOS-1:0];
logic [NUM_EGR_FIFOS-2:0]        xfer_tag_err_vec = 0;
logic [NUM_EGR_FIFOS-1:0]        egrfifo_wpfull;
logic                            egrfifo_wpfull_reg = 0;


//****************************************************************
//  Local resets
//    limits fanout, allows input reset to be async to clock
//****************************************************************

xpm_cdc_single #(
    .DEST_SYNC_FF   ( 4 ),  
    .INIT_SYNC_FF   ( 0 ),  
    .SIM_ASSERT_CHK ( 0 ),
    .SRC_INPUT_REG  ( 0 )  
) rstn_s_sync (
    .dest_out       ( local_s_rstn ),
    .dest_clk       ( s_aclk       ),
    .src_in         ( arstn        ) 
);

xpm_cdc_single #(
    .DEST_SYNC_FF   ( 4 ),  
    .INIT_SYNC_FF   ( 0 ),  
    .SIM_ASSERT_CHK ( 0 ),
    .SRC_INPUT_REG  ( 0 )  
) rstn_m_sync (
    .dest_out       ( local_m_rstn ),
    .dest_clk       ( m_aclk       ),
    .src_in         ( arstn        ) 
);


//****************************************************************
//  Input/output mapping
//****************************************************************

`RP_PORT_REMAP(0);
`RP_PORT_REMAP(1);
`RP_PORT_REMAP(2);
`RP_PORT_REMAP(3);
`RP_PORT_REMAP(4);
`RP_PORT_REMAP(5);
`RP_PORT_REMAP(6);
`RP_PORT_REMAP(7);


//****************************************************************
//  Register inputs
//****************************************************************

always_ff @ (posedge s_aclk) begin
    axiseg_ing_reg_tid       <= axiseg_tid_in;
    axiseg_ing_reg_valid     <= axiseg_valid_in;
    axiseg_ing_reg_tdata     <= axiseg_ing_tdata;
    axiseg_ing_reg_tuser_ena <= axiseg_ing_tuser_ena;
    axiseg_ing_reg_tuser_sop <= axiseg_ing_tuser_sop;
    axiseg_ing_reg_tuser_eop <= axiseg_ing_tuser_eop;
    axiseg_ing_reg_tuser_err <= axiseg_ing_tuser_err;
    axiseg_ing_reg_tuser_mty <= axiseg_ing_tuser_mty;
end


//****************************************************************
//  Ingress FIFO
//****************************************************************

assign  ingfifo_wdata = { axiseg_ing_reg_tdata, axiseg_ing_reg_tuser_mty, axiseg_ing_reg_tuser_ena, axiseg_ing_reg_tuser_sop,
                            axiseg_ing_reg_tuser_eop, axiseg_ing_reg_tuser_err, axiseg_ing_reg_tid };
assign  ingfifo_wen   = axiseg_ing_reg_valid;

xpm_fifo_async #(
    .CASCADE_HEIGHT       ( 0                     ),
    .CDC_SYNC_STAGES      ( 2                     ),
    .DOUT_RESET_VALUE     ( "0"                   ),
    .ECC_MODE             ( "no_ecc"              ),
    .FIFO_MEMORY_TYPE     ( "block"               ),
    .FIFO_READ_LATENCY    ( 1                     ),
    .FIFO_WRITE_DEPTH     ( ING_FIFO_D            ),
    .FULL_RESET_VALUE     ( 0                     ),
    .PROG_EMPTY_THRESH    ( 10                    ),
    .PROG_FULL_THRESH     ( 10                    ),
    .RD_DATA_COUNT_WIDTH  ( $clog2(ING_FIFO_D)+1  ),
    .READ_DATA_WIDTH      ( ING_FIFO_W            ),
    .READ_MODE            ( "std"                 ),
    .RELATED_CLOCKS       ( 0                     ),
    .SIM_ASSERT_CHK       ( 0                     ),
    .USE_ADV_FEATURES     ( "1404"                ),
    .WAKEUP_TIME          ( 0                     ),
    .WRITE_DATA_WIDTH     ( ING_FIFO_W            ),
    .WR_DATA_COUNT_WIDTH  ( $clog2(ING_FIFO_D)+1  ) 
) ing_fifo (
    .wr_clk         ( s_aclk             ),   //         input
    .rst            ( ~local_s_rstn      ),   // wr_clk  input
    .wr_en          ( ingfifo_wen        ),   // wr_clk  input
    .din            ( ingfifo_wdata      ),   // wr_clk  input [WRITE_DATA_WIDTH-1:0]
    .full           ( ingfifo_wfull      ),   // wr_clk  output
    .overflow       (                    ),   // wr_clk  output
    .prog_full      (                    ),   // wr_clk  output
    .wr_data_count  (                    ),   // wr_clk  output [WR_DATA_COUNT_WIDTH-1:0]
    .almost_full    (                    ),   // wr_clk  output
    .wr_ack         (                    ),   // wr_clk  output
    .wr_rst_busy    ( ingfifo_wrst_busy  ),   // wr_clk  output
    .injectdbiterr  ( 1'b0               ),   // wr_clk  input
    .injectsbiterr  ( 1'b0               ),   // wr_clk  input
    .dbiterr        (                    ),   // rd_clk  output
    .sbiterr        (                    ),   // rd_clk  output
    .rd_clk         ( m_aclk             ),   //         input
    .rd_en          ( ingfifo_ren        ),   // rd_clk  input
    .dout           ( ingfifo_rdata      ),   // rd_clk  output [READ_DATA_WIDTH-1:0]
    .empty          ( ingfifo_rempty     ),   // rd_clk  output
    .underflow      (                    ),   // rd_clk  output
    .prog_empty     (                    ),   // rd_clk  output
    .rd_data_count  ( ingfifo_rcnt       ),   // rd_clk  output [WR_DATA_COUNT_WIDTH-1:0]
    .almost_empty   (                    ),   // rd_clk  output
    .data_valid     ( ingfifo_rvalid     ),   // rd_clk  output
    .rd_rst_busy    (                    ),   // rd_clk  output
    .sleep          ( 1'b0               )    // rd_clk  input
);

always_ff @ (posedge m_aclk)
    ingfifo_min_fill <= (ingfifo_rcnt<MIN_FIFO_FILL) ? 1'b0 : 1'b1;

always_ff @ (posedge m_aclk) begin
    if (local_m_rstn==0) begin
        ingfifo_min_fill_reached <= 1'b0;
    end else begin
        // start draining buffers only once buffer has reached minimum threshold fill
        if (ingfifo_min_fill) begin
            ingfifo_min_fill_reached <= 1'b1;
        end
    end
end


// overflow reporting
always_ff @ (posedge s_aclk)
    err_overflow_ing <= (ingfifo_wen & (ingfifo_wfull | ingfifo_wrst_busy)) ? 4'hF : 4'h0;

// read control, OK to read an empty FIFO
always_ff @ (posedge m_aclk) begin
    egrfifo_wpfull_reg <= |egrfifo_wpfull;
    ingfifo_ren <= ~egrfifo_wpfull_reg & ingfifo_min_fill_reached;
end


//****************************************************************
//  Pipeline stages
//****************************************************************

always_ff @ (posedge m_aclk) begin
    pipeline_data[0] <= { ingfifo_rvalid, ingfifo_rdata };
    for (int i=1; i<PIPELINE_STAGES; i++) begin
        pipeline_data[i] <= pipeline_data[i-1];
    end
    // split back into original fields
    { pipe_valid, pipe_tdata, pipe_tuser_mty, pipe_tuser_ena, pipe_tuser_sop,
            pipe_tuser_eop, pipe_tuser_err, pipe_tid } <= pipeline_data[PIPELINE_STAGES-1];
end



//****************************************************************
//  Egress FIFO
//****************************************************************

always_ff @ (posedge m_aclk) begin
    if (pipe_valid)
        tag <= tag + 1'b1;
end

generate
    for (genvar ch=0; ch<NUM_EGR_FIFOS; ch++) begin : gen_egr

        // egress FIFO
        logic [EGR_FIFO_W-1:0]        egrfifo_wdata;
        logic                         egrfifo_wen, egrfifo_wfull, egrfifo_wrst_busy;
        logic [EGR_FIFO_W-1:0]        egrfifo_rdata;
        logic                         egrfifo_ren, egrfifo_rvalid, egrfifo_rempty;
        logic [$clog2(EGR_FIFO_D):0]  egrfifo_rcnt;

        logic [NUM_SEG_PER_FIFO-1:0]  axiseg_egr_tuser_ena_raw;


        assign  egrfifo_wdata = { pipe_tdata[ch*NUM_SEG_PER_FIFO*SEG_DW+:NUM_SEG_PER_FIFO*SEG_DW],
                                  pipe_tuser_mty[ch*NUM_SEG_PER_FIFO*SEG_MTYW+:NUM_SEG_PER_FIFO*SEG_MTYW],
                                  pipe_tuser_ena[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                                  pipe_tuser_sop[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                                  pipe_tuser_eop[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                                  pipe_tuser_err[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                                  pipe_tid,
                                  tag };

        assign  egrfifo_wen = pipe_valid;


        xpm_fifo_sync #(
            .DOUT_RESET_VALUE     ( "0"                  ),
            .ECC_MODE             ( "no_ecc"             ),
            .FIFO_MEMORY_TYPE     ( "auto"               ),
            .FIFO_READ_LATENCY    ( 0                    ),
            .FIFO_WRITE_DEPTH     ( EGR_FIFO_D           ),
            .FULL_RESET_VALUE     ( 0                    ),
            .PROG_EMPTY_THRESH    ( 10                   ),
            .PROG_FULL_THRESH     ( 10                   ),
            .RD_DATA_COUNT_WIDTH  ( $clog2(EGR_FIFO_D)+1 ),
            .READ_DATA_WIDTH      ( EGR_FIFO_W           ),
            .READ_MODE            ( "fwft"               ),
            .SIM_ASSERT_CHK       ( 0                    ),
            .USE_ADV_FEATURES     ( "1404"               ),
            .WAKEUP_TIME          ( 0                    ),
            .WRITE_DATA_WIDTH     ( EGR_FIFO_W           ),
            .WR_DATA_COUNT_WIDTH  ( $clog2(EGR_FIFO_D)+1 ) 
        ) egr_fifo (
            .wr_clk         ( m_aclk             ),   // input
            .rst            ( ~local_m_rstn      ),   // input
            .wr_en          ( egrfifo_wen        ),   // input
            .din            ( egrfifo_wdata      ),   // input [WRITE_DATA_WIDTH-1:0]
            .full           ( egrfifo_wfull      ),   // output
            .overflow       (                    ),   // output
            .prog_full      ( egrfifo_wpfull[ch] ),   // output
            .wr_data_count  (                    ),   // output [WR_DATA_COUNT_WIDTH-1:0]
            .almost_full    (                    ),   // output
            .wr_ack         (                    ),   // output
            .wr_rst_busy    ( egrfifo_wrst_busy  ),   // output
            .injectdbiterr  ( 1'b0               ),   // input
            .injectsbiterr  ( 1'b0               ),   // input
            .dbiterr        (                    ),   // output
            .sbiterr        (                    ),   // output
            .rd_en          ( egrfifo_ren        ),   // input
            .dout           ( egrfifo_rdata      ),   // output [READ_DATA_WIDTH-1:0]
            .empty          ( egrfifo_rempty     ),   // output
            .underflow      (                    ),   // output
            .prog_empty     (                    ),   // output
            .rd_data_count  ( egrfifo_rcnt       ),   // output [WR_DATA_COUNT_WIDTH-1:0]
            .almost_empty   (                    ),   // output
            .data_valid     ( egrfifo_rvalid     ),   // output
            .rd_rst_busy    (                    ),   // output
            .sleep          ( 1'b0               )    // input
        );


        assign egrfifo_ren = egrfifo_rvalid & axiseg_ready_out[ch];

        // map almost everything directly to the output port
        assign { axiseg_egr_tdata[ch*NUM_SEG_PER_FIFO*SEG_DW+:NUM_SEG_PER_FIFO*SEG_DW],
                 axiseg_egr_tuser_mty[ch*NUM_SEG_PER_FIFO*SEG_MTYW+:NUM_SEG_PER_FIFO*SEG_MTYW] ,
                 axiseg_egr_tuser_ena_raw,
                 axiseg_egr_tuser_sop[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                 axiseg_egr_tuser_eop[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                 axiseg_egr_tuser_err[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO],
                 axiseg_egr_tid_raw[ch],
                 axiseg_egr_tag_raw[ch] } = egrfifo_rdata;

        assign axiseg_valid_out[ch] = egrfifo_rvalid;

        // zero out ena when valid deasserted
        assign axiseg_egr_tuser_ena[ch*NUM_SEG_PER_FIFO+:NUM_SEG_PER_FIFO] = 
            (egrfifo_rvalid) ? axiseg_egr_tuser_ena_raw : 'h0;

    end
endgenerate

assign axiseg_tid_out = axiseg_egr_tid_raw[0];


//****************************************************************
//  Error checking
//****************************************************************

always_ff @ (posedge m_aclk) begin
    if (local_m_rstn==0) begin
        xfer_tag_err_vec    <= 'h0;
        err_alignment_egr   <= 1'b0;
    end else begin
        for (int i=0; i<NUM_EGR_FIFOS-1; i++) begin
            xfer_tag_err_vec[i]    <= (axiseg_egr_tag_raw[i]!=axiseg_egr_tag_raw[i+1]);
        end
        err_alignment_egr <= |xfer_tag_err_vec;
    end
end


endmodule



