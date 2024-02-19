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
module dcmac_0_axis_pkt_gen_buffer_ctx (
  clk,
  rst,
  i_id,
  i_id_valid_p1,
  i_size,
  o_id,
  o_buf_size,
  o_buf_idx,
  o_dat_req
);

  input  clk;
  input  rst;
  input  i_id_valid_p1;
  input  [2:0] i_id;
  input  [7:0] i_size;
  output reg [2:0] o_id;
  output reg [7:0] o_buf_size;
  output reg [7:0] o_buf_idx;
  output reg o_dat_req;


  reg   [1:1][2:0] id;
  reg   [1:1][7:0] size, size_c, size_m1;
  wire  [1:1] need_new_ena_i, need_new_ena_o;
  wire  [1:1][1:0][7:0] buf_size_i;
  wire  [1:1][1:0][7:0] buf_size_o;
  wire  [1:1][1:0][7:0] buf_idx_i;
  wire  [1:1][1:0][7:0] buf_idx_o;
  wire  [1:1][7:0] buf_size_mux;
  wire  [1:1][7:0] buf_idx_mux;


  assign buf_size_mux[1] = buf_size_o[1][need_new_ena_o[1]];
  assign buf_idx_mux[1]  = buf_idx_o[1][need_new_ena_o[1]];

  assign need_new_ena_i[1] = buf_size_mux[1] < size[1];
  assign buf_size_i[1][1]  = buf_size_mux[1] + size_c[1];
  assign buf_size_i[1][0]  = buf_size_mux[1] - size[1];

  // the index of the first valid byte in the buffer
  assign buf_idx_i[1][1] = size_m1[1] - buf_size_mux[1];
  assign buf_idx_i[1][0] = buf_idx_mux[1] + size[1];


  always @(posedge clk) begin
    size[1] <= i_size;
    size_c[1] <= 192 - i_size;
    size_m1[1] = i_size - 1'b1;
    id[1] <= i_id;

    o_dat_req <= need_new_ena_i[1];
    {o_buf_size, o_buf_idx} <= {buf_size_mux[1], buf_idx_mux[1]};
    o_id <= id[1];
  end

  dcmac_0_ts_context_mem_v2  #(
    .DW (8 * 2),
    .INIT_VALUE (0)
  ) i_dcmac_0_buffer_size_0_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (i_id),
    .i_ena           (i_id_valid_p1),
    .i_dat           ({buf_size_i[1][0], buf_idx_i[1][0]}),
    .o_dat           ({buf_size_o[1][0], buf_idx_o[1][0]}),
    .i_rd_during_wr  (),
    .o_init          ()
  );



  dcmac_0_ts_context_mem_v2  #(
    .DW (8 * 2),
    .INIT_VALUE (0)
  ) i_dcmac_0_buffer_size_1_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (i_id),
    .i_ena           (i_id_valid_p1),
    .i_dat           ({buf_size_i[1][1], buf_idx_i[1][1]}),
    .o_dat           ({buf_size_o[1][1], buf_idx_o[1][1]}),
    .i_rd_during_wr  (),
    .o_init          ()
  );


  dcmac_0_ts_context_mem_v2  #(
    .DW (1),
    .INIT_VALUE (0)
  ) i_dcmac_0_gt_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (i_id),
    .i_ena           (i_id_valid_p1),
    .i_dat           (need_new_ena_i[1]),
    .o_dat           (need_new_ena_o[1]),
    .i_rd_during_wr  (),
    .o_init          ()
  );

endmodule
