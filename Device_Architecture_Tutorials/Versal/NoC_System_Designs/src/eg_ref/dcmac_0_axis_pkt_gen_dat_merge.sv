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
module dcmac_0_axis_pkt_gen_dat_merge (
  clk,
  rst,
  i_id_m1,
  i_buf_size,
  i_buf_idx,
  i_dat_ena,
  i_dat,
  o_id,
  o_dat
);

  input  clk;
  input  rst;
  input  [2:0] i_id_m1;
  input  [7:0] i_buf_size;
  input  [7:0] i_buf_idx;
  input  i_dat_ena;
  input  [191:0][7:0] i_dat;
  output reg [2:0] o_id;
  output reg [191:0][7:0] o_dat;

  reg   [3:0][2:0] id;
  logic [3:0][7:0] buf_size;
  logic [3:0][7:0] buf_idx;
  logic [3:0][1535:0] shift_dat_new;
  logic [3:0][1535:0] shift_dat_old;
  wire  [0:0][1536-8-1:0] buf_dat_i, buf_dat_o;
  wire  [3:3][191-1:0][7:0] byte_old;
  wire  [3:3][191:0][7:0] byte_new;

  assign buf_size[0] = i_buf_size;
  assign buf_idx[0] = i_buf_idx;

  assign shift_dat_old[0] = buf_dat_o[0];
  assign shift_dat_new[0] = i_dat;

  assign buf_dat_i[0] = i_dat[191:1]; // shift 1B out because it needs at least 1 new byte

  assign byte_old[3] = shift_dat_old[3];
  assign byte_new[3] = shift_dat_new[3];

  always @(posedge clk) begin

    id[3:0] <= {id[2:0], i_id_m1};
    buf_size[3:1] <= buf_size[2:0];
    buf_idx[3:1]  <= buf_idx[2:0];

    // shift the old data (buffered data) for output data merging
    shift_dat_old[1] <= shift_dat_old[0] >> {buf_idx[0][2:0], 3'd0};
    shift_dat_old[2] <= shift_dat_old[1] >> {buf_idx[1][5:3], 6'd0};
    shift_dat_old[3] <= shift_dat_old[2] >> {buf_idx[2][7:6], 9'd0};

    // shift the new data for output data merging
    shift_dat_new[1] <= shift_dat_new[0] << {buf_size[0][2:0], 3'd0};
    shift_dat_new[2] <= shift_dat_new[1] << {buf_size[1][5:3], 6'd0};
    shift_dat_new[3] <= shift_dat_new[2] << {buf_size[2][7:6], 9'd0};

    // merge the buffer data and the shifted new data
    for (int i=0; i<192; i++) begin
      o_dat[i] <= (i < buf_size[3])? byte_old[3][i] : byte_new[3][i];
    end
    o_id <= id[3];
  end

  dcmac_0_ts_context_mem_v2  #(
    .DW (1536 - 8),
    .DISABLE_INIT (1)
  ) i_dcmac_0_buffer_dat_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (i_id_m1),
    .i_ena           (i_dat_ena),
    .i_dat           (buf_dat_i[0]),
    .o_dat           (buf_dat_o[0]),
    .i_rd_during_wr  (),
    .o_init          ()
  );

endmodule
