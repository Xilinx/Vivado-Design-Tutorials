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
module dcmac_0_axis_pkt_cnt (
  clk,
  rst,
  i_clear_counters,
  i_id_m1,
  i_sop,
  i_eop,
  i_size,
  o_byte_cnt,
  o_pkt_cnt,
  o_carry_id_m1,
  o_byte_cnt_carry,  // to be chained for wider counter if needed
  o_pkt_cnt_carry
);

  parameter REGISTER_INPUT = 1;

  input   clk;
  input   rst;
  input   [6-1:0] i_clear_counters;
  input   [2:0] i_id_m1;
  input   [11:0] i_sop;
  input   [11:0] i_eop;
  input   [7:0] i_size;
  output  reg [6-1:0][31:0] o_byte_cnt;
  output  reg [6-1:0][31:0] o_pkt_cnt;
  output  reg [2:0] o_carry_id_m1;
  output  reg o_byte_cnt_carry;
  output  reg o_pkt_cnt_carry;


  wire init;
  logic [7:0] size;
  reg [2:0] rd_during_wr;
  reg [1:0][6-1:0] clear_rx_counters;
  reg [6-1:0] clear_rx_pulse;
  reg [2:0] clear_rx_pulse_o;
  reg [3:0][2:0] id;
  reg [1:0] num_pkt;
  logic [7:0] pkt_cnt_l_i, pkt_cnt_l_o, byte_cnt_l_i, byte_cnt_l_o; // split 32b counter to multiple smaller counters for timing
  logic [8:0] pkt_cnt_nxt_0, byte_cnt_nxt_0;
  logic [12:0] pkt_cnt_nxt_1, byte_cnt_nxt_1;
  logic [12:0] pkt_cnt_nxt_2, byte_cnt_nxt_2;
  reg   [1:0] pkt_cnt_carry, byte_cnt_carry;
  logic [11:0] pkt_cnt_h0_i, pkt_cnt_h0_o, byte_cnt_h0_i, byte_cnt_h0_o;
  logic [11:0] pkt_cnt_h1_i, pkt_cnt_h1_o, byte_cnt_h1_i, byte_cnt_h1_o;


  always @* begin
    pkt_cnt_nxt_0 = clear_rx_pulse_o[0]? num_pkt: num_pkt + pkt_cnt_l_o;
    byte_cnt_nxt_0 = clear_rx_pulse_o[0]? size : size + byte_cnt_l_o;

    pkt_cnt_l_i = pkt_cnt_nxt_0[7:0];
    byte_cnt_l_i = byte_cnt_nxt_0[7:0];

    pkt_cnt_nxt_1 = clear_rx_pulse_o[1]? pkt_cnt_carry[0] : pkt_cnt_carry[0] + pkt_cnt_h0_o;
    byte_cnt_nxt_1 = clear_rx_pulse_o[1]? byte_cnt_carry[0] : byte_cnt_carry[0] + byte_cnt_h0_o;

    pkt_cnt_h0_i = pkt_cnt_nxt_1[11:0];
    byte_cnt_h0_i = byte_cnt_nxt_1[11:0];

    pkt_cnt_nxt_2 = clear_rx_pulse_o[2]? pkt_cnt_carry[1] : pkt_cnt_carry[1] + pkt_cnt_h1_o;
    byte_cnt_nxt_2 = clear_rx_pulse_o[2]? byte_cnt_carry[1] : byte_cnt_carry[1] + byte_cnt_h1_o;

    pkt_cnt_h1_i = pkt_cnt_nxt_2[11:0];
    byte_cnt_h1_i = byte_cnt_nxt_2[11:0];
  end

  always @(posedge clk) begin
    id <= {id, i_id_m1};
    size <= i_size;
    rd_during_wr[0] <= id[0] == i_id_m1 | init;
    rd_during_wr[1] <= rd_during_wr[0] | init;
    rd_during_wr[2] <= rd_during_wr[1] | init;

    num_pkt <= (|i_eop[3:0])
             + (|i_eop[7:4])
             + (|i_eop[11:8])
             ;

    clear_rx_counters <= {clear_rx_counters[0], i_clear_counters};
    clear_rx_pulse_o[0] <= clear_rx_pulse[id[0]];
    clear_rx_pulse_o[2:1] <= clear_rx_pulse_o[1:0];

    pkt_cnt_carry[0] <= pkt_cnt_nxt_0[8];
    byte_cnt_carry[0] <= byte_cnt_nxt_0[8];

    pkt_cnt_carry[1] <= pkt_cnt_nxt_1[12];
    byte_cnt_carry[1] <= byte_cnt_nxt_1[12];

    o_pkt_cnt_carry <= pkt_cnt_nxt_2[12];
    o_byte_cnt_carry <= byte_cnt_nxt_2[12];
    o_carry_id_m1 <= id[2];

    clear_rx_pulse[id[0]] <= 1'b0;
    for (int i=0; i<6; i++) begin
      if (clear_rx_counters[0][i] & ~clear_rx_counters[1][i]) begin
        clear_rx_pulse[i] <= 1'b1;
      end

      if (clear_rx_pulse_o[0]) begin
        o_pkt_cnt[id[1]][7:0] <= pkt_cnt_l_o;
        o_byte_cnt[id[1]][7:0] <= byte_cnt_l_o;
      end

      if (clear_rx_pulse_o[1]) begin
        o_pkt_cnt[id[2]][8+:12] <= pkt_cnt_h0_o;
        o_byte_cnt[id[2]][8+:12] <= byte_cnt_h0_o;
      end

      if (clear_rx_pulse_o[2]) begin
        o_pkt_cnt[id[3]][20+:12] <= pkt_cnt_h1_o;
        o_byte_cnt[id[3]][20+:12] <= byte_cnt_h1_o;
      end
    end

    if (rst) begin
      clear_rx_counters <= '0;
      o_pkt_cnt <= '0;
      o_byte_cnt <= '0;
    end
  end


  dcmac_0_ts_context_mem_v2  #(
    .DW (8 * 2),
    .ENABLE_RD_DURING_WR (1),
    .INIT_VALUE (0)
  ) i_dcmac_0_cnt_l_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (id[0]),
    .i_ena           (1'b1),
    .i_rd_during_wr  (rd_during_wr[0]),
    .i_dat           ({pkt_cnt_l_i, byte_cnt_l_i}),
    .o_dat           ({pkt_cnt_l_o, byte_cnt_l_o}),
    .o_init          (init)
  );

  dcmac_0_ts_context_mem_v2  #(
    .DW (12 * 2),
    .ENABLE_RD_DURING_WR (1),
    .INIT_VALUE (0)
  ) i_dcmac_0_cnt_h0_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (id[1]),
    .i_ena           (1'b1),
    .i_rd_during_wr  (rd_during_wr[1]),
    .i_dat           ({pkt_cnt_h0_i, byte_cnt_h0_i}),
    .o_dat           ({pkt_cnt_h0_o, byte_cnt_h0_o}),
    .o_init          ()
  );

  dcmac_0_ts_context_mem_v2  #(
    .DW (12 * 2),
    .ENABLE_RD_DURING_WR (1),
    .INIT_VALUE (0)
  ) i_dcmac_0_cnt_h1_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (id[2]),
    .i_ena           (1'b1),
    .i_rd_during_wr  (rd_during_wr[2]),
    .i_dat           ({pkt_cnt_h1_i, byte_cnt_h1_i}),
    .o_dat           ({pkt_cnt_h1_o, byte_cnt_h1_o}),
    .o_init          ()
  );

endmodule
