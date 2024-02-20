// ------------------------------------------------------------------------------
//   (c) Copyright 2020-2021 Advanced Micro Devices, Inc. All rights reserved.
// 
//   This file contains confidential and proprietary information
//   of Advanced Micro Devices, Inc. and is protected under U.S. and
//   international copyright and other intellectual property
//   laws.
// 
//   DISCLAIMER
//   This disclaimer is not a license and does not grant any
//   rights to the materials distributed herewith. Except as
//   otherwise provided in a valid license issued to you by
//   AMD, and to the maximum extent permitted by applicable
//   law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
//   WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
//   AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//   BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//   INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//   (2) AMD shall not be liable (whether in contract or tort,
//   including negligence, or under any other theory of
//   liability) for any loss or damage of any kind or nature
//   related to, arising under or in connection with these
//   materials, including for any direct, or any indirect,
//   special, incidental, or consequential loss or damage
//   (including loss of data, profits, goodwill, or any type of
//   loss or damage suffered as a result of any action brought
//   by a third party) even if such damage or loss was
//   reasonably foreseeable or AMD had been advised of the
//   possibility of the same.
// 
//   CRITICAL APPLICATIONS
//   AMD products are not designed or intended to be fail-
//   safe, or for use in any application requiring fail-safe
//   performance, such as life-support or safety devices or
//   systems, Class III medical devices, nuclear facilities,
//   applications related to the deployment of airbags, or any
//   other applications that could lead to death, personal
//   injury, or severe property or environmental damage
//   (individually and collectively, \"Critical
//   Applications\"). Customer assumes the sole risk and
//   liability of any use of AMD products in Critical
//   Applications, subject only to applicable laws and
//   regulations governing limitations on product liability.
// 
//   THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//   PART OF THIS FILE AT ALL TIMES.
// ------------------------------------------------------------------------------
////------------------------------------------------------------------------------


