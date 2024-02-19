//--------------------------------------------------------------------------------------
//
// Copyright(C) 2023 Advanced Micro Devices, Inc. All rights reserved.
//
// This document contains proprietary, confidential information that
// may be used, copied and/or disclosed only as authorized by a
// valid licensing agreement with Advanced Micro Devices, Inc. This copyright
// notice must be retained on all authorized copies.
//
// This code is provided "as is". Advanced Micro Devices, Inc. makes, and
// the end user receives, no warranties or conditions, express,
// implied, statutory or otherwise, and Advanced Micro Devices, Inc.
// specifically disclaims any implied warranties of merchantability,
// non-infringement, or fitness for a particular purpose.
//
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Description   : Converts standard AXIS to 2 segmented AXIS, N instantiations
//                 Ensure synchronization logic across all output segments
//                 Custom TKEEP handling & TDEST/TID usage
//--------------------------------------------------------------------------------------

// Module declaration
module axis_1x_axis_to_2x_seg #(
    parameter integer NUM_NOC_CH         = 2,
    parameter integer NUM_SEG_PER_NOC    = 2,             // fixed
    parameter integer NUM_SEG_CH         = NUM_SEG_PER_NOC*NUM_NOC_CH,
    parameter integer ING_TID_W          = 6,             // fixed
    parameter integer ING_TDEST_W        = 7,             // fixed
    parameter integer EGR_TID_W          = 3,             // fixed
    parameter integer EGR_DW             = 128,           // fixed
    parameter integer ING_DW             = EGR_DW*NUM_SEG_PER_NOC,
    parameter integer EGR_MTYW           = $clog2(EGR_DW/8),
    parameter integer ING_MTYW           = EGR_MTYW*NUM_SEG_PER_NOC,
    parameter integer EGR_KW             = EGR_DW/8,
    parameter integer ING_KW             = ING_DW/8,
    parameter logic   ADD_ING_AXIS_REG   = 0,
    parameter logic   ADD_EGR_AXIS_REG   = 0
) (
    input  wire                               aclk,
    input  wire                               arstn,
    output wire [NUM_NOC_CH-1:0]              axis_ing_tready,
    input  wire [NUM_NOC_CH-1:0]              axis_ing_tvalid,
    input  wire [NUM_NOC_CH*ING_DW-1:0]       axis_ing_tdata,
    input  wire [NUM_NOC_CH-1:0]              axis_ing_tlast,
    input  wire [NUM_NOC_CH*ING_KW-1:0]       axis_ing_tkeep,
    input  wire [NUM_NOC_CH*ING_TID_W-1:0]    axis_ing_tid,
    input  wire [NUM_NOC_CH*ING_TDEST_W-1:0]  axis_ing_tdest,
    input  wire [NUM_NOC_CH-1:0]              axiseg_egr_ready,
    output wire [NUM_NOC_CH-1:0]              axiseg_egr_valid,
    output wire [NUM_SEG_CH*EGR_DW-1:0]       axiseg_egr_tdata,
    output wire [NUM_SEG_CH-1:0]              axiseg_egr_tuser_ena,
    output wire [NUM_SEG_CH-1:0]              axiseg_egr_tuser_sop,
    output wire [NUM_SEG_CH-1:0]              axiseg_egr_tuser_eop,
    output wire [NUM_SEG_CH-1:0]              axiseg_egr_tuser_err,
    output wire [NUM_SEG_CH*EGR_MTYW-1:0]     axiseg_egr_tuser_mty,
    output wire [EGR_TID_W-1:0]               axiseg_egr_tid,
    output wire                               err_alignment
);


//****************************************************************
//  Parameters & functions
//****************************************************************

localparam integer CH_FIFO_W = ING_DW+ING_KW+ING_TID_W+ING_TDEST_W;
localparam integer CH_FIFO_D = 64;
localparam integer ID_W = ING_TID_W - 2*NUM_SEG_PER_NOC;

localparam integer MIN_FIFO_FILL = CH_FIFO_D/4;


