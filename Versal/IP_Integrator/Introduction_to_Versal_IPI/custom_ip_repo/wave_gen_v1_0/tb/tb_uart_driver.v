//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : tb_uart_driver.v
//  Parent   : tb_uart_rx
//  Children : none
//
//  Description: 
//    This testbench module generates serial data. It is essentially
//    a behavioral implementation of a UART transmitter, sending one character
//    at a time (when invoked through one of its tasks), at a specified bit
//    period. The character is sent using the RS232 protocol; START, 8 data
//    bits (LSbit first), STOP.
//
//  Parameters: 
//
//  Tasks:
//    send_char_bitper : Sends a character at the specified bit period
//                       (in NANOSECONDS)
//    set_bitper       : Sets the default bit period in NANOSECONDS
//    send_char        : Sends a character at the default bit period
//    send_char_push   : Sends a character at the default bit period, and
//                       pushes the character into the data FIFO
//
//  Functions:
//
//  Internal variables:
//    reg [63:0]   bit_period
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


module tb_uart_driver (
  output      data_out       // Transmitted serial data
);

//***************************************************************************
// Parameter definitions
//***************************************************************************

  parameter BAUD_RATE = 57_600; // This is the default bit rate - can be
                                // overridden by "set_bitper"

//***************************************************************************
// Register declarations
//***************************************************************************
  
  // bit_period is 1/BAUD_RATE, but needs to be in ns (not seconds), so 
  // we multiply by 1e9. We need to round
  reg  [63:0]       bit_period = (1_000_000_000 + BAUD_RATE/2) /BAUD_RATE; 

  reg               data_out_reg = 1'b1;

//***************************************************************************
// Tasks
//***************************************************************************

  // The bit period is in nanoseconds since you can't pass a real to a task
  task set_bitper;
    input [63:0] new_bit_per;
  begin
    bit_period = new_bit_per;
  end
  endtask


  task send_char_bitper (
    input [7:0]  char,
    input [63:0] bit_per
  );
    integer      i;
  begin
    $display ("%t       Sending character %x (%c)",$realtime, char,char);
    data_out_reg = 1'b0; // send start bit
    #(bit_per);
    for (i=0; i<=7; i=i+1)
    begin
      data_out_reg = char[i];
      #(bit_per);
    end
    data_out_reg = 1'b1; // send stop bit
    #(bit_per);
  end
  endtask

  task send_char (
    input [7:0]  char
  );
  begin
    send_char_bitper(char,bit_period);
  end
  endtask

  task send_char_push (
    input [7:0] char
  );
  begin
    tb_char_fifo_i0.push(char);
    send_char(char);
  end
  endtask

//***************************************************************************
// Code
//***************************************************************************

  assign data_out = data_out_reg;

endmodule

