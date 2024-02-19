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
module dcmac_0_axis_pkt_mon_ts (
  clk,
  rst,
  port_rst,
  i_pkt,        // packet received from UUT
  i_clear_counters,
  o_pkt_cnt,
  o_byte_cnt,
  o_prbs_locked,
  o_prbs_err_cnt     // number of clock cycles with PRBS error/errors
);

  parameter COUNTER_MODE = 0;  // counter mode or PRBS mode

  typedef struct packed {
    logic [2:0]           id;
    logic [11:0]         ena;
    logic [11:0]         sop;
    logic [11:0]         eop;
    logic [11:0]         err;
    logic [11:0][3:0]    mty;
    logic [11:0][127:0]  dat;
  } lbus_pkt_t;

  input  clk;
  input  rst;
  input  [5:0] port_rst;
  input  lbus_pkt_t  i_pkt;
  input  [6-1:0] i_clear_counters;
  output logic [6-1:0][63:0]  o_pkt_cnt;
  output logic [6-1:0][63:0]  o_byte_cnt;
  output logic [6-1:0][31:0]  o_prbs_err_cnt;
  output logic [6-1:0]        o_prbs_locked;

  lbus_pkt_t [3:3] pkt_shift;
  wire [8:8][7:0] merge_size;
  wire [8:8][11:0][127:0] merge_data;

  reg   [8:1][11:0] eop;
  reg   [14:1][2:0] rx_id;
  wire  [14:14] prbs_locked;
  wire  [14:14] prbs_err;
  reg   [8:8] prbs_locked_pre;



  always @(posedge clk) begin
    if (rst) begin
      o_prbs_locked <= '0;
      eop <= '0;
    end
    else begin
      o_prbs_locked[rx_id[14]] <= prbs_locked[14];
      eop <= {eop, i_pkt.eop & i_pkt.ena};
      for (int i=0; i<6; i++) if (port_rst[i]) o_prbs_locked[i] <= 1'b0;
    end
  end


  always @(posedge clk) begin
    rx_id <= {rx_id, i_pkt.id};
    prbs_locked_pre[8] <= o_prbs_locked[rx_id[7]];
  end



  // segment shift: shift all the valid 16B segments together
  dcmac_0_axis_pkt_mon_shift_seg i_dcmac_0_shift_seg (
    .clk               (clk),
    .i_pkt             (i_pkt),
    .o_pkt             (pkt_shift[3])
  );


  // byte shift: shift mty
  dcmac_0_axis_pkt_mon_dat_merge i_dcmac_0_dat_merge (
    .clk               (clk),
    .i_pkt             (pkt_shift[3]),
    .o_size            (merge_size[8]),
    .o_dat             (merge_data[8])
  );

  // synthesis translate_off
  wire [191:0][7:0] byte_out;
  int j_max;
  reg [7:0] byte_nxt;
  reg [6-1:0][7:0] byte_ctx;
  reg [191:0] byte_err;
  reg [7:0] byte_err_idx;
  bit [6-1:0] found_err;

  assign byte_out = merge_data[8];

  always @(negedge clk) begin
    byte_nxt = byte_ctx[rx_id[8]];
    byte_err = '0;

    for (int i=0; i<merge_size[8]; i++) begin
      if(byte_nxt !== byte_out[i] & COUNTER_MODE) begin
        if (byte_err == 0) byte_err_idx <= i;
        byte_err[i] <= found_err[rx_id[8]];
        if (found_err[rx_id[8]]) begin
          $error ("ID[%2d]: found error in axis_pkt_mon_dat_merge.dat byte[%3d], expect 0x%x, received 0x%x ", rx_id[8], i, byte_nxt, byte_out[i]);
          $stop;
        end
        found_err[rx_id[8]] = 1'b1;
      end
      byte_nxt = byte_out[i] + 1'b1;
    end
    byte_ctx[rx_id[8]] <= byte_nxt;
  end
  // synthesis translate_on


  dcmac_0_prbs_mon_ts #(
    .COUNTER_MODE (COUNTER_MODE)
  ) i_dcmac_0_prbs_mon_ts   (
  .clk            (clk),
  .rst            (rst),
  .i_id           (rx_id[8]),
  .i_num_byte     (merge_size[8]),
  .i_dat          (merge_data[8]),
  .i_prbs_locked  (prbs_locked_pre[8]),
  .o_prbs_locked  (prbs_locked[14]),
  .o_prbs_err     (prbs_err[14])
  );

  wire  byte_cnt_carry, pkt_cnt_carry;
  wire  [2:0] carry_id_m1;
  wire  [6-1:0][31:0] byte_cnt_upper, byte_cnt_lower, pkt_cnt_upper, pkt_cnt_lower;

  always @* begin
    for (int i=0; i<6; i++) begin
      o_byte_cnt[i] = {byte_cnt_upper[i], byte_cnt_lower[i]};
      o_pkt_cnt[i] = {pkt_cnt_upper[i], pkt_cnt_lower[i]};
    end
  end

  dcmac_0_axis_pkt_cnt #(
    .REGISTER_INPUT (0)
  ) i_dcmac_0_pkt_cnt_lower_inst (
    .clk                 (clk),
    .rst                 (rst),
    .i_clear_counters    (i_clear_counters),
    .i_id_m1             (rx_id[7]),
    .i_sop               (),
    .i_eop               (eop[8]),
    .i_size              (merge_size[8]),
    .o_byte_cnt          (byte_cnt_lower),
    .o_pkt_cnt           (pkt_cnt_lower),
    .o_carry_id_m1       (carry_id_m1),
    .o_byte_cnt_carry    (byte_cnt_carry),
    .o_pkt_cnt_carry     (pkt_cnt_carry)
  );

  dcmac_0_axis_pkt_cnt #(
    .REGISTER_INPUT (0)
  ) i_dcmac_0_pkt_cnt_upper_inst (
    .clk                 (clk),
    .rst                 (rst),
    .i_clear_counters    (i_clear_counters),
    .i_id_m1             (carry_id_m1),
    .i_sop               ('0),
    .i_eop               ({11'd0, pkt_cnt_carry}),
    .i_size              ({7'd0, byte_cnt_carry}),
    .o_byte_cnt          (byte_cnt_upper),
    .o_pkt_cnt           (pkt_cnt_upper),
    .o_carry_id_m1       (),
    .o_byte_cnt_carry    (),
    .o_pkt_cnt_carry     ()
  );

  dcmac_0_axis_pkt_cnt #(
    .REGISTER_INPUT (0)
  ) i_dcmac_0_prbs_err_inst (
    .clk                 (clk),
    .rst                 (rst),
    .i_clear_counters    (i_clear_counters),
    .i_id_m1             (rx_id[13]),
    .i_sop               (),
    .i_eop               ({11'd0, prbs_err[14]}),
    .i_size              (),
    .o_byte_cnt          (),
    .o_pkt_cnt           (o_prbs_err_cnt),
    .o_carry_id_m1       (),
    .o_byte_cnt_carry    (),
    .o_pkt_cnt_carry     ()
  );



endmodule
