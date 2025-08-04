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

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module dcmac_0_exdes_imp_top
(
    input  wire [3:0] gt0_rxn_in0,
    input  wire [3:0] gt0_rxp_in0,
    output wire [3:0] gt0_txn_out0,
    output wire [3:0] gt0_txp_out0,
    input  wire [3:0] gt0_rxn_in1,
    input  wire [3:0] gt0_rxp_in1,
    output wire [3:0] gt0_txn_out1,
    output wire [3:0] gt0_txp_out1,
    input  wire       gt0_ref_clk0_p,
    input  wire       gt0_ref_clk0_n,
    input  wire       gt0_ref_clk1_p,
    input  wire       gt0_ref_clk1_n,
    input  wire [3:0] gt1_rxn_in0,
    input  wire [3:0] gt1_rxp_in0,
    output wire [3:0] gt1_txn_out0,
    output wire [3:0] gt1_txp_out0,
    input  wire [3:0] gt1_rxn_in1,
    input  wire [3:0] gt1_rxp_in1,
    output wire [3:0] gt1_txn_out1,
    output wire [3:0] gt1_txp_out1,
    input  wire       gt1_ref_clk0_p,
    input  wire       gt1_ref_clk0_n,
    input  wire       gt1_ref_clk1_p,
    input  wire       gt1_ref_clk1_n
    );
    wire             gt0_reset_all_in;
    wire [31:0]      gt0_gpo;
    wire [31:0]      gt1_gpo;
    wire             gt0_reset_done;
    wire             gt1_reset_done;
    wire [7 :0]      gt0_line_rate;
    wire [2 : 0]     gt0_loopback;
    wire [5 : 0]     gt0_txprecursor;
    wire [5 : 0]     gt0_txpostcursor;
    wire [6 : 0]     gt0_txmaincursor;
    wire             gt0_rxcdrhold;
    wire [31 : 0]    s0_axi_awaddr;
    wire             s0_axi_awvalid;
    wire             s0_axi_awready;
    wire [31 : 0]    s0_axi_wdata;
    wire             s0_axi_wvalid;
    wire             s0_axi_wready;
    wire [1 : 0]     s0_axi_bresp;
    wire             s0_axi_bvalid;
    wire             s0_axi_bready;
    wire [31 : 0]    s0_axi_araddr;
    wire             s0_axi_arvalid;
    wire             s0_axi_arready;
    wire [31 : 0]    s0_axi_rdata;
    wire [1 : 0]     s0_axi_rresp;
    wire             s0_axi_rvalid;
    wire             s0_axi_rready;    
    wire [31 : 0]    s1_axi_awaddr;
    wire             s1_axi_awvalid;
    wire             s1_axi_awready;
    wire [31 : 0]    s1_axi_wdata;
    wire             s1_axi_wvalid;
    wire             s1_axi_wready;
    wire [1 : 0]     s1_axi_bresp;
    wire             s1_axi_bvalid;
    wire             s1_axi_bready;
    wire [31 : 0]    s1_axi_araddr;
    wire             s1_axi_arvalid;
    wire             s1_axi_arready;
    wire [31 : 0]    s1_axi_rdata;
    wire [1 : 0]     s1_axi_rresp;
    wire             s1_axi_rvalid;
    wire             s1_axi_rready;    
    wire             pl0_ref_clk_0;
    wire             pl0_resetn_0;    
    wire [31:0]      APB_M2_prdata;
    wire [0:0]       APB_M2_pready;
    wire [0:0]       APB_M2_pslver;
    wire [31:0]      APB_M3_prdata;
    wire [0:0]       APB_M3_pready;
    wire [0:0]       APB_M3_pslver;
    wire [31:0]      APB_M4_prdata;
    wire [0:0]       APB_M4_pready;
    wire [0:0]       APB_M4_pslver;
    wire [31:0]      APB_M2_paddr;
    wire             APB_M2_penable;
    wire [0:0]       APB_M2_psel;
    wire [31:0]      APB_M2_pwdata;
    wire             APB_M2_pwrite;
    wire [31:0]      APB_M3_paddr;
    wire             APB_M3_penable;
    wire [0:0]       APB_M3_psel;
    wire [31:0]      APB_M3_pwdata;
    wire             APB_M3_pwrite;
    wire [31:0]      APB_M4_paddr;
    wire             APB_M4_penable;
    wire [0:0]       APB_M4_psel;
    wire [31:0]      APB_M4_pwdata;
    wire             APB_M4_pwrite;
    wire [23:0] gt0_reset_tx_datapath_in;
    wire [23:0] gt0_reset_rx_datapath_in;
    wire [23:0] gt1_reset_tx_datapath_in;
    wire [23:0] gt1_reset_rx_datapath_in;
    wire [5:0]  tx_serdes_reset;
    wire [5:0]  rx_serdes_reset;
    wire        tx_core_reset;
    wire        rx_core_reset;
    wire [23:0] gt0_tx_reset_done_out;
    wire [23:0] gt0_rx_reset_done_out;
    wire [23:0] gt1_tx_reset_done_out;
    wire [23:0] gt1_rx_reset_done_out;
 
