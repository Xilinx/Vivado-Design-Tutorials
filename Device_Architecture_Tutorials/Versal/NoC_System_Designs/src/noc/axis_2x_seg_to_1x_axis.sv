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
// Description   : Shim to convert 2 segmented AXIS to one standard
//                 AXIS using TID to capture SOF & EOF.
//                 Handles N instantiations
//--------------------------------------------------------------------------------------

// Module declaration
module axis_2x_seg_to_1x_axis #(
    parameter integer NUM_NOC_CH         = 2,
    parameter integer NUM_SEG_PER_NOC    = 2,             // fixed
    parameter integer NUM_SEG_CH         = NUM_SEG_PER_NOC*NUM_NOC_CH,
    parameter integer ING_TID_W          = 3,             // fixed
    parameter integer EGR_TID_W          = 6,             // fixed
    parameter integer EGR_TDEST_W        = 7,             // fixed
    parameter integer ING_DW             = 128,           // fixed
    parameter integer EGR_DW             = ING_DW*NUM_SEG_PER_NOC,
    parameter integer ING_MTYW           = $clog2(ING_DW/8),
    parameter integer ING_KW             = ING_DW/8,
    parameter integer EGR_KW             = EGR_DW/8,
    parameter logic   ADD_EGR_AXIS_REG   = 0
) (
    input  wire                              aclk,
    input  wire                              arstn,
    input  wire                              axiseg_ing_valid,
    input  wire [NUM_SEG_CH*ING_DW-1:0]      axiseg_ing_tdata,
    input  wire [NUM_SEG_CH-1:0]             axiseg_ing_tuser_ena,
    input  wire [NUM_SEG_CH-1:0]             axiseg_ing_tuser_sop,
    input  wire [NUM_SEG_CH-1:0]             axiseg_ing_tuser_eop,
    input  wire [NUM_SEG_CH-1:0]             axiseg_ing_tuser_err,
    input  wire [NUM_SEG_CH*ING_MTYW-1:0]    axiseg_ing_tuser_mty,
    input  wire [ING_TID_W-1:0]              axiseg_ing_tid,
    input  wire [NUM_NOC_CH-1:0]             axis_egr_tready,
    output wire [NUM_NOC_CH-1:0]             axis_egr_tvalid,
    output wire [NUM_NOC_CH*EGR_DW-1:0]      axis_egr_tdata,
    output wire [NUM_NOC_CH-1:0]             axis_egr_tlast,
    output wire [NUM_NOC_CH*EGR_KW-1:0]      axis_egr_tkeep,
    output wire [NUM_NOC_CH*EGR_TID_W-1:0]   axis_egr_tid,
    output wire [NUM_NOC_CH*EGR_TDEST_W-1:0] axis_egr_tdest,
    output wire [NUM_NOC_CH-1:0]             err_ch_overflow
);


//****************************************************************
//  Parameters
//****************************************************************

localparam integer CH_FIFO_W = EGR_DW+EGR_KW+EGR_TID_W+EGR_TDEST_W;
localparam integer CH_FIFO_D = 64;
localparam integer ID_W = EGR_TID_W - 2*NUM_SEG_PER_NOC;
localparam integer ID_LSBS = 3;  // e.g. if 3, ID tag will update every 2^3=8 beats
localparam integer ID_CNT_W = ID_W + ID_LSBS;


//****************************************************************
//  Signal Declarations
//****************************************************************

logic [ID_CNT_W-1:0] tag;


logic [ING_TID_W-1:0]              axiseg_reg_tid;
logic                              axiseg_reg_valid;
logic [NUM_SEG_CH*ING_DW-1:0]      axiseg_reg_tdata;
logic [NUM_SEG_CH-1:0]             axiseg_reg_tuser_ena;
logic [NUM_SEG_CH-1:0]             axiseg_reg_tuser_sop;
logic [NUM_SEG_CH-1:0]             axiseg_reg_tuser_eop;
logic [NUM_SEG_CH-1:0]             axiseg_reg_tuser_err;
logic [NUM_SEG_CH*ING_MTYW-1:0]    axiseg_reg_tuser_mty;

logic                  local_rstn;
logic [NUM_NOC_CH-1:0] chfifo_overflow;


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


//****************************************************************
//  Register inputs
//****************************************************************

