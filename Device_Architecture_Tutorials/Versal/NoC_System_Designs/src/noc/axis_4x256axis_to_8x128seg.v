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
// Description   : Wrapper to SV axis_1x_axis_to_2x_seg
//                 4x NoC channel instantiation, 4x256 -> 8x128 segmented
//--------------------------------------------------------------------------------------


// Module declaration
module axis_4x256axis_to_8x128seg (
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF axis_s0:axis_s1:axis_s2:axis_s3:axiseg_m0:axiseg_m1:axiseg_m2:axiseg_m3:axiseg_m4:axiseg_m5:axiseg_m6:axiseg_m7, ASSOCIATED_RESET arstn" *)
    input  wire           aclk,
    input  wire           arstn,
    output wire           axis_s0_tready,
    input  wire           axis_s0_tvalid,
    input  wire [255:0]   axis_s0_tdata,
    input  wire           axis_s0_tlast,
    input  wire [31:0]    axis_s0_tkeep,
    input  wire [5:0]     axis_s0_tid,
    input  wire [6:0]     axis_s0_tdest,
    output wire           axis_s1_tready,
    input  wire           axis_s1_tvalid,
    input  wire [255:0]   axis_s1_tdata,
    input  wire           axis_s1_tlast,
    input  wire [31:0]    axis_s1_tkeep,
    input  wire [5:0]     axis_s1_tid,
    input  wire [6:0]     axis_s1_tdest,
    output wire           axis_s2_tready,
    input  wire           axis_s2_tvalid,
    input  wire [255:0]   axis_s2_tdata,
    input  wire           axis_s2_tlast,
    input  wire [31:0]    axis_s2_tkeep,
    input  wire [5:0]     axis_s2_tid,
    input  wire [6:0]     axis_s2_tdest,
    output wire           axis_s3_tready,
    input  wire           axis_s3_tvalid,
    input  wire [255:0]   axis_s3_tdata,
    input  wire           axis_s3_tlast,
    input  wire [31:0]    axis_s3_tkeep,
    input  wire [5:0]     axis_s3_tid,
    input  wire [6:0]     axis_s3_tdest,
    input  wire [3:0]     axiseg_ready,
    output wire [3:0]     axiseg_valid,
    output wire [2:0]     axiseg_tid,
    output wire [127:0]   axiseg_m0_tdata,
    output wire           axiseg_m0_tuser_ena,
    output wire           axiseg_m0_tuser_sop,
    output wire           axiseg_m0_tuser_eop,
    output wire           axiseg_m0_tuser_err,
    output wire [3:0]     axiseg_m0_tuser_mty,
    output wire [127:0]   axiseg_m1_tdata,
    output wire           axiseg_m1_tuser_ena,
    output wire           axiseg_m1_tuser_sop,
    output wire           axiseg_m1_tuser_eop,
    output wire           axiseg_m1_tuser_err,
    output wire [3:0]     axiseg_m1_tuser_mty,
    output wire [127:0]   axiseg_m2_tdata,
    output wire           axiseg_m2_tuser_ena,
    output wire           axiseg_m2_tuser_sop,
    output wire           axiseg_m2_tuser_eop,
    output wire           axiseg_m2_tuser_err,
    output wire [3:0]     axiseg_m2_tuser_mty,
    output wire [127:0]   axiseg_m3_tdata,
    output wire           axiseg_m3_tuser_ena,
    output wire           axiseg_m3_tuser_sop,
    output wire           axiseg_m3_tuser_eop,
    output wire           axiseg_m3_tuser_err,
    output wire [3:0]     axiseg_m3_tuser_mty,
    output wire [127:0]   axiseg_m4_tdata,
    output wire           axiseg_m4_tuser_ena,
    output wire           axiseg_m4_tuser_sop,
    output wire           axiseg_m4_tuser_eop,
    output wire           axiseg_m4_tuser_err,
    output wire [3:0]     axiseg_m4_tuser_mty,
    output wire [127:0]   axiseg_m5_tdata,
    output wire           axiseg_m5_tuser_ena,
    output wire           axiseg_m5_tuser_sop,
    output wire           axiseg_m5_tuser_eop,
    output wire           axiseg_m5_tuser_err,
    output wire [3:0]     axiseg_m5_tuser_mty,
    output wire [127:0]   axiseg_m6_tdata,
    output wire           axiseg_m6_tuser_ena,
    output wire           axiseg_m6_tuser_sop,
    output wire           axiseg_m6_tuser_eop,
    output wire           axiseg_m6_tuser_err,
    output wire [3:0]     axiseg_m6_tuser_mty,
    output wire [127:0]   axiseg_m7_tdata,
    output wire           axiseg_m7_tuser_ena,
    output wire           axiseg_m7_tuser_sop,
    output wire           axiseg_m7_tuser_eop,
    output wire           axiseg_m7_tuser_err,
    output wire [3:0]     axiseg_m7_tuser_mty,
    output wire           err_alignment
);


