//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5059413 Wed May  1 19:41:18 MDT 2024
//Date        : Thu May  2 10:45:59 2024
//Host        : xcoapps75 running 64-bit Ubuntu 22.04.3 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top
   (ddr4_dimm0_act_n,
    ddr4_dimm0_adr,
    ddr4_dimm0_alert_n,
    ddr4_dimm0_ba,
    ddr4_dimm0_bg,
    ddr4_dimm0_ck_c,
    ddr4_dimm0_ck_t,
    ddr4_dimm0_cke,
    ddr4_dimm0_cs_n,
    ddr4_dimm0_dq,
    ddr4_dimm0_dqs_c,
    ddr4_dimm0_dqs_t,
    ddr4_dimm0_odt,
    ddr4_dimm0_par,
    ddr4_dimm0_reset_n,
    ddr4_dimm0_sma_clk_clk_n,
    ddr4_dimm0_sma_clk_clk_p);
  output ddr4_dimm0_act_n;
  output [16:0]ddr4_dimm0_adr;
  input ddr4_dimm0_alert_n;
  output [1:0]ddr4_dimm0_ba;
  output [1:0]ddr4_dimm0_bg;
  output ddr4_dimm0_ck_c;
  output ddr4_dimm0_ck_t;
  output ddr4_dimm0_cke;
  output ddr4_dimm0_cs_n;
  inout [71:0]ddr4_dimm0_dq;
  inout [8:0]ddr4_dimm0_dqs_c;
  inout [8:0]ddr4_dimm0_dqs_t;
  output ddr4_dimm0_odt;
  output ddr4_dimm0_par;
  output ddr4_dimm0_reset_n;
  input ddr4_dimm0_sma_clk_clk_n;
  input ddr4_dimm0_sma_clk_clk_p;


  wire ddr4_dimm0_act_n;
  wire [16:0]ddr4_dimm0_adr;
  wire ddr4_dimm0_alert_n;
  wire [1:0]ddr4_dimm0_ba;
  wire [1:0]ddr4_dimm0_bg;
  wire ddr4_dimm0_ck_c;
  wire ddr4_dimm0_ck_t;
  wire ddr4_dimm0_cke;
  wire ddr4_dimm0_cs_n;
  wire [71:0]ddr4_dimm0_dq;
  wire [8:0]ddr4_dimm0_dqs_c;
  wire [8:0]ddr4_dimm0_dqs_t;
  wire ddr4_dimm0_odt;
  wire ddr4_dimm0_par;
  wire ddr4_dimm0_reset_n;
  wire ddr4_dimm0_sma_clk_clk_n;
  wire ddr4_dimm0_sma_clk_clk_p;
  wire pl0_ref_clk_0;
  wire pl0_resetn_0;
  
  wire [1:0] tg_done;
  wire [1:0] tg_error;

`ifdef SIM_ENABLED
   sim_clk_gen u_sim_clk_gen (
      .clk(pl0_ref_clk_0)
   );
`endif

   design_1 design_1_i (
      .ddr4_dimm0_act_n(ddr4_dimm0_act_n),
      .ddr4_dimm0_adr(ddr4_dimm0_adr),
      .ddr4_dimm0_alert_n(ddr4_dimm0_alert_n),
      .ddr4_dimm0_ba(ddr4_dimm0_ba),
      .ddr4_dimm0_bg(ddr4_dimm0_bg),
      .ddr4_dimm0_ck_c(ddr4_dimm0_ck_c),
      .ddr4_dimm0_ck_t(ddr4_dimm0_ck_t),
      .ddr4_dimm0_cke(ddr4_dimm0_cke),
      .ddr4_dimm0_cs_n(ddr4_dimm0_cs_n),
      .ddr4_dimm0_dq(ddr4_dimm0_dq),
      .ddr4_dimm0_dqs_c(ddr4_dimm0_dqs_c),
      .ddr4_dimm0_dqs_t(ddr4_dimm0_dqs_t),
      .ddr4_dimm0_odt(ddr4_dimm0_odt),
      .ddr4_dimm0_par(ddr4_dimm0_par),
      .ddr4_dimm0_reset_n(ddr4_dimm0_reset_n),
      .ddr4_dimm0_sma_clk_clk_n(ddr4_dimm0_sma_clk_clk_n),
      .ddr4_dimm0_sma_clk_clk_p(ddr4_dimm0_sma_clk_clk_p),
      .pl0_ref_clk_0(pl0_ref_clk_0),
      .pl0_resetn_0(pl0_resetn_0)
   );

`ifdef SIM_ENABLED
   vio_sim vio_sim_inst (
`else
   vio_pl_master_to_hbm vio_pl_master_to_hbm_inst (
`endif 
      .probe_in0(tg_done),    // input wire [1 : 0] probe_in0
      .probe_in1(tg_error),    // input wire [1 : 0] probe_in0
      .probe_out0(tg_rstb),  // output wire [0 : 0] probe_out0
      .probe_out1(tg_start),  // output wire [0 : 0] probe_out0
      .clk(pl0_ref_clk_0)                // input wire clk
   );
      

   vnoc_to_hbm vnoc_to_hbm_inst (
      .pl0_ref_clk_0(pl0_ref_clk_0),
      .tg_rstb(tg_rstb),
      .tg_start(tg_start),
      .tg_done(tg_done[0]),
      .tg_error(tg_error[0])
   );
        
   bli_to_hbm bli_to_hbm_inst (
      .pl0_ref_clk_0(pl0_ref_clk_0),
      .tg_rstb(tg_rstb),
      .tg_start(tg_start),
      .tg_done(tg_done[1]),
      .tg_error(tg_error[1])
   );
        
endmodule
