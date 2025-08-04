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
////------------------------------------------------------------------------------


`timescale 1ps/1ps


`define SIMULATION
`define SIMULATE_DESIGN

`define PATH_TO_GT0_WRAPPER  EXDES.dcmac_0_exdes_i.i_dcmac_0_exdes_support_wrapper_0.dcmac_0_exdes_support_i.dcmac_0_gt_wrapper
`define PATH_TO_GT1_WRAPPER  EXDES.dcmac_0_exdes_i.i_dcmac_0_exdes_support_wrapper_1.dcmac_0_exdes_support_1_i.dcmac_0_gt_wrapper_1

`define CLK_RX_CORE_HALF_PERIOD   640ps //781.25MHz
`define CLK_TX_CORE_HALF_PERIOD   640ps //781.25MHz
`define CLK_APB3_HALF_PERIOD      5000ps //100.00MHz

//// Content of emulation_macro_include
`define FEC_USE_RTL_IMPLIED_LOGIC 1

`ifdef SIMULATE_DESIGN
  `define FAST_ALIGN 1
`else
  `undef FAST_ALIGN
`endif

`undef DEBUG

`undef PRUNE_FEC

// the below two macros define attribute connections to dcmac_atom.sv.
`define SYN  1
`define NO_ASSERT 1

// if the following variable is not defined, dcmac_atom is not instantiated in dut.v
//`define DUT 1

// Flex I/F mode
//`define FLEX_IF_MODE

`undef SERDES_ERROR_INJ_SKEW

`define AXI_ONLY
`undef FLEXIF_ONLY

`undef RX_BRAM_ENABLE
////

module dcmac_0_exdes_tb
(
);
 
parameter ADDR_AXI4_BASE       = 32'hA4000000;
parameter ADDR_APB3_2_BASE     = 32'hA4010000;
parameter ADDR_APB3_2_BASE_DEC = 32'd2751528960;
parameter ADDR_APB3_3_BASE     = 32'hA4020000;
parameter ADDR_APB3_3_BASE_DEC = 32'd2751594496;
parameter ADDR_APB3_4_BASE     = 32'hA4030000;
parameter ADDR_APB3_4_BASE_DEC = 32'd2751660032;

parameter COUNTER_MODE = 0;

parameter R_400G = 2'b10,
          R_200G = 2'b01,
          R_100G = 2'b00;


bit       clk_apb3;        always #`CLK_APB3_HALF_PERIOD clk_apb3 = ~clk_apb3;
bit       clk_tx_core;     always #`CLK_TX_CORE_HALF_PERIOD clk_tx_core = ~clk_tx_core;
bit       clk_rx_core;     always #`CLK_RX_CORE_HALF_PERIOD clk_rx_core = ~clk_rx_core;

 
integer gt0_loopback0_p_0;
integer gt0_loopback0_n_0;
integer gt0_loopback1_p_0;
integer gt0_loopback1_n_0;
integer gt0_loopback2_p_0;
integer gt0_loopback2_n_0;
integer gt0_loopback3_p_0;
integer gt0_loopback3_n_0;
integer gt0_loopback4_p_0;
integer gt0_loopback4_n_0;
integer gt0_loopback5_p_0;
integer gt0_loopback5_n_0;
integer gt0_loopback0_p_1;
integer gt0_loopback0_n_1;
integer gt0_loopback1_p_1;
integer gt0_loopback1_n_1;
integer gt0_loopback2_p_1;
integer gt0_loopback2_n_1;
integer gt0_loopback3_p_1;
integer gt0_loopback3_n_1;
integer gt0_loopback4_p_1;
integer gt0_loopback4_n_1;
integer gt0_loopback5_p_1;
integer gt0_loopback5_n_1;
integer gt1_loopback0_p_0;
integer gt1_loopback0_n_0;
integer gt1_loopback1_p_0;
integer gt1_loopback1_n_0;
integer gt1_loopback2_p_0;
integer gt1_loopback2_n_0;
integer gt1_loopback3_p_0;
integer gt1_loopback3_n_0;
integer gt1_loopback4_p_0;
integer gt1_loopback4_n_0;
integer gt1_loopback5_p_0;
integer gt1_loopback5_n_0;
integer gt1_loopback0_p_1;
integer gt1_loopback0_n_1;
integer gt1_loopback1_p_1;
integer gt1_loopback1_n_1;
integer gt1_loopback2_p_1;
integer gt1_loopback2_n_1;
integer gt1_loopback3_p_1;
integer gt1_loopback3_n_1;
integer gt1_loopback4_p_1;
integer gt1_loopback4_n_1;
integer gt1_loopback5_p_1;
integer gt1_loopback5_n_1;
reg               gt0_ref_clk_p;
reg               gt0_ref_clk_n;
reg               gt1_ref_clk_p;
reg               gt1_ref_clk_n;
reg               pl_clk;
reg               gt_reset_all_in;
wire  [31:0]      gt_gpo0;
wire  [31:0]      gt_gpo1;
wire              gt_reset_done0;
wire              gt_reset_done1;

logic             rstn_apb3;
wire [23:0]       gt_tx_reset_done_out0;
wire [23:0]       gt_rx_reset_done_out0;
wire [23:0]       gt_tx_reset_done_out1;
wire [23:0]       gt_rx_reset_done_out1;
wire [5:0]        tx_serdes_reset;
wire [5:0]        rx_serdes_reset;
wire              tx_core_reset;
wire              rx_core_reset;
wire              gt_rx_reset_core;
wire              gt_tx_reset_core;
reg [2:0]         config_switch ;
logic [31:0]      APB_M_paddr;
logic             APB_M_penable;
logic             APB_M_psel;
logic [31:0]      APB_M_pwdata;
logic             APB_M_pwrite;
logic [31:0]      APB_M_prdata;
logic             APB_M_pready;
logic [31:0]      EMU_AP3_M_paddr;
logic [4:2]       EMU_AP3_M_penable;
logic             EMU_AP3_M_psel;
logic [31:0]      EMU_AP3_M_pwdata;
logic             EMU_AP3_M_pwrite;
logic [4:2][31:0] EMU_AP3_M_prdata;
logic [4:2]       EMU_AP3_M_pready;

logic             ch_all_ready;
logic [5:0]       ch_ready;
bit   [39:0]      ch_ena;

