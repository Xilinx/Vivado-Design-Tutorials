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
module dcmac_0_axis_pkt_mon_shift_seg (
  clk,
  i_pkt,
  o_pkt
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
  input  lbus_pkt_t  i_pkt;
  output lbus_pkt_t  o_pkt;

  reg  [1:1][2:0][2:0] ena_sum_4;
  reg  [2:2][1:0][3:0] ena_sum_8;
  lbus_pkt_t [3:1] pkt_shift;

  assign o_pkt = pkt_shift[3];


  always @(posedge clk) begin
    pkt_shift[1] <= i_pkt;

    ena_sum_4[1][0] <= i_pkt.ena[0] +  i_pkt.ena[1] + i_pkt.ena[2] + i_pkt.ena[3];
    ena_sum_4[1][1] <= i_pkt.ena[4] +  i_pkt.ena[5] + i_pkt.ena[6] + i_pkt.ena[7];
    ena_sum_4[1][2] <= i_pkt.ena[8] +  i_pkt.ena[9] + i_pkt.ena[10] + i_pkt.ena[11];

    if (~i_pkt.ena[0]) begin
      pkt_shift[1].ena[3:2] <= 2'd0;
      pkt_shift[1].ena[1:0] <= i_pkt.ena[3:2];
      pkt_shift[1].sop[1:0] <= i_pkt.sop[3:2];
      pkt_shift[1].eop[1:0] <= i_pkt.eop[3:2];
      pkt_shift[1].err[1:0] <= i_pkt.err[3:2];
      pkt_shift[1].mty[1:0] <= i_pkt.mty[3:2];
      pkt_shift[1].dat[1:0] <= i_pkt.dat[3:2];
    end
    else if (~i_pkt.ena[1]) begin
      pkt_shift[1].ena[3] <= 1'b0;
      pkt_shift[1].ena[2:1] <= i_pkt.ena[3:2];
      pkt_shift[1].sop[2:1] <= i_pkt.sop[3:2];
      pkt_shift[1].eop[2:1] <= i_pkt.eop[3:2];
      pkt_shift[1].err[2:1] <= i_pkt.err[3:2];
      pkt_shift[1].mty[2:1] <= i_pkt.mty[3:2];
      pkt_shift[1].dat[2:1] <= i_pkt.dat[3:2];
    end

    if (~i_pkt.ena[4]) begin
      pkt_shift[1].ena[7:6] <= 2'd0;
      pkt_shift[1].ena[5:4] <= i_pkt.ena[7:6];
      pkt_shift[1].sop[5:4] <= i_pkt.sop[7:6];
      pkt_shift[1].eop[5:4] <= i_pkt.eop[7:6];
      pkt_shift[1].err[5:4] <= i_pkt.err[7:6];
      pkt_shift[1].mty[5:4] <= i_pkt.mty[7:6];
      pkt_shift[1].dat[5:4] <= i_pkt.dat[7:6];
    end
    else if (~i_pkt.ena[5]) begin
      pkt_shift[1].ena[7] <= 1'b0;
      pkt_shift[1].ena[6:5] <= i_pkt.ena[7:6];
      pkt_shift[1].sop[6:5] <= i_pkt.sop[7:6];
      pkt_shift[1].eop[6:5] <= i_pkt.eop[7:6];
      pkt_shift[1].err[6:5] <= i_pkt.err[7:6];
      pkt_shift[1].mty[6:5] <= i_pkt.mty[7:6];
      pkt_shift[1].dat[6:5] <= i_pkt.dat[7:6];
    end

    if (~i_pkt.ena[8]) begin
      pkt_shift[1].ena[11:10] <= 2'd0;
      pkt_shift[1].ena[9:8] <= i_pkt.ena[11:10];
      pkt_shift[1].sop[9:8] <= i_pkt.sop[11:10];
      pkt_shift[1].eop[9:8] <= i_pkt.eop[11:10];
      pkt_shift[1].err[9:8] <= i_pkt.err[11:10];
      pkt_shift[1].mty[9:8] <= i_pkt.mty[11:10];
      pkt_shift[1].dat[9:8] <= i_pkt.dat[11:10];
    end
    else if (~i_pkt.ena[9]) begin
      pkt_shift[1].ena[11] <= 1'b0;
      pkt_shift[1].ena[10:9] <= i_pkt.ena[11:10];
      pkt_shift[1].sop[10:9] <= i_pkt.sop[11:10];
      pkt_shift[1].eop[10:9] <= i_pkt.eop[11:10];
      pkt_shift[1].err[10:9] <= i_pkt.err[11:10];
      pkt_shift[1].mty[10:9] <= i_pkt.mty[11:10];
      pkt_shift[1].dat[10:9] <= i_pkt.dat[11:10];
    end


    pkt_shift[2] <= pkt_shift[1];

    case(ena_sum_4[1][0])
      3'd0: begin
        pkt_shift[2].ena[7:4] <= 4'd0;
        pkt_shift[2].ena[3:0] <= pkt_shift[1].ena[7:4];
        pkt_shift[2].sop[3:0] <= pkt_shift[1].sop[7:4];
        pkt_shift[2].eop[3:0] <= pkt_shift[1].eop[7:4];
        pkt_shift[2].err[3:0] <= pkt_shift[1].err[7:4];
        pkt_shift[2].mty[3:0] <= pkt_shift[1].mty[7:4];
        pkt_shift[2].dat[3:0] <= pkt_shift[1].dat[7:4];
      end
      3'd1: begin
        pkt_shift[2].ena[7:5] <= 3'd0;
        pkt_shift[2].ena[4:1] <= pkt_shift[1].ena[7:4];
        pkt_shift[2].sop[4:1] <= pkt_shift[1].sop[7:4];
        pkt_shift[2].eop[4:1] <= pkt_shift[1].eop[7:4];
        pkt_shift[2].err[4:1] <= pkt_shift[1].err[7:4];
        pkt_shift[2].mty[4:1] <= pkt_shift[1].mty[7:4];
        pkt_shift[2].dat[4:1] <= pkt_shift[1].dat[7:4];
      end
      3'd2: begin
        pkt_shift[2].ena[7:6] <= 2'd0;
        pkt_shift[2].ena[5:2] <= pkt_shift[1].ena[7:4];
        pkt_shift[2].sop[5:2] <= pkt_shift[1].sop[7:4];
        pkt_shift[2].eop[5:2] <= pkt_shift[1].eop[7:4];
        pkt_shift[2].err[5:2] <= pkt_shift[1].err[7:4];
        pkt_shift[2].mty[5:2] <= pkt_shift[1].mty[7:4];
        pkt_shift[2].dat[5:2] <= pkt_shift[1].dat[7:4];
      end
      3'd3: begin
        pkt_shift[2].ena[7:7] <= 1'd0;
        pkt_shift[2].ena[6:3] <= pkt_shift[1].ena[7:4];
        pkt_shift[2].sop[6:3] <= pkt_shift[1].sop[7:4];
        pkt_shift[2].eop[6:3] <= pkt_shift[1].eop[7:4];
        pkt_shift[2].err[6:3] <= pkt_shift[1].err[7:4];
        pkt_shift[2].mty[6:3] <= pkt_shift[1].mty[7:4];
        pkt_shift[2].dat[6:3] <= pkt_shift[1].dat[7:4];
      end
    endcase

    ena_sum_8[2][0] <= ena_sum_4[1][0] + ena_sum_4[1][1];
    ena_sum_8[2][1] <= ena_sum_4[1][2];

    pkt_shift[3] <= pkt_shift[2];

    case(ena_sum_8[2][0])
      4'd0: begin
        pkt_shift[3].ena[11:4] <= '0;
        pkt_shift[3].ena[3:0] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[3:0] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[3:0] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[3:0] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[3:0] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[3:0] <= pkt_shift[2].dat[11:8];
      end
      4'd1: begin
        pkt_shift[3].ena[11:5] <= '0;
        pkt_shift[3].ena[4:1] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[4:1] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[4:1] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[4:1] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[4:1] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[4:1] <= pkt_shift[2].dat[11:8];
      end
      4'd2: begin
        pkt_shift[3].ena[11:6] <= '0;
        pkt_shift[3].ena[5:2] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[5:2] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[5:2] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[5:2] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[5:2] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[5:2] <= pkt_shift[2].dat[11:8];
      end
      4'd3: begin
        pkt_shift[3].ena[11:7] <= '0;
        pkt_shift[3].ena[6:3] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[6:3] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[6:3] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[6:3] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[6:3] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[6:3] <= pkt_shift[2].dat[11:8];
      end
      4'd4: begin
        pkt_shift[3].ena[11:8] <= '0;
        pkt_shift[3].ena[7:4] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[7:4] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[7:4] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[7:4] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[7:4] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[7:4] <= pkt_shift[2].dat[11:8];
      end
      4'd5: begin
        pkt_shift[3].ena[11:9] <= '0;
        pkt_shift[3].ena[8:5] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[8:5] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[8:5] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[8:5] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[8:5] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[8:5] <= pkt_shift[2].dat[11:8];
      end
      4'd6: begin
        pkt_shift[3].ena[11:10] <= '0;
        pkt_shift[3].ena[9:6] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[9:6] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[9:6] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[9:6] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[9:6] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[9:6] <= pkt_shift[2].dat[11:8];
      end
      4'd7: begin
        pkt_shift[3].ena[11:11] <= '0;
        pkt_shift[3].ena[10:7] <= pkt_shift[2].ena[11:8];
        pkt_shift[3].sop[10:7] <= pkt_shift[2].sop[11:8];
        pkt_shift[3].eop[10:7] <= pkt_shift[2].eop[11:8];
        pkt_shift[3].err[10:7] <= pkt_shift[2].err[11:8];
        pkt_shift[3].mty[10:7] <= pkt_shift[2].mty[11:8];
        pkt_shift[3].dat[10:7] <= pkt_shift[2].dat[11:8];
      end
    endcase

  end




endmodule
