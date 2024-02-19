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
// Description   : Wrapper to SV axis_2x_seg_to_1x_axis
//                 4x NoC channel instantiation, 8x128 segmented -> 4x256
//--------------------------------------------------------------------------------------


// Module declaration
module axis_8x128seg_to_4x256axis (
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF axiseg_s0:axiseg_s1:axiseg_s2:axiseg_s3:axiseg_s4:axiseg_s5:axiseg_s6:axiseg_s7:axis_m0:axis_m1:axis_m2:axis_m3, ASSOCIATED_RESET arstn" *)
    input  wire           aclk,
    input  wire           arstn,
    input  wire [2:0]     axiseg_tid,
    input  wire           axiseg_valid,
    input  wire [127:0]   axiseg_s0_tdata,
    input  wire           axiseg_s0_tuser_ena,
    input  wire           axiseg_s0_tuser_sop,
    input  wire           axiseg_s0_tuser_eop,
    input  wire           axiseg_s0_tuser_err,
    input  wire [3:0]     axiseg_s0_tuser_mty,
    input  wire [127:0]   axiseg_s1_tdata,
    input  wire           axiseg_s1_tuser_ena,
    input  wire           axiseg_s1_tuser_sop,
    input  wire           axiseg_s1_tuser_eop,
    input  wire           axiseg_s1_tuser_err,
    input  wire [3:0]     axiseg_s1_tuser_mty,
    input  wire [127:0]   axiseg_s2_tdata,
    input  wire           axiseg_s2_tuser_ena,
    input  wire           axiseg_s2_tuser_sop,
    input  wire           axiseg_s2_tuser_eop,
    input  wire           axiseg_s2_tuser_err,
    input  wire [3:0]     axiseg_s2_tuser_mty,
    input  wire [127:0]   axiseg_s3_tdata,
    input  wire           axiseg_s3_tuser_ena,
    input  wire           axiseg_s3_tuser_sop,
    input  wire           axiseg_s3_tuser_eop,
    input  wire           axiseg_s3_tuser_err,
    input  wire [3:0]     axiseg_s3_tuser_mty,
    input  wire [127:0]   axiseg_s4_tdata,
    input  wire           axiseg_s4_tuser_ena,
    input  wire           axiseg_s4_tuser_sop,
    input  wire           axiseg_s4_tuser_eop,
    input  wire           axiseg_s4_tuser_err,
    input  wire [3:0]     axiseg_s4_tuser_mty,
    input  wire [127:0]   axiseg_s5_tdata,
    input  wire           axiseg_s5_tuser_ena,
    input  wire           axiseg_s5_tuser_sop,
    input  wire           axiseg_s5_tuser_eop,
    input  wire           axiseg_s5_tuser_err,
    input  wire [3:0]     axiseg_s5_tuser_mty,
    input  wire [127:0]   axiseg_s6_tdata,
    input  wire           axiseg_s6_tuser_ena,
    input  wire           axiseg_s6_tuser_sop,
    input  wire           axiseg_s6_tuser_eop,
    input  wire           axiseg_s6_tuser_err,
    input  wire [3:0]     axiseg_s6_tuser_mty,
    input  wire [127:0]   axiseg_s7_tdata,
    input  wire           axiseg_s7_tuser_ena,
    input  wire           axiseg_s7_tuser_sop,
    input  wire           axiseg_s7_tuser_eop,
    input  wire           axiseg_s7_tuser_err,
    input  wire [3:0]     axiseg_s7_tuser_mty,
    input  wire           axis_m0_tready,
    output wire           axis_m0_tvalid,
    output wire [255:0]   axis_m0_tdata,
    output wire           axis_m0_tlast,
    output wire [31:0]    axis_m0_tkeep,
    output wire [5:0]     axis_m0_tid,
    output wire [6:0]     axis_m0_tdest,
    input  wire           axis_m1_tready,
    output wire           axis_m1_tvalid,
    output wire [255:0]   axis_m1_tdata,
    output wire           axis_m1_tlast,
    output wire [31:0]    axis_m1_tkeep,
    output wire [5:0]     axis_m1_tid,
    output wire [6:0]     axis_m1_tdest,
    input  wire           axis_m2_tready,
    output wire           axis_m2_tvalid,
    output wire [255:0]   axis_m2_tdata,
    output wire           axis_m2_tlast,
    output wire [31:0]    axis_m2_tkeep,
    output wire [5:0]     axis_m2_tid,
    output wire [6:0]     axis_m2_tdest,
    input  wire           axis_m3_tready,
    output wire           axis_m3_tvalid,
    output wire [255:0]   axis_m3_tdata,
    output wire           axis_m3_tlast,
    output wire [31:0]    axis_m3_tkeep,
    output wire [5:0]     axis_m3_tid,
    output wire [6:0]     axis_m3_tdest,
    output wire [3:0]     err_ch_overflow
);