bit   [5:0][1:0]  client_rate;

wire              s_axi_arready [2];
reg [31:0]        s_axi_araddr  [2];
reg               s_axi_arvalid [2]; 
wire              s_axi_awready [2];
reg [31:0]        s_axi_awaddr  [2];
reg               s_axi_awvalid [2];  
reg               s_axi_bready  [2];
wire [1:0]        s_axi_bresp   [2];
wire              s_axi_bvalid  [2];
reg               s_axi_rready  [2];
wire [31:0]       s_axi_rdata   [2];
wire [1:0]        s_axi_rresp   [2];
wire              s_axi_rvalid  [2];
wire              s_axi_wready  [2];
reg [31:0]        s_axi_wdata   [2];
reg               s_axi_wvalid  [2];

reg [7:0]         gt_line_rate;
reg [2:0]         gt_loopback;
reg [5:0]         gt_txprecursor;
reg [5:0]         gt_txpostcursor;
reg [6:0]         gt_txmaincursor;
reg               gt_rxcdrhold;
logic [31:0]      wdata, prdata_out;
int               overall_fail;

/// Serdes resets and Core resets
  assign rx_core_reset     = gt_rx_reset_core;
  assign tx_core_reset     = gt_tx_reset_core;
  assign rx_serdes_reset   = {1'b1,1'b1,~gt_rx_reset_done_out0[0],~gt_rx_reset_done_out0[0],~gt_rx_reset_done_out0[0],~gt_rx_reset_done_out0[0]} |
                             {1'b1,1'b1,~gt_rx_reset_done_out1[0],~gt_rx_reset_done_out1[0],~gt_rx_reset_done_out1[0],~gt_rx_reset_done_out1[0]};
  assign tx_serdes_reset   = {1'b1,1'b1,~gt_tx_reset_done_out0[0],~gt_tx_reset_done_out0[0],~gt_tx_reset_done_out0[0],~gt_tx_reset_done_out0[0]} |
                             {1'b1,1'b1,~gt_tx_reset_done_out1[0],~gt_tx_reset_done_out1[0],~gt_tx_reset_done_out1[0],~gt_tx_reset_done_out1[0]};

// DCMAC core counters
logic [5:0][31:0] core_frames_tx, core_bytes_tx, core_frames_rx, core_bytes_rx;
// TX emulation counters
logic [39:0][31:0] emu_frames_tx, emu_bytes_tx, tdm_frames_tx, tdm_pause_tx, tdm_user_pause_tx, tdm_bytes_tx;
// RX emulation counters
logic [39:0][31:0] emu_frames_rx, emu_bytes_rx, tdm_frames_rx, tdm_pause_rx, tdm_user_pause_rx, tdm_bytes_rx;
logic [39:0] emu_prbs_locked;
logic [39:0][31:0] emu_prbs_error;
logic [39:0][31:0] emu_preamble_error;

// init TB stats to zero
initial begin
  core_frames_tx       = '0;
  core_frames_rx       = '0;
  core_bytes_tx        = '0;
  core_bytes_rx        = '0;
  emu_frames_tx        = '0;
  emu_frames_rx        = '0;
  emu_bytes_tx         = '0;
  emu_bytes_rx         = '0;
  emu_prbs_locked      = '0;
  emu_prbs_error       = '0;
  emu_preamble_error   = '0;
end

initial begin
    rstn_apb3          = 1'b0;
    wait_apb3_clk(100);
    rstn_apb3          = 1'b1;
end

initial begin
  gt_reset_all_in = 1'b0;
  wait(rstn_apb3);
  repeat (10) @(posedge pl_clk);
  gt_reset_all_in = 1'b1;
  repeat (10) @(posedge pl_clk);
  gt_reset_all_in = 1'b0;
end //initial

//int config_input_file;
//int config_scan_result;
//reg [31:0] config_offset, config_data;
reg [31:0] config_data[0:199];
//string output_string;
//bit config_ena;


// APB access
initial begin

//`ifndef DONT_DUMP_VPD
//  $vcdpluson();
//  $vcdplusmemon();
//`endif
  config_switch = 3'b000;
  gt_line_rate = 8'd0;
  gt_loopback = 3'b000;
  gt_txprecursor = 6'd3;
  gt_txpostcursor = 6'd9;
  gt_txmaincursor = 7'd75;
  gt_rxcdrhold = 1'b0;

  s_axi_awaddr  = '{default:0};
  s_axi_awvalid = '{default:0};
  s_axi_wdata   = '{default:0};
  s_axi_wvalid  = '{default:0};
  s_axi_bready  = '{default:0};
  s_axi_araddr  = '{default:0};
  s_axi_arvalid = '{default:0};
  s_axi_rready  = '{default:0};
  APB_M_paddr = '0;
  APB_M_penable = '0;
  APB_M_psel = '0;
  APB_M_pwdata = '0;
  APB_M_pwrite = '0;
  prdata_out = '0;
  ch_all_ready = '0;


  wait_apb3_clk(2000);

  // First do memcel reset
  apb3_write(ADDR_APB3_2_BASE+32'h200, 32'h1, 2);

  wait_apb3_clk(20);

  test_fixe_sanity();

  $finish();
end

// Client APB access
initial begin
  EMU_AP3_M_paddr = '0;
  EMU_AP3_M_penable = '0;
  EMU_AP3_M_psel = '0;
  EMU_AP3_M_pwdata = '0;
  EMU_AP3_M_pwrite = '0;
