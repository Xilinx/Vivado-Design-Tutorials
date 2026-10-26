//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 11:48:30 AM
// Design Name: 
// Module Name: pl_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pl_slave_from_cips #(
   parameter S0_AXI_AWADDR_WIDTH = 48,
   parameter S0_AXI_AWLEN_WIDTH = 8,
   parameter S0_AXI_AWSIZE_WIDTH = 3,
   parameter S0_AXI_AWBURST_WIDTH = 2,
   parameter S0_AXI_AWCACHE_WIDTH = 4,
   parameter S0_AXI_AWPROT_WIDTH = 3,
   parameter S0_AXI_AWREGION_WIDTH = 4,
   parameter S0_AXI_AWQOS_WIDTH = 4,
   parameter S0_AXI_WDATA_WIDTH = 512,
   parameter S0_AXI_WSTRB_WIDTH = 64,
   parameter S0_AXI_BRESP_WIDTH = 2,
   parameter S0_AXI_ARADDR_WIDTH = 48,
   parameter S0_AXI_ARLEN_WIDTH = 8,
   parameter S0_AXI_ARSIZE_WIDTH = 3,
   parameter S0_AXI_ARBURST_WIDTH = 2,
   parameter S0_AXI_ARCACHE_WIDTH = 4,
   parameter S0_AXI_ARPROT_WIDTH = 3,
   parameter S0_AXI_ARREGION_WIDTH = 4,
   parameter S0_AXI_ARQOS_WIDTH = 4,
   parameter S0_AXI_RDATA_WIDTH = 512,
   parameter S0_AXI_RRESP_WIDTH = 2,
   parameter S0_AXI_ARID_WIDTH = 2,
   parameter S0_AXI_AWID_WIDTH = 2,
   parameter S0_AXI_BID_WIDTH = 2,
   parameter S0_AXI_RID_WIDTH = 2  
)(
    input clk,
    input rstn
    );

  wire [S0_AXI_AWADDR_WIDTH-1 : 0] s_axi_awaddr;
  wire [S0_AXI_AWLEN_WIDTH-1 : 0] s_axi_awlen;
  wire [S0_AXI_AWSIZE_WIDTH-1 : 0] s_axi_awsize;
  wire [S0_AXI_AWBURST_WIDTH-1 : 0] s_axi_awburst;
  wire s_axi_awlock;
  wire [S0_AXI_AWCACHE_WIDTH-1 : 0] s_axi_awcache;
  wire [S0_AXI_AWPROT_WIDTH-1 : 0] s_axi_awprot;
  wire s_axi_awvalid;
  wire s_axi_awready;
  wire [S0_AXI_WDATA_WIDTH-1 : 0] s_axi_wdata;
  wire [S0_AXI_WSTRB_WIDTH-1 : 0] s_axi_wstrb;
  wire s_axi_wlast;
  wire s_axi_wvalid;
  wire s_axi_wready;
  wire [S0_AXI_BRESP_WIDTH-1 : 0] s_axi_bresp;
  wire s_axi_bvalid;
  wire s_axi_bready;
  wire [S0_AXI_ARADDR_WIDTH-1 : 0] s_axi_araddr;
  wire [S0_AXI_ARLEN_WIDTH-1 : 0] s_axi_arlen;
  wire [S0_AXI_ARSIZE_WIDTH-1 : 0] s_axi_arsize;
  wire [S0_AXI_ARBURST_WIDTH-1 : 0] s_axi_arburst;
  wire s_axi_arlock;
  wire [S0_AXI_ARCACHE_WIDTH-1 : 0] s_axi_arcache;
  wire [S0_AXI_ARPROT_WIDTH-1 : 0] s_axi_arprot;
  wire s_axi_arvalid;
  wire s_axi_arready;
  wire [S0_AXI_RDATA_WIDTH-1 : 0] s_axi_rdata;
  wire [S0_AXI_RRESP_WIDTH-1 : 0] s_axi_rresp;
  wire s_axi_rlast;
  wire s_axi_rvalid;
  wire s_axi_rready;
  wire [S0_AXI_AWID_WIDTH-1:0 ] s_axi_awid;
  wire [S0_AXI_BID_WIDTH-1:0 ] s_axi_bid;
  wire [S0_AXI_ARID_WIDTH-1:0 ] s_axi_arid;
  wire [S0_AXI_RID_WIDTH-1:0 ] s_axi_rid;



