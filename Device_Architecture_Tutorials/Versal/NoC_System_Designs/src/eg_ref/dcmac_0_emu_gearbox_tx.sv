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
module dcmac_0_emu_gearbox_tx (
  clk,
  rst,
  i_data_rate,
  i_pkt_ena,
  i_skip_response,
  i_pkt,
  i_tready,
  o_af,
  o_vld,
  o_preamble,
  o_slice,
  o_underflow,
  o_overflow
);

  parameter REGISTER_INPUT = 1;        // timing


  parameter R_400G = 2'b10,
            R_200G = 2'b01,
            R_100G = 2'b00;

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
    logic [1:0]              ena;
    logic [1:0]              sop;
    logic [1:0]              eop;
    logic [1:0]              err;
    logic [1:0][3:0]         mty;
    logic [1:0][127:0]       dat;
  } slice_t;

  input                               clk;
  input                [5:0]          rst;
  input                [5:0][1:0]     i_data_rate;
  input                               i_skip_response;
  input  axis_tx_pkt_t                i_pkt;
  input                [5:0]          i_pkt_ena;
  input                [5:0]          i_tready;
  output slice_t       [5:0]          o_slice;
  output               [5:0]          o_af;
  output reg           [5:0][55:0]    o_preamble;
  output reg           [5:0]          o_underflow;
  output reg           [5:0]          o_overflow;
  output reg           [5:0]          o_vld;


  wire                        p0_400;
  wire                        p0_200;
  wire                        p2_200;
  wire                        p4_200;
  wire                        p0_200_or_400;
  logic   [1:0]               skip_response_n_reg;
  slice_t [5:0]               slice_in;
  reg     [5:0][2:0]          remainder;
  reg     [5:0]               wr_ena_pre, wr_ena;
  logic   [5:0]               new_dat;
  reg     [5:0]               rst_mask;
  wire    [5:0]               tready_mask;
  reg     [5:0]               dat_enough;
  slice_t [5:0]               slice_reg_0;
  slice_t [5:1][4:0]          slice_reg;
  slice_t [3:0]               din_0;
  slice_t [1:0]               din_2, din_4;
  slice_t                     din_1, din_3, din_5;
  slice_t [5:0]               fin;
  slice_t [5:0]               slice_out;
  wire    [11:0]              sop_out;
  // sim-only
  axis_tx_pkt_t               pkt_out;

  assign p0_400 = i_data_rate[0] == R_400G;
  assign p0_200 = i_data_rate[0] == R_200G;
  assign p0_200_or_400 = i_data_rate[0] == R_400G | i_data_rate[0] == R_200G;
  assign p2_200 = i_data_rate[2] == R_200G;
  assign p4_200 = i_data_rate[4] == R_200G;

  assign tready_mask[0] = i_tready[0];
  assign tready_mask[1] = p0_200_or_400? i_tready[0] : i_tready[1];
  assign tready_mask[2] = p0_400? i_tready[0] : i_tready[2];
  assign tready_mask[3] = p0_400? i_tready[0] : p2_200? i_tready[2] : i_tready[3];
  assign tready_mask[4] = i_tready[4];
  assign tready_mask[5] = p4_200? i_tready[4] : i_tready[5];

  assign sop_out[00] = slice_out[0].sop[0] & slice_out[0].ena[0];
  assign sop_out[01] = slice_out[0].sop[1] & slice_out[0].ena[1];
  assign sop_out[02] = slice_out[1].sop[0] & slice_out[1].ena[0];
  assign sop_out[03] = slice_out[1].sop[1] & slice_out[1].ena[1];
  assign sop_out[04] = slice_out[2].sop[0] & slice_out[2].ena[0];
  assign sop_out[05] = slice_out[2].sop[1] & slice_out[2].ena[1];
  assign sop_out[06] = slice_out[3].sop[0] & slice_out[3].ena[0];
  assign sop_out[07] = slice_out[3].sop[1] & slice_out[3].ena[1];
  assign sop_out[08] = slice_out[4].sop[0] & slice_out[4].ena[0];
  assign sop_out[09] = slice_out[4].sop[1] & slice_out[4].ena[1];
  assign sop_out[10] = slice_out[5].sop[0] & slice_out[5].ena[0];
  assign sop_out[11] = slice_out[5].sop[1] & slice_out[5].ena[1];

  generate
    if (REGISTER_INPUT) begin : GEN_ENABLE_REGISTER_INPUT
      always @(posedge clk) begin
        for (int i=0; i<6; i++) begin
          new_dat[i] <= |i_pkt.ena & i_pkt.id == i;

          slice_in[i].ena <= {i_pkt.ena[i*2+1], i_pkt.ena[i*2]};
          slice_in[i].sop <= {i_pkt.sop[i*2+1], i_pkt.sop[i*2]};
          slice_in[i].eop <= {i_pkt.eop[i*2+1], i_pkt.eop[i*2]};
          slice_in[i].err <= {i_pkt.err[i*2+1], i_pkt.err[i*2]};
          slice_in[i].mty <= {i_pkt.mty[i*2+1], i_pkt.mty[i*2]};
          slice_in[i].dat <= {i_pkt.dat[i*2+1], i_pkt.dat[i*2]};
        end
      end
    end
    else begin : GEN_DISABLE_REGISTER_INPUT
      always @* begin
        for (int i=0; i<6; i++) begin
          new_dat[i] = |i_pkt.ena & i_pkt.id == i;

          slice_in[i].ena = {i_pkt.ena[i*2+1], i_pkt.ena[i*2]};
          slice_in[i].sop = {i_pkt.sop[i*2+1], i_pkt.sop[i*2]};
          slice_in[i].eop = {i_pkt.eop[i*2+1], i_pkt.eop[i*2]};
          slice_in[i].err = {i_pkt.err[i*2+1], i_pkt.err[i*2]};
          slice_in[i].mty = {i_pkt.mty[i*2+1], i_pkt.mty[i*2]};
          slice_in[i].dat = {i_pkt.dat[i*2+1], i_pkt.dat[i*2]};
        end
      end
    end
  endgenerate

  always @* begin
    for (int i=0; i<6; i++) begin
      o_slice[i] = slice_out[i];
      if (!tready_mask[i])
        o_slice[i].ena = '0;
    end

    // custom preamble
    for (int i=0; i<6; i++) begin
      // synthesis translate_off
      o_preamble[i] = sop_out[i*2]? slice_out[i].dat[0][55:0] : slice_out[i].dat[1][55:0];
      // synthesis translate_on
    end


    // synthesis translate_off
    if (p0_200 | p0_400) begin
      case (sop_out[3:0])
        4'b0001: o_preamble[0] = slice_out[0].dat[0][55:0];
        4'b0010: o_preamble[0] = slice_out[0].dat[1][55:0];
        4'b0100: o_preamble[0] = slice_out[1].dat[0][55:0];
        4'b1000: o_preamble[0] = slice_out[1].dat[1][55:0];
      endcase
    end

    if (p2_200 | p0_400) begin
      case (sop_out[7:4])
        4'b0001: o_preamble[2] = slice_out[2].dat[0][55:0];
        4'b0010: o_preamble[2] = slice_out[2].dat[1][55:0];
        4'b0100: o_preamble[2] = slice_out[3].dat[0][55:0];
        4'b1000: o_preamble[2] = slice_out[3].dat[1][55:0];
      endcase
    end

    if (p4_200) begin
      case (sop_out[11:8])
        4'b0001: o_preamble[4] = slice_out[4].dat[0][55:0];
        4'b0010: o_preamble[4] = slice_out[4].dat[1][55:0];
        4'b0100: o_preamble[4] = slice_out[5].dat[0][55:0];
        4'b1000: o_preamble[4] = slice_out[5].dat[1][55:0];
      endcase
    end
    // synthesis translate_on
  end

  always @(posedge clk) begin
    fin[0] <= din_0[0];
    fin[1] <= p0_200_or_400? din_0[1] : din_1;
    fin[2] <= p0_400? din_0[2] : din_2[0];
    fin[3] <= p0_400? din_0[3] : p2_200? din_2[1] : din_3;
    fin[4] <= din_4[0];
    fin[5] <= p4_200? din_4[1] : din_5;
  end

  assign skip_response_n_reg[0] = ~i_skip_response & i_pkt.id == '0;

  always @(posedge clk) begin
    wr_ena_pre <= 6'd0;
    skip_response_n_reg[1] <= skip_response_n_reg[0];

    case (remainder[0]) // max = 6
      0: begin
        din_0[3:0] <= slice_in[3:0];
        if (new_dat[0]) begin
          if (p0_400) begin
            remainder[0] <= 2;
            slice_reg_0[1:0] <= slice_in[5:4];
            wr_ena_pre[3:0] <= '1;
          end
          else if (p0_200) begin
            remainder[0] <= 4;
            slice_reg_0[3:0] <= slice_in[5:2];
            wr_ena_pre[1:0] <= '1;
          end
          else begin
            remainder[0] <= 5;
            slice_reg_0[4:0] <= slice_in[5:1];
            wr_ena_pre[0] <= 1'b1;
          end
        end
      end
      2: begin
        if (p0_400) begin
          if (new_dat[0]) begin
            wr_ena_pre[3:0] <= '1;
            remainder[0] <= 4;
            slice_reg_0[3:0] <= slice_in[5:2];
            din_0[3:0] <= {slice_in[1:0], slice_reg_0[1:0]};
          end
          else if ((slice_reg_0[1].eop[1] | !slice_reg_0[1].ena[1]) & skip_response_n_reg[REGISTER_INPUT]) begin // pkt ends, push to FIFO
            wr_ena_pre[3:0] <= '1;
            remainder[0] <= 0;
            din_0[1:0] <= slice_reg_0[1:0];
            {din_0[2].ena, din_0[2].sop, din_0[2].eop} <= '0;
            {din_0[3].ena, din_0[3].sop, din_0[3].eop} <= '0;
          end
        end
        else if(p0_200) begin
          wr_ena_pre[1:0] <= '1;
          remainder[0] <= 0;
          din_0[1:0] <= slice_reg_0[1:0];
        end
        else begin
          wr_ena_pre[0] <= 1'b1;
          remainder[0] <= 1;
          slice_reg_0[0] <= slice_reg_0[1];
          din_0[0] <= slice_reg_0[0];
        end
      end
      4: begin
        if (p0_400) begin
          wr_ena_pre[3:0] <= '1;
          din_0[3:0] <= slice_reg_0[3:0];
          remainder[0] <= new_dat[0]? 6 : '0;
          slice_reg_0[5:0] <= slice_in[5:0];
        end
        else if(p0_200) begin
          wr_ena_pre[1:0] <= '1;
          din_0[1:0] <= slice_reg_0[1:0];
          remainder[0] <= 2;
          slice_reg_0[1:0] <= slice_reg_0[3:2];
        end
        else begin
          wr_ena_pre[0] <= 1'b1;
          remainder[0] <= 3;
          slice_reg_0[2:0] <= slice_reg_0[3:1];
          din_0[0] <= slice_reg_0[0];
        end
      end
      6 : begin
        wr_ena_pre[3:0] <= '1;
        din_0[3:0] <= slice_reg_0[3:0];
        remainder[0] <= 2;
        slice_reg_0[1:0] <= slice_reg_0[5:4];
      end
      default: begin // 1, 3, 5
        wr_ena_pre[0] <= 1'b1;
        din_0[0] <= slice_reg_0[0];
        remainder[0] <= remainder[0] - 1'b1;
        if (remainder[0] == 3) slice_reg_0[1:0] <= slice_reg_0[2:1];
        else slice_reg_0[3:0] <= slice_reg_0[4:1];
      end
    endcase

    remainder[1] <= new_dat[1]? remainder[1] + 5 : (|remainder[1])? remainder[1] - 1'b1 : '0;
    din_1 <= (|remainder[1])? slice_reg[1][0] : slice_in[0];
    slice_reg[1][4:0] <= new_dat[1]? slice_in[5:1] : {slice_reg[1][4], slice_reg[1][4:1]};
    if (|remainder[1] | new_dat[1]) wr_ena_pre[1] <= 1'b1;


    case (remainder[2])
      0: begin
        din_2[1:0] <= slice_in[1:0];
        if (new_dat[2]) wr_ena_pre[2] <= 1'b1;
        if (new_dat[2] & p2_200) wr_ena_pre[3] <= 1'b1;
        slice_reg[2][4:0] <= p2_200? {slice_reg[2][4], slice_in[5:2]} : slice_in[5:1];
        if (new_dat[2]) remainder[2] <= p2_200? 4 : 5;
      end
      default: begin
        wr_ena_pre[2] <= 1'b1;
        wr_ena_pre[3] <= p2_200;
        din_2[1:0] <= slice_reg[2][1:0];
        remainder[2] <= remainder[2] - (p2_200? 2 : 1);
        slice_reg[2][4:0] <= p2_200? {slice_reg[2][4:3], slice_reg[2][4:2]} :  {slice_reg[2][4], slice_reg[2][4:1]};
      end
    endcase

    remainder[3] <= new_dat[3]? remainder[3] + 5 : (|remainder[3])? remainder[3] - 1'b1 : '0;
    din_3 <= (|remainder[3])? slice_reg[3][0] : slice_in[0];
    slice_reg[3][4:0] <= new_dat[3]? slice_in[5:1] : {slice_reg[3][4], slice_reg[3][4:1]};
    if (|remainder[3] | new_dat[3]) wr_ena_pre[3] <= 1'b1;


    case (remainder[4])
      0: begin
        din_4[1:0] <= slice_in[1:0];
        if (new_dat[4]) wr_ena_pre[4] <= 1'b1;
        if (new_dat[4] & p4_200) wr_ena_pre[5] <= 1'b1;
        slice_reg[4][4:0] <= p4_200? {slice_reg[4][4], slice_in[5:2]} : slice_in[5:1];
        if (new_dat[4]) remainder[4] <= p4_200? 4 : 5;
      end
      default: begin
        wr_ena_pre[4] <= 1'b1;
        wr_ena_pre[5] <= p4_200;
        din_4[1:0] <= slice_reg[4][1:0];
        remainder[4] <= remainder[4] - (p4_200? 2 : 1);
        slice_reg[4][4:0] <= p4_200? {slice_reg[4][4:3], slice_reg[4][4:2]} :  {slice_reg[4][4], slice_reg[4][4:1]};;
      end
    endcase

    remainder[5] <= new_dat[5]? remainder[5] + 5 : (|remainder[5])? remainder[5] - 1'b1 : '0;
    din_5 <= (|remainder[5])? slice_reg[5][0] : slice_in[0];
    slice_reg[5][4:0] <= new_dat[5]? slice_in[5:1] :  {slice_reg[5][4], slice_reg[5][4:1]};
    if (|remainder[5] | new_dat[5]) wr_ena_pre[5] <= 1'b1;

    wr_ena <= wr_ena_pre;

   rst_mask[0] <= rst[0];
   rst_mask[1] <= p0_200_or_400? rst[0] : rst[1];
   rst_mask[2] <= p0_400? rst[0] : rst[2];
   rst_mask[3] <= p0_400? rst[0] : p2_200? rst[2] : rst[3];
   rst_mask[4] <= rst[4];
   rst_mask[5] <= p4_200? rst[4] : rst[5];


    // reset
    for (int i=0; i<6; i++) begin
      if (rst_mask[i]) remainder[i] <= '0;
    end
  end

  wire    [5:0] fifo_empty, ae;
  slice_t [5:0] fout_slice;
  wire    [5:0] fout_vld;
  reg     [5:0] rd_deep_fifo_ena;


  wire    [5:0] shallow_tready, shallow_ae;

  always @(posedge clk) begin
    for (int i=0; i<6; i++) begin
      if (fifo_empty[i]) dat_enough[i] <= 1'b0;
      else if (!ae[i]) dat_enough[i] <= 1'b1;
    end
    rd_deep_fifo_ena <= dat_enough & shallow_ae;
  end

  genvar z;
  generate
    for (z=0; z<6; z++) begin : GEN_FIFO
      xpm_fifo_sync #(
       .DOUT_RESET_VALUE("0"),
       .ECC_MODE("no_ecc"),
       .FIFO_MEMORY_TYPE("block"),
       .FIFO_READ_LATENCY(2),
       .FIFO_WRITE_DEPTH(256),
       .FULL_RESET_VALUE(0),      // ECC related
       .PROG_EMPTY_THRESH(18),
       .PROG_FULL_THRESH(128),
       .READ_DATA_WIDTH($bits(slice_t)),
       .READ_MODE("std"),
       //.SIM_ASSERT_CHK(0),        // 0=disable simulation messages, 1=enable simulation messages
       .USE_ADV_FEATURES("1303"), // [0]: enable overflow; [1]: prog_full; [2]: wr_data_count; [3]: almost_full; [4]:  wr_ack; [8]: underflow; [9] prog_empty; [10] rd_data_count; [11] almost_empty; [12] data_valid
       .WAKEUP_TIME(0),           //  disable
       .WRITE_DATA_WIDTH($bits(slice_t)),
       .RD_DATA_COUNT_WIDTH(0),
       .WR_DATA_COUNT_WIDTH(0)
      )
      deep_fifo_inst (
         .rst(rst_mask[z]),
         .wr_clk(clk),
         .wr_en(wr_ena[z]),
         .din(fin[z]),
         .rd_en(rd_deep_fifo_ena[z]),
         .data_valid(fout_vld[z]),
         .dout(fout_slice[z]),
         .empty(fifo_empty[z]),
         .overflow(o_overflow[z]),
         .prog_empty(ae[z]),
         .prog_full(o_af[z]),
         .underflow(o_underflow[z]),
         // unused ports
         .sleep (),
         .full (),
         .wr_data_count (),
         .wr_rst_busy (),
         .almost_full (),
         .wr_ack (),
         .rd_data_count (),
         .rd_rst_busy (),
         .almost_empty (),
         .injectsbiterr (),
         .injectdbiterr (),
         .sbiterr (),
         .dbiterr ()
      );

      xpm_fifo_axis #(
       .CDC_SYNC_STAGES(2),
       .CLOCKING_MODE("common_clock"),
       .ECC_MODE("no_ecc"),
       .FIFO_DEPTH(16),
       .FIFO_MEMORY_TYPE("distributed"),
       .PACKET_FIFO("false"),
       .PROG_EMPTY_THRESH(8),
       .PROG_FULL_THRESH(10),  // dont care
       .RD_DATA_COUNT_WIDTH(1),
       .RELATED_CLOCKS(0),
       //.SIM_ASSERT_CHK(0),
       .TDATA_WIDTH($bits(slice_t)),
       .TDEST_WIDTH(1),
       .TID_WIDTH(1),
       .TUSER_WIDTH(1),
       .USE_ADV_FEATURES("1200"),  // bit[9] prog_empty flag
       .WR_DATA_COUNT_WIDTH(1)
      )
      shallow_fifo_inst  (
        .s_aclk          (clk),
        .s_aresetn       (~rst_mask[z]),
        .s_axis_tid      ('0),
        .s_axis_tdata    (fout_slice[z]),
        .s_axis_tvalid   (fout_vld[z]),
        .s_axis_tready   (shallow_tready[z]),
        .prog_empty_axis (shallow_ae[z]),
        .m_aclk          (clk),
        .m_axis_tdata    (slice_out[z]),
        .m_axis_tvalid   (o_vld[z]),
        .m_axis_tready   (tready_mask[z]),
        // unused ports
        .s_axis_tstrb (),
        .s_axis_tkeep (),
        .s_axis_tlast (),
        .s_axis_tdest (),
        .s_axis_tuser (),
        .m_axis_tstrb (),
        .m_axis_tkeep (),
        .m_axis_tlast (),
        .m_axis_tid (),
        .m_axis_tdest (),
        .m_axis_tuser (),
        .prog_full_axis (),
        .wr_data_count_axis (),
        .almost_full_axis (),
        .rd_data_count_axis (),
        .almost_empty_axis (),
        .injectsbiterr_axis (),
        .injectdbiterr_axis (),
        .sbiterr_axis (),
        .dbiterr_axis ()
      );
    end
  endgenerate

endmodule
