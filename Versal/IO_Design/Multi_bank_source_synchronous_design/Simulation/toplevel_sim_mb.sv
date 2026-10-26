`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: toplevel_sim_mb
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

module toplevel_sim_mb(

    input    CLKIN_p,
    input    CLKIN_n,


    input    int_rst,
    input    int_inject_err_b0_p,    
    input    int_inject_err_b1_p,    


    /////////////////////Transmitter//////////////////////////////////
    
    output    Tx_data_n0_bs0_p_b0,      	// p-side Tx data  PRBS
    output    Tx_data_n0_bs1_n_b0,		// n-side Tx data  PRBS
    output    Tx_data_n0_bs2_p_b0,      	// p-side Tx data  PRBS
    output    Tx_data_n0_bs3_n_b0,		// n-side Tx data  PRBS
    output    Tx_data_n0_bs4_p_b0,      	// p-side Tx data  PRBS
    output    Tx_data_n0_bs5_n_b0,		// n-side Tx data  PRBS
    output    Tx_data_n1_bs0_p_b0,      	// p-side Tx data  PRBS
    output    Tx_data_n1_bs1_n_b0,		// n-side Tx data  PRBS
    output    Tx_data_n2_bs0_p_b0, 	    	// p-side Transmit Clock
    output    Tx_data_n2_bs1_n_b0,		// n-side Transmit Clock

    output    Tx_data_n0_bs0_p_b1,      	// p-side Tx data  PRBS
    output    Tx_data_n0_bs1_n_b1,		// n-side Tx data  PRBS
    output    Tx_data_n0_bs2_p_b1,      	// p-side Tx data  PRBS
    output    Tx_data_n0_bs3_n_b1,		// n-side Tx data  PRBS
    output    Tx_data_n2_bs0_p_b1, 	    	// p-side Transmit Clock
    output    Tx_data_n2_bs1_n_b1,		// n-side Transmit Clock

    /////////////////////Receiver//////////////////////////////////
    
    input    Rx_data_n0_bs0_p_b0, 		// p-side Rx data  PRBS
    input    Rx_data_n0_bs1_n_b0,		// n-side Rx data  PRBS
    input    Rx_data_n0_bs2_p_b0, 		// p-side Rx data  PRBS
    input    Rx_data_n0_bs3_n_b0,		// n-side Rx data  PRBS
    input    Rx_data_n0_bs4_p_b0, 		// p-side Rx data  PRBS
    input    Rx_data_n0_bs5_n_b0,		// n-side Rx data  PRBS
    input    Rx_data_n1_bs0_p_b0, 		// p-side Rx data  PRBS
    input    Rx_data_n1_bs1_n_b0,		// n-side Rx data  PRBS
    input    strobe_p_b0, 	           	// p-side Rx data  Strobe
    input    strobe_n_b0, 	            	// n-side Rx data  Strobe

    input    Rx_data_n0_bs0_p_b1, 		// p-side Rx data  PRBS
    input    Rx_data_n0_bs1_n_b1,		// n-side Rx data  PRBS
    input    Rx_data_n0_bs2_p_b1, 		// p-side Rx data  PRBS
    input    Rx_data_n0_bs3_n_b1,		// n-side Rx data  PRBS
    input    strobe_p_b1, 	            	// p-side Rx data  Strobe
    input    strobe_n_b1 	            	// n-side Rx data  Strobe

    );
   
    ////////////////////////////////////////////////////////////////////////////   

    parameter    Low = 1'b0;
    parameter    High = 1'b1;
    parameter    Simulation_o = 1;
    
    wire [3:0]   p_side_iob_tx_b0;
    wire [3:0]   n_side_iob_tx_b0;
    wire [1:0]   p_side_iob_tx_b1;
    wire [1:0]   n_side_iob_tx_b1;
    wire         p_side_strobe_tx_iob_b0;
    wire         n_side_strobe_tx_iob_b0;
    wire         p_side_strobe_tx_iob_b1;
    wire         n_side_strobe_tx_iob_b1;
    
    wire [3:0]   p_side_iob_rx_b0;
    wire [3:0]   n_side_iob_rx_b0;
    wire [1:0]   p_side_iob_rx_b1;
    wire [1:0]   n_side_iob_rx_b1;
    wire         p_side_strobe_rx_iob_b0;
    wire         n_side_strobe_rx_iob_b0;
    wire         p_side_strobe_rx_iob_b1;
    wire         n_side_strobe_rx_iob_b1;
    
    reg  [7:0]   dummy_data;
    reg  [7:0]   dummy_strobe;
    
    reg  [31:0]  int_d_b0;
    reg  [7:0]   int_d_clk_fwd_b0;
    reg  [7:0]   int_d_clk_fwd_b0_sync;
    reg  [15:0]  int_d_b1;
    reg  [7:0]   int_d_clk_fwd_b1;
    reg  [7:0]   int_d_clk_fwd_b1_sync;

    reg  [31:0]  int_q_b0;
    reg  [15:0]  int_q_b1;

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

    wire         int_inject_err_b0;
    wire         int_inject_err_b1;
    wire         int_inject_err_b0_sync;
    wire         int_inject_err_b1_sync;

    wire         int_prbs_gen_rst_b0;
    wire         int_prbs_gen_rst_b0_sync;
    wire         int_prbs_gen_rst_b1;
    wire         int_prbs_gen_rst_b1_sync;

    wire         int_prbs_chk_rst_b0;
    wire         int_prbs_chk_rst_b0_sync;
    wire         int_prbs_chk_rst_b1;
    wire         int_prbs_chk_rst_b1_sync;

    wire         int_rx_rst;
    wire         int_rx_rst_sync;

    wire         int_pll_rst_pll_tx_b0;
    wire         int_pll_rst_pll_rx_b0;
    wire         int_pll_rst_pll_tx_b1;
    wire         int_pll_rst_pll_rx_b1;
    wire         int_pll_rst_pll_tx_b0_sync;
    wire         int_pll_rst_pll_rx_b0_sync;
    wire         int_pll_rst_pll_tx_b1_sync;
    wire         int_pll_rst_pll_rx_b1_sync;
     
    wire         int_fifo_empty;
    reg          int_fifo_rden;
    wire         int_fifo_empty_dummy;
    reg          int_fifo_rden_dummy;
    wire [7:0]   rcvd_dqs_b0;
    wire [7:0]   rcvd_dqs_b1;
    wire [7:0]   rcvd_dqs_b0_sync;
    wire [7:0]   rcvd_dqs_b1_sync;
    
    wire         intTxClk0_b0;
    wire         intRxClk0_b0;
    wire         intTxClk0_b1;
    wire         intRxClk0_b1;
    
    wire         int_mmcm_clk;

    reg          int_gen_b0;
    reg          int_chk_b0;
    reg          int_gen_b1;
    reg          int_chk_b1;

    genvar          index_8bit_dataout_b0;
    genvar          index_8bit_datain_b0;
    genvar          index_8bit_clk_fwd_b0;
    genvar          index_8bit_rcvd_dqs_b0;
    genvar          index_8bit_dataout_b1;
    genvar          index_8bit_datain_b1;
    genvar          index_8bit_clk_fwd_b1;
    genvar          index_8bit_rcvd_dqs_b1;

    reg  [7:0]      D_n0_0_b0_sync;     
    reg  [7:0]      Q_n0_0_b0_sync;     
    reg  [7:0]      D_n0_0_b1_sync;     
    reg  [7:0]      Q_n0_0_b1_sync;     
    
    ////////////////////////////////////////////////////////////
    
    reg [7:0] D_n0_0_b0, D_n0_1_b0, D_n0_2_b0, D_n0_3_b0, D_n0_4_b0, D_n0_5_b0;
    reg [7:0] D_n1_0_b0, D_n1_1_b0;

    reg [7:0] D_n0_0_b1, D_n0_1_b1, D_n0_2_b1, D_n0_3_b1, D_n0_4_b1, D_n0_5_b1;

    ////////////////////////////////////////////////////////////
    
    reg [7:0] Q_n0_0_b0, Q_n0_1_b0, Q_n0_2_b0, Q_n0_3_b0, Q_n0_4_b0, Q_n0_5_b0;
    reg [7:0] Q_n1_0_b0, Q_n1_1_b0;

    reg [7:0] Q_n0_0_b1, Q_n0_1_b1, Q_n0_2_b1, Q_n0_3_b1, Q_n0_4_b1, Q_n0_5_b1;

        
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

    Tx_2bank_ssync_intrfce  my_Tx_bank (
      
      .intf_rdy(int_intf_rdy_tx),                                       // output wire intf_rdy  
      .ctrl_clk(intTxClk0_b0),                                          // input wire ctrl_clk
      .en_vtc(usr_tx_en_vtc),                                           // input wire en_vtc
      .bank0_pll_clkout0(intTxClk0_b0),                                 // output wire bank0_pll_clkout0
      .bank0_pll_locked(int_pll_locked_tx_b0),                          // output wire bank0_pll_locked
      .bank1_pll_clkout0(intTxClk0_b1),                                 // output wire bank1_pll_clkout0
      .bank1_pll_locked(int_pll_locked_tx_b1),                          // output wire bank1_pll_locked
      .bank0_pll_clkin(int_clkin_tx_bufg),                              // input wire bank0_pll_clkin
      .bank1_pll_clkin(int_clkin_tx_bufg),                              // input wire bank1_pll_clkin
      .rst(int_rst),                                                  // input wire rst
      .bank0_pll_rst_pll(int_rst),                                    // input wire bank0_pll_rst_pll
      .bank1_pll_rst_pll(int_rst),                                    // input wire bank1_pll_rst_pll
      .dly_rdy(int_dly_rdy),                                            // output wire dly_rdy
      .phy_rdy(int_phy_rdy),                                            // output wire phy_rdy
      .Tx_data_b0_p(p_side_iob_tx_b0[3:0]),                             // output wire [3 : 0] Tx_data_b0_p
      .Tx_data_b0_n(n_side_iob_tx_b0[3:0]),                             // output wire [3 : 0] Tx_data_b0_n    
      .t_Tx_data_b0({4'b0}),                                            // input wire [3 : 0] t_Tx_data_b0
      .data_from_fabric_Tx_data_b0(int_d_b0[31:0]),                     // input wire [31 : 0] data_from_fabric_Tx_data_b0
      .Clk_fwd_b0_p(p_side_strobe_tx_iob_b0),                           // output wire [0 : 0] Clk_fwd_b0_p
      .Clk_fwd_b0_n(n_side_strobe_tx_iob_b0),                           // output wire [0 : 0] Clk_fwd_b0_n
      .t_Clk_fwd_b0({1'b0}),                                            // input wire [0 : 0] t_Clk_fwd_b0
      .data_from_fabric_Clk_fwd_b0(int_d_clk_fwd_b0[7:0]),              // input wire [7 : 0] data_from_fabric_Clk_fwd_b0
      .Tx_data_b1_p(p_side_iob_tx_b1[1:0]),                             // output wire [1 : 0] Tx_data_b1_p
      .Tx_data_b1_n(n_side_iob_tx_b1[1:0]),                             // output wire [1 : 0] Tx_data_b1_n
      .t_Tx_data_b1({2'b0}),                                            // input wire [1 : 0] t_Tx_data_b1
      .data_from_fabric_Tx_data_b1(int_d_b1[15:0]),                     // input wire [15 : 0] data_from_fabric_Tx_data_b1
      .Clk_fwd_b1_p(p_side_strobe_tx_iob_b1),                           // output wire [0 : 0] Clk_fwd_b1_p
      .Clk_fwd_b1_n(n_side_strobe_tx_iob_b1),                           // output wire [0 : 0] Clk_fwd_b1_n
      .t_Clk_fwd_b1({1'b0}),                                            // input wire [0 : 0] t_Clk_fwd_b1
      .data_from_fabric_Clk_fwd_b1(int_d_clk_fwd_b1[7:0])               // input wire [7 : 0] data_from_fabric_Clk_fwd_b1
    );

    //////////////////////////////////////////////////////
    /////////////  Instantiation of Rx_bank //////////////
    //////////////////////////////////////////////////////
    
    Rx_2bank_ssync_intrfce my_Rx_bank (
    
      .intf_rdy(int_intf_rdy_rx),                                       // output wire intf_rdy  
      .ctrl_clk(intRxClk0_b0),                                          // input wire ctrl_clk
      .en_vtc(usr_tx_en_vtc),                                           // input wire en_vtc
      .fifo_rd_clk(intRxClk0_b0),                                       // input wire fifo_rd_clk
      .bank0_pll_clkout0(intRxClk0_b0),                                 // output wire bank0_pll_clkout0
      .bank0_pll_locked(int_pll_locked_rx_b0),                          // output wire bank0_pll_locked
      .bank1_pll_clkout0(intRxClk0_b1),                                 // output wire bank1_pll_clkout0
      .bank1_pll_locked(int_pll_locked_rx_b1),                          // output wire bank1_pll_locked
      .bank0_pll_clkin(int_clkin_rx_bufg),                              // input wire bank0_pll_clkin
      .bank1_pll_clkin(int_clkin_rx_bufg),                              // input wire bank1_pll_clkin
      .rst(int_rst | !int_intf_rdy_tx),                               // input wire rst
      .bank0_pll_rst_pll(int_rst),                                    // input wire bank0_pll_rst_pll
      .bank1_pll_rst_pll(int_rst),                                    // input wire bank1_pll_rst_pll
      .dly_rdy(int_dly_rdy_rx),                                         // output wire dly_rdy
      .phy_rdy(int_phy_rdy_rx),                                         // output wire phy_rdy
      .fifo_empty(int_fifo_empty),                                      // output wire fifo_empty
      .fifo_rd_en(int_fifo_rden),                                       // input wire fifo_rd_en  
      .Rx_data_b0_p(p_side_iob_rx_b0[3:0]),                             // input wire [3 : 0] Rx_data_b0_p
      .Rx_data_b0_n(n_side_iob_rx_b0[3:0]),                             // input wire [3 : 0] Rx_data_b0_n
      .data_to_fabric_Rx_data_b0(int_q_b0[31:0]),                       // output wire [31 : 0] data_to_fabric_Rx_data_b0
      .strobe_b0_p(p_side_strobe_rx_iob_b0),                            // input wire [0 : 0] strobe_b0_p
      .strobe_b0_n(n_side_strobe_rx_iob_b0),                            // input wire [0 : 0] strobe_b0_n
      .data_to_fabric_strobe_b0(rcvd_dqs_b0[7:0]),                      // output wire [7 : 0] data_to_fabric_strobe_b0
      .Rx_data_b1_p(p_side_iob_rx_b1[1:0]),                             // input wire [1 : 0] Rx_data_b1_p
      .Rx_data_b1_n(n_side_iob_rx_b1[1:0]),                             // input wire [1 : 0] Rx_data_b1_n
      .data_to_fabric_Rx_data_b1(int_q_b1[15:0]),                       // output wire [15 : 0] data_to_fabric_Rx_data_b1
      .strobe_b1_p(p_side_strobe_rx_iob_b1),                            // input wire [0 : 0] strobe_b1_p
      .strobe_b1_n(n_side_strobe_rx_iob_b1),                            // input wire [0 : 0] strobe_b1_n
      .data_to_fabric_strobe_b1(rcvd_dqs_b1[7:0])                       // output wire [7 : 0] data_to_fabric_strobe_b1
    );

    ///////////////////////////////////////////////
    ///////////////       TX       ////////////////
    ///////////////////////////////////////////////
    
    
    assign Tx_data_n0_bs0_p_b0 = p_side_iob_tx_b0[0];
    assign Tx_data_n0_bs2_p_b0 = p_side_iob_tx_b0[1];
    assign Tx_data_n0_bs4_p_b0 = p_side_iob_tx_b0[2];
    assign Tx_data_n1_bs0_p_b0 = p_side_iob_tx_b0[3];
    assign Tx_data_n2_bs0_p_b0 = p_side_strobe_tx_iob_b0;

    assign Tx_data_n0_bs0_p_b1 = p_side_iob_tx_b1[0];
    assign Tx_data_n0_bs2_p_b1 = p_side_iob_tx_b1[1];
    assign Tx_data_n2_bs0_p_b1 = p_side_strobe_tx_iob_b1;

    //////////////////////////////////////////

    assign Tx_data_n0_bs1_n_b0 = n_side_iob_tx_b0[0];
    assign Tx_data_n0_bs3_n_b0 = n_side_iob_tx_b0[1];
    assign Tx_data_n0_bs5_n_b0 = n_side_iob_tx_b0[2];
    assign Tx_data_n1_bs1_n_b0 = n_side_iob_tx_b0[3];
    assign Tx_data_n2_bs1_n_b0 = n_side_strobe_tx_iob_b0;

    assign Tx_data_n0_bs1_n_b1 = n_side_iob_tx_b1[0];
    assign Tx_data_n0_bs3_n_b1 = n_side_iob_tx_b1[1];
    assign Tx_data_n2_bs1_n_b1 = n_side_strobe_tx_iob_b1;
       
    ///////////////////////////////////////////////
    
    assign  int_d_b0[7:0]           = D_n0_0_b0[7:0];
    assign  int_d_b0[15:8]          = D_n0_2_b0[7:0];
    assign  int_d_b0[23:16]         = D_n0_4_b0[7:0];
    assign  int_d_b0[31:24]         = D_n1_0_b0[7:0];
    assign  int_d_clk_fwd_b0[7:0]   = 8'h55;                               // Transmit Clock         

    assign  int_d_b1[7:0]     = D_n0_0_b1[7:0];
    assign  int_d_b1[15:8]     = D_n0_2_b1[7:0];
    assign  int_d_clk_fwd_b1[7:0]   = 8'h55;                               // Transmit Clock         
    
    ///////////////////////////////////////////////
    ///////////////       RX       ////////////////
    ///////////////////////////////////////////////
    
    
    assign p_side_iob_rx_b0[0]     = Rx_data_n0_bs0_p_b0;
    assign p_side_iob_rx_b0[1]     = Rx_data_n0_bs2_p_b0;
    assign p_side_iob_rx_b0[2]     = Rx_data_n0_bs4_p_b0;
    assign p_side_iob_rx_b0[3]     = Rx_data_n1_bs0_p_b0;
    assign p_side_strobe_rx_iob_b0 = strobe_p_b0;

    assign p_side_iob_rx_b1[0] = Rx_data_n0_bs0_p_b1;
    assign p_side_iob_rx_b1[1] = Rx_data_n0_bs2_p_b1;
    assign p_side_strobe_rx_iob_b1 = strobe_p_b1;

    //////////////////////////////////////////
    
    assign n_side_iob_rx_b0[0] = Rx_data_n0_bs1_n_b0;
    assign n_side_iob_rx_b0[1] = Rx_data_n0_bs3_n_b0;
    assign n_side_iob_rx_b0[2] = Rx_data_n0_bs5_n_b0;
    assign n_side_iob_rx_b0[3] = Rx_data_n1_bs1_n_b0;
    assign n_side_strobe_rx_iob_b0 = strobe_n_b0;

    assign n_side_iob_rx_b1[0] = Rx_data_n0_bs1_n_b1;
    assign n_side_iob_rx_b1[1] = Rx_data_n0_bs3_n_b1;
    assign n_side_strobe_rx_iob_b1 = strobe_n_b1;

    ///////////////////////////////////////////////

    assign   Q_n0_0_b0[7:0]  = int_q_b0[7:0];
    assign   Q_n0_2_b0[7:0]  = int_q_b0[15:8];
    assign   Q_n0_4_b0[7:0]  = int_q_b0[23:16];
    assign   Q_n1_0_b0[7:0]  = int_q_b0[31:24];

    assign   Q_n0_0_b1[7:0]  = int_q_b1[7:0];
    assign   Q_n0_2_b1[7:0]  = int_q_b1[15:8];

         
    ////////////////////////////////////////////////
    ////////////  Constant Assignments  ////////////
    ////////////////////////////////////////////////    
 
//Can have a single control for tx/rx_en_vtc
    assign usr_tx_en_vtc    = 1'b1;
    assign usr_rx_en_vtc    = 1'b1;
    assign usr_en_vtc       = 1'b1;

    
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
        .dest_out(int_prbs_err_all_sync),           // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b0),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_err_all)                   // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //2
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_err00_b0 (
        .dest_out(int_prbs_err00_b0_sync),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b0),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_err00_b0)                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //3
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_intf_rdy_tx (
        .dest_out(int_intf_rdy_tx_sync),            // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b0),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_intf_rdy_tx)                    // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //4
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_intf_rdy_rx (
        .dest_out(int_intf_rdy_rx_sync),            // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b0),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_intf_rdy_rx)                    // 1-bit input: Input signal to be synchronized to dest_clk domain.
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
        .dest_clk(int_clkin_tx_bufg),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),                       // 1-bit input: optional; required when SRC_INPUT_REG = 1
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
        .dest_clk(int_clkin_rx_bufg),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),                       // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_rx_rst)                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //7
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_valid_b0 (
        .dest_out(int_prbs_valid_b0_sync),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b0),                      // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_valid_b0)                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //8
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_locked_tx_b0 (
        .dest_out(int_pll_locked_tx_b0_sync),        // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b0),                      // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_locked_tx_b0)                // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //9
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_locked_rx_b0 (
        .dest_out(int_pll_locked_rx_b0_sync),        // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b0),                      // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_locked_rx_b0)                // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //10
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_inject_err_b0 (
        .dest_out(int_inject_err_b0_sync),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intTxClk0_b0),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),               // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_inject_err_b0)                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //11
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_gen_rst_b0 (
        .dest_out(int_prbs_gen_rst_b0_sync),        // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intTxClk0_b0),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),               // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_gen_rst_b0)                // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //12
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_chk_rst_b0 (
        .dest_out(int_prbs_chk_rst_b0_sync),        // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intRxClk0_b0),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),               // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_chk_rst_b0)                // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //13
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_inject_err_b1 (
        .dest_out(int_inject_err_b1_sync),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intTxClk0_b1),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),               // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_inject_err_b1)                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //14
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_err00_b1 (
        .dest_out(int_prbs_err00_b1_sync),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b1),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_err00_b1)                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //15
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_gen_b0 (
        .dest_out(int_gen_b0_sync),                 // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b0),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_gen_b0)                         // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //16
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_chk_b0 (
        .dest_out(int_chk_b0_sync),                 // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b0),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_chk_b0)                         // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //17
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_gen_rst_b1 (
        .dest_out(int_prbs_gen_rst_b1_sync),        // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intTxClk0_b1),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),               // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_gen_rst_b1)                // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //18
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_chk_rst_b1 (
        .dest_out(int_prbs_chk_rst_b1_sync),        // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(intRxClk0_b1),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),               // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_chk_rst_b1)                // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //19
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_gen_b1 (
        .dest_out(int_gen_b1_sync),                 // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b1),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_gen_b1)                         // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //20
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_chk_b1 (
        .dest_out(int_chk_b1_sync),                 // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b1),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_chk_b1)                         // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //21
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_prbs_valid_b1 (
        .dest_out(int_prbs_valid_b1_sync),          // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b1),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_prbs_valid_b1)                  // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //22
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_locked_rx_b1 (
        .dest_out(int_pll_locked_rx_b1_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intRxClk0_b1),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_locked_rx_b1)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //23
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_locked_tx_b1 (
        .dest_out(int_pll_locked_tx_b1_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(chipscope_clk_bufg),              // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(intTxClk0_b1),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_locked_tx_b1)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //24
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_rst_pll_tx_b0 (
        .dest_out(int_pll_rst_pll_tx_b0_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_tx_bufg),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_rst_pll_tx_b0)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

     //25
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_rst_pll_rx_b0 (
        .dest_out(int_pll_rst_pll_rx_b0_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_rx_bufg),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_rst_pll_rx_b0)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //26
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_rst_pll_tx_b1 (
        .dest_out(int_pll_rst_pll_tx_b1_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_tx_bufg),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_rst_pll_tx_b1)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

     //27
    xpm_cdc_single #(
        .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
        .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
        .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
    )
    xpm_cdc_int_pll_rst_pll_rx_b1 (
        .dest_out(int_pll_rst_pll_rx_b1_sync),       // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
        .dest_clk(int_clkin_rx_bufg),                    // 1-bit input: Clock signal for the destination clock domain.
        .src_clk(chipscope_clk_bufg),                     // 1-bit input: optional; required when SRC_INPUT_REG = 1
        .src_in(int_pll_rst_pll_rx_b1)               // 1-bit input: Input signal to be synchronized to dest_clk domain.
    );

    //28
    generate

        for (index_8bit_dataout_b0 = 0; index_8bit_dataout_b0 < 8; index_8bit_dataout_b0+=1)
            begin: dataout_loop_b0
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_dataout_b0 (
                .dest_out(D_n0_0_b0_sync[index_8bit_dataout_b0]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intTxClk0_b0),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(D_n0_0_b0[index_8bit_dataout_b0])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end
   
        for (index_8bit_datain_b0 = 0; index_8bit_datain_b0 < 8; index_8bit_datain_b0+=1)
            begin: datain_loop_b0
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_datain_b0 (
                .dest_out(Q_n0_0_b0_sync[index_8bit_datain_b0]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intRxClk0_b0),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(Q_n0_0_b0[index_8bit_datain_b0])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end

        for (index_8bit_clk_fwd_b0 = 0; index_8bit_clk_fwd_b0 < 8; index_8bit_clk_fwd_b0+=1)
            begin: clk_fwd_loop_b0
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_clk_fwd_b0 (
                .dest_out(int_d_clk_fwd_b0_sync[index_8bit_clk_fwd_b0]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intTxClk0_b0),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(int_d_clk_fwd_b0[index_8bit_clk_fwd_b0])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end
   
        for (index_8bit_rcvd_dqs_b0 = 0; index_8bit_rcvd_dqs_b0 < 8; index_8bit_rcvd_dqs_b0+=1)
            begin: rcvd_dqs_loop_b0
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_rcvd_dqs_b0 (
                .dest_out(rcvd_dqs_b0_sync[index_8bit_rcvd_dqs_b0]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intRxClk0_b0),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(rcvd_dqs_b0[index_8bit_rcvd_dqs_b0])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end

        for (index_8bit_dataout_b1 = 0; index_8bit_dataout_b1 < 8; index_8bit_dataout_b1+=1)
            begin: dataout_loop_b1
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_dataout_b1 (
                .dest_out(D_n0_0_b1_sync[index_8bit_dataout_b1]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intTxClk0_b1),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(D_n0_0_b1[index_8bit_dataout_b1])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end
   
        for (index_8bit_datain_b1 = 0; index_8bit_datain_b1 < 8; index_8bit_datain_b1+=1)
            begin: datain_loop_b1
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_datain_b1 (
                .dest_out(Q_n0_0_b1_sync[index_8bit_datain_b1]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intRxClk0_b1),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(Q_n0_0_b1[index_8bit_datain_b1])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end

        for (index_8bit_clk_fwd_b1 = 0; index_8bit_clk_fwd_b1 < 8; index_8bit_clk_fwd_b1+=1)
            begin: clk_fwd_loop_b1
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_clk_fwd_b1 (
                .dest_out(int_d_clk_fwd_b1_sync[index_8bit_clk_fwd_b1]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intTxClk0_b1),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(int_d_clk_fwd_b1[index_8bit_clk_fwd_b1])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end
   
        for (index_8bit_rcvd_dqs_b1 = 0; index_8bit_rcvd_dqs_b1 < 8; index_8bit_rcvd_dqs_b1+=1)
            begin: rcvd_dqs_loop_b1
            xpm_cdc_single #(
                .DEST_SYNC_FF(2),                   // DECIMAL; range: 2-10
                .INIT_SYNC_FF(0),                   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
                .SIM_ASSERT_CHK(0),                 // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
                .SRC_INPUT_REG(0)                   // DECIMAL; 0=do not register input, 1=register input
            )
            xpm_cdc_int_rcvd_dqs_b1 (
                .dest_out(rcvd_dqs_b1_sync[index_8bit_rcvd_dqs_b1]),         // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
                .dest_clk(chipscope_clk_bufg),               // 1-bit input: Clock signal for the destination clock domain.
                .src_clk(intRxClk0_b1),       // 1-bit input: optional; required when SRC_INPUT_REG = 1
                .src_in(rcvd_dqs_b1[index_8bit_rcvd_dqs_b1])                 // 1-bit input: Input signal to be synchronized to dest_clk domain.
            );
        end

endgenerate


    
    ////////////////////////////////////////
    //////////      FIFO          //////////
    ////////////////////////////////////////
    
    assign int_fifo_rden = ~(int_fifo_empty);
    assign int_fifo_rden_dummy = ~(int_fifo_empty_dummy);
            
    ////////////////////////////////////////
    //////////  For Simulation    //////////
    ////////////////////////////////////////

    
    assign int_prbs_gen_rst_b0 = 1'b0;
    assign int_prbs_chk_rst_b0 = 1'b0;
    assign int_prbs_gen_rst_b1 = 1'b0;
    assign int_prbs_chk_rst_b1 = 1'b0;
    
    ///////////////////////////////////////////
    ///   PRBS Generator and Checker       ////
    ///////////////////////////////////////////
        
    always @(posedge intTxClk0_b0)
    begin 
        if (int_intf_rdy_tx &&  !int_prbs_gen_rst_b0)                     // if still in reset,
            begin  
             int_gen_b0 <= 1'b1;
            end
        else
            begin  
             int_gen_b0 <= 1'b0;
            end
    end
        
    always @(posedge intTxClk0_b1)
    begin 
        if (int_intf_rdy_tx &&  !int_prbs_gen_rst_b1)                     // if still in reset,
            begin  
             int_gen_b1 <= 1'b1;
            end
        else
            begin  
             int_gen_b1 <= 1'b0;
            end
    end
    
    always @(posedge intRxClk0_b0)
    begin 
        if (int_intf_rdy_rx && !int_prbs_chk_rst_b0)                      // if still in reset,
            begin  
             int_chk_b0 <= 1'b1;
            end
        else
            begin  
             int_chk_b0 <= 1'b0;
            end
    end
    
    always @(posedge intRxClk0_b1)
    begin 
        if (int_intf_rdy_rx && !int_prbs_chk_rst_b1)                      // if still in reset,
            begin  
             int_chk_b1 <= 1'b1;
            end
        else
            begin  
             int_chk_b1 <= 1'b0;
            end
    end
    
    ///////////////////////
    ///      Bank0      ///
    ///////////////////////

    //////////////   nibble 0  ////////////////////
    
    Prbs_RxTx inst_prbs00_b0(    
            .ClkInGen       (intTxClk0_b0),                 // in
            .ClkInChk       (intRxClk0_b0),                 // in
            .RstInGen       (int_prbs_gen_rst_b0),     // in
            .RstInChk       (int_prbs_chk_rst_b0),     // in
            .InjErr         (int_inject_err_b0_p),        // in
            .PrbsGenEna     (int_gen_b0),                   // in
            .PrbsGen        (D_n0_0_b0),                    // out [C_NumOfBits-1:0]
            .PrbsValid      (int_prbs_valid_b0),            // out 
            .PrbsChk        (Q_n0_0_b0),                    // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk_b0),                   // in 
            .PrbsErrDet     (int_prbs_err00_b0)             // out
    );
     
    Prbs_RxTx inst_prbs02_b0(    
            .ClkInGen       (intTxClk0_b0),                 // in
            .ClkInChk       (intRxClk0_b0),                 // in
            .RstInGen       (int_prbs_gen_rst_b0),     // in
            .RstInChk       (int_prbs_chk_rst_b0),     // in
            .InjErr         (Low),                          // in
            .PrbsGenEna     (int_gen_b0),                   // in
            .PrbsGen        (D_n0_2_b0),                    // out [C_NumOfBits-1:0]
            .PrbsValid      (),                             // out 
            .PrbsChk        (Q_n0_2_b0),                    // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk_b0),                   // in 
            .PrbsErrDet     (int_prbs_err02_b0)             // out
    );
     
    Prbs_RxTx inst_prbs04_b0(
            .ClkInGen       (intTxClk0_b0),                 // in
            .ClkInChk       (intRxClk0_b0),                 // in
            .RstInGen       (int_prbs_gen_rst_b0),     // in
            .RstInChk       (int_prbs_chk_rst_b0),     // in
            .InjErr         (Low),                          // in
            .PrbsGenEna     (int_gen_b0),                   // in
            .PrbsGen        (D_n0_4_b0),                    // out [C_NumOfBits-1:0]
            .PrbsValid      (),                             // out 
            .PrbsChk        (Q_n0_4_b0),                    // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk_b0),                   // in 
            .PrbsErrDet     (int_prbs_err04_b0)             // out
    );
    
    //////////////   nibble 1  //////////////////// 
     
    Prbs_RxTx inst_prbs10_b0(
            .ClkInGen       (intTxClk0_b0),                 // in
            .ClkInChk       (intRxClk0_b0),                 // in
            .RstInGen       (int_prbs_gen_rst_b0),     // in
            .RstInChk       (int_prbs_chk_rst_b0),     // in
            .InjErr         (Low),                          // in
            .PrbsGenEna     (int_gen_b0),                   // in
            .PrbsGen        (D_n1_0_b0),                    // out [C_NumOfBits-1:0]
            .PrbsValid      (),                             // out 
            .PrbsChk        (Q_n1_0_b0),                    // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk_b0),                   // in 
            .PrbsErrDet     (int_prbs_err10_b0)             // out
    );
     
    
    ///////////////////////
    ///      Bank1      ///
    ///////////////////////

    //////////////   nibble 0  ////////////////////
    
    Prbs_RxTx inst_prbs00_b1(    
            .ClkInGen       (intTxClk0_b0),                 // in
            .ClkInChk       (intRxClk0_b0),                 // in
            .RstInGen       (int_prbs_gen_rst_b0),     // in
            .RstInChk       (int_prbs_chk_rst_b0),     // in
            .InjErr         (int_inject_err_b1_p),          // in
            .PrbsGenEna     (int_gen_b0),                   // in
            .PrbsGen        (D_n0_0_b1),                    // out [C_NumOfBits-1:0]
            .PrbsValid      (int_prbs_valid_b1),            // out 
            .PrbsChk        (Q_n0_0_b1),                    // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk_b0),                   // in 
            .PrbsErrDet     (int_prbs_err00_b1)             // out
    );

    Prbs_RxTx inst_prbs02_b1(    
            .ClkInGen       (intTxClk0_b0),                 // in
            .ClkInChk       (intRxClk0_b0),                 // in
            .RstInGen       (int_prbs_gen_rst_b0),     // in
            .RstInChk       (int_prbs_chk_rst_b0),     // in
            .InjErr         (Low),                          // in
            .PrbsGenEna     (int_gen_b0),                   // in
            .PrbsGen        (D_n0_2_b1),                    // out [C_NumOfBits-1:0]
            .PrbsValid      (),                             // out 
            .PrbsChk        (Q_n0_2_b1),                    // in  [C_NumOfBits-1:0]
            .PrbsChkEna     (int_chk_b0),                   // in 
            .PrbsErrDet     (int_prbs_err02_b1)             // out
    );


    assign int_prbs_err_00_b0    = ( int_prbs_err00_b0  || int_prbs_err02_b0  || int_prbs_err04_b0  );
    assign int_prbs_err_12_b0    = ( int_prbs_err10_b0 );
    
    assign int_prbs_err_00_b1    = int_prbs_err00_b1 || int_prbs_err02_b1;
    
    assign int_prbs_err_all   = (int_prbs_err_00_b0  || int_prbs_err_12_b0  || int_prbs_err_00_b1);    
    
     
endmodule