always_ff @ (posedge aclk) begin
    axiseg_reg_tid       <= axiseg_ing_tid;
    axiseg_reg_valid     <= axiseg_ing_valid;
    axiseg_reg_tdata     <= axiseg_ing_tdata;
    axiseg_reg_tuser_ena <= axiseg_ing_tuser_ena;
    axiseg_reg_tuser_sop <= axiseg_ing_tuser_sop;
    axiseg_reg_tuser_eop <= axiseg_ing_tuser_eop;
    axiseg_reg_tuser_err <= axiseg_ing_tuser_err;
    axiseg_reg_tuser_mty <= axiseg_ing_tuser_mty;
end


//****************************************************************
//  TID generation
//    Different ID with every beat to show coherency
//    Only MSBs are passed into TID
//****************************************************************

always_ff @ (posedge aclk) begin
    if (!local_rstn)
        tag <= 'h0;
    else begin
        if (axiseg_reg_valid)
            tag <= tag + 1'b1;
    end
end




generate
    for (genvar ch=0; ch<NUM_NOC_CH; ch++) begin : gen_ch

        // channel reg
        logic [NUM_SEG_PER_NOC*ING_DW-1:0]      axiseg_chreg_tdata;
        logic [NUM_SEG_PER_NOC*ING_KW-1:0]      axiseg_chreg_tkeep;
        logic [NUM_SEG_PER_NOC-1:0]             axiseg_chreg_tuser_sop;
        logic [NUM_SEG_PER_NOC-1:0]             axiseg_chreg_tuser_eop;
        logic [NUM_SEG_PER_NOC-1:0]             axiseg_chreg_tuser_err;
        logic                                   axiseg_chreg_valid;
        logic [ING_TID_W-1:0]                   axiseg_chreg_tid;
        logic [EGR_TID_W-1:0]                   axi_noc_tid;
        logic [EGR_TDEST_W-1:0]                 axi_noc_tdest;

        // channel FIFO
        logic [CH_FIFO_W-1:0]        chfifo_wdata;
        logic                        chfifo_wen, chfifo_wfull;
        logic [CH_FIFO_W-1:0]        chfifo_rdata;
        logic                        chfifo_ren, chfifo_rvalid, chfifo_rempty, chfifo_rrst_busy;
        logic [$clog2(CH_FIFO_D):0]  chfifo_rcnt;

        logic insert_tlast = 0;

        logic [EGR_DW-1:0]          axis_chfifo_tdata;
        logic [EGR_KW-1:0]          axis_chfifo_tkeep;
        logic                       axis_chfifo_tlast;
        logic                       axis_chfifo_tvalid;
        logic                       axis_chfifo_tready;
        logic [EGR_TID_W-1:0]       axis_chfifo_tid;
        logic [EGR_TDEST_W-1:0]     axis_chfifo_tdest;
        logic [EGR_DW-1:0]          axis_chfiforeg_tdata;
        logic [EGR_KW-1:0]          axis_chfiforeg_tkeep;
        logic                       axis_chfiforeg_tlast;
        logic                       axis_chfiforeg_tvalid;
        logic                       axis_chfiforeg_tready;
        logic [EGR_TID_W-1:0]       axis_chfiforeg_tid;
        logic [EGR_TDEST_W-1:0]     axis_chfiforeg_tdest;


        //****************************************************************
        //  Input reg
        //****************************************************************

        always @ (posedge aclk) begin
            // loop through all segments tied to a NoC channel, remap array slice
            for (int seg=0; seg<NUM_SEG_PER_NOC; seg++) begin
                // first reg
                axiseg_chreg_tdata[seg*ING_DW+:ING_DW]  <= axiseg_reg_tdata[(ch*NUM_SEG_PER_NOC+seg)*ING_DW+:ING_DW];
                axiseg_chreg_tuser_sop[seg]             <= axiseg_reg_tuser_sop[ch*NUM_SEG_PER_NOC+seg];
                axiseg_chreg_tuser_eop[seg]             <= axiseg_reg_tuser_eop[ch*NUM_SEG_PER_NOC+seg];
                axiseg_chreg_tuser_err[seg]             <= axiseg_reg_tuser_err[ch*NUM_SEG_PER_NOC+seg];
                // loop through KEEP bits, assign based on MTY and ENA
                // aggregating segments with different KEEP profiles is OK, NoC handles sparse KEEP
                for (int i=0; i<ING_KW; i++)
                    axiseg_chreg_tkeep[seg*ING_KW+i]    <= ((ING_KW-i) > axiseg_reg_tuser_mty[(ch*NUM_SEG_PER_NOC+seg)*ING_MTYW+:ING_MTYW]) ?
                                                                axiseg_reg_tuser_ena[ch*NUM_SEG_PER_NOC+seg] : 1'b0;
            end
            axiseg_chreg_valid  <= axiseg_reg_valid;
            axiseg_chreg_tid    <= axiseg_reg_tid;
        end


        //****************************************************************
        //  FIFO & output reg
        //****************************************************************

        assign  axi_noc_tid =   { tag[ID_LSBS+:ID_W], axiseg_chreg_tuser_sop, axiseg_chreg_tuser_eop };
        assign  axi_noc_tdest = { tag[ID_LSBS+:ID_W], axiseg_chreg_tid, axiseg_chreg_tuser_err };

        assign  chfifo_wdata = { axi_noc_tdest, axi_noc_tid, axiseg_chreg_tdata, axiseg_chreg_tkeep };
        assign  chfifo_wen   = axiseg_chreg_valid;

        always @ (posedge aclk)
            chfifo_overflow[ch] <= chfifo_wen & (chfifo_wfull | chfifo_rrst_busy);

        assign err_ch_overflow = chfifo_overflow;

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
            insert_tlast <= 1'b1;