localparam integer CH_FIFO_EGR_W = ING_DW+(EGR_MTYW*NUM_SEG_PER_NOC)+NUM_SEG_PER_NOC+ING_TID_W+ING_TDEST_W;
localparam integer CH_FIFO_EGR_D = 64;

// function to convert TKEEP to MTY
function logic [EGR_MTYW-1:0] fGetMTY (
    input logic [EGR_KW-1:0] tkeep );
    logic [EGR_MTYW-1:0] mty;
    mty = 0;
    for (int i=1; i<EGR_KW; i++) begin
        if ((tkeep[EGR_KW-i]==1'b0) && (tkeep[EGR_KW-1-i]==1'b1))
            mty = i;
    end
    fGetMTY = mty;
endfunction


//****************************************************************
//  Signal Declarations
//****************************************************************

// synchronization of buffers
logic [NUM_NOC_CH-1:0] axis_ch_buf_tvalid;
logic [NUM_NOC_CH-1:0] axis_ch_buf_min_fill;
logic [NUM_NOC_CH-1:0] chfifo_egr_progfull_all;
logic                  axis_ch_buf_alignment_ready;
logic                  axiseg_fiforead_ready;

// local reset
logic                  local_rstn;

// ID handling
logic  [ID_W-1:0]        xfer_id_reg [NUM_NOC_CH-1:0] = '{default:0};
logic  [NUM_NOC_CH-2:0]  xfer_id_err_vec;
logic                    xfer_id_err;
logic  [NUM_NOC_CH-1:0]  xfer_id_ch_err = 0;
logic                    xfer_id_ch_err_reg;
logic  [EGR_TID_W-1:0]   axiseg_tid_reg [NUM_NOC_CH-1:0] = '{default:0};
logic  [NUM_NOC_CH-2:0]  axiseg_tid_err_vec;

// output register
logic  [NUM_SEG_CH*EGR_DW-1:0]       axiseg_ch_tdata;
logic  [NUM_SEG_CH-1:0]              axiseg_ch_tuser_ena;
logic  [NUM_SEG_CH-1:0]              axiseg_ch_tuser_sop;
logic  [NUM_SEG_CH-1:0]              axiseg_ch_tuser_eop;
logic  [NUM_SEG_CH-1:0]              axiseg_ch_tuser_err;
logic  [NUM_SEG_CH*EGR_MTYW-1:0]     axiseg_ch_tuser_mty;


//****************************************************************
//  Local reset
//****************************************************************

// limits fanout, allows input reset to be async to clock
xpm_cdc_single #(
    .DEST_SYNC_FF   ( 4 ),  
    .INIT_SYNC_FF   ( 0 ),  
    .SIM_ASSERT_CHK ( 0 ),
    .SRC_INPUT_REG  ( 0 )  
) rstn_sync (
    .dest_out       ( local_rstn ),
    .dest_clk       ( aclk       ),
    .src_in         ( arstn      ) 
);


//*************************************************************************************************
//  Input channel buffering
//    Use registers on either side of FIFO for timing closure
//*************************************************************************************************

