//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : tb_resp_checker.v
//  Parent   : tb_uart_rx, tb_wave_gen
//  Children : none
//
//  Description: 
//    This testbench module checks the data received from the DUT against
//    the data stored in a FIFO
//
//  Parameters: 
//
//  Tasks:
//    start_chk        : Enables the checker
//
//  Functions:
//
//  Internal variables:
//    reg    enabled;
//    
//
//  Notes       : 
//    
//
//  Multicycle and False Paths
//    None - this is a testbench file only, and is not intended for synthesis
//

// All times in this testbench are expressed in units of nanoseconds, with a 
// precision of 1ps increments
`timescale 1ns/1ps


module tb_resp_checker (
  input [7:0] data_in,  
  input       frm_err,
  input       strobe
);

//***************************************************************************
// Parameter definitions
//***************************************************************************


//***************************************************************************
// Register declarations
//***************************************************************************
  
  reg               enabled = 1'b0;

  reg  [7:0]        my_data;
  reg  [7:0]        char_received;

//***************************************************************************
// Tasks
//***************************************************************************

  // Enables the checker 
  task enable;
    input new_enable;
  begin
    enabled = new_enable;
  end
  endtask

  task is_done (
  );
  begin
    if (!tb_char_fifo_i0.is_empty(1'b0))
      $display("%t ERROR Data FIFO is not empty when expected",$realtime);
  end
  endtask


//***************************************************************************
// Code
//***************************************************************************

  always @(posedge strobe)
  begin
    if (enabled)
    begin
      my_data = tb_char_fifo_i0.pop(1'b0);
      char_received = data_in;
      #1; // Wait to ensure that the output data is valid after the rising
          // edge of the strobe
      if (data_in !== my_data)
      begin
         $display(
           "%t ERROR Character mismatch. Expected %x (%c), received %x (%c)",
           $realtime, my_data, my_data, data_in, data_in);
      end
      else
      begin
         $display("%t       Character received %x (%c)", $realtime, my_data,my_data);
      end
    end // if enabled
  end // always 

  always @(posedge frm_err)
  begin
    if (enabled)
    begin
       $display("%t ERROR Frame Error Detected", $realtime);
    end // if enabled
  end // always 

endmodule

