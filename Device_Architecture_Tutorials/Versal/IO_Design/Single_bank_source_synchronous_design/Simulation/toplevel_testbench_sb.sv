`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: toplevel_testbench_sb
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


module toplevel_testbench_sb();
    
    integer err_mult = 0;
    integer err_cnt = 0;
    integer prbs_v_cnt = 0;
    integer clock_edges = 0;
    real test_size = 0;
    integer no_of_data_lines = 0;
    parameter CLKIN_period = 4.444;         // 225 MHz
    
    reg sim_CLKIN_p;                        // Input Clock
    reg sim_CLKIN_n;                        // Input Clock
    reg sim_inject_error = 0;               // Injecting Error 
    reg sim_int_rst;                        // Reset
    
    //Loopback from TX pins to RX pins
    wire loopback1;
    wire loopback2;
    wire loopback3;
    wire loopback4;
    wire loopback5;
    wire loopback6;
    wire loopback7;
    wire loopback8;
    wire loopback9;
    wire loopback10;
    wire loopback11;
    wire loopback12;
    wire loopback13;
    wire loopback14;
    wire loopback15;
    wire loopback16;
    wire loopback17;
    wire loopback18;
    wire loopback19;
    wire loopback20;
    wire loopback21;
    wire loopback22;
    wire loopback23;
    wire loopback24;
    wire loopback25;
    wire loopback26;
    wire loopback27;
    wire loopback28;
    wire loopback29;
    wire loopback30;
    wire loopback31;
    wire loopback32;
    wire loopback33;
    wire loopback34;
    
    //DUT Instantiation
    toplevel_sim_sb uut (
       
       .CLKIN_p(sim_CLKIN_p),       		// p-side differential clock
       .CLKIN_n(sim_CLKIN_n),      		    // n-side differential clock

       .int_rst(sim_int_rst),
       .int_inject_err_p(sim_inject_error),

       .Tx_data_n0_bs0_p(loopback1), 		// p-side Tx data  PRBS
       .Tx_data_n0_bs1_n(loopback2),		// n-side Tx data  PRBS
       .Tx_data_n0_bs2_p(loopback3),		// p-side Tx data  PRBS 
       .Tx_data_n0_bs3_n(loopback4),		// n-side Tx data  PRBS
       .Tx_data_n0_bs4_p(loopback5),		// p-side Tx data  PRBS
       .Tx_data_n0_bs5_n(loopback6),		// n-side Tx data  PRBS
       
       .Tx_data_n1_bs0_p(loopback7), 		// p-side Tx data  PRBS
       .Tx_data_n1_bs1_n(loopback8),		// n-side Tx data  PRBS
       .Tx_data_n1_bs2_p(loopback9),		// p-side Tx data  PRBS 
       .Tx_data_n1_bs3_n(loopback10),		// n-side Tx data  PRBS
       .Tx_data_n1_bs4_p(loopback11),		// p-side Tx data  PRBS
       .Tx_data_n1_bs5_n(loopback12),		// n-side Tx data  PRBS

       .Tx_data_n2_bs0_p(loopback13),       // p-side Transmit Clock
       .Tx_data_n2_bs1_n(loopback14),       // n-side Transmit Clock       
       .Tx_data_n2_bs2_p(loopback15),		// p-side Tx data  PRBS 
       .Tx_data_n2_bs3_n(loopback16),		// n-side Tx data  PRBS
       .Tx_data_n2_bs4_p(loopback17),		// p-side Tx data  PRBS
       .Tx_data_n2_bs5_n(loopback18),		// n-side Tx data  PRBS

       .Tx_data_n3_bs0_p(loopback19), 		// p-side Tx data  PRBS
       .Tx_data_n3_bs1_n(loopback20),		// n-side Tx data  PRBS
       .Tx_data_n3_bs2_p(loopback21),		// p-side Tx data  PRBS 
       .Tx_data_n3_bs3_n(loopback22),		// n-side Tx data  PRBS
       .Tx_data_n3_bs4_p(loopback23),		// p-side Tx data  PRBS
       .Tx_data_n3_bs5_n(loopback24),		// n-side Tx data  PRBS
       
//       .Tx_data_n4_bs0_p(loopback23), 		// p-side Tx data  PRBS
//       .Tx_data_n4_bs1_n(loopback24),		// n-side Tx data  PRBS
       .Tx_data_n4_bs2_p(loopback25),		// p-side Tx data  PRBS 
       .Tx_data_n4_bs3_n(loopback26),		// n-side Tx data  PRBS
       .Tx_data_n4_bs4_p(loopback27),		// p-side Tx data  PRBS
       .Tx_data_n4_bs5_n(loopback28),		// n-side Tx data  PRBS
       
       .Tx_data_n5_bs0_p(loopback29), 		// p-side Tx data  PRBS
       .Tx_data_n5_bs1_n(loopback30),		// n-side Tx data  PRBS
       .Tx_data_n5_bs2_p(loopback31),		// p-side Tx data  PRBS 
       .Tx_data_n5_bs3_n(loopback32),		// n-side Tx data  PRBS
       .Tx_data_n5_bs4_p(loopback33),		// p-side Tx data  PRBS
       .Tx_data_n5_bs5_n(loopback34),		// n-side Tx data  PRBS
       
      
       .Rx_data_n0_bs0_p(loopback1), 		// p-side Rx data  PRBS
       .Rx_data_n0_bs1_n(loopback2),		// n-side Rx data  PRBS
       .Rx_data_n0_bs2_p(loopback3),		// p-side Rx data  PRBS 
       .Rx_data_n0_bs3_n(loopback4),		// n-side Rx data  PRBS
       .Rx_data_n0_bs4_p(loopback5),		// p-side Rx data  PRBS
       .Rx_data_n0_bs5_n(loopback6),		// n-side Rx data  PRBS
       
       .Rx_data_n1_bs0_p(loopback7), 		// p-side Rx data  PRBS
       .Rx_data_n1_bs1_n(loopback8),		// n-side Rx data  PRBS
       .Rx_data_n1_bs2_p(loopback9),		// p-side Rx data  PRBS 
       .Rx_data_n1_bs3_n(loopback10),		// n-side Rx data  PRBS
       .Rx_data_n1_bs4_p(loopback11),		// p-side Rx data  PRBS
       .Rx_data_n1_bs5_n(loopback12),		// n-side Rx data  PRBS

       .strobe_p(loopback13), 		        // p-side Capture Clock
       .strobe_n(loopback14),		        // n-side Capture Clock
       .Rx_data_n2_bs2_p(loopback15),		// p-side Rx data  PRBS 
       .Rx_data_n2_bs3_n(loopback16),		// n-side Rx data  PRBS
       .Rx_data_n2_bs4_p(loopback17),		// p-side Rx data  PRBS
       .Rx_data_n2_bs5_n(loopback18),		// n-side Rx data  PRBS

       .Rx_data_n3_bs0_p(loopback19), 		// p-side Rx data  PRBS
       .Rx_data_n3_bs1_n(loopback20),		// n-side Rx data  PRBS
       .Rx_data_n3_bs2_p(loopback21),		// p-side Rx data  PRBS 
       .Rx_data_n3_bs3_n(loopback22),		// n-side Rx data  PRBS
       .Rx_data_n3_bs4_p(loopback23),		// p-side Rx data  PRBS
       .Rx_data_n3_bs5_n(loopback24),		// n-side Rx data  PRBS
       
//       .Rx_data_n4_bs0_p(loopback23), 		// p-side Rx data  PRBS
//       .Rx_data_n4_bs1_n(loopback24),		// n-side Rx data  PRBS
       .Rx_data_n4_bs2_p(loopback25),		// p-side Rx data  PRBS 
       .Rx_data_n4_bs3_n(loopback26),		// n-side Rx data  PRBS
       .Rx_data_n4_bs4_p(loopback27),		// p-side Rx data  PRBS
       .Rx_data_n4_bs5_n(loopback28),		// n-side Rx data  PRBS
       
       .Rx_data_n5_bs0_p(loopback29), 		// p-side Rx data  PRBS
       .Rx_data_n5_bs1_n(loopback30),		// n-side Rx data  PRBS
       .Rx_data_n5_bs2_p(loopback31),		// p-side Rx data  PRBS 
       .Rx_data_n5_bs3_n(loopback32),		// n-side Rx data  PRBS
       .Rx_data_n5_bs4_p(loopback33),		// p-side Rx data  PRBS
       .Rx_data_n5_bs5_n(loopback34)		// n-side Rx data  PRBS        
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
    	no_of_data_lines = $size(toplevel_testbench_sb.uut.my_Tx_bank.t_Tx_data) * 2;      //x2 because of the differential pair  
    end

    always @(posedge toplevel_testbench_sb.uut.intTxClk0)
    begin
        if (toplevel_testbench_sb.uut.int_chk == 1)
            begin
                
                //Counting the number of posedge of toplevel_testbench_sb.uut.intTxClk0            
                clock_edges = clock_edges + 1;
                
                test_size = (clock_edges * no_of_data_lines * 2)/(8*(10**3));               // x2 because of the DDR sampling
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
    	        sim_inject_error = "0";
                # (CLKIN_period*(5000+err_mult));
                sim_inject_error = "1";
        end
    end	
    */
	
endmodule
