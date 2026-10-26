`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: toplevel_sb
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

module toplevel_sb(

    input    CLKIN_p,
    input    CLKIN_n,
    input    chipscope_clk_in_p_pin,
    input    chipscope_clk_in_n_pin,

    
    /////////////////////Transmitter//////////////////////////////////
    
    output    Tx_data_n0_bs0_p,     // p-side Tx data  PRBS
    output    Tx_data_n0_bs1_n,		// n-side Tx data  PRBS
    output    Tx_data_n0_bs2_p,		// p-side Tx data  PRBS 
    output    Tx_data_n0_bs3_n,		// n-side Tx data  PRBS
    output    Tx_data_n0_bs4_p,		// p-side Tx data  PRBS
    output    Tx_data_n0_bs5_n,		// n-side Tx data  PRBS
    
    output    Tx_data_n1_bs0_p, 	// p-side Tx data  PRBS
    output    Tx_data_n1_bs1_n,		// n-side Tx data  PRBS
    output    Tx_data_n1_bs2_p, 	// p-side Tx data  PRBS
    output    Tx_data_n1_bs3_n,		// n-side Tx data  PRBS
    output    Tx_data_n1_bs4_p, 	// p-side Tx data  PRBS
    output    Tx_data_n1_bs5_n,		// n-side Tx data  PRBS

    output    Tx_data_n2_bs0_p, 	// p-side Transmit Clock
    output    Tx_data_n2_bs1_n,		// n-side Transmit Clock
    output    Tx_data_n2_bs2_p, 	// p-side Tx data  PRBS
    output    Tx_data_n2_bs3_n,		// n-side Tx data  PRBS
    output    Tx_data_n2_bs4_p, 	// p-side Tx data  PRBS
    output    Tx_data_n2_bs5_n,		// n-side Tx data  PRBS

    output    Tx_data_n3_bs0_p, 	// p-side Tx data  PRBS
    output    Tx_data_n3_bs1_n,		// n-side Tx data  PRBS
    output    Tx_data_n3_bs2_p, 	// p-side Tx data  PRBS
    output    Tx_data_n3_bs3_n,		// n-side Tx data  PRBS
    output    Tx_data_n3_bs4_p, 	// p-side Tx data  PRBS
    output    Tx_data_n3_bs5_n,		// n-side Tx data  PRBS

    output    Tx_data_n4_bs2_p, 	// p-side Tx data  PRBS
    output    Tx_data_n4_bs3_n,		// n-side Tx data  PRBS
    output    Tx_data_n4_bs4_p, 	// p-side Tx data  PRBS
    output    Tx_data_n4_bs5_n,		// n-side Tx data  PRBS

    output    Tx_data_n5_bs0_p, 	// p-side Tx data  PRBS
    output    Tx_data_n5_bs1_n,		// n-side Tx data  PRBS
    output    Tx_data_n5_bs2_p, 	// p-side Tx data  PRBS
    output    Tx_data_n5_bs3_n,		// n-side Tx data  PRBS
    output    Tx_data_n5_bs4_p, 	// p-side Tx data  PRBS
    output    Tx_data_n5_bs5_n,		// n-side Tx data  PRBS

    /////////////////////Receiver//////////////////////////////////
    
    input    Rx_data_n0_bs0_p, 		// p-side Rx data  PRBS
    input    Rx_data_n0_bs1_n,		// n-side Rx data  PRBS
    input    Rx_data_n0_bs2_p,		// p-side Rx data  PRBS 
    input    Rx_data_n0_bs3_n,		// n-side Rx data  PRBS
    input    Rx_data_n0_bs4_p,		// p-side Rx data  PRBS
    input    Rx_data_n0_bs5_n,		// n-side Rx data  PRBS
    
    input    Rx_data_n1_bs0_p, 		// p-side Rx data  PRBS
    input    Rx_data_n1_bs1_n,		// n-side Rx data  PRBS
    input    Rx_data_n1_bs2_p,		// p-side Rx data  PRBS 
    input    Rx_data_n1_bs3_n,		// n-side Rx data  PRBS
    input    Rx_data_n1_bs4_p,		// p-side Rx data  PRBS
    input    Rx_data_n1_bs5_n,		// n-side Rx data  PRBS
    
    input    strobe_p, 	            // p-side Rx data  Strobe
    input    strobe_n, 	            // n-side Rx data  Strobe
    input    Rx_data_n2_bs2_p,		// p-side Rx data  PRBS 
    input    Rx_data_n2_bs3_n,		// n-side Rx data  PRBS
    input    Rx_data_n2_bs4_p,		// p-side Rx data  PRBS
    input    Rx_data_n2_bs5_n,		// n-side Rx data  PRBS
    
    input    Rx_data_n3_bs0_p,		// p-side Rx data  PRBS 
    input    Rx_data_n3_bs1_n,		// n-side Rx data  PRBS
    input    Rx_data_n3_bs2_p,		// p-side Rx data  PRBS 
    input    Rx_data_n3_bs3_n,		// n-side Rx data  PRBS
    input    Rx_data_n3_bs4_p,		// p-side Rx data  PRBS
    input    Rx_data_n3_bs5_n,		// n-side Rx data  PRBS
    
    input    Rx_data_n4_bs2_p,		// p-side Rx data  PRBS 
    input    Rx_data_n4_bs3_n,		// n-side Rx data  PRBS
    input    Rx_data_n4_bs4_p,		// p-side Rx data  PRBS
    input    Rx_data_n4_bs5_n,		// n-side Rx data  PRBS
    
    input    Rx_data_n5_bs0_p, 		// p-side Rx data  PRBS
    input    Rx_data_n5_bs1_n,		// n-side Rx data  PRBS
    input    Rx_data_n5_bs2_p,		// p-side Rx data  PRBS 
    input    Rx_data_n5_bs3_n,		// n-side Rx data  PRBS
    input    Rx_data_n5_bs4_p,		// p-side Rx data  PRBS
    input    Rx_data_n5_bs5_n		// n-side Rx data  PRBS
    
    );
   
    ////////////////////////////////////////////////////////////////////////////   


    parameter    Low = 1'b0;
    parameter    High = 1'b1;
    parameter    Simulation_o = 1;
    
    wire [15:0]  p_side_iob_tx;
    wire [15:0]  n_side_iob_tx;
    wire         p_side_strobe_tx_iob;
    wire         n_side_strobe_tx_iob;

    wire [15:0]  p_side_iob_rx;
    wire [15:0]  n_side_iob_rx;
    wire         p_side_strobe_rx_iob;
    wire         n_side_strobe_rx_iob;
    
    reg  [7:0]   dummy_data;
    reg  [7:0]   dummy_strobe;

    reg  [127:0] int_d;
    reg  [7:0]   int_d_clk_fwd;
    reg  [7:0]   int_d_clk_fwd_sync;

    reg  [127:0] int_q;

    wire         strobe_p_rx;
    
    wire         chipscope_clk_ibufds;
    wire         chipscope_clk_bufg;

    wire         int_clkin_tx_ibuf;
    wire         int_clkin_tx_bufg;

    wire         int_clkin_rx_ibuf;
    wire         int_clkin_rx_bufg;

    wire         int_prbs_err_all_sync;
    wire         int_intf_rdy_rx_sync;
    wire         int_intf_rdy_tx_sync;
    wire         int_prbs_valid_sync;

    wire         int_tx_rst;
    wire         int_tx_rst_sync;

    wire         int_inject_err;
    wire         int_inject_err_sync;

    wire         int_prbs_gen_rst;
    wire         int_prbs_gen_rst_sync;

    wire         int_prbs_chk_rst;
    wire         int_prbs_chk_rst_sync;

    wire         int_rx_rst;
    wire         int_rx_rst_sync;

    wire         int_pll_rst_pll_tx;
    wire         int_pll_rst_pll_rx;
    wire         int_pll_rst_pll_tx_sync;
    wire         int_pll_rst_pll_rx_sync;
     
    wire         int_fifo_empty;
    reg          int_fifo_rden;
    wire         int_fifo_empty_dummy;
    reg          int_fifo_rden_dummy;
    wire [7:0]   rcvd_dqs;
    wire [7:0]   rcvd_dqs_sync;
    
    wire         intTxClk0;
    wire         intRxClk0;

    wire         int_mmcm_clk;
    
    reg          int_gen;
    reg          int_chk;

    genvar          index_8bit_dataout;
    genvar          index_8bit_datain;
    genvar          index_8bit_clk_fwd;
    genvar          index_8bit_rcvd_dqs;

    reg  [7:0]      D_n0_0_sync;     
    reg  [7:0]      Q_n0_0_sync;     
    
    ////////////////////////////////////////////////////////////
    reg [7:0] D_n0_0, D_n0_1, D_n0_2, D_n0_3, D_n0_4, D_n0_5;
    reg [7:0] D_n1_0, D_n1_1, D_n1_2, D_n1_3, D_n1_4, D_n1_5;
    reg [7:0]                 D_n2_2, D_n2_3, D_n2_4, D_n2_5;
    reg [7:0] D_n3_0, D_n3_1, D_n3_2, D_n3_3, D_n3_4, D_n3_5;
    reg [7:0] D_n4_0, D_n4_1, D_n4_2, D_n4_3, D_n4_4, D_n4_5;
    reg [7:0] D_n5_0, D_n5_1, D_n5_2, D_n5_3, D_n5_4, D_n5_5;

    ////////////////////////////////////////////////////////////
    reg [7:0] Q_n0_0, Q_n0_1, Q_n0_2, Q_n0_3, Q_n0_4, Q_n0_5;
    reg [7:0] Q_n1_0, Q_n1_1, Q_n1_2, Q_n1_3, Q_n1_4, Q_n1_5;
    reg [7:0]                 Q_n2_2, Q_n2_3, Q_n2_4, Q_n2_5;
    reg [7:0] Q_n3_0, Q_n3_1, Q_n3_2, Q_n3_3, Q_n3_4, Q_n3_5;
    reg [7:0] Q_n4_0, Q_n4_1, Q_n4_2, Q_n4_3, Q_n4_4, Q_n4_5;
    reg [7:0] Q_n5_0, Q_n5_1, Q_n5_2, Q_n5_3, Q_n5_4, Q_n5_5;


    //////////////////////////////////////////////////////
    ///////////  CLKIN to TX and RX Cores   //////////////
    //////////////////////////////////////////////////////

    BUFG tx_clk_bufg_inst (
        .I(int_mmcm_clk),
        .O(int_clkin_tx_bufg)
    );

     BUFG rx_clk_bufg_inst (
        .I(int_mmcm_clk),
        .O(int_clkin_rx_bufg)
    );


    //////////////////////////////////////////////////////
    ///////////       VIO Clocking          //////////////
    //////////////////////////////////////////////////////

    IBUFDS chipscope_clk_ifbuds_inst (
        .I(chipscope_clk_in_p_pin),
        .IB(chipscope_clk_in_n_pin),
        .O(chipscope_clk_ibufds)
    );

    BUFG chipscope_clk_bufg_inst (
        .I(chipscope_clk_ibufds),
        .O(chipscope_clk_bufg)
    );


    ///////////////////////////////////////////////////////
    /////////////  Instantiation of mmcm_clk //////////////
    ///////////////////////////////////////////////////////

    clock_gen mmcm_clock (
        .clk_in1_p(CLKIN_p),  // input wire clk_in1_p
        .clk_in1_n(CLKIN_n),  // input wire clk_in1_n
        .clk_out1(int_mmcm_clk)    // output wire clk_out1
    );


    //////////////////////////////////////////////////////
    ///////////  Instantiation of Tx_bank   //////////////
    //////////////////////////////////////////////////////

    Tx_1bank_ssync_intrfce  my_Tx_bank (
      
      .intf_rdy(int_intf_rdy_tx),                                       // output wire intf_rdy  
      .ctrl_clk(intTxClk0),                                             // input wire ctrl_clk
      .en_vtc(usr_tx_en_vtc),                                           // input wire en_vtc
      .bank0_pll_clkout0(intTxClk0),                                    // output wire bank0_pll_clkout0
      .bank0_pll_locked(int_pll_locked_tx),                             // output wire bank0_pll_locked
      .rst(int_tx_rst_sync),                                            // input wire rst
      .bank0_pll_rst_pll(int_pll_rst_pll_tx_sync),                      // input wire bank0_pll_rst_pll
      .bank0_pll_clkin(int_clkin_tx_bufg),                              // input wire bank0_pll_clkin
      .dly_rdy(int_dly_rdy),                                            // output wire dly_rdy
      .phy_rdy(int_phy_rdy),                                            // output wire phy_rdy
      .Tx_data_p(p_side_iob_tx[15:0]),                                  // output wire [15 : 0] Tx_data_p
      .Tx_data_n(n_side_iob_tx[15:0]),                                  // output wire [15 : 0] Tx_data_n    
      .t_Tx_data({16{1'b0}}),                                           // input wire [15 : 0] t_Tx_data
      .data_from_fabric_Tx_data(int_d[127:0]),                          // input wire [127 : 0] data_from_fabric_Tx_data
      .Clk_fwd_p(p_side_strobe_tx_iob),                                 // output wire [0 : 0] Clk_fwd_p
      .Clk_fwd_n(n_side_strobe_tx_iob),                                 // output wire [0 : 0] Clk_fwd_n
      .t_Clk_fwd({1'b0}),                                               // input wire [0 : 0] t_Clk_fwd
      .data_from_fabric_Clk_fwd(int_d_clk_fwd[7:0])                     // input wire [7 : 0] data_from_fabric_Clk_fwd
    );


    //////////////////////////////////////////////////////
    /////////////  Instantiation of Rx_bank //////////////
    //////////////////////////////////////////////////////
    
    Rx_1bank_ssync_intrfce my_Rx_bank (
    
      .intf_rdy(int_intf_rdy_rx),                                       // output wire intf_rdy  
      .ctrl_clk(intRxClk0),                                             // input wire ctrl_clk
      .en_vtc(usr_tx_en_vtc),                                           // input wire en_vtc
      .fifo_rd_clk(intRxClk0),                                          // input wire fifo_rd_clk
      .bank0_pll_clkout0(intRxClk0),                                    // output wire bank0_pll_clkout0
      .bank0_pll_locked(int_pll_locked_rx),                             // output wire bank0_pll_locked
      .rst(int_rx_rst_sync | !int_intf_rdy_tx),                         // input wire rst
      .bank0_pll_clkin(int_clkin_rx_bufg),                              // input wire bank0_pll_clkin
      .bank0_pll_rst_pll(int_pll_rst_pll_rx_sync),                      // input wire bank0_pll_rst_pll
      .dly_rdy(int_dly_rdy_rx),                                         // output wire dly_rdy
      .phy_rdy(int_phy_rdy_rx),                                         // output wire phy_rdy
      .fifo_empty(int_fifo_empty),                                      // output wire fifo_empty
      .fifo_rd_en(int_fifo_rden),                                       // input wire fifo_rd_en  
      .Rx_data_pins_p(p_side_iob_rx[15:0]),                             // input wire [15 : 0] Rx_data_pins_p
      .Rx_data_pins_n(n_side_iob_rx[15:0]),                             // input wire [15 : 0] Rx_data_pins_n
      .data_to_fabric_Rx_data_pins(int_q[127:0]),                       // output wire [127 : 0] data_to_fabric_Rx_data_pins
      .strobe_p(p_side_strobe_rx_iob),                                  // input wire [0 : 0] strobe_p
      .strobe_n(n_side_strobe_rx_iob),                                  // input wire [0 : 0] strobe_n
      .data_to_fabric_strobe(rcvd_dqs[7:0])                             // output wire [7 : 0] data_to_fabric_strobe
    );


       
    ///////////////////////////////////////////////
    ///////////////       TX       ////////////////
    ///////////////////////////////////////////////    
    
    assign Tx_data_n0_bs0_p = p_side_iob_tx[0];
    assign Tx_data_n0_bs2_p = p_side_iob_tx[1];
    assign Tx_data_n0_bs4_p = p_side_iob_tx[2];   
    assign Tx_data_n1_bs0_p = p_side_iob_tx[3];    
    assign Tx_data_n1_bs2_p = p_side_iob_tx[4];
    assign Tx_data_n1_bs4_p = p_side_iob_tx[5];
    assign Tx_data_n2_bs0_p = p_side_strobe_tx_iob;
    assign Tx_data_n2_bs2_p = p_side_iob_tx[6];
    assign Tx_data_n2_bs4_p = p_side_iob_tx[7];   
    assign Tx_data_n3_bs0_p = p_side_iob_tx[8];
    assign Tx_data_n3_bs2_p = p_side_iob_tx[9];
    assign Tx_data_n3_bs4_p = p_side_iob_tx[10];    
    assign Tx_data_n4_bs2_p = p_side_iob_tx[11];
    assign Tx_data_n4_bs4_p = p_side_iob_tx[12];
    assign Tx_data_n5_bs0_p = p_side_iob_tx[13];    
    assign Tx_data_n5_bs2_p = p_side_iob_tx[14];
    assign Tx_data_n5_bs4_p = p_side_iob_tx[15];

    //////////////////////////////////////////

    assign Tx_data_n0_bs1_n = n_side_iob_tx[0];
    assign Tx_data_n0_bs3_n = n_side_iob_tx[1];
    assign Tx_data_n0_bs5_n = n_side_iob_tx[2];    
    assign Tx_data_n1_bs1_n = n_side_iob_tx[3];
    assign Tx_data_n1_bs3_n = n_side_iob_tx[4];
    assign Tx_data_n1_bs5_n = n_side_iob_tx[5];
    assign Tx_data_n2_bs1_n = n_side_strobe_tx_iob;
    assign Tx_data_n2_bs3_n = n_side_iob_tx[6];
    assign Tx_data_n2_bs5_n = n_side_iob_tx[7];    
    assign Tx_data_n3_bs1_n = n_side_iob_tx[8];
    assign Tx_data_n3_bs3_n = n_side_iob_tx[9];
    assign Tx_data_n3_bs5_n = n_side_iob_tx[10];    
    assign Tx_data_n4_bs3_n = n_side_iob_tx[11];
    assign Tx_data_n4_bs5_n = n_side_iob_tx[12];
    assign Tx_data_n5_bs1_n = n_side_iob_tx[13];
    assign Tx_data_n5_bs3_n = n_side_iob_tx[14];
    assign Tx_data_n5_bs5_n = n_side_iob_tx[15];    
       
    ///////////////////////////////////////////////
    
    assign  int_d[7:0]     = D_n0_0[7:0];
    assign  int_d[15:8]    = D_n0_2[7:0];
    assign  int_d[23:16]   = D_n0_4[7:0];    
    assign  int_d[31:24]   = D_n1_0[7:0];
    assign  int_d[39:32]   = D_n1_2[7:0];
    assign  int_d[47:40]   = D_n1_4[7:0];    
    assign  int_d_clk_fwd[7:0]   = 8'h55;                               // Transmit Clock         
    assign  int_d[55:48]   = D_n2_2[7:0];
    assign  int_d[63:56]   = D_n2_4[7:0];    
    assign  int_d[71:64]   = D_n3_0[7:0];
    assign  int_d[79:72]   = D_n3_2[7:0];
    assign  int_d[87:80]   = D_n3_4[7:0];    
    assign  int_d[95:88]   = D_n4_2[7:0];
    assign  int_d[103:96]   = D_n4_4[7:0];    
    assign  int_d[111:104]   = D_n5_0[7:0];
    assign  int_d[119:112]   = D_n5_2[7:0];
    assign  int_d[127:120]   = D_n5_4[7:0];    

    
    ///////////////////////////////////////////////
    ///////////////       RX       ////////////////
    ///////////////////////////////////////////////    
    
    assign p_side_iob_rx[0] = Rx_data_n0_bs0_p;
    assign p_side_iob_rx[1] = Rx_data_n0_bs2_p;
    assign p_side_iob_rx[2] = Rx_data_n0_bs4_p;    
    assign p_side_iob_rx[3] = Rx_data_n1_bs0_p;
    assign p_side_iob_rx[4] = Rx_data_n1_bs2_p;
    assign p_side_iob_rx[5] = Rx_data_n1_bs4_p;
    assign p_side_strobe_rx_iob = strobe_p;
    assign p_side_iob_rx[6] = Rx_data_n2_bs2_p;
    assign p_side_iob_rx[7] = Rx_data_n2_bs4_p;    
    assign p_side_iob_rx[8] = Rx_data_n3_bs0_p;
    assign p_side_iob_rx[9] = Rx_data_n3_bs2_p;
    assign p_side_iob_rx[10] = Rx_data_n3_bs4_p;    
    assign p_side_iob_rx[11] = Rx_data_n4_bs2_p;
    assign p_side_iob_rx[12] = Rx_data_n4_bs4_p;    
    assign p_side_iob_rx[13] = Rx_data_n5_bs0_p;
    assign p_side_iob_rx[14] = Rx_data_n5_bs2_p;
    assign p_side_iob_rx[15] = Rx_data_n5_bs4_p;    

    //////////////////////////////////////////
    
    assign n_side_iob_rx[0] = Rx_data_n0_bs1_n;
    assign n_side_iob_rx[1] = Rx_data_n0_bs3_n;
    assign n_side_iob_rx[2] = Rx_data_n0_bs5_n;    
    assign n_side_iob_rx[3] = Rx_data_n1_bs1_n;
    assign n_side_iob_rx[4] = Rx_data_n1_bs3_n;
    assign n_side_iob_rx[5] = Rx_data_n1_bs5_n;   
    assign n_side_strobe_rx_iob = strobe_n;
    assign n_side_iob_rx[6] = Rx_data_n2_bs3_n;
    assign n_side_iob_rx[7] = Rx_data_n2_bs5_n;    
    assign n_side_iob_rx[8] = Rx_data_n3_bs1_n;
    assign n_side_iob_rx[9] = Rx_data_n3_bs3_n;
    assign n_side_iob_rx[10] = Rx_data_n3_bs5_n;    
    assign n_side_iob_rx[11] = Rx_data_n4_bs3_n;
    assign n_side_iob_rx[12] = Rx_data_n4_bs5_n;
    assign n_side_iob_rx[13] = Rx_data_n5_bs1_n;
    assign n_side_iob_rx[14] = Rx_data_n5_bs3_n;
    assign n_side_iob_rx[15] = Rx_data_n5_bs5_n;    
    
    ///////////////////////////////////////////////

    assign   Q_n0_0[7:0]  = int_q[7:0];
    assign   Q_n0_2[7:0]  = int_q[15:8];
    assign   Q_n0_4[7:0]  = int_q[23:16];    
    assign   Q_n1_0[7:0]  = int_q[31:24];
    assign   Q_n1_2[7:0]  = int_q[39:32];
    assign   Q_n1_4[7:0]  = int_q[47:40];    
    assign   Q_n2_2[7:0]  = int_q[55:48];
    assign   Q_n2_4[7:0]  = int_q[63:56];    
    assign   Q_n3_0[7:0]  = int_q[71:64];
    assign   Q_n3_2[7:0]  = int_q[79:72];
    assign   Q_n3_4[7:0]  = int_q[87:80];   
    assign   Q_n4_2[7:0]  = int_q[95:88];
    assign   Q_n4_4[7:0]  = int_q[103:96];    
    assign   Q_n5_0[7:0]  = int_q[111:104];
    assign   Q_n5_2[7:0]  = int_q[119:112];
    assign   Q_n5_4[7:0]  = int_q[127:120];    


    ////////////////////////////////////////////////
    ////////////  Constant Assignments  ////////////
    ////////////////////////////////////////////////    
 
//Can have a single control for tx/rx_en_vtc
    assign usr_tx_en_vtc    = 1'b1;
    assign usr_rx_en_vtc    = 1'b1;
    assign usr_en_vtc       = 1'b1;


////////////////////////////////////////
////  VIO Instantiation              ///
////////////////////////////////////////

    
design_1 my_cs ();

vio_0 my_vio (
    .probe_in0(int_prbs_err_all_sync),                          // input wire [0 : 0] probe_in0
    .probe_in1(int_pll_locked_tx_sync),                         // input wire [0 : 0] probe_in1
    .probe_in2(int_pll_locked_rx_sync),                         // input wire [0 : 0] probe_in2
    .probe_in3(int_intf_rdy_tx_sync),                           // input wire [0 : 0] probe_in3
    .probe_in4(int_intf_rdy_rx_sync),                           // input wire [0 : 0] probe_in4
    .probe_in5(int_gen_sync),                                   // input wire [0 : 0] probe_in5
    .probe_in6(int_chk_sync),                                   // input wire [0 : 0] probe_in6
    .probe_in7(int_prbs_valid_sync),                            // input wire [0 : 0] probe_in7
    .probe_out0(int_tx_rst),                                    // output wire [0 : 0] probe_out0
    .probe_out1(int_rx_rst),                                    // output wire [0 : 0] probe_out1
    .probe_out2(int_pll_rst_pll_tx),                            // output wire [0 : 0] probe_out2
    .probe_out3(int_pll_rst_pll_rx),                            // output wire [0 : 0] probe_out3
    .probe_out4(int_inject_err),                                // output wire [0 : 0] probe_out4
    .probe_out5(int_prbs_gen_rst),                              // output wire [0 : 0] probe_out5
    .probe_out6(int_prbs_chk_rst),                              // output wire [0 : 0] probe_out6
    .clk(chipscope_clk_bufg)                                    // input wire clk
);


ila_0 my_ila (
  .clk(chipscope_clk_bufg),                                     // input wire clk
  .probe0(int_intf_rdy_tx_sync),                                // input wire [0 : 0] probe0
  .probe1(int_intf_rdy_rx_sync),                                // input wire [0 : 0] probe1
  .probe2(int_pll_locked_tx_sync),                              // input wire [0 : 0] probe2
  .probe3(int_pll_locked_rx_sync),                              // input wire [0 : 0] probe3
  .probe4(int_prbs_err_all_sync),                               // input wire [0 : 0] probe4
  .probe5(int_prbs_gen_rst),                                    // input wire [0 : 0] probe5
  .probe6(int_prbs_chk_rst),                                    // input wire [0 : 0] probe6
  .probe7(int_gen_sync),                                        // input wire [0 : 0] probe7
  .probe8(int_chk_sync),                                        // input wire [0 : 0] probe8
  .probe9(int_prbs_valid_sync),                                 // input wire [0 : 0] probe9
  .probe10(int_inject_err),                                     // input wire [0 : 0] probe10
  .probe11(int_prbs_err00_sync),                                // input wire [0 : 0] probe11
  .probe12(int_d_clk_fwd_sync[7:0]),                            // input wire [7 : 0] probe12
  .probe13(rcvd_dqs_sync[7:0]),                                 // input wire [7 : 0] probe13
  .probe14(D_n0_0_sync[7:0]),                                   // input wire [7 : 0] probe14
  .probe15(Q_n0_0_sync[7:0])                                    // input wire [7 : 0] probe15
);

    
    ////////////////////////////////////////////////
    ////////      synchronizers             ////////
    ////////////////////////////////////////////////

    //1
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_err_all (
        .dest_out(int_prbs_err_all_sync),   // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_err_all)           // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //2
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_err00 (
        .dest_out(int_prbs_err00_sync),     // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_err00)             // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //3
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_intf_rdy_tx (
        .dest_out(int_intf_rdy_tx_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_intf_rdy_tx)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //4
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_intf_rdy_rx (
        .dest_out(int_intf_rdy_rx_sync),    // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_intf_rdy_rx)            // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //5
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_tx_rst (
        .dest_out(int_tx_rst_sync),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_tx_bufg),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_tx_rst)                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //6
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_rx_rst (
        .dest_out(int_rx_rst_sync),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_rx_bufg),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_rx_rst)                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //7
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_valid (
        .dest_out(int_prbs_valid_sync),     // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_valid)             // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //8
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_locked_tx (
        .dest_out(int_pll_locked_tx_sync),              // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),                  // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0),                            // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_locked_tx)                      // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //9
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_locked_rx (
        .dest_out(int_pll_locked_rx_sync),              // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),                  // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0),                            // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_locked_rx)                      // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //10
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_inject_err (
        .dest_out(int_inject_err_sync),     // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intTxClk0),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_inject_err)             // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //11
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_gen_rst (
        .dest_out(int_prbs_gen_rst_sync),   // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intTxClk0),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_gen_rst)           // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //12
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_chk_rst (
        .dest_out(int_prbs_chk_rst_sync),   // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intRxClk0),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_chk_rst)           // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //13
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_rst_pll (
        .dest_out(int_pll_rst_pll_tx_sync),    // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_tx_bufg),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_rst_pll_tx)            // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //14
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_rst_pll_rx (
        .dest_out(int_pll_rst_pll_rx_sync), // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_rx_bufg),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_rst_pll_rx)         // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //15
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_gen (
        .dest_out(int_gen_sync),            // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_gen)                    // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //16
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_chk (
        .dest_out(int_chk_sync),            // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),      // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0),                // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_chk)                    // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //17
    generate

        for (index_8bit_dataout = 0; index_8bit_dataout < 8; index_8bit_dataout+=1)
            begin: dataout_loop
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_dataout (
                .dest_out(D_n0_0_sync[index_8bit_dataout]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intTxClk0),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(D_n0_0[index_8bit_dataout])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end
   
        for (index_8bit_datain = 0; index_8bit_datain < 8; index_8bit_datain+=1)
            begin: datain_loop
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_datain (
                .dest_out(Q_n0_0_sync[index_8bit_datain]),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),                      // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intRxClk0),                                // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(Q_n0_0[index_8bit_datain])                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end

        for (index_8bit_clk_fwd = 0; index_8bit_clk_fwd < 8; index_8bit_clk_fwd+=1)
            begin: clk_fwd_loop
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_clk_fwd (
                .dest_out(int_d_clk_fwd_sync[index_8bit_clk_fwd]),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),                              // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intTxClk0),                                        // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(int_d_clk_fwd[index_8bit_clk_fwd])                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end
   
        for (index_8bit_rcvd_dqs = 0; index_8bit_rcvd_dqs < 8; index_8bit_rcvd_dqs+=1)
            begin: rcvd_dqs_loop
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_rcvd_dqs (
                .dest_out(rcvd_dqs_sync[index_8bit_rcvd_dqs]),              // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),                              // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intRxClk0),                                        // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(rcvd_dqs[index_8bit_rcvd_dqs])                      // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end

endgenerate
    
    ////////////////////////////////////////
    //////////      FIFO          //////////
    ////////////////////////////////////////
    
    assign int_fifo_rden = ~(int_fifo_empty);
    assign int_fifo_rden_dummy = ~(int_fifo_empty_dummy);

    ///////////////////////////////////////////
    ///   PRBS Generator and Checker       ////
    ///////////////////////////////////////////
        
    always @(posedge intTxClk0)
    begin 
        if (int_intf_rdy_tx &&  !int_prbs_gen_rst_sync)                          // if still in reset,
            begin  
             int_gen <= 1'b1;
            end
        else
            begin  
             int_gen <= 1'b0;
            end
    end
    
    always @(posedge intRxClk0)
    begin 
        if (int_intf_rdy_rx && !int_prbs_chk_rst_sync)                      // if still in reset,
            begin  
             int_chk <= 1'b1;
            end
        else
            begin  
             int_chk <= 1'b0;
            end
    end
    
    //////////////   nibble 0  ////////////////////
    
    Prbs_RxTx inst_prbs00(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (int_inject_err_sync),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n0_0),               // out [C_NumOfBits-1:0]
            .PrbsValid      (int_prbs_valid),       // out 
            .PrbsChk        (Q_n0_0),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err00)        // out
    );
     
    Prbs_RxTx inst_prbs02(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n0_2),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n0_2),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err02)        // out
    );
     
    Prbs_RxTx inst_prbs04(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n0_4),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n0_4),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err04)        // out
    );
    
    //////////////   nibble 1  //////////////////// 
     
    Prbs_RxTx inst_prbs10(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n1_0),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n1_0),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err10)        // out
    );
     
    Prbs_RxTx inst_prbs12(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n1_2),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n1_2),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err12)        // out
    );
     
    Prbs_RxTx inst_prbs14(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n1_4),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n1_4),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err14)        // out
    );
    
    //////////////   nibble 2  //////////////////// 
          
    Prbs_RxTx inst_prbs22(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n2_2),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n2_2),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err22)        // out
    );
     
    Prbs_RxTx inst_prbs24(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n2_4),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n2_4),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err24)        // out
    );
    
    //////////////   nibble 3  //////////////////// 
     
    Prbs_RxTx inst_prbs30(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n3_0),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n3_0),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err30)        // out
    );
     
    Prbs_RxTx inst_prbs32(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n3_2),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n3_2),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err32)        // out
    );
     
    Prbs_RxTx inst_prbs34(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n3_4),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n3_4),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err34)        // out
    );
    
    //////////////   nibble 4  //////////////////// 
          
    Prbs_RxTx inst_prbs42(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n4_2),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n4_2),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err42)        // out
    );
     
    Prbs_RxTx inst_prbs44(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n4_4),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n4_4),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err44)        // out
    );
    
    //////////////   nibble 5  //////////////////// 
     
    Prbs_RxTx inst_prbs50(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n5_0),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n5_0),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err50)        // out
    );
     
    Prbs_RxTx inst_prbs52(    
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n5_2),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n5_2),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err52)        // out
    );
     
    Prbs_RxTx inst_prbs54(
            .ClkInGen       (intTxClk0),            // in
            .ClkInChk       (intRxClk0),            // in
            .RstInGen       (int_prbs_gen_rst_sync),// in
            .RstInChk       (int_prbs_chk_rst_sync),// in
            .InjErr         (Low),                  // in
            .PrbsGenEna     (int_gen),              // in
            .PrbsGen        (D_n5_4),               // out [C_NumOfBits-1:0]
            .PrbsValid      (),                     // out 
            .PrbsChk        (Q_n5_4),               // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk),              // in 
            .PrbsErrDet     (int_prbs_err54)        // out
    );

        
    assign int_prbs_err_00    = ( int_prbs_err00  || int_prbs_err02  || int_prbs_err04  );
    assign int_prbs_err_12    = ( int_prbs_err10  || int_prbs_err12  || int_prbs_err14  || int_prbs_err22  || int_prbs_err24  );
    assign int_prbs_err_34    = ( int_prbs_err32  || int_prbs_err34  || int_prbs_err30  || int_prbs_err42  || int_prbs_err44  );
    assign int_prbs_err_56    = ( int_prbs_err50  || int_prbs_err52  || int_prbs_err54  );
    assign int_prbs_err_all   = (int_prbs_err_00  || int_prbs_err_12 || int_prbs_err_34 || int_prbs_err_56 );   
    
     
endmodule
