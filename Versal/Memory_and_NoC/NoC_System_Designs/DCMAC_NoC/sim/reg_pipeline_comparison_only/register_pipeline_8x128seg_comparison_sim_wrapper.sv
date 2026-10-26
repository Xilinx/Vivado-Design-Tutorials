//--------------------------------------------------------------------------------------
//
// MIT License
// 
// Copyright (c) 2023 Advanced Micro Devices, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice (including the 
// next paragraph) shall be included in all copies or substantial portions 
// of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Description   : EXDES sim wrapper without NoC references
//                 Only to be used in conjuction with pipeline instead of NoC solution
//                 Copied directly from generated sim wrapper, excludes NoC model
//                 references
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
//Design : dcmac_0_exdes_sim_wrapper
//Purpose: Everest Simulation Wrapper netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module dcmac_0_exdes_sim_wrapper
   (APB_M2_paddr,
    APB_M2_penable,
    APB_M2_prdata,
    APB_M2_pready,
    APB_M2_psel,
    APB_M2_pslverr,
    APB_M2_pwdata,
    APB_M2_pwrite,
    APB_M3_paddr,
    APB_M3_penable,
    APB_M3_prdata,
    APB_M3_pready,
    APB_M3_psel,
    APB_M3_pslverr,
    APB_M3_pwdata,
    APB_M3_pwrite,
    APB_M4_paddr,
    APB_M4_penable,
    APB_M4_prdata,
    APB_M4_pready,
    APB_M4_psel,
    APB_M4_pslverr,
    APB_M4_pwdata,
    APB_M4_pwrite,
    gt0_ref_clk0_n,
    gt0_ref_clk0_p,
    gt0_ref_clk1_n,
    gt0_ref_clk1_p,
    gt0_rxn_in0,
    gt0_rxn_in1,
    gt0_rxp_in0,
    gt0_rxp_in1,
    gt0_txn_out0,
    gt0_txn_out1,
    gt0_txp_out0,
    gt0_txp_out1,
    gt1_ref_clk0_n,
    gt1_ref_clk0_p,
    gt1_ref_clk1_n,
    gt1_ref_clk1_p,
    gt1_rxn_in0,
    gt1_rxn_in1,
    gt1_rxp_in0,
    gt1_rxp_in1,
    gt1_txn_out0,
    gt1_txn_out1,
    gt1_txp_out0,
    gt1_txp_out1,
    gt_gpo0,
    gt_gpo1,
    gt_line_rate,
    gt_loopback,
    gt_reset_all_in,
    gt_reset_done0,
    gt_reset_done1,
    gt_reset_rx_datapath_in0,
    gt_reset_rx_datapath_in1,
    gt_reset_tx_datapath_in0,
    gt_reset_tx_datapath_in1,
    gt_rx_reset_core0,
    gt_rx_reset_core1,
    gt_rx_reset_done_out0,
    gt_rx_reset_done_out1,
    gt_rxcdrhold,
    gt_tx_reset_core0,
    gt_tx_reset_core1,
    gt_tx_reset_done_out0,
    gt_tx_reset_done_out1,
    gt_txmaincursor,
    gt_txpostcursor,
    gt_txprecursor,
    init_clk,
    rx_core_reset,
    rx_serdes_reset,
    s_axi_0_araddr,
    s_axi_0_arready,
    s_axi_0_arvalid,
    s_axi_0_awaddr,
    s_axi_0_awready,
    s_axi_0_awvalid,
    s_axi_0_bready,
    s_axi_0_bresp,
    s_axi_0_bvalid,
    s_axi_0_rdata,
    s_axi_0_rready,
    s_axi_0_rresp,
    s_axi_0_rvalid,
    s_axi_0_wdata,
    s_axi_0_wready,
    s_axi_0_wvalid,
    s_axi_1_araddr,
    s_axi_1_arready,
    s_axi_1_arvalid,
    s_axi_1_awaddr,
    s_axi_1_awready,
    s_axi_1_awvalid,
    s_axi_1_bready,
    s_axi_1_bresp,
    s_axi_1_bvalid,
    s_axi_1_rdata,
    s_axi_1_rready,
    s_axi_1_rresp,
    s_axi_1_rvalid,
    s_axi_1_wdata,
    s_axi_1_wready,
    s_axi_1_wvalid,
    s_axi_aclk,
    s_axi_aresetn,
    tx_core_reset,
    tx_serdes_reset);
  input [31:0]APB_M2_paddr;
  input APB_M2_penable;
  output [31:0]APB_M2_prdata;
  output [0:0]APB_M2_pready;
  input [0:0]APB_M2_psel;
  output [0:0]APB_M2_pslverr;
  input [31:0]APB_M2_pwdata;
  input APB_M2_pwrite;
  input [31:0]APB_M3_paddr;
  input APB_M3_penable;
  output [31:0]APB_M3_prdata;
  output [0:0]APB_M3_pready;
  input [0:0]APB_M3_psel;
  output [0:0]APB_M3_pslverr;
  input [31:0]APB_M3_pwdata;
  input APB_M3_pwrite;
  input [31:0]APB_M4_paddr;
  input APB_M4_penable;
  output [31:0]APB_M4_prdata;
  output [0:0]APB_M4_pready;
  input [0:0]APB_M4_psel;
  output [0:0]APB_M4_pslverr;
  input [31:0]APB_M4_pwdata;
  input APB_M4_pwrite;
  input gt0_ref_clk0_n;
  input gt0_ref_clk0_p;
  input gt0_ref_clk1_n;
  input gt0_ref_clk1_p;
  input [3:0]gt0_rxn_in0;
  input [3:0]gt0_rxn_in1;
  input [3:0]gt0_rxp_in0;
  input [3:0]gt0_rxp_in1;
  output [3:0]gt0_txn_out0;
  output [3:0]gt0_txn_out1;
  output [3:0]gt0_txp_out0;
  output [3:0]gt0_txp_out1;
  input gt1_ref_clk0_n;
  input gt1_ref_clk0_p;
  input gt1_ref_clk1_n;
  input gt1_ref_clk1_p;
  input [3:0]gt1_rxn_in0;
  input [3:0]gt1_rxn_in1;
  input [3:0]gt1_rxp_in0;
  input [3:0]gt1_rxp_in1;
  output [3:0]gt1_txn_out0;
  output [3:0]gt1_txn_out1;
  output [3:0]gt1_txp_out0;
  output [3:0]gt1_txp_out1;
  output [31:0]gt_gpo0;
  output [31:0]gt_gpo1;
  input [7:0]gt_line_rate;
  input [2:0]gt_loopback;
  input gt_reset_all_in;
  output gt_reset_done0;
  output gt_reset_done1;
  input [7:0]gt_reset_rx_datapath_in0;
  input [7:0]gt_reset_rx_datapath_in1;
  input [7:0]gt_reset_tx_datapath_in0;
  input [7:0]gt_reset_tx_datapath_in1;
  output gt_rx_reset_core0;
  output gt_rx_reset_core1;
  output [23:0]gt_rx_reset_done_out0;
  output [23:0]gt_rx_reset_done_out1;
  input gt_rxcdrhold;
  output gt_tx_reset_core0;
  output gt_tx_reset_core1;
  output [23:0]gt_tx_reset_done_out0;
  output [23:0]gt_tx_reset_done_out1;
  input [6:0]gt_txmaincursor;
  input [5:0]gt_txpostcursor;
  input [5:0]gt_txprecursor;
  input init_clk;
  input rx_core_reset;
  input [5:0]rx_serdes_reset;
  input [31:0]s_axi_0_araddr;
  output s_axi_0_arready;
  input s_axi_0_arvalid;
  input [31:0]s_axi_0_awaddr;
  output s_axi_0_awready;
  input s_axi_0_awvalid;
  input s_axi_0_bready;
  output [1:0]s_axi_0_bresp;
  output s_axi_0_bvalid;
  output [31:0]s_axi_0_rdata;
  input s_axi_0_rready;
  output [1:0]s_axi_0_rresp;
  output s_axi_0_rvalid;
  input [31:0]s_axi_0_wdata;
  output s_axi_0_wready;
  input s_axi_0_wvalid;
  input [31:0]s_axi_1_araddr;
  output s_axi_1_arready;
  input s_axi_1_arvalid;
  input [31:0]s_axi_1_awaddr;
  output s_axi_1_awready;
  input s_axi_1_awvalid;
  input s_axi_1_bready;
  output [1:0]s_axi_1_bresp;
  output s_axi_1_bvalid;
  output [31:0]s_axi_1_rdata;
  input s_axi_1_rready;
  output [1:0]s_axi_1_rresp;
  output s_axi_1_rvalid;
  input [31:0]s_axi_1_wdata;
  output s_axi_1_wready;
  input s_axi_1_wvalid;
  input s_axi_aclk;
  input s_axi_aresetn;
  input tx_core_reset;
  input [5:0]tx_serdes_reset;

  wire [31:0]apb_m2_paddr_net;
  wire apb_m2_penable_net;
  wire [31:0]apb_m2_prdata_net;
  wire [0:0]apb_m2_pready_net;
  wire [0:0]apb_m2_psel_net;
  wire [0:0]apb_m2_pslverr_net;
  wire [31:0]apb_m2_pwdata_net;
  wire apb_m2_pwrite_net;
  wire [31:0]apb_m3_paddr_net;
  wire apb_m3_penable_net;
  wire [31:0]apb_m3_prdata_net;
  wire [0:0]apb_m3_pready_net;
  wire [0:0]apb_m3_psel_net;
  wire [0:0]apb_m3_pslverr_net;
  wire [31:0]apb_m3_pwdata_net;
  wire apb_m3_pwrite_net;
  wire [31:0]apb_m4_paddr_net;
  wire apb_m4_penable_net;
  wire [31:0]apb_m4_prdata_net;
  wire [0:0]apb_m4_pready_net;
  wire [0:0]apb_m4_psel_net;
  wire [0:0]apb_m4_pslverr_net;
  wire [31:0]apb_m4_pwdata_net;
  wire apb_m4_pwrite_net;
  wire gt0_ref_clk0_n_net;
  wire gt0_ref_clk0_p_net;
  wire gt0_ref_clk1_n_net;
  wire gt0_ref_clk1_p_net;
  wire [3:0]gt0_rxn_in0_net;
  wire [3:0]gt0_rxn_in1_net;
  wire [3:0]gt0_rxp_in0_net;
  wire [3:0]gt0_rxp_in1_net;
  wire [3:0]gt0_txn_out0_net;
  wire [3:0]gt0_txn_out1_net;
  wire [3:0]gt0_txp_out0_net;
  wire [3:0]gt0_txp_out1_net;
  wire gt1_ref_clk0_n_net;
  wire gt1_ref_clk0_p_net;
  wire gt1_ref_clk1_n_net;
  wire gt1_ref_clk1_p_net;
  wire [3:0]gt1_rxn_in0_net;
  wire [3:0]gt1_rxn_in1_net;
  wire [3:0]gt1_rxp_in0_net;
  wire [3:0]gt1_rxp_in1_net;
  wire [3:0]gt1_txn_out0_net;
  wire [3:0]gt1_txn_out1_net;
  wire [3:0]gt1_txp_out0_net;
  wire [3:0]gt1_txp_out1_net;
  wire [31:0]gt_gpo0_net;
  wire [31:0]gt_gpo1_net;
  wire [7:0]gt_line_rate_net;
  wire [2:0]gt_loopback_net;
  wire gt_reset_all_in_net;
  wire gt_reset_done0_net;
  wire gt_reset_done1_net;
  wire [7:0]gt_reset_rx_datapath_in0_net;
  wire [7:0]gt_reset_rx_datapath_in1_net;
  wire [7:0]gt_reset_tx_datapath_in0_net;
  wire [7:0]gt_reset_tx_datapath_in1_net;
  wire gt_rx_reset_core0_net;
  wire gt_rx_reset_core1_net;
  wire [23:0]gt_rx_reset_done_out0_net;
  wire [23:0]gt_rx_reset_done_out1_net;
  wire gt_rxcdrhold_net;
  wire gt_tx_reset_core0_net;
  wire gt_tx_reset_core1_net;
  wire [23:0]gt_tx_reset_done_out0_net;
  wire [23:0]gt_tx_reset_done_out1_net;
  wire [6:0]gt_txmaincursor_net;
  wire [5:0]gt_txpostcursor_net;
  wire [5:0]gt_txprecursor_net;
  wire init_clk_net;

  wire rx_core_reset_net;
  wire [5:0]rx_serdes_reset_net;
  wire [31:0]s_axi_0_araddr_net;
  wire s_axi_0_arready_net;
  wire s_axi_0_arvalid_net;
  wire [31:0]s_axi_0_awaddr_net;
  wire s_axi_0_awready_net;
  wire s_axi_0_awvalid_net;
  wire s_axi_0_bready_net;
  wire [1:0]s_axi_0_bresp_net;
  wire s_axi_0_bvalid_net;
  wire [31:0]s_axi_0_rdata_net;
  wire s_axi_0_rready_net;
  wire [1:0]s_axi_0_rresp_net;
  wire s_axi_0_rvalid_net;
  wire [31:0]s_axi_0_wdata_net;
  wire s_axi_0_wready_net;
  wire s_axi_0_wvalid_net;
  wire [31:0]s_axi_1_araddr_net;
  wire s_axi_1_arready_net;
  wire s_axi_1_arvalid_net;
  wire [31:0]s_axi_1_awaddr_net;
  wire s_axi_1_awready_net;
  wire s_axi_1_awvalid_net;
  wire s_axi_1_bready_net;
  wire [1:0]s_axi_1_bresp_net;
  wire s_axi_1_bvalid_net;
  wire [31:0]s_axi_1_rdata_net;
  wire s_axi_1_rready_net;
  wire [1:0]s_axi_1_rresp_net;
  wire s_axi_1_rvalid_net;
  wire [31:0]s_axi_1_wdata_net;
  wire s_axi_1_wready_net;
  wire s_axi_1_wvalid_net;
  wire s_axi_aclk_net;
  wire s_axi_aresetn_net;
  wire tx_core_reset_net;
  wire [5:0]tx_serdes_reset_net;

  assign APB_M2_prdata[31:0] = apb_m2_prdata_net;
  assign APB_M2_pready[0] = apb_m2_pready_net;
  assign APB_M2_pslverr[0] = apb_m2_pslverr_net;
  assign APB_M3_prdata[31:0] = apb_m3_prdata_net;
  assign APB_M3_pready[0] = apb_m3_pready_net;
  assign APB_M3_pslverr[0] = apb_m3_pslverr_net;
  assign APB_M4_prdata[31:0] = apb_m4_prdata_net;
  assign APB_M4_pready[0] = apb_m4_pready_net;
  assign APB_M4_pslverr[0] = apb_m4_pslverr_net;
  assign apb_m2_paddr_net = APB_M2_paddr[31:0];
  assign apb_m2_penable_net = APB_M2_penable;
  assign apb_m2_psel_net = APB_M2_psel[0];
  assign apb_m2_pwdata_net = APB_M2_pwdata[31:0];
  assign apb_m2_pwrite_net = APB_M2_pwrite;
  assign apb_m3_paddr_net = APB_M3_paddr[31:0];
  assign apb_m3_penable_net = APB_M3_penable;
  assign apb_m3_psel_net = APB_M3_psel[0];
  assign apb_m3_pwdata_net = APB_M3_pwdata[31:0];
  assign apb_m3_pwrite_net = APB_M3_pwrite;
  assign apb_m4_paddr_net = APB_M4_paddr[31:0];
  assign apb_m4_penable_net = APB_M4_penable;
  assign apb_m4_psel_net = APB_M4_psel[0];
  assign apb_m4_pwdata_net = APB_M4_pwdata[31:0];
  assign apb_m4_pwrite_net = APB_M4_pwrite;
  assign gt0_ref_clk0_n_net = gt0_ref_clk0_n;
  assign gt0_ref_clk0_p_net = gt0_ref_clk0_p;
  assign gt0_ref_clk1_n_net = gt0_ref_clk1_n;
  assign gt0_ref_clk1_p_net = gt0_ref_clk1_p;
  assign gt0_rxn_in0_net = gt0_rxn_in0[3:0];
  assign gt0_rxn_in1_net = gt0_rxn_in1[3:0];
  assign gt0_rxp_in0_net = gt0_rxp_in0[3:0];
  assign gt0_rxp_in1_net = gt0_rxp_in1[3:0];
  assign gt0_txn_out0[3:0] = gt0_txn_out0_net;
  assign gt0_txn_out1[3:0] = gt0_txn_out1_net;
  assign gt0_txp_out0[3:0] = gt0_txp_out0_net;
  assign gt0_txp_out1[3:0] = gt0_txp_out1_net;
  assign gt1_ref_clk0_n_net = gt1_ref_clk0_n;
  assign gt1_ref_clk0_p_net = gt1_ref_clk0_p;
  assign gt1_ref_clk1_n_net = gt1_ref_clk1_n;
  assign gt1_ref_clk1_p_net = gt1_ref_clk1_p;
  assign gt1_rxn_in0_net = gt1_rxn_in0[3:0];
  assign gt1_rxn_in1_net = gt1_rxn_in1[3:0];
  assign gt1_rxp_in0_net = gt1_rxp_in0[3:0];
  assign gt1_rxp_in1_net = gt1_rxp_in1[3:0];
  assign gt1_txn_out0[3:0] = gt1_txn_out0_net;
  assign gt1_txn_out1[3:0] = gt1_txn_out1_net;
  assign gt1_txp_out0[3:0] = gt1_txp_out0_net;
  assign gt1_txp_out1[3:0] = gt1_txp_out1_net;
  assign gt_gpo0[31:0] = gt_gpo0_net;
  assign gt_gpo1[31:0] = gt_gpo1_net;
  assign gt_line_rate_net = gt_line_rate[7:0];
  assign gt_loopback_net = gt_loopback[2:0];
  assign gt_reset_all_in_net = gt_reset_all_in;
  assign gt_reset_done0 = gt_reset_done0_net;
  assign gt_reset_done1 = gt_reset_done1_net;
  assign gt_reset_rx_datapath_in0_net = gt_reset_rx_datapath_in0[7:0];
  assign gt_reset_rx_datapath_in1_net = gt_reset_rx_datapath_in1[7:0];
  assign gt_reset_tx_datapath_in0_net = gt_reset_tx_datapath_in0[7:0];
  assign gt_reset_tx_datapath_in1_net = gt_reset_tx_datapath_in1[7:0];
  assign gt_rx_reset_core0 = gt_rx_reset_core0_net;
  assign gt_rx_reset_core1 = gt_rx_reset_core1_net;
  assign gt_rx_reset_done_out0[23:0] = gt_rx_reset_done_out0_net;
  assign gt_rx_reset_done_out1[23:0] = gt_rx_reset_done_out1_net;
  assign gt_rxcdrhold_net = gt_rxcdrhold;
  assign gt_tx_reset_core0 = gt_tx_reset_core0_net;
  assign gt_tx_reset_core1 = gt_tx_reset_core1_net;
  assign gt_tx_reset_done_out0[23:0] = gt_tx_reset_done_out0_net;
  assign gt_tx_reset_done_out1[23:0] = gt_tx_reset_done_out1_net;
  assign gt_txmaincursor_net = gt_txmaincursor[6:0];
  assign gt_txpostcursor_net = gt_txpostcursor[5:0];
  assign gt_txprecursor_net = gt_txprecursor[5:0];
  assign init_clk_net = init_clk;
  assign rx_core_reset_net = rx_core_reset;
  assign rx_serdes_reset_net = rx_serdes_reset[5:0];
  assign s_axi_0_araddr_net = s_axi_0_araddr[31:0];
  assign s_axi_0_arready = s_axi_0_arready_net;
  assign s_axi_0_arvalid_net = s_axi_0_arvalid;
  assign s_axi_0_awaddr_net = s_axi_0_awaddr[31:0];
  assign s_axi_0_awready = s_axi_0_awready_net;
  assign s_axi_0_awvalid_net = s_axi_0_awvalid;
  assign s_axi_0_bready_net = s_axi_0_bready;
  assign s_axi_0_bresp[1:0] = s_axi_0_bresp_net;
  assign s_axi_0_bvalid = s_axi_0_bvalid_net;
  assign s_axi_0_rdata[31:0] = s_axi_0_rdata_net;
  assign s_axi_0_rready_net = s_axi_0_rready;
  assign s_axi_0_rresp[1:0] = s_axi_0_rresp_net;
  assign s_axi_0_rvalid = s_axi_0_rvalid_net;
  assign s_axi_0_wdata_net = s_axi_0_wdata[31:0];
  assign s_axi_0_wready = s_axi_0_wready_net;
  assign s_axi_0_wvalid_net = s_axi_0_wvalid;
  assign s_axi_1_araddr_net = s_axi_1_araddr[31:0];
  assign s_axi_1_arready = s_axi_1_arready_net;
  assign s_axi_1_arvalid_net = s_axi_1_arvalid;
  assign s_axi_1_awaddr_net = s_axi_1_awaddr[31:0];
  assign s_axi_1_awready = s_axi_1_awready_net;
  assign s_axi_1_awvalid_net = s_axi_1_awvalid;
  assign s_axi_1_bready_net = s_axi_1_bready;
  assign s_axi_1_bresp[1:0] = s_axi_1_bresp_net;
  assign s_axi_1_bvalid = s_axi_1_bvalid_net;
  assign s_axi_1_rdata[31:0] = s_axi_1_rdata_net;
  assign s_axi_1_rready_net = s_axi_1_rready;
  assign s_axi_1_rresp[1:0] = s_axi_1_rresp_net;
  assign s_axi_1_rvalid = s_axi_1_rvalid_net;
  assign s_axi_1_wdata_net = s_axi_1_wdata[31:0];
  assign s_axi_1_wready = s_axi_1_wready_net;
  assign s_axi_1_wvalid_net = s_axi_1_wvalid;
  assign s_axi_aclk_net = s_axi_aclk;
  assign s_axi_aresetn_net = s_axi_aresetn;
  assign tx_core_reset_net = tx_core_reset;
  assign tx_serdes_reset_net = tx_serdes_reset[5:0];
  dcmac_0_exdes dcmac_0_exdes_i
       (.APB_M2_paddr(apb_m2_paddr_net),
        .APB_M2_penable(apb_m2_penable_net),
        .APB_M2_prdata(apb_m2_prdata_net),
        .APB_M2_pready(apb_m2_pready_net),
        .APB_M2_psel(apb_m2_psel_net),
        .APB_M2_pslverr(apb_m2_pslverr_net),
        .APB_M2_pwdata(apb_m2_pwdata_net),
        .APB_M2_pwrite(apb_m2_pwrite_net),
        .APB_M3_paddr(apb_m3_paddr_net),
        .APB_M3_penable(apb_m3_penable_net),
        .APB_M3_prdata(apb_m3_prdata_net),
        .APB_M3_pready(apb_m3_pready_net),
        .APB_M3_psel(apb_m3_psel_net),
        .APB_M3_pslverr(apb_m3_pslverr_net),
        .APB_M3_pwdata(apb_m3_pwdata_net),
        .APB_M3_pwrite(apb_m3_pwrite_net),
        .APB_M4_paddr(apb_m4_paddr_net),
        .APB_M4_penable(apb_m4_penable_net),
        .APB_M4_prdata(apb_m4_prdata_net),
        .APB_M4_pready(apb_m4_pready_net),
        .APB_M4_psel(apb_m4_psel_net),
        .APB_M4_pslverr(apb_m4_pslverr_net),
        .APB_M4_pwdata(apb_m4_pwdata_net),
        .APB_M4_pwrite(apb_m4_pwrite_net),
        .gt0_ref_clk0_n(gt0_ref_clk0_n_net),
        .gt0_ref_clk0_p(gt0_ref_clk0_p_net),
        .gt0_ref_clk1_n(gt0_ref_clk1_n_net),
        .gt0_ref_clk1_p(gt0_ref_clk1_p_net),
        .gt0_rxn_in0(gt0_rxn_in0_net),
        .gt0_rxn_in1(gt0_rxn_in1_net),
        .gt0_rxp_in0(gt0_rxp_in0_net),
        .gt0_rxp_in1(gt0_rxp_in1_net),
        .gt0_txn_out0(gt0_txn_out0_net),
        .gt0_txn_out1(gt0_txn_out1_net),
        .gt0_txp_out0(gt0_txp_out0_net),
        .gt0_txp_out1(gt0_txp_out1_net),
        .gt1_ref_clk0_n(gt1_ref_clk0_n_net),
        .gt1_ref_clk0_p(gt1_ref_clk0_p_net),
        .gt1_ref_clk1_n(gt1_ref_clk1_n_net),
        .gt1_ref_clk1_p(gt1_ref_clk1_p_net),
        .gt1_rxn_in0(gt1_rxn_in0_net),
        .gt1_rxn_in1(gt1_rxn_in1_net),
        .gt1_rxp_in0(gt1_rxp_in0_net),
        .gt1_rxp_in1(gt1_rxp_in1_net),
        .gt1_txn_out0(gt1_txn_out0_net),
        .gt1_txn_out1(gt1_txn_out1_net),
        .gt1_txp_out0(gt1_txp_out0_net),
        .gt1_txp_out1(gt1_txp_out1_net),
        .gt_gpo0(gt_gpo0_net),
        .gt_gpo1(gt_gpo1_net),
        .gt_line_rate(gt_line_rate_net),
        .gt_loopback(gt_loopback_net),
        .gt_reset_all_in(gt_reset_all_in_net),
        .gt_reset_done0(gt_reset_done0_net),
        .gt_reset_done1(gt_reset_done1_net),
        .gt_reset_rx_datapath_in0(gt_reset_rx_datapath_in0_net),
        .gt_reset_rx_datapath_in1(gt_reset_rx_datapath_in1_net),
        .gt_reset_tx_datapath_in0(gt_reset_tx_datapath_in0_net),
        .gt_reset_tx_datapath_in1(gt_reset_tx_datapath_in1_net),
        .gt_rx_reset_core0(gt_rx_reset_core0_net),
        .gt_rx_reset_core1(gt_rx_reset_core1_net),
        .gt_rx_reset_done_out0(gt_rx_reset_done_out0_net),
        .gt_rx_reset_done_out1(gt_rx_reset_done_out1_net),
        .gt_rxcdrhold(gt_rxcdrhold_net),
        .gt_tx_reset_core0(gt_tx_reset_core0_net),
        .gt_tx_reset_core1(gt_tx_reset_core1_net),
        .gt_tx_reset_done_out0(gt_tx_reset_done_out0_net),
        .gt_tx_reset_done_out1(gt_tx_reset_done_out1_net),
        .gt_txmaincursor(gt_txmaincursor_net),
        .gt_txpostcursor(gt_txpostcursor_net),
        .gt_txprecursor(gt_txprecursor_net),
        .init_clk(init_clk_net),
        .rx_core_reset(rx_core_reset_net),
        .rx_serdes_reset(rx_serdes_reset_net),
        .s_axi_0_araddr(s_axi_0_araddr_net),
        .s_axi_0_arready(s_axi_0_arready_net),
        .s_axi_0_arvalid(s_axi_0_arvalid_net),
        .s_axi_0_awaddr(s_axi_0_awaddr_net),
        .s_axi_0_awready(s_axi_0_awready_net),
        .s_axi_0_awvalid(s_axi_0_awvalid_net),
        .s_axi_0_bready(s_axi_0_bready_net),
        .s_axi_0_bresp(s_axi_0_bresp_net),
        .s_axi_0_bvalid(s_axi_0_bvalid_net),
        .s_axi_0_rdata(s_axi_0_rdata_net),
        .s_axi_0_rready(s_axi_0_rready_net),
        .s_axi_0_rresp(s_axi_0_rresp_net),
        .s_axi_0_rvalid(s_axi_0_rvalid_net),
        .s_axi_0_wdata(s_axi_0_wdata_net),
        .s_axi_0_wready(s_axi_0_wready_net),
        .s_axi_0_wvalid(s_axi_0_wvalid_net),
        .s_axi_1_araddr(s_axi_1_araddr_net),
        .s_axi_1_arready(s_axi_1_arready_net),
        .s_axi_1_arvalid(s_axi_1_arvalid_net),
        .s_axi_1_awaddr(s_axi_1_awaddr_net),
        .s_axi_1_awready(s_axi_1_awready_net),
        .s_axi_1_awvalid(s_axi_1_awvalid_net),
        .s_axi_1_bready(s_axi_1_bready_net),
        .s_axi_1_bresp(s_axi_1_bresp_net),
        .s_axi_1_bvalid(s_axi_1_bvalid_net),
        .s_axi_1_rdata(s_axi_1_rdata_net),
        .s_axi_1_rready(s_axi_1_rready_net),
        .s_axi_1_rresp(s_axi_1_rresp_net),
        .s_axi_1_rvalid(s_axi_1_rvalid_net),
        .s_axi_1_wdata(s_axi_1_wdata_net),
        .s_axi_1_wready(s_axi_1_wready_net),
        .s_axi_1_wvalid(s_axi_1_wvalid_net),
        .s_axi_aclk(s_axi_aclk_net),
        .s_axi_aresetn(s_axi_aresetn_net),
        .tx_core_reset(tx_core_reset_net),
        .tx_serdes_reset(tx_serdes_reset_net));


endmodule
