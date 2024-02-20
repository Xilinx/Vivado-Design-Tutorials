
// ------------------------------------------------------------------------------
//   (c) Copyright 2020-2021 Advanced Micro Devices, Inc. All rights reserved.
// 
//   This file contains confidential and proprietary information
//   of Advanced Micro Devices, Inc. and is protected under U.S. and
//   international copyright and other intellectual property
//   laws.
// 
//   DISCLAIMER
//   This disclaimer is not a license and does not grant any
//   rights to the materials distributed herewith. Except as
//   otherwise provided in a valid license issued to you by
//   AMD, and to the maximum extent permitted by applicable
//   law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
//   WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
//   AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//   BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//   INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//   (2) AMD shall not be liable (whether in contract or tort,
//   including negligence, or under any other theory of
//   liability) for any loss or damage of any kind or nature
//   related to, arising under or in connection with these
//   materials, including for any direct, or any indirect,
//   special, incidental, or consequential loss or damage
//   (including loss of data, profits, goodwill, or any type of
//   loss or damage suffered as a result of any action brought
//   by a third party) even if such damage or loss was
//   reasonably foreseeable or AMD had been advised of the
//   possibility of the same.
// 
//   CRITICAL APPLICATIONS
//   AMD products are not designed or intended to be fail-
//   safe, or for use in any application requiring fail-safe
//   performance, such as life-support or safety devices or
//   systems, Class III medical devices, nuclear facilities,
//   applications related to the deployment of airbags, or any
//   other applications that could lead to death, personal
//   injury, or severe property or environmental damage
//   (individually and collectively, \"Critical
//   Applications\"). Customer assumes the sole risk and
//   liability of any use of AMD products in Critical
//   Applications, subject only to applicable laws and
//   regulations governing limitations on product liability.
// 
//   THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//   PART OF THIS FILE AT ALL TIMES.
// ------------------------------------------------------------------------------

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module dcmac_0_exdes_imp_top
(
    input  wire [3:0] gt_rxn_in0,
    input  wire [3:0] gt_rxp_in0,
    output wire [3:0] gt_txn_out0,
    output wire [3:0] gt_txp_out0,
    input  wire [3:0] gt_rxn_in1,
    input  wire [3:0] gt_rxp_in1,
    output wire [3:0] gt_txn_out1,
    output wire [3:0] gt_txp_out1,
    input  wire       gt_ref_clk0_p,
    input  wire       gt_ref_clk0_n,
    input  wire       gt_ref_clk1_p,
    input  wire       gt_ref_clk1_n
    );
    wire             gt_reset_all_in;
    wire [31:0]      gt_gpo;
    wire             gt_reset_done;
    wire [7 :0]      gt_line_rate;
    wire [2 : 0]     gt_loopback;
    wire [5 : 0]     gt_txprecursor;
    wire [5 : 0]     gt_txpostcursor;
    wire [6 : 0]     gt_txmaincursor;
    wire             gt_rxcdrhold;
    wire [31 : 0]    s_axi_awaddr;
    wire             s_axi_awvalid;
    wire             s_axi_awready;
    wire [31 : 0]    s_axi_wdata;
    wire             s_axi_wvalid;
    wire             s_axi_wready;
    wire [1 : 0]     s_axi_bresp;
    wire             s_axi_bvalid;
    wire             s_axi_bready;
    wire [31 : 0]    s_axi_araddr;
    wire             s_axi_arvalid;
    wire             s_axi_arready;
    wire [31 : 0]    s_axi_rdata;
    wire [1 : 0]     s_axi_rresp;
    wire             s_axi_rvalid;
    wire             s_axi_rready;    
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
    wire [23:0] gt_reset_tx_datapath_in;
    wire [23:0] gt_reset_rx_datapath_in;
    wire [5:0]  tx_serdes_reset;
    wire [5:0]  rx_serdes_reset;
    wire        tx_core_reset;
    wire        rx_core_reset;
    wire [23:0] gt_tx_reset_done_out;
    wire [23:0] gt_rx_reset_done_out;
 
