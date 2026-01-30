//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 03:24:23 PM
// Design Name: 
// Module Name: pl_master
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


module pl_master_to_ddr #(
   parameter M0_AXI_AWADDR_WIDTH = 48,
   parameter M0_AXI_AWLEN_WIDTH = 8,
   parameter M0_AXI_AWSIZE_WIDTH = 3,
   parameter M0_AXI_AWBURST_WIDTH = 2,
   parameter M0_AXI_AWCACHE_WIDTH = 4,
   parameter M0_AXI_AWPROT_WIDTH = 3,
   parameter M0_AXI_AWREGION_WIDTH = 4,
   parameter M0_AXI_AWQOS_WIDTH = 4,
   parameter M0_AXI_WDATA_WIDTH = 512,
   parameter M0_AXI_WSTRB_WIDTH = 64,
   parameter M0_AXI_BRESP_WIDTH = 2,
   parameter M0_AXI_ARADDR_WIDTH = 48,
   parameter M0_AXI_ARLEN_WIDTH = 8,
   parameter M0_AXI_ARSIZE_WIDTH = 3,
   parameter M0_AXI_ARBURST_WIDTH = 2,
   parameter M0_AXI_ARCACHE_WIDTH = 4,
   parameter M0_AXI_ARPROT_WIDTH = 3,
   parameter M0_AXI_ARREGION_WIDTH = 4,
   parameter M0_AXI_ARQOS_WIDTH = 4,
   parameter M0_AXI_RDATA_WIDTH = 512,
   parameter M0_AXI_RRESP_WIDTH = 2,
   parameter M0_AXI_ARID_WIDTH = 1,
   parameter M0_AXI_AWID_WIDTH = 1,
   parameter M0_AXI_BID_WIDTH = 1,
   parameter M0_AXI_RID_WIDTH = 1  
)(
    input clk,
    input rstn

    );

  (* MARK_DEBUG = "TRUE" *) wire [M0_AXI_AWADDR_WIDTH-1:0] pl_master_to_ddr_axi_awaddr;
  wire [M0_AXI_AWLEN_WIDTH-1:0] pl_master_to_ddr_axi_awlen;
  wire [M0_AXI_AWSIZE_WIDTH-1:0] pl_master_to_ddr_axi_awsize;
  wire [M0_AXI_AWBURST_WIDTH-1:0] pl_master_to_ddr_axi_awburst;
  wire  pl_master_to_ddr_axi_awlock;
  wire [M0_AXI_AWCACHE_WIDTH-1:0] pl_master_to_ddr_axi_awcache;
  wire [M0_AXI_AWPROT_WIDTH-1:0] pl_master_to_ddr_axi_awprot;
  wire [M0_AXI_AWREGION_WIDTH-1:0] pl_master_to_ddr_axi_awregion;
  wire [M0_AXI_AWQOS_WIDTH-1:0] pl_master_to_ddr_axi_awqos;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_awvalid;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_awready;
  (* MARK_DEBUG = "TRUE" *) wire [M0_AXI_WDATA_WIDTH-1:0] pl_master_to_ddr_axi_wdata;
  wire [M0_AXI_WSTRB_WIDTH-1:0] pl_master_to_ddr_axi_wstrb;
  wire pl_master_to_ddr_axi_wlast;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_wvalid;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_wready;
  (* MARK_DEBUG = "TRUE" *) wire [M0_AXI_BRESP_WIDTH-1:0] pl_master_to_ddr_axi_bresp;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_bvalid;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_bready;
  (* MARK_DEBUG = "TRUE" *) wire [M0_AXI_ARADDR_WIDTH-1:0] pl_master_to_ddr_axi_araddr;
  wire [M0_AXI_ARLEN_WIDTH-1:0] pl_master_to_ddr_axi_arlen;
  wire [M0_AXI_ARSIZE_WIDTH-1:0] pl_master_to_ddr_axi_arsize;
  wire [M0_AXI_ARBURST_WIDTH-1:0] pl_master_to_ddr_axi_arburst;
  wire pl_master_to_ddr_axi_arlock;
  wire [M0_AXI_ARCACHE_WIDTH-1:0] pl_master_to_ddr_axi_arcache;
  wire [M0_AXI_ARPROT_WIDTH-1:0] pl_master_to_ddr_axi_arprot;
  wire [M0_AXI_ARREGION_WIDTH-1:0] pl_master_to_ddr_axi_arregion;
  wire [M0_AXI_ARQOS_WIDTH-1:0] pl_master_to_ddr_axi_arqos;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_arvalid;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_arready;
  (* MARK_DEBUG = "TRUE" *) wire [M0_AXI_RDATA_WIDTH-1:0] pl_master_to_ddr_axi_rdata;
  (* MARK_DEBUG = "TRUE" *) wire [M0_AXI_RRESP_WIDTH-1:0] pl_master_to_ddr_axi_rresp;
  wire pl_master_to_ddr_axi_rlast;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_rvalid;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_rready;
  wire [M0_AXI_ARID_WIDTH-1:0] pl_master_to_ddr_axi_arid;
  wire [M0_AXI_AWID_WIDTH-1:0] pl_master_to_ddr_axi_awid;
  wire [M0_AXI_BID_WIDTH-1:0] pl_master_to_ddr_axi_bid;
  wire [M0_AXI_RID_WIDTH-1:0] pl_master_to_ddr_axi_rid;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_tg_start;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_tg_done;
  (* MARK_DEBUG = "TRUE" *) wire pl_master_to_ddr_axi_tg_error;
  wire pl_master_to_ddr_axi_tg_rstn;