//            insert_tlast <= (chfifo_rcnt<=1) ? 1'b1 : 1'b0;   // insert TLAST if FIFO is getting low, ensures no stalled transfers

        assign  chfifo_ren = axis_chfifo_tvalid & axis_chfifo_tready;
        assign  axis_chfifo_tvalid = chfifo_rvalid;
        assign  { axis_chfifo_tdest, axis_chfifo_tid, axis_chfifo_tdata, axis_chfifo_tkeep } = chfifo_rdata;
        assign  axis_chfifo_tlast = insert_tlast;

        // nested generate
        if (ADD_EGR_AXIS_REG==0) begin : egr_comb_gen
            assign  axis_chfiforeg_tdata   = axis_chfifo_tdata ;
            assign  axis_chfiforeg_tkeep   = axis_chfifo_tkeep ;
            assign  axis_chfiforeg_tlast   = axis_chfifo_tlast ;
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
                .s_axis_tlast   ( axis_chfifo_tlast      ),  // input
                .s_axis_tid     ( axis_chfifo_tid        ),  // input  [ID_WIDTH-1:0]
                .s_axis_tdest   ( axis_chfifo_tdest      ),  // input  [DEST_WIDTH-1:0]
                .m_axis_tvalid  ( axis_chfiforeg_tvalid  ),  // output
                .m_axis_tready  ( axis_chfiforeg_tready  ),  // input
                .m_axis_tdata   ( axis_chfiforeg_tdata   ),  // output [DATA_WIDTH-1:0]
                .m_axis_tkeep   ( axis_chfiforeg_tkeep   ),  // output [DATA_WIDTH/8-1:0]
                .m_axis_tlast   ( axis_chfiforeg_tlast   ),  // output
                .m_axis_tid     ( axis_chfiforeg_tid     ),  // output [ID_WIDTH-1:0]
                .m_axis_tdest   ( axis_chfiforeg_tdest   )   // output [DEST_WIDTH-1:0]
            );
        end
        // nested endgenerate

        // output assignments
        assign  axis_egr_tvalid[ch]                          = axis_chfiforeg_tvalid;
        assign  axis_egr_tdata[ch*EGR_DW+:EGR_DW]            = axis_chfiforeg_tdata;
        assign  axis_egr_tlast[ch]                           = axis_chfiforeg_tlast;
        assign  axis_egr_tkeep[ch*EGR_KW+:EGR_KW]            = axis_chfiforeg_tkeep;
        assign  axis_egr_tid[ch*EGR_TID_W+:EGR_TID_W]        = axis_chfiforeg_tid;
        assign  axis_egr_tdest[ch*EGR_TDEST_W+:EGR_TDEST_W]  = axis_chfiforeg_tdest;

        assign  axis_chfiforeg_tready  = axis_egr_tready[ch];

    end
endgenerate


endmodule