// parameters
parameter NUM_NOC_CH = 4;
parameter NUM_SEG_CH = NUM_NOC_CH*2;
parameter INGRESS_TID_WIDTH  = 3;
parameter EGRESS_TID_WIDTH   = 6;
parameter EGRESS_TDEST_WIDTH = 7;
parameter INGRESS_DATA_WIDTH = 128;
parameter EGRESS_DATA_WIDTH  = 2*INGRESS_DATA_WIDTH;
parameter INGRESS_MTY_WIDTH  = 4;
parameter EGRESS_KEEP_WIDTH  = EGRESS_DATA_WIDTH/8;
parameter ADD_EGR_AXIS_REG   = 0;

wire [NUM_SEG_CH*INGRESS_DATA_WIDTH-1:0]    axiseg_ing_flat_tdata;
wire [NUM_SEG_CH-1:0]                       axiseg_ing_flat_tuser_ena;
wire [NUM_SEG_CH-1:0]                       axiseg_ing_flat_tuser_sop;
wire [NUM_SEG_CH-1:0]                       axiseg_ing_flat_tuser_eop;
wire [NUM_SEG_CH-1:0]                       axiseg_ing_flat_tuser_err;
wire [NUM_SEG_CH*INGRESS_MTY_WIDTH-1:0]     axiseg_ing_flat_tuser_mty;

wire [NUM_NOC_CH-1:0]                     axis_egr_flat_tready;
wire [NUM_NOC_CH-1:0]                     axis_egr_flat_tvalid;
wire [NUM_NOC_CH*EGRESS_DATA_WIDTH-1:0]   axis_egr_flat_tdata;
wire [NUM_NOC_CH-1:0]                     axis_egr_flat_tlast;
wire [NUM_NOC_CH*EGRESS_KEEP_WIDTH-1:0]   axis_egr_flat_tkeep;
wire [NUM_NOC_CH*EGRESS_TID_WIDTH-1:0]    axis_egr_flat_tid;
wire [NUM_NOC_CH*EGRESS_TDEST_WIDTH-1:0]  axis_egr_flat_tdest;

// input to ing
assign axiseg_ing_flat_tdata     = { axiseg_s7_tdata    , axiseg_s6_tdata    , axiseg_s5_tdata    , axiseg_s4_tdata    , axiseg_s3_tdata    , axiseg_s2_tdata    , axiseg_s1_tdata    , axiseg_s0_tdata     };
assign axiseg_ing_flat_tuser_ena = { axiseg_s7_tuser_ena, axiseg_s6_tuser_ena, axiseg_s5_tuser_ena, axiseg_s4_tuser_ena, axiseg_s3_tuser_ena, axiseg_s2_tuser_ena, axiseg_s1_tuser_ena, axiseg_s0_tuser_ena };
assign axiseg_ing_flat_tuser_sop = { axiseg_s7_tuser_sop, axiseg_s6_tuser_sop, axiseg_s5_tuser_sop, axiseg_s4_tuser_sop, axiseg_s3_tuser_sop, axiseg_s2_tuser_sop, axiseg_s1_tuser_sop, axiseg_s0_tuser_sop };
assign axiseg_ing_flat_tuser_eop = { axiseg_s7_tuser_eop, axiseg_s6_tuser_eop, axiseg_s5_tuser_eop, axiseg_s4_tuser_eop, axiseg_s3_tuser_eop, axiseg_s2_tuser_eop, axiseg_s1_tuser_eop, axiseg_s0_tuser_eop };
assign axiseg_ing_flat_tuser_err = { axiseg_s7_tuser_err, axiseg_s6_tuser_err, axiseg_s5_tuser_err, axiseg_s4_tuser_err, axiseg_s3_tuser_err, axiseg_s2_tuser_err, axiseg_s1_tuser_err, axiseg_s0_tuser_err };
assign axiseg_ing_flat_tuser_mty = { axiseg_s7_tuser_mty, axiseg_s6_tuser_mty, axiseg_s5_tuser_mty, axiseg_s4_tuser_mty, axiseg_s3_tuser_mty, axiseg_s2_tuser_mty, axiseg_s1_tuser_mty, axiseg_s0_tuser_mty };

