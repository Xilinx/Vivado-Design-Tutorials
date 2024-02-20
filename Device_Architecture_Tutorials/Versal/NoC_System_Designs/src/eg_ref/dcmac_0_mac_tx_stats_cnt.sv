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
module dcmac_0_mac_tx_stats_cnt (
  // status interface
  stats_clk,
  stats_rst,
  ts_rst_id,
  ts_rst,
  i_tdm_stats_valid,
  i_tdm_stats_id,
  i_tdm_stats,
  // APB3 interface
  apb3_clk,
  apb3_rstn,
  hard_rstn,
  APB_M_prdata,
  APB_M_pready,
  APB_M_pslverr,
  APB_M_paddr,
  APB_M_penable,
  APB_M_psel,
  APB_M_pwdata,
  APB_M_pwrite,
  // from the other APB3
  i_pm_tick
);


  input                         stats_clk;
  input                         stats_rst;
  input   [5:0]                 ts_rst_id;
  input                         ts_rst;
  input                         i_tdm_stats_valid;
  input   [5:0]                 i_tdm_stats_id;
  input   [55:0]                i_tdm_stats;
  input                         apb3_clk;
  input                         apb3_rstn;
  input                         hard_rstn;
  output  [31:0]                APB_M_prdata;
  output  [0:0]                 APB_M_pready;
  output  [0:0]                 APB_M_pslverr;
  input   [31:0]                APB_M_paddr;
  input                         APB_M_penable;
  input   [0:0]                 APB_M_psel;
  input   [31:0]                APB_M_pwdata;
  input                         APB_M_pwrite;
  input   [39:0]                i_pm_tick;


  wire            [7:0]                 axi_total_bytes;           // [55:48]
  wire            [7:0]                 axi_total_good_bytes;      // [47:40]
  wire            [3:0]                 axi_total_packets;         // [39:36]
  wire            [1:0]                 axi_total_good_packets;    // [35:34]
  wire            [1:0]                 axi_frame_error;           // [33:32]
  wire            [1:0]                 axi_bad_fcs;               // [31:30]
  wire            [1:0]                 axi_packet_64_bytes;       // [29:28]
  wire            [1:0]                 axi_packet_65_127_bytes;   // [27:26]
  wire            [1:0]                 axi_packet_128_255_bytes;  // [25:24]
  wire            [3:0]                 axi_packet_gt255_bytes;    // [23:20]
  wire                                  axi_packet_large;          // [19:19]
  wire            [1:0]                 axi_unicast;               // [18:17]
  wire            [1:0]                 axi_multicast;             // [16:15]
  wire            [1:0]                 axi_broadcast;             // [14:13]
  wire            [1:0]                 axi_vlan;                  // [12:11]
  wire            [1:0]                 axi_pause;                 // [10:19]
  wire            [1:0]                 axi_user_pause;            // [08:07]
  wire                                  axi_sic_overflow;          // [06:06]
  wire                                  axi_tsmac_unf;             // [05:05]
  wire                                  axi_tsmac_ovf;             // [04:04]
  wire                                  axi_local_fault;           // [03:03]
  wire                                  axi_packet_small;          // [02:02]
  wire                                  axis_unf;                  // [01:01]
  wire                                  axis_err;                  // [00:00]
  logic                                 len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215;



  always @* begin
    case (axi_packet_gt255_bytes)
      4'd1   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b1_0000_0000;
      4'd2   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_1000_0000;
      4'd3   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0100_0000;
      4'd4   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0010_0000;
      4'd5   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0001_0000;
      4'd6   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0000_1000;
      4'd7   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0000_0100;
      4'd8   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0000_0010;
      4'd9   : {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'b0_0000_0001;
      default: {len_256_511, len_512_1023, len_1024_1518, len_1519_1522, len_1523_1548, len_1549_2047, len_2048_4095, len_4096_8191, len_8192_9215} = 9'd0;
    endcase
  end

  assign {axi_total_bytes
         ,axi_total_good_bytes
         ,axi_total_packets
         ,axi_total_good_packets
         ,axi_frame_error
         ,axi_bad_fcs
         ,axi_packet_64_bytes
         ,axi_packet_65_127_bytes
         ,axi_packet_128_255_bytes
         ,axi_packet_gt255_bytes
         ,axi_packet_large
         ,axi_unicast
         ,axi_multicast
         ,axi_broadcast
         ,axi_vlan
         ,axi_pause
         ,axi_user_pause
         ,axi_sic_overflow
         ,axi_tsmac_unf
         ,axi_tsmac_ovf
         ,axi_local_fault
         ,axi_packet_small
         ,axis_unf
         ,axis_err
         } = i_tdm_stats;



  tsmac_tx_stats_cnt_external inst_tsmac_tx_stats_cnt (
    .clk                                (stats_clk),
    .rst                                (stats_rst),
    .ts_rst                             (ts_rst),
    .ts_rst_id                          (ts_rst_id),
    .i_stats_id_valid                   (i_tdm_stats_valid),
    .i_stats_id                         (i_tdm_stats_id),
    .i_stat_tx_total_bytes              (axi_total_bytes),
    .i_stat_tx_total_good_bytes         (axi_total_good_bytes),
    .i_stat_tx_total_packets            (axi_total_packets),
    .i_stat_tx_total_good_packets       (axi_total_good_packets),
    .i_stat_tx_frame_error              (axi_frame_error),
    .i_stat_tx_bad_fcs                  (axi_bad_fcs),
    .i_stat_tx_packet_64_bytes          (axi_packet_64_bytes),
    .i_stat_tx_packet_65_127_bytes      (axi_packet_65_127_bytes),
    .i_stat_tx_packet_128_255_bytes     (axi_packet_128_255_bytes),
    .i_stat_tx_packet_256_511_bytes     (len_256_511),
    .i_stat_tx_packet_512_1023_bytes    (len_512_1023),
    .i_stat_tx_packet_1024_1518_bytes   (len_1024_1518),
    .i_stat_tx_packet_1519_1522_bytes   (len_1519_1522),
    .i_stat_tx_packet_1523_1548_bytes   (len_1523_1548),
    .i_stat_tx_packet_1549_2047_bytes   (len_1549_2047),
    .i_stat_tx_packet_2048_4095_bytes   (len_2048_4095),
    .i_stat_tx_packet_4096_8191_bytes   (len_4096_8191),
    .i_stat_tx_packet_8192_9215_bytes   (len_8192_9215),
    .i_stat_tx_packet_large             (axi_packet_large),
    .i_stat_tx_unicast                  (axi_unicast),
    .i_stat_tx_multicast                (axi_multicast),
    .i_stat_tx_broadcast                (axi_broadcast),
    .i_stat_tx_vlan                     (axi_vlan),
    .i_stat_tx_pause                    (axi_pause),
    .i_stat_tx_user_pause               (axi_user_pause),
    .i_stat_tx_ecc_err0                 ('0),
    .i_stat_tx_ecc_err1                 ('0),
    .i_ecc_tick                         ('0),
    .rd_clk                             (apb3_clk),
    .i_pm_tick                          (i_pm_tick),
    .i_rd_id                            (APB_M_paddr[21:16]),
    .i_rd_index                         (APB_M_paddr[12:8]),
    .i_rd_h                             (APB_M_paddr[0]),
    .i_rd_en                            (APB_M_psel && APB_M_penable && !APB_M_pwrite),
    .o_init                             (),
    .o_cnt                              (APB_M_prdata),
    .o_cnt_vld                          (APB_M_pready)
  );

endmodule