end

 

  always @(*)
   begin
       //For quad0 ch0
    force gt0_loopback0_p_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMTXP_integer;
    force gt0_loopback0_n_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMRXP_integer = gt0_loopback0_p_0;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMRXN_integer = gt0_loopback0_n_0;

    //For quad0  ch1
    force gt0_loopback1_p_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMTXP_integer;
    force gt0_loopback1_n_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMRXP_integer = gt0_loopback1_p_0;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMRXN_integer = gt0_loopback1_n_0;

    //For quad0 ch2
    force gt0_loopback2_p_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMTXP_integer;
    force gt0_loopback2_n_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMRXP_integer = gt0_loopback2_p_0;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMRXN_integer = gt0_loopback2_n_0;

    //For quad0 ch3
    force gt0_loopback3_p_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMTXP_integer;
    force gt0_loopback3_n_0 = `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMRXP_integer = gt0_loopback3_p_0;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMRXN_integer = gt0_loopback3_n_0;


    //For quad1 ch0
    force gt0_loopback0_p_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMTXP_integer;
    force gt0_loopback0_n_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMRXP_integer = gt0_loopback0_p_1 ;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMRXN_integer = gt0_loopback0_n_1 ;

    //For quad1  ch1
    force gt0_loopback1_p_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMTXP_integer;
    force gt0_loopback1_n_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMRXP_integer = gt0_loopback1_p_1 ;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMRXN_integer = gt0_loopback1_n_1 ;

    //For quad1 ch2
    force gt0_loopback2_p_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMTXP_integer;
    force gt0_loopback2_n_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMRXP_integer = gt0_loopback2_p_1 ;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMRXN_integer = gt0_loopback2_n_1 ;

    //For quad1 ch3
    force gt0_loopback3_p_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMTXP_integer;
    force gt0_loopback3_n_1  = `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMTXN_integer;

    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMRXP_integer = gt0_loopback3_p_1 ;
    force  `PATH_TO_GT0_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMRXN_integer = gt0_loopback3_n_1 ;

   end


  always @(*)
   begin
       //For quad0 ch0
    force gt1_loopback0_p_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMTXP_integer;
    force gt1_loopback0_n_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMRXP_integer = gt1_loopback0_p_0;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH0_GTMRXN_integer = gt1_loopback0_n_0;

    //For quad0  ch1
    force gt1_loopback1_p_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMTXP_integer;
    force gt1_loopback1_n_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMRXP_integer = gt1_loopback1_p_0;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH1_GTMRXN_integer = gt1_loopback1_n_0;

    //For quad0 ch2
    force gt1_loopback2_p_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMTXP_integer;
    force gt1_loopback2_n_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMRXP_integer = gt1_loopback2_p_0;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH2_GTMRXN_integer = gt1_loopback2_n_0;

    //For quad0 ch3
    force gt1_loopback3_p_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMTXP_integer;
    force gt1_loopback3_n_0 = `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMRXP_integer = gt1_loopback3_p_0;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base.inst.quad_inst.CH3_GTMRXN_integer = gt1_loopback3_n_0;


    //For quad1 ch0
    force gt1_loopback0_p_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMTXP_integer;
    force gt1_loopback0_n_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMRXP_integer = gt1_loopback0_p_1 ;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH0_GTMRXN_integer = gt1_loopback0_n_1 ;

    //For quad1  ch1
    force gt1_loopback1_p_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMTXP_integer;
    force gt1_loopback1_n_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMRXP_integer = gt1_loopback1_p_1 ;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH1_GTMRXN_integer = gt1_loopback1_n_1 ;

    //For quad1 ch2
    force gt1_loopback2_p_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMTXP_integer;
    force gt1_loopback2_n_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMRXP_integer = gt1_loopback2_p_1 ;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH2_GTMRXN_integer = gt1_loopback2_n_1 ;

    //For quad1 ch3
    force gt1_loopback3_p_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMTXP_integer;
    force gt1_loopback3_n_1  = `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMTXN_integer;

    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMRXP_integer = gt1_loopback3_p_1 ;
    force  `PATH_TO_GT1_WRAPPER.gt_quad_base_1.inst.quad_inst.CH3_GTMRXN_integer = gt1_loopback3_n_1 ;

   end