//initial 
//    begin
//    #1000; 
//    force design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.pl0_resetn = 1;
//    end

  perf_axi_tg_pl_master_to_ddr perf_axi_tg_pl_master_to_ddr_inst (
  .clk(clk),                    // input wire clk
  .tg_rst_n(pl_master_to_ddr_axi_tg_rstn),          // input wire tg_rst_n
  .axi_awid(axi_awid),          // output wire [0 : 0] axi_awid
  .axi_awaddr(pl_master_to_ddr_axi_awaddr),      // output wire [47 : 0] axi_awaddr
  .axi_awlen(pl_master_to_ddr_axi_awlen),        // output wire [7 : 0] axi_awlen
  .axi_awsize(pl_master_to_ddr_axi_awsize),      // output wire [2 : 0] axi_awsize
  .axi_awburst(pl_master_to_ddr_axi_awburst),    // output wire [1 : 0] axi_awburst
  .axi_awlock(pl_master_to_ddr_axi_awlock),      // output wire [0 : 0] axi_awlock
  .axi_awcache(pl_master_to_ddr_axi_awcache),    // output wire [3 : 0] axi_awcache
  .axi_awprot(pl_master_to_ddr_axi_awprot),      // output wire [2 : 0] axi_awprot
  .axi_awregion(pl_master_to_ddr_axi_awregion),  // output wire [3 : 0] axi_awregion
  .axi_awqos(pl_master_to_ddr_axi_awqos),        // output wire [3 : 0] axi_awqos
  .axi_awuser(pl_master_to_ddr_axi_awuser),      // output wire [15 : 0] axi_awuser
  .axi_awvalid(pl_master_to_ddr_axi_awvalid),    // output wire axi_awvalid
  .axi_awready(pl_master_to_ddr_axi_awready),    // input wire axi_awready
  .axi_wdata(pl_master_to_ddr_axi_wdata),        // output wire [511 : 0] axi_wdata
  .axi_wstrb(pl_master_to_ddr_axi_wstrb),        // output wire [63 : 0] axi_wstrb
  .axi_wlast(pl_master_to_ddr_axi_wlast),        // output wire axi_wlast
  .axi_wuser(pl_master_to_ddr_axi_wuser),        // output wire [15 : 0] axi_wuser
  .axi_wvalid(pl_master_to_ddr_axi_wvalid),      // output wire axi_wvalid
  .axi_wready(pl_master_to_ddr_axi_wready),      // input wire axi_wready
  .axi_bid(pl_master_to_ddr_axi_bid),            // input wire [0 : 0] axi_bid
  .axi_bresp(pl_master_to_ddr_axi_bresp),        // input wire [1 : 0] axi_bresp
  .axi_buser(pl_master_to_ddr_axi_buser),        // input wire [15 : 0] axi_buser
  .axi_bvalid(pl_master_to_ddr_axi_bvalid),      // input wire axi_bvalid
  .axi_bready(pl_master_to_ddr_axi_bready),      // output wire axi_bready
  .axi_arid(pl_master_to_ddr_axi_arid),          // output wire [0 : 0] axi_arid
  .axi_araddr(pl_master_to_ddr_axi_araddr),      // output wire [47 : 0] axi_araddr
  .axi_arlen(pl_master_to_ddr_axi_arlen),        // output wire [7 : 0] axi_arlen
  .axi_arsize(pl_master_to_ddr_axi_arsize),      // output wire [2 : 0] axi_arsize
  .axi_arburst(pl_master_to_ddr_axi_arburst),    // output wire [1 : 0] axi_arburst
  .axi_arlock(pl_master_to_ddr_axi_arlock),      // output wire [0 : 0] axi_arlock
  .axi_arcache(pl_master_to_ddr_axi_arcache),    // output wire [3 : 0] axi_arcache
  .axi_arprot(pl_master_to_ddr_axi_arprot),      // output wire [2 : 0] axi_arprot
  .axi_arregion(pl_master_to_ddr_axi_arregion),  // output wire [3 : 0] axi_arregion
  .axi_arqos(pl_master_to_ddr_axi_arqos),        // output wire [3 : 0] axi_arqos
  .axi_aruser(pl_master_to_ddr_axi_aruser),      // output wire [15 : 0] axi_aruser
  .axi_arvalid(pl_master_to_ddr_axi_arvalid),    // output wire axi_arvalid
  .axi_arready(pl_master_to_ddr_axi_arready),    // input wire axi_arready
  .axi_rid(pl_master_to_ddr_axi_rid),            // input wire [0 : 0] axi_rid
  .axi_rdata(pl_master_to_ddr_axi_rdata),        // input wire [511 : 0] axi_rdata
  .axi_rresp(pl_master_to_ddr_axi_rresp),        // input wire [1 : 0] axi_rresp
  .axi_rlast(pl_master_to_ddr_axi_rlast),        // input wire axi_rlast
  .axi_ruser(pl_master_to_ddr_axi_ruser),        // input wire [15 : 0] axi_ruser
  .axi_rvalid(pl_master_to_ddr_axi_rvalid),      // input wire axi_rvalid
  .axi_rready(pl_master_to_ddr_axi_rready),      // output wire axi_rready
  .axi_tg_start(pl_master_to_ddr_axi_tg_start),  // input wire axi_tg_start
  .axi_tg_done(pl_master_to_ddr_axi_tg_done),    // output wire axi_tg_done
  .axi_tg_error(pl_master_to_ddr_axi_tg_error)  // output wire axi_tg_error
);

    xpm_nmu_mm # (
   .NOC_FABRIC("VNOC"),       // VNOC/BLI
   .DATA_WIDTH(M0_AXI_WDATA_WIDTH),           // 32/64/128/256/512
   .ADDR_WIDTH(M0_AXI_AWADDR_WIDTH),            // 12 to 64
   .ID_WIDTH(16),              // 0 to 16
   .AUSER_WIDTH(16),           // 16 for VNOC with parity disabled, 18 for VNOC with parity enabled 
   .DUSER_WIDTH(0),            // 2*DATA_WIDTH/8 for parity enablement with VNOC, 0 for VNOC with parity disabled cases
   .ENABLE_USR_INTERRUPT("false"),       // false/true
   .SIDEBAND_PINS("false")       // false/true/addr/data
    ) xpm_nmu_pl_master_to_ddr(
  .s_axi_aclk(clk),
  .s_axi_awid(pl_master_to_ddr_axi_awid),
  .s_axi_awaddr(pl_master_to_ddr_axi_awaddr),
  .s_axi_awlen(pl_master_to_ddr_axi_awlen),
  .s_axi_awsize(pl_master_to_ddr_axi_awsize),
  .s_axi_awburst(pl_master_to_ddr_axi_awburst),
  .s_axi_awlock(pl_master_to_ddr_axi_awlock),
  .s_axi_awcache(pl_master_to_ddr_axi_awcache),
  .s_axi_awprot(pl_master_to_ddr_axi_awprot),
  .s_axi_awregion(pl_master_to_ddr_axi_awregion),
  .s_axi_awqos(pl_master_to_ddr_axi_awqos),
  .s_axi_awuser(pl_master_to_ddr_axi_awuser),
  .s_axi_awvalid(pl_master_to_ddr_axi_awvalid),
  .s_axi_awready(pl_master_to_ddr_axi_awready),

  .s_axi_wid(),
  .s_axi_wdata(pl_master_to_ddr_axi_wdata),
  .s_axi_wstrb(pl_master_to_ddr_axi_wstrb),
  .s_axi_wlast(pl_master_to_ddr_axi_wlast),
  .s_axi_wuser(16'b0),
  .s_axi_wvalid(pl_master_to_ddr_axi_wvalid),
  .s_axi_wready(pl_master_to_ddr_axi_wready),

  .s_axi_bid(pl_master_to_ddr_axi_bid),
  .s_axi_bresp(pl_master_to_ddr_axi_bresp),
  .s_axi_buser(),
  .s_axi_bvalid(pl_master_to_ddr_axi_bvalid),
  .s_axi_bready(pl_master_to_ddr_axi_bready),

  .s_axi_arid(pl_master_to_ddr_axi_arid),
  .s_axi_araddr(pl_master_to_ddr_axi_araddr),
  .s_axi_arlen(pl_master_to_ddr_axi_arlen),
  .s_axi_arsize(pl_master_to_ddr_axi_arsize),
  .s_axi_arburst(pl_master_to_ddr_axi_arburst),
  .s_axi_arlock(pl_master_to_ddr_axi_arlock),
  .s_axi_arcache(pl_master_to_ddr_axi_arcache),
  .s_axi_arprot(pl_master_to_ddr_axi_arprot),
  .s_axi_arregion(pl_master_to_ddr_axi_arregion),
  .s_axi_arqos(pl_master_to_ddr_axi_arqos),
  .s_axi_aruser(16'b0),
  .s_axi_arvalid(pl_master_to_ddr_axi_arvalid),
  .s_axi_arready(pl_master_to_ddr_axi_arready),

  .s_axi_rid(pl_master_to_ddr_axi_rid),
  .s_axi_rdata(pl_master_to_ddr_axi_rdata),
  .s_axi_rresp(pl_master_to_ddr_axi_rresp),
  .s_axi_rlast(pl_master_to_ddr_axi_rlast),
  .s_axi_ruser(),
  .s_axi_rvalid(pl_master_to_ddr_axi_rvalid),
  .s_axi_rready(pl_master_to_ddr_axi_rready),

//  axi_in,
  .nmu_usr_interrupt_in(4'b0)
);


and rst_and (pl_master_to_ddr_axi_tg_rstn,vio_axi_tg_rstn,rstn);

`ifdef SIM_ENABLED
axis_vio_sim axis_vio_sim_inst (
  .probe_in0({pl_master_to_ddr_axi_tg_done, pl_master_to_ddr_axi_tg_error}),    // input wire [1 : 0] probe_in0
  .probe_out0({vio_axi_tg_rstn,pl_master_to_ddr_axi_tg_start}),  // output wire [1 : 0] probe_out0
  .clk(clk),                // input wire clk
  .rstn(rstn)
);
`else
axis_vio_pl_master_to_ddr axis_vio_pl_master_to_ddr_inst (
  .probe_in0({pl_master_to_ddr_axi_tg_done, pl_master_to_ddr_axi_tg_error}),    // input wire [1 : 0] probe_in0
  .probe_out0({vio_axi_tg_rstn,pl_master_to_ddr_axi_tg_start}),  // output wire [1 : 0] probe_out0
  .clk(clk)                // input wire clk
);
`endif

endmodule
