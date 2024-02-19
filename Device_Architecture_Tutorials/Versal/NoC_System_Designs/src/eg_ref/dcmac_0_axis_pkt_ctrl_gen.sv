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
module dcmac_0_axis_pkt_ctrl_gen (
  clk,
  rst,
  i_pkt_ena,          // enable packet generation; bit [6] is global enable; the packets cannot be stopped in the middle
  i_min_len,          // the minimum packet length
  i_max_len,          // the maximum packet length
  i_req_id,           // channel ID that is to be served
  i_req_id_vld,       // i_req_id is valid
  o_size,
  o_pkt_ctrl
);

  localparam int POLY = 17'b1_0110_1000_0000_0001; // the polynomial used to generate the random packet length

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
  output  reg [7:0] o_size;
  output  lbus_pkt_ctrl_t o_pkt_ctrl;


  reg   [1:0][6:0] pkt_ena_reg;
  reg   [3:1] dat_req, pkt_ena;
  reg   [3:1][2:0] id;
  logic [2:0][13:0] pkt_len_r;
  logic [2:1][2:0][13:0] pkt_len_r_p;
  reg   [2:0][9:0] num_seg_in_pkt;
  logic [2:2] reach_max, wr_cnt_max, pkt_end;
  reg   [9:0] num_seg_in_pkt_0_0_pre;
  reg   [2:0][9:0] num_seg_in_pkt_0_0;
  logic [2:0][3:0] num_seg_in_pkt_0_0_need;
  logic [2:2][9:0] num_seg_sum_0_0;
  reg   [9:0] num_seg_in_pkt_1_0_pre;
  reg   [2:0][9:0] num_seg_in_pkt_1_0;
  logic [2:0][3:0] num_seg_in_pkt_1_0_need;
  logic [2:2][9:0] num_seg_sum_1_0;
  reg   [9:0] num_seg_in_pkt_2_0_pre;
  reg   [2:0][9:0] num_seg_in_pkt_2_0;
  logic [2:0][3:0] num_seg_in_pkt_2_0_need;
  logic [2:2][9:0] num_seg_sum_2_0;
  reg [9:0] sum_seg_in_pkt_1_0;
  reg   [3:3][2:0][3:0] seg_r;
  wire  [2:2][3:0] seg_r_i;
  logic [3:2][3:0] seg_r_o;
  logic [3:2] pkt_on_going_i;
  logic [3:2] pkt_on_going_o;
  logic [2:0][2:0][3:0] byte_r;
  logic [3:0][2:0][3:0] pkt_mty;
  wire  [2:2][3:0] byte_r_i;
  wire  [2:2][3:0] byte_r_o;
  reg   [3:3][3:0] mty_o;
  wire  [2:2][7:0] cnt_max_i;
  wire  [2:2][7:0] cnt_max_o;
  wire  [2:2][7:0] cnt_i;
  wire  [2:2][7:0] cnt_o;
  reg   [3:3][3:0] eop;
  logic [3:3][11:0][3:0] eop_mux;
  logic [3:3][11:0] ena_bus, sop_bus, eop_bus;
  logic [3:3][11:0][3:0] mty;
  logic [3:3][4-1:0] non_idle_seg_sum;
  logic [3:3][5:0] mty_sum;



  wire [255:0][1:0] mod3;
  wire [15:0][3:0] mod12;

  logic [11:0][1:0] seg_tmp;
  logic [11:0][9:0] num_seg_sum_mux;
  logic [11:0] num_seg_sum_gt_12, num_seg_sum_gt_12_reg;
  logic [11:0][3:0] byte_r_i_mux_pre, byte_r_i_mux, byte_r_i_mux_reg;
  logic [11:0][3:0] seg_r_i_mux, seg_r_i_mux_reg;
  logic [11:0][7:0] cnt_max_mux, cnt_max_mux_reg;


  assign byte_r_i [2] = byte_r_i_mux_reg[seg_r_o[2]];
  assign seg_r_i  [2] = seg_r_i_mux_reg [seg_r_o[2]];
  assign cnt_max_i[2] = cnt_max_mux_reg [seg_r_o[2]];

  assign cnt_i[2] = reach_max[2]? (|seg_r_o[2] | !pkt_on_going_o[2])? 6 : cnt_o[2]: cnt_o[2] + 3;
  assign reach_max[2] = cnt_o[2] >= cnt_max_o[2];
  assign wr_cnt_max[2] = dat_req[2] & reach_max[2] & (|seg_r_o[2] | !pkt_on_going_o[2]);
  assign pkt_end[2] = dat_req[2] & reach_max[2] & pkt_on_going_o[2];
  // pkt_on_going_i: pkt_on_going after the last byte of the current clock cycle
  assign pkt_on_going_i[2] = reach_max[2]? pkt_ena[2] & num_seg_sum_gt_12_reg[seg_r_o[2]] & (|seg_r_o[2] | !pkt_on_going_o[2]) : |pkt_on_going_o[2];


  // 1 segment = 16B
  // seg_r_o[2]: the segment number that the previous packet ends at
  assign num_seg_sum_0_0[2] = seg_r_o[2] + num_seg_in_pkt_0_0[2];
  assign num_seg_sum_1_0[2] = seg_r_o[2] + num_seg_in_pkt_1_0[2];
  assign num_seg_sum_2_0[2] = seg_r_o[2] + num_seg_in_pkt_2_0[2];

  always @* begin
    if (num_seg_in_pkt_0_0_need[0] <= 0) begin
      num_seg_sum_mux[0] = num_seg_in_pkt_0_0[0] + 0;
      byte_r_i_mux_pre[0] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 0) begin
      num_seg_sum_mux[0] = num_seg_in_pkt_1_0[0] + 0;
      byte_r_i_mux_pre[0] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[0] = num_seg_in_pkt_2_0[0] + 0;
      byte_r_i_mux_pre[0] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 1) begin
      num_seg_sum_mux[1] = num_seg_in_pkt_0_0[0] + 1;
      byte_r_i_mux_pre[1] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 1) begin
      num_seg_sum_mux[1] = num_seg_in_pkt_1_0[0] + 1;
      byte_r_i_mux_pre[1] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[1] = num_seg_in_pkt_2_0[0] + 1;
      byte_r_i_mux_pre[1] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 2) begin
      num_seg_sum_mux[2] = num_seg_in_pkt_0_0[0] + 2;
      byte_r_i_mux_pre[2] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 2) begin
      num_seg_sum_mux[2] = num_seg_in_pkt_1_0[0] + 2;
      byte_r_i_mux_pre[2] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[2] = num_seg_in_pkt_2_0[0] + 2;
      byte_r_i_mux_pre[2] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 3) begin
      num_seg_sum_mux[3] = num_seg_in_pkt_0_0[0] + 3;
      byte_r_i_mux_pre[3] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 3) begin
      num_seg_sum_mux[3] = num_seg_in_pkt_1_0[0] + 3;
      byte_r_i_mux_pre[3] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[3] = num_seg_in_pkt_2_0[0] + 3;
      byte_r_i_mux_pre[3] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 4) begin
      num_seg_sum_mux[4] = num_seg_in_pkt_0_0[0] + 4;
      byte_r_i_mux_pre[4] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 4) begin
      num_seg_sum_mux[4] = num_seg_in_pkt_1_0[0] + 4;
      byte_r_i_mux_pre[4] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[4] = num_seg_in_pkt_2_0[0] + 4;
      byte_r_i_mux_pre[4] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 5) begin
      num_seg_sum_mux[5] = num_seg_in_pkt_0_0[0] + 5;
      byte_r_i_mux_pre[5] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 5) begin
      num_seg_sum_mux[5] = num_seg_in_pkt_1_0[0] + 5;
      byte_r_i_mux_pre[5] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[5] = num_seg_in_pkt_2_0[0] + 5;
      byte_r_i_mux_pre[5] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 6) begin
      num_seg_sum_mux[6] = num_seg_in_pkt_0_0[0] + 6;
      byte_r_i_mux_pre[6] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 6) begin
      num_seg_sum_mux[6] = num_seg_in_pkt_1_0[0] + 6;
      byte_r_i_mux_pre[6] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[6] = num_seg_in_pkt_2_0[0] + 6;
      byte_r_i_mux_pre[6] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 7) begin
      num_seg_sum_mux[7] = num_seg_in_pkt_0_0[0] + 7;
      byte_r_i_mux_pre[7] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 7) begin
      num_seg_sum_mux[7] = num_seg_in_pkt_1_0[0] + 7;
      byte_r_i_mux_pre[7] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[7] = num_seg_in_pkt_2_0[0] + 7;
      byte_r_i_mux_pre[7] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 8) begin
      num_seg_sum_mux[8] = num_seg_in_pkt_0_0[0] + 8;
      byte_r_i_mux_pre[8] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 8) begin
      num_seg_sum_mux[8] = num_seg_in_pkt_1_0[0] + 8;
      byte_r_i_mux_pre[8] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[8] = num_seg_in_pkt_2_0[0] + 8;
      byte_r_i_mux_pre[8] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 9) begin
      num_seg_sum_mux[9] = num_seg_in_pkt_0_0[0] + 9;
      byte_r_i_mux_pre[9] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 9) begin
      num_seg_sum_mux[9] = num_seg_in_pkt_1_0[0] + 9;
      byte_r_i_mux_pre[9] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[9] = num_seg_in_pkt_2_0[0] + 9;
      byte_r_i_mux_pre[9] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 10) begin
      num_seg_sum_mux[10] = num_seg_in_pkt_0_0[0] + 10;
      byte_r_i_mux_pre[10] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 10) begin
      num_seg_sum_mux[10] = num_seg_in_pkt_1_0[0] + 10;
      byte_r_i_mux_pre[10] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[10] = num_seg_in_pkt_2_0[0] + 10;
      byte_r_i_mux_pre[10] = byte_r[0][2];
    end
    if (num_seg_in_pkt_0_0_need[0] <= 11) begin
      num_seg_sum_mux[11] = num_seg_in_pkt_0_0[0] + 11;
      byte_r_i_mux_pre[11] = byte_r[0][0];
    end
    else if (num_seg_in_pkt_1_0_need[0] <= 11) begin
      num_seg_sum_mux[11] = num_seg_in_pkt_1_0[0] + 11;
      byte_r_i_mux_pre[11] = byte_r[0][1];
    end
    else begin
      num_seg_sum_mux[11] = num_seg_in_pkt_2_0[0] + 11;
      byte_r_i_mux_pre[11] = byte_r[0][2];
    end
  end

  always @(posedge clk) begin
    for (int i=0; i<12; i++) begin
      cnt_max_mux[i] <= num_seg_sum_mux[i][9:2] + |num_seg_sum_mux[i][1:0];
      seg_tmp[i] = mod3[num_seg_sum_mux[i][9:2]];
      seg_r_i_mux[i] <= {seg_tmp[i], num_seg_sum_mux[i][1:0]};
      num_seg_sum_gt_12[i] <= num_seg_sum_mux[i] > 12;
      byte_r_i_mux[i] <= byte_r_i_mux_pre[i];
    end

    num_seg_sum_gt_12_reg <= num_seg_sum_gt_12;
    byte_r_i_mux_reg <= byte_r_i_mux;
    seg_r_i_mux_reg <= pkt_ena[1]? seg_r_i_mux : '0;
    cnt_max_mux_reg <= pkt_ena[1]? cnt_max_mux : '0;
  end

  //
  // generate random packet lengths
  //
  logic fb;
  logic [2:0][15:0] len_r_nxt;
  reg   [2:0][15:0] len_r;


  always @* begin
    for (int i=0; i<3; i++) begin
      fb = 1'b0;
      for (int j=16; j>=0; j--) begin
        fb = fb ^ (len_r[i][j] & POLY[j+1]);
      end
      len_r_nxt[i][15:1] = len_r[i][14:0];
      len_r_nxt[i][0] = fb;
    end
  end


  always @(posedge clk) begin
    //
    // generate random packet lengths
    //
    for (int i=0; i<3; i++) begin
      if (i_max_len <= i_min_len) begin
        pkt_len_r[i] <= i_min_len;
      end
      else if (len_r[i][13:0] <= i_max_len) begin
        pkt_len_r[i] <= (len_r[i][13:0] >= i_min_len)? len_r[i][13:0] : i_min_len;
      end
      else begin // len_r[i][13:0] > i_max_len
        pkt_len_r[i] <= '0;

        if (|len_r[i][9:0] & len_r[i][9:0] <= i_max_len & len_r[i][9:0] >= i_min_len) pkt_len_r[i] <= len_r[i][9:0];
        else if (|len_r[i][7:0] & len_r[i][7:0] <= i_max_len & len_r[i][7:0] >= i_min_len) pkt_len_r[i] <= len_r[i][7:0];
        else if  (|len_r[i][5:0] & len_r[i][5:0] <= i_max_len & len_r[i][5:0] >= i_min_len) pkt_len_r[i] <= len_r[i][5:0];
        else pkt_len_r[i] <= i_max_len;
      end
    end


    for (int i=0; i<3; i++) begin
      num_seg_in_pkt[i] <= pkt_len_r[i][13:4] + (|pkt_len_r[i][3:0]);
    end

    sum_seg_in_pkt_1_0 <= pkt_len_r[0][13:4] + (|pkt_len_r[0][3:0])
                        + pkt_len_r[1][13:4] + (|pkt_len_r[1][3:0]);

    num_seg_in_pkt_0_0_pre <= num_seg_in_pkt[0];

    num_seg_in_pkt_1_0_pre <= (num_seg_in_pkt[0][9] | num_seg_in_pkt[0][8])? '1 : 0
                             + sum_seg_in_pkt_1_0
                             ;

    num_seg_in_pkt_2_0_pre <= (num_seg_in_pkt[0][9] | num_seg_in_pkt[0][8] | num_seg_in_pkt[1][9] | num_seg_in_pkt[1][8])? '1 : 0
                             + sum_seg_in_pkt_1_0
                             + num_seg_in_pkt[2];;


    if (rst) begin
      for (int i=0; i<2; i++) begin
        len_r[i][3:0] <= i;
        len_r[i][15:4] <= '1;
      end
    end
    else begin
      len_r <= len_r_nxt;
    end

  end




  always @* begin
    for(int i=0; i<12; i++) begin
      ena_bus[3][i] = dat_req[3] & (pkt_ena[3] | pkt_on_going_i[3] | pkt_on_going_o[3] & (i < seg_r_o[3] | seg_r_o[3] == '0));

      if (i==0)
        sop_bus[3][0] = !pkt_on_going_o[3];
      else
        sop_bus[3][i] = eop[3][0] & i == seg_r_o[3] // after pkt[-1]'s eop
                      | eop[3][1] & i == seg_r[3][0] // after pkt[0]'s eop
                      | eop[3][2] & i == seg_r[3][1] // after pkt[1]'s eop
                      ;


      eop_mux[3][i][0] = eop[3][0] & (i+1)%12 == seg_r_o[3];
      eop_mux[3][i][1] = eop[3][1] & (i+1)%12 == seg_r[3][0];
      eop_mux[3][i][2] = eop[3][2] & (i+1)%12 == seg_r[3][1];
      eop_mux[3][i][3] = eop[3][3] & (i+1)%12 == seg_r[3][2];

      eop_bus[3][i] = |eop_mux[3][i];

      mty[3][i] = eop_mux[3][i][0]? mty_o[3]
                : eop_mux[3][i][1]? pkt_mty[3][0]
                : eop_mux[3][i][2]? pkt_mty[3][1]
                : eop_mux[3][i][3]? pkt_mty[3][2]
                : '0;
    end

    mty_sum[3] = eop[3][0]? mty_o[3] : 0;

    if (eop[3][1]) mty_sum[3] += pkt_mty[3][0];
    if (eop[3][2]) mty_sum[3] += pkt_mty[3][1];
    if (eop[3][3]) mty_sum[3] += pkt_mty[3][2];

    non_idle_seg_sum[3] = (pkt_ena[3] | pkt_on_going_i[3])? 12 : (seg_r_o[3] == '0)? 12 : seg_r_o[3];
  end

  wire [3:3][2:0][3:0] mty_mux;
  wire [3:3][2:0][3:0] seg_mux;

  assign seg_mux[3][0] = pkt_on_going_o[3]? (eop[3][0]? seg_r_o[3] : 12) : (eop[3][1]? seg_r[3][0] : 12);
  assign mty_mux[3][0] = pkt_on_going_o[3]? mty_o[3] & {4{eop[3][0]}} : pkt_mty[3][0] & {4{eop[3][1]}};

  assign seg_mux[3][1] = pkt_on_going_o[3]? (eop[3][1]? seg_r[3][0] : 12) : (eop[3][2]? seg_r[3][1] : 12);
  assign mty_mux[3][1] = pkt_on_going_o[3]? pkt_mty[3][0] & {4{eop[3][1]}} : pkt_mty[3][1] & {4{eop[3][2]}};

  assign seg_mux[3][2] = pkt_on_going_o[3]? (eop[3][2]? seg_r[3][1] : 12) : (eop[3][3]? seg_r[3][2] : 12);
  assign mty_mux[3][2] = pkt_on_going_o[3]? pkt_mty[3][1] & {4{eop[3][2]}} : pkt_mty[3][2] & {4{eop[3][3]}};


  always @(posedge clk) begin
    pkt_ena_reg <= {pkt_ena_reg, i_pkt_ena};
    pkt_ena[1] <= ((i_req_id < 6)? pkt_ena_reg[1][i_req_id] : 1'b0) | pkt_ena_reg[1][6];
    pkt_ena[3:2] <= pkt_ena[2:1];
    pkt_on_going_i[3:3] <= pkt_on_going_i[2:2];

    dat_req <= rst? 0 : {dat_req, i_req_id_vld};
    id <= {id, i_req_id};

    num_seg_in_pkt_0_0[0] <= num_seg_in_pkt_0_0_pre; // num_seg_in_pkt_0_0[1] is 3 clock cycles delay to pkt_len_r
    num_seg_in_pkt_0_0_need[0] <= (num_seg_in_pkt_0_0_pre >= 12)? 0 : 12 - num_seg_in_pkt_0_0_pre;

    num_seg_in_pkt_0_0[2:1] <= num_seg_in_pkt_0_0[2-1:0];
    num_seg_in_pkt_0_0_need[2:1] <= num_seg_in_pkt_0_0_need[2-1:0];


    num_seg_in_pkt_1_0[0] <= num_seg_in_pkt_1_0_pre; // num_seg_in_pkt_1_0[1] is 3 clock cycles delay to pkt_len_r
    num_seg_in_pkt_1_0_need[0] <= (num_seg_in_pkt_1_0_pre >= 12)? 0 : 12 - num_seg_in_pkt_1_0_pre;

    num_seg_in_pkt_1_0[2:1] <= num_seg_in_pkt_1_0[2-1:0];
    num_seg_in_pkt_1_0_need[2:1] <= num_seg_in_pkt_1_0_need[2-1:0];


    num_seg_in_pkt_2_0[0] <= num_seg_in_pkt_2_0_pre; // num_seg_in_pkt_2_0[1] is 3 clock cycles delay to pkt_len_r
    num_seg_in_pkt_2_0_need[0] <= (num_seg_in_pkt_2_0_pre >= 12)? 0 : 12 - num_seg_in_pkt_2_0_pre;

    num_seg_in_pkt_2_0[2:1] <= num_seg_in_pkt_2_0[2-1:0];
    num_seg_in_pkt_2_0_need[2:1] <= num_seg_in_pkt_2_0_need[2-1:0];



    pkt_len_r_p <= {pkt_len_r_p, pkt_len_r};

    for (int i=0; i<3; i++) begin
      byte_r[0][i] <= pkt_len_r_p[2][i][3:0]; // byte_r[0] is aligned with num_seg_in_pkt_[2:0]_0[0], 3 clock cycles delay to pkt_len_r
      pkt_mty[0][i] <= 16 - pkt_len_r_p[2][i][3:0];
    end

    byte_r[2:1] <= byte_r[1:0];
    pkt_mty[3:1] <= pkt_mty[2:0];

    seg_r[3][0] <= mod12[num_seg_sum_0_0[2][3:0]];
    seg_r[3][1] <= mod12[num_seg_sum_1_0[2][3:0]];
    seg_r[3][2] <= mod12[num_seg_sum_2_0[2][3:0]];

    mty_o[3] <= 16 - byte_r_o[2];
    seg_r_o[3:3] <= seg_r_o[2:2];
    pkt_on_going_o[3:3] <= pkt_on_going_o[2:2];

    eop[3][0] <= pkt_end[2];
    eop[3][1] <= pkt_ena[2]? pkt_on_going_o[2]? pkt_end[2] & seg_r_o[2] <= num_seg_in_pkt_0_0_need[2] & |seg_r_o[2] : num_seg_in_pkt_0_0[2] <= 12 : 1'b0;
    eop[3][2] <= pkt_ena[2]? pkt_on_going_o[2]? pkt_end[2] & seg_r_o[2] <= num_seg_in_pkt_1_0_need[2] & |seg_r_o[2] : num_seg_in_pkt_1_0[2] <= 12 : 1'b0;
    eop[3][3] <= pkt_ena[2]? pkt_on_going_o[2]? pkt_end[2] & seg_r_o[2] <= num_seg_in_pkt_2_0_need[2] & |seg_r_o[2] : num_seg_in_pkt_2_0[2] <= 12 : 1'b0;


    o_pkt_ctrl.id  <= id[3];
    o_pkt_ctrl.ena <= ena_bus[3];
    o_pkt_ctrl.sop <= sop_bus[3];
    o_pkt_ctrl.eop <= eop_bus[3];
    o_pkt_ctrl.mty <= mty[3];
    o_pkt_ctrl.err <= '0;

    o_pkt_ctrl.pkt_mty_idx[0] <= (seg_mux[3][0] == 0)? 12 : seg_mux[3][0];   // number of segments before sop
    o_pkt_ctrl.mty_sum[0] <= mty_mux[3][0]
                           ;
    o_pkt_ctrl.pkt_mty_idx[1] <= (seg_mux[3][1] == 0)? 12 : seg_mux[3][1];   // number of segments before sop
    o_pkt_ctrl.mty_sum[1] <= mty_mux[3][0]
                           + mty_mux[3][1]
                           ;
    o_pkt_ctrl.pkt_mty_idx[2] <= (seg_mux[3][2] == 0)? 12 : seg_mux[3][2];   // number of segments before sop
    o_pkt_ctrl.mty_sum[2] <= mty_mux[3][0]
                           + mty_mux[3][1]
                           + mty_mux[3][2]
                           ;


    o_size <= (rst | ~|ena_bus[3])? '0 : {non_idle_seg_sum[3], 4'd0} - mty_sum[3];
  end


  dcmac_0_ts_context_mem_v2  #(
    .DW (8 + 4 + 4),
    .INIT_VALUE (0)
  ) i_dcmac_0_cnt_max_ctx (
    .clk         (clk),
    .rst         (rst),
    .ts_rst      (1'b0),
    .i_rd_id     (id[1]),
    .i_ena       (wr_cnt_max[2]),
    .i_dat       ({cnt_max_i[2], seg_r_i[2], byte_r_i[2]}),
    .o_dat       ({cnt_max_o[2], seg_r_o[2], byte_r_o[2]}),
    .i_rd_during_wr  (),
    .o_init          ()
  );

  dcmac_0_ts_context_mem_v2  #(
    .DW (1 + 8),
    .INIT_VALUE (0)
  ) i_dcmac_0_cnt_ctx (
    .clk         (clk),
    .rst         (rst),
    .ts_rst      (1'b0),
    .i_rd_id     (id[1]),
    .i_ena       (dat_req[2]),
    .i_dat       ({pkt_on_going_i[2], cnt_i[2]}),
    .o_dat       ({pkt_on_going_o[2], cnt_o[2]}),
    .i_rd_during_wr  (),
    .o_init          ()
  );


  // synthesis translate_off
  reg [5:0][2:0][13:0] pkt_len_p;
  reg [6-1:0][13:0] pkt_len_mem, pkt_len_cal;
  reg [6-1:0] pkt_on_going;
  logic [5:0] pkt_num;
  logic [3:3][11:0][13:0] pkt_len;
  logic pkt_err;
  logic pkt_len_err;
  logic size_out_err;
  logic [13:0] pkt_len_nxt, pkt_len_cal_hold, pkt_len_ctrl;
  logic pkt_on_going_nxt;
  logic [15:0] cycle_byte_cnt;


  always @* begin
    pkt_len[3][0] = pkt_len_mem[id[3]];
    pkt_num = '0;
    pkt_len_nxt = pkt_len_cal[o_pkt_ctrl.id];
    pkt_on_going_nxt = pkt_on_going[o_pkt_ctrl.id];
    cycle_byte_cnt = 0;

    pkt_err = 1'b0;
    pkt_len_err = 1'b0;
    size_out_err = 1'b0;

    for(int i=0; i<12; i++) begin
      if (sop_bus[3][i]) begin
        pkt_len[3][i] =  pkt_len_p[5][pkt_num];
        pkt_num++;
      end
      else if (i>0) begin
        pkt_len[3][i] = pkt_len[3][i-1];
      end

      if (o_pkt_ctrl.ena[i]) begin
        cycle_byte_cnt += 16;

        if (o_pkt_ctrl.sop[i]) begin
          pkt_len_nxt = 16;
          pkt_err = pkt_on_going_nxt;
          pkt_on_going_nxt = 1'b1;
        end
        else if (o_pkt_ctrl.eop[i]) begin
          pkt_len_nxt += 16 - o_pkt_ctrl.mty[i];
          cycle_byte_cnt -= o_pkt_ctrl.mty[i];
          pkt_len_err = pkt_len_nxt != o_pkt_ctrl.pkt_len[i];
          if (pkt_len_err) begin
            pkt_len_cal_hold = pkt_len_nxt;
            pkt_len_ctrl = o_pkt_ctrl.pkt_len[i];
          end
          pkt_err = !pkt_on_going_nxt;
          pkt_on_going_nxt = 1'b0;
        end
        else begin
          pkt_len_nxt += 16;
          pkt_err = !pkt_on_going_nxt;
        end
      end // end ena
    end

    if (cycle_byte_cnt !== o_size) size_out_err = 1'b1;
  end

  always @(posedge clk) begin
    pkt_len_p <= {pkt_len_p, pkt_len_r};
    if (dat_req[3]) pkt_len_mem[id[3]] <= pkt_len[3][11];

    for(int i=0; i<12; i++) begin
      o_pkt_ctrl.pkt_len[i] <= pkt_len[3][i];
    end

    pkt_len_cal[o_pkt_ctrl.id] <= pkt_len_nxt;
    pkt_on_going[o_pkt_ctrl.id] <= pkt_on_going_nxt;
  end

  always @(negedge clk) begin
    if (pkt_err && o_pkt_ctrl.id < 6) begin
      $error ("pkt violation");
      $stop;
    end

    if (pkt_len_err && o_pkt_ctrl.id < 6) begin
      $error ("ID[%d] pkt length err, calcuated %d, expect %d", o_pkt_ctrl.id, pkt_len_cal_hold, pkt_len_ctrl);
      $stop;
    end

    if (size_out_err && o_pkt_ctrl.id < 6) begin
      $error ("ID[%d] size_out error", o_pkt_ctrl.id);
      $stop;
    end
  end
  // synthesis translate_on



  assign mod3[0] = 2'd0;
  assign mod3[1] = 2'd1;
  assign mod3[2] = 2'd2;
  assign mod3[3] = 2'd0;
  assign mod3[4] = 2'd1;
  assign mod3[5] = 2'd2;
  assign mod3[6] = 2'd0;
  assign mod3[7] = 2'd1;
  assign mod3[8] = 2'd2;
  assign mod3[9] = 2'd0;
  assign mod3[10] = 2'd1;
  assign mod3[11] = 2'd2;
  assign mod3[12] = 2'd0;
  assign mod3[13] = 2'd1;
  assign mod3[14] = 2'd2;
  assign mod3[15] = 2'd0;
  assign mod3[16] = 2'd1;
  assign mod3[17] = 2'd2;
  assign mod3[18] = 2'd0;
  assign mod3[19] = 2'd1;
  assign mod3[20] = 2'd2;
  assign mod3[21] = 2'd0;
  assign mod3[22] = 2'd1;
  assign mod3[23] = 2'd2;
  assign mod3[24] = 2'd0;
  assign mod3[25] = 2'd1;
  assign mod3[26] = 2'd2;
  assign mod3[27] = 2'd0;
  assign mod3[28] = 2'd1;
  assign mod3[29] = 2'd2;
  assign mod3[30] = 2'd0;
  assign mod3[31] = 2'd1;
  assign mod3[32] = 2'd2;
  assign mod3[33] = 2'd0;
  assign mod3[34] = 2'd1;
  assign mod3[35] = 2'd2;
  assign mod3[36] = 2'd0;
  assign mod3[37] = 2'd1;
  assign mod3[38] = 2'd2;
  assign mod3[39] = 2'd0;
  assign mod3[40] = 2'd1;
  assign mod3[41] = 2'd2;
  assign mod3[42] = 2'd0;
  assign mod3[43] = 2'd1;
  assign mod3[44] = 2'd2;
  assign mod3[45] = 2'd0;
  assign mod3[46] = 2'd1;
  assign mod3[47] = 2'd2;
  assign mod3[48] = 2'd0;
  assign mod3[49] = 2'd1;
  assign mod3[50] = 2'd2;
  assign mod3[51] = 2'd0;
  assign mod3[52] = 2'd1;
  assign mod3[53] = 2'd2;
  assign mod3[54] = 2'd0;
  assign mod3[55] = 2'd1;
  assign mod3[56] = 2'd2;
  assign mod3[57] = 2'd0;
  assign mod3[58] = 2'd1;
  assign mod3[59] = 2'd2;
  assign mod3[60] = 2'd0;
  assign mod3[61] = 2'd1;
  assign mod3[62] = 2'd2;
  assign mod3[63] = 2'd0;
  assign mod3[64] = 2'd1;
  assign mod3[65] = 2'd2;
  assign mod3[66] = 2'd0;
  assign mod3[67] = 2'd1;
  assign mod3[68] = 2'd2;
  assign mod3[69] = 2'd0;
  assign mod3[70] = 2'd1;
  assign mod3[71] = 2'd2;
  assign mod3[72] = 2'd0;
  assign mod3[73] = 2'd1;
  assign mod3[74] = 2'd2;
  assign mod3[75] = 2'd0;
  assign mod3[76] = 2'd1;
  assign mod3[77] = 2'd2;
  assign mod3[78] = 2'd0;
  assign mod3[79] = 2'd1;
  assign mod3[80] = 2'd2;
  assign mod3[81] = 2'd0;
  assign mod3[82] = 2'd1;
  assign mod3[83] = 2'd2;
  assign mod3[84] = 2'd0;
  assign mod3[85] = 2'd1;
  assign mod3[86] = 2'd2;
  assign mod3[87] = 2'd0;
  assign mod3[88] = 2'd1;
  assign mod3[89] = 2'd2;
  assign mod3[90] = 2'd0;
  assign mod3[91] = 2'd1;
  assign mod3[92] = 2'd2;
  assign mod3[93] = 2'd0;
  assign mod3[94] = 2'd1;
  assign mod3[95] = 2'd2;
  assign mod3[96] = 2'd0;
  assign mod3[97] = 2'd1;
  assign mod3[98] = 2'd2;
  assign mod3[99] = 2'd0;
  assign mod3[100] = 2'd1;
  assign mod3[101] = 2'd2;
  assign mod3[102] = 2'd0;
  assign mod3[103] = 2'd1;
  assign mod3[104] = 2'd2;
  assign mod3[105] = 2'd0;
  assign mod3[106] = 2'd1;
  assign mod3[107] = 2'd2;
  assign mod3[108] = 2'd0;
  assign mod3[109] = 2'd1;
  assign mod3[110] = 2'd2;
  assign mod3[111] = 2'd0;
  assign mod3[112] = 2'd1;
  assign mod3[113] = 2'd2;
  assign mod3[114] = 2'd0;
  assign mod3[115] = 2'd1;
  assign mod3[116] = 2'd2;
  assign mod3[117] = 2'd0;
  assign mod3[118] = 2'd1;
  assign mod3[119] = 2'd2;
  assign mod3[120] = 2'd0;
  assign mod3[121] = 2'd1;
  assign mod3[122] = 2'd2;
  assign mod3[123] = 2'd0;
  assign mod3[124] = 2'd1;
  assign mod3[125] = 2'd2;
  assign mod3[126] = 2'd0;
  assign mod3[127] = 2'd1;
  assign mod3[128] = 2'd2;
  assign mod3[129] = 2'd0;
  assign mod3[130] = 2'd1;
  assign mod3[131] = 2'd2;
  assign mod3[132] = 2'd0;
  assign mod3[133] = 2'd1;
  assign mod3[134] = 2'd2;
  assign mod3[135] = 2'd0;
  assign mod3[136] = 2'd1;
  assign mod3[137] = 2'd2;
  assign mod3[138] = 2'd0;
  assign mod3[139] = 2'd1;
  assign mod3[140] = 2'd2;
  assign mod3[141] = 2'd0;
  assign mod3[142] = 2'd1;
  assign mod3[143] = 2'd2;
  assign mod3[144] = 2'd0;
  assign mod3[145] = 2'd1;
  assign mod3[146] = 2'd2;
  assign mod3[147] = 2'd0;
  assign mod3[148] = 2'd1;
  assign mod3[149] = 2'd2;
  assign mod3[150] = 2'd0;
  assign mod3[151] = 2'd1;
  assign mod3[152] = 2'd2;
  assign mod3[153] = 2'd0;
  assign mod3[154] = 2'd1;
  assign mod3[155] = 2'd2;
  assign mod3[156] = 2'd0;
  assign mod3[157] = 2'd1;
  assign mod3[158] = 2'd2;
  assign mod3[159] = 2'd0;
  assign mod3[160] = 2'd1;
  assign mod3[161] = 2'd2;
  assign mod3[162] = 2'd0;
  assign mod3[163] = 2'd1;
  assign mod3[164] = 2'd2;
  assign mod3[165] = 2'd0;
  assign mod3[166] = 2'd1;
  assign mod3[167] = 2'd2;
  assign mod3[168] = 2'd0;
  assign mod3[169] = 2'd1;
  assign mod3[170] = 2'd2;
  assign mod3[171] = 2'd0;
  assign mod3[172] = 2'd1;
  assign mod3[173] = 2'd2;
  assign mod3[174] = 2'd0;
  assign mod3[175] = 2'd1;
  assign mod3[176] = 2'd2;
  assign mod3[177] = 2'd0;
  assign mod3[178] = 2'd1;
  assign mod3[179] = 2'd2;
  assign mod3[180] = 2'd0;
  assign mod3[181] = 2'd1;
  assign mod3[182] = 2'd2;
  assign mod3[183] = 2'd0;
  assign mod3[184] = 2'd1;
  assign mod3[185] = 2'd2;
  assign mod3[186] = 2'd0;
  assign mod3[187] = 2'd1;
  assign mod3[188] = 2'd2;
  assign mod3[189] = 2'd0;
  assign mod3[190] = 2'd1;
  assign mod3[191] = 2'd2;
  assign mod3[192] = 2'd0;
  assign mod3[193] = 2'd1;
  assign mod3[194] = 2'd2;
  assign mod3[195] = 2'd0;
  assign mod3[196] = 2'd1;
  assign mod3[197] = 2'd2;
  assign mod3[198] = 2'd0;
  assign mod3[199] = 2'd1;
  assign mod3[200] = 2'd2;
  assign mod3[201] = 2'd0;
  assign mod3[202] = 2'd1;
  assign mod3[203] = 2'd2;
  assign mod3[204] = 2'd0;
  assign mod3[205] = 2'd1;
  assign mod3[206] = 2'd2;
  assign mod3[207] = 2'd0;
  assign mod3[208] = 2'd1;
  assign mod3[209] = 2'd2;
  assign mod3[210] = 2'd0;
  assign mod3[211] = 2'd1;
  assign mod3[212] = 2'd2;
  assign mod3[213] = 2'd0;
  assign mod3[214] = 2'd1;
  assign mod3[215] = 2'd2;
  assign mod3[216] = 2'd0;
  assign mod3[217] = 2'd1;
  assign mod3[218] = 2'd2;
  assign mod3[219] = 2'd0;
  assign mod3[220] = 2'd1;
  assign mod3[221] = 2'd2;
  assign mod3[222] = 2'd0;
  assign mod3[223] = 2'd1;
  assign mod3[224] = 2'd2;
  assign mod3[225] = 2'd0;
  assign mod3[226] = 2'd1;
  assign mod3[227] = 2'd2;
  assign mod3[228] = 2'd0;
  assign mod3[229] = 2'd1;
  assign mod3[230] = 2'd2;
  assign mod3[231] = 2'd0;
  assign mod3[232] = 2'd1;
  assign mod3[233] = 2'd2;
  assign mod3[234] = 2'd0;
  assign mod3[235] = 2'd1;
  assign mod3[236] = 2'd2;
  assign mod3[237] = 2'd0;
  assign mod3[238] = 2'd1;
  assign mod3[239] = 2'd2;
  assign mod3[240] = 2'd0;
  assign mod3[241] = 2'd1;
  assign mod3[242] = 2'd2;
  assign mod3[243] = 2'd0;
  assign mod3[244] = 2'd1;
  assign mod3[245] = 2'd2;
  assign mod3[246] = 2'd0;
  assign mod3[247] = 2'd1;
  assign mod3[248] = 2'd2;
  assign mod3[249] = 2'd0;
  assign mod3[250] = 2'd1;
  assign mod3[251] = 2'd2;
  assign mod3[252] = 2'd0;
  assign mod3[253] = 2'd1;
  assign mod3[254] = 2'd2;
  assign mod3[255] = 2'd0;

  assign mod12[0] = 4'd0;
  assign mod12[1] = 4'd1;
  assign mod12[2] = 4'd2;
  assign mod12[3] = 4'd3;
  assign mod12[4] = 4'd4;
  assign mod12[5] = 4'd5;
  assign mod12[6] = 4'd6;
  assign mod12[7] = 4'd7;
  assign mod12[8] = 4'd8;
  assign mod12[9] = 4'd9;
  assign mod12[10] = 4'd10;
  assign mod12[11] = 4'd11;
  assign mod12[12] = '0;
  assign mod12[13] = '0;
  assign mod12[14] = '0;
  assign mod12[15] = '0;

endmodule
