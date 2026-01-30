//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//


module RP1 
      (
      input wire clk,
      input wire rstb,
      input wire dbg_hub_rstb,
      output [15:0] error
      );

  wire [63 : 0] s_axi_awaddr;
  wire [7: 0] s_axi_awlen;
  wire [2 : 0] s_axi_awsize;
  wire [1 : 0] s_axi_awburst;
  wire s_axi_awlock;
  wire [3: 0] s_axi_awcache;
  wire [2: 0] s_axi_awprot;
  wire s_axi_awvalid;
  wire s_axi_awready;
  wire [127 : 0] s_axi_wdata;
  wire [15 : 0] s_axi_wstrb;
  wire s_axi_wlast;
  wire s_axi_wvalid;
  wire s_axi_wready;
  wire [1: 0] s_axi_bresp;
  wire s_axi_bvalid;
  wire s_axi_bready;
  wire [63: 0] s_axi_araddr;
  wire [7: 0] s_axi_arlen;
  wire [2: 0] s_axi_arsize;
  wire [1: 0] s_axi_arburst;
  wire s_axi_arlock;
  wire [3: 0] s_axi_arcache;
  wire [2: 0] s_axi_arprot;
  wire s_axi_arvalid;
  wire s_axi_arready;
  wire [127: 0] s_axi_rdata;
  wire [1: 0] s_axi_rresp;
  wire s_axi_rlast;
  wire s_axi_rvalid;
  wire s_axi_rready;
  wire [1:0 ] s_axi_awid;
  wire [1:0 ] s_axi_bid;
  wire [1:0 ] s_axi_arid;
  wire [1:0 ] s_axi_rid;


   pl_master_to_ddr_low0 pl_master_to_ddr_low0_inst
      (
      .clk(clk),
      .rstn (dbg_hub_rstb));
   pl_master_to_ddr_low1 pl_master_to_ddr_low1_inst
      (
      .clk(clk),
      .rstn (dbg_hub_rstb));
      
   pl_master2_to_ddr_low1 pl_master2_to_ddr_low1_inst
      (
      .clk(clk),
      .rstn (dbg_hub_rstb));

  axi_dbg_hub_0  axi_dbg_hub_0_inst (
   .aclk(clk),                       // input wire aclk
   .aresetn(dbg_hub_rstb),                   // input wire aresetn
   .s_axi_awid(s_axi_awid),          // input wire [1 : 0] s_axi_awid
   .s_axi_awaddr(s_axi_awaddr),      // input wire [63 : 0] s_axi_awaddr
   .s_axi_awlen(s_axi_awlen),        // input wire [7 : 0] s_axi_awlen
   .s_axi_awsize(s_axi_awsize),      // input wire [2 : 0] s_axi_awsize
   .s_axi_awburst(s_axi_awburst),    // input wire [1 : 0] s_axi_awburst
   .s_axi_awlock(s_axi_awlock),      // input wire s_axi_awlock
   .s_axi_awcache(s_axi_awcache),    // input wire [3 : 0] s_axi_awcache
   .s_axi_awprot(s_axi_awprot),      // input wire [2 : 0] s_axi_awprot
   .s_axi_awqos(s_axi_awqos),        // input wire [3 : 0] s_axi_awqos
   .s_axi_awregion(s_axi_awregion),  // input wire [3 : 0] s_axi_awregion
   .s_axi_awvalid(s_axi_awvalid),    // input wire s_axi_awvalid
   .s_axi_awready(s_axi_awready),    // output wire s_axi_awready
   .s_axi_wdata(s_axi_wdata),        // input wire [127 : 0] s_axi_wdata
   .s_axi_wstrb(s_axi_wstrb),        // input wire [15 : 0] s_axi_wstrb
   .s_axi_wlast(s_axi_wlast),        // input wire s_axi_wlast
   .s_axi_wvalid(s_axi_wvalid),      // input wire s_axi_wvalid
   .s_axi_wready(s_axi_wready),      // output wire s_axi_wready
   .s_axi_bid(s_axi_bid),            // output wire [1 : 0] s_axi_bid
   .s_axi_bresp(s_axi_bresp),        // output wire [1 : 0] s_axi_bresp
   .s_axi_bvalid(s_axi_bvalid),      // output wire s_axi_bvalid
   .s_axi_bready(s_axi_bready),      // input wire s_axi_bready
   .s_axi_arid(s_axi_arid),          // input wire [1 : 0] s_axi_arid
   .s_axi_araddr(s_axi_araddr),      // input wire [63 : 0] s_axi_araddr
   .s_axi_arlen(s_axi_arlen),        // input wire [7 : 0] s_axi_arlen
   .s_axi_arsize(s_axi_arsize),      // input wire [2 : 0] s_axi_arsize
   .s_axi_arburst(s_axi_arburst),    // input wire [1 : 0] s_axi_arburst
   .s_axi_arlock(s_axi_arlock),      // input wire s_axi_arlock
   .s_axi_arcache(s_axi_arcache),    // input wire [3 : 0] s_axi_arcache
   .s_axi_arprot(s_axi_arprot),      // input wire [2 : 0] s_axi_arprot
   .s_axi_arqos(s_axi_arqos),        // input wire [3 : 0] s_axi_arqos
   .s_axi_arregion(s_axi_arregion),  // input wire [3 : 0] s_axi_arregion
   .s_axi_arvalid(s_axi_arvalid),    // input wire s_axi_arvalid
   .s_axi_arready(s_axi_arready),    // output wire s_axi_arready
   .s_axi_rid(s_axi_rid),            // output wire [1 : 0] s_axi_rid
   .s_axi_rdata(s_axi_rdata),        // output wire [127 : 0] s_axi_rdata
   .s_axi_rresp(s_axi_rresp),        // output wire [1 : 0] s_axi_rresp
   .s_axi_rlast(s_axi_rlast),        // output wire s_axi_rlast
   .s_axi_rvalid(s_axi_rvalid),      // output wire s_axi_rvalid
   .s_axi_rready(s_axi_rready)      // input wire s_axi_rready
 ); 
 xpm_nsu_mm #(
   .NOC_FABRIC("VNOC"),  // VNOC/BLI
   .DATA_WIDTH(128),     // 32/64/128/256/512
   .ADDR_WIDTH(64),      // 12 to 64
   .ID_WIDTH(2),       // always 2
   .AUSER_WIDTH(16),      // 16 for VNOC with parity disabled, 18 for VNOC with parity enabled
   .DUSER_WIDTH(0),       // 2*DATA_WIDTH/8 for parity enablement with VNOC, 0 for VNOC with parity disabled cases
   .ENABLE_USR_INTERRUPT("false"), // false/true
   .SIDEBAND_PINS("false")  // false/true/addr/data
 ) xpm_nsu_mm_debug_hub (
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