dcmac_0_exdes i_dcmac_0_exdes(
    .s_axi_aclk     (pl0_ref_clk_0),   //input wire            s_axi_aclk,
    .s_axi_aresetn  (pl0_resetn_0),    //input wire            s_axi_aresetn,
    .s_axi_awaddr   (s_axi_awaddr),    //input wire [31 : 0]   s_axi_awaddr,
    .s_axi_awvalid  (s_axi_awvalid),   //input wire            s_axi_awvalid,
    .s_axi_awready  (s_axi_awready),   //output wire           s_axi_awready,
    .s_axi_wdata    (s_axi_wdata),     //input wire [31 : 0]   s_axi_wdata,
    .s_axi_wvalid   (s_axi_wvalid),    //input wire            s_axi_wvalid,
    .s_axi_wready   (s_axi_wready),    //output wire           s_axi_wready,
    .s_axi_bresp    (s_axi_bresp),     //output wire [1 : 0]   s_axi_bresp,
    .s_axi_bvalid   (s_axi_bvalid),    //output wire           s_axi_bvalid,
    .s_axi_bready   (s_axi_bready),    //input wire            s_axi_bready,
    .s_axi_araddr   (s_axi_araddr),    //input wire [31 : 0]   s_axi_araddr,
    .s_axi_arvalid  (s_axi_arvalid),   //input wire            s_axi_arvalid,
    .s_axi_arready  (s_axi_arready),   //output wire           s_axi_arready,
    .s_axi_rdata    (s_axi_rdata),     //output wire [31 : 0]  s_axi_rdata,
    .s_axi_rresp    (s_axi_rresp),     //output wire [1 : 0]   s_axi_rresp,
    .s_axi_rvalid   (s_axi_rvalid),    //output wire           s_axi_rvalid,
    .s_axi_rready   (s_axi_rready),    //input wire            s_axi_rready,
    .gt_tx_reset_done_out (gt_tx_reset_done_out),
    .gt_rx_reset_done_out (gt_rx_reset_done_out),
    .tx_serdes_reset (tx_serdes_reset),
    .rx_serdes_reset (rx_serdes_reset),
    .tx_core_reset   (tx_core_reset),
    .rx_core_reset   (rx_core_reset),
    .gt_rxn_in0     (gt_rxn_in0 ),//input  wire [3:0] gt_rxn_in0,
    .gt_rxp_in0     (gt_rxp_in0 ),//input  wire [3:0] gt_rxp_in0,
    .gt_txn_out0    (gt_txn_out0),//output wire [3:0] gt_txn_out0,
    .gt_txp_out0    (gt_txp_out0),//output wire [3:0] gt_txp_out0,
    .gt_rxn_in1     (gt_rxn_in1 ),//input  wire [3:0] gt_rxn_in1,
    .gt_rxp_in1     (gt_rxp_in1 ),//input  wire [3:0] gt_rxp_in1,
    .gt_txn_out1    (gt_txn_out1),//output wire [3:0] gt_txn_out1,
    .gt_txp_out1    (gt_txp_out1),//output wire [3:0] gt_txp_out1,
    .gt_reset_all_in (gt_reset_all_in),//input  wire       gt_reset_all_in,
    .gt_gpo          (gt_gpo),//output  wire       gt_gpo,
    .gt_reset_done   (gt_reset_done),//output  wire       gt_reset_done,
    .gt_line_rate    (gt_line_rate),//input  wire [7:0]    gt_line_rate,
    .gt_loopback     (gt_loopback),//input  wire [2:0]    gt_loopback,
    .gt_txprecursor  (gt_txprecursor),//input  wire [5:0]    gt_txprecursor,
    .gt_txpostcursor (gt_txpostcursor),//input  wire [5:0]    gt_txpostcursor,
    .gt_txmaincursor (gt_txmaincursor),//input  wire [6:0]    gt_txmaincursor,
    .gt_rxcdrhold    (gt_rxcdrhold),//input  wire          gt_rxcdrhold,
    .gt_reset_tx_datapath_in (gt_reset_tx_datapath_in[8-1:0]),
    .gt_reset_rx_datapath_in (gt_reset_rx_datapath_in[8-1:0]),
    
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
    .gt_ref_clk0_p   (gt_ref_clk0_p),//input  wire       gt_ref_clk0_p,
    .gt_ref_clk0_n   (gt_ref_clk0_n),//input  wire       gt_ref_clk0_n,
    .gt_ref_clk1_p   (gt_ref_clk1_p),//input  wire       gt_ref_clk1_p,
    .gt_ref_clk1_n   (gt_ref_clk1_n),//input  wire       gt_ref_clk1_n,
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
    .M00_AXI_0_araddr   (s_axi_araddr),   
    .M00_AXI_0_arprot   (),               
    .M00_AXI_0_arready  (s_axi_arready),  
    .M00_AXI_0_arvalid  (s_axi_arvalid),  
    .M00_AXI_0_awaddr   (s_axi_awaddr),   
    .M00_AXI_0_awprot   (),               
    .M00_AXI_0_awready  (s_axi_awready),  
    .M00_AXI_0_awvalid  (s_axi_awvalid),  
    .M00_AXI_0_bready   (s_axi_bready),   
    .M00_AXI_0_bresp    (s_axi_bresp),    
    .M00_AXI_0_bvalid   (s_axi_bvalid),   
    .M00_AXI_0_rdata    (s_axi_rdata),    
    .M00_AXI_0_rready   (s_axi_rready),   
    .M00_AXI_0_rresp    (s_axi_rresp),    
    .M00_AXI_0_rvalid   (s_axi_rvalid),   
    .M00_AXI_0_wdata    (s_axi_wdata),    
    .M00_AXI_0_wready   (s_axi_wready),   
    .M00_AXI_0_wstrb    (),               
    .M00_AXI_0_wvalid   (s_axi_wvalid),   
    .pl0_ref_clk_0      (pl0_ref_clk_0),
    .gt_reset_all_in    (gt_reset_all_in),
    .gt_line_rate       (gt_line_rate),
    .gt_loopback        (gt_loopback),
    .gt_txprecursor     (gt_txprecursor),
    .gt_txpostcursor    (gt_txpostcursor),
    .gt_txmaincursor    (gt_txmaincursor),
    .gt_rxcdrhold       (gt_rxcdrhold),
    .gt_reset_tx_datapath_in (gt_reset_tx_datapath_in),
    .gt_reset_rx_datapath_in (gt_reset_rx_datapath_in),
    .gt_tx_reset_done  (gt_tx_reset_done_out),
    .gt_rx_reset_done  (gt_rx_reset_done_out),
    .tx_serdes_reset (tx_serdes_reset),
    .rx_serdes_reset (rx_serdes_reset),
    .tx_core_reset   (tx_core_reset),
    .rx_core_reset   (rx_core_reset),
	
    .M00_AXI_1_araddr     (		),	
    .M00_AXI_1_arprot     (		),	
    .M00_AXI_1_arready    (1'b0	),
    .M00_AXI_1_arvalid    (		),	
    .M00_AXI_1_awaddr     (		),	
    .M00_AXI_1_awprot     (		),	
    .M00_AXI_1_awready    (1'b0	),
    .M00_AXI_1_awvalid    (		),	
    .M00_AXI_1_bready     (		),	
    .M00_AXI_1_bresp      (2'b00),
    .M00_AXI_1_bvalid     (1'b0	),
    .M00_AXI_1_rdata      (32'd0),
    .M00_AXI_1_rready     (		),	
    .M00_AXI_1_rresp      (2'b00),
    .M00_AXI_1_rvalid     (1'b0	),
    .M00_AXI_1_wdata      (		),	
    .M00_AXI_1_wready     (1'b0	),
    .M00_AXI_1_wstrb      (		),	
    .M00_AXI_1_wvalid     (		),		
	
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