// input to egr
assign axis_egr_flat_tready = { axis_m3_tready, axis_m2_tready, axis_m1_tready, axis_m0_tready };

// output from egr
assign { axis_m3_tvalid, axis_m2_tvalid, axis_m1_tvalid, axis_m0_tvalid } = axis_egr_flat_tvalid;
assign { axis_m3_tdata , axis_m2_tdata , axis_m1_tdata , axis_m0_tdata  } = axis_egr_flat_tdata ;
assign { axis_m3_tlast , axis_m2_tlast , axis_m1_tlast , axis_m0_tlast  } = axis_egr_flat_tlast ;
assign { axis_m3_tkeep , axis_m2_tkeep , axis_m1_tkeep , axis_m0_tkeep  } = axis_egr_flat_tkeep ;
assign { axis_m3_tid   , axis_m2_tid   , axis_m1_tid   , axis_m0_tid    } = axis_egr_flat_tid   ;
assign { axis_m3_tdest , axis_m2_tdest , axis_m1_tdest , axis_m0_tdest  } = axis_egr_flat_tdest ;


axis_2x_seg_to_1x_axis #(
    .NUM_NOC_CH         ( NUM_NOC_CH           ),
    .ING_DW             ( INGRESS_DATA_WIDTH   ),
    .ING_TID_W          ( INGRESS_TID_WIDTH    ),
    .ADD_EGR_AXIS_REG   ( ADD_EGR_AXIS_REG     )
) inst (
    .aclk                     ( aclk                       ),   //  input
    .arstn                    ( arstn                      ),   //  input
    .axiseg_ing_valid         ( axiseg_valid               ),   //  input
    .axiseg_ing_tdata         ( axiseg_ing_flat_tdata      ),   //  input  [NUM_SEG_CH*ING_DW-1:0]
    .axiseg_ing_tuser_ena     ( axiseg_ing_flat_tuser_ena  ),   //  input  [NUM_SEG_CH-1:0]
    .axiseg_ing_tuser_sop     ( axiseg_ing_flat_tuser_sop  ),   //  input  [NUM_SEG_CH-1:0]
    .axiseg_ing_tuser_eop     ( axiseg_ing_flat_tuser_eop  ),   //  input  [NUM_SEG_CH-1:0]
    .axiseg_ing_tuser_err     ( axiseg_ing_flat_tuser_err  ),   //  input  [NUM_SEG_CH-1:0]
    .axiseg_ing_tuser_mty     ( axiseg_ing_flat_tuser_mty  ),   //  input  [NUM_SEG_CH*ING_MTYW-1:0]
    .axiseg_ing_tid           ( axiseg_tid                 ),   //  input  [ING_TID_W-1:0]
    .axis_egr_tready          ( axis_egr_flat_tready       ),   //  input  [NUM_NOC_CH-1:0]
    .axis_egr_tvalid          ( axis_egr_flat_tvalid       ),   //  output [NUM_NOC_CH-1:0]
    .axis_egr_tdata           ( axis_egr_flat_tdata        ),   //  output [NUM_NOC_CH*EGR_DW-1:0]
    .axis_egr_tlast           ( axis_egr_flat_tlast        ),   //  output [NUM_NOC_CH-1:0]
    .axis_egr_tkeep           ( axis_egr_flat_tkeep        ),   //  output [NUM_NOC_CH*EGR_KW-1:0]
    .axis_egr_tid             ( axis_egr_flat_tid          ),   //  output [NUM_NOC_CH*EGR_TID_W-1:0]
    .axis_egr_tdest           ( axis_egr_flat_tdest        ),   //  output [NUM_NOC_CH*EGR_TDEST_W-1:0]
    .err_ch_overflow          (err_ch_overflow             )    //  output [NUM_NOC_CH-1:0]
);


endmodule

