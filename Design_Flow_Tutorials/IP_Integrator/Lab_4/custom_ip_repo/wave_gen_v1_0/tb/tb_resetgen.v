//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2008 Xilinx Inc.
//
//  Project  : Programmable Wave Generator (Testbench)
//  Module   : tb_reset.v
//  Parent   : tb_uart_rx
//  Children : none
//
//  Description: 
//    This is a general reset generation module. It should be instantiated
//    and connected to both the DUT
//
//
//  Parameters:
//    None
//
//  Notes       : 
//
//  Multicycle and False Paths
//    None - this is a testbench file only, and is not intended for synthesis
//

`timescale 1ns/1ps

module tb_resetgen (
  input      clk,
  output reg reset
);

//***************************************************************************
// Parameter definitions
//***************************************************************************

  

//***************************************************************************
// Register declarations
//***************************************************************************


//***************************************************************************
// Code
//***************************************************************************

  initial
  begin
    reset = 1'b0;
  end // initial

  task assert_reset (
    input [31:0] num_clk
  );
  begin
    $display("%t       Asserting reset for %d clocks",$realtime, num_clk);
    reset = 1'b1;
    repeat (num_clk) @(posedge clk);
    $display("%t       Deasserting reset",$realtime);
    reset = 1'b0;
  end
  endtask

endmodule