axi_bram_ctrl_pl_slave_from_ps axi_bram_ctrl_pl_slave_from_cips_inst (
  .s_axi_aclk(clk),        // input wire s_axi_aclk
  .s_axi_aresetn(rstn),  // input wire s_axi_aresetn
  .s_axi_awid(s_axi_awid),        // input wire [1 : 0] s_axi_awid
  .s_axi_awaddr(s_axi_awaddr),    // input wire [15 : 0] s_axi_awaddr
  .s_axi_awlen(s_axi_awlen),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(s_axi_awsize),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(s_axi_awburst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awlock(s_axi_awlock),    // input wire s_axi_awlock
  .s_axi_awcache(s_axi_awcache),  // input wire [3 : 0] s_axi_awcache
  .s_axi_awprot(s_axi_awprot),    // input wire [2 : 0] s_axi_awprot
  .s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),  // output wire s_axi_awready
  .s_axi_wdata(s_axi_wdata),      // input wire [511 : 0] s_axi_wdata
  .s_axi_wstrb(s_axi_wstrb),      // input wire [63 : 0] s_axi_wstrb
  .s_axi_wlast(s_axi_wlast),      // input wire s_axi_wlast
  .s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),    // output wire s_axi_wready
  .s_axi_bid(s_axi_bid),          // output wire [1 : 0] s_axi_bid
  .s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),    // input wire s_axi_bready
  .s_axi_arid(s_axi_arid),        // input wire [1 : 0] s_axi_arid
  .s_axi_araddr(s_axi_araddr),    // input wire [15 : 0] s_axi_araddr
  .s_axi_arlen(s_axi_arlen),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(s_axi_arsize),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(s_axi_arburst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arlock(s_axi_arlock),    // input wire s_axi_arlock
  .s_axi_arcache(s_axi_arcache),  // input wire [3 : 0] s_axi_arcache
  .s_axi_arprot(s_axi_arprot),    // input wire [2 : 0] s_axi_arprot
  .s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready(s_axi_arready),  // output wire s_axi_arready
  .s_axi_rid(s_axi_rid),          // output wire [1 : 0] s_axi_rid
  .s_axi_rdata(s_axi_rdata),      // output wire [511 : 0] s_axi_rdata
  .s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(s_axi_rlast),      // output wire s_axi_rlast
  .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready)    // input wire s_axi_rready
);


xpm_nsu_mm #(
  .NOC_FABRIC("VNOC"),  // VNOC/BLI
  .DATA_WIDTH(S0_AXI_WDATA_WIDTH),     // 32/64/128/256/512
  .ADDR_WIDTH(S0_AXI_AWADDR_WIDTH),      // 12 to 64
  .ID_WIDTH(2),       // always 2
  .AUSER_WIDTH(16),      // 16 for VNOC with parity disabled, 18 for VNOC with parity enabled
  .DUSER_WIDTH(0),       // 2*DATA_WIDTH/8 for parity enablement with VNOC, 0 for VNOC with parity disabled cases
  .ENABLE_USR_INTERRUPT("false"), // false/true
  .SIDEBAND_PINS("false")  // false/true/addr/data
) xpm_nsu_mm_pl_slave_from_cips (
    .m_axi_aclk(clk),
    .m_axi_awid(s_axi_awid),
    .m_axi_awaddr(s_axi_awaddr),
    .m_axi_awlen(s_axi_awlen),
    .m_axi_awsize(s_axi_awsize),
    .m_axi_awburst(s_axi_awburst),
    .m_axi_awlock(s_axi_awlock),
    .m_axi_awcache(s_axi_awcache),
    .m_axi_awprot(s_axi_awprot),
    .m_axi_awregion(s_axi_awregion),
    .m_axi_awqos(s_axi_awqos),
    .m_axi_awuser(s_axi_awuser),
    .m_axi_awvalid(s_axi_awvalid),
    .m_axi_awready(s_axi_awready),
    .m_axi_wdata(s_axi_wdata),
    .m_axi_wstrb(s_axi_wstrb),
    .m_axi_wlast(s_axi_wlast),
    .m_axi_wuser(s_axi_wuser),
    .m_axi_wvalid(s_axi_wvalid),
    .m_axi_wready(s_axi_wready),
    .m_axi_bid(s_axi_bid),
    .m_axi_bresp(s_axi_bresp),
    .m_axi_buser(s_axi_user), //supports only 16-bits transferred from NSU to NMU
    .m_axi_bvalid(s_axi_bvalid),
    .m_axi_bready(s_axi_bready),
    .m_axi_arid(s_axi_arid),
    .m_axi_araddr(s_axi_araddr),
    .m_axi_arlen(s_axi_arlen),
    .m_axi_arsize(s_axi_arsize),
    .m_axi_arburst(s_axi_arburst),
    .m_axi_arlock(s_axi_arlock),
    .m_axi_arcache(s_axi_arcache),
    .m_axi_arprot(s_axi_arprot),
    .m_axi_arregion(s_axi_arregion),
    .m_axi_arqos(s_axi_arqos),
    .m_axi_aruser(s_axi_aruser),
    .m_axi_arvalid(s_axi_arvalid),
    .m_axi_arready(s_axi_arready),
    .m_axi_rid(s_axi_rid),
    .m_axi_rdata(s_axi_rdata),
    .m_axi_rresp(s_axi_rresp),
    .m_axi_rlast(s_axi_rlast),
    .m_axi_ruser(s_axi_ruser),
    .m_axi_rvalid(s_axi_rvalid),
    .m_axi_rready(s_axi_rready),
    .m_axi_out(),
    .nsu_usr_interrupt_in(4'b0)
    );

endmodule
