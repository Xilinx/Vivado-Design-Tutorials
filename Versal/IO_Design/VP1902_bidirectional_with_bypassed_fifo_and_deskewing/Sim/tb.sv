`timescale 1ns / 1ps

module tb(

    );

    reg             clk                          ;

    wire [47 : 0]   banka_to_bankb_data_pins     ; //Bidirectional connection between bank a and bank b
    wire [47 : 0]   bankc_to_bankd_data_pins     ; //Bidirectional connection between bank c and bank d
    wire [47 : 0]   banke_to_bankf_data_pins     ; //Bidirectional connection between bank e and bank f

    wire [0 : 0]    banka_rxclk                  ; 
    wire [0 : 0]    banka_wrclk                  ; 
  
    wire [0 : 0]    bankb_rxclk                  ; 
    wire [0 : 0]    bankb_wrclk                  ; 
  
    wire [0 : 0]    bankc_rxclk                  ; 
    wire [0 : 0]    bankc_wrclk                  ; 
  
    wire [0 : 0]    bankd_rxclk                  ; 
    wire [0 : 0]    bankd_wrclk                  ; 
  
    wire [0 : 0]    banke_rxclk                  ; 
    wire [0 : 0]    banke_wrclk                  ; 
  
    wire [0 : 0]    bankf_rxclk                  ; 
    wire [0 : 0]    bankf_wrclk                  ; 




	reg  banka_rst_test, bankb_rst_test, bankc_rst_test, bankd_rst_test, banke_rst_test, bankf_rst_test    ;
	reg  banka_injerr,   bankb_injerr,   bankc_injerr,   bankd_injerr,   banke_injerr,   bankf_injerr      ;
      
	reg  banka_read,     bankb_read,     bankc_read,     bankd_read,     banke_read,     bankf_read        ;
	reg  banka_write,    bankb_write,    bankc_write,    bankd_write,    banke_write,    bankf_write       ;
	wire   banka_writing,  bankb_writing,  bankc_writing,  bankd_writing,  banke_writing,  bankf_writing   ;
	
	
	wire banka_intf_rdy_reg, bankb_intf_rdy_reg, bankc_intf_rdy_reg, bankd_intf_rdy_reg, banke_intf_rdy_reg, bankf_intf_rdy_reg ;
	wire  [ 47:0]	 banka_prbs_error, bankb_prbs_error, bankc_prbs_error, bankd_prbs_error, banke_prbs_error, bankf_prbs_error ;




   always begin
      clk = 1'b0;
      #(10.0/2) clk = 1'b1;
      #(10.0/2);
   end




	assign banka_rxclk = bankb_wrclk;
	assign bankb_rxclk = banka_wrclk; 
	assign bankc_rxclk = bankd_wrclk;
	assign bankd_rxclk = bankc_wrclk;
	assign banke_rxclk = banke_wrclk;
	assign bankf_rxclk = bankf_wrclk;


initial
    begin
	 force dut.banka_rst_test = 1'b1;
	 force dut.bankb_rst_test = 1'b1;
	 force dut.bankc_rst_test = 1'b1;
	 force dut.bankd_rst_test = 1'b1;
	 force dut.banke_rst_test = 1'b1;
	 force dut.bankf_rst_test = 1'b1;

	 force dut.banka_injerr   = 1'b0;
	 force dut.bankb_injerr   = 1'b0;
	 force dut.bankc_injerr   = 1'b0;
	 force dut.bankd_injerr   = 1'b0;
	 force dut.banke_injerr   = 1'b0;
	 force dut.bankf_injerr   = 1'b0;

	//Initially bank a/c/e will be writing and bank b/d/f will be reading
     force dut.banka_write    = 1'b1;
     force dut.bankb_write    = 1'b0;
     force dut.bankc_write    = 1'b1;
     force dut.bankd_write    = 1'b0;
     force dut.banke_write    = 1'b1;
     force dut.bankf_write    = 1'b0;

      #1000

    //Release reset to allow all banks to go through the reset sequence
	 force dut.banka_rst_test = 1'b0;
	 force dut.bankb_rst_test = 1'b0;
	 force dut.bankc_rst_test = 1'b0;
	 force dut.bankd_rst_test = 1'b0;
	 force dut.banke_rst_test = 1'b0;
	 force dut.bankf_rst_test = 1'b0; 	 
    #160000
    
     //Reset sequence may vary based on usage. Waiting for intf_rdy to be high for all banks
     force dut.banka_write    = 1'b1;
     force dut.bankb_write    = 1'b0;
     force dut.bankc_write    = 1'b1;
     force dut.bankd_write    = 1'b0;
     force dut.banke_write    = 1'b1;
     force dut.bankf_write    = 1'b0;

     #10000
     
    //Allow the bus to be floating for 100 ns before driving the bus with bankb, bankd and bankf
     force dut.banka_write    = 1'b0;
     force dut.bankb_write    = 1'b0;
     force dut.bankc_write    = 1'b0;
     force dut.bankd_write    = 1'b0;
     force dut.banke_write    = 1'b0;
     force dut.bankf_write    = 1'b0;
       #100
	
	//Reading from banks a/c/e and writing to b/d/f
     force dut.banka_write    = 1'b0;
     force dut.bankb_write    = 1'b1;
     force dut.bankc_write    = 1'b0;
     force dut.bankd_write    = 1'b1;
     force dut.banke_write    = 1'b0;
     force dut.bankf_write    = 1'b1;
     #10000
     


    //Allow the bus to be floating for 100 ns before driving the bus with banka, bankc and banke
     force dut.banka_write    = 1'b0;
     force dut.bankb_write    = 1'b0;
     force dut.bankc_write    = 1'b0;
     force dut.bankd_write    = 1'b0;
     force dut.banke_write    = 1'b0;
     force dut.bankf_write    = 1'b0;
       #100
	
	//Reading from banks b/d/f and writing to a/c/e
     force dut.banka_write    = 1'b1;
     force dut.bankb_write    = 1'b0;
     force dut.bankc_write    = 1'b1;
     force dut.bankd_write    = 1'b0;
     force dut.banke_write    = 1'b1;
     force dut.bankf_write    = 1'b0;
 
    end


    
    top  dut  (
	 .clk             ( clk            ),
	 .clk_n           ( ! clk          ),
	 

		
    //bidirectional, read clock and write clock ports
	 .banka_data_pins    (banka_to_bankb_data_pins),   
	 .banka_rxclk        ( banka_rxclk         ), 
	 .banka_rxclk_n      (!  banka_rxclk       ), 
	 .banka_wrclk        (banka_wrclk          ),
	 .banka_wrclk_n      (),

	 .bankb_data_pins    (banka_to_bankb_data_pins),   
	 .bankb_rxclk        ( banka_rxclk         ),        
	 .bankb_rxclk_n      ( ! banka_rxclk       ), 
	 .bankb_wrclk        (bankb_wrclk          ),
	 .bankb_wrclk_n      (),

	 .bankc_data_pins    (bankc_to_bankd_data_pins),   
	 .bankc_rxclk        ( banka_rxclk         ),        
	 .bankc_rxclk_n      ( ! banka_rxclk       ), 
	 .bankc_wrclk        (bankc_wrclk          ),
	 .bankc_wrclk_n      (),

	 .bankd_data_pins    (bankc_to_bankd_data_pins),   
	 .bankd_rxclk        ( banka_rxclk         ),      
	 .bankd_rxclk_n      ( ! banka_rxclk       ), 
	 .bankd_wrclk        (bankd_wrclk          ),
	 .bankd_wrclk_n      (),

	 .banke_data_pins    (banke_to_bankf_data_pins),   
	 .banke_rxclk        ( banka_rxclk         ),        
	 .banke_rxclk_n      ( ! banka_rxclk       ), 
	 .banke_wrclk        (banke_wrclk          ),
	 .banke_wrclk_n      (),

	 .bankf_data_pins    (banke_to_bankf_data_pins),   
	 .bankf_rxclk        ( banka_rxclk         ),        
	 .bankf_rxclk_n      ( ! banka_rxclk       ),
	 .bankf_wrclk        (bankf_wrclk          ),
	 .bankf_wrclk_n      ()
    );
endmodule