`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module dcmac_0_exdes
(
    input wire            s_axi_aclk,
    input wire            s_axi_aresetn,
    input wire [31 : 0]   s_axi_awaddr,
    input wire            s_axi_awvalid,
    output wire           s_axi_awready,
    input wire [31 : 0]   s_axi_wdata,
    input wire            s_axi_wvalid,
    output wire           s_axi_wready,
    output wire [1 : 0]   s_axi_bresp,
    output wire           s_axi_bvalid,
    input wire            s_axi_bready,
    input wire [31 : 0]   s_axi_araddr,
    input wire            s_axi_arvalid,
    output wire           s_axi_arready,
    output wire [31 : 0]  s_axi_rdata,
    output wire [1 : 0]   s_axi_rresp,
    output wire           s_axi_rvalid,
    input wire            s_axi_rready,
    input  wire [3:0] gt_rxn_in0,
    input  wire [3:0] gt_rxp_in0,
    output wire [3:0] gt_txn_out0,
    output wire [3:0] gt_txp_out0,
    input  wire [3:0] gt_rxn_in1,
    input  wire [3:0] gt_rxp_in1,
    output wire [3:0] gt_txn_out1,
    output wire [3:0] gt_txp_out1,

    input  wire       gt_reset_all_in,
    output wire [31:0] gt_gpo,
    output wire       gt_reset_done,
    input  wire [7:0] gt_line_rate,
    input  wire [2:0] gt_loopback,
    input  wire [5:0] gt_txprecursor,
    input  wire [5:0] gt_txpostcursor,
    input  wire [6:0] gt_txmaincursor,
    input  wire       gt_rxcdrhold,

    output logic [31:0]  APB_M2_prdata,
    output logic [0:0]   APB_M2_pready,
    output logic [0:0]   APB_M2_pslverr,
    output logic [31:0]  APB_M3_prdata,
    output logic [0:0]   APB_M3_pready,
    output logic [0:0]   APB_M3_pslverr,
    output logic [31:0]  APB_M4_prdata,
    output logic [0:0]   APB_M4_pready,
    output logic [0:0]   APB_M4_pslverr,

    input [31:0]      APB_M2_paddr,
    input             APB_M2_penable,
    input [0:0]       APB_M2_psel,
    input [31:0]      APB_M2_pwdata,
    input             APB_M2_pwrite,
    input [31:0]      APB_M3_paddr,
    input             APB_M3_penable,
    input [0:0]       APB_M3_psel,
    input [31:0]      APB_M3_pwdata,
    input             APB_M3_pwrite,
    input [31:0]      APB_M4_paddr,
    input             APB_M4_penable,
    input [0:0]       APB_M4_psel,
    input [31:0]      APB_M4_pwdata,
    input             APB_M4_pwrite,
    input  wire [5:0] tx_serdes_reset,
    input  wire [5:0] rx_serdes_reset,
    input  wire       tx_core_reset,
    input  wire       rx_core_reset,
    output wire [23:0] gt_tx_reset_done_out,
    output wire [23:0] gt_rx_reset_done_out,
    output wire        gt_tx_reset_core,
    output wire        gt_rx_reset_core,
    input  wire       gt_ref_clk0_p,
    input  wire       gt_ref_clk0_n,
    input  wire       gt_ref_clk1_p,
    input  wire       gt_ref_clk1_n,
    input  wire [8-1:0] gt_reset_tx_datapath_in,
    input  wire [8-1:0] gt_reset_rx_datapath_in,
    input  wire       init_clk
);

  //parameter DEVICE_NAME  = "VERSAL_PREMIUM_ES1";
  parameter COUNTER_MODE = 0;

  // For other GT loopback options, please program the value thru CIPS appropriately.
  // For GT Near-end PCS loopback, update the GT loopback value to 3'd1. Drive gt_loopback = 3'b001.
  // For GT External loopback, update the GT loopback value to 3'd0. Drive gt_loopback = 3'b000.
  // For more information & settings on loopback, refer versal GT Transceivers user guide.
  wire  [31:0]   SW_REG_GT_LINE_RATE;
  assign SW_REG_GT_LINE_RATE = {gt_line_rate,gt_line_rate,gt_line_rate,gt_line_rate};

  //wire           gt_rxcdrhold;
  //assign gt_rxcdrhold = (gt_loopback == 3'b001)? 1'b1 : 1'b0;
  ////////////
  wire           tx_core_clk;
  wire           rx_core_clk;
  wire [5:0]     rx_serdes_clk;
  wire [5:0]     tx_serdes_clk;
  wire [5:0]     rx_alt_serdes_clk;
  wire [5:0]     tx_alt_serdes_clk;
  wire           ts_clk;


  wire           gt0_tx_usrclk_0;
  wire           gt0_tx_usrclk2_0;
  wire           gt0_rx_usrclk2_0;
  wire           gt0_rx_usrclk_0;

  wire           gt0_tx_usrclk_2;
  wire           gt0_tx_usrclk2_2;
  wire           gt0_rx_usrclk2_2;
  wire           gt0_rx_usrclk_2;

  wire           gt1_tx_usrclk_0;
  wire           gt1_tx_usrclk2_0;
  wire           gt1_rx_usrclk2_0;
  wire           gt1_rx_usrclk_0;

  wire           gt1_tx_usrclk_2;
  wire           gt1_tx_usrclk2_2;
  wire           gt1_rx_usrclk2_2;
  wire           gt1_rx_usrclk_2;
  wire           gt_reset_tx_datapath_in_0;
  wire           gt_reset_rx_datapath_in_0;
  assign         gt_reset_tx_datapath_in_0 = gt_reset_tx_datapath_in[0];
  assign         gt_reset_rx_datapath_in_0 = gt_reset_rx_datapath_in[0];
  wire           gt_reset_tx_datapath_in_1;
  wire           gt_reset_rx_datapath_in_1;
  assign         gt_reset_tx_datapath_in_1 = gt_reset_tx_datapath_in[1];
  assign         gt_reset_rx_datapath_in_1 = gt_reset_rx_datapath_in[1];
  wire           gt_reset_tx_datapath_in_2;
  wire           gt_reset_rx_datapath_in_2;
  assign         gt_reset_tx_datapath_in_2 = gt_reset_tx_datapath_in[2];
  assign         gt_reset_rx_datapath_in_2 = gt_reset_rx_datapath_in[2];
  wire           gt_reset_tx_datapath_in_3;
  wire           gt_reset_rx_datapath_in_3;
  assign         gt_reset_tx_datapath_in_3 = gt_reset_tx_datapath_in[3];
  assign         gt_reset_rx_datapath_in_3 = gt_reset_rx_datapath_in[3];
  wire           gt_reset_tx_datapath_in_4;
  wire           gt_reset_rx_datapath_in_4;
  assign         gt_reset_tx_datapath_in_4 = gt_reset_tx_datapath_in[4];
  assign         gt_reset_rx_datapath_in_4 = gt_reset_rx_datapath_in[4];
  wire           gt_reset_tx_datapath_in_5;
  wire           gt_reset_rx_datapath_in_5;
  assign         gt_reset_tx_datapath_in_5 = gt_reset_tx_datapath_in[5];
  assign         gt_reset_rx_datapath_in_5 = gt_reset_rx_datapath_in[5];
  wire           gt_reset_tx_datapath_in_6;
  wire           gt_reset_rx_datapath_in_6;
  assign         gt_reset_tx_datapath_in_6 = gt_reset_tx_datapath_in[6];
  assign         gt_reset_rx_datapath_in_6 = gt_reset_rx_datapath_in[6];
  wire           gt_reset_tx_datapath_in_7;
  wire           gt_reset_rx_datapath_in_7;
  assign         gt_reset_tx_datapath_in_7 = gt_reset_tx_datapath_in[7];
  assign         gt_reset_rx_datapath_in_7 = gt_reset_rx_datapath_in[7];
  wire           gtpowergood_0;
  wire           gtpowergood_1;
  wire           gt_rx_reset_done_inv;
  wire           gt_tx_reset_done_inv;
  wire           gt_rx_reset_done_core_clk_sync;
  wire           gt_tx_reset_done_core_clk_sync;
  wire           gt_rx_reset_done_axis_clk_sync;
  wire           gt_tx_reset_done_axis_clk_sync;
  wire           gtpowergood;
  wire [5:0]     pm_tick_core = {6{1'b0}};
  wire           core_clk;
  wire           axis_clk;
  wire           clk_wiz_in;
  wire           clk_wiz_locked;
  wire           clk_tx_axi;
  wire           clk_rx_axi;
  wire           [5:0] tx_serdes_is_am;
  wire           [5:0] tx_serdes_is_am_prefifo;
  wire           clk_apb3;
  wire           rstn_hard_apb3;

  assign clk_apb3       = s_axi_aclk;
  assign rstn_hard_apb3 = s_axi_aresetn;

assign gt_tx_reset_core = gt_tx_reset_done_inv; 
assign gt_rx_reset_core = gt_rx_reset_done_inv;

  typedef struct packed {
    logic [2:0]               id;
    logic [11:0]              ena;
    logic [11:0]              sop;
    logic [11:0]              eop;
    logic [11:0]              err;
    logic [11:0][3:0]         mty;
    logic [11:0][127:0]       dat;
  } axis_tx_pkt_t;

  typedef struct packed {
    logic [2:0]               id;
    logic [11:0]              ena;
    logic [11:0]              sop;
    logic [11:0]              eop;
    logic [11:0]              err;
    logic [11:0][3:0]         mty;
    logic [11:0][127:0]       dat;
  } axis_rx_pkt_t;

  typedef struct packed {
    logic [1:0]              ena;
    logic [1:0]              sop;
    logic [1:0]              eop;
    logic [1:0]              err;
    logic [1:0][3:0]         mty;
    logic [1:0][127:0]       dat;
  } slice_tx_t;

  typedef struct packed {
    logic [1:0]              ena;
    logic [1:0]              sop;
    logic [1:0]              eop;
    logic [1:0]              err;
    logic [1:0][3:0]         mty;
    logic [1:0][127:0]       dat;
  } slice_rx_t;

  wire                rstn_apb3;
  wire                [31:0] scratch;
  logic               [5:0] tx_axis_ch_status_id;
  logic               tx_axis_ch_status_skip_req;
  logic               tx_axis_ch_status_vld     ;
  logic               [5:0] tx_axis_id_req      ;
  logic               tx_axis_id_req_vld        ;
  wire                tx_axis_tuser_skip_response;
  // MACIF TX
  wire                tx_macif_ena;
  wire                [5:0] tx_macif_ts_id; // delayed tx_macif_ts_id_req
  wire                [5:0] tx_macif_ts_id_req; // from calendar
  wire                tx_macif_ts_id_req_rdy;
  wire                tx_macif_ts_id_req_vld;
  wire                [23:0][65:0] tx_macif_data;
  // MACIF RX
  logic               rx_macif_ena;
  logic               [23:0][65:0] rx_macif_data;
  logic               [5:0] rx_macif_ts_id;

  wire                [6:0] tx_pkt_gen_ena;
  wire                [15:0] tx_pkt_gen_min_len;
  wire                [15:0] tx_pkt_gen_max_len;
  wire                [39:0] clear_tx_counters;
  wire                [39:0] clear_rx_counters;


  wire                [5:0][63:0] tx_frames_transmitted_latched, tx_bytes_transmitted_latched;
  wire                [5:0][63:0] rx_frames_received_latched, rx_bytes_received_latched;
  wire                [5:0]       rx_prbs_locked;
  wire                [5:0][31:0] rx_prbs_err;


  axis_tx_pkt_t    tx_gen_axis_pkt, tx_axis_pkt;
  wire             tx_axis_pkt_valid;
  axis_rx_pkt_t    rx_axis_pkt, rx_axis_pkt_mon;
  wire             [11:0] rx_axis_pkt_ena;
  wire             [5:0] rx_axis_tvalid;

  wire             [55:0] tx_tsmac_tdm_stats_data;
  wire             [5:0] tx_tsmac_tdm_stats_id;
  wire             tx_tsmac_tdm_stats_valid;
  wire             [78:0] rx_tsmac_tdm_stats_data;
  wire             [5:0] rx_tsmac_tdm_stats_id;
  wire             rx_tsmac_tdm_stats_valid;

  wire [15:0]      c0_stat_rx_corrected_lane_delay_0;
  wire [15:0]      c0_stat_rx_corrected_lane_delay_1;
  wire [15:0]      c0_stat_rx_corrected_lane_delay_2;
  wire [15:0]      c0_stat_rx_corrected_lane_delay_3;
  wire             c0_stat_rx_corrected_lane_delay_valid;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_0;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_1;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_2;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_3;
  wire             c1_stat_rx_corrected_lane_delay_valid;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_0;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_1;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_2;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_3;
  wire             c2_stat_rx_corrected_lane_delay_valid;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_0;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_1;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_2;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_3;
  wire             c3_stat_rx_corrected_lane_delay_valid;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_0;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_1;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_2;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_3;
  wire c4_stat_rx_corrected_lane_delay_valid;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_0;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_1;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_2;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_3;
  wire             c5_stat_rx_corrected_lane_delay_valid;

  // Pause insertion
  wire                [5:0] emu_tx_resend_pause;
  wire                [5:0][8:0] emu_tx_pause_req;

  // PTP enable
  wire                [1:0]   emu_tx_ptp_opt;
  wire                [11:0]  emu_tx_ptp_cf_offset;
  wire                        emu_tx_ptp_upd_chksum;
  wire                [5:0]   emu_tx_ptp_ena;

  logic               independent_mode;
  wire                [5:0] tx_axi_vld_mask;
  wire                [5:0] tx_gearbox_af, tx_gearbox_dout_vld, tx_axis_tready, tx_axis_af;
  slice_tx_t          [5:0] tx_gearbox_slice;
  slice_rx_t          [5:0] rx_gearbox_slice;
  wire                [5:0] tx_gearbox_ovf, tx_gearbox_unf;
  wire                [5:0] pkt_gen_id_req;
  wire                pkt_gen_id_req_vld;
  axis_rx_pkt_t       rx_gearbox_o_pkt;
  wire                [5:0][31:0] rx_preamble_err_cnt;
  wire                [5:0][1:0]  client_data_rate;

  //wire                [23:0][79:0] tx_serdes_data;
  //wire                [23:0][79:0] rx_serdes_data;

  wire                [15:0] default_vl_length_100GE = 16'd255;
  wire                [15:0] default_vl_length_200GE_or_400GE = 16'd256;

  wire                [63:0] ctl_tx_vl_marker_id0_100ge  = 64'hc16821003e97de00;
  wire                [63:0] ctl_tx_vl_marker_id1_100ge  = 64'h9d718e00628e7100;
  wire                [63:0] ctl_tx_vl_marker_id2_100ge  = 64'h594be800a6b41700;
  wire                [63:0] ctl_tx_vl_marker_id3_100ge  = 64'h4d957b00b26a8400;
  wire                [63:0] ctl_tx_vl_marker_id4_100ge  = 64'hf50709000af8f600;
  wire                [63:0] ctl_tx_vl_marker_id5_100ge  = 64'hdd14c20022eb3d00;
  wire                [63:0] ctl_tx_vl_marker_id6_100ge  = 64'h9a4a260065b5d900;
  wire                [63:0] ctl_tx_vl_marker_id7_100ge  = 64'h7b45660084ba9900;
  wire                [63:0] ctl_tx_vl_marker_id8_100ge  = 64'ha02476005fdb8900;
  wire                [63:0] ctl_tx_vl_marker_id9_100ge  = 64'h68c9fb0097360400;
  wire                [63:0] ctl_tx_vl_marker_id10_100ge = 64'hfd6c990002936600;
  wire                [63:0] ctl_tx_vl_marker_id11_100ge = 64'hb9915500466eaa00;
  wire                [63:0] ctl_tx_vl_marker_id12_100ge = 64'h5cb9b200a3464d00;
  wire                [63:0] ctl_tx_vl_marker_id13_100ge = 64'h1af8bd00e5074200;
  wire                [63:0] ctl_tx_vl_marker_id14_100ge = 64'h83c7ca007c383500;
  wire                [63:0] ctl_tx_vl_marker_id15_100ge = 64'h3536cd00cac93200;
  wire                [63:0] ctl_tx_vl_marker_id16_100ge = 64'hc4314c003bceb300;
  wire                [63:0] ctl_tx_vl_marker_id17_100ge = 64'hadd6b70052294800;
  wire                [63:0] ctl_tx_vl_marker_id18_100ge = 64'h5f662a00a099d500;
  wire                [63:0] ctl_tx_vl_marker_id19_100ge = 64'hc0f0e5003f0f1a00;

  wire                [5:0][55:0] tx_preamble;
  reg                 [5:0][55:0] rx_preamble;
  wire                [5:0][55:0] rx_axis_preamble;

  wire [5:0]          rx_flexif_clk = {6{axis_clk}};
  wire [5:0]          tx_flexif_clk = {6{axis_clk}};

  wire                rx_macif_clk = axis_clk; 
  wire                tx_macif_clk = axis_clk;
  wire                clk_wiz_reset = 1'b0;

  dcmac_0_clk_wiz_0 i_dcmac_0_clk_wiz_0 (
    .reset      (clk_wiz_reset),
    .clk_in1	(clk_wiz_in),
    .locked     (clk_wiz_locked),
    .clk_out1	(core_clk),
    .clk_out2   (axis_clk),
    .clk_out3   (ts_clk)
  );

  //assign gt_reset_done   = gt_rx_reset_done_out[0];

  dcmac_0_syncer_reset #(
    .RESET_PIPE_LEN      (3)
  ) i_dcmac_0_gt_rx_reset_done_core_clk_syncer (
    .clk                 (core_clk),
    .reset_async         (gt_rx_reset_done_inv),
    .reset               (gt_rx_reset_done_core_clk_sync)
  );

  dcmac_0_syncer_reset #(
    .RESET_PIPE_LEN      (3)
  ) i_dcmac_0_gt_tx_reset_done_core_clk_syncer (
    .clk                 (core_clk),
    .reset_async         (gt_tx_reset_done_inv),
    .reset               (gt_tx_reset_done_core_clk_sync)
  );

  dcmac_0_syncer_reset #(
    .RESET_PIPE_LEN      (3)
  ) i_dcmac_0_gt_rx_reset_done_axis_clk_syncer (
    .clk                 (axis_clk),
    .reset_async         (gt_rx_reset_done_inv),
    .reset               (gt_rx_reset_done_axis_clk_sync)
  );

  dcmac_0_syncer_reset #(
    .RESET_PIPE_LEN      (3)
  ) i_dcmac_0_gt_tx_reset_done_axis_clk_syncer (
    .clk                 (axis_clk),
    .reset_async         (gt_tx_reset_done_inv),
    .reset               (gt_tx_reset_done_axis_clk_sync)
  );

  assign gtpowergood       = gtpowergood_0; 
  assign gt_reset_done     = gt_rx_reset_done_out[0];

  ///// Core and Serdes Resets
  assign gt_rx_reset_done_inv  = ~gt_rx_reset_done_out[0];
  assign gt_tx_reset_done_inv  = ~gt_tx_reset_done_out[0];
  ///////  Core and Serdes Clocking
  assign rx_alt_serdes_clk = {1'b0,1'b0,gt0_rx_usrclk2_0,gt0_rx_usrclk2_0,gt0_rx_usrclk2_0,gt0_rx_usrclk2_0};
  assign tx_alt_serdes_clk = {1'b0,1'b0,gt0_tx_usrclk2_0,gt0_tx_usrclk2_0,gt0_tx_usrclk2_0,gt0_tx_usrclk2_0};
  assign rx_serdes_clk     = {1'b0,1'b0,gt0_rx_usrclk_0,gt0_rx_usrclk_0,gt0_rx_usrclk_0,gt0_rx_usrclk_0}; 
  assign tx_serdes_clk     = {1'b0,1'b0,gt0_tx_usrclk_0,gt0_tx_usrclk_0,gt0_tx_usrclk_0,gt0_tx_usrclk_0}; 


  ///// Core Clocks
  assign tx_core_clk       = core_clk;
  assign rx_core_clk       = core_clk;

  ///// AXIS Clocks
  assign clk_tx_axi        = axis_clk;
  assign clk_rx_axi        = axis_clk;
  assign rstn_tx_axi       = clk_wiz_locked & ~gt_tx_reset_done_axis_clk_sync;
  assign rstn_rx_axi       = clk_wiz_locked & ~gt_rx_reset_done_axis_clk_sync;



  dcmac_0_exdes_support_wrapper i_dcmac_0_exdes_support_wrapper
  (
  .CLK_IN_D_0_clk_n(gt_ref_clk0_n),
  .CLK_IN_D_0_clk_p(gt_ref_clk0_p),
  .CLK_IN_D_1_clk_n(gt_ref_clk1_n),
  .CLK_IN_D_1_clk_p(gt_ref_clk1_p),
  .GT_Serial_grx_n(gt_rxn_in0),
  .GT_Serial_grx_p(gt_rxp_in0),
  .GT_Serial_gtx_n(gt_txn_out0),
  .GT_Serial_gtx_p(gt_txp_out0),
  .GT_Serial_1_grx_n(gt_rxn_in1),
  .GT_Serial_1_grx_p(gt_rxp_in1),
  .GT_Serial_1_gtx_n(gt_txn_out1),
  .GT_Serial_1_gtx_p(gt_txp_out1),
  .IBUFDS_ODIV2(clk_wiz_in),
  .gt_rxcdrhold(gt_rxcdrhold),
  .gt_txprecursor(gt_txprecursor),
  .gt_txpostcursor(gt_txpostcursor),
  .gt_txmaincursor(gt_txmaincursor),
  .ch0_loopback_0(gt_loopback),
  .ch0_loopback_1(gt_loopback),
  .ch0_rxrate_0(SW_REG_GT_LINE_RATE[7:0]),
  .ch0_rxrate_1(SW_REG_GT_LINE_RATE[7:0]),
  .ch0_txrate_0(SW_REG_GT_LINE_RATE[7:0]),
  .ch0_txrate_1(SW_REG_GT_LINE_RATE[7:0]),
  .ch0_tx_usr_clk2_0(gt0_tx_usrclk2_0),
  .ch0_tx_usr_clk_0(gt0_tx_usrclk_0),
  .ch0_rx_usr_clk2_0(gt0_rx_usrclk2_0),
  .ch0_rx_usr_clk_0(gt0_rx_usrclk_0),
  .ch1_loopback_0(gt_loopback),
  .ch1_loopback_1(gt_loopback),
  .ch1_rxrate_0(SW_REG_GT_LINE_RATE[15:8]),
  .ch1_rxrate_1(SW_REG_GT_LINE_RATE[15:8]),
  .ch1_txrate_0(SW_REG_GT_LINE_RATE[15:8]),
  .ch1_txrate_1(SW_REG_GT_LINE_RATE[15:8]),
  .ch2_loopback_0(gt_loopback),
  .ch2_loopback_1(gt_loopback),
  .ch2_rxrate_0(SW_REG_GT_LINE_RATE[23:16]),
  .ch2_rxrate_1(SW_REG_GT_LINE_RATE[23:16]),
  .ch2_txrate_0(SW_REG_GT_LINE_RATE[23:16]),
  .ch2_txrate_1(SW_REG_GT_LINE_RATE[23:16]),
  .ch3_loopback_0(gt_loopback),
  .ch3_loopback_1(gt_loopback),
  .ch3_rxrate_0(SW_REG_GT_LINE_RATE[31:24]),
  .ch3_rxrate_1(SW_REG_GT_LINE_RATE[31:24]),
  .ch3_txrate_0(SW_REG_GT_LINE_RATE[31:24]),
  .ch3_txrate_1(SW_REG_GT_LINE_RATE[31:24]),
  .gtpowergood_0(gtpowergood_0),
  .gtpowergood_1(gtpowergood_1),
  .ctl_port_ctl_rx_custom_vl_length_minus1(default_vl_length_200GE_or_400GE),
  .ctl_port_ctl_tx_custom_vl_length_minus1(default_vl_length_200GE_or_400GE),
  .ctl_port_ctl_vl_marker_id0(ctl_tx_vl_marker_id0_100ge),
  .ctl_port_ctl_vl_marker_id1(ctl_tx_vl_marker_id1_100ge),
  .ctl_port_ctl_vl_marker_id2(ctl_tx_vl_marker_id2_100ge),
  .ctl_port_ctl_vl_marker_id3(ctl_tx_vl_marker_id3_100ge),
  .ctl_port_ctl_vl_marker_id4(ctl_tx_vl_marker_id4_100ge),
  .ctl_port_ctl_vl_marker_id5(ctl_tx_vl_marker_id5_100ge),
  .ctl_port_ctl_vl_marker_id6(ctl_tx_vl_marker_id6_100ge),
  .ctl_port_ctl_vl_marker_id7(ctl_tx_vl_marker_id7_100ge),
  .ctl_port_ctl_vl_marker_id8(ctl_tx_vl_marker_id8_100ge),
  .ctl_port_ctl_vl_marker_id9(ctl_tx_vl_marker_id9_100ge),
  .ctl_port_ctl_vl_marker_id10(ctl_tx_vl_marker_id10_100ge),
  .ctl_port_ctl_vl_marker_id11(ctl_tx_vl_marker_id11_100ge),
  .ctl_port_ctl_vl_marker_id12(ctl_tx_vl_marker_id12_100ge),
  .ctl_port_ctl_vl_marker_id13(ctl_tx_vl_marker_id13_100ge),
  .ctl_port_ctl_vl_marker_id14(ctl_tx_vl_marker_id14_100ge),
  .ctl_port_ctl_vl_marker_id15(ctl_tx_vl_marker_id15_100ge),
  .ctl_port_ctl_vl_marker_id16(ctl_tx_vl_marker_id16_100ge),
  .ctl_port_ctl_vl_marker_id17(ctl_tx_vl_marker_id17_100ge),
  .ctl_port_ctl_vl_marker_id18(ctl_tx_vl_marker_id18_100ge),
  .ctl_port_ctl_vl_marker_id19(ctl_tx_vl_marker_id19_100ge),
  .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override(1'b0),
  .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override_value(8'd0),
  .ctl_txrx_port0_ctl_tx_send_idle_in(1'b0),
  .ctl_txrx_port0_ctl_tx_send_lfi_in(1'b0),
  .ctl_txrx_port0_ctl_tx_send_rfi_in(1'b0),
  .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override(1'b0),
  .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override_value(8'd0),
  .ctl_txrx_port1_ctl_tx_send_idle_in(1'b0),
  .ctl_txrx_port1_ctl_tx_send_lfi_in(1'b0),
  .ctl_txrx_port1_ctl_tx_send_rfi_in(1'b0),
  .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override(1'b0),
  .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override_value(8'd0),
  .ctl_txrx_port2_ctl_tx_send_idle_in(1'b0),
  .ctl_txrx_port2_ctl_tx_send_lfi_in(1'b0),
  .ctl_txrx_port2_ctl_tx_send_rfi_in(1'b0),
  .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override(1'b0),
  .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override_value(8'd0),
  .ctl_txrx_port3_ctl_tx_send_idle_in(1'b0),
  .ctl_txrx_port3_ctl_tx_send_lfi_in(1'b0),
  .ctl_txrx_port3_ctl_tx_send_rfi_in(1'b0),
  .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override(1'b0),
  .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override_value(8'd0),
  .ctl_txrx_port4_ctl_tx_send_idle_in(1'b0),
  .ctl_txrx_port4_ctl_tx_send_lfi_in(1'b0),
  .ctl_txrx_port4_ctl_tx_send_rfi_in(1'b0),
  .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override(1'b0),
  .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override_value(8'd0),
  .ctl_txrx_port5_ctl_tx_send_idle_in(1'b0),
  .ctl_txrx_port5_ctl_tx_send_lfi_in(1'b0),
  .ctl_txrx_port5_ctl_tx_send_rfi_in(1'b0),
  .gt_reset_all_in(gt_reset_all_in),
  .gpo(gt_gpo),
  .gt_reset_tx_datapath_in_0(gt_reset_tx_datapath_in_0),
  .gt_reset_rx_datapath_in_0(gt_reset_rx_datapath_in_0),
  .gt_tx_reset_done_out_0(gt_tx_reset_done_out[0]),
  .gt_rx_reset_done_out_0(gt_rx_reset_done_out[0]),
  .gt_reset_tx_datapath_in_1(gt_reset_tx_datapath_in_1),
  .gt_reset_rx_datapath_in_1(gt_reset_rx_datapath_in_1),
  .gt_tx_reset_done_out_1(gt_tx_reset_done_out[1]),
  .gt_rx_reset_done_out_1(gt_rx_reset_done_out[1]),
  .gt_reset_tx_datapath_in_2(gt_reset_tx_datapath_in_2),
  .gt_reset_rx_datapath_in_2(gt_reset_rx_datapath_in_2),
  .gt_tx_reset_done_out_2(gt_tx_reset_done_out[2]),
  .gt_rx_reset_done_out_2(gt_rx_reset_done_out[2]),
  .gt_reset_tx_datapath_in_3(gt_reset_tx_datapath_in_3),
  .gt_reset_rx_datapath_in_3(gt_reset_rx_datapath_in_3),
  .gt_tx_reset_done_out_3(gt_tx_reset_done_out[3]),
  .gt_rx_reset_done_out_3(gt_rx_reset_done_out[3]),
  .gt_reset_tx_datapath_in_4(gt_reset_tx_datapath_in_4),
  .gt_reset_rx_datapath_in_4(gt_reset_rx_datapath_in_4),
  .gt_tx_reset_done_out_4(gt_tx_reset_done_out[4]),
  .gt_rx_reset_done_out_4(gt_rx_reset_done_out[4]),
  .gt_reset_tx_datapath_in_5(gt_reset_tx_datapath_in_5),
  .gt_reset_rx_datapath_in_5(gt_reset_rx_datapath_in_5),
  .gt_tx_reset_done_out_5(gt_tx_reset_done_out[5]),
  .gt_rx_reset_done_out_5(gt_rx_reset_done_out[5]),
  .gt_reset_tx_datapath_in_6(gt_reset_tx_datapath_in_6),
  .gt_reset_rx_datapath_in_6(gt_reset_rx_datapath_in_6),
  .gt_tx_reset_done_out_6(gt_tx_reset_done_out[6]),
  .gt_rx_reset_done_out_6(gt_rx_reset_done_out[6]),
  .gt_reset_tx_datapath_in_7(gt_reset_tx_datapath_in_7),
  .gt_reset_rx_datapath_in_7(gt_reset_rx_datapath_in_7),
  .gt_tx_reset_done_out_7(gt_tx_reset_done_out[7]),
  .gt_rx_reset_done_out_7(gt_rx_reset_done_out[7]),
  .gtpowergood_in(gtpowergood),
  .ctl_rsvd_in(120'd0),
  .rsvd_in_rx_mac(8'd0),
  .rsvd_in_rx_phy(8'd0),
  .rx_all_channel_mac_pm_tick(1'b0),
  .rx_alt_serdes_clk(rx_alt_serdes_clk),
  .rx_axi_clk(clk_rx_axi),
  .rx_axis_tdata0(rx_axis_pkt.dat[0]),
  .rx_axis_tdata1(rx_axis_pkt.dat[1]),
  .rx_axis_tdata2(rx_axis_pkt.dat[2]),
  .rx_axis_tdata3(rx_axis_pkt.dat[3]),
  .rx_axis_tdata4(rx_axis_pkt.dat[4]),
  .rx_axis_tdata5(rx_axis_pkt.dat[5]),
  .rx_axis_tdata6(rx_axis_pkt.dat[6]),
  .rx_axis_tdata7(rx_axis_pkt.dat[7]),
  .rx_axis_tdata8(rx_axis_pkt.dat[8]),
  .rx_axis_tdata9(rx_axis_pkt.dat[9]),
  .rx_axis_tdata10(rx_axis_pkt.dat[10]),
  .rx_axis_tdata11(rx_axis_pkt.dat[11]),
  .rx_axis_tid(rx_axis_pkt.id),
  .rx_axis_tuser_ena0(rx_axis_pkt_ena[0]),
  .rx_axis_tuser_ena1(rx_axis_pkt_ena[1]),
  .rx_axis_tuser_ena2(rx_axis_pkt_ena[2]),
  .rx_axis_tuser_ena3(rx_axis_pkt_ena[3]),
  .rx_axis_tuser_ena4(rx_axis_pkt_ena[4]),
  .rx_axis_tuser_ena5(rx_axis_pkt_ena[5]),
  .rx_axis_tuser_ena6(rx_axis_pkt_ena[6]),
  .rx_axis_tuser_ena7(rx_axis_pkt_ena[7]),
  .rx_axis_tuser_ena8(rx_axis_pkt_ena[8]),
  .rx_axis_tuser_ena9(rx_axis_pkt_ena[9]),
  .rx_axis_tuser_ena10(rx_axis_pkt_ena[10]),
  .rx_axis_tuser_ena11(rx_axis_pkt_ena[11]),
  .rx_axis_tuser_eop0(rx_axis_pkt.eop[0]),
  .rx_axis_tuser_eop1(rx_axis_pkt.eop[1]),
  .rx_axis_tuser_eop2(rx_axis_pkt.eop[2]),
  .rx_axis_tuser_eop3(rx_axis_pkt.eop[3]),
  .rx_axis_tuser_eop4(rx_axis_pkt.eop[4]),
  .rx_axis_tuser_eop5(rx_axis_pkt.eop[5]),
  .rx_axis_tuser_eop6(rx_axis_pkt.eop[6]),
  .rx_axis_tuser_eop7(rx_axis_pkt.eop[7]),
  .rx_axis_tuser_eop8(rx_axis_pkt.eop[8]),
  .rx_axis_tuser_eop9(rx_axis_pkt.eop[9]),
  .rx_axis_tuser_eop10(rx_axis_pkt.eop[10]),
  .rx_axis_tuser_eop11(rx_axis_pkt.eop[11]),
  .rx_axis_tuser_err0(rx_axis_pkt.err[0]),
  .rx_axis_tuser_err1(rx_axis_pkt.err[1]),
  .rx_axis_tuser_err2(rx_axis_pkt.err[2]),
  .rx_axis_tuser_err3(rx_axis_pkt.err[3]),
  .rx_axis_tuser_err4(rx_axis_pkt.err[4]),
  .rx_axis_tuser_err5(rx_axis_pkt.err[5]),
  .rx_axis_tuser_err6(rx_axis_pkt.err[6]),
  .rx_axis_tuser_err7(rx_axis_pkt.err[7]),
  .rx_axis_tuser_err8(rx_axis_pkt.err[8]),
  .rx_axis_tuser_err9(rx_axis_pkt.err[9]),
  .rx_axis_tuser_err10(rx_axis_pkt.err[10]),
  .rx_axis_tuser_err11(rx_axis_pkt.err[11]),
  .rx_axis_tuser_mty0(rx_axis_pkt.mty[0]),
  .rx_axis_tuser_mty1(rx_axis_pkt.mty[1]),
  .rx_axis_tuser_mty2(rx_axis_pkt.mty[2]),
  .rx_axis_tuser_mty3(rx_axis_pkt.mty[3]),
  .rx_axis_tuser_mty4(rx_axis_pkt.mty[4]),
  .rx_axis_tuser_mty5(rx_axis_pkt.mty[5]),
  .rx_axis_tuser_mty6(rx_axis_pkt.mty[6]),
  .rx_axis_tuser_mty7(rx_axis_pkt.mty[7]),
  .rx_axis_tuser_mty8(rx_axis_pkt.mty[8]),
  .rx_axis_tuser_mty9(rx_axis_pkt.mty[9]),
  .rx_axis_tuser_mty10(rx_axis_pkt.mty[10]),
  .rx_axis_tuser_mty11(rx_axis_pkt.mty[11]),
  .rx_axis_tuser_sop0(rx_axis_pkt.sop[0]),
  .rx_axis_tuser_sop1(rx_axis_pkt.sop[1]),
  .rx_axis_tuser_sop2(rx_axis_pkt.sop[2]),
  .rx_axis_tuser_sop3(rx_axis_pkt.sop[3]),
  .rx_axis_tuser_sop4(rx_axis_pkt.sop[4]),
  .rx_axis_tuser_sop5(rx_axis_pkt.sop[5]),
  .rx_axis_tuser_sop6(rx_axis_pkt.sop[6]),
  .rx_axis_tuser_sop7(rx_axis_pkt.sop[7]),
  .rx_axis_tuser_sop8(rx_axis_pkt.sop[8]),
  .rx_axis_tuser_sop9(rx_axis_pkt.sop[9]),
  .rx_axis_tuser_sop10(rx_axis_pkt.sop[10]),
  .rx_axis_tuser_sop11(rx_axis_pkt.sop[11]),
  .rx_axis_tvalid_0(rx_axis_tvalid[0]),
  .rx_axis_tvalid_1(rx_axis_tvalid[1]),
  .rx_axis_tvalid_2(rx_axis_tvalid[2]),
  .rx_axis_tvalid_3(rx_axis_tvalid[3]),
  .rx_axis_tvalid_4(rx_axis_tvalid[4]),
  .rx_axis_tvalid_5(rx_axis_tvalid[5]),
  .rx_channel_flush(6'd0),
  .rx_core_clk(rx_core_clk),
  .rx_core_reset(rx_core_reset),
  .rx_flexif_clk(rx_flexif_clk),
  .rx_lane_aligner_fill(),
  .rx_lane_aligner_fill_start(),
  .rx_lane_aligner_fill_valid(),
  .rx_macif_clk(rx_macif_clk),
  .rx_pcs_tdm_stats_data(),
  .rx_pcs_tdm_stats_start(),
  .rx_pcs_tdm_stats_valid(),
  .rx_port_pm_rdy(),
  .rx_preambleout_0(rx_axis_preamble[0]),
  .rx_preambleout_1(rx_axis_preamble[1]),
  .rx_preambleout_2(rx_axis_preamble[2]),
  .rx_preambleout_3(rx_axis_preamble[3]),
  .rx_preambleout_4(rx_axis_preamble[4]),
  .rx_preambleout_5(rx_axis_preamble[5]),
  
  .rx_serdes_albuf_restart_0(),
  .rx_serdes_albuf_restart_1(),
  .rx_serdes_albuf_restart_2(),
  .rx_serdes_albuf_restart_3(),
  .rx_serdes_albuf_restart_4(),
  .rx_serdes_albuf_restart_5(),
  .rx_serdes_albuf_slip_0(),
  .rx_serdes_albuf_slip_1(),
  .rx_serdes_albuf_slip_2(),
  .rx_serdes_albuf_slip_3(),
  .rx_serdes_albuf_slip_4(),
  .rx_serdes_albuf_slip_5(),
  .rx_serdes_albuf_slip_6(),
  .rx_serdes_albuf_slip_7(),
  .rx_serdes_albuf_slip_8(),
  .rx_serdes_albuf_slip_9(),
  .rx_serdes_albuf_slip_10(),
  .rx_serdes_albuf_slip_11(),
  .rx_serdes_albuf_slip_12(),
  .rx_serdes_albuf_slip_13(),
  .rx_serdes_albuf_slip_14(),
  .rx_serdes_albuf_slip_15(),
  .rx_serdes_albuf_slip_16(),
  .rx_serdes_albuf_slip_17(),
  .rx_serdes_albuf_slip_18(),
  .rx_serdes_albuf_slip_19(),
  .rx_serdes_albuf_slip_20(),
  .rx_serdes_albuf_slip_21(),
  .rx_serdes_albuf_slip_22(),
  .rx_serdes_albuf_slip_23(),
  .rx_serdes_clk(rx_serdes_clk),
  .rx_serdes_fifo_flagin_0(1'b0),
  .rx_serdes_fifo_flagin_1(1'b0),
  .rx_serdes_fifo_flagin_2(1'b0),
  .rx_serdes_fifo_flagin_3(1'b0),
  .rx_serdes_fifo_flagin_4(1'b0),
  .rx_serdes_fifo_flagin_5(1'b0),
  .rx_serdes_fifo_flagout_0(),
  .rx_serdes_fifo_flagout_1(),
  .rx_serdes_fifo_flagout_2(),
  .rx_serdes_fifo_flagout_3(),
  .rx_serdes_fifo_flagout_4(),
  .rx_serdes_fifo_flagout_5(),
  .rx_serdes_reset(rx_serdes_reset),
  .rx_tsmac_tdm_stats_data(rx_tsmac_tdm_stats_data),
  .rx_tsmac_tdm_stats_id(rx_tsmac_tdm_stats_id),
  .rx_tsmac_tdm_stats_valid(rx_tsmac_tdm_stats_valid),

  //// GT APB3 ports
  .apb3clk_quad(s_axi_aclk),
  .s_axi_araddr(s_axi_araddr),
  .s_axi_arready(s_axi_arready),
  .s_axi_arvalid(s_axi_arvalid),
  .s_axi_awaddr(s_axi_awaddr),
  .s_axi_awready(s_axi_awready),
  .s_axi_awvalid(s_axi_awvalid),
  .s_axi_bready(s_axi_bready),
  .s_axi_bresp(s_axi_bresp),
  .s_axi_bvalid(s_axi_bvalid),
  .s_axi_rdata(s_axi_rdata),
  .s_axi_rready(s_axi_rready),
  .s_axi_rresp(s_axi_rresp),
  .s_axi_rvalid(s_axi_rvalid),
  .s_axi_wdata(s_axi_wdata),
  .s_axi_wready(s_axi_wready),
  .s_axi_wvalid(s_axi_wvalid),
  .s_axi_aclk(s_axi_aclk),
  .s_axi_aresetn(s_axi_aresetn),
  .ts_clk({6{ts_clk}}),
  .tx_all_channel_mac_pm_rdy(),
  .tx_all_channel_mac_pm_tick(1'b0),
  .tx_alt_serdes_clk(tx_alt_serdes_clk),
  .tx_axi_clk(clk_tx_axi),
  .tx_axis_ch_status_id(tx_axis_ch_status_id),
  .tx_axis_ch_status_skip_req(tx_axis_ch_status_skip_req),
  .tx_axis_ch_status_vld(tx_axis_ch_status_vld),
  .tx_axis_id_req(tx_axis_id_req),
  .tx_axis_id_req_vld(tx_axis_id_req_vld),
  .tx_axis_taf_0(tx_axis_af[0]),
  .tx_axis_taf_1(tx_axis_af[1]),
  .tx_axis_taf_2(tx_axis_af[2]),
  .tx_axis_taf_3(tx_axis_af[3]),
  .tx_axis_taf_4(tx_axis_af[4]),
  .tx_axis_taf_5(tx_axis_af[5]),
  .tx_axis_tdata0(tx_axis_pkt.dat[0]),
  .tx_axis_tdata1(tx_axis_pkt.dat[1]),
  .tx_axis_tdata2(tx_axis_pkt.dat[2]),
  .tx_axis_tdata3(tx_axis_pkt.dat[3]),
  .tx_axis_tdata4(tx_axis_pkt.dat[4]),
  .tx_axis_tdata5(tx_axis_pkt.dat[5]),
  .tx_axis_tdata6(tx_axis_pkt.dat[6]),
  .tx_axis_tdata7(tx_axis_pkt.dat[7]),
  .tx_axis_tdata8(tx_axis_pkt.dat[8]),
  .tx_axis_tdata9(tx_axis_pkt.dat[9]),
  .tx_axis_tdata10(tx_axis_pkt.dat[10]),
  .tx_axis_tdata11(tx_axis_pkt.dat[11]),
  .tx_axis_tid(tx_axis_pkt.id),
  .tx_axis_tready_0(tx_axis_tready[0]),
  .tx_axis_tready_1(tx_axis_tready[1]),
  .tx_axis_tready_2(tx_axis_tready[2]),
  .tx_axis_tready_3(tx_axis_tready[3]),
  .tx_axis_tready_4(tx_axis_tready[4]),
  .tx_axis_tready_5(tx_axis_tready[5]),
  .tx_axis_tuser_ena0(tx_axis_pkt.ena[0]),
  .tx_axis_tuser_ena1(tx_axis_pkt.ena[1]),
  .tx_axis_tuser_ena2(tx_axis_pkt.ena[2]),
  .tx_axis_tuser_ena3(tx_axis_pkt.ena[3]),
  .tx_axis_tuser_ena4(tx_axis_pkt.ena[4]),
  .tx_axis_tuser_ena5(tx_axis_pkt.ena[5]),
  .tx_axis_tuser_ena6(tx_axis_pkt.ena[6]),
  .tx_axis_tuser_ena7(tx_axis_pkt.ena[7]),
  .tx_axis_tuser_ena8(tx_axis_pkt.ena[8]),
  .tx_axis_tuser_ena9(tx_axis_pkt.ena[9]),
  .tx_axis_tuser_ena10(tx_axis_pkt.ena[10]),
  .tx_axis_tuser_ena11(tx_axis_pkt.ena[11]),
  .tx_axis_tuser_eop0(tx_axis_pkt.eop[0]),
  .tx_axis_tuser_eop1(tx_axis_pkt.eop[1]),
  .tx_axis_tuser_eop2(tx_axis_pkt.eop[2]),
  .tx_axis_tuser_eop3(tx_axis_pkt.eop[3]),
  .tx_axis_tuser_eop4(tx_axis_pkt.eop[4]),
  .tx_axis_tuser_eop5(tx_axis_pkt.eop[5]),
  .tx_axis_tuser_eop6(tx_axis_pkt.eop[6]),
  .tx_axis_tuser_eop7(tx_axis_pkt.eop[7]),
  .tx_axis_tuser_eop8(tx_axis_pkt.eop[8]),
  .tx_axis_tuser_eop9(tx_axis_pkt.eop[9]),
  .tx_axis_tuser_eop10(tx_axis_pkt.eop[10]),
  .tx_axis_tuser_eop11(tx_axis_pkt.eop[11]),
  .tx_axis_tuser_err0(tx_axis_pkt.err[0]),
  .tx_axis_tuser_err1(tx_axis_pkt.err[1]),
  .tx_axis_tuser_err2(tx_axis_pkt.err[2]),
  .tx_axis_tuser_err3(tx_axis_pkt.err[3]),
  .tx_axis_tuser_err4(tx_axis_pkt.err[4]),
  .tx_axis_tuser_err5(tx_axis_pkt.err[5]),
  .tx_axis_tuser_err6(tx_axis_pkt.err[6]),
  .tx_axis_tuser_err7(tx_axis_pkt.err[7]),
  .tx_axis_tuser_err8(tx_axis_pkt.err[8]),
  .tx_axis_tuser_err9(tx_axis_pkt.err[9]),
  .tx_axis_tuser_err10(tx_axis_pkt.err[10]),
  .tx_axis_tuser_err11(tx_axis_pkt.err[11]),
  .tx_axis_tuser_mty0(tx_axis_pkt.mty[0]),
  .tx_axis_tuser_mty1(tx_axis_pkt.mty[1]),
  .tx_axis_tuser_mty2(tx_axis_pkt.mty[2]),
  .tx_axis_tuser_mty3(tx_axis_pkt.mty[3]),
  .tx_axis_tuser_mty4(tx_axis_pkt.mty[4]),
  .tx_axis_tuser_mty5(tx_axis_pkt.mty[5]),
  .tx_axis_tuser_mty6(tx_axis_pkt.mty[6]),
  .tx_axis_tuser_mty7(tx_axis_pkt.mty[7]),
  .tx_axis_tuser_mty8(tx_axis_pkt.mty[8]),
  .tx_axis_tuser_mty9(tx_axis_pkt.mty[9]),
  .tx_axis_tuser_mty10(tx_axis_pkt.mty[10]),
  .tx_axis_tuser_mty11(tx_axis_pkt.mty[11]),
  .tx_axis_tuser_skip_response(tx_axis_tuser_skip_response),
  .tx_axis_tuser_sop0(tx_axis_pkt.sop[0]),
  .tx_axis_tuser_sop1(tx_axis_pkt.sop[1]),
  .tx_axis_tuser_sop2(tx_axis_pkt.sop[2]),
  .tx_axis_tuser_sop3(tx_axis_pkt.sop[3]),
  .tx_axis_tuser_sop4(tx_axis_pkt.sop[4]),
  .tx_axis_tuser_sop5(tx_axis_pkt.sop[5]),
  .tx_axis_tuser_sop6(tx_axis_pkt.sop[6]),
  .tx_axis_tuser_sop7(tx_axis_pkt.sop[7]),
  .tx_axis_tuser_sop8(tx_axis_pkt.sop[8]),
  .tx_axis_tuser_sop9(tx_axis_pkt.sop[9]),
  .tx_axis_tuser_sop10(tx_axis_pkt.sop[10]),
  .tx_axis_tuser_sop11(tx_axis_pkt.sop[11]),
  .tx_axis_tvalid_0(tx_gearbox_dout_vld[0] | tx_axi_vld_mask[0]),
  .tx_axis_tvalid_1(tx_gearbox_dout_vld[1] | tx_axi_vld_mask[1]),
  .tx_axis_tvalid_2(tx_gearbox_dout_vld[2] | tx_axi_vld_mask[2]),
  .tx_axis_tvalid_3(tx_gearbox_dout_vld[3] | tx_axi_vld_mask[3]),
  .tx_axis_tvalid_4(tx_gearbox_dout_vld[4] | tx_axi_vld_mask[4]),
  .tx_axis_tvalid_5(tx_gearbox_dout_vld[5] | tx_axi_vld_mask[5]),
  .tx_channel_flush(6'd0),
  .tx_core_clk(tx_core_clk),
  .tx_core_reset(tx_core_reset),
  .tx_flexif_clk(tx_flexif_clk),
  .tx_macif_clk(tx_macif_clk),
  .tx_pcs_tdm_stats_data(),
  .tx_pcs_tdm_stats_start(),
  .tx_pcs_tdm_stats_valid(),
  .tx_port_pm_rdy(),
  .tx_port_pm_tick(pm_tick_core),
  .rx_port_pm_tick(pm_tick_core),
  .tx_preamblein_0(tx_preamble[0]),
  .tx_preamblein_1(tx_preamble[1]),
  .tx_preamblein_2(tx_preamble[2]),
  .tx_preamblein_3(tx_preamble[3]),
  .tx_preamblein_4(tx_preamble[4]),
  .tx_preamblein_5(tx_preamble[5]),
  .tx_serdes_clk(tx_serdes_clk),
  .tx_serdes_is_am_0(tx_serdes_is_am[0]),
  .tx_serdes_is_am_1(tx_serdes_is_am[1]),
  .tx_serdes_is_am_2(tx_serdes_is_am[2]),
  .tx_serdes_is_am_3(tx_serdes_is_am[3]),
  .tx_serdes_is_am_4(tx_serdes_is_am[4]),
  .tx_serdes_is_am_5(tx_serdes_is_am[5]),
  .tx_serdes_is_am_prefifo_0(tx_serdes_is_am_prefifo[0]),
  .tx_serdes_is_am_prefifo_1(tx_serdes_is_am_prefifo[1]),
  .tx_serdes_is_am_prefifo_2(tx_serdes_is_am_prefifo[2]),
  .tx_serdes_is_am_prefifo_3(tx_serdes_is_am_prefifo[3]),
  .tx_serdes_is_am_prefifo_4(tx_serdes_is_am_prefifo[4]),
  .tx_serdes_is_am_prefifo_5(tx_serdes_is_am_prefifo[5]),
  .tx_tsmac_tdm_stats_data(tx_tsmac_tdm_stats_data),
  .tx_tsmac_tdm_stats_id(tx_tsmac_tdm_stats_id),
  .tx_tsmac_tdm_stats_valid(tx_tsmac_tdm_stats_valid),
  .c0_stat_rx_corrected_lane_delay_0(c0_stat_rx_corrected_lane_delay_0),
  .c0_stat_rx_corrected_lane_delay_1(c0_stat_rx_corrected_lane_delay_1),
  .c0_stat_rx_corrected_lane_delay_2(c0_stat_rx_corrected_lane_delay_2),
  .c0_stat_rx_corrected_lane_delay_3(c0_stat_rx_corrected_lane_delay_3),
  .c0_stat_rx_corrected_lane_delay_valid(c0_stat_rx_corrected_lane_delay_valid),
  .c1_stat_rx_corrected_lane_delay_0(c1_stat_rx_corrected_lane_delay_0),
  .c1_stat_rx_corrected_lane_delay_1(c1_stat_rx_corrected_lane_delay_1),
  .c1_stat_rx_corrected_lane_delay_2(c1_stat_rx_corrected_lane_delay_2),
  .c1_stat_rx_corrected_lane_delay_3(c1_stat_rx_corrected_lane_delay_3),
  .c1_stat_rx_corrected_lane_delay_valid(c1_stat_rx_corrected_lane_delay_valid),
  .c2_stat_rx_corrected_lane_delay_0(c2_stat_rx_corrected_lane_delay_0),
  .c2_stat_rx_corrected_lane_delay_1(c2_stat_rx_corrected_lane_delay_1),
  .c2_stat_rx_corrected_lane_delay_2(c2_stat_rx_corrected_lane_delay_2),
  .c2_stat_rx_corrected_lane_delay_3(c2_stat_rx_corrected_lane_delay_3),
  .c2_stat_rx_corrected_lane_delay_valid(c2_stat_rx_corrected_lane_delay_valid),
  .c3_stat_rx_corrected_lane_delay_0(c3_stat_rx_corrected_lane_delay_0),
  .c3_stat_rx_corrected_lane_delay_1(c3_stat_rx_corrected_lane_delay_1),
  .c3_stat_rx_corrected_lane_delay_2(c3_stat_rx_corrected_lane_delay_2),
  .c3_stat_rx_corrected_lane_delay_3(c3_stat_rx_corrected_lane_delay_3),
  .c3_stat_rx_corrected_lane_delay_valid(c3_stat_rx_corrected_lane_delay_valid),
  .c4_stat_rx_corrected_lane_delay_0(c4_stat_rx_corrected_lane_delay_0),
  .c4_stat_rx_corrected_lane_delay_1(c4_stat_rx_corrected_lane_delay_1),
  .c4_stat_rx_corrected_lane_delay_2(c4_stat_rx_corrected_lane_delay_2),
  .c4_stat_rx_corrected_lane_delay_3(c4_stat_rx_corrected_lane_delay_3),
  .c4_stat_rx_corrected_lane_delay_valid(c4_stat_rx_corrected_lane_delay_valid),
  .c5_stat_rx_corrected_lane_delay_0(c5_stat_rx_corrected_lane_delay_0),
  .c5_stat_rx_corrected_lane_delay_1(c5_stat_rx_corrected_lane_delay_1),
  .c5_stat_rx_corrected_lane_delay_2(c5_stat_rx_corrected_lane_delay_2),
  .c5_stat_rx_corrected_lane_delay_3(c5_stat_rx_corrected_lane_delay_3),
  .c5_stat_rx_corrected_lane_delay_valid(c5_stat_rx_corrected_lane_delay_valid),
  .tx_serdes_reset(tx_serdes_reset)
  );

  //------------------------------------------
  // EMU registers
  //------------------------------------------
  dcmac_0_emu_register i_dcmac_0_emu_register (
  .apb3_clk                               (clk_apb3),
  .apb3_rstn                              (rstn_apb3),
  .hard_rstn                              (rstn_hard_apb3),
  .APB_M_prdata                           (APB_M2_prdata),
  .APB_M_pready                           (APB_M2_pready),
  .APB_M_pslverr                          (APB_M2_pslverr),
  .APB_M_paddr                            (APB_M2_paddr),
  .APB_M_penable                          (APB_M2_penable),
  .APB_M_psel                             (APB_M2_psel),
  .APB_M_pwdata                           (APB_M2_pwdata),
  .APB_M_pwrite                           (APB_M2_pwrite),

  .tx_pkt_gen_ena                         (tx_pkt_gen_ena),
  .tx_pkt_gen_min_len                     (tx_pkt_gen_min_len),
  .tx_pkt_gen_max_len                     (tx_pkt_gen_max_len),
  .clear_tx_counters                      (clear_tx_counters),
  .clear_rx_counters                      (clear_rx_counters),

  .tx_pause_req                           (emu_tx_pause_req),
  .tx_resend_pause                        (emu_tx_resend_pause),
  .tx_ptp_ena                             (emu_tx_ptp_ena),
  .tx_ptp_opt                             (emu_tx_ptp_opt),
  .tx_ptp_cf_offset                       (emu_tx_ptp_cf_offset),
  .tx_ptp_upd_chksum                      (emu_tx_ptp_upd_chksum),

  .tx_macif_clk                           (tx_macif_clk),
  .tx_macif_ts_id_req_rdy                 (tx_macif_ts_id_req_rdy),
  .tx_macif_ts_id_req                     (tx_macif_ts_id_req),
  .tx_macif_ts_id_req_vld                 (tx_macif_ts_id_req_vld),

  .client_tx_frames_transmitted_latched   (tx_frames_transmitted_latched),
  .client_tx_bytes_transmitted_latched    (tx_bytes_transmitted_latched),
  .client_rx_frames_received_latched      (rx_frames_received_latched),
  .client_rx_bytes_received_latched       (rx_bytes_received_latched),
  .client_rx_preamble_err_cnt             (rx_preamble_err_cnt),
  .client_rx_prbs_locked                  (rx_prbs_locked),
  .client_rx_prbs_err                     (rx_prbs_err),

  .gearbox_unf                            (tx_gearbox_unf),
  .gearbox_ovf                            (tx_gearbox_ovf),

  .scratch                                (scratch),
  .apb3_rstn_out                          (rstn_apb3)
  );

  //------------------------------------------
  // 40-channel TDM to stats counter EMU
  //------------------------------------------
  // synthesis translate_off
  reg                [55:0] tx_tsmac_tdm_stats_data_reg;
  reg                [5:0] tx_tsmac_tdm_stats_id_reg;
  reg                tx_tsmac_tdm_stats_valid_reg;
  reg                [78:0] rx_tsmac_tdm_stats_data_reg;
  reg                [5:0] rx_tsmac_tdm_stats_id_reg;
  reg                rx_tsmac_tdm_stats_valid_reg;

  always @(posedge clk_tx_axi) begin
    tx_tsmac_tdm_stats_valid_reg <= tx_tsmac_tdm_stats_valid;
    tx_tsmac_tdm_stats_id_reg    <= tx_tsmac_tdm_stats_id   ;
    tx_tsmac_tdm_stats_data_reg  <= tx_tsmac_tdm_stats_data ;
  end

  always @(posedge clk_rx_axi) begin
    rx_tsmac_tdm_stats_valid_reg <= rx_tsmac_tdm_stats_valid;
    rx_tsmac_tdm_stats_id_reg    <= rx_tsmac_tdm_stats_id   ;
    rx_tsmac_tdm_stats_data_reg  <= rx_tsmac_tdm_stats_data ;
  end

  dcmac_0_mac_tx_stats_cnt i_dcmac_0_mac_tx_stats_cnt (
    // status interface
    .stats_clk                  (clk_tx_axi),
    .stats_rst                  (~rstn_tx_axi),
    .ts_rst_id                  ('0),
    .ts_rst                     ('0),
    .i_tdm_stats_valid          (tx_tsmac_tdm_stats_valid_reg),
    .i_tdm_stats_id             (tx_tsmac_tdm_stats_id_reg),
    .i_tdm_stats                (tx_tsmac_tdm_stats_data_reg),
    // APB3 interface
    .apb3_clk                   (clk_apb3),
    .apb3_rstn                  (rstn_apb3),
    .hard_rstn                  (rstn_hard_apb3),
    .APB_M_prdata               (APB_M3_prdata),
    .APB_M_pready               (APB_M3_pready),
    .APB_M_pslverr              (APB_M3_pslverr),
    .APB_M_paddr                (APB_M3_paddr),
    .APB_M_penable              (APB_M3_penable),
    .APB_M_psel                 (APB_M3_psel),
    .APB_M_pwdata               (APB_M3_pwdata),
    .APB_M_pwrite               (APB_M3_pwrite),
    // from the other APB3
    .i_pm_tick                  (clear_tx_counters)
  );

  dcmac_0_mac_rx_stats_cnt i_dcmac_0_mac_rx_stats_cnt (
    // status interface
    .stats_clk                  (clk_rx_axi),
    .stats_rst                  (~rstn_rx_axi),
    .ts_rst_id                  ('0),
    .ts_rst                     ('0),
    .i_tdm_stats_valid          (rx_tsmac_tdm_stats_valid_reg),
    .i_tdm_stats_id             (rx_tsmac_tdm_stats_id_reg),
    .i_tdm_stats                (rx_tsmac_tdm_stats_data_reg),
    // APB3 interface
    .apb3_clk                   (clk_apb3),
    .apb3_rstn                  (rstn_apb3),
    .hard_rstn                  (rstn_hard_apb3),
    .APB_M_prdata               (APB_M4_prdata),
    .APB_M_pready               (APB_M4_pready),
    .APB_M_pslverr              (APB_M4_pslverr),
    .APB_M_paddr                (APB_M4_paddr),
    .APB_M_penable              (APB_M4_penable),
    .APB_M_psel                 (APB_M4_psel),
    .APB_M_pwdata               (APB_M4_pwdata),
    .APB_M_pwrite               (APB_M4_pwrite),
    // from the other APB3
    .i_pm_tick                  (clear_rx_counters)
  );
  // synthesis translate_on

  //------------------------------------------
  // TX packet gen
  //------------------------------------------
  dcmac_0_axis_pkt_gen_ts #(
    .COUNTER_MODE (COUNTER_MODE)
  ) i_dcmac_0_axis_pkt_gen_ts (
    .clk              (clk_tx_axi),
    .rst              (~rstn_tx_axi),
    .i_pkt_ena        (tx_pkt_gen_ena),
    .i_clear_counters (clear_tx_counters[5:0]),
    .i_min_len        (tx_pkt_gen_min_len),
    .i_max_len        (tx_pkt_gen_max_len),
    .i_req_id         (pkt_gen_id_req[2:0]),
    .i_req_id_vld     (pkt_gen_id_req_vld),
    .i_skip_id        (tx_axis_ch_status_id[2:0]),
    .i_skip           (1'b0),
    .i_af             (tx_gearbox_af),
    .o_skip_response  (tx_axis_tuser_skip_response),
    .o_pkt            (tx_gen_axis_pkt),
    .o_pkt_vld        (tx_axis_pkt_valid),
    .o_pkt_cnt        (tx_frames_transmitted_latched),
    .o_byte_cnt       (tx_bytes_transmitted_latched)
  );

  //------------------------------------------
  // TX gearbox
  //------------------------------------------
  wire [5:0]      tx_gearbox_rst, rx_gearbox_rst;
  wire [2:0]      fixe_req_id;

  dcmac_0_core_sniffer i_dcmac_0_core_sniffer (
    .clk_apb3              (clk_apb3),
    .rstn_apb3             (rstn_apb3),
    .clk_tx_axi            (clk_tx_axi),
    .i_disable_tvalid_mask (scratch[3]),
    .i_wait_time           (4'd5),
    .i_set_time            (4'd10),
    //.apb3_wr_ena           (APB_M_penable & APB_M_psel & APB_M_pwrite),
    //.apb3_wr_addr          (APB_M_paddr),
    //.apb3_wr_dat           (APB_M_pwdata),
    .apb3_wr_ena           (s_axi_wvalid),
    .apb3_wr_addr          (s_axi_awaddr),
    .apb3_wr_dat           (s_axi_wdata),	
    .o_independent_mode    (independent_mode),
    .o_emu_tx_rst          (tx_gearbox_rst),
    .o_emu_rx_rst          (rx_gearbox_rst),
    .o_data_rate           (client_data_rate),
    .o_tx_axi_vld_mask     (tx_axi_vld_mask),
    .o_tx_axi_req_id       (fixe_req_id)
  );

  dcmac_0_emu_gearbox_tx #(
    .REGISTER_INPUT (1)
  ) i_dcmac_0_emu_gearbox_tx (
   .clk              (clk_tx_axi),
   .rst              (tx_gearbox_rst | {6{independent_mode}}),
   .i_pkt_ena        (tx_pkt_gen_ena[5:0]),
   .i_data_rate      (client_data_rate),
   .i_skip_response  (tx_axis_tuser_skip_response),
   .i_pkt            (tx_gen_axis_pkt),
   .i_tready         (tx_axis_tready),
   .o_af             (tx_gearbox_af),
   .o_vld            (tx_gearbox_dout_vld),
   .o_slice          (tx_gearbox_slice),
   .o_preamble       (tx_preamble),
   .o_underflow      (tx_gearbox_unf), // latched, cleared by rst
   .o_overflow       (tx_gearbox_ovf)  // latched, cleared by rst
  );

  assign pkt_gen_id_req = {3'd0, fixe_req_id};
  assign pkt_gen_id_req_vld = 1'b1;

  always @* begin
    for (int i=0; i<6; i++) begin
      {tx_axis_pkt.ena[i*2+1], tx_axis_pkt.ena[i*2]} = tx_gearbox_slice[i].ena;
      {tx_axis_pkt.sop[i*2+1], tx_axis_pkt.sop[i*2]} = tx_gearbox_slice[i].sop;
      {tx_axis_pkt.eop[i*2+1], tx_axis_pkt.eop[i*2]} = tx_gearbox_slice[i].eop;
      {tx_axis_pkt.err[i*2+1], tx_axis_pkt.err[i*2]} = tx_gearbox_slice[i].err;
      {tx_axis_pkt.mty[i*2+1], tx_axis_pkt.mty[i*2]} = tx_gearbox_slice[i].mty;
      {tx_axis_pkt.dat[i*2+1], tx_axis_pkt.dat[i*2]} = tx_gearbox_slice[i].dat;
    end
  end

  //------------------------------------------
  // SERDES TX to RX loopback
  //------------------------------------------
  //assign rx_serdes_data = tx_serdes_data;

  //------------------------------------------
  // RX gearbox
  //------------------------------------------
  assign rx_axis_pkt.ena = (rx_axis_tvalid[0] | !independent_mode)? rx_axis_pkt_ena : '0;


  reg [5:0] rx_gearbox_valid;

  always @(posedge clk_rx_axi) begin

    //if (scratch[1]) begin
    //  rx_gearbox_valid <= '1;
    //  rx_preamble <= tx_preamble;
    //  for (int i=0; i<6; i++) begin
    //    rx_gearbox_slice[i].ena <= tx_gearbox_slice[i].ena;
    //    rx_gearbox_slice[i].sop <= tx_gearbox_slice[i].sop;
    //    rx_gearbox_slice[i].eop <= tx_gearbox_slice[i].eop;
    //    rx_gearbox_slice[i].err <= tx_gearbox_slice[i].err;
    //    rx_gearbox_slice[i].mty <= tx_gearbox_slice[i].mty;
    //    rx_gearbox_slice[i].dat <= tx_gearbox_slice[i].dat;
    //  end
    //end
    //else begin
      rx_gearbox_valid <= rx_axis_tvalid;
      rx_preamble <= rx_axis_preamble;
      for (int i=0; i<6; i++) begin
        rx_gearbox_slice[i].ena <= {rx_axis_pkt.ena[i*2+1], rx_axis_pkt.ena[i*2]};
        rx_gearbox_slice[i].sop <= {rx_axis_pkt.sop[i*2+1], rx_axis_pkt.sop[i*2]};
        rx_gearbox_slice[i].eop <= {rx_axis_pkt.eop[i*2+1], rx_axis_pkt.eop[i*2]};
        rx_gearbox_slice[i].err <= {rx_axis_pkt.err[i*2+1], rx_axis_pkt.err[i*2]};
        rx_gearbox_slice[i].mty <= {rx_axis_pkt.mty[i*2+1], rx_axis_pkt.mty[i*2]};
        rx_gearbox_slice[i].dat <= {rx_axis_pkt.dat[i*2+1], rx_axis_pkt.dat[i*2]};
      end
    //end
  end


  dcmac_0_emu_gearbox_rx  i_dcmac_0_emu_gearbox_rx (
    .clk                 (clk_rx_axi),
    .rst                 (rx_gearbox_rst | {6{independent_mode}}),
    .i_clear_counters    (clear_rx_counters[5:0]),
    .i_data_rate         (client_data_rate),
    .i_valid             (rx_gearbox_valid),
    .i_slice             (rx_gearbox_slice),
    .i_preamble          (rx_preamble),
    .o_preamble_err_cnt  (rx_preamble_err_cnt),
    .o_pkt               (rx_gearbox_o_pkt)
  );

  always @(posedge clk_rx_axi) begin
    //if (scratch[0]) begin
    //  rx_axis_pkt_mon.id   <= tx_gen_axis_pkt.id;
    //  rx_axis_pkt_mon.ena  <= tx_gen_axis_pkt.ena;
    //  rx_axis_pkt_mon.sop  <= tx_gen_axis_pkt.sop;
    //  rx_axis_pkt_mon.eop  <= tx_gen_axis_pkt.eop;
    //  rx_axis_pkt_mon.err  <= tx_gen_axis_pkt.err;
    //  rx_axis_pkt_mon.mty  <= tx_gen_axis_pkt.mty;
    //  rx_axis_pkt_mon.dat  <= tx_gen_axis_pkt.dat;
    //end
    //else begin
      rx_axis_pkt_mon <= rx_gearbox_o_pkt;
    //end
  end

  //------------------------------------------
  // RX packet mon
  //------------------------------------------
  dcmac_0_axis_pkt_mon_ts #(
    .COUNTER_MODE  (COUNTER_MODE)
  ) i_dcmac_0_axis_pkt_mon_ts (
    .clk                   (clk_rx_axi),
    .rst                   (~rstn_rx_axi),
    .port_rst              (rx_gearbox_rst),
    .i_pkt                 (rx_axis_pkt_mon),
    .i_clear_counters      (clear_rx_counters[5:0]),
    .o_pkt_cnt             (rx_frames_received_latched),
    .o_byte_cnt            (rx_bytes_received_latched),
    .o_prbs_locked         (rx_prbs_locked),
    .o_prbs_err_cnt        (rx_prbs_err)
  );


endmodule