generate
    for (genvar ch=0; ch<NUM_NOC_CH; ch++) begin : gen_ch
   
        logic                        axis_ch_tready;
        logic                        axis_ch_tvalid;
        logic [ING_DW-1:0]           axis_ch_tdata;
        logic                        axis_ch_tlast;
        logic [ING_KW-1:0]           axis_ch_tkeep;
        logic [ING_TID_W-1:0]        axis_ch_tid;
        logic [ING_TDEST_W-1:0]      axis_ch_tdest;
        logic                        axis_chreg_tready;
        logic                        axis_chreg_tvalid;
        logic [ING_DW-1:0]           axis_chreg_tdata;
        logic                        axis_chreg_tlast;
        logic [ING_KW-1:0]           axis_chreg_tkeep;
        logic [ING_TID_W-1:0]        axis_chreg_tid;
        logic [ING_TDEST_W-1:0]      axis_chreg_tdest;
        logic                        axis_chfifo_tready;
        logic                        axis_chfifo_tvalid;
        logic [ING_DW-1:0]           axis_chfifo_tdata;
        logic [ING_KW-1:0]           axis_chfifo_tkeep;
        logic [ING_TID_W-1:0]        axis_chfifo_tid;
        logic [ING_TDEST_W-1:0]      axis_chfifo_tdest;
        logic                        axis_chfiforeg_tready;
        logic                        axis_chfiforeg_tvalid;
        logic [ING_DW-1:0]           axis_chfiforeg_tdata;
        logic [ING_KW-1:0]           axis_chfiforeg_tkeep;
        logic [ING_TID_W-1:0]        axis_chfiforeg_tid;
        logic [ING_TDEST_W-1:0]      axis_chfiforeg_tdest;
        logic [ING_MTYW-1:0]         axis_chfiforeg_mty;
        logic [NUM_SEG_PER_NOC-1:0]  axis_chfiforeg_ena;

        // ingress FIFO
        logic [CH_FIFO_W-1:0]         chfifo_wdata;
        logic                         chfifo_wen, chfifo_wfull;
        logic [CH_FIFO_W-1:0]         chfifo_rdata;
        logic                         chfifo_ren, chfifo_rvalid, chfifo_rempty, chfifo_rrst_busy;
        logic [$clog2(CH_FIFO_D):0]   chfifo_rcnt;

        logic [NUM_SEG_PER_NOC-1:0] axiseg_sop_buf;
        logic [NUM_SEG_PER_NOC-1:0] axiseg_eop_buf;
        logic [NUM_SEG_PER_NOC-1:0] axiseg_err_buf;
        logic [ID_W-1:0]            xfer_id_buf;
        logic [ID_W-1:0]            xfer_alt_id_buf;
        logic [EGR_TID_W-1:0]       axiseg_tid_buf;



        // egress FIFO
        logic [CH_FIFO_EGR_W-1:0]         chfifo_egr_wdata;
        logic                             chfifo_egr_wen, chfifo_egr_wfull, chfifo_egr_progfull;
        logic [CH_FIFO_EGR_W-1:0]         chfifo_egr_rdata;
        logic                             chfifo_egr_ren, chfifo_egr_rvalid, chfifo_egr_rempty, chfifo_egr_rrst_busy, chfifo_egr_ready;
        logic [$clog2(CH_FIFO_EGR_D):0]   chfifo_egr_rcnt;

        logic                        axis_chfifoegr_tready;
        logic                        axis_chfifoegr_tvalid;
        logic [ING_DW-1:0]           axis_chfifoegr_tdata;
        logic [ING_MTYW-1:0]         axis_chfifoegr_mty;
        logic [NUM_SEG_PER_NOC-1:0]  axis_chfifoegr_ena;
        logic [ING_TID_W-1:0]        axis_chfifoegr_tid;
        logic [ING_TDEST_W-1:0]      axis_chfifoegr_tdest;




        // remap array slice to loop signals
        assign  axis_ing_tready[ch]  = axis_ch_tready;

        assign  axis_ch_tvalid = axis_ing_tvalid[ch];
        assign  axis_ch_tdata  = axis_ing_tdata[ING_DW*ch+:ING_DW];
        assign  axis_ch_tkeep  = axis_ing_tkeep[ING_KW*ch+:ING_KW];
        assign  axis_ch_tlast  = axis_ing_tlast[ch];
        assign  axis_ch_tid    = axis_ing_tid[ING_TID_W*ch+:ING_TID_W];
        assign  axis_ch_tdest  = axis_ing_tdest[ING_TDEST_W*ch+:ING_TDEST_W];

        // nested generate
        if (ADD_ING_AXIS_REG==0) begin : ing_comb_gen
            assign  axis_chreg_tdata   = axis_ch_tdata ;
            assign  axis_chreg_tkeep   = axis_ch_tkeep ;
            assign  axis_chreg_tlast   = axis_ch_tlast ;
            assign  axis_chreg_tvalid  = axis_ch_tvalid;
            assign  axis_chreg_tid     = axis_ch_tid   ;
            assign  axis_chreg_tdest   = axis_ch_tdest ;
            assign  axis_ch_tready  = axis_chreg_tready;
        end else begin : ing_reg_gen
            axis_register_slice_noc_ch ch_reg (
                .aclk           ( aclk                   ),  // input
                .aresetn        ( local_rstn             ),  // input
                .s_axis_tvalid  ( axis_ch_tvalid         ),  // input
                .s_axis_tready  ( axis_ch_tready         ),  // output
                .s_axis_tdata   ( axis_ch_tdata          ),  // input  [DATA_WIDTH-1:0]
                .s_axis_tkeep   ( axis_ch_tkeep          ),  // input  [DATA_WIDTH/8-1:0]
                .s_axis_tlast   ( axis_ch_tlast          ),  // input
                .s_axis_tid     ( axis_ch_tid            ),  // input  [USER_WIDTH-1:0]
                .s_axis_tdest   ( axis_ch_tdest          ),  // input  [DEST_WIDTH-1:0]
                .m_axis_tvalid  ( axis_chreg_tvalid      ),  // output
                .m_axis_tready  ( axis_chreg_tready      ),  // input
                .m_axis_tdata   ( axis_chreg_tdata       ),  // output [DATA_WIDTH-1:0]
                .m_axis_tkeep   ( axis_chreg_tkeep       ),  // output [DATA_WIDTH/8-1:0]
                .m_axis_tlast   ( axis_chreg_tlast       ),  // output
                .m_axis_tid     ( axis_chreg_tid         ),  // output [USER_WIDTH-1:0]
                .m_axis_tdest   ( axis_chreg_tdest       )   // output [DEST_WIDTH-1:0]
            );
        end
        // nested endgenerate

        // FIFO input signals
        assign  axis_chreg_tready = ~chfifo_wfull & ~chfifo_rrst_busy;
        assign  chfifo_wdata = { axis_chreg_tdata, axis_chreg_tkeep, axis_chreg_tid, axis_ch_tdest };
        assign  chfifo_wen   = axis_chreg_tvalid & axis_chreg_tready;

        xpm_fifo_sync #(
            .DOUT_RESET_VALUE     ( "0"                 ),
            .ECC_MODE             ( "no_ecc"            ),
            .FIFO_MEMORY_TYPE     ( "auto"              ),
            .FIFO_READ_LATENCY    ( 0                   ),
            .FIFO_WRITE_DEPTH     ( CH_FIFO_D           ),
            .FULL_RESET_VALUE     ( 0                   ),
            .PROG_EMPTY_THRESH    ( 10                  ),
            .PROG_FULL_THRESH     ( 10                  ),
            .RD_DATA_COUNT_WIDTH  ( $clog2(CH_FIFO_D)+1 ),
            .READ_DATA_WIDTH      ( CH_FIFO_W           ),
            .READ_MODE            ( "fwft"              ),
            .SIM_ASSERT_CHK       ( 0                   ),
            .USE_ADV_FEATURES     ( "1404"              ),
            .WAKEUP_TIME          ( 0                   ),
            .WRITE_DATA_WIDTH     ( CH_FIFO_W           ),
            .WR_DATA_COUNT_WIDTH  ( $clog2(CH_FIFO_D)+1 ) 
        ) ch_fifo (
            .wr_clk         ( aclk              ),   // input
            .rst            ( ~local_rstn       ),   // input
            .wr_en          ( chfifo_wen        ),   // input
            .din            ( chfifo_wdata      ),   // input [WRITE_DATA_WIDTH-1:0]
            .full           ( chfifo_wfull      ),   // output
            .overflow       (                   ),   // output
            .prog_full      (                   ),   // output
            .wr_data_count  (                   ),   // output [WR_DATA_COUNT_WIDTH-1:0]
            .almost_full    (                   ),   // output
            .wr_ack         (                   ),   // output
            .wr_rst_busy    (                   ),   // output
            .injectdbiterr  ( 1'b0              ),   // input
            .injectsbiterr  ( 1'b0              ),   // input
            .dbiterr        (                   ),   // output
            .sbiterr        (                   ),   // output
            .rd_en          ( chfifo_ren        ),   // input
            .dout           ( chfifo_rdata      ),   // output [READ_DATA_WIDTH-1:0]
            .empty          ( chfifo_rempty     ),   // output
            .underflow      (                   ),   // output
            .prog_empty     (                   ),   // output
            .rd_data_count  ( chfifo_rcnt       ),   // output [WR_DATA_COUNT_WIDTH-1:0]
            .almost_empty   (                   ),   // output
            .data_valid     ( chfifo_rvalid     ),   // output
            .rd_rst_busy    ( chfifo_rrst_busy  ),   // output
            .sleep          ( 1'b0              )    // input
        );

        always @ (posedge aclk)
            axis_ch_buf_min_fill[ch] <= (chfifo_rcnt<MIN_FIFO_FILL) ? 1'b0 : 1'b1;

        // FIFO output signals
        assign  chfifo_ren = axis_chfifo_tvalid & axis_chfifo_tready;
        assign  axis_chfifo_tvalid = chfifo_rvalid;
        assign  { axis_chfifo_tdata, axis_chfifo_tkeep, axis_chfifo_tid, axis_chfifo_tdest } = chfifo_rdata;

        // nested generate
        if (ADD_EGR_AXIS_REG==0) begin : egr_comb_gen
            assign  axis_chfiforeg_tdata   = axis_chfifo_tdata ;
            assign  axis_chfiforeg_tkeep   = axis_chfifo_tkeep ;
            assign  axis_chfiforeg_tvalid  = axis_chfifo_tvalid;
            assign  axis_chfiforeg_tid     = axis_chfifo_tid   ;
            assign  axis_chfiforeg_tdest   = axis_chfifo_tdest ;
            assign  axis_chfifo_tready  = axis_chfiforeg_tready;
        end else begin : egr_reg_gen
            axis_register_slice_noc_ch ch_fiforeg (
                .aclk           ( aclk                   ),  // input
                .aresetn        ( local_rstn             ),  // input
                .s_axis_tvalid  ( axis_chfifo_tvalid     ),  // input
                .s_axis_tready  ( axis_chfifo_tready     ),  // output
                .s_axis_tdata   ( axis_chfifo_tdata      ),  // input  [DATA_WIDTH-1:0]
                .s_axis_tkeep   ( axis_chfifo_tkeep      ),  // input  [DATA_WIDTH/8-1:0]
                .s_axis_tlast   ( 1'b0                   ),  // input
                .s_axis_tid     ( axis_chfifo_tid        ),  // input  [USER_WIDTH-1:0]
                .s_axis_tdest   ( axis_chfifo_tdest      ),  // input  [DEST_WIDTH-1:0]
                .m_axis_tvalid  ( axis_chfiforeg_tvalid  ),  // output
                .m_axis_tready  ( axis_chfiforeg_tready  ),  // input
                .m_axis_tdata   ( axis_chfiforeg_tdata   ),  // output [DATA_WIDTH-1:0]
                .m_axis_tkeep   ( axis_chfiforeg_tkeep   ),  // output [DATA_WIDTH/8-1:0]
                .m_axis_tlast   (                        ),  // output
                .m_axis_tid     ( axis_chfiforeg_tid     ),  // output [USER_WIDTH-1:0]
                .m_axis_tdest   ( axis_chfiforeg_tdest   )   // output [DEST_WIDTH-1:0]
            );
        end
        // nested endgenerate


        assign axis_ch_buf_tvalid[ch] = axis_chfiforeg_tvalid;
        
        // backpressure propagation
        always @ (posedge aclk) begin
            chfifo_egr_progfull_all[ch] <= chfifo_egr_progfull;
            chfifo_egr_ready <= ~(|chfifo_egr_progfull_all);  // downstream not ready until all egress FIFOs have room
            axis_chfiforeg_tready <= axiseg_fiforead_ready & (&axis_ch_buf_tvalid) & chfifo_egr_ready;
        end

        always_comb begin
            // loop through all segments tied to a NoC channel, remap array slice
            for (int seg=0; seg<NUM_SEG_PER_NOC; seg++) begin
                axis_chfiforeg_mty[seg*EGR_MTYW+:EGR_MTYW]  = fGetMTY(axis_chfiforeg_tkeep[seg*EGR_KW+:EGR_KW]);
                axis_chfiforeg_ena[seg]  = axis_chfiforeg_tkeep[seg*EGR_KW+:1];
            end
        end

        // register outputs between FIFOs
        always @ (posedge aclk) begin
            chfifo_egr_wdata <= { axis_chfiforeg_tdata, axis_chfiforeg_mty, axis_chfiforeg_ena, axis_chfiforeg_tid, axis_chfiforeg_tdest };
            chfifo_egr_wen   <= axis_chfiforeg_tvalid & axis_chfiforeg_tready;
        end




        xpm_fifo_sync #(
            .DOUT_RESET_VALUE     ( "0"                     ),
            .ECC_MODE             ( "no_ecc"                ),
            .FIFO_MEMORY_TYPE     ( "auto"                  ),
            .FIFO_READ_LATENCY    ( 0                       ),
            .FIFO_WRITE_DEPTH     ( CH_FIFO_EGR_D           ),
            .FULL_RESET_VALUE     ( 0                       ),
            .PROG_EMPTY_THRESH    ( 10                      ),
            .PROG_FULL_THRESH     ( CH_FIFO_EGR_D-8         ),
            .RD_DATA_COUNT_WIDTH  ( $clog2(CH_FIFO_EGR_D)+1 ),
            .READ_DATA_WIDTH      ( CH_FIFO_EGR_W           ),
            .READ_MODE            ( "fwft"                  ),
            .SIM_ASSERT_CHK       ( 0                       ),
            .USE_ADV_FEATURES     ( "1406"                  ),
            .WAKEUP_TIME          ( 0                       ),
            .WRITE_DATA_WIDTH     ( CH_FIFO_EGR_W           ),
            .WR_DATA_COUNT_WIDTH  ( $clog2(CH_FIFO_EGR_D)+1 ) 
        ) ch_fifo_egr (
            .wr_clk         ( aclk                  ),   // input
            .rst            ( ~local_rstn           ),   // input
            .wr_en          ( chfifo_egr_wen        ),   // input
            .din            ( chfifo_egr_wdata      ),   // input [WRITE_DATA_WIDTH-1:0]
            .full           ( chfifo_egr_wfull      ),   // output
            .overflow       (                       ),   // output
            .prog_full      ( chfifo_egr_progfull   ),   // output
            .wr_data_count  (                       ),   // output [WR_DATA_COUNT_WIDTH-1:0]
            .almost_full    (                       ),   // output
            .wr_ack         (                       ),   // output
            .wr_rst_busy    (                       ),   // output
            .injectdbiterr  ( 1'b0                  ),   // input
            .injectsbiterr  ( 1'b0                  ),   // input
            .dbiterr        (                       ),   // output
            .sbiterr        (                       ),   // output
            .rd_en          ( chfifo_egr_ren        ),   // input
            .dout           ( chfifo_egr_rdata      ),   // output [READ_DATA_WIDTH-1:0]
            .empty          ( chfifo_egr_rempty     ),   // output
            .underflow      (                       ),   // output
            .prog_empty     (                       ),   // output
            .rd_data_count  ( chfifo_egr_rcnt       ),   // output [WR_DATA_COUNT_WIDTH-1:0]
            .almost_empty   (                       ),   // output
            .data_valid     ( chfifo_egr_rvalid     ),   // output
            .rd_rst_busy    ( chfifo_egr_rrst_busy  ),   // output
            .sleep          ( 1'b0                  )    // input
        );

        assign  axis_chfifoegr_tvalid = chfifo_egr_rvalid;
        assign  axiseg_egr_valid[ch]  = chfifo_egr_rvalid;
        assign  axis_chfifoegr_tready = axiseg_egr_ready[ch];
        assign  chfifo_egr_ren = axis_chfifoegr_tvalid & axis_chfifoegr_tready;

        assign { axis_chfifoegr_tdata, axis_chfifoegr_mty, axis_chfifoegr_ena, axis_chfifoegr_tid, axis_chfifoegr_tdest } = chfifo_egr_rdata;


        // these assigns match packing upstream
        assign { xfer_id_buf, axiseg_sop_buf, axiseg_eop_buf }     = axis_chfifoegr_tid;
        assign { xfer_alt_id_buf, axiseg_tid_buf, axiseg_err_buf } = axis_chfifoegr_tdest;

        always_comb begin
            // loop through all segments tied to a NoC channel, remap array slice
            for (int seg=0; seg<NUM_SEG_PER_NOC; seg++) begin
                axiseg_ch_tdata[(ch*NUM_SEG_PER_NOC+seg)*EGR_DW+:EGR_DW]          = axis_chfifoegr_tdata[seg*EGR_DW+:EGR_DW];
                axiseg_ch_tuser_sop[ch*NUM_SEG_PER_NOC+seg]                       = axiseg_sop_buf[seg];
                axiseg_ch_tuser_eop[ch*NUM_SEG_PER_NOC+seg]                       = axiseg_eop_buf[seg];
                axiseg_ch_tuser_err[ch*NUM_SEG_PER_NOC+seg]                       = axiseg_err_buf[seg];
                axiseg_ch_tuser_mty[(ch*NUM_SEG_PER_NOC+seg)*EGR_MTYW+:EGR_MTYW]  = axis_chfifoegr_mty[seg*EGR_MTYW+:EGR_MTYW];
                if (axis_chfifoegr_tvalid)
                    axiseg_ch_tuser_ena[ch*NUM_SEG_PER_NOC+seg]  = axis_chfifoegr_ena[seg];
                else
                    axiseg_ch_tuser_ena[ch*NUM_SEG_PER_NOC+seg]  = 1'b0;
            end
            xfer_id_reg[ch]     = xfer_id_buf;
            xfer_id_ch_err[ch]  = (xfer_alt_id_buf==xfer_id_buf) ? 1'b0 : 1'b1;
            axiseg_tid_reg[ch]  = axiseg_tid_buf;
        end

    end
endgenerate


//****************************************************************
//  Ensure initial alignment of channels
//****************************************************************

always @ (posedge aclk) begin
    if ((local_rstn==0) || (axis_ch_buf_tvalid==0)) begin
        axis_ch_buf_alignment_ready <= 1'b0;
        axiseg_fiforead_ready <= 1'b0;
    end else begin
        // start draining buffers only once all buffers have reached minimum threshold fill
        if (&axis_ch_buf_min_fill) begin
            axis_ch_buf_alignment_ready <= 1'b1;
        end
        axiseg_fiforead_ready <= axis_ch_buf_alignment_ready;
    end
end


//****************************************************************
//  Alignment check & error reporting
//****************************************************************

always @ (posedge aclk) begin
    if (local_rstn==0) begin
        xfer_id_err        <= 1'b0;
        xfer_id_err_vec    <= 'h0;
        axiseg_tid_err_vec <= 'h0;
        xfer_id_ch_err_reg <= 'h0;
    end else begin
        xfer_id_err <= (|xfer_id_err_vec) | (|axiseg_tid_err_vec) | xfer_id_ch_err_reg;
        for (int ch=0; ch<NUM_NOC_CH-1; ch++) begin
            xfer_id_err_vec[ch]    <= (xfer_id_reg[ch]!=xfer_id_reg[ch+1]);
            axiseg_tid_err_vec[ch] <= (axiseg_tid_reg[ch]!=axiseg_tid_reg[ch+1]);
        end
        xfer_id_ch_err_reg <= |xfer_id_ch_err;
    end
end

assign err_alignment = xfer_id_err;


//****************************************************************
//  Output assignment
//****************************************************************

assign axiseg_egr_tdata     = axiseg_ch_tdata;
assign axiseg_egr_tuser_ena = axiseg_ch_tuser_ena;
assign axiseg_egr_tuser_sop = axiseg_ch_tuser_sop;
assign axiseg_egr_tuser_eop = axiseg_ch_tuser_eop;
assign axiseg_egr_tuser_err = axiseg_ch_tuser_err;
assign axiseg_egr_tuser_mty = axiseg_ch_tuser_mty;
assign axiseg_egr_tid       = axiseg_tid_reg[0];


endmodule


