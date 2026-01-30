//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

module bli_to_hbm (
   input pl0_ref_clk_0,
   input tg_rstb,
   input tg_start,
   output tg_done,
   output tg_error); 

  wire [0 : 0] s_axi_awid;
  (* MARK_DEBUG="true" *) wire [47 : 0] s_axi_awaddr;
  (* MARK_DEBUG="true" *) wire [7 : 0] s_axi_awlen;
  (* MARK_DEBUG="true" *) wire [2 : 0] s_axi_awsize;
  (* MARK_DEBUG="true" *) wire [1 : 0] s_axi_awburst;
  wire [0 : 0] s_axi_awlock;
  wire [3 : 0] s_axi_awcache;
  wire [2 : 0] s_axi_awprot;
  wire [3 : 0] s_axi_awregion;
  wire [3 : 0] s_axi_awqos;
  wire [15 : 0] s_axi_awuser;
  (* MARK_DEBUG="true" *) wire s_axi_awvalid;
  (* MARK_DEBUG="true" *) wire s_axi_awready;
  (* MARK_DEBUG="true" *) wire [255 : 0] s_axi_wdata;
  wire [31 : 0] s_axi_wstrb;
  (* MARK_DEBUG="true" *) wire s_axi_wlast;
  wire [15 : 0] s_axi_wuser;
  (* MARK_DEBUG="true" *) wire s_axi_wvalid;
  (* MARK_DEBUG="true" *) wire s_axi_wready;
  wire [0 : 0] s_axi_bid;
  (* MARK_DEBUG="true" *) wire [1 : 0] s_axi_bresp;
  wire [15 : 0] s_axi_buser;
  (* MARK_DEBUG="true" *) wire s_axi_bvalid;
  (* MARK_DEBUG="true" *) wire s_axi_bready;
  wire [0 : 0] s_axi_arid;
  (* MARK_DEBUG="true" *) wire [47 : 0] s_axi_araddr;
  (* MARK_DEBUG="true" *) wire [7 : 0] s_axi_arlen;
  (* MARK_DEBUG="true" *) wire [2 : 0] s_axi_arsize;
  (* MARK_DEBUG="true" *) wire [1 : 0] s_axi_arburst;
  wire [0 : 0] s_axi_arlock;
  wire [3 : 0] s_axi_arcache;
  wire [2 : 0] s_axi_arprot;
  wire [3 : 0] s_axi_arregion;
  wire [3 : 0] s_axi_arqos;
  wire [15 : 0] s_axi_aruser;
  (* MARK_DEBUG="true" *) wire s_axi_arvalid;
  (* MARK_DEBUG="true" *) wire s_axi_arready;
  wire [0 : 0] s_axi_rid;
  (* MARK_DEBUG="true" *) wire [255 : 0] s_axi_rdata;
  wire [1 : 0] s_axi_rresp;
  wire s_axi_rlast;
  wire [15 : 0] s_axi_ruser;
  (* MARK_DEBUG="true" *) wire s_axi_rvalid;
  (* MARK_DEBUG="true" *) wire s_axi_rready;
  wire tg_start;
  wire tg_done;
  (* MARK_DEBUG="true" *) wire tg_error;

  perf_axi_tg_pl_bli_to_hbm perf_axi_tg_pl_bli_to_hbm_inst (
      .clk(pl0_ref_clk_0),            // input wire clk
      .tg_rst_n(tg_rstb),             // input wire tg_rst_n
      .axi_awid(s_axi_awid),          // output wire [0 : 0] axi_awid
      .axi_awaddr(s_axi_awaddr),      // output wire [47 : 0] axi_awaddr
      .axi_awlen(s_axi_awlen),        // output wire [7 : 0] axi_awlen
      .axi_awsize(s_axi_awsize),      // output wire [2 : 0] axi_awsize
      .axi_awburst(s_axi_awburst),    // output wire [1 : 0] axi_awburst
      .axi_awlock(s_axi_awlock),      // output wire [0 : 0] axi_awlock
      .axi_awcache(s_axi_awcache),    // output wire [3 : 0] axi_awcache
      .axi_awprot(s_axi_awprot),      // output wire [2 : 0] axi_awprot
      .axi_awregion(s_axi_awregion),  // output wire [3 : 0] axi_awregion
      .axi_awqos(s_axi_awqos),        // output wire [3 : 0] axi_awqos
      .axi_awuser(s_axi_awuser),      // output wire [15 : 0] axi_awuser
      .axi_awvalid(s_axi_awvalid),    // output wire axi_awvalid
      .axi_awready(s_axi_awready),    // input wire axi_awready
      .axi_wdata(s_axi_wdata),        // output wire [255 : 0] axi_wdata
      .axi_wstrb(s_axi_wstrb),        // output wire [31 : 0] axi_wstrb
      .axi_wlast(s_axi_wlast),        // output wire axi_wlast
      .axi_wuser(s_axi_wuser),        // output wire [15 : 0] axi_wuser
      .axi_wvalid(s_axi_wvalid),      // output wire axi_wvalid
      .axi_wready(s_axi_wready),      // input wire axi_wready
      .axi_bid(s_axi_bid),            // input wire [0 : 0] axi_bid
      .axi_bresp(s_axi_bresp),        // input wire [1 : 0] axi_bresp
      .axi_buser(s_axi_buser),        // input wire [15 : 0] axi_buser
      .axi_bvalid(s_axi_bvalid),      // input wire axi_bvalid
      .axi_bready(s_axi_bready),      // output wire axi_bready
      .axi_arid(s_axi_arid),          // output wire [0 : 0] axi_arid
      .axi_araddr(s_axi_araddr),      // output wire [47 : 0] axi_araddr
      .axi_arlen(s_axi_arlen),        // output wire [7 : 0] axi_arlen
      .axi_arsize(s_axi_arsize),      // output wire [2 : 0] axi_arsize
      .axi_arburst(s_axi_arburst),    // output wire [1 : 0] axi_arburst
      .axi_arlock(s_axi_arlock),      // output wire [0 : 0] axi_arlock
      .axi_arcache(s_axi_arcache),    // output wire [3 : 0] axi_arcache
      .axi_arprot(s_axi_arprot),      // output wire [2 : 0] axi_arprot
      .axi_arregion(s_axi_arregion),  // output wire [3 : 0] axi_arregion
      .axi_arqos(s_axi_arqos),        // output wire [3 : 0] axi_arqos
      .axi_aruser(s_axi_aruser),      // output wire [15 : 0] axi_aruser
      .axi_arvalid(s_axi_arvalid),    // output wire axi_arvalid
      .axi_arready(s_axi_arready),    // input wire axi_arready
      .axi_rid(s_axi_rid),            // input wire [0 : 0] axi_rid
      .axi_rdata(s_axi_rdata),        // input wire [255 : 0] axi_rdata
      .axi_rresp(s_axi_rresp),        // input wire [1 : 0] axi_rresp
      .axi_rlast(s_axi_rlast),        // input wire axi_rlast
      .axi_ruser(s_axi_ruser),        // input wire [15 : 0] axi_ruser
      .axi_rvalid(s_axi_rvalid),      // input wire axi_rvalid
      .axi_rready(s_axi_rready),      // output wire axi_rready
      .axi_tg_start(tg_start),        // input wire axi_tg_start
      .axi_tg_done(tg_done),          // output wire axi_tg_done
      .axi_tg_error(tg_error)         // output wire axi_tg_error
    );        
        
    xpm_nmu_mm #(
         .NOC_FABRIC("BLI"),                 // VNOC/BLI
         .DATA_WIDTH(256),                   // 32/64/128/256/512
         .ADDR_WIDTH(48),                    // 12 to 64
         .ID_WIDTH(7),                       // 1 to 16
         .AUSER_WIDTH(16),                   // 16 for VNOC with parity disabled, 18 for VNOC with parity enabled 
         .DUSER_WIDTH(0),                    // 2*DATA_WIDTH/8 for parity enablement with VNOC, 0 for VNOC with parity disabled cases
         .ENABLE_USR_INTERRUPT("false"),     // false/true
         .SIDEBAND_PINS("false")             // false/true/addr/data
   )
   xpm_nmu_mm_inst (
         .s_axi_aclk(pl0_ref_clk_0),
         .s_axi_awid(s_axi_awid),
         .s_axi_awaddr(s_axi_awaddr),
         .s_axi_awlen(s_axi_awlen),
         .s_axi_awsize(s_axi_awsize),
         .s_axi_awburst(s_axi_awburst),
         .s_axi_awlock(s_axi_awlock),
         .s_axi_awcache(s_axi_awcache),
         .s_axi_awprot(s_axi_awprot),
         .s_axi_awregion(s_axi_awregion),
         .s_axi_awqos(s_axi_awqos),
         .s_axi_awuser(s_axi_awuser),
         .s_axi_awvalid(s_axi_awvalid),
         .s_axi_awready(s_axi_awready),
         .s_axi_wid(s_axi_wid),
         .s_axi_wdata(s_axi_wdata),
         .s_axi_wstrb(s_axi_wstrb),
         .s_axi_wlast(s_axi_wlast),
         .s_axi_wuser(s_axi_wuser),
         .s_axi_wvalid(s_axi_wvalid),
         .s_axi_wready(s_axi_wready),
         .s_axi_bid(s_axi_bid),
         .s_axi_bresp(s_axi_bresp),
         .s_axi_buser(s_axi_buser),
         .s_axi_bvalid(s_axi_bvalid),
         .s_axi_bready(s_axi_bready),
         .s_axi_arid(s_axi_arid),
         .s_axi_araddr(s_axi_araddr),
         .s_axi_arlen(s_axi_arlen),
         .s_axi_arsize(s_axi_arsize),
         .s_axi_arburst(s_axi_arburst),
         .s_axi_arlock(s_axi_arlock),
         .s_axi_arcache(s_axi_arcache),
         .s_axi_arprot(s_axi_arprot),
         .s_axi_arregion(s_axi_arregion),
         .s_axi_arqos(s_axi_arqos),
         .s_axi_aruser(s_axi_aruser),
         .s_axi_arvalid(s_axi_arvalid),
         .s_axi_arready(s_axi_arready),
         .s_axi_rid(s_axi_rid),
         .s_axi_rdata(s_axi_rdata),
         .s_axi_rresp(s_axi_rresp),
         .s_axi_rlast(s_axi_rlast),
         .s_axi_ruser(s_axi_ruser),
         .s_axi_rvalid(s_axi_rvalid),
         .s_axi_rready(s_axi_rready),
         .nmu_usr_interrupt_in(nmu_usr_interrupt_in)
    );       

endmodule
