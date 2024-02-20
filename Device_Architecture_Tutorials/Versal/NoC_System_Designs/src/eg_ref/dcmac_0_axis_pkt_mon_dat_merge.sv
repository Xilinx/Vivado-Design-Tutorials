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
module dcmac_0_axis_pkt_mon_dat_merge (
  clk,
  i_pkt,
  o_size,
  o_dat
);

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
  input  lbus_pkt_t i_pkt;
  output logic [7:0] o_size;
  output logic [11:0][15:0][7:0] o_dat;


  logic [1:0][2:0][2:0] valid_seg_sum_per_pkt;
  logic [1:0][2:0][3:0] sop_addr;
  logic [4:0][2:0][3:0] pkt_mty;
  logic [2:1][3:0] valid_seg_sum;
  logic [2:1][5:0] mty_sum;
  logic [5:3][7:0] size;
  logic [2:2][2:0][7:0] dat_idx;
  logic [4:3][191:0][1:0] sel;
  reg   [4:1][1536-1:0] dat_shift;
  logic [4:2][1536-1:0] dat_shift_pkt_0;
  logic [4:3][1536-1:0] dat_shift_pkt_1;
  logic [4:4][1536-1:0] dat_shift_pkt_2;
  logic [4:4][1536-1:0] dat_shift_pkt_3;
  reg   [4:4][3:0][191:0][7:0] byte_shift;
  reg   [5:5][191:0][7:0] byte_merge;


  always @* begin
    case (i_pkt.eop[3:0] & i_pkt.ena[3:0])
      4'b0001: begin pkt_mty[0][0] = i_pkt.mty[0]; sop_addr[0][0] = 0 + 1; end
      4'b0010: begin pkt_mty[0][0] = i_pkt.mty[1]; sop_addr[0][0] = 1 + 1; end
      4'b0100: begin pkt_mty[0][0] = i_pkt.mty[2]; sop_addr[0][0] = 2 + 1; end
      4'b1000: begin pkt_mty[0][0] = i_pkt.mty[3]; sop_addr[0][0] = 3 + 1; end
      default: begin pkt_mty[0][0] = '0; sop_addr[0][0] = 3 + 1; end
    endcase

    valid_seg_sum_per_pkt[0][0] = i_pkt.ena[0] + i_pkt.ena[1] + i_pkt.ena[2] + i_pkt.ena[3];

    case (i_pkt.eop[7:4] & i_pkt.ena[7:4])
      4'b0001: begin pkt_mty[0][1] = i_pkt.mty[4]; sop_addr[0][1] = 4 + 1; end
      4'b0010: begin pkt_mty[0][1] = i_pkt.mty[5]; sop_addr[0][1] = 5 + 1; end
      4'b0100: begin pkt_mty[0][1] = i_pkt.mty[6]; sop_addr[0][1] = 6 + 1; end
      4'b1000: begin pkt_mty[0][1] = i_pkt.mty[7]; sop_addr[0][1] = 7 + 1; end
      default: begin pkt_mty[0][1] = '0; sop_addr[0][1] = 7 + 1; end
    endcase

    valid_seg_sum_per_pkt[0][1] = i_pkt.ena[4] + i_pkt.ena[5] + i_pkt.ena[6] + i_pkt.ena[7];

    case (i_pkt.eop[11:8] & i_pkt.ena[11:8])
      4'b0001: begin pkt_mty[0][2] = i_pkt.mty[8]; sop_addr[0][2] = 8 + 1; end
      4'b0010: begin pkt_mty[0][2] = i_pkt.mty[9]; sop_addr[0][2] = 9 + 1; end
      4'b0100: begin pkt_mty[0][2] = i_pkt.mty[10]; sop_addr[0][2] = 10 + 1; end
      4'b1000: begin pkt_mty[0][2] = i_pkt.mty[11]; sop_addr[0][2] = 11 + 1; end
      default: begin pkt_mty[0][2] = '0; sop_addr[0][2] = 11 + 1; end
    endcase

    valid_seg_sum_per_pkt[0][2] = i_pkt.ena[8] + i_pkt.ena[9] + i_pkt.ena[10] + i_pkt.ena[11];



    valid_seg_sum[1] = '0;
    mty_sum[1] = '0;

    for (int i=0; i<3; i++) begin
      valid_seg_sum[1] += valid_seg_sum_per_pkt[1][i];
      mty_sum[1] += pkt_mty[1][i];
    end

  end

  assign dat_shift_pkt_3[4] = dat_shift[4];

  assign byte_shift[4][0] = dat_shift_pkt_0[4];
  assign byte_shift[4][1] = dat_shift_pkt_1[4];
  assign byte_shift[4][2] = dat_shift_pkt_2[4];
  assign byte_shift[4][3] = dat_shift_pkt_3[4];


  assign o_size = size[5];
  assign o_dat = byte_merge[5];

  always @(posedge clk) begin
    valid_seg_sum_per_pkt[1] <= valid_seg_sum_per_pkt[0];
    pkt_mty[4:1] <= pkt_mty[3:0];
    valid_seg_sum[2] <= valid_seg_sum[1];
    mty_sum[2] <= mty_sum[1];
    sop_addr[1] <= sop_addr[0];

    size[3] <= {valid_seg_sum[2], 4'd0} - mty_sum[2];
    size[5:4] <= size[4:3];

    sel[4:4] <= sel[3:3];

    dat_idx[2][0] <= {sop_addr[1][0], 4'd0}
                      - pkt_mty[1][0]
                      ;
    dat_idx[2][1] <= {sop_addr[1][1], 4'd0}
                      - pkt_mty[1][0]
                      - pkt_mty[1][1]
                      ;
    dat_idx[2][2] <= {sop_addr[1][2], 4'd0}
                      - pkt_mty[1][0]
                      - pkt_mty[1][1]
                      - pkt_mty[1][2]
                      ;

    for (int i=0; i<192; i++) begin
      if (i < dat_idx[2][0]) sel[3][i] <= 0;
      else if (i < dat_idx[2][1]) sel[3][i] <= 1;
      else if (i < dat_idx[2][2]) sel[3][i] <= 2;
      else sel[3][i] <= 3;

      if (i < 48) byte_merge[5][i] <= byte_shift[4][sel[4][i][0]][i];
      else if (i < 64) byte_merge[5][i] <= (sel[4][i] == 0)? byte_shift[4][0][i] : (sel[4][i] == 1)? byte_shift[4][1][i] : byte_shift[4][2][i];
      else if (i < 96) byte_merge[5][i] <= (sel[4][i] == 1)? byte_shift[4][1][i] : byte_shift[4][2][i];
      else if (i < 128) byte_merge[5][i] <= (sel[4][i] == 1)? byte_shift[4][1][i] : (sel[4][i] == 2)? byte_shift[4][2][i] : byte_shift[4][3][i];
      else  byte_merge[5][i] <= (sel[4][i] == 2)? byte_shift[4][2][i] : byte_shift[4][3][i];

    end

    dat_shift[1] <= i_pkt.dat;
    dat_shift_pkt_0[2] <= dat_shift[1];
    dat_shift_pkt_0[4:3] <= dat_shift_pkt_0[3:2];

    dat_shift[2] <= dat_shift[1] >> {pkt_mty[1][0][3:0], 3'd0};
    dat_shift_pkt_1[3] <= dat_shift[2];
    dat_shift_pkt_1[4] <= dat_shift_pkt_1[3];

    dat_shift[3] <= dat_shift[2] >> {pkt_mty[2][1][3:0], 3'd0};
    dat_shift_pkt_2[4] <= dat_shift[3];

    dat_shift[4] <= dat_shift[3] >> {pkt_mty[3][2][3:0], 3'd0};


  end

endmodule