dcmac_0_exdes i_dcmac_0_exdes(
    .s_axi_aclk     (pl0_ref_clk_0),   //input wire            s_axi_aclk,
    .s_axi_aresetn  (pl0_resetn_0),    //input wire            s_axi_aresetn,
    .s_axi_0_awaddr   (s0_axi_awaddr),    //input wire [31 : 0]   s_axi_awaddr,
    .s_axi_0_awvalid  (s0_axi_awvalid),   //input wire            s_axi_awvalid,
    .s_axi_0_awready  (s0_axi_awready),   //output wire           s_axi_awready,
    .s_axi_0_wdata    (s0_axi_wdata),     //input wire [31 : 0]   s_axi_wdata,
    .s_axi_0_wvalid   (s0_axi_wvalid),    //input wire            s_axi_wvalid,
    .s_axi_0_wready   (s0_axi_wready),    //output wire           s_axi_wready,
    .s_axi_0_bresp    (s0_axi_bresp),     //output wire [1 : 0]   s_axi_bresp,
    .s_axi_0_bvalid   (s0_axi_bvalid),    //output wire           s_axi_bvalid,
    .s_axi_0_bready   (s0_axi_bready),    //input wire            s_axi_bready,
    .s_axi_0_araddr   (s0_axi_araddr),    //input wire [31 : 0]   s_axi_araddr,
    .s_axi_0_arvalid  (s0_axi_arvalid),   //input wire            s_axi_arvalid,
    .s_axi_0_arready  (s0_axi_arready),   //output wire           s_axi_arready,
    .s_axi_0_rdata    (s0_axi_rdata),     //output wire [31 : 0]  s_axi_rdata,
    .s_axi_0_rresp    (s0_axi_rresp),     //output wire [1 : 0]   s_axi_rresp,
    .s_axi_0_rvalid   (s0_axi_rvalid),    //output wire           s_axi_rvalid,
    .s_axi_0_rready   (s0_axi_rready),    //input wire            s_axi_rready,
    .s_axi_1_awaddr   (s1_axi_awaddr),    //input wire [31 : 0]   s_axi_awaddr,
    .s_axi_1_awvalid  (s1_axi_awvalid),   //input wire            s_axi_awvalid,
    .s_axi_1_awready  (s1_axi_awready),   //output wire           s_axi_awready,
    .s_axi_1_wdata    (s1_axi_wdata),     //input wire [31 : 0]   s_axi_wdata,
    .s_axi_1_wvalid   (s1_axi_wvalid),    //input wire            s_axi_wvalid,
    .s_axi_1_wready   (s1_axi_wready),    //output wire           s_axi_wready,
    .s_axi_1_bresp    (s1_axi_bresp),     //output wire [1 : 0]   s_axi_bresp,
    .s_axi_1_bvalid   (s1_axi_bvalid),    //output wire           s_axi_bvalid,
    .s_axi_1_bready   (s1_axi_bready),    //input wire            s_axi_bready,
    .s_axi_1_araddr   (s1_axi_araddr),    //input wire [31 : 0]   s_axi_araddr,
    .s_axi_1_arvalid  (s1_axi_arvalid),   //input wire            s_axi_arvalid,
    .s_axi_1_arready  (s1_axi_arready),   //output wire           s_axi_arready,
    .s_axi_1_rdata    (s1_axi_rdata),     //output wire [31 : 0]  s_axi_rdata,
    .s_axi_1_rresp    (s1_axi_rresp),     //output wire [1 : 0]   s_axi_rresp,
    .s_axi_1_rvalid   (s1_axi_rvalid),    //output wire           s_axi_rvalid,
    .s_axi_1_rready   (s1_axi_rready),    //input wire            s_axi_rready,
    .gt_tx_reset_done_out0 (gt0_tx_reset_done_out),
    .gt_rx_reset_done_out0 (gt0_rx_reset_done_out),
    .gt_tx_reset_done_out1 (gt1_tx_reset_done_out),
    .gt_rx_reset_done_out1 (gt1_rx_reset_done_out),
    .tx_serdes_reset (tx_serdes_reset),
    .rx_serdes_reset (rx_serdes_reset),
    .tx_core_reset   (tx_core_reset),
    .rx_core_reset   (rx_core_reset),
    .gt0_rxn_in0     (gt0_rxn_in0 ),//input  wire [3:0] gt_rxn_in0,
    .gt0_rxp_in0     (gt0_rxp_in0 ),//input  wire [3:0] gt_rxp_in0,
    .gt0_txn_out0    (gt0_txn_out0),//output wire [3:0] gt_txn_out0,
    .gt0_txp_out0    (gt0_txp_out0),//output wire [3:0] gt_txp_out0,
    .gt0_rxn_in1     (gt0_rxn_in1 ),//input  wire [3:0] gt_rxn_in1,
    .gt0_rxp_in1     (gt0_rxp_in1 ),//input  wire [3:0] gt_rxp_in1,
    .gt0_txn_out1    (gt0_txn_out1),//output wire [3:0] gt_txn_out1,
    .gt0_txp_out1    (gt0_txp_out1),//output wire [3:0] gt_txp_out1,
    .gt1_rxn_in0     (gt1_rxn_in0 ),//input  wire [3:0] gt_rxn_in0,
    .gt1_rxp_in0     (gt1_rxp_in0 ),//input  wire [3:0] gt_rxp_in0,
    .gt1_txn_out0    (gt1_txn_out0),//output wire [3:0] gt_txn_out0,
    .gt1_txp_out0    (gt1_txp_out0),//output wire [3:0] gt_txp_out0,
    .gt1_rxn_in1     (gt1_rxn_in1 ),//input  wire [3:0] gt_rxn_in1,
    .gt1_rxp_in1     (gt1_rxp_in1 ),//input  wire [3:0] gt_rxp_in1,
    .gt1_txn_out1    (gt1_txn_out1),//output wire [3:0] gt_txn_out1,
    .gt1_txp_out1    (gt1_txp_out1),//output wire [3:0] gt_txp_out1,
    .gt_reset_all_in (gt0_reset_all_in),//input  wire       gt_reset_all_in,
    .gt_gpo0          (gt0_gpo),//output  wire       gt_gpo,
    .gt_gpo1          (gt1_gpo),//output  wire       gt_gpo,
    .gt_reset_done0   (gt0_reset_done),//output  wire       gt_reset_done,
    .gt_reset_done1   (gt1_reset_done),//output  wire       gt_reset_done,
    .gt_line_rate    (gt0_line_rate),//input  wire [7:0]    gt_line_rate,
    .gt_loopback     (gt0_loopback),//input  wire [2:0]    gt_loopback,
    .gt_txprecursor  (gt0_txprecursor),//input  wire [5:0]    gt_txprecursor,
    .gt_txpostcursor (gt0_txpostcursor),//input  wire [5:0]    gt_txpostcursor,
    .gt_txmaincursor (gt0_txmaincursor),//input  wire [6:0]    gt_txmaincursor,
    .gt_rxcdrhold    (gt0_rxcdrhold),//input  wire          gt_rxcdrhold,
    .gt_reset_tx_datapath_in0 (gt0_reset_tx_datapath_in[8-1:0]),
    .gt_reset_rx_datapath_in0 (gt0_reset_rx_datapath_in[8-1:0]),
    .gt_reset_tx_datapath_in1 (gt1_reset_tx_datapath_in[8-1:0]),
    .gt_reset_rx_datapath_in1 (gt1_reset_rx_datapath_in[8-1:0]),
    
    .APB_M2_prdata   (APB_M2_prdata ),//output logic [31:0]  APB_M2_prdata,
    .APB_M2_pready   (APB_M2_pready ),//output logic [0:0]   APB_M2_pready,
    .APB_M2_pslverr  (APB_M2_pslverr),//output logic [0:0]   APB_M2_pslverr,
    .APB_M3_prdata   (APB_M3_prdata ),//output logic [31:0]  APB_M3_prdata,
    .APB_M3_pready   (APB_M3_pready ),//output logic [0:0]   APB_M3_pready,
    .APB_M3_pslverr  (APB_M3_pslverr),//output logic [0:0]   APB_M3_pslverr,
    .APB_M4_prdata   (APB_M4_prdata ),//output logic [31:0]  APB_M4_prdata,
    .APB_M4_pready   (APB_M4_pready ),//output logic [0:0]   APB_M4_pready,
    .APB_M4_pslverr  (APB_M4_pslverr),//output logic [0:0]   APB_M4_pslverr,

    .APB_M2_paddr    (APB_M2_paddr  ),//input [31:0]      APB_M2_paddr,
    .APB_M2_penable  (APB_M2_penable),//input             APB_M2_penable,
    .APB_M2_psel     (APB_M2_psel   ),//input [0:0]       APB_M2_psel,
    .APB_M2_pwdata   (APB_M2_pwdata ),//input [31:0]      APB_M2_pwdata,
    .APB_M2_pwrite   (APB_M2_pwrite ),//input             APB_M2_pwrite,
    .APB_M3_paddr    (APB_M3_paddr  ),//input [31:0]      APB_M3_paddr,
    .APB_M3_penable  (APB_M3_penable),//input             APB_M3_penable,
    .APB_M3_psel     (APB_M3_psel   ),//input [0:0]       APB_M3_psel,
    .APB_M3_pwdata   (APB_M3_pwdata ),//input [31:0]      APB_M3_pwdata,
    .APB_M3_pwrite   (APB_M3_pwrite ),//input             APB_M3_pwrite,
    .APB_M4_paddr    (APB_M4_paddr  ),//input [31:0]      APB_M4_paddr,
    .APB_M4_penable  (APB_M4_penable),//input             APB_M4_penable,
    .APB_M4_psel     (APB_M4_psel   ),//input [0:0]       APB_M4_psel,
    .APB_M4_pwdata   (APB_M4_pwdata ),//input [31:0]      APB_M4_pwdata,
    .APB_M4_pwrite   (APB_M4_pwrite ),//input             APB_M4_pwrite,
    .gt0_ref_clk0_p  (gt0_ref_clk0_p),//input  wire       gt_ref_clk0_p,
    .gt0_ref_clk0_n  (gt0_ref_clk0_n),//input  wire       gt_ref_clk0_n,
    .gt0_ref_clk1_p  (gt0_ref_clk1_p),//input  wire       gt_ref_clk1_p,
    .gt0_ref_clk1_n  (gt0_ref_clk1_n),//input  wire       gt_ref_clk1_n,
    .gt1_ref_clk0_p  (gt1_ref_clk0_p),//input  wire       gt_ref_clk0_p,
    .gt1_ref_clk0_n  (gt1_ref_clk0_n),//input  wire       gt_ref_clk0_n,
    .gt1_ref_clk1_p  (gt1_ref_clk1_p),//input  wire       gt_ref_clk1_p,
    .gt1_ref_clk1_n  (gt1_ref_clk1_n),//input  wire       gt_ref_clk1_n,
    .init_clk        (pl0_ref_clk_0)//input  wire       init_clk
);
   
 dcmac_0_cips_wrapper i_dcmac_0_cips_wrapper(
    .APB_M2_0_paddr     (APB_M3_paddr),
    .APB_M2_0_penable   (APB_M3_penable),
    .APB_M2_0_prdata    (APB_M3_prdata),
    .APB_M2_0_pready    (APB_M3_pready),
    .APB_M2_0_psel      (APB_M3_psel),
    .APB_M2_0_pslverr   (APB_M3_pslverr),
    .APB_M2_0_pwdata    (APB_M3_pwdata),
    .APB_M2_0_pwrite    (APB_M3_pwrite),
    .APB_M3_0_paddr     (APB_M4_paddr),
    .APB_M3_0_penable   (APB_M4_penable),
    .APB_M3_0_prdata    (APB_M4_prdata),
    .APB_M3_0_pready    (APB_M4_pready),
    .APB_M3_0_psel      (APB_M4_psel),
    .APB_M3_0_pslverr   (APB_M4_pslverr),
    .APB_M3_0_pwdata    (APB_M4_pwdata),
    .APB_M3_0_pwrite    (APB_M4_pwrite),
    .APB_M_0_paddr      (APB_M2_paddr),
    .APB_M_0_penable    (APB_M2_penable),
    .APB_M_0_prdata     (APB_M2_prdata),
    .APB_M_0_pready     (APB_M2_pready),
    .APB_M_0_psel       (APB_M2_psel),
    .APB_M_0_pslverr    (APB_M2_pslverr),
    .APB_M_0_pwdata     (APB_M2_pwdata),
    .APB_M_0_pwrite     (APB_M2_pwrite),
    .M00_AXI_0_araddr   (s0_axi_araddr),   
    .M00_AXI_0_arprot   (),               
    .M00_AXI_0_arready  (s0_axi_arready),  
    .M00_AXI_0_arvalid  (s0_axi_arvalid),  
    .M00_AXI_0_awaddr   (s0_axi_awaddr),   
    .M00_AXI_0_awprot   (),               
    .M00_AXI_0_awready  (s0_axi_awready),  
    .M00_AXI_0_awvalid  (s0_axi_awvalid),  
    .M00_AXI_0_bready   (s0_axi_bready),   
    .M00_AXI_0_bresp    (s0_axi_bresp),    
    .M00_AXI_0_bvalid   (s0_axi_bvalid),   
    .M00_AXI_0_rdata    (s0_axi_rdata),    
    .M00_AXI_0_rready   (s0_axi_rready),   
    .M00_AXI_0_rresp    (s0_axi_rresp),    
    .M00_AXI_0_rvalid   (s0_axi_rvalid),   
    .M00_AXI_0_wdata    (s0_axi_wdata),    
    .M00_AXI_0_wready   (s0_axi_wready),   
    .M00_AXI_0_wstrb    (),               
    .M00_AXI_0_wvalid   (s0_axi_wvalid),   
    .pl0_ref_clk_0      (pl0_ref_clk_0),
    .gt_reset_all_in    (gt0_reset_all_in),
    .gt_line_rate       (gt0_line_rate),
    .gt_loopback        (gt0_loopback),
    .gt_txprecursor     (gt0_txprecursor),
    .gt_txpostcursor    (gt0_txpostcursor),
    .gt_txmaincursor    (gt0_txmaincursor),
    .gt_rxcdrhold       (gt0_rxcdrhold),
    .gt_reset_tx_datapath_in (gt0_reset_tx_datapath_in),
    .gt_reset_rx_datapath_in (gt0_reset_rx_datapath_in),
    .gt_tx_reset_done  (gt0_tx_reset_done_out),
    .gt_rx_reset_done  (gt0_rx_reset_done_out),
    .tx_serdes_reset (tx_serdes_reset),
    .rx_serdes_reset (rx_serdes_reset),
    .tx_core_reset   (tx_core_reset),
    .rx_core_reset   (rx_core_reset),
	
    .M00_AXI_1_araddr   (s1_axi_araddr),   
    .M00_AXI_1_arprot   (),               
    .M00_AXI_1_arready  (s1_axi_arready),  
    .M00_AXI_1_arvalid  (s1_axi_arvalid),  
    .M00_AXI_1_awaddr   (s1_axi_awaddr),   
    .M00_AXI_1_awprot   (),               
    .M00_AXI_1_awready  (s1_axi_awready),  
    .M00_AXI_1_awvalid  (s1_axi_awvalid),  
    .M00_AXI_1_bready   (s1_axi_bready),   
    .M00_AXI_1_bresp    (s1_axi_bresp),    
    .M00_AXI_1_bvalid   (s1_axi_bvalid),   
    .M00_AXI_1_rdata    (s1_axi_rdata),    
    .M00_AXI_1_rready   (s1_axi_rready),   
    .M00_AXI_1_rresp    (s1_axi_rresp),    
    .M00_AXI_1_rvalid   (s1_axi_rvalid),   
    .M00_AXI_1_wdata    (s1_axi_wdata),    
    .M00_AXI_1_wready   (s1_axi_wready),   
    .M00_AXI_1_wstrb    (),               
    .M00_AXI_1_wvalid   (s1_axi_wvalid),   
	
    .M00_AXI_2_araddr     (		),	
    .M00_AXI_2_arprot     (		),	
    .M00_AXI_2_arready    (1'b0	),
    .M00_AXI_2_arvalid    (		),	
    .M00_AXI_2_awaddr     (		),	
    .M00_AXI_2_awprot     (		),	
    .M00_AXI_2_awready    (1'b0	),
    .M00_AXI_2_awvalid    (		),	
    .M00_AXI_2_bready     (		),	
    .M00_AXI_2_bresp      (2'b00),
    .M00_AXI_2_bvalid     (1'b0	),
    .M00_AXI_2_rdata      (32'd0),
    .M00_AXI_2_rready     (		),	
    .M00_AXI_2_rresp      (2'b00),
    .M00_AXI_2_rvalid     (1'b0	),
    .M00_AXI_2_wdata      (		),	
    .M00_AXI_2_wready     (1'b0	),
    .M00_AXI_2_wstrb      (		),	
    .M00_AXI_2_wvalid     (		),		
	
    .M00_AXI_3_araddr     (		),	
    .M00_AXI_3_arprot     (		),	
    .M00_AXI_3_arready    (1'b0	),
    .M00_AXI_3_arvalid    (		),	
    .M00_AXI_3_awaddr     (		),	
    .M00_AXI_3_awprot     (		),	
    .M00_AXI_3_awready    (1'b0	),
    .M00_AXI_3_awvalid    (		),	
    .M00_AXI_3_bready     (		),	
    .M00_AXI_3_bresp      (2'b00),
    .M00_AXI_3_bvalid     (1'b0	),
    .M00_AXI_3_rdata      (32'd0),
    .M00_AXI_3_rready     (		),	
    .M00_AXI_3_rresp      (2'b00),
    .M00_AXI_3_rvalid     (1'b0	),
    .M00_AXI_3_wdata      (		),	
    .M00_AXI_3_wready     (1'b0	),
    .M00_AXI_3_wstrb      (		),	
    .M00_AXI_3_wvalid     (		),		
    .M00_AXI_4_araddr     (		),	
    .M00_AXI_4_arprot     (		),	
    .M00_AXI_4_arready    (1'b0	),
    .M00_AXI_4_arvalid    (		),	
    .M00_AXI_4_awaddr     (		),	
    .M00_AXI_4_awprot     (		),	
    .M00_AXI_4_awready    (1'b0	),
    .M00_AXI_4_awvalid    (		),	
    .M00_AXI_4_bready     (		),	
    .M00_AXI_4_bresp      (2'b00),
    .M00_AXI_4_bvalid     (1'b0	),
    .M00_AXI_4_rdata      (32'd0),
    .M00_AXI_4_rready     (		),	
    .M00_AXI_4_rresp      (2'b00),
    .M00_AXI_4_rvalid     (1'b0	),
    .M00_AXI_4_wdata      (		),	
    .M00_AXI_4_wready     (1'b0	),
    .M00_AXI_4_wstrb      (		),	
    .M00_AXI_4_wvalid     (		),		
	
	
    .M00_AXI_5_araddr     (		),	
    .M00_AXI_5_arprot     (		),	
    .M00_AXI_5_arready    (1'b0	),
    .M00_AXI_5_arvalid    (		),	
    .M00_AXI_5_awaddr     (		),	
    .M00_AXI_5_awprot     (		),	
    .M00_AXI_5_awready    (1'b0	),
    .M00_AXI_5_awvalid    (		),	
    .M00_AXI_5_bready     (		),	
    .M00_AXI_5_bresp      (2'b00),
    .M00_AXI_5_bvalid     (1'b0	),
    .M00_AXI_5_rdata      (32'd0),
    .M00_AXI_5_rready     (		),	
    .M00_AXI_5_rresp      (2'b00),
    .M00_AXI_5_rvalid     (1'b0	),
    .M00_AXI_5_wdata      (		),	
    .M00_AXI_5_wready     (1'b0	),
    .M00_AXI_5_wstrb      (		),	
    .M00_AXI_5_wvalid     (		),		
    .M00_AXI_6_araddr     (		),	
    .M00_AXI_6_arprot     (		),	
    .M00_AXI_6_arready    (1'b0	),
    .M00_AXI_6_arvalid    (		),	
    .M00_AXI_6_awaddr     (		),	
    .M00_AXI_6_awprot     (		),	
    .M00_AXI_6_awready    (1'b0	),
    .M00_AXI_6_awvalid    (		),	
    .M00_AXI_6_bready     (		),	
    .M00_AXI_6_bresp      (2'b00),
    .M00_AXI_6_bvalid     (1'b0	),
    .M00_AXI_6_rdata      (32'd0),
    .M00_AXI_6_rready     (		),	
    .M00_AXI_6_rresp      (2'b00),
    .M00_AXI_6_rvalid     (1'b0	),
    .M00_AXI_6_wdata      (		),	
    .M00_AXI_6_wready     (1'b0	),
    .M00_AXI_6_wstrb      (		),	
    .M00_AXI_6_wvalid     (		),		
	
    .pl0_resetn_0       (pl0_resetn_0)
);

 
endmodule