// parameters
parameter NUM_NOC_CH = 4;
parameter NUM_SEG_CH = NUM_NOC_CH*2;
parameter TID_WIDTH    = 6;
parameter TDEST_WIDTH  = 7;
parameter EGRESS_DATA_WIDTH  = 128;
parameter INGRESS_DATA_WIDTH = 2*EGRESS_DATA_WIDTH;
parameter EGRESS_MTY_WIDTH   = 4;
parameter INGRESS_KEEP_WIDTH = INGRESS_DATA_WIDTH/8;
parameter ADD_ING_AXIS_REG   = 0;
parameter ADD_EGR_AXIS_REG   = 0;

wire [NUM_NOC_CH-1:0]                     axis_ing_flat_tready;
wire [NUM_NOC_CH-1:0]                     axis_ing_flat_tvalid;
wire [NUM_NOC_CH*INGRESS_DATA_WIDTH-1:0]  axis_ing_flat_tdata;
wire [NUM_NOC_CH-1:0]                     axis_ing_flat_tlast;
wire [NUM_NOC_CH*INGRESS_KEEP_WIDTH-1:0]  axis_ing_flat_tkeep;
wire [NUM_NOC_CH*TID_WIDTH-1:0]           axis_ing_flat_tid;
wire [NUM_NOC_CH*TDEST_WIDTH-1:0]         axis_ing_flat_tdest;

wire [NUM_SEG_CH*EGRESS_DATA_WIDTH-1:0]     axiseg_egr_flat_tdata;
wire [NUM_SEG_CH-1:0]                       axiseg_egr_flat_tuser_ena;
wire [NUM_SEG_CH-1:0]                       axiseg_egr_flat_tuser_sop;
wire [NUM_SEG_CH-1:0]                       axiseg_egr_flat_tuser_eop;
wire [NUM_SEG_CH-1:0]                       axiseg_egr_flat_tuser_err;
wire [NUM_SEG_CH*EGRESS_MTY_WIDTH-1:0]      axiseg_egr_flat_tuser_mty;

// input to ing
assign axis_ing_flat_tvalid = { axis_s3_tvalid, axis_s2_tvalid, axis_s1_tvalid, axis_s0_tvalid };
assign axis_ing_flat_tdata  = { axis_s3_tdata , axis_s2_tdata , axis_s1_tdata , axis_s0_tdata  };
assign axis_ing_flat_tlast  = { axis_s3_tlast , axis_s2_tlast , axis_s1_tlast , axis_s0_tlast  };
assign axis_ing_flat_tkeep  = { axis_s3_tkeep , axis_s2_tkeep , axis_s1_tkeep , axis_s0_tkeep  };
assign axis_ing_flat_tid    = { axis_s3_tid   , axis_s2_tid   , axis_s1_tid   , axis_s0_tid    };
assign axis_ing_flat_tdest  = { axis_s3_tdest , axis_s2_tdest , axis_s1_tdest , axis_s0_tdest  };

// output from egr
assign { axis_s3_tready, axis_s2_tready, axis_s1_tready, axis_s0_tready } = axis_ing_flat_tready;