dcmac_0_exdes_sim_wrapper EXDES
(
   .s_axi_aclk           (clk_apb3),
   .s_axi_aresetn        (rstn_apb3),
   .s_axi_0_awaddr         (s_axi_awaddr[0]),
   .s_axi_0_awvalid        (s_axi_awvalid[0]),
   .s_axi_0_awready        (s_axi_awready[0]),
   .s_axi_0_wdata          (s_axi_wdata[0]),
   .s_axi_0_wvalid         (s_axi_wvalid[0]),
   .s_axi_0_wready         (s_axi_wready[0]),
   .s_axi_0_bresp          (s_axi_bresp[0]),
   .s_axi_0_bvalid         (s_axi_bvalid[0]),
   .s_axi_0_bready         (s_axi_bready[0]),
   .s_axi_0_araddr         (s_axi_araddr[0]),
   .s_axi_0_arvalid        (s_axi_arvalid[0]),
   .s_axi_0_arready        (s_axi_arready[0]),
   .s_axi_0_rdata          (s_axi_rdata[0]),
   .s_axi_0_rresp          (s_axi_rresp[0]),
   .s_axi_0_rvalid         (s_axi_rvalid[0]),
   .s_axi_0_rready         (s_axi_rready[0]),
   .s_axi_1_awaddr         (s_axi_awaddr[1]),
   .s_axi_1_awvalid        (s_axi_awvalid[1]),
   .s_axi_1_awready        (s_axi_awready[1]),
   .s_axi_1_wdata          (s_axi_wdata[1]),
   .s_axi_1_wvalid         (s_axi_wvalid[1]),
   .s_axi_1_wready         (s_axi_wready[1]),
   .s_axi_1_bresp          (s_axi_bresp[1]),
   .s_axi_1_bvalid         (s_axi_bvalid[1]),
   .s_axi_1_bready         (s_axi_bready[1]),
   .s_axi_1_araddr         (s_axi_araddr[1]),
   .s_axi_1_arvalid        (s_axi_arvalid[1]),
   .s_axi_1_arready        (s_axi_arready[1]),
   .s_axi_1_rdata          (s_axi_rdata[1]),
   .s_axi_1_rresp          (s_axi_rresp[1]),
   .s_axi_1_rvalid         (s_axi_rvalid[1]),
   .s_axi_1_rready         (s_axi_rready[1]),

   .APB_M2_prdata        (EMU_AP3_M_prdata[2][31:0]),
   .APB_M2_pready        (EMU_AP3_M_pready[2]),

   .APB_M3_prdata        (EMU_AP3_M_prdata[3][31:0]),
   .APB_M3_pready        (EMU_AP3_M_pready[3]),

   .APB_M4_prdata        (EMU_AP3_M_prdata[4][31:0]),
   .APB_M4_pready        (EMU_AP3_M_pready[4]),

   .APB_M2_paddr         (EMU_AP3_M_paddr[31:0]),
   .APB_M2_penable       (EMU_AP3_M_penable[2]),
   .APB_M2_psel          (EMU_AP3_M_psel),
   .APB_M2_pwdata        (EMU_AP3_M_pwdata[31:0]),
   .APB_M2_pwrite        (EMU_AP3_M_pwrite),

   .APB_M3_paddr         (EMU_AP3_M_paddr[31:0]),
   .APB_M3_penable       (EMU_AP3_M_penable[3]),
   .APB_M3_psel          (EMU_AP3_M_psel),
   .APB_M3_pwdata        (EMU_AP3_M_pwdata[31:0]),
   .APB_M3_pwrite        (EMU_AP3_M_pwrite),

   .APB_M4_paddr         (EMU_AP3_M_paddr[31:0]),
   .APB_M4_penable       (EMU_AP3_M_penable[4]),
   .APB_M4_psel          (EMU_AP3_M_psel),
   .APB_M4_pwdata        (EMU_AP3_M_pwdata[31:0]),
   .APB_M4_pwrite        (EMU_AP3_M_pwrite),
   .gt_tx_reset_done_out0 (gt_tx_reset_done_out0),
   .gt_rx_reset_done_out0 (gt_rx_reset_done_out0),
   .gt_tx_reset_done_out1 (gt_tx_reset_done_out1),
   .gt_rx_reset_done_out1 (gt_rx_reset_done_out1),
   .tx_serdes_reset      (tx_serdes_reset),
   .rx_serdes_reset      (rx_serdes_reset),
   .tx_core_reset        (tx_core_reset),
   .rx_core_reset        (rx_core_reset),
   .gt_tx_reset_core0    (gt_tx_reset_core),
   .gt_rx_reset_core0    (gt_rx_reset_core),
   .gt0_ref_clk0_p        (gt0_ref_clk_p),
   .gt0_ref_clk0_n        (gt0_ref_clk_n),
   .gt0_ref_clk1_p        (gt0_ref_clk_p),
   .gt0_ref_clk1_n        (gt0_ref_clk_n),
   .gt1_ref_clk0_p        (gt1_ref_clk_p),
   .gt1_ref_clk0_n        (gt1_ref_clk_n),
   .gt1_ref_clk1_p        (gt1_ref_clk_p),
   .gt1_ref_clk1_n        (gt1_ref_clk_n),
 
   .gt0_rxn_in0           (),
   .gt0_rxp_in0           (),
   .gt0_txn_out0          (),
   .gt0_txp_out0          (),
   .gt0_rxn_in1           (),
   .gt0_rxp_in1           (),
   .gt0_txn_out1          (),
   .gt0_txp_out1          (),
   .gt1_rxn_in0           (),
   .gt1_rxp_in0           (),
   .gt1_txn_out0          (),
   .gt1_txp_out0          (),
   .gt1_rxn_in1           (),
   .gt1_rxp_in1           (),
   .gt1_txn_out1          (),
   .gt1_txp_out1          (),
   .gt_reset_all_in      (gt_reset_all_in),
   .gt_gpo0              (gt_gpo0),
   .gt_gpo1              (gt_gpo1),
   .gt_reset_done0       (gt_reset_done0),
   .gt_reset_done1       (gt_reset_done1),
   .gt_reset_tx_datapath_in0 ('d0),
   .gt_reset_rx_datapath_in0 ('d0),
   .gt_reset_tx_datapath_in1 ('d0),
   .gt_reset_rx_datapath_in1 ('d0),
 	
 
 
 
 
 
   .gt_line_rate         (gt_line_rate),
   .gt_loopback          (gt_loopback),
   .gt_txprecursor       (gt_txprecursor),
   .gt_txpostcursor      (gt_txpostcursor),
   .gt_txmaincursor      (gt_txmaincursor),
   .gt_rxcdrhold         (gt_rxcdrhold),
   .init_clk             (pl_clk)
);

initial
begin
    gt0_ref_clk_p =1;
    forever #3200.000   gt0_ref_clk_p = ~ gt0_ref_clk_p;
end

initial
begin
    gt0_ref_clk_n =0;
    forever #3200.000   gt0_ref_clk_n = ~ gt0_ref_clk_n;
end

initial
begin
    gt1_ref_clk_p =1;
    forever #3200.000   gt1_ref_clk_p = ~ gt1_ref_clk_p;
end

initial
begin
    gt1_ref_clk_n =0;
    forever #3200.000   gt1_ref_clk_n = ~ gt1_ref_clk_n;
end

initial
begin
    pl_clk =1;
    forever #5000.00 pl_clk = ~pl_clk;
end

 

//// Content of common_tasks
//`define CFG_FILE "../../../../imports/dcmac_0_regmap_emulation_writes.txt"

task apb3_write;
  input [31:0] addr;
  input [31:0] data;
  input [2:0]  root;

  @(negedge clk_apb3);

  if(root == 0) begin
    // dcmac APB3 transaction
    APB_M_paddr   = addr;
    APB_M_penable = 1'b0;
    APB_M_psel    = 1'b1;
    APB_M_pwdata  = data;
    APB_M_pwrite  = 1'b1;

    @(negedge clk_apb3);

    APB_M_penable = 1'b1;

    #1ns;
    while (APB_M_pready == 1'b0) begin
      @(negedge clk_apb3);
      #1ns;
    end

    @(negedge clk_apb3);
    #1ns;
    APB_M_penable = 1'b0;
    APB_M_paddr   = 32'h0;
    APB_M_psel    = 1'b0;

  end // if (root == 0)
  else begin

    // APB3 transaction to emulation client
    EMU_AP3_M_paddr   = addr;
    EMU_AP3_M_penable = '0;
    EMU_AP3_M_psel    = 1'b1;
    EMU_AP3_M_pwdata  = data;
    EMU_AP3_M_pwrite  = 1'b1;

    @(negedge clk_apb3);

    EMU_AP3_M_penable[root] = 1'b1;

    #1ns;
    while (EMU_AP3_M_pready[root] == 1'b0) begin
      @(negedge clk_apb3);
      #1ns;
    end

    @(negedge clk_apb3);
    #1ns;
    EMU_AP3_M_penable = '0;
    EMU_AP3_M_paddr   = 32'h0;
    EMU_AP3_M_psel    = 1'b0;
  end

endtask // apb3_write

task apb3_read;
  input  [31:0] addr;
  output [31:0] rdata;
  input  [2:0]  root;

  @(negedge clk_apb3);

  if(root == 0) begin
    // dcmac APB3 transaction
    APB_M_paddr   = addr;
    APB_M_penable = 1'b0;
    APB_M_psel    = 1'b1;
    APB_M_pwrite  = 1'b0;

    @(negedge clk_apb3);

    APB_M_penable = 1'b1;

    #1ns;
    while (APB_M_pready == 1'b0) begin
      @(negedge clk_apb3);
      #1ns;
    end

    // sample data
    rdata         = APB_M_prdata;

    @(negedge clk_apb3);
    #1ns;

    APB_M_penable = 1'b0;
    APB_M_paddr   = 32'h0;
    APB_M_psel    = 1'b0;
  end // if (root == 0)
  else begin
    // APB3 transaction to emulation client
    EMU_AP3_M_paddr   = addr;
    EMU_AP3_M_penable = '0;
    EMU_AP3_M_psel    = 1'b1;
    EMU_AP3_M_pwrite  = 1'b0;

    @(negedge clk_apb3);

    EMU_AP3_M_penable[root] = 1'b1;

    #1ns;
    while (EMU_AP3_M_pready[root] == 1'b0) begin
      @(negedge clk_apb3);
      #1ns;
    end

    // sample data
    rdata         = EMU_AP3_M_prdata[root];

    @(negedge clk_apb3);
    #1ns;

    EMU_AP3_M_penable = '0;
    EMU_AP3_M_paddr   = 32'h0;
    EMU_AP3_M_psel    = 1'b0;
  end
endtask // apb3_read

task axi_write (
    input [31:0] awaddr,
    input [31:0] wdata,
    input [1:0] sel = 2'b11  // default write to both
);
begin
  for (int i=0; i<2; i++) begin
    if (sel[i]==0) continue;
    // *** Write address ***
    s_axi_awaddr[i] = awaddr;
    s_axi_wdata[i] = wdata;
    s_axi_awvalid[i] = 1;
    s_axi_wvalid[i] = 1;
    @(posedge s_axi_wready[i]); 
    @(posedge clk_apb3);
    @(posedge clk_apb3);
    s_axi_awvalid[i] = 0;
    s_axi_wvalid[i] = 0;
    s_axi_awaddr[i] = 0;
    s_axi_wdata[i] = 0;
    @(posedge s_axi_bvalid[i]);
    if (s_axi_bresp[i] !=2'b00)
    begin
        $display("############ AXI4 write error ...");
        $finish;
    end 
    @(posedge clk_apb3);
    s_axi_bready[i] = 1'b1;
    @(posedge clk_apb3);
    s_axi_bready[i] = 1'b0;
    @(posedge clk_apb3);
  end
end
endtask // axi_write

task axi_read (
   input [31:0] araddr,
   output [31:0] read_data,
   input sel = 0
);
begin
   // *** Read address ***
   s_axi_araddr[sel] = araddr;
   s_axi_arvalid[sel] = 1;
   @(posedge s_axi_arready[sel]);
   @(posedge clk_apb3);
   @(posedge clk_apb3);
   s_axi_arvalid[sel] = 0;
       
   @(posedge s_axi_rvalid[sel]);
   if (s_axi_rresp[sel] !=2'b00)
   begin
      $display("############ AXI4 read error ...");
      $finish;
   end
   read_data =  s_axi_rdata[sel]; 
   @(posedge clk_apb3);
   s_axi_rready[sel] = 1'b1;
   @(posedge clk_apb3);
   s_axi_rready[sel] = 1'b0;
   @(posedge clk_apb3);
end
endtask // axi_read

 

task assert_all_reset;
  begin
    $display("Assert all DCMAC resets, time %d", $time);
    axi_write(ADDR_AXI4_BASE+32'h00f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h10f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h20f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h30f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h40f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h50f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h60f0, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h00f8, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h10f8, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h20f8, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h30f8, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h40f8, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h50f8, 32'hffffffff);
    axi_write(ADDR_AXI4_BASE+32'h60f8, 32'hffffffff);

  end
endtask

task release_all_reset;
  begin
    $display("Release all DCMAC resets, time %d", $time);
    axi_write(ADDR_AXI4_BASE+32'h00f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h10f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h20f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h30f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h40f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h50f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h60f0, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h00f8, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h10f8, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h20f8, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h30f8, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h40f8, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h50f8, 32'd0);
    axi_write(ADDR_AXI4_BASE+32'h60f8, 32'd0);

  end
endtask

task wait_apb3_clk;
  input [15:0] num_clk;
begin
  repeat(num_clk) begin
    @(posedge clk_apb3);
  end
end
endtask

task latch_all;
  begin
    // tick all again
    axi_write(ADDR_AXI4_BASE+32'h000f4, 32'd1);
    axi_write(ADDR_AXI4_BASE+32'h000fc, 32'd1);


    //delay to allow stats transfer
    wait_apb3_clk(100);

    // collect stats
    // TX_EMU_STATS
    apb3_write(ADDR_APB3_2_BASE+32'h20c,32'hffff_ffff,2); // latch tx
    apb3_write(ADDR_APB3_2_BASE+32'h210,32'hffff_ffff,2); // latch tx
    apb3_write(ADDR_APB3_2_BASE+32'h214,32'hffff_ffff,2); // latch rx
    apb3_write(ADDR_APB3_2_BASE+32'h218,32'hffff_ffff,2); // latch rx

    wait_apb3_clk(10);
  end
endtask

task wait_for_alignment;
input  sel;
    bit [1-1:0] aligned;
  begin
    for (int i=0; i< 1; i++) aligned = !ch_ena[i];
    fork
      begin : watch_dog
        `ifdef SIM_SPEED_UP
        wait_apb3_clk(5_000);
        `else
        //wait_apb3_clk(50_000);
        wait_apb3_clk(64'd1000000000000000000);
        `endif
        disable poll;
        disable watch_dog;
      end

      begin : poll
        while(~&aligned) begin
          for (int i=0; i< 1; i++) begin
            if (!aligned[i]) begin
              // Write to clear register and get real status
              axi_write(ADDR_AXI4_BASE+32'h1C00 + (i << 12), 32'hFFFFFFFF, (1<<sel));
              // read back
              axi_read(ADDR_AXI4_BASE+32'h1C00 + (i << 12), prdata_out, sel);
              //$display($sformatf("Reading RX PHY Status Reg:: %x", prdata_out));

              if (prdata_out[0] === 1'b1 & prdata_out[2] === 1'b1) begin
                aligned[i] = 1'b1;
                if (ch_ena[i]) $display("Client[%1d] RX achieved alignment at time %d {stat_rx_aligned, stat_rx_status} == 2'b%b%b", i, $time, prdata_out[2], prdata_out[0]);;
              end
              else begin
                repeat(100) begin
                  @(posedge clk_apb3);
                end
              end
            end
          end
        end
        disable watch_dog;
        disable poll;
      end
    join

    if (~&aligned) begin
      $error("Did not achieve all-alignment");
      $finish;
    end
    //// read TX CN_STAT_PORT_TX_FEC_STATUS_REG
    //// fields:
    ////    - c0_stat_tx_fec_pcs_lane_align: { bit_offset: 0, bit_width: 1, reset: 0, description: "Indicates that all the transmit FEC lanes are aligned/ deskewed and ready to transmit data. ", access: "read-only" }
    ////    - c0_stat_tx_fec_pcs_block_lock: { bit_offset: 1, bit_width: 1, reset: 0, description: "Indicates that all of the PCS lanes have achieved sync header lock. ", access: "read-only" }
    ////    - c0_stat_tx_fec_pcs_am_lock: { bit_offset: 2, bit_width: 1, reset: 0, description: "Indicates that all of the PCS lanes have achieved Alignment Marker lock. ", access: "read-only" }
    //for (int i=0; i<$NUM_PORT; i++) begin
    //  axi_read(ADDR_AXI4_BASE+32'h1810 + (i << 12), prdata_out);
    //  $display("Client[%1d] stat_tx_fec_pcs_lane_align = %b", i, prdata_out[0]);
    //  $display("Client[%1d] stat_tx_fec_pcs_block_lock = %b", i, prdata_out[1]);  
    //  $display("Client[%1d] stat_tx_fec_pcs_am_lock = %b", i, prdata_out[2]);
    //end
  end
endtask


////////////////////////////CHANGES FOR DYNAMIC

task config_mac;
  begin
    $display($sformatf("CFG -- MAC Config Starts"));

    /*config_input_file = $fopen($sformatf("%s", `CFG_FILE), "r");
    config_ena = 1;
    while (!$feof(config_input_file) & config_ena) begin

      config_scan_result = $fscanf(config_input_file, "%*s %h %h\n", config_offset, config_data);

      if (config_offset == 32'hffff_ffff) begin
        config_ena = 0;
      end
      else begin
        if (config_offset[19:12] < 7) begin  // only configure 6 channels
        output_string = $sformatf("OFFSET: %8X DATA: %8X", config_offset, config_data);
        output_string = output_string.toupper();
        //$display($sformatf("CFG -- Writing to %s", output_string));

        #1ns;
        axi_write(ADDR_AXI4_BASE+config_offset, config_data);

        wait_apb3_clk(10);
        end
      end
    end*/

    for (int i = 1; i <= 6; i++) begin
      //axi_write(ADDR_AXI4_BASE+32'h00004 + (i << 12), 32'h25800042);
      axi_write(ADDR_AXI4_BASE+32'h00004 + (i << 12), 32'h25800000);
      //axi_read(ADDR_AXI4_BASE+32'h00004 + (i << 12), prdata_out);
      //$display($sformatf("CFG -- Writing to %x", prdata_out));
    end

    for (int i = 1; i <= 6; i++) begin
      axi_write(ADDR_AXI4_BASE+32'h00000 + (i << 12), 32'h00000C21);
      //axi_read(ADDR_AXI4_BASE+32'h00000 + (i << 12), prdata_out);
      //$display($sformatf("CFG -- Writing to %x", prdata_out));
    end

    //for (int i = 1; i <= 6; i++) begin
    //  axi_write(ADDR_AXI4_BASE+32'h000ac + (i << 12), 32'h00000020);
    //  axi_read(ADDR_AXI4_BASE+32'h000ac + (i << 12), prdata_out);
    //  $display($sformatf("CFG -- Writing to %x", prdata_out));
    //end

    wait_apb3_clk(20);
    $display($sformatf("CFG -- MAC Config Complete!"));
  end
endtask


task set_data_rate;
  input [2:0] client_num;
  input [5:0][1:0] i_rate;
  reg [31:0] wdat;
  begin
      //$display("set_data_rate client[%1d] time %d", client_num, $time);
      wdat[31:0] = 32'd0;
      wdat[1:0] = i_rate;
      `ifdef SIM_SPEED_UP
      wdat[2] = 1'b1; // ctl_tx_use_custom_vl_length_minus1
      `endif
      wdat[10:9] = 2'b01; // tx_pma_lane_mux

      if (i_rate == R_100G) begin
        wdat[20:16] = 5'b00100; // 100G KP4
      end
      else if (i_rate == R_200G) wdat[20:16] = 5'b01000; // 200G FEC
      else if (i_rate == R_400G) wdat[20:16] = 5'b10000; // 400G FEC
      // TX
      axi_write(ADDR_AXI4_BASE+32'h01040 + (client_num << 12), wdat);

      // RX
      wdat[10:9] = 2'd0;
      `ifdef SIM_SPEED_UP
      wdat[2] = 1'b0;
      wdat[9] = 1'b1; // ctl_rx_use_custom_vl_length_minus1
      `endif
      wdat[13:12] = 2'b01; // rx_pma_lane_mux
      axi_write(ADDR_AXI4_BASE+32'h01044 + (client_num << 12), wdat);
  end
endtask

task client_reset_flush;
  input [2:0] client_id;
  int num_port;
  begin
    $display("Reset port %1d at time %d", client_id, $time);

    case (client_rate[client_id])
      R_100G: num_port = 1;
      R_200G: num_port = 2;
      R_400G: num_port = 4;
      default: num_port = 1;
    endcase

    for (int i=client_id; i<client_id+num_port; i++) begin
      // per-channel flush
      axi_write(ADDR_AXI4_BASE+32'h01030 + (i << 12), 32'd1);
      axi_write(ADDR_AXI4_BASE+32'h01038 + (i << 12), 32'd1);
      wait_apb3_clk(100);
      // phy reset
      axi_write(ADDR_AXI4_BASE+32'h010f0 + (i << 12), 32'd3);
      axi_write(ADDR_AXI4_BASE+32'h010f8 + (i << 12), 32'd3);
    end
    wait_apb3_clk(100);
  end
  endtask

task client_release_flush;
  input [2:0] client_id;
  int num_port;
  begin
    $display("Release port %1d at time %d", client_id, $time);

    case (client_rate[client_id])
      R_100G: num_port = 1;
      R_200G: num_port = 2;
      R_400G: num_port = 4;
      default: num_port = 1;
    endcase

    for (int i=client_id; i<client_id+num_port; i++) begin
      // release phy reset
      axi_write(ADDR_AXI4_BASE+32'h010f0 + (i << 12), 32'd0);
      axi_write(ADDR_AXI4_BASE+32'h010f8 + (i << 12), 32'd0);
      wait_apb3_clk(100);
      // release per-channel flush
      axi_write(ADDR_AXI4_BASE+32'h01030 + (i << 12), 32'd0);
      axi_write(ADDR_AXI4_BASE+32'h01038 + (i << 12), 32'd0);
    end

    repeat(20) begin
      @(posedge clk_apb3);
    end

  end
endtask

task check_sanity;
  begin
    for(int i=0; i<6; i=i+1) begin
      if (ch_ena[i]) begin
        // read DCMAC core stats counters
        if (i < 6) begin
          axi_read(ADDR_AXI4_BASE+32'h1200 + (i << 12), core_bytes_tx[i]);
          axi_read(ADDR_AXI4_BASE+32'h1210 + (i << 12), core_frames_tx[i]);
          axi_read(ADDR_AXI4_BASE+32'h1400 + (i << 12), core_bytes_rx[i]);
          axi_read(ADDR_AXI4_BASE+32'h1410 + (i << 12), core_frames_rx[i]);
        end
        // read packet gen/mon stats counters
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+0)<<2), emu_frames_tx      [i],  2);
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+2)<<2), emu_bytes_tx       [i],  2);
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+4)<<2), emu_frames_rx      [i],  2);
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+6)<<2), emu_bytes_rx       [i],  2);
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+8)<<2), emu_prbs_locked    [i],  2);
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+9)<<2), emu_prbs_error     [i],  2);
        apb3_read(ADDR_APB3_2_BASE_DEC+((256+i*16+10)<<2), emu_preamble_error [i],  2);

        // TDM to cnt
        apb3_read(ADDR_APB3_3_BASE+{8'd0, i[7:0], 8'd0,  8'd0}, tdm_bytes_tx [i], 3);
        apb3_read(ADDR_APB3_3_BASE+{8'd0, i[7:0], 8'd2,  8'd0}, tdm_frames_tx[i], 3);
        apb3_read(ADDR_APB3_4_BASE+{8'd0, i[7:0], 8'd0,  8'd0}, tdm_bytes_rx [i], 4);
        apb3_read(ADDR_APB3_4_BASE+{8'd0, i[7:0], 8'd2,  8'd0}, tdm_frames_rx[i], 4);

        apb3_read(ADDR_APB3_3_BASE+{8'd0, i[7:0], 8'd23, 8'd0}, tdm_pause_tx[i], 3);
        apb3_read(ADDR_APB3_3_BASE+{8'd0, i[7:0], 8'd24, 8'd0}, tdm_user_pause_tx[i], 3);
        apb3_read(ADDR_APB3_4_BASE+{8'd0, i[7:0], 8'd30, 8'd0}, tdm_pause_rx[i], 4);
        apb3_read(ADDR_APB3_4_BASE+{8'd0, i[7:0], 8'd31, 8'd0}, tdm_user_pause_rx[i], 4);


        // FCS adjustment
        tdm_bytes_tx[i] -= 4 * tdm_frames_tx[i];
        tdm_bytes_rx[i] -= 4 * tdm_frames_rx[i];

        core_bytes_tx[i] -= 4 * core_frames_tx[i];
        core_bytes_rx[i] -= 4 * core_frames_rx[i];

      end
    end

    for (int i=0; i<6; i++) begin
      if (ch_ena[i]) begin
        $display("Channel[%2d] sent %d user packets", i, emu_frames_tx[i]);
        $display("Channel[%2d] received %d user packets", i, emu_frames_rx[i]);
        $display("Channel[%2d] sent %d total bytes", i, emu_bytes_tx[i]);
        $display("Channel[%2d] received %d total bytes", i, emu_bytes_rx[i]);

        //if (tdm_pause_tx[i] !== 0 | tdm_user_pause_tx[i] !== 0) begin
        //  $display ("INFO: tdm_pause_tx[%2d] = %d, tdm_user_pause_tx[%2d] = %d", i, tdm_pause_tx[i], i, tdm_user_pause_tx[i]);
        //  tdm_frames_tx[i] -= (tdm_pause_tx[i] + tdm_user_pause_tx[i]);
        //  tdm_bytes_tx[i] -= 60 * (tdm_pause_tx[i] + tdm_user_pause_tx[i]);
        //  core_frames_tx[i] -= (tdm_pause_tx[i] + tdm_user_pause_tx[i]);
        //  core_bytes_tx[i] -= 60 * (tdm_pause_tx[i] + tdm_user_pause_tx[i]);
        //end

        //if (tdm_pause_rx[i] !== 0 | tdm_user_pause_rx[i] !== 0) begin
        //  $display ("INFO: tdm_pause_rx[%2d] = %d, tdm_user_pause_rx[%2d] = %d", i, tdm_pause_rx[i], i, tdm_user_pause_rx[i]);
        //  tdm_frames_rx[i] -= (tdm_pause_rx[i] + tdm_user_pause_rx[i]);
        //  tdm_bytes_rx[i] -= 60 * (tdm_pause_rx[i] + tdm_user_pause_rx[i]);
        //  core_frames_rx[i] -= (tdm_pause_rx[i] + tdm_user_pause_rx[i]);
        //  core_bytes_rx[i] -= 60 * (tdm_pause_rx[i] + tdm_user_pause_rx[i]);
        //end


        if (emu_frames_tx[i] !== emu_frames_rx[i] | emu_frames_tx[i] === 0 | emu_frames_rx[i] === 0) begin
          overall_fail = 1'b1;
          $display ("ERROR: emu_frames_tx[%2d] = %d, emu_frames_rx[%2d] = %d", i, emu_frames_tx[i], i, emu_frames_rx[i]);
        end

        //if (i < 6) begin
        //  if (emu_frames_tx[i] !== core_frames_tx[i] | emu_frames_tx[i] !== core_frames_rx[i]) begin
        //    overall_fail = 1'b1;
        //    $display ("ERROR: emu_frames_tx[%2d] = %d, core_frames_tx[%2d] = %d, core_frames_rx[%2d] = %d", i, emu_frames_tx[i], i, core_frames_tx[i], i, core_frames_rx[i]);
        //  end
        //  if (emu_bytes_tx[i] !== core_bytes_tx[i] | emu_bytes_tx[i] !== core_bytes_rx[i]) begin
        //    overall_fail = 1'b1;
        //    $display ("ERROR: emu_bytes_tx[%2d] = %d, core_bytes_tx[%2d] = %d, core_bytes_rx[%2d] = %d", i, emu_bytes_tx[i], i, core_bytes_tx[i], i, core_bytes_rx[i]);
        //  end
        //end

        //if (tdm_frames_tx[i] !== emu_frames_tx[i] ) begin
        //  overall_fail = 1'b1;
        //  $display ("ERROR: emu_frames_tx[%2d] = %d, tdm_frames_tx[%2d] = %d", i, emu_frames_tx[i], i, tdm_frames_tx[i]);
        //end

        //if (tdm_bytes_tx[i] !== emu_bytes_tx[i] ) begin
        //  overall_fail = 1'b1;
        //  $display ("ERROR: emu_bytes_tx[%2d] = %d, tdm_bytes_tx[%2d] = %d", i, emu_bytes_tx[i], i, tdm_bytes_tx[i]);
        //end

        //if (tdm_frames_rx[i] !== emu_frames_rx[i] ) begin
        //  overall_fail = 1'b1;
        //  $display ("ERROR: emu_frames_rx[%2d] = %d, tdm_frames_rx[%2d] = %d", i, emu_frames_rx[i], i, tdm_frames_rx[i]);
        //end

        //if (tdm_bytes_rx[i] !== emu_bytes_rx[i] ) begin
        //  overall_fail = 1'b1;
        //  $display ("ERROR: emu_bytes_rx[%2d] = %d, tdm_bytes_rx[%2d] = %d", i, emu_bytes_rx[i], i, tdm_bytes_rx[i]);
        //end


        if (emu_bytes_tx[i] !== emu_bytes_rx[i] | emu_bytes_tx[i] === 0 | emu_bytes_rx[i] === 0) begin
          overall_fail = 1'b1;
          $display ("ERROR: emu_bytes_tx[%2d] = %d, emu_bytes_rx[%2d] = %d", i, emu_bytes_tx[i], i, emu_bytes_rx[i]);
        end

        if (emu_prbs_locked[i] !== 1'b1) begin
          overall_fail = 1'b1;
          $display ("ERROR: ch[%2d] is not locked", i);
        end

        if (emu_prbs_error[i] !== 0) begin
          overall_fail = 1'b1;
          $display ("ERROR: emu_prbs_error[%2d] is %d", i, emu_prbs_error[i]);
        end

        //if (!independent_mode & emu_preamble_error[i] !== 0) begin
        //  overall_fail = 1'b1;
        //  $display ("ERROR: emu_preamble_error[%2d] is %d", i, emu_preamble_error[i]);
        //end


      end
    end
  end
endtask

task test_fixe_sanity;
  begin

//////////////////////////////////// CHANGES for Dynamic

//////////////////For STATIC////////////////////


  $display("#########################################");
  $display("#########################################");

  // Wait for GT reset done
  //@(posedge gt_reset_done);
  wait (gt_reset_done0 == 1'b1 && gt_reset_done1 == 1'b1 && gt_gpo0[15] == 1'b1 && gt_gpo1[15] == 1'b1);
  $display($sformatf("GT reset done, time %d", $time));

  axi_write(ADDR_AXI4_BASE+32'h00004, 32'h0133_0022);
  //config_mac();

  ch_ena = '0;
  ch_ena[0] = 1'b1;
  client_rate[0] = R_400G;

  assert_all_reset(); // core reset to re-assign 16 pointers to the first 6 channels
  //client_reset_flush(0);
  for (int i=0; i<6; i++) begin
    client_reset_flush(i);
  end
  
  // config PCS client 0 to 400G
  //set_data_rate(0, client_rate[0]);
  for (int i=0; i<6; i++) begin
    set_data_rate(i, client_rate[i]);
  end
  
  release_all_reset();

  //client_release_flush(0);
  for (int i=0; i<6; i++) begin
    client_release_flush(i);
  end

  wait_apb3_clk(500);
  latch_all();

  // wait for alignment
  wait_for_alignment(0);
  wait_for_alignment(1);
  wait_apb3_clk(30);
  // enable EMU packet gen
  $display($sformatf("Packets start, time %d", $time));
  apb3_write(ADDR_APB3_2_BASE+32'h208, 32'h0100_0040, 2);
  apb3_write(ADDR_APB3_2_BASE+32'h204, {2'd0, ch_ena, 24'd0}, 2);
  wait_apb3_clk(500);

  // stop packets
  apb3_write(ADDR_APB3_2_BASE+32'h204, 32'd0, 2);
  $display($sformatf("Packets stop, time %d", $time));

  // delay TICK for stats accumulating
  wait_apb3_clk(1500);

  latch_all();
  check_sanity();

  $display(" *********************\n");

  if(overall_fail == 0)
    $display(" ***** Test Completed Successfully and Passed *****\n");
  else
    $display(" ***** Test Completed but Failed *****\n");

  $display(" *********************\n");


  $finish();




  end
endtask
////


endmodule
