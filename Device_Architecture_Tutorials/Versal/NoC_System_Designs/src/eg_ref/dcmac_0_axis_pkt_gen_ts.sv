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
module dcmac_0_axis_pkt_gen_ts   (
  clk,                // clock
  rst,                // reset, active high
  i_pkt_ena,          // enable packet generation; bit [6] is global enable; the packets cannot be stopped in the middle
  i_min_len,          // the minimum packet length
  i_max_len,          // the maximum packet length
  i_clear_counters,
  i_req_id,           // channel ID that is to be served
  i_req_id_vld,       // i_req_id is valid
  i_skip_id,          // skip ID
  i_skip,             // stop for a cycle
  i_af,               // almost full, stop pkt gen until it is 0, used when i_skip is not used (i_skip is tied to 0)
  o_skip_response,    // skip response
  o_pkt,              // output packet
  o_pkt_vld,          // delayed version of i_req_id_vld
  o_byte_cnt,         // number of bytes sent
  o_pkt_cnt           // number of packets sent
);

  parameter COUNTER_MODE = 0;  // counter mode or PRBS mode


  typedef struct packed {
    logic [2:0]               id;
    logic [11:0]         ena;
    logic [11:0]         sop;
    logic [11:0]         eop;
    logic [11:0]         err;
    logic [11:0][3:0]    mty;
    logic [11:0][127:0]  dat;
  } lbus_pkt_t;


  typedef struct packed {
    logic [2:0]          id;
    logic [11:0]         ena;
    logic [11:0][15:0]   pkt_len;
    logic [11:0]         sop;
    logic [11:0]         eop;
    logic [11:0]         err;
    logic [11:0][3:0]    mty;
    logic [2:0][3:0]     pkt_mty_idx;
    logic [2:0][5:0]     mty_sum;
  } lbus_pkt_ctrl_t;


  input   clk;
  input   rst;
  input   [6:0] i_pkt_ena;
  input   [15:0] i_min_len;
  input   [15:0] i_max_len;
  input   [2:0] i_req_id;
  input   i_req_id_vld;
  input   [2:0] i_skip_id;
  input   i_skip;
  input   [6-1:0] i_af;
  input   [6-1:0] i_clear_counters;
  output  o_skip_response;
  output  lbus_pkt_t o_pkt;
  output  o_pkt_vld;
  output  logic [6-1:0][63:0]  o_byte_cnt;
  output  logic [6-1:0][63:0]  o_pkt_cnt;


  logic [13:0] is_backpressure;
  logic [13:0] req_id_vld;
  logic [5:4][7:0] ctrl_gen_o_size;
  lbus_pkt_ctrl_t [12:4] ctrl_gen_o_ctrl;
  logic [7:6] dat_req;
  logic [7:6][7:0] buf_size;
  logic [7:6][7:0] buf_idx;
  wire  [7:7][1536-1:0] prbs;
  wire  [11:11][1536-1:0] dat_pack;
  lbus_pkt_t [13:13] pkt_out;
  reg [40-1:0] skip_hold;

  assign is_backpressure[0] = skip_hold[i_req_id];
  assign o_skip_response = is_backpressure[13];
  assign o_pkt_vld = req_id_vld[13];

  assign req_id_vld[0] = i_req_id_vld;

  always @(posedge clk) begin
    ctrl_gen_o_size[5] <= ctrl_gen_o_size[4];
    ctrl_gen_o_ctrl[12:5] <= ctrl_gen_o_ctrl[12-1:4];
    ctrl_gen_o_ctrl[5].sop <= ctrl_gen_o_ctrl[4].sop & ctrl_gen_o_ctrl[4].ena;
    ctrl_gen_o_ctrl[5].eop <= ctrl_gen_o_ctrl[4].eop & ctrl_gen_o_ctrl[4].ena;

    buf_size[7:6+1] <= buf_size[7-1:6];
    buf_idx[7:6+1]  <= buf_idx[7-1:6];
    dat_req[7:6+1]  <= dat_req[7-1:6];

    is_backpressure[13:0+1] <= is_backpressure[12:0];

    req_id_vld[13:1] <= {req_id_vld[12:1], i_req_id_vld};

    if (i_req_id_vld) skip_hold[i_req_id] <= 1'b0;
    if (i_skip) begin
      skip_hold[i_skip_id] <= 1'b1;
      // synthesis translate_off
      if (skip_hold[i_skip_id]) begin
        $error("TODO: The packet generator does not allow two skip requests accumulated");
        $stop;
      end
      // synthesis translate_on
    end

    for (int i=0; i<6; i++) begin
      if(i_af[i]) skip_hold[i] <= 1'b1;
    end

    if (rst) skip_hold <= '0;
  end

  // generate random packet control information: sop, eop, ena, etc. with no actual data
  dcmac_0_axis_pkt_ctrl_gen i_dcmac_0_ctrl_gen (
    .clk          (clk),
    .rst          (rst),
    .i_pkt_ena    (i_pkt_ena),
    .i_min_len    (i_min_len),
    .i_max_len    (i_max_len),
    .i_req_id     (i_req_id),
    .i_req_id_vld (req_id_vld[0] & !is_backpressure[0]),
    .o_size       (ctrl_gen_o_size[4]),
    .o_pkt_ctrl   (ctrl_gen_o_ctrl[4])
  );


  // The prbs generator generates 192 bytes per clock cycle when data_req is 1
  // inst_buffer_ctx fetches a portion of it, and update the size of the remaining bytes
  dcmac_0_axis_pkt_gen_buffer_ctx i_dcmac_0_buffer_ctx (
    .clk           (clk),
    .rst           (rst),
    .i_id_valid_p1 (req_id_vld[5]),
    .i_id          (ctrl_gen_o_ctrl[4].id),
    .i_size        (ctrl_gen_o_size[4]),
    .o_id          (),
    .o_buf_size    (buf_size[6]),
    .o_buf_idx     (buf_idx[6]),
    .o_dat_req     (dat_req[6])
  );

  // merge the new data with the remaining bytes from the previous clock cycle
  dcmac_0_axis_pkt_gen_dat_merge  i_dcmac_0_dat_merge (
    .clk          (clk),
    .rst          (rst),
    .i_id_m1      (ctrl_gen_o_ctrl[6].id),
    .i_buf_size   (buf_size[7]),
    .i_buf_idx    (buf_idx[7]),
    .i_dat_ena    (dat_req[7]),
    .i_dat        (prbs[7]),
    .o_id         (),
    .o_dat        (dat_pack[11])
  );

  // PRBS generator
  dcmac_0_prbs_gen_ts #(
    .COUNTER_MODE (COUNTER_MODE)
  ) i_dcmac_0_prbs_gen (
    .clk         (clk),
    .rst         (rst),
    .i_id_m1     (ctrl_gen_o_ctrl[5].id),
    .i_req_en    (dat_req[6]),
    .i_req_num   (8'd192),
    .i_seed      (),
    .o_dat       (prbs[7])
  );

  // shift mty (0~15)
  dcmac_0_axis_pkt_gen_mty_shift #(
    .REGISTER_INPUT (0)
  ) i_dcmac_0_mty_shift (
    .clk         (clk),
    .i_pkt_ctrl  (ctrl_gen_o_ctrl[10]),
    .i_dat       (dat_pack[11]),
    .o_pkt       (pkt_out[13])
  );

  assign o_pkt = pkt_out[13];

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
    .i_id_m1             (ctrl_gen_o_ctrl[4].id),
    .i_sop               (ctrl_gen_o_ctrl[5].sop),
    .i_eop               (ctrl_gen_o_ctrl[5].eop),
    .i_size              (ctrl_gen_o_size[5]),
    .o_carry_id_m1       (carry_id_m1),
    .o_byte_cnt_carry    (byte_cnt_carry),
    .o_pkt_cnt_carry     (pkt_cnt_carry),
    .o_byte_cnt          (byte_cnt_lower),
    .o_pkt_cnt           (pkt_cnt_lower)
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


  // synthesis translate_off
  wire [11:0][15:0][7:0] byte_out;
  int j_max;
  reg [7:0] byte_nxt;
  reg [6-1:0][7:0] byte_ctx;
  reg [11:0] byte_err;
  bit [6-1:0] found_err;

  assign byte_out = o_pkt.dat;

  always @(negedge clk) begin
    byte_nxt = byte_ctx[o_pkt.id];
    byte_err <= '0;

    for (int i=0; i<12; i++) begin
      if (o_pkt.ena[i]) begin
        j_max = o_pkt.eop[i]? 16 - o_pkt.mty[i] : 16;
        for (int j=0; j<j_max; j++) begin
          if(byte_nxt !== byte_out[i][j] & COUNTER_MODE) begin
            byte_err[i] <= found_err[o_pkt.id];
            if(found_err[o_pkt.id]) begin
              $error ("ID %2d, segment %2d, byte %2d, expect %2x, received %2x", o_pkt.id, i, j, byte_nxt, byte_out[i][j]);
              $stop;
            end
            found_err[o_pkt.id] = 1'b1;
          end
          byte_nxt = byte_out[i][j] + 1'b1;
        end
      end
    end
    byte_ctx[o_pkt.id] <= byte_nxt;
  end
  // synthesis translate_on


endmodule
