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
module dcmac_0_axis_pkt_gen_mty_shift (
  clk,
  i_pkt_ctrl,
  i_dat,
  o_pkt
);
  parameter REGISTER_INPUT = 1;

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

  typedef struct packed {
    logic [2:0]               id;
    logic [11:0]         ena;
    logic [11:0]         sop;
    logic [11:0]         eop;
    logic [11:0]         err;
    logic [11:0][3:0]    mty;
    logic [11:0][127:0]  dat;
  } lbus_pkt_t;

  input clk;
  input lbus_pkt_ctrl_t i_pkt_ctrl;
  input [11:0][127:0] i_dat;
  output lbus_pkt_t o_pkt;

  lbus_pkt_ctrl_t [2:1] pkt_ctrl;
  reg  [1:1][11:1][8-1:0] gap_before;
  reg  [1:1][11:0][127:0] data_in;
  wire [1:1][192-1:0][7:0] byte_in;
  reg  [2:2][192-1:0][7:0] dout;

  wire [3:0][31*8-1:0] bus_0, bus_shift_0;


  assign bus_0[0] = byte_in[1][31:1];
  assign bus_0[1] = byte_in[1][47:17];
  assign bus_0[2] = byte_in[1][63:33];
  assign bus_0[3] = byte_in[1][79:49];

  assign bus_shift_0[0] = bus_0[0] << {gap_before[1][1][3:0], 3'd0};
  assign bus_shift_0[1] = bus_0[1] << {gap_before[1][2][3:0], 3'd0};
  assign bus_shift_0[2] = bus_0[2] << {gap_before[1][3][3:0], 3'd0};
  assign bus_shift_0[3] = bus_0[3] << {gap_before[1][4][3:0], 3'd0};


  wire [3:0][46*8-1:0] bus_1, bus_shift_1;

  assign bus_1[0] = byte_in[1][ 95:50];
  assign bus_1[1] = byte_in[1][111:66];
  assign bus_1[2] = byte_in[1][127:82];
  assign bus_1[3] = byte_in[1][143:98];

  assign bus_shift_1[0] = bus_1[0] << {gap_before[1][5][4:0], 3'd0};
  assign bus_shift_1[1] = bus_1[1] << {gap_before[1][6][4:0], 3'd0};
  assign bus_shift_1[2] = bus_1[2] << {gap_before[1][7][4:0], 3'd0};
  assign bus_shift_1[3] = bus_1[3] << {gap_before[1][8][4:0], 3'd0};

  wire [2:0][61*8-1:0] bus_2, bus_shift_2;

  assign bus_2[0] = byte_in[1][159: 99];
  assign bus_2[1] = byte_in[1][175:115];
  assign bus_2[2] = byte_in[1][191:131];

  assign bus_shift_2[0] = bus_2[0] << {gap_before[1] [9][5:0], 3'd0};
  assign bus_shift_2[1] = bus_2[1] << {gap_before[1][10][5:0], 3'd0};
  assign bus_shift_2[2] = bus_2[2] << {gap_before[1][11][5:0], 3'd0};

  assign byte_in[1] = REGISTER_INPUT? data_in[1] : i_dat;

  always @(posedge clk) begin
    data_in[1] <= i_dat;
    pkt_ctrl <= {pkt_ctrl, i_pkt_ctrl};

    for (int i=1; i<12; i++) begin
      // pkt_mty_idx[i]: the number of segments before the next sop
      // if there is no sop after segment[i], pkt_mty_idx[i] will be 12 (invalid)
      gap_before[1][i] <= (i >= i_pkt_ctrl.pkt_mty_idx[2])? i_pkt_ctrl.mty_sum[2]
                        : (i >= i_pkt_ctrl.pkt_mty_idx[1])? i_pkt_ctrl.mty_sum[1]
                        : (i >= i_pkt_ctrl.pkt_mty_idx[0])? i_pkt_ctrl.mty_sum[0]
                        : '0;
    end

    dout[2][15:0]  <= byte_in[1][15:0];
    dout[2][31:16] <= bus_shift_0[0][31*8-1:15*8];
    dout[2][47:32] <= bus_shift_0[1][31*8-1:15*8];
    dout[2][63:48] <= bus_shift_0[2][31*8-1:15*8];
    dout[2][79:64] <= bus_shift_0[3][31*8-1:15*8];

    dout[2][ 95: 80] <= bus_shift_1[0][46*8-1:30*8];
    dout[2][111: 96] <= bus_shift_1[1][46*8-1:30*8];
    dout[2][127:112] <= bus_shift_1[2][46*8-1:30*8];
    dout[2][143:128] <= bus_shift_1[3][46*8-1:30*8];

    dout[2][159:144] <= bus_shift_2[0][61*8-1:45*8];
    dout[2][175:160] <= bus_shift_2[1][61*8-1:45*8];
    dout[2][191:176] <= bus_shift_2[2][61*8-1:45*8];

    o_pkt.id       <= pkt_ctrl[2].id;
    o_pkt.ena      <= pkt_ctrl[2].ena;
    o_pkt.sop      <= pkt_ctrl[2].sop;
    o_pkt.eop      <= pkt_ctrl[2].eop;
    o_pkt.err      <= pkt_ctrl[2].err;
    o_pkt.mty      <= pkt_ctrl[2].mty;
    o_pkt.dat      <= dout[2];
  end

endmodule
