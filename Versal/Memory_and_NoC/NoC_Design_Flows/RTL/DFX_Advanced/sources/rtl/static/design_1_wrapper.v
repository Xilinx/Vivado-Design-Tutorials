//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 3995751 Tue Sep 12 10:48:01 MDT 2023
//Date        : Wed Sep 13 17:56:26 2023
//Host        : xcoapps70 running 64-bit Red Hat Enterprise Linux release 8.4 (Ootpa)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module design_1_wrapper
   (ddr4_dimm1_act_n,
    ddr4_dimm1_adr,
    ddr4_dimm1_ba,
    ddr4_dimm1_bg,
    ddr4_dimm1_ck_c,
    ddr4_dimm1_ck_t,
    ddr4_dimm1_cke,
    ddr4_dimm1_cs_n,
    ddr4_dimm1_dm_n,
    ddr4_dimm1_dq,
    ddr4_dimm1_dqs_c,
    ddr4_dimm1_dqs_t,
    ddr4_dimm1_odt,
    ddr4_dimm1_reset_n,
    ddr4_dimm1_sma_clk_clk_n,
    ddr4_dimm1_sma_clk_clk_p);
  output ddr4_dimm1_act_n;
  output [16:0]ddr4_dimm1_adr;
  output [1:0]ddr4_dimm1_ba;
  output [1:0]ddr4_dimm1_bg;
  output ddr4_dimm1_ck_c;
  output ddr4_dimm1_ck_t;
  output ddr4_dimm1_cke;
  output ddr4_dimm1_cs_n;
  inout [7:0]ddr4_dimm1_dm_n;
  inout [63:0]ddr4_dimm1_dq;
  inout [7:0]ddr4_dimm1_dqs_c;
  inout [7:0]ddr4_dimm1_dqs_t;
  output ddr4_dimm1_odt;
  output ddr4_dimm1_reset_n;
  input ddr4_dimm1_sma_clk_clk_n;
  input ddr4_dimm1_sma_clk_clk_p;

  wire ddr4_dimm1_act_n;
  wire [16:0]ddr4_dimm1_adr;
  wire [1:0]ddr4_dimm1_ba;
  wire [1:0]ddr4_dimm1_bg;
  wire ddr4_dimm1_ck_c;
  wire ddr4_dimm1_ck_t;
  wire ddr4_dimm1_cke;
  wire ddr4_dimm1_cs_n;
  wire [7:0]ddr4_dimm1_dm_n;
  wire [63:0]ddr4_dimm1_dq;
  wire [7:0]ddr4_dimm1_dqs_c;
  wire [7:0]ddr4_dimm1_dqs_t;
  wire ddr4_dimm1_odt;
  wire ddr4_dimm1_reset_n;
  wire ddr4_dimm1_sma_clk_clk_n;
  wire ddr4_dimm1_sma_clk_clk_p;
  wire [15:0] s_axis_error;
  
initial 
    begin
    #100; 
    force design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.pl0_resetn = 1;
    // Enabling the routing for NOC FPD port to OCM peripheral in CIPS. This
    // is used  to demonstrate the PL to CIPS via XPM NoC
    design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.inst.pspmc_0.inst.PS9_VIP_inst.inst.set_routing_config("NOC_FPD_AXI_0","OCM",1);

    end
    
  design_1 design_1_i
       (.ddr4_dimm1_act_n(ddr4_dimm1_act_n),
        .ddr4_dimm1_adr(ddr4_dimm1_adr),
        .ddr4_dimm1_ba(ddr4_dimm1_ba),
        .ddr4_dimm1_bg(ddr4_dimm1_bg),
        .ddr4_dimm1_ck_c(ddr4_dimm1_ck_c),
        .ddr4_dimm1_ck_t(ddr4_dimm1_ck_t),
        .ddr4_dimm1_cke(ddr4_dimm1_cke),
        .ddr4_dimm1_cs_n(ddr4_dimm1_cs_n),
        .ddr4_dimm1_dm_n(ddr4_dimm1_dm_n),
        .ddr4_dimm1_dq(ddr4_dimm1_dq),
        .ddr4_dimm1_dqs_c(ddr4_dimm1_dqs_c),
        .ddr4_dimm1_dqs_t(ddr4_dimm1_dqs_t),
        .ddr4_dimm1_odt(ddr4_dimm1_odt),
        .ddr4_dimm1_reset_n(ddr4_dimm1_reset_n),
        .ddr4_dimm1_sma_clk_clk_n(ddr4_dimm1_sma_clk_clk_n),
        .ddr4_dimm1_sma_clk_clk_p(ddr4_dimm1_sma_clk_clk_p),
        .pl0_ref_clk_0(pl0_ref_clk_0),
        .pl0_resetn_0(pl0_resetn_0));
  

`ifdef SIM_ENABLED
    sim_clk_gen u_sim_clk_gen (
        .clk(pl0_ref_clk_0)
    );
`endif
  
   (* DONT_TOUCH = "yes" *) RP1 RP1_inst
      (.clk(pl0_ref_clk_0),
      .rstb (vio_rst_n),
      .dbg_hub_rstb(pl0_resetn_0),
      .error(s_axis_error));


endmodule
