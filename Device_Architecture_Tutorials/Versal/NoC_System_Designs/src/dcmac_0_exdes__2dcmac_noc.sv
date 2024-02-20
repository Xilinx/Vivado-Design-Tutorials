// ------------------------------------------------------------------------------
//   (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
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
    input wire [31 : 0]   s_axi_0_awaddr,
    input wire            s_axi_0_awvalid,
    output wire           s_axi_0_awready,
    input wire [31 : 0]   s_axi_0_wdata,
    input wire            s_axi_0_wvalid,
    output wire           s_axi_0_wready,
    output wire [1 : 0]   s_axi_0_bresp,
    output wire           s_axi_0_bvalid,
    input wire            s_axi_0_bready,
    input wire [31 : 0]   s_axi_0_araddr,
    input wire            s_axi_0_arvalid,
    output wire           s_axi_0_arready,
    output wire [31 : 0]  s_axi_0_rdata,
    output wire [1 : 0]   s_axi_0_rresp,
    output wire           s_axi_0_rvalid,
    input wire            s_axi_0_rready,
    input wire [31 : 0]   s_axi_1_awaddr,
    input wire            s_axi_1_awvalid,
    output wire           s_axi_1_awready,
    input wire [31 : 0]   s_axi_1_wdata,
    input wire            s_axi_1_wvalid,
    output wire           s_axi_1_wready,
    output wire [1 : 0]   s_axi_1_bresp,
    output wire           s_axi_1_bvalid,
    input wire            s_axi_1_bready,
    input wire [31 : 0]   s_axi_1_araddr,
    input wire            s_axi_1_arvalid,
    output wire           s_axi_1_arready,
    output wire [31 : 0]  s_axi_1_rdata,
    output wire [1 : 0]   s_axi_1_rresp,
    output wire           s_axi_1_rvalid,
    input wire            s_axi_1_rready,
    input  wire [3:0] gt0_rxn_in0,
    input  wire [3:0] gt0_rxp_in0,
    output wire [3:0] gt0_txn_out0,
    output wire [3:0] gt0_txp_out0,
    input  wire [3:0] gt0_rxn_in1,
    input  wire [3:0] gt0_rxp_in1,
    output wire [3:0] gt0_txn_out1,
    output wire [3:0] gt0_txp_out1,
    input  wire [3:0] gt1_rxn_in0,
    input  wire [3:0] gt1_rxp_in0,
    output wire [3:0] gt1_txn_out0,
    output wire [3:0] gt1_txp_out0,
    input  wire [3:0] gt1_rxn_in1,
    input  wire [3:0] gt1_rxp_in1,
    output wire [3:0] gt1_txn_out1,
    output wire [3:0] gt1_txp_out1,

    input  wire       gt_reset_all_in,
    output wire [31:0] gt_gpo0,
    output wire [31:0] gt_gpo1,
    output wire       gt_reset_done0,
    output wire       gt_reset_done1,
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
    output wire [23:0] gt_tx_reset_done_out0,
    output wire [23:0] gt_rx_reset_done_out0,
    output wire [23:0] gt_tx_reset_done_out1,
    output wire [23:0] gt_rx_reset_done_out1,
    output wire        gt_tx_reset_core0,
    output wire        gt_rx_reset_core0,
    output wire        gt_tx_reset_core1,
    output wire        gt_rx_reset_core1,
    input  wire       gt0_ref_clk0_p,
    input  wire       gt0_ref_clk0_n,
    input  wire       gt0_ref_clk1_p,
    input  wire       gt0_ref_clk1_n,
    input  wire       gt1_ref_clk0_p,
    input  wire       gt1_ref_clk0_n,
    input  wire       gt1_ref_clk1_p,
    input  wire       gt1_ref_clk1_n,
    input  wire [8-1:0] gt_reset_tx_datapath_in0,
    input  wire [8-1:0] gt_reset_rx_datapath_in0,
    input  wire [8-1:0] gt_reset_tx_datapath_in1,
    input  wire [8-1:0] gt_reset_rx_datapath_in1,
    input  wire       init_clk
);

    // Handy defines
    //   axiseg_s -> inputs
    //   axiseg_m -> outputs
    `define SEG_S_PORT(SegNum) \
        .axiseg_s``SegNum``_tdata       ( pkt_noc_in.dat[``SegNum``]  ),   \
        .axiseg_s``SegNum``_tuser_ena   ( pkt_noc_in.ena[``SegNum``]  ),   \
        .axiseg_s``SegNum``_tuser_sop   ( pkt_noc_in.sop[``SegNum``]  ),   \
        .axiseg_s``SegNum``_tuser_eop   ( pkt_noc_in.eop[``SegNum``]  ),   \
        .axiseg_s``SegNum``_tuser_err   ( pkt_noc_in.err[``SegNum``]  ),   \
        .axiseg_s``SegNum``_tuser_mty   ( pkt_noc_in.mty[``SegNum``]  )

    `define SEG_M_PORT(SegNum) \
        .axiseg_m``SegNum``_tdata       ( pkt_noc_out.dat[``SegNum``]  ),   \
        .axiseg_m``SegNum``_tuser_ena   ( pkt_noc_out.ena[``SegNum``]  ),   \
        .axiseg_m``SegNum``_tuser_sop   ( pkt_noc_out.sop[``SegNum``]  ),   \
        .axiseg_m``SegNum``_tuser_eop   ( pkt_noc_out.eop[``SegNum``]  ),   \
        .axiseg_m``SegNum``_tuser_err   ( pkt_noc_out.err[``SegNum``]  ),   \
        .axiseg_m``SegNum``_tuser_mty   ( pkt_noc_out.mty[``SegNum``]  )


  //parameter DEVICE_NAME  = "VERSAL_PREMIUM_ES1";
  parameter COUNTER_MODE = 0;

  parameter NUM_DCMACS = 2;
  parameter DCMAC0 = 0;
  parameter DCMAC1 = 1;


  // For other GT loopback options, please program the value thru CIPS appropriately.
  // For GT Near-end PCS loopback, update the GT loopback value to 3'd1. Drive gt_loopback = 3'b001.
  // For GT External loopback, update the GT loopback value to 3'd0. Drive gt_loopback = 3'b000.
  // For more information & settings on loopback, refer versal GT Transceivers user guide.
  wire  [31:0]   SW_REG_GT_LINE_RATE;
  assign SW_REG_GT_LINE_RATE = {gt_line_rate,gt_line_rate,gt_line_rate,gt_line_rate};

  //wire           gt_rxcdrhold;
  //assign gt_rxcdrhold = (gt_loopback == 3'b001)? 1'b1 : 1'b0;
  ////////////
  wire           tx_core_clk__DCMAC0, tx_core_clk__DCMAC1;
  wire           rx_core_clk__DCMAC0, rx_core_clk__DCMAC1;
  wire [5:0]     rx_serdes_clk__DCMAC0, rx_serdes_clk__DCMAC1;
  wire [5:0]     tx_serdes_clk__DCMAC0, tx_serdes_clk__DCMAC1;
  wire [5:0]     rx_alt_serdes_clk__DCMAC0, rx_alt_serdes_clk__DCMAC1;
  wire [5:0]     tx_alt_serdes_clk__DCMAC0, tx_alt_serdes_clk__DCMAC1;
  wire           ts_clk__DCMAC0, ts_clk__DCMAC1;


  wire           gt_tx_usrclk_0__DCMAC0, gt_tx_usrclk_0__DCMAC1;
  wire           gt_tx_usrclk2_0__DCMAC0, gt_tx_usrclk2_0__DCMAC1;
  wire           gt_rx_usrclk2_0__DCMAC0, gt_rx_usrclk2_0__DCMAC1;
  wire           gt_rx_usrclk_0__DCMAC0, gt_rx_usrclk_0__DCMAC1;

  wire           gt_reset_tx_datapath_in_0__DCMAC0, gt_reset_tx_datapath_in_0__DCMAC1;
  wire           gt_reset_rx_datapath_in_0__DCMAC0, gt_reset_rx_datapath_in_0__DCMAC1;
  wire           gt_reset_tx_datapath_in_1__DCMAC0, gt_reset_tx_datapath_in_1__DCMAC1;
  wire           gt_reset_rx_datapath_in_1__DCMAC0, gt_reset_rx_datapath_in_1__DCMAC1;
  wire           gt_reset_tx_datapath_in_2__DCMAC0, gt_reset_tx_datapath_in_2__DCMAC1;
  wire           gt_reset_rx_datapath_in_2__DCMAC0, gt_reset_rx_datapath_in_2__DCMAC1;
  wire           gt_reset_tx_datapath_in_3__DCMAC0, gt_reset_tx_datapath_in_3__DCMAC1;
  wire           gt_reset_rx_datapath_in_3__DCMAC0, gt_reset_rx_datapath_in_3__DCMAC1;
  wire           gt_reset_tx_datapath_in_4__DCMAC0, gt_reset_tx_datapath_in_4__DCMAC1;
  wire           gt_reset_rx_datapath_in_4__DCMAC0, gt_reset_rx_datapath_in_4__DCMAC1;
  wire           gt_reset_tx_datapath_in_5__DCMAC0, gt_reset_tx_datapath_in_5__DCMAC1;
  wire           gt_reset_rx_datapath_in_5__DCMAC0, gt_reset_rx_datapath_in_5__DCMAC1;
  wire           gt_reset_tx_datapath_in_6__DCMAC0, gt_reset_tx_datapath_in_6__DCMAC1;
  wire           gt_reset_rx_datapath_in_6__DCMAC0, gt_reset_rx_datapath_in_6__DCMAC1;
  wire           gt_reset_tx_datapath_in_7__DCMAC0, gt_reset_tx_datapath_in_7__DCMAC1;
  wire           gt_reset_rx_datapath_in_7__DCMAC0, gt_reset_rx_datapath_in_7__DCMAC1;
  assign         gt_reset_tx_datapath_in_0__DCMAC0 = gt_reset_tx_datapath_in0[0];
  assign         gt_reset_rx_datapath_in_0__DCMAC0 = gt_reset_rx_datapath_in0[0];
  assign         gt_reset_tx_datapath_in_1__DCMAC0 = gt_reset_tx_datapath_in0[1];
  assign         gt_reset_rx_datapath_in_1__DCMAC0 = gt_reset_rx_datapath_in0[1];
  assign         gt_reset_tx_datapath_in_2__DCMAC0 = gt_reset_tx_datapath_in0[2];
  assign         gt_reset_rx_datapath_in_2__DCMAC0 = gt_reset_rx_datapath_in0[2];
  assign         gt_reset_tx_datapath_in_3__DCMAC0 = gt_reset_tx_datapath_in0[3];
  assign         gt_reset_rx_datapath_in_3__DCMAC0 = gt_reset_rx_datapath_in0[3];
  assign         gt_reset_tx_datapath_in_4__DCMAC0 = gt_reset_tx_datapath_in0[4];
  assign         gt_reset_rx_datapath_in_4__DCMAC0 = gt_reset_rx_datapath_in0[4];
  assign         gt_reset_tx_datapath_in_5__DCMAC0 = gt_reset_tx_datapath_in0[5];
  assign         gt_reset_rx_datapath_in_5__DCMAC0 = gt_reset_rx_datapath_in0[5];
  assign         gt_reset_tx_datapath_in_6__DCMAC0 = gt_reset_tx_datapath_in0[6];
  assign         gt_reset_rx_datapath_in_6__DCMAC0 = gt_reset_rx_datapath_in0[6];
  assign         gt_reset_tx_datapath_in_7__DCMAC0 = gt_reset_tx_datapath_in0[7];
  assign         gt_reset_rx_datapath_in_7__DCMAC0 = gt_reset_rx_datapath_in0[7];
  assign         gt_reset_tx_datapath_in_0__DCMAC1 = gt_reset_tx_datapath_in1[0];
  assign         gt_reset_rx_datapath_in_0__DCMAC1 = gt_reset_rx_datapath_in1[0];
  assign         gt_reset_tx_datapath_in_1__DCMAC1 = gt_reset_tx_datapath_in1[1];
  assign         gt_reset_rx_datapath_in_1__DCMAC1 = gt_reset_rx_datapath_in1[1];
  assign         gt_reset_tx_datapath_in_2__DCMAC1 = gt_reset_tx_datapath_in1[2];
  assign         gt_reset_rx_datapath_in_2__DCMAC1 = gt_reset_rx_datapath_in1[2];
  assign         gt_reset_tx_datapath_in_3__DCMAC1 = gt_reset_tx_datapath_in1[3];
  assign         gt_reset_rx_datapath_in_3__DCMAC1 = gt_reset_rx_datapath_in1[3];
  assign         gt_reset_tx_datapath_in_4__DCMAC1 = gt_reset_tx_datapath_in1[4];
  assign         gt_reset_rx_datapath_in_4__DCMAC1 = gt_reset_rx_datapath_in1[4];
  assign         gt_reset_tx_datapath_in_5__DCMAC1 = gt_reset_tx_datapath_in1[5];
  assign         gt_reset_rx_datapath_in_5__DCMAC1 = gt_reset_rx_datapath_in1[5];
  assign         gt_reset_tx_datapath_in_6__DCMAC1 = gt_reset_tx_datapath_in1[6];
  assign         gt_reset_rx_datapath_in_6__DCMAC1 = gt_reset_rx_datapath_in1[6];
  assign         gt_reset_tx_datapath_in_7__DCMAC1 = gt_reset_tx_datapath_in1[7];
  assign         gt_reset_rx_datapath_in_7__DCMAC1 = gt_reset_rx_datapath_in1[7];
  wire           gtpowergood_0__DCMAC0, gtpowergood_0__DCMAC1;
  wire           gtpowergood_1__DCMAC0, gtpowergood_1__DCMAC1;
  wire           gt_rx_reset_done_inv__DCMAC0, gt_rx_reset_done_inv__DCMAC1;
  wire           gt_tx_reset_done_inv__DCMAC0, gt_tx_reset_done_inv__DCMAC1;
  wire           gt_rx_reset_done_core_clk_sync__DCMAC0, gt_rx_reset_done_core_clk_sync__DCMAC1;
  wire           gt_tx_reset_done_core_clk_sync__DCMAC0, gt_tx_reset_done_core_clk_sync__DCMAC1;
  wire           gt_rx_reset_done_axis_clk_sync__DCMAC0, gt_rx_reset_done_axis_clk_sync__DCMAC1;
  wire           gt_tx_reset_done_axis_clk_sync__DCMAC0, gt_tx_reset_done_axis_clk_sync__DCMAC1;
  wire           gtpowergood__DCMAC0, gtpowergood__DCMAC1;
  wire [5:0]     pm_tick_core = {6{1'b0}};
  wire           core_clk__DCMAC0, core_clk__DCMAC1;
  wire           axis_clk__DCMAC0, axis_clk__DCMAC1;
  wire           clk_wiz_in__DCMAC0, clk_wiz_in__DCMAC1;
  wire           clk_wiz_locked__DCMAC0, clk_wiz_locked__DCMAC1;
  wire           clk_tx_axi__DCMAC0, clk_tx_axi__DCMAC1;
  wire           clk_rx_axi__DCMAC0, clk_rx_axi__DCMAC1;
  wire           rstn_tx_axi__DCMAC0, rstn_tx_axi__DCMAC1;
  wire           rstn_rx_axi__DCMAC0, rstn_rx_axi__DCMAC1;
  wire           [5:0] tx_serdes_is_am;
  wire           [5:0] tx_serdes_is_am_prefifo;
  wire           clk_apb3;
  wire           rstn_hard_apb3;

  assign clk_apb3       = s_axi_aclk;
  assign rstn_hard_apb3 = s_axi_aresetn;

assign gt_tx_reset_core0 = gt_tx_reset_done_inv__DCMAC0; 
assign gt_rx_reset_core0 = gt_rx_reset_done_inv__DCMAC0;

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


  axis_tx_pkt_t    tx_gen_axis_pkt__DCMAC0, tx_gen_axis_pkt__DCMAC1;
  axis_tx_pkt_t    tx_axis_pkt__DCMAC0, tx_axis_pkt__DCMAC1;
  wire             tx_axis_pkt_valid;
  axis_rx_pkt_t    rx_axis_pkt__DCMAC0, rx_axis_pkt__DCMAC1;
  axis_rx_pkt_t    rx_axis_pkt_mon;
  wire             [11:0] rx_axis_pkt_ena__DCMAC0, rx_axis_pkt_ena__DCMAC1;
  wire             [5:0] rx_axis_tvalid__DCMAC0, rx_axis_tvalid__DCMAC1;

  wire             [55:0] tx_tsmac_tdm_stats_data__DCMAC0, tx_tsmac_tdm_stats_data__DCMAC1;
  wire             [5:0] tx_tsmac_tdm_stats_id__DCMAC0, tx_tsmac_tdm_stats_id__DCMAC1;
  wire             tx_tsmac_tdm_stats_valid__DCMAC0, tx_tsmac_tdm_stats_valid__DCMAC1;
  wire             [78:0] rx_tsmac_tdm_stats_data__DCMAC0, rx_tsmac_tdm_stats_data__DCMAC1;
  wire             [5:0] rx_tsmac_tdm_stats_id__DCMAC0, rx_tsmac_tdm_stats_id__DCMAC1;
  wire             rx_tsmac_tdm_stats_valid__DCMAC0, rx_tsmac_tdm_stats_valid__DCMAC1;

  wire [15:0]      c0_stat_rx_corrected_lane_delay_0__DCMAC0, c0_stat_rx_corrected_lane_delay_0__DCMAC1;
  wire [15:0]      c0_stat_rx_corrected_lane_delay_1__DCMAC0, c0_stat_rx_corrected_lane_delay_1__DCMAC1;
  wire [15:0]      c0_stat_rx_corrected_lane_delay_2__DCMAC0, c0_stat_rx_corrected_lane_delay_2__DCMAC1;
  wire [15:0]      c0_stat_rx_corrected_lane_delay_3__DCMAC0, c0_stat_rx_corrected_lane_delay_3__DCMAC1;
  wire             c0_stat_rx_corrected_lane_delay_valid__DCMAC0, c0_stat_rx_corrected_lane_delay_valid__DCMAC1;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_0__DCMAC0, c1_stat_rx_corrected_lane_delay_0__DCMAC1;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_1__DCMAC0, c1_stat_rx_corrected_lane_delay_1__DCMAC1;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_2__DCMAC0, c1_stat_rx_corrected_lane_delay_2__DCMAC1;
  wire [15:0]      c1_stat_rx_corrected_lane_delay_3__DCMAC0, c1_stat_rx_corrected_lane_delay_3__DCMAC1;
  wire             c1_stat_rx_corrected_lane_delay_valid__DCMAC0, c1_stat_rx_corrected_lane_delay_valid__DCMAC1;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_0__DCMAC0, c2_stat_rx_corrected_lane_delay_0__DCMAC1;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_1__DCMAC0, c2_stat_rx_corrected_lane_delay_1__DCMAC1;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_2__DCMAC0, c2_stat_rx_corrected_lane_delay_2__DCMAC1;
  wire [15:0]      c2_stat_rx_corrected_lane_delay_3__DCMAC0, c2_stat_rx_corrected_lane_delay_3__DCMAC1;
  wire             c2_stat_rx_corrected_lane_delay_valid__DCMAC0, c2_stat_rx_corrected_lane_delay_valid__DCMAC1;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_0__DCMAC0, c3_stat_rx_corrected_lane_delay_0__DCMAC1;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_1__DCMAC0, c3_stat_rx_corrected_lane_delay_1__DCMAC1;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_2__DCMAC0, c3_stat_rx_corrected_lane_delay_2__DCMAC1;
  wire [15:0]      c3_stat_rx_corrected_lane_delay_3__DCMAC0, c3_stat_rx_corrected_lane_delay_3__DCMAC1;
  wire             c3_stat_rx_corrected_lane_delay_valid__DCMAC0, c3_stat_rx_corrected_lane_delay_valid__DCMAC1;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_0__DCMAC0, c4_stat_rx_corrected_lane_delay_0__DCMAC1;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_1__DCMAC0, c4_stat_rx_corrected_lane_delay_1__DCMAC1;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_2__DCMAC0, c4_stat_rx_corrected_lane_delay_2__DCMAC1;
  wire [15:0]      c4_stat_rx_corrected_lane_delay_3__DCMAC0, c4_stat_rx_corrected_lane_delay_3__DCMAC1;
  wire             c4_stat_rx_corrected_lane_delay_valid__DCMAC0, c4_stat_rx_corrected_lane_delay_valid__DCMAC1;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_0__DCMAC0, c5_stat_rx_corrected_lane_delay_0__DCMAC1;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_1__DCMAC0, c5_stat_rx_corrected_lane_delay_1__DCMAC1;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_2__DCMAC0, c5_stat_rx_corrected_lane_delay_2__DCMAC1;
  wire [15:0]      c5_stat_rx_corrected_lane_delay_3__DCMAC0, c5_stat_rx_corrected_lane_delay_3__DCMAC1;
  wire             c5_stat_rx_corrected_lane_delay_valid__DCMAC0, c5_stat_rx_corrected_lane_delay_valid__DCMAC1;

  // Pause insertion
  wire                [5:0] emu_tx_resend_pause;
  wire                [5:0][8:0] emu_tx_pause_req;

  // PTP enable
  wire                [1:0]   emu_tx_ptp_opt;
  wire                [11:0]  emu_tx_ptp_cf_offset;
  wire                        emu_tx_ptp_upd_chksum;
  wire                [5:0]   emu_tx_ptp_ena;

  logic               independent_mode__DCMAC0, independent_mode__DCMAC1;
  wire                [5:0] tx_axi_vld_mask__DCMAC0, tx_axi_vld_mask__DCMAC1;
  wire                [5:0] tx_gearbox_af__DCMAC0, tx_gearbox_af__DCMAC1;
  wire                [5:0] tx_gearbox_dout_vld__DCMAC0, tx_gearbox_dout_vld__DCMAC1;
  wire                [5:0] tx_axis_tready__DCMAC0, tx_axis_tready__DCMAC1;
  wire                [5:0] tx_axis_af__DCMAC0, tx_axis_af__DCMAC1;
  slice_tx_t          [5:0] tx_gearbox_slice__DCMAC0, tx_gearbox_slice__DCMAC1;
  slice_rx_t          [5:0] rx_gearbox_slice__DCMAC0, rx_gearbox_slice__DCMAC1;
  wire                [5:0] tx_gearbox_ovf__DCMAC0, tx_gearbox_ovf__DCMAC1;
  wire                [5:0] tx_gearbox_unf__DCMAC0, tx_gearbox_unf__DCMAC1;
  wire                [5:0] pkt_gen_id_req;
  wire                pkt_gen_id_req_vld;
  axis_rx_pkt_t       rx_gearbox_o_pkt__DCMAC0, rx_gearbox_o_pkt__DCMAC1;
  wire                [5:0][31:0] rx_preamble_err_cnt__DCMAC0, rx_preamble_err_cnt__DCMAC1;
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

  wire                [5:0][55:0] tx_preamble__DCMAC0;
  reg                 [5:0][55:0] tx_preamble__DCMAC1 = '{default:0};
  reg                 [5:0][55:0] rx_preamble__DCMAC0, rx_preamble__DCMAC1;
  wire                [5:0][55:0] rx_axis_preamble__DCMAC0, rx_axis_preamble__DCMAC1;

  wire [5:0]          rx_flexif_clk__DCMAC0, rx_flexif_clk__DCMAC1;
  wire [5:0]          tx_flexif_clk__DCMAC0, tx_flexif_clk__DCMAC1;

  wire                rx_macif_clk__DCMAC0, rx_macif_clk__DCMAC1;
  wire                tx_macif_clk__DCMAC0, tx_macif_clk__DCMAC1;
  wire                clk_wiz_reset = 1'b0;


    assign         rx_flexif_clk__DCMAC0 = {6{axis_clk__DCMAC0}};
    assign         tx_flexif_clk__DCMAC0 = {6{axis_clk__DCMAC0}};
    assign         rx_macif_clk__DCMAC0  = axis_clk__DCMAC0; 
    assign         tx_macif_clk__DCMAC0  = axis_clk__DCMAC0;
  
    //assign gt_reset_done   = gt_rx_reset_done_out0[0];
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_0_gt_rx_reset_done_core_clk_syncer (
      .clk                 (core_clk__DCMAC0),
      .reset_async         (gt_rx_reset_done_inv__DCMAC0),
      .reset               (gt_rx_reset_done_core_clk_sync__DCMAC0)
    );
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_0_gt_tx_reset_done_core_clk_syncer (
      .clk                 (core_clk__DCMAC0),
      .reset_async         (gt_tx_reset_done_inv__DCMAC0),
      .reset               (gt_tx_reset_done_core_clk_sync__DCMAC0)
    );
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_0_gt_rx_reset_done_axis_clk_syncer (
      .clk                 (axis_clk__DCMAC0),
      .reset_async         (gt_rx_reset_done_inv__DCMAC0),
      .reset               (gt_rx_reset_done_axis_clk_sync__DCMAC0)
    );
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_0_gt_tx_reset_done_axis_clk_syncer (
      .clk                 (axis_clk__DCMAC0),
      .reset_async         (gt_tx_reset_done_inv__DCMAC0),
      .reset               (gt_tx_reset_done_axis_clk_sync__DCMAC0)
    );
  
    assign gtpowergood__DCMAC0       = gtpowergood_0__DCMAC0; 
  
    ///////  Core and Serdes Clocking
    assign rx_alt_serdes_clk__DCMAC0 = {1'b0,1'b0,gt_rx_usrclk2_0__DCMAC0,gt_rx_usrclk2_0__DCMAC0,gt_rx_usrclk2_0__DCMAC0,gt_rx_usrclk2_0__DCMAC0};
    assign tx_alt_serdes_clk__DCMAC0 = {1'b0,1'b0,gt_tx_usrclk2_0__DCMAC0,gt_tx_usrclk2_0__DCMAC0,gt_tx_usrclk2_0__DCMAC0,gt_tx_usrclk2_0__DCMAC0};
    assign rx_serdes_clk__DCMAC0     = {1'b0,1'b0,gt_rx_usrclk_0__DCMAC0,gt_rx_usrclk_0__DCMAC0,gt_rx_usrclk_0__DCMAC0,gt_rx_usrclk_0__DCMAC0}; 
    assign tx_serdes_clk__DCMAC0     = {1'b0,1'b0,gt_tx_usrclk_0__DCMAC0,gt_tx_usrclk_0__DCMAC0,gt_tx_usrclk_0__DCMAC0,gt_tx_usrclk_0__DCMAC0}; 
  
  
    ///// Core Clocks
    assign tx_core_clk__DCMAC0       = core_clk__DCMAC0;
    assign rx_core_clk__DCMAC0       = core_clk__DCMAC0;
  
    ///// AXIS Clocks
    assign clk_tx_axi__DCMAC0        = axis_clk__DCMAC0;
    assign clk_rx_axi__DCMAC0        = axis_clk__DCMAC0;
    assign rstn_tx_axi__DCMAC0       = clk_wiz_locked__DCMAC0 & ~gt_tx_reset_done_axis_clk_sync__DCMAC0;
    assign rstn_rx_axi__DCMAC0       = clk_wiz_locked__DCMAC0 & ~gt_rx_reset_done_axis_clk_sync__DCMAC0;


    assign         rx_flexif_clk__DCMAC1 = {6{axis_clk__DCMAC1}};
    assign         tx_flexif_clk__DCMAC1 = {6{axis_clk__DCMAC1}};
    assign         rx_macif_clk__DCMAC1  = axis_clk__DCMAC1; 
    assign         tx_macif_clk__DCMAC1  = axis_clk__DCMAC1;
  
    //assign gt_reset_done   = gt_rx_reset_done_out0[0];
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_1_gt_rx_reset_done_core_clk_syncer (
      .clk                 (core_clk__DCMAC1),
      .reset_async         (gt_rx_reset_done_inv__DCMAC1),
      .reset               (gt_rx_reset_done_core_clk_sync__DCMAC1)
    );
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_1_gt_tx_reset_done_core_clk_syncer (
      .clk                 (core_clk__DCMAC1),
      .reset_async         (gt_tx_reset_done_inv__DCMAC1),
      .reset               (gt_tx_reset_done_core_clk_sync__DCMAC1)
    );
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_1_gt_rx_reset_done_axis_clk_syncer (
      .clk                 (axis_clk__DCMAC1),
      .reset_async         (gt_rx_reset_done_inv__DCMAC1),
      .reset               (gt_rx_reset_done_axis_clk_sync__DCMAC1)
    );
  
    dcmac_0_syncer_reset #(
      .RESET_PIPE_LEN      (3)
    ) i_dcmac_1_gt_tx_reset_done_axis_clk_syncer (
      .clk                 (axis_clk__DCMAC1),
      .reset_async         (gt_tx_reset_done_inv__DCMAC1),
      .reset               (gt_tx_reset_done_axis_clk_sync__DCMAC1)
    );
  
    assign gtpowergood__DCMAC1       = gtpowergood_0__DCMAC1; 
  
    ///////  Core and Serdes Clocking
    assign rx_alt_serdes_clk__DCMAC1 = {1'b0,1'b0,gt_rx_usrclk2_0__DCMAC1,gt_rx_usrclk2_0__DCMAC1,gt_rx_usrclk2_0__DCMAC1,gt_rx_usrclk2_0__DCMAC1};
    assign tx_alt_serdes_clk__DCMAC1 = {1'b0,1'b0,gt_tx_usrclk2_0__DCMAC1,gt_tx_usrclk2_0__DCMAC1,gt_tx_usrclk2_0__DCMAC1,gt_tx_usrclk2_0__DCMAC1};
    assign rx_serdes_clk__DCMAC1     = {1'b0,1'b0,gt_rx_usrclk_0__DCMAC1,gt_rx_usrclk_0__DCMAC1,gt_rx_usrclk_0__DCMAC1,gt_rx_usrclk_0__DCMAC1}; 
    assign tx_serdes_clk__DCMAC1     = {1'b0,1'b0,gt_tx_usrclk_0__DCMAC1,gt_tx_usrclk_0__DCMAC1,gt_tx_usrclk_0__DCMAC1,gt_tx_usrclk_0__DCMAC1}; 
  
  
    ///// Core Clocks
    assign tx_core_clk__DCMAC1       = core_clk__DCMAC1;
    assign rx_core_clk__DCMAC1       = core_clk__DCMAC1;
  
    ///// AXIS Clocks
    assign clk_tx_axi__DCMAC1        = axis_clk__DCMAC1;
    assign clk_rx_axi__DCMAC1        = axis_clk__DCMAC1;
    assign rstn_tx_axi__DCMAC1       = clk_wiz_locked__DCMAC1 & ~gt_tx_reset_done_axis_clk_sync__DCMAC1;
    assign rstn_rx_axi__DCMAC1       = clk_wiz_locked__DCMAC1 & ~gt_rx_reset_done_axis_clk_sync__DCMAC1;



  dcmac_0_clk_wiz_0 i_dcmac_0_clk_wiz_0 (
    .reset      (clk_wiz_reset),
    .clk_in1	  (clk_wiz_in__DCMAC0),
    .locked     (clk_wiz_locked__DCMAC0),
    .clk_out1	  (core_clk__DCMAC0),
    .clk_out2   (axis_clk__DCMAC0),
    .clk_out3   (ts_clk__DCMAC0)
  );
  
  dcmac_0_clk_wiz_0 i_dcmac_0_clk_wiz_1 (
    .reset      (clk_wiz_reset),
    .clk_in1	  (clk_wiz_in__DCMAC1),
    .locked     (clk_wiz_locked__DCMAC1),
    .clk_out1	  (core_clk__DCMAC1),
    .clk_out2   (axis_clk__DCMAC1),
    .clk_out3   (ts_clk__DCMAC1)
  );
  

  assign gt_reset_done0     = gt_rx_reset_done_out0[0];
  assign gt_reset_done1     = gt_rx_reset_done_out1[0];
  ///// Core and Serdes Resets
  assign gt_rx_reset_done_inv__DCMAC0  = ~gt_rx_reset_done_out0[0];
  assign gt_tx_reset_done_inv__DCMAC0  = ~gt_tx_reset_done_out0[0];
  assign gt_rx_reset_done_inv__DCMAC1  = ~gt_rx_reset_done_out1[0];
  assign gt_tx_reset_done_inv__DCMAC1  = ~gt_tx_reset_done_out1[0];


  dcmac_0_exdes_support_wrapper i_dcmac_0_exdes_support_wrapper_0
  (
    .CLK_IN_D_0_clk_n                                     ( gt0_ref_clk0_n                                        ),  // input  [0:0]
    .CLK_IN_D_0_clk_p                                     ( gt0_ref_clk0_p                                        ),  // input  [0:0]
    .CLK_IN_D_1_clk_n                                     ( gt0_ref_clk1_n                                        ),  // input  [0:0]
    .CLK_IN_D_1_clk_p                                     ( gt0_ref_clk1_p                                        ),  // input  [0:0]
    .GT_Serial_grx_n                                      ( gt0_rxn_in0                                           ),  // input  [3:0]
    .GT_Serial_grx_p                                      ( gt0_rxp_in0                                           ),  // input  [3:0]
    .GT_Serial_gtx_n                                      ( gt0_txn_out0                                          ),  // output [3:0]
    .GT_Serial_gtx_p                                      ( gt0_txp_out0                                          ),  // output [3:0]
    .GT_Serial_1_grx_n                                    ( gt0_rxn_in1                                           ),  // input  [3:0]
    .GT_Serial_1_grx_p                                    ( gt0_rxp_in1                                           ),  // input  [3:0]
    .GT_Serial_1_gtx_n                                    ( gt0_txn_out1                                          ),  // output [3:0]
    .GT_Serial_1_gtx_p                                    ( gt0_txp_out1                                          ),  // output [3:0]
    .IBUFDS_ODIV2                                         ( clk_wiz_in__DCMAC0                                    ),  // output 
    .gt_rxcdrhold                                         ( gt_rxcdrhold                                          ),  // input  
    .gt_txprecursor                                       ( gt_txprecursor                                        ),  // input  [5:0]
    .gt_txpostcursor                                      ( gt_txpostcursor                                       ),  // input  [5:0]
    .gt_txmaincursor                                      ( gt_txmaincursor                                       ),  // input  [6:0]
    .ch0_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch0_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch0_rxrate_0                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_rxrate_1                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_txrate_0                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_txrate_1                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_tx_usr_clk2_0                                    ( gt_tx_usrclk2_0__DCMAC0                               ),  // output [0:0]
    .ch0_tx_usr_clk_0                                     ( gt_tx_usrclk_0__DCMAC0                                ),  // output [0:0]
    .ch0_rx_usr_clk2_0                                    ( gt_rx_usrclk2_0__DCMAC0                               ),  // output [0:0]
    .ch0_rx_usr_clk_0                                     ( gt_rx_usrclk_0__DCMAC0                                ),  // output [0:0]
    .ch1_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch1_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch1_rxrate_0                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch1_rxrate_1                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch1_txrate_0                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch1_txrate_1                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch2_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch2_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch2_rxrate_0                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch2_rxrate_1                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch2_txrate_0                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch2_txrate_1                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch3_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch3_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch3_rxrate_0                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .ch3_rxrate_1                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .ch3_txrate_0                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .ch3_txrate_1                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .gtpowergood_0                                        ( gtpowergood_0__DCMAC0                                 ),  // output 
    .gtpowergood_1                                        ( gtpowergood_1__DCMAC0                                 ),  // output 
    .ctl_port_ctl_rx_custom_vl_length_minus1              ( default_vl_length_200GE_or_400GE                      ),  // input  [15:0]
    .ctl_port_ctl_tx_custom_vl_length_minus1              ( default_vl_length_200GE_or_400GE                      ),  // input  [15:0]
    .ctl_port_ctl_vl_marker_id0                           ( ctl_tx_vl_marker_id0_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id1                           ( ctl_tx_vl_marker_id1_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id2                           ( ctl_tx_vl_marker_id2_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id3                           ( ctl_tx_vl_marker_id3_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id4                           ( ctl_tx_vl_marker_id4_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id5                           ( ctl_tx_vl_marker_id5_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id6                           ( ctl_tx_vl_marker_id6_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id7                           ( ctl_tx_vl_marker_id7_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id8                           ( ctl_tx_vl_marker_id8_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id9                           ( ctl_tx_vl_marker_id9_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id10                          ( ctl_tx_vl_marker_id10_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id11                          ( ctl_tx_vl_marker_id11_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id12                          ( ctl_tx_vl_marker_id12_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id13                          ( ctl_tx_vl_marker_id13_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id14                          ( ctl_tx_vl_marker_id14_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id15                          ( ctl_tx_vl_marker_id15_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id16                          ( ctl_tx_vl_marker_id16_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id17                          ( ctl_tx_vl_marker_id17_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id18                          ( ctl_tx_vl_marker_id18_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id19                          ( ctl_tx_vl_marker_id19_100ge                           ),  // input  [63:0]
    .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port0_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port0_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port0_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port1_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port2_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port3_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port4_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port5_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .gt_reset_all_in                                      ( gt_reset_all_in                                       ),  // input  
    .gpo                                                  ( gt_gpo0                                               ),  // output [31:0]
    .gt_reset_tx_datapath_in_0                            ( gt_reset_tx_datapath_in_0__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_0                            ( gt_reset_rx_datapath_in_0__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_0                               ( gt_tx_reset_done_out0[0]                              ),  // output 
    .gt_rx_reset_done_out_0                               ( gt_rx_reset_done_out0[0]                              ),  // output 
    .gt_reset_tx_datapath_in_1                            ( gt_reset_tx_datapath_in_1__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_1                            ( gt_reset_rx_datapath_in_1__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_1                               ( gt_tx_reset_done_out0[1]                              ),  // output 
    .gt_rx_reset_done_out_1                               ( gt_rx_reset_done_out0[1]                              ),  // output 
    .gt_reset_tx_datapath_in_2                            ( gt_reset_tx_datapath_in_2__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_2                            ( gt_reset_rx_datapath_in_2__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_2                               ( gt_tx_reset_done_out0[2]                              ),  // output 
    .gt_rx_reset_done_out_2                               ( gt_rx_reset_done_out0[2]                              ),  // output 
    .gt_reset_tx_datapath_in_3                            ( gt_reset_tx_datapath_in_3__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_3                            ( gt_reset_rx_datapath_in_3__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_3                               ( gt_tx_reset_done_out0[3]                              ),  // output 
    .gt_rx_reset_done_out_3                               ( gt_rx_reset_done_out0[3]                              ),  // output 
    .gt_reset_tx_datapath_in_4                            ( gt_reset_tx_datapath_in_4__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_4                            ( gt_reset_rx_datapath_in_4__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_4                               ( gt_tx_reset_done_out0[4]                              ),  // output 
    .gt_rx_reset_done_out_4                               ( gt_rx_reset_done_out0[4]                              ),  // output 
    .gt_reset_tx_datapath_in_5                            ( gt_reset_tx_datapath_in_5__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_5                            ( gt_reset_rx_datapath_in_5__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_5                               ( gt_tx_reset_done_out0[5]                              ),  // output 
    .gt_rx_reset_done_out_5                               ( gt_rx_reset_done_out0[5]                              ),  // output 
    .gt_reset_tx_datapath_in_6                            ( gt_reset_tx_datapath_in_6__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_6                            ( gt_reset_rx_datapath_in_6__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_6                               ( gt_tx_reset_done_out0[6]                              ),  // output 
    .gt_rx_reset_done_out_6                               ( gt_rx_reset_done_out0[6]                              ),  // output 
    .gt_reset_tx_datapath_in_7                            ( gt_reset_tx_datapath_in_7__DCMAC0                     ),  // input  
    .gt_reset_rx_datapath_in_7                            ( gt_reset_rx_datapath_in_7__DCMAC0                     ),  // input  
    .gt_tx_reset_done_out_7                               ( gt_tx_reset_done_out0[7]                              ),  // output 
    .gt_rx_reset_done_out_7                               ( gt_rx_reset_done_out0[7]                              ),  // output 
    .gtpowergood_in                                       ( gtpowergood__DCMAC0                                   ),  // input  
    .ctl_rsvd_in                                          ( 120'd0                                                ),  // input  [119:0]
    .rsvd_in_rx_mac                                       ( 8'd0                                                  ),  // input  [7:0]
    .rsvd_in_rx_phy                                       ( 8'd0                                                  ),  // input  [7:0]
    .rx_all_channel_mac_pm_tick                           ( 1'b0                                                  ),  // input  
    .rx_alt_serdes_clk                                    ( rx_alt_serdes_clk__DCMAC0                             ),  // input  [5:0]
    .rx_axi_clk                                           ( clk_rx_axi__DCMAC0                                    ),  // input  
    .rx_axis_tdata0                                       ( rx_axis_pkt__DCMAC0.dat[0]                            ),  // output [127:0]
    .rx_axis_tdata1                                       ( rx_axis_pkt__DCMAC0.dat[1]                            ),  // output [127:0]
    .rx_axis_tdata2                                       ( rx_axis_pkt__DCMAC0.dat[2]                            ),  // output [127:0]
    .rx_axis_tdata3                                       ( rx_axis_pkt__DCMAC0.dat[3]                            ),  // output [127:0]
    .rx_axis_tdata4                                       ( rx_axis_pkt__DCMAC0.dat[4]                            ),  // output [127:0]
    .rx_axis_tdata5                                       ( rx_axis_pkt__DCMAC0.dat[5]                            ),  // output [127:0]
    .rx_axis_tdata6                                       ( rx_axis_pkt__DCMAC0.dat[6]                            ),  // output [127:0]
    .rx_axis_tdata7                                       ( rx_axis_pkt__DCMAC0.dat[7]                            ),  // output [127:0]
    .rx_axis_tdata8                                       ( rx_axis_pkt__DCMAC0.dat[8]                            ),  // output [127:0]
    .rx_axis_tdata9                                       ( rx_axis_pkt__DCMAC0.dat[9]                            ),  // output [127:0]
    .rx_axis_tdata10                                      ( rx_axis_pkt__DCMAC0.dat[10]                           ),  // output [127:0]
    .rx_axis_tdata11                                      ( rx_axis_pkt__DCMAC0.dat[11]                           ),  // output [127:0]
    .rx_axis_tid                                          ( rx_axis_pkt__DCMAC0.id                                ),  // output [5:0]
    .rx_axis_tuser_ena0                                   ( rx_axis_pkt_ena__DCMAC0[0]                            ),  // output 
    .rx_axis_tuser_ena1                                   ( rx_axis_pkt_ena__DCMAC0[1]                            ),  // output 
    .rx_axis_tuser_ena2                                   ( rx_axis_pkt_ena__DCMAC0[2]                            ),  // output 
    .rx_axis_tuser_ena3                                   ( rx_axis_pkt_ena__DCMAC0[3]                            ),  // output 
    .rx_axis_tuser_ena4                                   ( rx_axis_pkt_ena__DCMAC0[4]                            ),  // output 
    .rx_axis_tuser_ena5                                   ( rx_axis_pkt_ena__DCMAC0[5]                            ),  // output 
    .rx_axis_tuser_ena6                                   ( rx_axis_pkt_ena__DCMAC0[6]                            ),  // output 
    .rx_axis_tuser_ena7                                   ( rx_axis_pkt_ena__DCMAC0[7]                            ),  // output 
    .rx_axis_tuser_ena8                                   ( rx_axis_pkt_ena__DCMAC0[8]                            ),  // output 
    .rx_axis_tuser_ena9                                   ( rx_axis_pkt_ena__DCMAC0[9]                            ),  // output 
    .rx_axis_tuser_ena10                                  ( rx_axis_pkt_ena__DCMAC0[10]                           ),  // output 
    .rx_axis_tuser_ena11                                  ( rx_axis_pkt_ena__DCMAC0[11]                           ),  // output 
    .rx_axis_tuser_eop0                                   ( rx_axis_pkt__DCMAC0.eop[0]                            ),  // output 
    .rx_axis_tuser_eop1                                   ( rx_axis_pkt__DCMAC0.eop[1]                            ),  // output 
    .rx_axis_tuser_eop2                                   ( rx_axis_pkt__DCMAC0.eop[2]                            ),  // output 
    .rx_axis_tuser_eop3                                   ( rx_axis_pkt__DCMAC0.eop[3]                            ),  // output 
    .rx_axis_tuser_eop4                                   ( rx_axis_pkt__DCMAC0.eop[4]                            ),  // output 
    .rx_axis_tuser_eop5                                   ( rx_axis_pkt__DCMAC0.eop[5]                            ),  // output 
    .rx_axis_tuser_eop6                                   ( rx_axis_pkt__DCMAC0.eop[6]                            ),  // output 
    .rx_axis_tuser_eop7                                   ( rx_axis_pkt__DCMAC0.eop[7]                            ),  // output 
    .rx_axis_tuser_eop8                                   ( rx_axis_pkt__DCMAC0.eop[8]                            ),  // output 
    .rx_axis_tuser_eop9                                   ( rx_axis_pkt__DCMAC0.eop[9]                            ),  // output 
    .rx_axis_tuser_eop10                                  ( rx_axis_pkt__DCMAC0.eop[10]                           ),  // output 
    .rx_axis_tuser_eop11                                  ( rx_axis_pkt__DCMAC0.eop[11]                           ),  // output 
    .rx_axis_tuser_err0                                   ( rx_axis_pkt__DCMAC0.err[0]                            ),  // output 
    .rx_axis_tuser_err1                                   ( rx_axis_pkt__DCMAC0.err[1]                            ),  // output 
    .rx_axis_tuser_err2                                   ( rx_axis_pkt__DCMAC0.err[2]                            ),  // output 
    .rx_axis_tuser_err3                                   ( rx_axis_pkt__DCMAC0.err[3]                            ),  // output 
    .rx_axis_tuser_err4                                   ( rx_axis_pkt__DCMAC0.err[4]                            ),  // output 
    .rx_axis_tuser_err5                                   ( rx_axis_pkt__DCMAC0.err[5]                            ),  // output 
    .rx_axis_tuser_err6                                   ( rx_axis_pkt__DCMAC0.err[6]                            ),  // output 
    .rx_axis_tuser_err7                                   ( rx_axis_pkt__DCMAC0.err[7]                            ),  // output 
    .rx_axis_tuser_err8                                   ( rx_axis_pkt__DCMAC0.err[8]                            ),  // output 
    .rx_axis_tuser_err9                                   ( rx_axis_pkt__DCMAC0.err[9]                            ),  // output 
    .rx_axis_tuser_err10                                  ( rx_axis_pkt__DCMAC0.err[10]                           ),  // output 
    .rx_axis_tuser_err11                                  ( rx_axis_pkt__DCMAC0.err[11]                           ),  // output 
    .rx_axis_tuser_mty0                                   ( rx_axis_pkt__DCMAC0.mty[0]                            ),  // output [3:0]
    .rx_axis_tuser_mty1                                   ( rx_axis_pkt__DCMAC0.mty[1]                            ),  // output [3:0]
    .rx_axis_tuser_mty2                                   ( rx_axis_pkt__DCMAC0.mty[2]                            ),  // output [3:0]
    .rx_axis_tuser_mty3                                   ( rx_axis_pkt__DCMAC0.mty[3]                            ),  // output [3:0]
    .rx_axis_tuser_mty4                                   ( rx_axis_pkt__DCMAC0.mty[4]                            ),  // output [3:0]
    .rx_axis_tuser_mty5                                   ( rx_axis_pkt__DCMAC0.mty[5]                            ),  // output [3:0]
    .rx_axis_tuser_mty6                                   ( rx_axis_pkt__DCMAC0.mty[6]                            ),  // output [3:0]
    .rx_axis_tuser_mty7                                   ( rx_axis_pkt__DCMAC0.mty[7]                            ),  // output [3:0]
    .rx_axis_tuser_mty8                                   ( rx_axis_pkt__DCMAC0.mty[8]                            ),  // output [3:0]
    .rx_axis_tuser_mty9                                   ( rx_axis_pkt__DCMAC0.mty[9]                            ),  // output [3:0]
    .rx_axis_tuser_mty10                                  ( rx_axis_pkt__DCMAC0.mty[10]                           ),  // output [3:0]
    .rx_axis_tuser_mty11                                  ( rx_axis_pkt__DCMAC0.mty[11]                           ),  // output [3:0]
    .rx_axis_tuser_sop0                                   ( rx_axis_pkt__DCMAC0.sop[0]                            ),  // output 
    .rx_axis_tuser_sop1                                   ( rx_axis_pkt__DCMAC0.sop[1]                            ),  // output 
    .rx_axis_tuser_sop2                                   ( rx_axis_pkt__DCMAC0.sop[2]                            ),  // output 
    .rx_axis_tuser_sop3                                   ( rx_axis_pkt__DCMAC0.sop[3]                            ),  // output 
    .rx_axis_tuser_sop4                                   ( rx_axis_pkt__DCMAC0.sop[4]                            ),  // output 
    .rx_axis_tuser_sop5                                   ( rx_axis_pkt__DCMAC0.sop[5]                            ),  // output 
    .rx_axis_tuser_sop6                                   ( rx_axis_pkt__DCMAC0.sop[6]                            ),  // output 
    .rx_axis_tuser_sop7                                   ( rx_axis_pkt__DCMAC0.sop[7]                            ),  // output 
    .rx_axis_tuser_sop8                                   ( rx_axis_pkt__DCMAC0.sop[8]                            ),  // output 
    .rx_axis_tuser_sop9                                   ( rx_axis_pkt__DCMAC0.sop[9]                            ),  // output 
    .rx_axis_tuser_sop10                                  ( rx_axis_pkt__DCMAC0.sop[10]                           ),  // output 
    .rx_axis_tuser_sop11                                  ( rx_axis_pkt__DCMAC0.sop[11]                           ),  // output 
    .rx_axis_tvalid_0                                     ( rx_axis_tvalid__DCMAC0[0]                             ),  // output 
    .rx_axis_tvalid_1                                     ( rx_axis_tvalid__DCMAC0[1]                             ),  // output 
    .rx_axis_tvalid_2                                     ( rx_axis_tvalid__DCMAC0[2]                             ),  // output 
    .rx_axis_tvalid_3                                     ( rx_axis_tvalid__DCMAC0[3]                             ),  // output 
    .rx_axis_tvalid_4                                     ( rx_axis_tvalid__DCMAC0[4]                             ),  // output 
    .rx_axis_tvalid_5                                     ( rx_axis_tvalid__DCMAC0[5]                             ),  // output 
    .rx_channel_flush                                     ( 6'd0                                                  ),  // input  [5:0]
    .rx_core_clk                                          ( rx_core_clk__DCMAC0                                   ),  // input  
    .rx_core_reset                                        ( rx_core_reset                                         ),  // input  
    .rx_flexif_clk                                        ( rx_flexif_clk__DCMAC0                                 ),  // input  [5:0]
    .rx_lane_aligner_fill                                 (                                                       ),  // output [6:0]
    .rx_lane_aligner_fill_start                           (                                                       ),  // output 
    .rx_lane_aligner_fill_valid                           (                                                       ),  // output 
    .rx_macif_clk                                         ( rx_macif_clk__DCMAC0                                  ),  // input  
    .rx_pcs_tdm_stats_data                                (                                                       ),  // output [43:0]
    .rx_pcs_tdm_stats_start                               (                                                       ),  // output 
    .rx_pcs_tdm_stats_valid                               (                                                       ),  // output 
    .rx_port_pm_rdy                                       (                                                       ),  // output [5:0]
    .rx_preambleout_0                                     ( rx_axis_preamble__DCMAC0[0]                           ),  // output [55:0]
    .rx_preambleout_1                                     ( rx_axis_preamble__DCMAC0[1]                           ),  // output [55:0]
    .rx_preambleout_2                                     ( rx_axis_preamble__DCMAC0[2]                           ),  // output [55:0]
    .rx_preambleout_3                                     ( rx_axis_preamble__DCMAC0[3]                           ),  // output [55:0]
    .rx_preambleout_4                                     ( rx_axis_preamble__DCMAC0[4]                           ),  // output [55:0]
    .rx_preambleout_5                                     ( rx_axis_preamble__DCMAC0[5]                           ),  // output [55:0]
    .rx_serdes_albuf_restart_0                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_1                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_2                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_3                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_4                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_5                            (                                                       ),  // output 
    .rx_serdes_albuf_slip_0                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_1                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_2                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_3                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_4                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_5                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_6                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_7                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_8                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_9                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_10                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_11                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_12                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_13                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_14                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_15                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_16                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_17                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_18                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_19                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_20                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_21                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_22                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_23                              (                                                       ),  // output 
    .rx_serdes_clk                                        ( rx_serdes_clk__DCMAC0                                 ),  // input  [5:0]
    .rx_serdes_fifo_flagin_0                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_1                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_2                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_3                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_4                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_5                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagout_0                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_1                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_2                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_3                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_4                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_5                             (                                                       ),  // output 
    .rx_serdes_reset                                      ( rx_serdes_reset                                       ),  // input  [5:0]
    .rx_tsmac_tdm_stats_data                              ( rx_tsmac_tdm_stats_data__DCMAC0                       ),  // output [78:0]
    .rx_tsmac_tdm_stats_id                                ( rx_tsmac_tdm_stats_id__DCMAC0                         ),  // output [5:0]
    .rx_tsmac_tdm_stats_valid                             ( rx_tsmac_tdm_stats_valid__DCMAC0                      ),  // output 
    .apb3clk_quad                                         ( s_axi_aclk                                            ),  // input  
    .s_axi_araddr                                         ( s_axi_0_araddr                                        ),  // input  [31:0]
    .s_axi_arready                                        ( s_axi_0_arready                                       ),  // output 
    .s_axi_arvalid                                        ( s_axi_0_arvalid                                       ),  // input  
    .s_axi_awaddr                                         ( s_axi_0_awaddr                                        ),  // input  [31:0]
    .s_axi_awready                                        ( s_axi_0_awready                                       ),  // output 
    .s_axi_awvalid                                        ( s_axi_0_awvalid                                       ),  // input  
    .s_axi_bready                                         ( s_axi_0_bready                                        ),  // input  
    .s_axi_bresp                                          ( s_axi_0_bresp                                         ),  // output [1:0]
    .s_axi_bvalid                                         ( s_axi_0_bvalid                                        ),  // output 
    .s_axi_rdata                                          ( s_axi_0_rdata                                         ),  // output [31:0]
    .s_axi_rready                                         ( s_axi_0_rready                                        ),  // input  
    .s_axi_rresp                                          ( s_axi_0_rresp                                         ),  // output [1:0]
    .s_axi_rvalid                                         ( s_axi_0_rvalid                                        ),  // output 
    .s_axi_wdata                                          ( s_axi_0_wdata                                         ),  // input  [31:0]
    .s_axi_wready                                         ( s_axi_0_wready                                        ),  // output 
    .s_axi_wvalid                                         ( s_axi_0_wvalid                                        ),  // input  
    .s_axi_aclk                                           ( s_axi_aclk                                            ),  // input  
    .s_axi_aresetn                                        ( s_axi_aresetn                                         ),  // input  
    .ts_clk                                               ( {6{ts_clk__DCMAC0}}                                   ),  // input  [5:0]
    .tx_all_channel_mac_pm_rdy                            (                                                       ),  // output 
    .tx_all_channel_mac_pm_tick                           ( 1'b0                                                  ),  // input  
    .tx_alt_serdes_clk                                    ( tx_alt_serdes_clk__DCMAC0                             ),  // input  [5:0]
    .tx_axi_clk                                           ( clk_tx_axi__DCMAC0                                    ),  // input  
    .tx_axis_ch_status_id                                 ( tx_axis_ch_status_id                                  ),  // output [5:0]
    .tx_axis_ch_status_skip_req                           ( tx_axis_ch_status_skip_req                            ),  // output 
    .tx_axis_ch_status_vld                                ( tx_axis_ch_status_vld                                 ),  // output 
    .tx_axis_id_req                                       ( tx_axis_id_req                                        ),  // output [5:0]
    .tx_axis_id_req_vld                                   ( tx_axis_id_req_vld                                    ),  // output 
    .tx_axis_taf_0                                        ( tx_axis_af__DCMAC0[0]                                 ),  // output 
    .tx_axis_taf_1                                        ( tx_axis_af__DCMAC0[1]                                 ),  // output 
    .tx_axis_taf_2                                        ( tx_axis_af__DCMAC0[2]                                 ),  // output 
    .tx_axis_taf_3                                        ( tx_axis_af__DCMAC0[3]                                 ),  // output 
    .tx_axis_taf_4                                        ( tx_axis_af__DCMAC0[4]                                 ),  // output 
    .tx_axis_taf_5                                        ( tx_axis_af__DCMAC0[5]                                 ),  // output 
    .tx_axis_tdata0                                       ( tx_axis_pkt__DCMAC0.dat[0]                            ),  // input  [127:0]
    .tx_axis_tdata1                                       ( tx_axis_pkt__DCMAC0.dat[1]                            ),  // input  [127:0]
    .tx_axis_tdata2                                       ( tx_axis_pkt__DCMAC0.dat[2]                            ),  // input  [127:0]
    .tx_axis_tdata3                                       ( tx_axis_pkt__DCMAC0.dat[3]                            ),  // input  [127:0]
    .tx_axis_tdata4                                       ( tx_axis_pkt__DCMAC0.dat[4]                            ),  // input  [127:0]
    .tx_axis_tdata5                                       ( tx_axis_pkt__DCMAC0.dat[5]                            ),  // input  [127:0]
    .tx_axis_tdata6                                       ( tx_axis_pkt__DCMAC0.dat[6]                            ),  // input  [127:0]
    .tx_axis_tdata7                                       ( tx_axis_pkt__DCMAC0.dat[7]                            ),  // input  [127:0]
    .tx_axis_tdata8                                       ( tx_axis_pkt__DCMAC0.dat[8]                            ),  // input  [127:0]
    .tx_axis_tdata9                                       ( tx_axis_pkt__DCMAC0.dat[9]                            ),  // input  [127:0]
    .tx_axis_tdata10                                      ( tx_axis_pkt__DCMAC0.dat[10]                           ),  // input  [127:0]
    .tx_axis_tdata11                                      ( tx_axis_pkt__DCMAC0.dat[11]                           ),  // input  [127:0]
    .tx_axis_tid                                          ( tx_axis_pkt__DCMAC0.id                                ),  // input  [5:0]
    .tx_axis_tready_0                                     ( tx_axis_tready__DCMAC0[0]                             ),  // output 
    .tx_axis_tready_1                                     ( tx_axis_tready__DCMAC0[1]                             ),  // output 
    .tx_axis_tready_2                                     ( tx_axis_tready__DCMAC0[2]                             ),  // output 
    .tx_axis_tready_3                                     ( tx_axis_tready__DCMAC0[3]                             ),  // output 
    .tx_axis_tready_4                                     ( tx_axis_tready__DCMAC0[4]                             ),  // output 
    .tx_axis_tready_5                                     ( tx_axis_tready__DCMAC0[5]                             ),  // output 
    .tx_axis_tuser_ena0                                   ( tx_axis_pkt__DCMAC0.ena[0]                            ),  // input  
    .tx_axis_tuser_ena1                                   ( tx_axis_pkt__DCMAC0.ena[1]                            ),  // input  
    .tx_axis_tuser_ena2                                   ( tx_axis_pkt__DCMAC0.ena[2]                            ),  // input  
    .tx_axis_tuser_ena3                                   ( tx_axis_pkt__DCMAC0.ena[3]                            ),  // input  
    .tx_axis_tuser_ena4                                   ( tx_axis_pkt__DCMAC0.ena[4]                            ),  // input  
    .tx_axis_tuser_ena5                                   ( tx_axis_pkt__DCMAC0.ena[5]                            ),  // input  
    .tx_axis_tuser_ena6                                   ( tx_axis_pkt__DCMAC0.ena[6]                            ),  // input  
    .tx_axis_tuser_ena7                                   ( tx_axis_pkt__DCMAC0.ena[7]                            ),  // input  
    .tx_axis_tuser_ena8                                   ( tx_axis_pkt__DCMAC0.ena[8]                            ),  // input  
    .tx_axis_tuser_ena9                                   ( tx_axis_pkt__DCMAC0.ena[9]                            ),  // input  
    .tx_axis_tuser_ena10                                  ( tx_axis_pkt__DCMAC0.ena[10]                           ),  // input  
    .tx_axis_tuser_ena11                                  ( tx_axis_pkt__DCMAC0.ena[11]                           ),  // input  
    .tx_axis_tuser_eop0                                   ( tx_axis_pkt__DCMAC0.eop[0]                            ),  // input  
    .tx_axis_tuser_eop1                                   ( tx_axis_pkt__DCMAC0.eop[1]                            ),  // input  
    .tx_axis_tuser_eop2                                   ( tx_axis_pkt__DCMAC0.eop[2]                            ),  // input  
    .tx_axis_tuser_eop3                                   ( tx_axis_pkt__DCMAC0.eop[3]                            ),  // input  
    .tx_axis_tuser_eop4                                   ( tx_axis_pkt__DCMAC0.eop[4]                            ),  // input  
    .tx_axis_tuser_eop5                                   ( tx_axis_pkt__DCMAC0.eop[5]                            ),  // input  
    .tx_axis_tuser_eop6                                   ( tx_axis_pkt__DCMAC0.eop[6]                            ),  // input  
    .tx_axis_tuser_eop7                                   ( tx_axis_pkt__DCMAC0.eop[7]                            ),  // input  
    .tx_axis_tuser_eop8                                   ( tx_axis_pkt__DCMAC0.eop[8]                            ),  // input  
    .tx_axis_tuser_eop9                                   ( tx_axis_pkt__DCMAC0.eop[9]                            ),  // input  
    .tx_axis_tuser_eop10                                  ( tx_axis_pkt__DCMAC0.eop[10]                           ),  // input  
    .tx_axis_tuser_eop11                                  ( tx_axis_pkt__DCMAC0.eop[11]                           ),  // input  
    .tx_axis_tuser_err0                                   ( tx_axis_pkt__DCMAC0.err[0]                            ),  // input  
    .tx_axis_tuser_err1                                   ( tx_axis_pkt__DCMAC0.err[1]                            ),  // input  
    .tx_axis_tuser_err2                                   ( tx_axis_pkt__DCMAC0.err[2]                            ),  // input  
    .tx_axis_tuser_err3                                   ( tx_axis_pkt__DCMAC0.err[3]                            ),  // input  
    .tx_axis_tuser_err4                                   ( tx_axis_pkt__DCMAC0.err[4]                            ),  // input  
    .tx_axis_tuser_err5                                   ( tx_axis_pkt__DCMAC0.err[5]                            ),  // input  
    .tx_axis_tuser_err6                                   ( tx_axis_pkt__DCMAC0.err[6]                            ),  // input  
    .tx_axis_tuser_err7                                   ( tx_axis_pkt__DCMAC0.err[7]                            ),  // input  
    .tx_axis_tuser_err8                                   ( tx_axis_pkt__DCMAC0.err[8]                            ),  // input  
    .tx_axis_tuser_err9                                   ( tx_axis_pkt__DCMAC0.err[9]                            ),  // input  
    .tx_axis_tuser_err10                                  ( tx_axis_pkt__DCMAC0.err[10]                           ),  // input  
    .tx_axis_tuser_err11                                  ( tx_axis_pkt__DCMAC0.err[11]                           ),  // input  
    .tx_axis_tuser_mty0                                   ( tx_axis_pkt__DCMAC0.mty[0]                            ),  // input  [3:0]
    .tx_axis_tuser_mty1                                   ( tx_axis_pkt__DCMAC0.mty[1]                            ),  // input  [3:0]
    .tx_axis_tuser_mty2                                   ( tx_axis_pkt__DCMAC0.mty[2]                            ),  // input  [3:0]
    .tx_axis_tuser_mty3                                   ( tx_axis_pkt__DCMAC0.mty[3]                            ),  // input  [3:0]
    .tx_axis_tuser_mty4                                   ( tx_axis_pkt__DCMAC0.mty[4]                            ),  // input  [3:0]
    .tx_axis_tuser_mty5                                   ( tx_axis_pkt__DCMAC0.mty[5]                            ),  // input  [3:0]
    .tx_axis_tuser_mty6                                   ( tx_axis_pkt__DCMAC0.mty[6]                            ),  // input  [3:0]
    .tx_axis_tuser_mty7                                   ( tx_axis_pkt__DCMAC0.mty[7]                            ),  // input  [3:0]
    .tx_axis_tuser_mty8                                   ( tx_axis_pkt__DCMAC0.mty[8]                            ),  // input  [3:0]
    .tx_axis_tuser_mty9                                   ( tx_axis_pkt__DCMAC0.mty[9]                            ),  // input  [3:0]
    .tx_axis_tuser_mty10                                  ( tx_axis_pkt__DCMAC0.mty[10]                           ),  // input  [3:0]
    .tx_axis_tuser_mty11                                  ( tx_axis_pkt__DCMAC0.mty[11]                           ),  // input  [3:0]
    .tx_axis_tuser_skip_response                          ( tx_axis_tuser_skip_response                           ),  // input  
    .tx_axis_tuser_sop0                                   ( tx_axis_pkt__DCMAC0.sop[0]                            ),  // input  
    .tx_axis_tuser_sop1                                   ( tx_axis_pkt__DCMAC0.sop[1]                            ),  // input  
    .tx_axis_tuser_sop2                                   ( tx_axis_pkt__DCMAC0.sop[2]                            ),  // input  
    .tx_axis_tuser_sop3                                   ( tx_axis_pkt__DCMAC0.sop[3]                            ),  // input  
    .tx_axis_tuser_sop4                                   ( tx_axis_pkt__DCMAC0.sop[4]                            ),  // input  
    .tx_axis_tuser_sop5                                   ( tx_axis_pkt__DCMAC0.sop[5]                            ),  // input  
    .tx_axis_tuser_sop6                                   ( tx_axis_pkt__DCMAC0.sop[6]                            ),  // input  
    .tx_axis_tuser_sop7                                   ( tx_axis_pkt__DCMAC0.sop[7]                            ),  // input  
    .tx_axis_tuser_sop8                                   ( tx_axis_pkt__DCMAC0.sop[8]                            ),  // input  
    .tx_axis_tuser_sop9                                   ( tx_axis_pkt__DCMAC0.sop[9]                            ),  // input  
    .tx_axis_tuser_sop10                                  ( tx_axis_pkt__DCMAC0.sop[10]                           ),  // input  
    .tx_axis_tuser_sop11                                  ( tx_axis_pkt__DCMAC0.sop[11]                           ),  // input  
    .tx_axis_tvalid_0                                     ( tx_gearbox_dout_vld__DCMAC0[0] | tx_axi_vld_mask__DCMAC0[0]   ),  // input  
    .tx_axis_tvalid_1                                     ( tx_gearbox_dout_vld__DCMAC0[1] | tx_axi_vld_mask__DCMAC0[1]   ),  // input  
    .tx_axis_tvalid_2                                     ( tx_gearbox_dout_vld__DCMAC0[2] | tx_axi_vld_mask__DCMAC0[2]   ),  // input  
    .tx_axis_tvalid_3                                     ( tx_gearbox_dout_vld__DCMAC0[3] | tx_axi_vld_mask__DCMAC0[3]   ),  // input  
    .tx_axis_tvalid_4                                     ( tx_gearbox_dout_vld__DCMAC0[4] | tx_axi_vld_mask__DCMAC0[4]   ),  // input  
    .tx_axis_tvalid_5                                     ( tx_gearbox_dout_vld__DCMAC0[5] | tx_axi_vld_mask__DCMAC0[5]   ),  // input  
    .tx_channel_flush                                     ( 6'd0                                                  ),  // input  [5:0]
    .tx_core_clk                                          ( tx_core_clk__DCMAC0                                   ),  // input  
    .tx_core_reset                                        ( tx_core_reset                                         ),  // input  
    .tx_flexif_clk                                        ( tx_flexif_clk__DCMAC0                                 ),  // input  [5:0]
    .tx_macif_clk                                         ( tx_macif_clk__DCMAC0                                  ),  // input  
    .tx_pcs_tdm_stats_data                                (                                                       ),  // output [21:0]
    .tx_pcs_tdm_stats_start                               (                                                       ),  // output 
    .tx_pcs_tdm_stats_valid                               (                                                       ),  // output 
    .tx_port_pm_rdy                                       (                                                       ),  // output [5:0]
    .tx_port_pm_tick                                      ( pm_tick_core                                          ),  // input  [5:0]
    .rx_port_pm_tick                                      ( pm_tick_core                                          ),  // input  [5:0]
    .tx_preamblein_0                                      ( tx_preamble__DCMAC0[0]                                ),  // input  [55:0]
    .tx_preamblein_1                                      ( tx_preamble__DCMAC0[1]                                ),  // input  [55:0]
    .tx_preamblein_2                                      ( tx_preamble__DCMAC0[2]                                ),  // input  [55:0]
    .tx_preamblein_3                                      ( tx_preamble__DCMAC0[3]                                ),  // input  [55:0]
    .tx_preamblein_4                                      ( tx_preamble__DCMAC0[4]                                ),  // input  [55:0]
    .tx_preamblein_5                                      ( tx_preamble__DCMAC0[5]                                ),  // input  [55:0]
    .tx_serdes_clk                                        ( tx_serdes_clk__DCMAC0                                 ),  // input  [5:0]
    .tx_serdes_is_am_0                                    ( tx_serdes_is_am[0]                                    ),  // output 
    .tx_serdes_is_am_1                                    ( tx_serdes_is_am[1]                                    ),  // output 
    .tx_serdes_is_am_2                                    ( tx_serdes_is_am[2]                                    ),  // output 
    .tx_serdes_is_am_3                                    ( tx_serdes_is_am[3]                                    ),  // output 
    .tx_serdes_is_am_4                                    ( tx_serdes_is_am[4]                                    ),  // output 
    .tx_serdes_is_am_5                                    ( tx_serdes_is_am[5]                                    ),  // output 
    .tx_serdes_is_am_prefifo_0                            ( tx_serdes_is_am_prefifo[0]                            ),  // output 
    .tx_serdes_is_am_prefifo_1                            ( tx_serdes_is_am_prefifo[1]                            ),  // output 
    .tx_serdes_is_am_prefifo_2                            ( tx_serdes_is_am_prefifo[2]                            ),  // output 
    .tx_serdes_is_am_prefifo_3                            ( tx_serdes_is_am_prefifo[3]                            ),  // output 
    .tx_serdes_is_am_prefifo_4                            ( tx_serdes_is_am_prefifo[4]                            ),  // output 
    .tx_serdes_is_am_prefifo_5                            ( tx_serdes_is_am_prefifo[5]                            ),  // output 
    .tx_tsmac_tdm_stats_data                              ( tx_tsmac_tdm_stats_data__DCMAC0                       ),  // output [55:0]
    .tx_tsmac_tdm_stats_id                                ( tx_tsmac_tdm_stats_id__DCMAC0                         ),  // output [5:0]
    .tx_tsmac_tdm_stats_valid                             ( tx_tsmac_tdm_stats_valid__DCMAC0                      ),  // output 
    .c0_stat_rx_corrected_lane_delay_0                    ( c0_stat_rx_corrected_lane_delay_0__DCMAC0             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_1                    ( c0_stat_rx_corrected_lane_delay_1__DCMAC0             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_2                    ( c0_stat_rx_corrected_lane_delay_2__DCMAC0             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_3                    ( c0_stat_rx_corrected_lane_delay_3__DCMAC0             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_valid                ( c0_stat_rx_corrected_lane_delay_valid__DCMAC0         ),  // output 
    .c1_stat_rx_corrected_lane_delay_0                    ( c1_stat_rx_corrected_lane_delay_0__DCMAC0             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_1                    ( c1_stat_rx_corrected_lane_delay_1__DCMAC0             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_2                    ( c1_stat_rx_corrected_lane_delay_2__DCMAC0             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_3                    ( c1_stat_rx_corrected_lane_delay_3__DCMAC0             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_valid                ( c1_stat_rx_corrected_lane_delay_valid__DCMAC0         ),  // output 
    .c2_stat_rx_corrected_lane_delay_0                    ( c2_stat_rx_corrected_lane_delay_0__DCMAC0             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_1                    ( c2_stat_rx_corrected_lane_delay_1__DCMAC0             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_2                    ( c2_stat_rx_corrected_lane_delay_2__DCMAC0             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_3                    ( c2_stat_rx_corrected_lane_delay_3__DCMAC0             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_valid                ( c2_stat_rx_corrected_lane_delay_valid__DCMAC0         ),  // output 
    .c3_stat_rx_corrected_lane_delay_0                    ( c3_stat_rx_corrected_lane_delay_0__DCMAC0             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_1                    ( c3_stat_rx_corrected_lane_delay_1__DCMAC0             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_2                    ( c3_stat_rx_corrected_lane_delay_2__DCMAC0             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_3                    ( c3_stat_rx_corrected_lane_delay_3__DCMAC0             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_valid                ( c3_stat_rx_corrected_lane_delay_valid__DCMAC0         ),  // output 
    .c4_stat_rx_corrected_lane_delay_0                    ( c4_stat_rx_corrected_lane_delay_0__DCMAC0             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_1                    ( c4_stat_rx_corrected_lane_delay_1__DCMAC0             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_2                    ( c4_stat_rx_corrected_lane_delay_2__DCMAC0             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_3                    ( c4_stat_rx_corrected_lane_delay_3__DCMAC0             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_valid                ( c4_stat_rx_corrected_lane_delay_valid__DCMAC0         ),  // output 
    .c5_stat_rx_corrected_lane_delay_0                    ( c5_stat_rx_corrected_lane_delay_0__DCMAC0             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_1                    ( c5_stat_rx_corrected_lane_delay_1__DCMAC0             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_2                    ( c5_stat_rx_corrected_lane_delay_2__DCMAC0             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_3                    ( c5_stat_rx_corrected_lane_delay_3__DCMAC0             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_valid                ( c5_stat_rx_corrected_lane_delay_valid__DCMAC0         ),  // output 
    .tx_serdes_reset                                      ( tx_serdes_reset                                       )   // input  [5:0]
  );



  dcmac_0_exdes_support_1_wrapper i_dcmac_0_exdes_support_wrapper_1
  (
    .CLK_IN_D_0_clk_n                                     ( gt1_ref_clk0_n                                        ),  // input  [0:0]
    .CLK_IN_D_0_clk_p                                     ( gt1_ref_clk0_p                                        ),  // input  [0:0]
    .CLK_IN_D_1_clk_n                                     ( gt1_ref_clk1_n                                        ),  // input  [0:0]
    .CLK_IN_D_1_clk_p                                     ( gt1_ref_clk1_p                                        ),  // input  [0:0]
    .GT_Serial_grx_n                                      ( gt1_rxn_in0                                           ),  // input  [3:0]
    .GT_Serial_grx_p                                      ( gt1_rxp_in0                                           ),  // input  [3:0]
    .GT_Serial_gtx_n                                      ( gt1_txn_out0                                          ),  // output [3:0]
    .GT_Serial_gtx_p                                      ( gt1_txp_out0                                          ),  // output [3:0]
    .GT_Serial_1_grx_n                                    ( gt1_rxn_in1                                           ),  // input  [3:0]
    .GT_Serial_1_grx_p                                    ( gt1_rxp_in1                                           ),  // input  [3:0]
    .GT_Serial_1_gtx_n                                    ( gt1_txn_out1                                          ),  // output [3:0]
    .GT_Serial_1_gtx_p                                    ( gt1_txp_out1                                          ),  // output [3:0]
    .IBUFDS_ODIV2                                         ( clk_wiz_in__DCMAC1                                    ),  // output 
    .gt_rxcdrhold                                         ( gt_rxcdrhold                                          ),  // input  
    .gt_txprecursor                                       ( gt_txprecursor                                        ),  // input  [5:0]
    .gt_txpostcursor                                      ( gt_txpostcursor                                       ),  // input  [5:0]
    .gt_txmaincursor                                      ( gt_txmaincursor                                       ),  // input  [6:0]
    .ch0_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch0_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch0_rxrate_0                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_rxrate_1                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_txrate_0                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_txrate_1                                         ( SW_REG_GT_LINE_RATE[7:0]                              ),  // input  [7:0]
    .ch0_tx_usr_clk2_0                                    ( gt_tx_usrclk2_0__DCMAC1                               ),  // output [0:0]
    .ch0_tx_usr_clk_0                                     ( gt_tx_usrclk_0__DCMAC1                                ),  // output [0:0]
    .ch0_rx_usr_clk2_0                                    ( gt_rx_usrclk2_0__DCMAC1                               ),  // output [0:0]
    .ch0_rx_usr_clk_0                                     ( gt_rx_usrclk_0__DCMAC1                                ),  // output [0:0]
    .ch1_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch1_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch1_rxrate_0                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch1_rxrate_1                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch1_txrate_0                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch1_txrate_1                                         ( SW_REG_GT_LINE_RATE[15:8]                             ),  // input  [7:0]
    .ch2_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch2_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch2_rxrate_0                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch2_rxrate_1                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch2_txrate_0                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch2_txrate_1                                         ( SW_REG_GT_LINE_RATE[23:16]                            ),  // input  [7:0]
    .ch3_loopback_0                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch3_loopback_1                                       ( gt_loopback                                           ),  // input  [2:0]
    .ch3_rxrate_0                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .ch3_rxrate_1                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .ch3_txrate_0                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .ch3_txrate_1                                         ( SW_REG_GT_LINE_RATE[31:24]                            ),  // input  [7:0]
    .gtpowergood_0                                        ( gtpowergood_0__DCMAC1                                 ),  // output 
    .gtpowergood_1                                        ( gtpowergood_1__DCMAC1                                 ),  // output 
    .ctl_port_ctl_rx_custom_vl_length_minus1              ( default_vl_length_200GE_or_400GE                      ),  // input  [15:0]
    .ctl_port_ctl_tx_custom_vl_length_minus1              ( default_vl_length_200GE_or_400GE                      ),  // input  [15:0]
    .ctl_port_ctl_vl_marker_id0                           ( ctl_tx_vl_marker_id0_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id1                           ( ctl_tx_vl_marker_id1_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id2                           ( ctl_tx_vl_marker_id2_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id3                           ( ctl_tx_vl_marker_id3_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id4                           ( ctl_tx_vl_marker_id4_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id5                           ( ctl_tx_vl_marker_id5_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id6                           ( ctl_tx_vl_marker_id6_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id7                           ( ctl_tx_vl_marker_id7_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id8                           ( ctl_tx_vl_marker_id8_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id9                           ( ctl_tx_vl_marker_id9_100ge                            ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id10                          ( ctl_tx_vl_marker_id10_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id11                          ( ctl_tx_vl_marker_id11_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id12                          ( ctl_tx_vl_marker_id12_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id13                          ( ctl_tx_vl_marker_id13_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id14                          ( ctl_tx_vl_marker_id14_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id15                          ( ctl_tx_vl_marker_id15_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id16                          ( ctl_tx_vl_marker_id16_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id17                          ( ctl_tx_vl_marker_id17_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id18                          ( ctl_tx_vl_marker_id18_100ge                           ),  // input  [63:0]
    .ctl_port_ctl_vl_marker_id19                          ( ctl_tx_vl_marker_id19_100ge                           ),  // input  [63:0]
    .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port0_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port0_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port0_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port0_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port1_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port1_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port2_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port2_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port3_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port3_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port4_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port4_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override        ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_lane0_vlm_bip7_override_value  ( 8'd0                                                  ),  // input  [7:0]
    .ctl_txrx_port5_ctl_tx_send_idle_in                   ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_send_lfi_in                    ( 1'b0                                                  ),  // input  
    .ctl_txrx_port5_ctl_tx_send_rfi_in                    ( 1'b0                                                  ),  // input  
    .gt_reset_all_in                                      ( gt_reset_all_in                                       ),  // input  
    .gpo                                                  ( gt_gpo1                                               ),  // output [31:0]
    .gt_reset_tx_datapath_in_0                            ( gt_reset_tx_datapath_in_0__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_0                            ( gt_reset_rx_datapath_in_0__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_0                               ( gt_tx_reset_done_out1[0]                              ),  // output 
    .gt_rx_reset_done_out_0                               ( gt_rx_reset_done_out1[0]                              ),  // output 
    .gt_reset_tx_datapath_in_1                            ( gt_reset_tx_datapath_in_1__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_1                            ( gt_reset_rx_datapath_in_1__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_1                               ( gt_tx_reset_done_out1[1]                              ),  // output 
    .gt_rx_reset_done_out_1                               ( gt_rx_reset_done_out1[1]                              ),  // output 
    .gt_reset_tx_datapath_in_2                            ( gt_reset_tx_datapath_in_2__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_2                            ( gt_reset_rx_datapath_in_2__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_2                               ( gt_tx_reset_done_out1[2]                              ),  // output 
    .gt_rx_reset_done_out_2                               ( gt_rx_reset_done_out1[2]                              ),  // output 
    .gt_reset_tx_datapath_in_3                            ( gt_reset_tx_datapath_in_3__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_3                            ( gt_reset_rx_datapath_in_3__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_3                               ( gt_tx_reset_done_out1[3]                              ),  // output 
    .gt_rx_reset_done_out_3                               ( gt_rx_reset_done_out1[3]                              ),  // output 
    .gt_reset_tx_datapath_in_4                            ( gt_reset_tx_datapath_in_4__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_4                            ( gt_reset_rx_datapath_in_4__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_4                               ( gt_tx_reset_done_out1[4]                              ),  // output 
    .gt_rx_reset_done_out_4                               ( gt_rx_reset_done_out1[4]                              ),  // output 
    .gt_reset_tx_datapath_in_5                            ( gt_reset_tx_datapath_in_5__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_5                            ( gt_reset_rx_datapath_in_5__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_5                               ( gt_tx_reset_done_out1[5]                              ),  // output 
    .gt_rx_reset_done_out_5                               ( gt_rx_reset_done_out1[5]                              ),  // output 
    .gt_reset_tx_datapath_in_6                            ( gt_reset_tx_datapath_in_6__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_6                            ( gt_reset_rx_datapath_in_6__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_6                               ( gt_tx_reset_done_out1[6]                              ),  // output 
    .gt_rx_reset_done_out_6                               ( gt_rx_reset_done_out1[6]                              ),  // output 
    .gt_reset_tx_datapath_in_7                            ( gt_reset_tx_datapath_in_7__DCMAC1                     ),  // input  
    .gt_reset_rx_datapath_in_7                            ( gt_reset_rx_datapath_in_7__DCMAC1                     ),  // input  
    .gt_tx_reset_done_out_7                               ( gt_tx_reset_done_out1[7]                              ),  // output 
    .gt_rx_reset_done_out_7                               ( gt_rx_reset_done_out1[7]                              ),  // output 
    .gtpowergood_in                                       ( gtpowergood__DCMAC1                                   ),  // input  
    .ctl_rsvd_in                                          ( 120'd0                                                ),  // input  [119:0]
    .rsvd_in_rx_mac                                       ( 8'd0                                                  ),  // input  [7:0]
    .rsvd_in_rx_phy                                       ( 8'd0                                                  ),  // input  [7:0]
    .rx_all_channel_mac_pm_tick                           ( 1'b0                                                  ),  // input  
    .rx_alt_serdes_clk                                    ( rx_alt_serdes_clk__DCMAC1                             ),  // input  [5:0]
    .rx_axi_clk                                           ( clk_rx_axi__DCMAC1                                    ),  // input  
    .rx_axis_tdata0                                       ( rx_axis_pkt__DCMAC1.dat[0]                            ),  // output [127:0]
    .rx_axis_tdata1                                       ( rx_axis_pkt__DCMAC1.dat[1]                            ),  // output [127:0]
    .rx_axis_tdata2                                       ( rx_axis_pkt__DCMAC1.dat[2]                            ),  // output [127:0]
    .rx_axis_tdata3                                       ( rx_axis_pkt__DCMAC1.dat[3]                            ),  // output [127:0]
    .rx_axis_tdata4                                       ( rx_axis_pkt__DCMAC1.dat[4]                            ),  // output [127:0]
    .rx_axis_tdata5                                       ( rx_axis_pkt__DCMAC1.dat[5]                            ),  // output [127:0]
    .rx_axis_tdata6                                       ( rx_axis_pkt__DCMAC1.dat[6]                            ),  // output [127:0]
    .rx_axis_tdata7                                       ( rx_axis_pkt__DCMAC1.dat[7]                            ),  // output [127:0]
    .rx_axis_tdata8                                       ( rx_axis_pkt__DCMAC1.dat[8]                            ),  // output [127:0]
    .rx_axis_tdata9                                       ( rx_axis_pkt__DCMAC1.dat[9]                            ),  // output [127:0]
    .rx_axis_tdata10                                      ( rx_axis_pkt__DCMAC1.dat[10]                           ),  // output [127:0]
    .rx_axis_tdata11                                      ( rx_axis_pkt__DCMAC1.dat[11]                           ),  // output [127:0]
    .rx_axis_tid                                          ( rx_axis_pkt__DCMAC1.id                                ),  // output [5:0]
    .rx_axis_tuser_ena0                                   ( rx_axis_pkt_ena__DCMAC1[0]                            ),  // output 
    .rx_axis_tuser_ena1                                   ( rx_axis_pkt_ena__DCMAC1[1]                            ),  // output 
    .rx_axis_tuser_ena2                                   ( rx_axis_pkt_ena__DCMAC1[2]                            ),  // output 
    .rx_axis_tuser_ena3                                   ( rx_axis_pkt_ena__DCMAC1[3]                            ),  // output 
    .rx_axis_tuser_ena4                                   ( rx_axis_pkt_ena__DCMAC1[4]                            ),  // output 
    .rx_axis_tuser_ena5                                   ( rx_axis_pkt_ena__DCMAC1[5]                            ),  // output 
    .rx_axis_tuser_ena6                                   ( rx_axis_pkt_ena__DCMAC1[6]                            ),  // output 
    .rx_axis_tuser_ena7                                   ( rx_axis_pkt_ena__DCMAC1[7]                            ),  // output 
    .rx_axis_tuser_ena8                                   ( rx_axis_pkt_ena__DCMAC1[8]                            ),  // output 
    .rx_axis_tuser_ena9                                   ( rx_axis_pkt_ena__DCMAC1[9]                            ),  // output 
    .rx_axis_tuser_ena10                                  ( rx_axis_pkt_ena__DCMAC1[10]                           ),  // output 
    .rx_axis_tuser_ena11                                  ( rx_axis_pkt_ena__DCMAC1[11]                           ),  // output 
    .rx_axis_tuser_eop0                                   ( rx_axis_pkt__DCMAC1.eop[0]                            ),  // output 
    .rx_axis_tuser_eop1                                   ( rx_axis_pkt__DCMAC1.eop[1]                            ),  // output 
    .rx_axis_tuser_eop2                                   ( rx_axis_pkt__DCMAC1.eop[2]                            ),  // output 
    .rx_axis_tuser_eop3                                   ( rx_axis_pkt__DCMAC1.eop[3]                            ),  // output 
    .rx_axis_tuser_eop4                                   ( rx_axis_pkt__DCMAC1.eop[4]                            ),  // output 
    .rx_axis_tuser_eop5                                   ( rx_axis_pkt__DCMAC1.eop[5]                            ),  // output 
    .rx_axis_tuser_eop6                                   ( rx_axis_pkt__DCMAC1.eop[6]                            ),  // output 
    .rx_axis_tuser_eop7                                   ( rx_axis_pkt__DCMAC1.eop[7]                            ),  // output 
    .rx_axis_tuser_eop8                                   ( rx_axis_pkt__DCMAC1.eop[8]                            ),  // output 
    .rx_axis_tuser_eop9                                   ( rx_axis_pkt__DCMAC1.eop[9]                            ),  // output 
    .rx_axis_tuser_eop10                                  ( rx_axis_pkt__DCMAC1.eop[10]                           ),  // output 
    .rx_axis_tuser_eop11                                  ( rx_axis_pkt__DCMAC1.eop[11]                           ),  // output 
    .rx_axis_tuser_err0                                   ( rx_axis_pkt__DCMAC1.err[0]                            ),  // output 
    .rx_axis_tuser_err1                                   ( rx_axis_pkt__DCMAC1.err[1]                            ),  // output 
    .rx_axis_tuser_err2                                   ( rx_axis_pkt__DCMAC1.err[2]                            ),  // output 
    .rx_axis_tuser_err3                                   ( rx_axis_pkt__DCMAC1.err[3]                            ),  // output 
    .rx_axis_tuser_err4                                   ( rx_axis_pkt__DCMAC1.err[4]                            ),  // output 
    .rx_axis_tuser_err5                                   ( rx_axis_pkt__DCMAC1.err[5]                            ),  // output 
    .rx_axis_tuser_err6                                   ( rx_axis_pkt__DCMAC1.err[6]                            ),  // output 
    .rx_axis_tuser_err7                                   ( rx_axis_pkt__DCMAC1.err[7]                            ),  // output 
    .rx_axis_tuser_err8                                   ( rx_axis_pkt__DCMAC1.err[8]                            ),  // output 
    .rx_axis_tuser_err9                                   ( rx_axis_pkt__DCMAC1.err[9]                            ),  // output 
    .rx_axis_tuser_err10                                  ( rx_axis_pkt__DCMAC1.err[10]                           ),  // output 
    .rx_axis_tuser_err11                                  ( rx_axis_pkt__DCMAC1.err[11]                           ),  // output 
    .rx_axis_tuser_mty0                                   ( rx_axis_pkt__DCMAC1.mty[0]                            ),  // output [3:0]
    .rx_axis_tuser_mty1                                   ( rx_axis_pkt__DCMAC1.mty[1]                            ),  // output [3:0]
    .rx_axis_tuser_mty2                                   ( rx_axis_pkt__DCMAC1.mty[2]                            ),  // output [3:0]
    .rx_axis_tuser_mty3                                   ( rx_axis_pkt__DCMAC1.mty[3]                            ),  // output [3:0]
    .rx_axis_tuser_mty4                                   ( rx_axis_pkt__DCMAC1.mty[4]                            ),  // output [3:0]
    .rx_axis_tuser_mty5                                   ( rx_axis_pkt__DCMAC1.mty[5]                            ),  // output [3:0]
    .rx_axis_tuser_mty6                                   ( rx_axis_pkt__DCMAC1.mty[6]                            ),  // output [3:0]
    .rx_axis_tuser_mty7                                   ( rx_axis_pkt__DCMAC1.mty[7]                            ),  // output [3:0]
    .rx_axis_tuser_mty8                                   ( rx_axis_pkt__DCMAC1.mty[8]                            ),  // output [3:0]
    .rx_axis_tuser_mty9                                   ( rx_axis_pkt__DCMAC1.mty[9]                            ),  // output [3:0]
    .rx_axis_tuser_mty10                                  ( rx_axis_pkt__DCMAC1.mty[10]                           ),  // output [3:0]
    .rx_axis_tuser_mty11                                  ( rx_axis_pkt__DCMAC1.mty[11]                           ),  // output [3:0]
    .rx_axis_tuser_sop0                                   ( rx_axis_pkt__DCMAC1.sop[0]                            ),  // output 
    .rx_axis_tuser_sop1                                   ( rx_axis_pkt__DCMAC1.sop[1]                            ),  // output 
    .rx_axis_tuser_sop2                                   ( rx_axis_pkt__DCMAC1.sop[2]                            ),  // output 
    .rx_axis_tuser_sop3                                   ( rx_axis_pkt__DCMAC1.sop[3]                            ),  // output 
    .rx_axis_tuser_sop4                                   ( rx_axis_pkt__DCMAC1.sop[4]                            ),  // output 
    .rx_axis_tuser_sop5                                   ( rx_axis_pkt__DCMAC1.sop[5]                            ),  // output 
    .rx_axis_tuser_sop6                                   ( rx_axis_pkt__DCMAC1.sop[6]                            ),  // output 
    .rx_axis_tuser_sop7                                   ( rx_axis_pkt__DCMAC1.sop[7]                            ),  // output 
    .rx_axis_tuser_sop8                                   ( rx_axis_pkt__DCMAC1.sop[8]                            ),  // output 
    .rx_axis_tuser_sop9                                   ( rx_axis_pkt__DCMAC1.sop[9]                            ),  // output 
    .rx_axis_tuser_sop10                                  ( rx_axis_pkt__DCMAC1.sop[10]                           ),  // output 
    .rx_axis_tuser_sop11                                  ( rx_axis_pkt__DCMAC1.sop[11]                           ),  // output 
    .rx_axis_tvalid_0                                     ( rx_axis_tvalid__DCMAC1[0]                             ),  // output 
    .rx_axis_tvalid_1                                     ( rx_axis_tvalid__DCMAC1[1]                             ),  // output 
    .rx_axis_tvalid_2                                     ( rx_axis_tvalid__DCMAC1[2]                             ),  // output 
    .rx_axis_tvalid_3                                     ( rx_axis_tvalid__DCMAC1[3]                             ),  // output 
    .rx_axis_tvalid_4                                     ( rx_axis_tvalid__DCMAC1[4]                             ),  // output 
    .rx_axis_tvalid_5                                     ( rx_axis_tvalid__DCMAC1[5]                             ),  // output 
    .rx_channel_flush                                     ( 6'd0                                                  ),  // input  [5:0]
    .rx_core_clk                                          ( rx_core_clk__DCMAC1                                   ),  // input  
    .rx_core_reset                                        ( rx_core_reset                                         ),  // input  
    .rx_flexif_clk                                        ( rx_flexif_clk__DCMAC1                                 ),  // input  [5:0]
    .rx_lane_aligner_fill                                 (                                                       ),  // output [6:0]
    .rx_lane_aligner_fill_start                           (                                                       ),  // output 
    .rx_lane_aligner_fill_valid                           (                                                       ),  // output 
    .rx_macif_clk                                         ( rx_macif_clk__DCMAC1                                  ),  // input  
    .rx_pcs_tdm_stats_data                                (                                                       ),  // output [43:0]
    .rx_pcs_tdm_stats_start                               (                                                       ),  // output 
    .rx_pcs_tdm_stats_valid                               (                                                       ),  // output 
    .rx_port_pm_rdy                                       (                                                       ),  // output [5:0]
    .rx_preambleout_0                                     ( rx_axis_preamble__DCMAC1[0]                           ),  // output [55:0]
    .rx_preambleout_1                                     ( rx_axis_preamble__DCMAC1[1]                           ),  // output [55:0]
    .rx_preambleout_2                                     ( rx_axis_preamble__DCMAC1[2]                           ),  // output [55:0]
    .rx_preambleout_3                                     ( rx_axis_preamble__DCMAC1[3]                           ),  // output [55:0]
    .rx_preambleout_4                                     ( rx_axis_preamble__DCMAC1[4]                           ),  // output [55:0]
    .rx_preambleout_5                                     ( rx_axis_preamble__DCMAC1[5]                           ),  // output [55:0]
    .rx_serdes_albuf_restart_0                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_1                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_2                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_3                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_4                            (                                                       ),  // output 
    .rx_serdes_albuf_restart_5                            (                                                       ),  // output 
    .rx_serdes_albuf_slip_0                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_1                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_2                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_3                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_4                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_5                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_6                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_7                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_8                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_9                               (                                                       ),  // output 
    .rx_serdes_albuf_slip_10                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_11                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_12                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_13                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_14                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_15                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_16                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_17                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_18                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_19                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_20                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_21                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_22                              (                                                       ),  // output 
    .rx_serdes_albuf_slip_23                              (                                                       ),  // output 
    .rx_serdes_clk                                        ( rx_serdes_clk__DCMAC1                                 ),  // input  [5:0]
    .rx_serdes_fifo_flagin_0                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_1                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_2                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_3                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_4                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagin_5                              ( 1'b0                                                  ),  // input  
    .rx_serdes_fifo_flagout_0                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_1                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_2                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_3                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_4                             (                                                       ),  // output 
    .rx_serdes_fifo_flagout_5                             (                                                       ),  // output 
    .rx_serdes_reset                                      ( rx_serdes_reset                                       ),  // input  [5:0]
    .rx_tsmac_tdm_stats_data                              ( rx_tsmac_tdm_stats_data__DCMAC1                       ),  // output [78:0]
    .rx_tsmac_tdm_stats_id                                ( rx_tsmac_tdm_stats_id__DCMAC1                         ),  // output [5:0]
    .rx_tsmac_tdm_stats_valid                             ( rx_tsmac_tdm_stats_valid__DCMAC1                      ),  // output 
    .apb3clk_quad                                         ( s_axi_aclk                                            ),  // input  
    .s_axi_araddr                                         ( s_axi_1_araddr                                        ),  // input  [31:0]
    .s_axi_arready                                        ( s_axi_1_arready                                       ),  // output 
    .s_axi_arvalid                                        ( s_axi_1_arvalid                                       ),  // input  
    .s_axi_awaddr                                         ( s_axi_1_awaddr                                        ),  // input  [31:0]
    .s_axi_awready                                        ( s_axi_1_awready                                       ),  // output 
    .s_axi_awvalid                                        ( s_axi_1_awvalid                                       ),  // input  
    .s_axi_bready                                         ( s_axi_1_bready                                        ),  // input  
    .s_axi_bresp                                          ( s_axi_1_bresp                                         ),  // output [1:0]
    .s_axi_bvalid                                         ( s_axi_1_bvalid                                        ),  // output 
    .s_axi_rdata                                          ( s_axi_1_rdata                                         ),  // output [31:0]
    .s_axi_rready                                         ( s_axi_1_rready                                        ),  // input  
    .s_axi_rresp                                          ( s_axi_1_rresp                                         ),  // output [1:0]
    .s_axi_rvalid                                         ( s_axi_1_rvalid                                        ),  // output 
    .s_axi_wdata                                          ( s_axi_1_wdata                                         ),  // input  [31:0]
    .s_axi_wready                                         ( s_axi_1_wready                                        ),  // output 
    .s_axi_wvalid                                         ( s_axi_1_wvalid                                        ),  // input  
    .s_axi_aclk                                           ( s_axi_aclk                                            ),  // input  
    .s_axi_aresetn                                        ( s_axi_aresetn                                         ),  // input  
    .ts_clk                                               ( {6{ts_clk__DCMAC1}}                                   ),  // input  [5:0]
    .tx_all_channel_mac_pm_rdy                            (                                                       ),  // output 
    .tx_all_channel_mac_pm_tick                           ( 1'b0                                                  ),  // input  
    .tx_alt_serdes_clk                                    ( tx_alt_serdes_clk__DCMAC1                             ),  // input  [5:0]
    .tx_axi_clk                                           ( clk_tx_axi__DCMAC1                                    ),  // input  
    .tx_axis_ch_status_id                                 (                                                       ),  // output [5:0]
    .tx_axis_ch_status_skip_req                           (                                                       ),  // output 
    .tx_axis_ch_status_vld                                (                                                       ),  // output 
    .tx_axis_id_req                                       (                                                       ),  // output [5:0]
    .tx_axis_id_req_vld                                   (                                                       ),  // output 
    .tx_axis_taf_0                                        ( tx_axis_af__DCMAC1[0]                                 ),  // output 
    .tx_axis_taf_1                                        ( tx_axis_af__DCMAC1[1]                                 ),  // output 
    .tx_axis_taf_2                                        ( tx_axis_af__DCMAC1[2]                                 ),  // output 
    .tx_axis_taf_3                                        ( tx_axis_af__DCMAC1[3]                                 ),  // output 
    .tx_axis_taf_4                                        ( tx_axis_af__DCMAC1[4]                                 ),  // output 
    .tx_axis_taf_5                                        ( tx_axis_af__DCMAC1[5]                                 ),  // output 
    .tx_axis_tdata0                                       ( tx_axis_pkt__DCMAC1.dat[0]                            ),  // input  [127:0]
    .tx_axis_tdata1                                       ( tx_axis_pkt__DCMAC1.dat[1]                            ),  // input  [127:0]
    .tx_axis_tdata2                                       ( tx_axis_pkt__DCMAC1.dat[2]                            ),  // input  [127:0]
    .tx_axis_tdata3                                       ( tx_axis_pkt__DCMAC1.dat[3]                            ),  // input  [127:0]
    .tx_axis_tdata4                                       ( tx_axis_pkt__DCMAC1.dat[4]                            ),  // input  [127:0]
    .tx_axis_tdata5                                       ( tx_axis_pkt__DCMAC1.dat[5]                            ),  // input  [127:0]
    .tx_axis_tdata6                                       ( tx_axis_pkt__DCMAC1.dat[6]                            ),  // input  [127:0]
    .tx_axis_tdata7                                       ( tx_axis_pkt__DCMAC1.dat[7]                            ),  // input  [127:0]
    .tx_axis_tdata8                                       ( tx_axis_pkt__DCMAC1.dat[8]                            ),  // input  [127:0]
    .tx_axis_tdata9                                       ( tx_axis_pkt__DCMAC1.dat[9]                            ),  // input  [127:0]
    .tx_axis_tdata10                                      ( tx_axis_pkt__DCMAC1.dat[10]                           ),  // input  [127:0]
    .tx_axis_tdata11                                      ( tx_axis_pkt__DCMAC1.dat[11]                           ),  // input  [127:0]
    .tx_axis_tid                                          ( tx_axis_pkt__DCMAC1.id                                ),  // input  [5:0]
    .tx_axis_tready_0                                     ( tx_axis_tready__DCMAC1[0]                             ),  // output 
    .tx_axis_tready_1                                     ( tx_axis_tready__DCMAC1[1]                             ),  // output 
    .tx_axis_tready_2                                     ( tx_axis_tready__DCMAC1[2]                             ),  // output 
    .tx_axis_tready_3                                     ( tx_axis_tready__DCMAC1[3]                             ),  // output 
    .tx_axis_tready_4                                     ( tx_axis_tready__DCMAC1[4]                             ),  // output 
    .tx_axis_tready_5                                     ( tx_axis_tready__DCMAC1[5]                             ),  // output 
    .tx_axis_tuser_ena0                                   ( tx_axis_pkt__DCMAC1.ena[0]                            ),  // input  
    .tx_axis_tuser_ena1                                   ( tx_axis_pkt__DCMAC1.ena[1]                            ),  // input  
    .tx_axis_tuser_ena2                                   ( tx_axis_pkt__DCMAC1.ena[2]                            ),  // input  
    .tx_axis_tuser_ena3                                   ( tx_axis_pkt__DCMAC1.ena[3]                            ),  // input  
    .tx_axis_tuser_ena4                                   ( tx_axis_pkt__DCMAC1.ena[4]                            ),  // input  
    .tx_axis_tuser_ena5                                   ( tx_axis_pkt__DCMAC1.ena[5]                            ),  // input  
    .tx_axis_tuser_ena6                                   ( tx_axis_pkt__DCMAC1.ena[6]                            ),  // input  
    .tx_axis_tuser_ena7                                   ( tx_axis_pkt__DCMAC1.ena[7]                            ),  // input  
    .tx_axis_tuser_ena8                                   ( tx_axis_pkt__DCMAC1.ena[8]                            ),  // input  
    .tx_axis_tuser_ena9                                   ( tx_axis_pkt__DCMAC1.ena[9]                            ),  // input  
    .tx_axis_tuser_ena10                                  ( tx_axis_pkt__DCMAC1.ena[10]                           ),  // input  
    .tx_axis_tuser_ena11                                  ( tx_axis_pkt__DCMAC1.ena[11]                           ),  // input  
    .tx_axis_tuser_eop0                                   ( tx_axis_pkt__DCMAC1.eop[0]                            ),  // input  
    .tx_axis_tuser_eop1                                   ( tx_axis_pkt__DCMAC1.eop[1]                            ),  // input  
    .tx_axis_tuser_eop2                                   ( tx_axis_pkt__DCMAC1.eop[2]                            ),  // input  
    .tx_axis_tuser_eop3                                   ( tx_axis_pkt__DCMAC1.eop[3]                            ),  // input  
    .tx_axis_tuser_eop4                                   ( tx_axis_pkt__DCMAC1.eop[4]                            ),  // input  
    .tx_axis_tuser_eop5                                   ( tx_axis_pkt__DCMAC1.eop[5]                            ),  // input  
    .tx_axis_tuser_eop6                                   ( tx_axis_pkt__DCMAC1.eop[6]                            ),  // input  
    .tx_axis_tuser_eop7                                   ( tx_axis_pkt__DCMAC1.eop[7]                            ),  // input  
    .tx_axis_tuser_eop8                                   ( tx_axis_pkt__DCMAC1.eop[8]                            ),  // input  
    .tx_axis_tuser_eop9                                   ( tx_axis_pkt__DCMAC1.eop[9]                            ),  // input  
    .tx_axis_tuser_eop10                                  ( tx_axis_pkt__DCMAC1.eop[10]                           ),  // input  
    .tx_axis_tuser_eop11                                  ( tx_axis_pkt__DCMAC1.eop[11]                           ),  // input  
    .tx_axis_tuser_err0                                   ( tx_axis_pkt__DCMAC1.err[0]                            ),  // input  
    .tx_axis_tuser_err1                                   ( tx_axis_pkt__DCMAC1.err[1]                            ),  // input  
    .tx_axis_tuser_err2                                   ( tx_axis_pkt__DCMAC1.err[2]                            ),  // input  
    .tx_axis_tuser_err3                                   ( tx_axis_pkt__DCMAC1.err[3]                            ),  // input  
    .tx_axis_tuser_err4                                   ( tx_axis_pkt__DCMAC1.err[4]                            ),  // input  
    .tx_axis_tuser_err5                                   ( tx_axis_pkt__DCMAC1.err[5]                            ),  // input  
    .tx_axis_tuser_err6                                   ( tx_axis_pkt__DCMAC1.err[6]                            ),  // input  
    .tx_axis_tuser_err7                                   ( tx_axis_pkt__DCMAC1.err[7]                            ),  // input  
    .tx_axis_tuser_err8                                   ( tx_axis_pkt__DCMAC1.err[8]                            ),  // input  
    .tx_axis_tuser_err9                                   ( tx_axis_pkt__DCMAC1.err[9]                            ),  // input  
    .tx_axis_tuser_err10                                  ( tx_axis_pkt__DCMAC1.err[10]                           ),  // input  
    .tx_axis_tuser_err11                                  ( tx_axis_pkt__DCMAC1.err[11]                           ),  // input  
    .tx_axis_tuser_mty0                                   ( tx_axis_pkt__DCMAC1.mty[0]                            ),  // input  [3:0]
    .tx_axis_tuser_mty1                                   ( tx_axis_pkt__DCMAC1.mty[1]                            ),  // input  [3:0]
    .tx_axis_tuser_mty2                                   ( tx_axis_pkt__DCMAC1.mty[2]                            ),  // input  [3:0]
    .tx_axis_tuser_mty3                                   ( tx_axis_pkt__DCMAC1.mty[3]                            ),  // input  [3:0]
    .tx_axis_tuser_mty4                                   ( tx_axis_pkt__DCMAC1.mty[4]                            ),  // input  [3:0]
    .tx_axis_tuser_mty5                                   ( tx_axis_pkt__DCMAC1.mty[5]                            ),  // input  [3:0]
    .tx_axis_tuser_mty6                                   ( tx_axis_pkt__DCMAC1.mty[6]                            ),  // input  [3:0]
    .tx_axis_tuser_mty7                                   ( tx_axis_pkt__DCMAC1.mty[7]                            ),  // input  [3:0]
    .tx_axis_tuser_mty8                                   ( tx_axis_pkt__DCMAC1.mty[8]                            ),  // input  [3:0]
    .tx_axis_tuser_mty9                                   ( tx_axis_pkt__DCMAC1.mty[9]                            ),  // input  [3:0]
    .tx_axis_tuser_mty10                                  ( tx_axis_pkt__DCMAC1.mty[10]                           ),  // input  [3:0]
    .tx_axis_tuser_mty11                                  ( tx_axis_pkt__DCMAC1.mty[11]                           ),  // input  [3:0]
    .tx_axis_tuser_skip_response                          ( 1'b0                                                  ),  // input  
    .tx_axis_tuser_sop0                                   ( tx_axis_pkt__DCMAC1.sop[0]                            ),  // input  
    .tx_axis_tuser_sop1                                   ( tx_axis_pkt__DCMAC1.sop[1]                            ),  // input  
    .tx_axis_tuser_sop2                                   ( tx_axis_pkt__DCMAC1.sop[2]                            ),  // input  
    .tx_axis_tuser_sop3                                   ( tx_axis_pkt__DCMAC1.sop[3]                            ),  // input  
    .tx_axis_tuser_sop4                                   ( tx_axis_pkt__DCMAC1.sop[4]                            ),  // input  
    .tx_axis_tuser_sop5                                   ( tx_axis_pkt__DCMAC1.sop[5]                            ),  // input  
    .tx_axis_tuser_sop6                                   ( tx_axis_pkt__DCMAC1.sop[6]                            ),  // input  
    .tx_axis_tuser_sop7                                   ( tx_axis_pkt__DCMAC1.sop[7]                            ),  // input  
    .tx_axis_tuser_sop8                                   ( tx_axis_pkt__DCMAC1.sop[8]                            ),  // input  
    .tx_axis_tuser_sop9                                   ( tx_axis_pkt__DCMAC1.sop[9]                            ),  // input  
    .tx_axis_tuser_sop10                                  ( tx_axis_pkt__DCMAC1.sop[10]                           ),  // input  
    .tx_axis_tuser_sop11                                  ( tx_axis_pkt__DCMAC1.sop[11]                           ),  // input  
    .tx_axis_tvalid_0                                     ( tx_gearbox_dout_vld__DCMAC1[0] | tx_axi_vld_mask__DCMAC1[0]   ),  // input  
    .tx_axis_tvalid_1                                     ( tx_gearbox_dout_vld__DCMAC1[1] | tx_axi_vld_mask__DCMAC1[1]   ),  // input  
    .tx_axis_tvalid_2                                     ( tx_gearbox_dout_vld__DCMAC1[2] | tx_axi_vld_mask__DCMAC1[2]   ),  // input  
    .tx_axis_tvalid_3                                     ( tx_gearbox_dout_vld__DCMAC1[3] | tx_axi_vld_mask__DCMAC1[3]   ),  // input  
    .tx_axis_tvalid_4                                     ( tx_gearbox_dout_vld__DCMAC1[4] | tx_axi_vld_mask__DCMAC1[4]   ),  // input  
    .tx_axis_tvalid_5                                     ( tx_gearbox_dout_vld__DCMAC1[5] | tx_axi_vld_mask__DCMAC1[5]   ),  // input  
    .tx_channel_flush                                     ( 6'd0                                                  ),  // input  [5:0]
    .tx_core_clk                                          ( tx_core_clk__DCMAC1                                   ),  // input  
    .tx_core_reset                                        ( tx_core_reset                                         ),  // input  
    .tx_flexif_clk                                        ( tx_flexif_clk__DCMAC1                                 ),  // input  [5:0]
    .tx_macif_clk                                         ( tx_macif_clk__DCMAC1                                  ),  // input  
    .tx_pcs_tdm_stats_data                                (                                                       ),  // output [21:0]
    .tx_pcs_tdm_stats_start                               (                                                       ),  // output 
    .tx_pcs_tdm_stats_valid                               (                                                       ),  // output 
    .tx_port_pm_rdy                                       (                                                       ),  // output [5:0]
    .tx_port_pm_tick                                      ( pm_tick_core                                          ),  // input  [5:0]
    .rx_port_pm_tick                                      ( pm_tick_core                                          ),  // input  [5:0]
    .tx_preamblein_0                                      ( tx_preamble__DCMAC1[0]                                ),  // input  [55:0]
    .tx_preamblein_1                                      ( tx_preamble__DCMAC1[1]                                ),  // input  [55:0]
    .tx_preamblein_2                                      ( tx_preamble__DCMAC1[2]                                ),  // input  [55:0]
    .tx_preamblein_3                                      ( tx_preamble__DCMAC1[3]                                ),  // input  [55:0]
    .tx_preamblein_4                                      ( tx_preamble__DCMAC1[4]                                ),  // input  [55:0]
    .tx_preamblein_5                                      ( tx_preamble__DCMAC1[5]                                ),  // input  [55:0]
    .tx_serdes_clk                                        ( tx_serdes_clk__DCMAC1                                 ),  // input  [5:0]
    .tx_serdes_is_am_0                                    (                                                       ),  // output 
    .tx_serdes_is_am_1                                    (                                                       ),  // output 
    .tx_serdes_is_am_2                                    (                                                       ),  // output 
    .tx_serdes_is_am_3                                    (                                                       ),  // output 
    .tx_serdes_is_am_4                                    (                                                       ),  // output 
    .tx_serdes_is_am_5                                    (                                                       ),  // output 
    .tx_serdes_is_am_prefifo_0                            (                                                       ),  // output 
    .tx_serdes_is_am_prefifo_1                            (                                                       ),  // output 
    .tx_serdes_is_am_prefifo_2                            (                                                       ),  // output 
    .tx_serdes_is_am_prefifo_3                            (                                                       ),  // output 
    .tx_serdes_is_am_prefifo_4                            (                                                       ),  // output 
    .tx_serdes_is_am_prefifo_5                            (                                                       ),  // output 
    .tx_tsmac_tdm_stats_data                              ( tx_tsmac_tdm_stats_data__DCMAC1                       ),  // output [55:0]
    .tx_tsmac_tdm_stats_id                                ( tx_tsmac_tdm_stats_id__DCMAC1                         ),  // output [5:0]
    .tx_tsmac_tdm_stats_valid                             ( tx_tsmac_tdm_stats_valid__DCMAC1                      ),  // output 
    .c0_stat_rx_corrected_lane_delay_0                    ( c0_stat_rx_corrected_lane_delay_0__DCMAC1             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_1                    ( c0_stat_rx_corrected_lane_delay_1__DCMAC1             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_2                    ( c0_stat_rx_corrected_lane_delay_2__DCMAC1             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_3                    ( c0_stat_rx_corrected_lane_delay_3__DCMAC1             ),  // output [15:0]
    .c0_stat_rx_corrected_lane_delay_valid                ( c0_stat_rx_corrected_lane_delay_valid__DCMAC1         ),  // output 
    .c1_stat_rx_corrected_lane_delay_0                    ( c1_stat_rx_corrected_lane_delay_0__DCMAC1             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_1                    ( c1_stat_rx_corrected_lane_delay_1__DCMAC1             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_2                    ( c1_stat_rx_corrected_lane_delay_2__DCMAC1             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_3                    ( c1_stat_rx_corrected_lane_delay_3__DCMAC1             ),  // output [15:0]
    .c1_stat_rx_corrected_lane_delay_valid                ( c1_stat_rx_corrected_lane_delay_valid__DCMAC1         ),  // output 
    .c2_stat_rx_corrected_lane_delay_0                    ( c2_stat_rx_corrected_lane_delay_0__DCMAC1             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_1                    ( c2_stat_rx_corrected_lane_delay_1__DCMAC1             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_2                    ( c2_stat_rx_corrected_lane_delay_2__DCMAC1             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_3                    ( c2_stat_rx_corrected_lane_delay_3__DCMAC1             ),  // output [15:0]
    .c2_stat_rx_corrected_lane_delay_valid                ( c2_stat_rx_corrected_lane_delay_valid__DCMAC1         ),  // output 
    .c3_stat_rx_corrected_lane_delay_0                    ( c3_stat_rx_corrected_lane_delay_0__DCMAC1             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_1                    ( c3_stat_rx_corrected_lane_delay_1__DCMAC1             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_2                    ( c3_stat_rx_corrected_lane_delay_2__DCMAC1             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_3                    ( c3_stat_rx_corrected_lane_delay_3__DCMAC1             ),  // output [15:0]
    .c3_stat_rx_corrected_lane_delay_valid                ( c3_stat_rx_corrected_lane_delay_valid__DCMAC1         ),  // output 
    .c4_stat_rx_corrected_lane_delay_0                    ( c4_stat_rx_corrected_lane_delay_0__DCMAC1             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_1                    ( c4_stat_rx_corrected_lane_delay_1__DCMAC1             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_2                    ( c4_stat_rx_corrected_lane_delay_2__DCMAC1             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_3                    ( c4_stat_rx_corrected_lane_delay_3__DCMAC1             ),  // output [15:0]
    .c4_stat_rx_corrected_lane_delay_valid                ( c4_stat_rx_corrected_lane_delay_valid__DCMAC1         ),  // output 
    .c5_stat_rx_corrected_lane_delay_0                    ( c5_stat_rx_corrected_lane_delay_0__DCMAC1             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_1                    ( c5_stat_rx_corrected_lane_delay_1__DCMAC1             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_2                    ( c5_stat_rx_corrected_lane_delay_2__DCMAC1             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_3                    ( c5_stat_rx_corrected_lane_delay_3__DCMAC1             ),  // output [15:0]
    .c5_stat_rx_corrected_lane_delay_valid                ( c5_stat_rx_corrected_lane_delay_valid__DCMAC1         ),  // output 
    .tx_serdes_reset                                      ( tx_serdes_reset                                       )   // input  [5:0]
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

  .tx_macif_clk                           (tx_macif_clk__DCMAC0),
  .tx_macif_ts_id_req_rdy                 (tx_macif_ts_id_req_rdy),
  .tx_macif_ts_id_req                     (tx_macif_ts_id_req),
  .tx_macif_ts_id_req_vld                 (tx_macif_ts_id_req_vld),

  .client_tx_frames_transmitted_latched   (tx_frames_transmitted_latched),
  .client_tx_bytes_transmitted_latched    (tx_bytes_transmitted_latched),
  .client_rx_frames_received_latched      (rx_frames_received_latched),
  .client_rx_bytes_received_latched       (rx_bytes_received_latched),
  .client_rx_preamble_err_cnt             (rx_preamble_err_cnt__DCMAC1),
  .client_rx_prbs_locked                  (rx_prbs_locked),
  .client_rx_prbs_err                     (rx_prbs_err),

  .gearbox_unf                            (tx_gearbox_unf__DCMAC0 | tx_gearbox_unf__DCMAC1),
  .gearbox_ovf                            (tx_gearbox_ovf__DCMAC0 | tx_gearbox_ovf__DCMAC1),

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

  always @(posedge clk_tx_axi__DCMAC0) begin
    tx_tsmac_tdm_stats_valid_reg <= tx_tsmac_tdm_stats_valid__DCMAC0;
    tx_tsmac_tdm_stats_id_reg    <= tx_tsmac_tdm_stats_id__DCMAC0   ;
    tx_tsmac_tdm_stats_data_reg  <= tx_tsmac_tdm_stats_data__DCMAC0 ;
  end

  always @(posedge clk_rx_axi__DCMAC1) begin
    rx_tsmac_tdm_stats_valid_reg <= rx_tsmac_tdm_stats_valid__DCMAC1;
    rx_tsmac_tdm_stats_id_reg    <= rx_tsmac_tdm_stats_id__DCMAC1   ;
    rx_tsmac_tdm_stats_data_reg  <= rx_tsmac_tdm_stats_data__DCMAC1 ;
  end

  dcmac_0_mac_tx_stats_cnt i_dcmac_0_mac_tx_stats_cnt (
    // status interface
    .stats_clk                  (clk_tx_axi__DCMAC0),
    .stats_rst                  (~rstn_tx_axi__DCMAC0),
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
    .stats_clk                  (clk_rx_axi__DCMAC1),
    .stats_rst                  (~rstn_rx_axi__DCMAC1),
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
    .clk              (clk_tx_axi__DCMAC0),
    .rst              (~rstn_tx_axi__DCMAC0),
    .i_pkt_ena        (tx_pkt_gen_ena),
    .i_clear_counters (clear_tx_counters[5:0]),
    .i_min_len        (tx_pkt_gen_min_len),
    .i_max_len        (tx_pkt_gen_max_len),
    .i_req_id         (pkt_gen_id_req[2:0]),
    .i_req_id_vld     (pkt_gen_id_req_vld),
    .i_skip_id        (tx_axis_ch_status_id[2:0]),
    .i_skip           (1'b0),
    .i_af             (tx_gearbox_af__DCMAC0),
    .o_skip_response  (tx_axis_tuser_skip_response),
    .o_pkt            (tx_gen_axis_pkt__DCMAC0),
    .o_pkt_vld        (tx_axis_pkt_valid),
    .o_pkt_cnt        (tx_frames_transmitted_latched),
    .o_byte_cnt       (tx_bytes_transmitted_latched)
  );

  //------------------------------------------
  // TX gearbox
  //------------------------------------------
  wire [5:0]      tx_gearbox_rst__DCMAC0, tx_gearbox_rst__DCMAC1;
  wire [5:0]      rx_gearbox_rst__DCMAC0, rx_gearbox_rst__DCMAC1;
  wire [2:0]      fixe_req_id;

  reg        axi_wvalid__DCMAC0, axi_wvalid__DCMAC1;
  reg [31:0] axi_awaddr__DCMAC0, axi_awaddr__DCMAC1;
  reg [31:0] axi_wdata__DCMAC0, axi_wdata__DCMAC1;

  always @ (posedge clk_apb3) begin
    axi_wvalid__DCMAC0 <= s_axi_0_wvalid;
    axi_awaddr__DCMAC0 <= s_axi_0_awaddr;
    axi_wdata__DCMAC0  <= s_axi_0_wdata;
    axi_wvalid__DCMAC1 <= s_axi_1_wvalid;
    axi_awaddr__DCMAC1 <= s_axi_1_awaddr;
    axi_wdata__DCMAC1  <= s_axi_1_wdata;
  end


  dcmac_0_core_sniffer i_dcmac_0_core_sniffer_0 (
    .clk_apb3              (clk_apb3),
    .rstn_apb3             (rstn_apb3),
    .clk_tx_axi            (clk_tx_axi__DCMAC0),
    .i_disable_tvalid_mask (scratch[3]),
    .i_wait_time           (4'd5),
    .i_set_time            (4'd10),
    //.apb3_wr_ena           (APB_M_penable & APB_M_psel & APB_M_pwrite),
    //.apb3_wr_addr          (APB_M_paddr),
    //.apb3_wr_dat           (APB_M_pwdata),
    .apb3_wr_ena           (axi_wvalid__DCMAC0),
    .apb3_wr_addr          (axi_awaddr__DCMAC0),
    .apb3_wr_dat           (axi_wdata__DCMAC0),	
    .o_independent_mode    (independent_mode__DCMAC0),
    .o_emu_tx_rst          (tx_gearbox_rst__DCMAC0),
    .o_emu_rx_rst          (rx_gearbox_rst__DCMAC0),
    .o_data_rate           (client_data_rate),
    .o_tx_axi_vld_mask     (tx_axi_vld_mask__DCMAC0),
    .o_tx_axi_req_id       (fixe_req_id)
  );

  dcmac_0_core_sniffer i_dcmac_0_core_sniffer_1 (
    .clk_apb3              (clk_apb3),
    .rstn_apb3             (rstn_apb3),
    .clk_tx_axi            (clk_tx_axi__DCMAC1),
    .i_disable_tvalid_mask (scratch[3]),
    .i_wait_time           (4'd5),
    .i_set_time            (4'd10),
    //.apb3_wr_ena           (APB_M_penable & APB_M_psel & APB_M_pwrite),
    //.apb3_wr_addr          (APB_M_paddr),
    //.apb3_wr_dat           (APB_M_pwdata),
    .apb3_wr_ena           (axi_wvalid__DCMAC1),
    .apb3_wr_addr          (axi_awaddr__DCMAC1),
    .apb3_wr_dat           (axi_wdata__DCMAC1),	
    .o_independent_mode    (independent_mode__DCMAC1),
    .o_emu_tx_rst          (tx_gearbox_rst__DCMAC1),
    .o_emu_rx_rst          (rx_gearbox_rst__DCMAC1),
    .o_data_rate           (),
    .o_tx_axi_vld_mask     (tx_axi_vld_mask__DCMAC1),
    .o_tx_axi_req_id       ()
  );

  dcmac_0_emu_gearbox_tx #(
    .REGISTER_INPUT (1)
  ) i_dcmac_0_emu_gearbox_tx_0 (
   .clk              (clk_tx_axi__DCMAC0),
   .rst              (tx_gearbox_rst__DCMAC0 | {6{independent_mode__DCMAC0}}),
   .i_pkt_ena        (tx_pkt_gen_ena[5:0]),
   .i_data_rate      (client_data_rate),
   .i_skip_response  (tx_axis_tuser_skip_response),
   .i_pkt            (tx_gen_axis_pkt__DCMAC0),
   .i_tready         (tx_axis_tready__DCMAC0),
   .o_af             (tx_gearbox_af__DCMAC0),
   .o_vld            (tx_gearbox_dout_vld__DCMAC0),
   .o_slice          (tx_gearbox_slice__DCMAC0),
   .o_preamble       (tx_preamble__DCMAC0),
   .o_underflow      (tx_gearbox_unf__DCMAC0), // latched, cleared by rst
   .o_overflow       (tx_gearbox_ovf__DCMAC0)  // latched, cleared by rst
  );

  assign pkt_gen_id_req = {3'd0, fixe_req_id};
  assign pkt_gen_id_req_vld = 1'b1;

  always @* begin
    for (int i=0; i<6; i++) begin
      {tx_axis_pkt__DCMAC0.ena[i*2+1], tx_axis_pkt__DCMAC0.ena[i*2]} = tx_gearbox_slice__DCMAC0[i].ena;
      {tx_axis_pkt__DCMAC0.sop[i*2+1], tx_axis_pkt__DCMAC0.sop[i*2]} = tx_gearbox_slice__DCMAC0[i].sop;
      {tx_axis_pkt__DCMAC0.eop[i*2+1], tx_axis_pkt__DCMAC0.eop[i*2]} = tx_gearbox_slice__DCMAC0[i].eop;
      {tx_axis_pkt__DCMAC0.err[i*2+1], tx_axis_pkt__DCMAC0.err[i*2]} = tx_gearbox_slice__DCMAC0[i].err;
      {tx_axis_pkt__DCMAC0.mty[i*2+1], tx_axis_pkt__DCMAC0.mty[i*2]} = tx_gearbox_slice__DCMAC0[i].mty;
      {tx_axis_pkt__DCMAC0.dat[i*2+1], tx_axis_pkt__DCMAC0.dat[i*2]} = tx_gearbox_slice__DCMAC0[i].dat;
    end
  end

  //------------------------------------------
  // SERDES TX to RX loopback
  //------------------------------------------
  //assign rx_serdes_data = tx_serdes_data;

  //------------------------------------------
  // RX gearbox
  //------------------------------------------
  assign rx_axis_pkt__DCMAC0.ena = (rx_axis_tvalid__DCMAC0[0] | !independent_mode__DCMAC0)? rx_axis_pkt_ena__DCMAC0 : '0;


  reg [5:0] rx_gearbox_valid__DCMAC0, rx_gearbox_valid__DCMAC1;


  //------------------------------------------
  // RX NoC transport
  //   Send registered slice across NoC
  //   400G data stream uses segments 0-7, port 0
  //------------------------------------------

  axis_rx_pkt_t    pkt_noc_in;
  reg              pkt_valid_noc_in;
  axis_tx_pkt_t    pkt_noc_out;
  wire [3:0]       pkt_valid_noc_out;
  wire [3:0]       pkt_ready_noc_out;
  wire [2:0]       rx_id_noc_out;
  wire             err_alignment_egr;
  wire [3:0]       err_overflow_ing;

  always @(posedge clk_rx_axi__DCMAC0) begin
    pkt_noc_in <= rx_axis_pkt__DCMAC0;
    pkt_valid_noc_in <= rx_axis_tvalid__DCMAC0[0];
  end

  bd_noc_wrapper  noc_inst (
    .s_aclk            ( clk_rx_axi__DCMAC0         ),   //  input
    .m_aclk            ( clk_tx_axi__DCMAC1         ),   //  input
    .arstn             ( ~rx_gearbox_rst__DCMAC0[0] ),   //  input
    `SEG_S_PORT(0),
    `SEG_S_PORT(1),
    `SEG_S_PORT(2),
    `SEG_S_PORT(3),
    `SEG_S_PORT(4),
    `SEG_S_PORT(5),
    `SEG_S_PORT(6),
    `SEG_S_PORT(7),
    `SEG_M_PORT(0),
    `SEG_M_PORT(1),
    `SEG_M_PORT(2),
    `SEG_M_PORT(3),
    `SEG_M_PORT(4),
    `SEG_M_PORT(5),
    `SEG_M_PORT(6),
    `SEG_M_PORT(7),
    .axiseg_valid_in   ( pkt_valid_noc_in           ),   //  input
    .axiseg_valid_out  ( pkt_valid_noc_out          ),   //  output [3:0]
    .axiseg_ready_out  ( pkt_ready_noc_out          ),   //  input  [3:0]
    .axiseg_tid_in     ( pkt_noc_in.id[2:0]         ),   //  input  [2:0]
    .axiseg_tid_out    ( pkt_noc_out.id[2:0]        ),   //  output [2:0]
    .err_alignment_egr ( err_alignment_egr          ),   //  output
    .err_overflow_ing  ( err_overflow_ing           )    //  output [3:0]
  );

// populate remaining array elements for completeness
  assign pkt_noc_out.ena[11:8] = 'h0;
  assign pkt_noc_out.sop[11:8] = 'h0;
  assign pkt_noc_out.eop[11:8] = 'h0;
  assign pkt_noc_out.err[11:8] = 'h0;
  assign pkt_noc_out.dat[11] = 'h0;
  assign pkt_noc_out.dat[10] = 'h0;
  assign pkt_noc_out.dat[9]  = 'h0;
  assign pkt_noc_out.dat[8]  = 'h0;
  assign pkt_noc_out.mty[11] = 'h0;
  assign pkt_noc_out.mty[10] = 'h0;
  assign pkt_noc_out.mty[9]  = 'h0;
  assign pkt_noc_out.mty[8]  = 'h0;

// gearbox backpressure, valid for ch=0 only
  assign pkt_ready_noc_out = tx_axis_tready__DCMAC1[3:0];
//  assign pkt_ready_noc_out = ~tx_axis_af__DCMAC1[0];

//  always @(posedge clk_tx_axi__DCMAC1) begin
  always_comb begin
    tx_axis_pkt__DCMAC1 = pkt_noc_out;
    // generate preamble
    case (pkt_noc_out.sop[3:0])
      4'b0001: tx_preamble__DCMAC1[0] = pkt_noc_out.dat[0][55:0];
      4'b0010: tx_preamble__DCMAC1[0] = pkt_noc_out.dat[1][55:0];
      4'b0100: tx_preamble__DCMAC1[0] = pkt_noc_out.dat[2][55:0];
      default: tx_preamble__DCMAC1[0] = pkt_noc_out.dat[3][55:0];
    endcase
    case (pkt_noc_out.sop[7:4])
      4'b0001: tx_preamble__DCMAC1[2] = pkt_noc_out.dat[4][55:0];
      4'b0010: tx_preamble__DCMAC1[2] = pkt_noc_out.dat[5][55:0];
      4'b0100: tx_preamble__DCMAC1[2] = pkt_noc_out.dat[6][55:0];
      default: tx_preamble__DCMAC1[2] = pkt_noc_out.dat[7][55:0];
    endcase
  end
  assign tx_gearbox_dout_vld__DCMAC1[3:0] = pkt_valid_noc_out;
  assign tx_gearbox_dout_vld__DCMAC1[5:4] = {2{1'b0}};

  //  ^  to 2nd DCMAC

  //  v  from 2nd DCMAC

  assign rx_axis_pkt__DCMAC1.ena = (rx_axis_tvalid__DCMAC1[0] | !independent_mode__DCMAC1)? rx_axis_pkt_ena__DCMAC1 : '0;

  always @(posedge clk_rx_axi__DCMAC1) begin

      rx_gearbox_valid__DCMAC1 <= rx_axis_tvalid__DCMAC1;
      rx_preamble__DCMAC1 <= rx_axis_preamble__DCMAC1;
      for (int i=0; i<6; i++) begin
        rx_gearbox_slice__DCMAC1[i].ena <= {rx_axis_pkt__DCMAC1.ena[i*2+1], rx_axis_pkt__DCMAC1.ena[i*2]};
        rx_gearbox_slice__DCMAC1[i].sop <= {rx_axis_pkt__DCMAC1.sop[i*2+1], rx_axis_pkt__DCMAC1.sop[i*2]};
        rx_gearbox_slice__DCMAC1[i].eop <= {rx_axis_pkt__DCMAC1.eop[i*2+1], rx_axis_pkt__DCMAC1.eop[i*2]};
        rx_gearbox_slice__DCMAC1[i].err <= {rx_axis_pkt__DCMAC1.err[i*2+1], rx_axis_pkt__DCMAC1.err[i*2]};
        rx_gearbox_slice__DCMAC1[i].mty <= {rx_axis_pkt__DCMAC1.mty[i*2+1], rx_axis_pkt__DCMAC1.mty[i*2]};
        rx_gearbox_slice__DCMAC1[i].dat <= {rx_axis_pkt__DCMAC1.dat[i*2+1], rx_axis_pkt__DCMAC1.dat[i*2]};
      end

  end

  dcmac_0_emu_gearbox_rx  i_dcmac_0_emu_gearbox_rx_1 (
    .clk                 (clk_rx_axi__DCMAC1),
    .rst                 (rx_gearbox_rst__DCMAC1 | {6{independent_mode__DCMAC1}}),
    .i_clear_counters    (clear_rx_counters[5:0]),
    .i_data_rate         (client_data_rate),
    .i_valid             (rx_gearbox_valid__DCMAC1),
    .i_slice             (rx_gearbox_slice__DCMAC1),
    .i_preamble          (rx_preamble__DCMAC1),
    .o_preamble_err_cnt  (rx_preamble_err_cnt__DCMAC1),
    .o_pkt               (rx_gearbox_o_pkt__DCMAC1)
  );

  always @(posedge clk_rx_axi__DCMAC1) begin
      rx_axis_pkt_mon <= rx_gearbox_o_pkt__DCMAC1;
  end

  //------------------------------------------
  // RX packet mon
  //------------------------------------------
  dcmac_0_axis_pkt_mon_ts #(
    .COUNTER_MODE  (COUNTER_MODE)
  ) i_dcmac_0_axis_pkt_mon_ts (
    .clk                   (clk_rx_axi__DCMAC1),
    .rst                   (~rstn_rx_axi__DCMAC1),
    .port_rst              (rx_gearbox_rst__DCMAC1),
    .i_pkt                 (rx_axis_pkt_mon),
    .i_clear_counters      (clear_rx_counters[5:0]),
    .o_pkt_cnt             (rx_frames_received_latched),
    .o_byte_cnt            (rx_bytes_received_latched),
    .o_prbs_locked         (rx_prbs_locked),
    .o_prbs_err_cnt        (rx_prbs_err)
  );


endmodule

