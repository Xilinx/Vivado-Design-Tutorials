//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Wed Jul  7 11:54:00 2021
//Host        : xcoswapps102 running 64-bit CentOS Linux release 7.4.1708 (Core)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (C0_DDR4_SLR0_act_n,
    C0_DDR4_SLR0_adr,
    C0_DDR4_SLR0_ba,
    C0_DDR4_SLR0_bg,
    C0_DDR4_SLR0_ck_c,
    C0_DDR4_SLR0_ck_t,
    C0_DDR4_SLR0_cke,
    C0_DDR4_SLR0_cs_n,
    C0_DDR4_SLR0_dm_n,
    C0_DDR4_SLR0_dq,
    C0_DDR4_SLR0_dqs_c,
    C0_DDR4_SLR0_dqs_t,
    C0_DDR4_SLR0_odt,
    C0_DDR4_SLR0_reset_n,
    C0_DDR4_SLR1_act_n,
    C0_DDR4_SLR1_adr,
    C0_DDR4_SLR1_ba,
    C0_DDR4_SLR1_bg,
    C0_DDR4_SLR1_ck_c,
    C0_DDR4_SLR1_ck_t,
    C0_DDR4_SLR1_cke,
    C0_DDR4_SLR1_cs_n,
    C0_DDR4_SLR1_dm_n,
    C0_DDR4_SLR1_dq,
    C0_DDR4_SLR1_dqs_c,
    C0_DDR4_SLR1_dqs_t,
    C0_DDR4_SLR1_odt,
    C0_DDR4_SLR1_reset_n,
    C0_DDR4_SLR2_act_n,
    C0_DDR4_SLR2_adr,
    C0_DDR4_SLR2_ba,
    C0_DDR4_SLR2_bg,
    C0_DDR4_SLR2_ck_c,
    C0_DDR4_SLR2_ck_t,
    C0_DDR4_SLR2_cke,
    C0_DDR4_SLR2_cs_n,
    C0_DDR4_SLR2_dm_n,
    C0_DDR4_SLR2_dq,
    C0_DDR4_SLR2_dqs_c,
    C0_DDR4_SLR2_dqs_t,
    C0_DDR4_SLR2_odt,
    C0_DDR4_SLR2_reset_n,
    C0_DDR4_SLR3_act_n,
    C0_DDR4_SLR3_adr,
    C0_DDR4_SLR3_ba,
    C0_DDR4_SLR3_bg,
    C0_DDR4_SLR3_ck_c,
    C0_DDR4_SLR3_ck_t,
    C0_DDR4_SLR3_cke,
    C0_DDR4_SLR3_cs_n,
    C0_DDR4_SLR3_dm_n,
    C0_DDR4_SLR3_dq,
    C0_DDR4_SLR3_dqs_c,
    C0_DDR4_SLR3_dqs_t,
    C0_DDR4_SLR3_odt,
    C0_DDR4_SLR3_reset_n,
    C0_SYS_CLK_SLR0_clk_n,
    C0_SYS_CLK_SLR0_clk_p,
    C0_SYS_CLK_SLR1_clk_n,
    C0_SYS_CLK_SLR1_clk_p,
    C0_SYS_CLK_SLR2_clk_n,
    C0_SYS_CLK_SLR2_clk_p,
    C0_SYS_CLK_SLR3_clk_n,
    C0_SYS_CLK_SLR3_clk_p,
    clk_in1_0,
    clock_qdma_slr1_clk_n,
    clock_qdma_slr1_clk_p,
    clock_qdma_slr2_clk_n,
    clock_qdma_slr2_clk_p,
    ext_reset_in_0,
    pcie_7x_mgt_rtl_SLR1_rxn,
    pcie_7x_mgt_rtl_SLR1_rxp,
    pcie_7x_mgt_rtl_SLR1_txn,
    pcie_7x_mgt_rtl_SLR1_txp,
    pcie_7x_mgt_rtl_SLR2_rxn,
    pcie_7x_mgt_rtl_SLR2_rxp,
    pcie_7x_mgt_rtl_SLR2_txn,
    pcie_7x_mgt_rtl_SLR2_txp);
  (* io_buffer_type = "none" *) output C0_DDR4_SLR0_act_n;
  (* io_buffer_type = "none" *) output [16:0]C0_DDR4_SLR0_adr;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR0_ba;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR0_bg;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR0_ck_c;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR0_ck_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR0_cke;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR0_cs_n;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR0_dm_n;
  (* io_buffer_type = "none" *) inout [7:0]C0_DDR4_SLR0_dq;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR0_dqs_c;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR0_dqs_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR0_odt;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR0_reset_n;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR1_act_n;
  (* io_buffer_type = "none" *) output [16:0]C0_DDR4_SLR1_adr;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR1_ba;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR1_bg;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR1_ck_c;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR1_ck_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR1_cke;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR1_cs_n;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR1_dm_n;
  (* io_buffer_type = "none" *) inout [7:0]C0_DDR4_SLR1_dq;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR1_dqs_c;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR1_dqs_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR1_odt;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR1_reset_n;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR2_act_n;
  (* io_buffer_type = "none" *) output [16:0]C0_DDR4_SLR2_adr;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR2_ba;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR2_bg;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR2_ck_c;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR2_ck_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR2_cke;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR2_cs_n;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR2_dm_n;
  (* io_buffer_type = "none" *) inout [7:0]C0_DDR4_SLR2_dq;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR2_dqs_c;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR2_dqs_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR2_odt;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR2_reset_n;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR3_act_n;
  (* io_buffer_type = "none" *) output [16:0]C0_DDR4_SLR3_adr;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR3_ba;
  (* io_buffer_type = "none" *) output [1:0]C0_DDR4_SLR3_bg;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR3_ck_c;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR3_ck_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR3_cke;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR3_cs_n;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR3_dm_n;
  (* io_buffer_type = "none" *) inout [7:0]C0_DDR4_SLR3_dq;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR3_dqs_c;
  (* io_buffer_type = "none" *) inout [0:0]C0_DDR4_SLR3_dqs_t;
  (* io_buffer_type = "none" *) output [0:0]C0_DDR4_SLR3_odt;
  (* io_buffer_type = "none" *) output C0_DDR4_SLR3_reset_n;
  (* io_buffer_type = "none" *) input [0:0]C0_SYS_CLK_SLR0_clk_n;
 (* io_buffer_type = "none" *)  input [0:0]C0_SYS_CLK_SLR0_clk_p;
  (* io_buffer_type = "none" *)input [0:0]C0_SYS_CLK_SLR1_clk_n;
  (* io_buffer_type = "none" *) input [0:0]C0_SYS_CLK_SLR1_clk_p;
  (* io_buffer_type = "none" *) input [0:0]C0_SYS_CLK_SLR2_clk_n;
  (* io_buffer_type = "none" *) input [0:0]C0_SYS_CLK_SLR2_clk_p;
  (* io_buffer_type = "none" *) input [0:0]C0_SYS_CLK_SLR3_clk_n;
  (* io_buffer_type = "none" *) input [0:0]C0_SYS_CLK_SLR3_clk_p;
   input clk_in1_0;
  (* io_buffer_type = "none" *) input [0:0]clock_qdma_slr1_clk_n;
  (* io_buffer_type = "none" *) input [0:0]clock_qdma_slr1_clk_p;
  (* io_buffer_type = "none" *) input [0:0]clock_qdma_slr2_clk_n;
  (* io_buffer_type = "none" *) input [0:0]clock_qdma_slr2_clk_p;
  input ext_reset_in_0;
  (* io_buffer_type = "none" *) input pcie_7x_mgt_rtl_SLR1_rxn;
  (* io_buffer_type = "none" *) input pcie_7x_mgt_rtl_SLR1_rxp;
  (* io_buffer_type = "none" *) output pcie_7x_mgt_rtl_SLR1_txn;
  (* io_buffer_type = "none" *) output pcie_7x_mgt_rtl_SLR1_txp;
  (* io_buffer_type = "none" *) input pcie_7x_mgt_rtl_SLR2_rxn;
  (* io_buffer_type = "none" *) input pcie_7x_mgt_rtl_SLR2_rxp;
  (* io_buffer_type = "none" *) output pcie_7x_mgt_rtl_SLR2_txn;
  (* io_buffer_type = "none" *) output pcie_7x_mgt_rtl_SLR2_txp;

  wire C0_DDR4_SLR0_act_n;
  wire [16:0]C0_DDR4_SLR0_adr;
  wire [1:0]C0_DDR4_SLR0_ba;
  wire [1:0]C0_DDR4_SLR0_bg;
  wire [0:0]C0_DDR4_SLR0_ck_c;
  wire [0:0]C0_DDR4_SLR0_ck_t;
  wire [0:0]C0_DDR4_SLR0_cke;
  wire [0:0]C0_DDR4_SLR0_cs_n;
  wire [0:0]C0_DDR4_SLR0_dm_n;
  wire [7:0]C0_DDR4_SLR0_dq;
  wire [0:0]C0_DDR4_SLR0_dqs_c;
  wire [0:0]C0_DDR4_SLR0_dqs_t;
  wire [0:0]C0_DDR4_SLR0_odt;
  wire C0_DDR4_SLR0_reset_n;
  wire C0_DDR4_SLR1_act_n;
  wire [16:0]C0_DDR4_SLR1_adr;
  wire [1:0]C0_DDR4_SLR1_ba;
  wire [1:0]C0_DDR4_SLR1_bg;
  wire [0:0]C0_DDR4_SLR1_ck_c;
  wire [0:0]C0_DDR4_SLR1_ck_t;
  wire [0:0]C0_DDR4_SLR1_cke;
  wire [0:0]C0_DDR4_SLR1_cs_n;
  wire [0:0]C0_DDR4_SLR1_dm_n;
  wire [7:0]C0_DDR4_SLR1_dq;
  wire [0:0]C0_DDR4_SLR1_dqs_c;
  wire [0:0]C0_DDR4_SLR1_dqs_t;
  wire [0:0]C0_DDR4_SLR1_odt;
  wire C0_DDR4_SLR1_reset_n;
  wire C0_DDR4_SLR2_act_n;
  wire [16:0]C0_DDR4_SLR2_adr;
  wire [1:0]C0_DDR4_SLR2_ba;
  wire [1:0]C0_DDR4_SLR2_bg;
  wire [0:0]C0_DDR4_SLR2_ck_c;
  wire [0:0]C0_DDR4_SLR2_ck_t;
  wire [0:0]C0_DDR4_SLR2_cke;
  wire [0:0]C0_DDR4_SLR2_cs_n;
  wire [0:0]C0_DDR4_SLR2_dm_n;
  wire [7:0]C0_DDR4_SLR2_dq;
  wire [0:0]C0_DDR4_SLR2_dqs_c;
  wire [0:0]C0_DDR4_SLR2_dqs_t;
  wire [0:0]C0_DDR4_SLR2_odt;
  wire C0_DDR4_SLR2_reset_n;
  wire C0_DDR4_SLR3_act_n;
  wire [16:0]C0_DDR4_SLR3_adr;
  wire [1:0]C0_DDR4_SLR3_ba;
  wire [1:0]C0_DDR4_SLR3_bg;
  wire [0:0]C0_DDR4_SLR3_ck_c;
  wire [0:0]C0_DDR4_SLR3_ck_t;
  wire [0:0]C0_DDR4_SLR3_cke;
  wire [0:0]C0_DDR4_SLR3_cs_n;
  wire [0:0]C0_DDR4_SLR3_dm_n;
  wire [7:0]C0_DDR4_SLR3_dq;
  wire [0:0]C0_DDR4_SLR3_dqs_c;
  wire [0:0]C0_DDR4_SLR3_dqs_t;
  wire [0:0]C0_DDR4_SLR3_odt;
  wire C0_DDR4_SLR3_reset_n;
  wire [0:0]C0_SYS_CLK_SLR0_clk_n;
  wire [0:0]C0_SYS_CLK_SLR0_clk_p;
  wire [0:0]C0_SYS_CLK_SLR1_clk_n;
  wire [0:0]C0_SYS_CLK_SLR1_clk_p;
  wire [0:0]C0_SYS_CLK_SLR2_clk_n;
  wire [0:0]C0_SYS_CLK_SLR2_clk_p;
  wire [0:0]C0_SYS_CLK_SLR3_clk_n;
  wire [0:0]C0_SYS_CLK_SLR3_clk_p;
  wire clk_in1_0;
  wire [0:0]clock_qdma_slr1_clk_n;
  wire [0:0]clock_qdma_slr1_clk_p;
  wire [0:0]clock_qdma_slr2_clk_n;
  wire [0:0]clock_qdma_slr2_clk_p;
  wire ext_reset_in_0;
  wire pcie_7x_mgt_rtl_SLR1_rxn;
  wire pcie_7x_mgt_rtl_SLR1_rxp;
  wire pcie_7x_mgt_rtl_SLR1_txn;
  wire pcie_7x_mgt_rtl_SLR1_txp;
  wire pcie_7x_mgt_rtl_SLR2_rxn;
  wire pcie_7x_mgt_rtl_SLR2_rxp;
  wire pcie_7x_mgt_rtl_SLR2_txn;
  wire pcie_7x_mgt_rtl_SLR2_txp;

  design_1 design_1_i
       (.C0_DDR4_SLR0_act_n(C0_DDR4_SLR0_act_n),
        .C0_DDR4_SLR0_adr(C0_DDR4_SLR0_adr),
        .C0_DDR4_SLR0_ba(C0_DDR4_SLR0_ba),
        .C0_DDR4_SLR0_bg(C0_DDR4_SLR0_bg),
        .C0_DDR4_SLR0_ck_c(C0_DDR4_SLR0_ck_c),
        .C0_DDR4_SLR0_ck_t(C0_DDR4_SLR0_ck_t),
        .C0_DDR4_SLR0_cke(C0_DDR4_SLR0_cke),
        .C0_DDR4_SLR0_cs_n(C0_DDR4_SLR0_cs_n),
        .C0_DDR4_SLR0_dm_n(C0_DDR4_SLR0_dm_n),
        .C0_DDR4_SLR0_dq(C0_DDR4_SLR0_dq),
        .C0_DDR4_SLR0_dqs_c(C0_DDR4_SLR0_dqs_c),
        .C0_DDR4_SLR0_dqs_t(C0_DDR4_SLR0_dqs_t),
        .C0_DDR4_SLR0_odt(C0_DDR4_SLR0_odt),
        .C0_DDR4_SLR0_reset_n(C0_DDR4_SLR0_reset_n),
        .C0_DDR4_SLR1_act_n(C0_DDR4_SLR1_act_n),
        .C0_DDR4_SLR1_adr(C0_DDR4_SLR1_adr),
        .C0_DDR4_SLR1_ba(C0_DDR4_SLR1_ba),
        .C0_DDR4_SLR1_bg(C0_DDR4_SLR1_bg),
        .C0_DDR4_SLR1_ck_c(C0_DDR4_SLR1_ck_c),
        .C0_DDR4_SLR1_ck_t(C0_DDR4_SLR1_ck_t),
        .C0_DDR4_SLR1_cke(C0_DDR4_SLR1_cke),
        .C0_DDR4_SLR1_cs_n(C0_DDR4_SLR1_cs_n),
        .C0_DDR4_SLR1_dm_n(C0_DDR4_SLR1_dm_n),
        .C0_DDR4_SLR1_dq(C0_DDR4_SLR1_dq),
        .C0_DDR4_SLR1_dqs_c(C0_DDR4_SLR1_dqs_c),
        .C0_DDR4_SLR1_dqs_t(C0_DDR4_SLR1_dqs_t),
        .C0_DDR4_SLR1_odt(C0_DDR4_SLR1_odt),
        .C0_DDR4_SLR1_reset_n(C0_DDR4_SLR1_reset_n),
        .C0_DDR4_SLR2_act_n(C0_DDR4_SLR2_act_n),
        .C0_DDR4_SLR2_adr(C0_DDR4_SLR2_adr),
        .C0_DDR4_SLR2_ba(C0_DDR4_SLR2_ba),
        .C0_DDR4_SLR2_bg(C0_DDR4_SLR2_bg),
        .C0_DDR4_SLR2_ck_c(C0_DDR4_SLR2_ck_c),
        .C0_DDR4_SLR2_ck_t(C0_DDR4_SLR2_ck_t),
        .C0_DDR4_SLR2_cke(C0_DDR4_SLR2_cke),
        .C0_DDR4_SLR2_cs_n(C0_DDR4_SLR2_cs_n),
        .C0_DDR4_SLR2_dm_n(C0_DDR4_SLR2_dm_n),
        .C0_DDR4_SLR2_dq(C0_DDR4_SLR2_dq),
        .C0_DDR4_SLR2_dqs_c(C0_DDR4_SLR2_dqs_c),
        .C0_DDR4_SLR2_dqs_t(C0_DDR4_SLR2_dqs_t),
        .C0_DDR4_SLR2_odt(C0_DDR4_SLR2_odt),
        .C0_DDR4_SLR2_reset_n(C0_DDR4_SLR2_reset_n),
        .C0_DDR4_SLR3_act_n(C0_DDR4_SLR3_act_n),
        .C0_DDR4_SLR3_adr(C0_DDR4_SLR3_adr),
        .C0_DDR4_SLR3_ba(C0_DDR4_SLR3_ba),
        .C0_DDR4_SLR3_bg(C0_DDR4_SLR3_bg),
        .C0_DDR4_SLR3_ck_c(C0_DDR4_SLR3_ck_c),
        .C0_DDR4_SLR3_ck_t(C0_DDR4_SLR3_ck_t),
        .C0_DDR4_SLR3_cke(C0_DDR4_SLR3_cke),
        .C0_DDR4_SLR3_cs_n(C0_DDR4_SLR3_cs_n),
        .C0_DDR4_SLR3_dm_n(C0_DDR4_SLR3_dm_n),
        .C0_DDR4_SLR3_dq(C0_DDR4_SLR3_dq),
        .C0_DDR4_SLR3_dqs_c(C0_DDR4_SLR3_dqs_c),
        .C0_DDR4_SLR3_dqs_t(C0_DDR4_SLR3_dqs_t),
        .C0_DDR4_SLR3_odt(C0_DDR4_SLR3_odt),
        .C0_DDR4_SLR3_reset_n(C0_DDR4_SLR3_reset_n),
        .C0_SYS_CLK_SLR0_clk_n(C0_SYS_CLK_SLR0_clk_n),
        .C0_SYS_CLK_SLR0_clk_p(C0_SYS_CLK_SLR0_clk_p),
        .C0_SYS_CLK_SLR1_clk_n(C0_SYS_CLK_SLR1_clk_n),
        .C0_SYS_CLK_SLR1_clk_p(C0_SYS_CLK_SLR1_clk_p),
        .C0_SYS_CLK_SLR2_clk_n(C0_SYS_CLK_SLR2_clk_n),
        .C0_SYS_CLK_SLR2_clk_p(C0_SYS_CLK_SLR2_clk_p),
        .C0_SYS_CLK_SLR3_clk_n(C0_SYS_CLK_SLR3_clk_n),
        .C0_SYS_CLK_SLR3_clk_p(C0_SYS_CLK_SLR3_clk_p),
        .clk_in1_0(clk_in1_0),
        .clock_qdma_slr1_clk_n(clock_qdma_slr1_clk_n),
        .clock_qdma_slr1_clk_p(clock_qdma_slr1_clk_p),
        .clock_qdma_slr2_clk_n(clock_qdma_slr2_clk_n),
        .clock_qdma_slr2_clk_p(clock_qdma_slr2_clk_p),
        .ext_reset_in_0(ext_reset_in_0),
        .pcie_7x_mgt_rtl_SLR1_rxn(pcie_7x_mgt_rtl_SLR1_rxn),
        .pcie_7x_mgt_rtl_SLR1_rxp(pcie_7x_mgt_rtl_SLR1_rxp),
        .pcie_7x_mgt_rtl_SLR1_txn(pcie_7x_mgt_rtl_SLR1_txn),
        .pcie_7x_mgt_rtl_SLR1_txp(pcie_7x_mgt_rtl_SLR1_txp),
        .pcie_7x_mgt_rtl_SLR2_rxn(pcie_7x_mgt_rtl_SLR2_rxn),
        .pcie_7x_mgt_rtl_SLR2_rxp(pcie_7x_mgt_rtl_SLR2_rxp),
        .pcie_7x_mgt_rtl_SLR2_txn(pcie_7x_mgt_rtl_SLR2_txn),
        .pcie_7x_mgt_rtl_SLR2_txp(pcie_7x_mgt_rtl_SLR2_txp));
endmodule