// output from egr
assign { axiseg_m7_tdata    , axiseg_m6_tdata    , axiseg_m5_tdata    , axiseg_m4_tdata    , axiseg_m3_tdata    , axiseg_m2_tdata    , axiseg_m1_tdata    , axiseg_m0_tdata     } = axiseg_egr_flat_tdata    ;
assign { axiseg_m7_tuser_ena, axiseg_m6_tuser_ena, axiseg_m5_tuser_ena, axiseg_m4_tuser_ena, axiseg_m3_tuser_ena, axiseg_m2_tuser_ena, axiseg_m1_tuser_ena, axiseg_m0_tuser_ena } = axiseg_egr_flat_tuser_ena;
assign { axiseg_m7_tuser_sop, axiseg_m6_tuser_sop, axiseg_m5_tuser_sop, axiseg_m4_tuser_sop, axiseg_m3_tuser_sop, axiseg_m2_tuser_sop, axiseg_m1_tuser_sop, axiseg_m0_tuser_sop } = axiseg_egr_flat_tuser_sop;
assign { axiseg_m7_tuser_eop, axiseg_m6_tuser_eop, axiseg_m5_tuser_eop, axiseg_m4_tuser_eop, axiseg_m3_tuser_eop, axiseg_m2_tuser_eop, axiseg_m1_tuser_eop, axiseg_m0_tuser_eop } = axiseg_egr_flat_tuser_eop;
assign { axiseg_m7_tuser_err, axiseg_m6_tuser_err, axiseg_m5_tuser_err, axiseg_m4_tuser_err, axiseg_m3_tuser_err, axiseg_m2_tuser_err, axiseg_m1_tuser_err, axiseg_m0_tuser_err } = axiseg_egr_flat_tuser_err;
assign { axiseg_m7_tuser_mty, axiseg_m6_tuser_mty, axiseg_m5_tuser_mty, axiseg_m4_tuser_mty, axiseg_m3_tuser_mty, axiseg_m2_tuser_mty, axiseg_m1_tuser_mty, axiseg_m0_tuser_mty } = axiseg_egr_flat_tuser_mty;


axis_1x_axis_to_2x_seg #(
    .NUM_NOC_CH         ( NUM_NOC_CH           ),
    .EGR_DW             ( EGRESS_DATA_WIDTH    ),
    .ADD_ING_AXIS_REG   ( ADD_ING_AXIS_REG     ),
    .ADD_EGR_AXIS_REG   ( ADD_EGR_AXIS_REG     )
) inst (
    .aclk                     ( aclk                       ),   //  input
    .arstn                    ( arstn                      ),   //  input
    .axis_ing_tready          ( axis_ing_flat_tready       ),   //  output [NUM_NOC_CH-1:0]
    .axis_ing_tvalid          ( axis_ing_flat_tvalid       ),   //  input  [NUM_NOC_CH-1:0]
    .axis_ing_tdata           ( axis_ing_flat_tdata        ),   //  input  [NUM_NOC_CH*ING_DW-1:0]
    .axis_ing_tlast           ( axis_ing_flat_tlast        ),   //  input  [NUM_NOC_CH-1:0]
    .axis_ing_tkeep           ( axis_ing_flat_tkeep        ),   //  input  [NUM_NOC_CH*ING_KW-1:0]
    .axis_ing_tid             ( axis_ing_flat_tid          ),   //  input  [NUM_NOC_CH*ING_TID_W-1:0]
    .axis_ing_tdest           ( axis_ing_flat_tdest        ),   //  input  [NUM_NOC_CH*ING_TDEST_W-1:0]
    .axiseg_egr_ready         ( axiseg_ready               ),   //  input  [NUM_NOC_CH-1:0]
    .axiseg_egr_valid         ( axiseg_valid               ),   //  output [NUM_NOC_CH-1:0]
    .axiseg_egr_tdata         ( axiseg_egr_flat_tdata      ),   //  output [NUM_SEG_CH*EGR_DW-1:0]
    .axiseg_egr_tuser_ena     ( axiseg_egr_flat_tuser_ena  ),   //  output [NUM_SEG_CH-1:0]
    .axiseg_egr_tuser_sop     ( axiseg_egr_flat_tuser_sop  ),   //  output [NUM_SEG_CH-1:0]
    .axiseg_egr_tuser_eop     ( axiseg_egr_flat_tuser_eop  ),   //  output [NUM_SEG_CH-1:0]
    .axiseg_egr_tuser_err     ( axiseg_egr_flat_tuser_err  ),   //  output [NUM_SEG_CH-1:0]
    .axiseg_egr_tuser_mty     ( axiseg_egr_flat_tuser_mty  ),   //  output [NUM_SEG_CH*EGR_MTYW-1:0]
    .axiseg_egr_tid           ( axiseg_tid                 ),   //  output [EGR_TID_W-1:0]
    .err_alignment            ( err_alignment              )    //  output
);


endmodule

