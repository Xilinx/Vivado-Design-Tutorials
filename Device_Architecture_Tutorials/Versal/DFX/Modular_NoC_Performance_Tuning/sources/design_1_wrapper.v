//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Sat Oct 21 13:19:37 2023
//Host        : xhdlc201951 running 64-bit CentOS Linux release 7.4.1708 (Core)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CE_0,
    CH0_DDR4_0_0_0_act_n,
    CH0_DDR4_0_0_0_adr,
    CH0_DDR4_0_0_0_ba,
    CH0_DDR4_0_0_0_bg,
    CH0_DDR4_0_0_0_ck_c,
    CH0_DDR4_0_0_0_ck_t,
    CH0_DDR4_0_0_0_cke,
    CH0_DDR4_0_0_0_cs_n,
    CH0_DDR4_0_0_0_dm_n,
    CH0_DDR4_0_0_0_dq,
    CH0_DDR4_0_0_0_dqs_c,
    CH0_DDR4_0_0_0_dqs_t,
    CH0_DDR4_0_0_0_odt,
    CH0_DDR4_0_0_0_reset_n,
    clk_in1_0,
    clk_in1_0_0,
    ext_reset_in_0,
    reset_0,
    sys_clk0_0_clk_n,
    sys_clk0_0_clk_p);
  input CE_0;
  output [0:0]CH0_DDR4_0_0_0_act_n;
  output [16:0]CH0_DDR4_0_0_0_adr;
  output [1:0]CH0_DDR4_0_0_0_ba;
  output [1:0]CH0_DDR4_0_0_0_bg;
  output [0:0]CH0_DDR4_0_0_0_ck_c;
  output [0:0]CH0_DDR4_0_0_0_ck_t;
  output [0:0]CH0_DDR4_0_0_0_cke;
  output [0:0]CH0_DDR4_0_0_0_cs_n;
  inout [7:0]CH0_DDR4_0_0_0_dm_n;
  inout [63:0]CH0_DDR4_0_0_0_dq;
  inout [7:0]CH0_DDR4_0_0_0_dqs_c;
  inout [7:0]CH0_DDR4_0_0_0_dqs_t;
  output [0:0]CH0_DDR4_0_0_0_odt;
  output [0:0]CH0_DDR4_0_0_0_reset_n;
  input clk_in1_0;
  input clk_in1_0_0;
  input ext_reset_in_0;
  input reset_0;
  input [0:0]sys_clk0_0_clk_n;
  input [0:0]sys_clk0_0_clk_p;

  wire CE_0;
  wire [0:0]CH0_DDR4_0_0_0_act_n;
  wire [16:0]CH0_DDR4_0_0_0_adr;
  wire [1:0]CH0_DDR4_0_0_0_ba;
  wire [1:0]CH0_DDR4_0_0_0_bg;
  wire [0:0]CH0_DDR4_0_0_0_ck_c;
  wire [0:0]CH0_DDR4_0_0_0_ck_t;
  wire [0:0]CH0_DDR4_0_0_0_cke;
  wire [0:0]CH0_DDR4_0_0_0_cs_n;
  wire [7:0]CH0_DDR4_0_0_0_dm_n;
  wire [63:0]CH0_DDR4_0_0_0_dq;
  wire [7:0]CH0_DDR4_0_0_0_dqs_c;
  wire [7:0]CH0_DDR4_0_0_0_dqs_t;
  wire [0:0]CH0_DDR4_0_0_0_odt;
  wire [0:0]CH0_DDR4_0_0_0_reset_n;
  wire clk_in1_0;
  wire clk_in1_0_0;
  wire ext_reset_in_0;
  wire reset_0;
  wire [0:0]sys_clk0_0_clk_n;
  wire [0:0]sys_clk0_0_clk_p;

  design_1 design_1_i
       (.CE_0(CE_0),
        .CH0_DDR4_0_0_0_act_n(CH0_DDR4_0_0_0_act_n),
        .CH0_DDR4_0_0_0_adr(CH0_DDR4_0_0_0_adr),
        .CH0_DDR4_0_0_0_ba(CH0_DDR4_0_0_0_ba),
        .CH0_DDR4_0_0_0_bg(CH0_DDR4_0_0_0_bg),
        .CH0_DDR4_0_0_0_ck_c(CH0_DDR4_0_0_0_ck_c),
        .CH0_DDR4_0_0_0_ck_t(CH0_DDR4_0_0_0_ck_t),
        .CH0_DDR4_0_0_0_cke(CH0_DDR4_0_0_0_cke),
        .CH0_DDR4_0_0_0_cs_n(CH0_DDR4_0_0_0_cs_n),
        .CH0_DDR4_0_0_0_dm_n(CH0_DDR4_0_0_0_dm_n),
        .CH0_DDR4_0_0_0_dq(CH0_DDR4_0_0_0_dq),
        .CH0_DDR4_0_0_0_dqs_c(CH0_DDR4_0_0_0_dqs_c),
        .CH0_DDR4_0_0_0_dqs_t(CH0_DDR4_0_0_0_dqs_t),
        .CH0_DDR4_0_0_0_odt(CH0_DDR4_0_0_0_odt),
        .CH0_DDR4_0_0_0_reset_n(CH0_DDR4_0_0_0_reset_n),
        .clk_in1_0(clk_in1_0),
        .clk_in1_0_0(clk_in1_0_0),
        .ext_reset_in_0(ext_reset_in_0),
        .reset_0(reset_0),
        .sys_clk0_0_clk_n(sys_clk0_0_clk_n),
        .sys_clk0_0_clk_p(sys_clk0_0_clk_p));
endmodule
