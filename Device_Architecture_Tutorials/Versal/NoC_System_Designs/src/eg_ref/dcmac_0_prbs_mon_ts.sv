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
module dcmac_0_prbs_mon_ts (
  clk,
  rst,
  i_id,
  i_num_byte,
  i_dat,
  i_prbs_locked,
  o_prbs_locked,
  o_prbs_err
);

  parameter COUNTER_MODE = 0;

  input        clk;
  input        rst;
  input        [3-1:0] i_id;
  input        [8-1:0] i_num_byte;
  input        [1536-1:0] i_dat;
  input        i_prbs_locked;
  output logic o_prbs_locked;
  output reg o_prbs_err;

  wire   [6:0][31:0][16-1:0] seed_group;
  reg    [1:1][6:0][16-1:0] seed_pipe;
  reg    [4:1][3-1:0] id;
  reg    [2:1] shift;
  reg    [3:1][8-1:0] num_byte;
  reg    [3:1][1536-1:0] dat;
  wire   [192+2-1:0][7:0] wide_bus;
  logic  [192:0][2-1:0][7:0] seed_array;
  reg    [2:2][16-1:0] seed_select;
  wire   [2:2][16-1:0] seed_i, seed_o;
  reg    [5:1] load_new_seed, prbs_locked;
  logic  [3:3][192-1:0][7:0] prbs_nxt;
  wire   [3:3][192-1:0][7:0] byte_in;
  logic  [4:4][192-1:0] byte_err;
  reg    [5:5][1:0] err_cnt_i, err_cnt_o;
  reg    [5:5] byte_err_is_0, byte_err_full;

  assign wide_bus = {i_dat, 16'd0};

  assign byte_in[3] = dat[3];

  always @* begin
    for (int i=0; i<=192; i++) begin
      for (int j=0; j<2; j++) begin
        seed_array[i][j] = wide_bus[i+j];
      end
    end
  end

  assign seed_group[0] = seed_array[31:0];
  assign seed_group[1] = seed_array[63:32];
  assign seed_group[2] = seed_array[95:64];
  assign seed_group[3] = seed_array[127:96];
  assign seed_group[4] = seed_array[159:128];
  assign seed_group[5] = seed_array[191:160];
  assign seed_group[6] = seed_array[192:192];

  assign seed_i[2] = (!COUNTER_MODE & shift[2])? {seed_select[2][15:8], seed_o[2][15:8]} : seed_select[2];

  always @(posedge clk) begin
    id <= {id, i_id};
    prbs_locked <= {prbs_locked, i_prbs_locked};
    num_byte <= {num_byte, i_num_byte};
    dat <= {dat, i_dat};

    for (int i=0; i<7; i++) begin
      seed_pipe[1][i] <= COUNTER_MODE? {8'd0, seed_group[i][i_num_byte[4:0]][15:8]} : seed_group[i][i_num_byte[4:0]];
    end

    seed_select[2] <= seed_pipe[1][num_byte[1][8-1:5]];

    load_new_seed[1] <= |i_num_byte;
    load_new_seed[5:2] <= load_new_seed[4:1];
    shift[1] <= i_num_byte == 1;
    shift[2] <= shift[1];

    for (int i=0; i<192; i++) begin
      byte_err[4][i] <= (i < num_byte[3])? prbs_nxt[3][i] != byte_in[3][i] : 1'b0;
    end
    byte_err_is_0[5] <= byte_err[4] == '0;
    byte_err_full[5] <= byte_err[4] == '1;
  end

  dcmac_0_ts_context_mem_v2  #(
    .DW (16),
    .INIT_VALUE (0)
  ) i_dcmac_0_seed_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (id[1]),
    .i_ena           (load_new_seed[2]),
    .i_rd_during_wr  (),
    .i_dat           (seed_i[2]),
    .o_dat           (seed_o[2]),
    .o_init          ()
  );

  dcmac_0_ts_context_mem_v2  #(
    .DW (2),
    .INIT_VALUE (0)
  ) i_dcmac_0_match_ctx (
    .clk             (clk),
    .rst             (rst),
    .ts_rst          (1'b0),
    .i_rd_id         (id[4]),
    .i_ena           (load_new_seed[5]),
    .i_rd_during_wr  (),
    .i_dat           (err_cnt_i[5]),
    .o_dat           (err_cnt_o[5]),
    .o_init          ()
  );

  always @* begin
    err_cnt_i[5] = err_cnt_o[5];

    if (byte_err_is_0[5]) err_cnt_i[5] = '0;
    else if (!err_cnt_o[5][1]) err_cnt_i[5]++;
  end


  always @(posedge clk) begin
    if (rst) begin
      o_prbs_locked <= 1'b0;
      o_prbs_err <= 1'b0;
    end
    else begin
      o_prbs_err <= prbs_locked[5]? !byte_err_is_0[5] : 0;

      if (load_new_seed[5]) begin
        if (byte_err_is_0[5]) o_prbs_locked <= 1'b1;
        else begin
          if (byte_err_full[5]) o_prbs_locked <= 1'b0;
          else o_prbs_locked <= ~err_cnt_o[5][1]; // 3 times to lose lock
        end
      end
      else  o_prbs_locked <= prbs_locked[5];
    end
  end

  dcmac_0_prbs_gen_ts #(
    .COUNTER_MODE (COUNTER_MODE),
    .LOAD_SEED (1),
    .REGISTER_OUTPUT (1)
  ) i_dcmac_0_prbs_gen (
    .clk         (clk),
    .rst         (rst),
    .i_id_m1     (),
    .i_req_en    (),
    .i_req_num   (8'd192),
    .i_seed      (seed_o[2]),
    .o_dat       (prbs_nxt[3])
  );




endmodule
