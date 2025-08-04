`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: toplevel_testbench_mb
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


module toplevel_testbench_mb();
    
    integer err_mult = 0;
    integer err_cnt = 0;
    integer prbs_v_cnt = 0;
    integer clock_edges = 0;
    real test_size = 0;
    integer no_of_data_lines = 0;
    parameter CLKIN_period = 4.444;         // 225 MHz
    
    reg sim_CLKIN_p;                          // Input Clock
    reg sim_CLKIN_n;                          // Input Clock
    reg sim_inject_error_b0 = 0;               // Injecting Error 
    reg sim_inject_error_b1 = 0;               // Injecting Error 
    reg sim_int_rst;                        // Reset
    
    //Loopback from TX pins to RX pins
    wire loopback1_b0;
    wire loopback2_b0;
    wire loopback3_b0;
    wire loopback4_b0;
    wire loopback5_b0;
    wire loopback6_b0;
    wire loopback7_b0;
    wire loopback8_b0;
    wire loopback9_b0;
    wire loopback10_b0;
    wire loopback1_b1;
    wire loopback2_b1;
    wire loopback3_b1;
    wire loopback4_b1;
    wire loopback5_b1;
    wire loopback6_b1;
    
    
    //DUT Instantiation
    toplevel_sim_mb uut (
       
       .CLKIN_p(sim_CLKIN_p),       		// p-side differential clock
       .CLKIN_n(sim_CLKIN_n),      	   	// n-side differential clock

       .int_rst(sim_int_rst),
       .int_inject_err_b0_p(sim_inject_error_b0),
       .int_inject_err_b1_p(sim_inject_error_b1),
           
	.Tx_data_n0_bs0_p_b0(loopback1_b0), 		// p-side Tx data  PRBS
       	.Tx_data_n0_bs1_n_b0(loopback2_b0),		// n-side Tx data  PRBS
       	.Tx_data_n0_bs2_p_b0(loopback3_b0),		// p-side Tx data  PRBS 
       	.Tx_data_n0_bs3_n_b0(loopback4_b0),		// n-side Tx data  PRBS
       	.Tx_data_n0_bs4_p_b0(loopback5_b0),		// p-side Tx data  PRBS
       	.Tx_data_n0_bs5_n_b0(loopback6_b0),		// n-side Tx data  PRBS       
       	.Tx_data_n1_bs0_p_b0(loopback7_b0),		// p-side Tx data  PRBS
       	.Tx_data_n1_bs1_n_b0(loopback8_b0),		// n-side Tx data  PRBS
       	.Tx_data_n2_bs0_p_b0(loopback9_b0),     	// p-side Transmit Clock
       	.Tx_data_n2_bs1_n_b0(loopback10_b0),    	// n-side Transmit Clock       

	.Tx_data_n0_bs0_p_b1(loopback1_b1), 		// p-side Tx data  PRBS
       	.Tx_data_n0_bs1_n_b1(loopback2_b1),		// n-side Tx data  PRBS
       	.Tx_data_n0_bs2_p_b1(loopback3_b1),		// p-side Tx data  PRBS 
       	.Tx_data_n0_bs3_n_b1(loopback4_b1),		// n-side Tx data  PRBS
       	.Tx_data_n2_bs0_p_b1(loopback5_b1),    		// p-side Transmit Clock
       	.Tx_data_n2_bs1_n_b1(loopback6_b1),    		// n-side Transmit Clock       

	.Rx_data_n0_bs0_p_b0(loopback1_b0), 		// p-side Tx data  PRBS
       	.Rx_data_n0_bs1_n_b0(loopback2_b0),		// n-side Tx data  PRBS
       	.Rx_data_n0_bs2_p_b0(loopback3_b0),		// p-side Tx data  PRBS 
       	.Rx_data_n0_bs3_n_b0(loopback4_b0),		// n-side Tx data  PRBS
       	.Rx_data_n0_bs4_p_b0(loopback5_b0),		// p-side Tx data  PRBS
       	.Rx_data_n0_bs5_n_b0(loopback6_b0),		// n-side Tx data  PRBS       
       	.Rx_data_n1_bs0_p_b0(loopback7_b0), 		// p-side Tx data  PRBS
       	.Rx_data_n1_bs1_n_b0(loopback8_b0),		// n-side Tx data  PRBS
       	.strobe_p_b0(loopback9_b0),     		// p-side Transmit Clock
       	.strobe_n_b0(loopback10_b0),    		// n-side Transmit Clock       

       	.Rx_data_n0_bs0_p_b1(loopback1_b1), 		// p-side Tx data  PRBS
       	.Rx_data_n0_bs1_n_b1(loopback2_b1),		// n-side Tx data  PRBS
       	.Rx_data_n0_bs2_p_b1(loopback3_b1),		// p-side Tx data  PRBS 
       	.Rx_data_n0_bs3_n_b1(loopback4_b1),		// n-side Tx data  PRBS
       	.strobe_p_b1(loopback5_b1),    			// p-side Transmit Clock
       	.strobe_n_b1(loopback6_b1)    			// n-side Transmit Clock       
         
    );
    	
    // generate main Clk for XPLL
    
    always 
    begin
          sim_CLKIN_p = 1'b0;
          sim_CLKIN_n = 1'b1;
          #(CLKIN_period/2) 
          sim_CLKIN_p = 1'b1;
          sim_CLKIN_n = 1'b0;
          #(CLKIN_period/2);
       end
    
    // generate reset signals
    initial 
    begin
    	sim_int_rst <= "1";
    	# (CLKIN_period*300);
    	sim_int_rst = "0";
    	# (CLKIN_period*500);     
    	
    	//Counting the tota number of data lines to calculate the test size   
    	no_of_data_lines = $size(toplevel_testbench_mb.uut.my_Tx_bank.t_Tx_data_b0) * 2;      //x2 because of the differential pair  
    	no_of_data_lines += $size(toplevel_testbench_mb.uut.my_Tx_bank.t_Tx_data_b1) * 2;      //x2 because of the differential pair  
    end

    always @(posedge toplevel_testbench_mb.uut.intTxClk0_b0)
    begin
        if (toplevel_testbench_mb.uut.int_chk_b0 == 1)
            begin
                
                //Counting the number of posedge of toplevel_testbench_mb.uut.intTxClk0_b0            
                clock_edges = clock_edges + 1;
                
                test_size = (clock_edges * no_of_data_lines * 2 * 2)/(8*(10**3));           // x2 because of the DDR sampling and another x2 for 2 banks
                                                                                            // Divide by 8*(10**3) to compute in MB
                $display ("%tus Test Size = %fMB Clock_Edges = %0d No_of_data_lines = %0d", $time, test_size, clock_edges, no_of_data_lines);
            end
    end

    //Placeholder to inject the error. Current Testbench doesn't inject any error.
    /*
    initial
    begin
        for (err_mult = 1; err_mult < 500; err_mult = err_mult + 1)
        begin
                # (CLKIN_period*(500+err_mult));
    	        sim_inject_error_b0 = "0";
    	        sim_inject_error_b1 = "0";
                # (CLKIN_period*(5000+err_mult));
                sim_inject_error_b0 = "1";
                sim_inject_error_b1 = "1";
        end
    end	
    */
	
endmodule
