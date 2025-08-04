//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : tb_ram.v
//  Parent   : tb_wave_gen
//  Children : clogb2.txt
//
//  Description: 
//    This module is a generic memory for testbench applications. It stores
//    data internally in a verilog memory, and provides access to it via the
//    tasks and functions read and write.
//
//    This module also implements bounds for write operation. Each cell in
//    the memory has a specified min and max value (which can be set by the
//    testbench or testcase). The write task will first check to see if the
//    value is in bounds for the location requested, and will only do the
//    write if it is. An error code is provided to indicate if the write
//    occurred or not.
//
//  Parameters: 
//    WIDTH        : Width of the data to be stored
//    DEPTH        : Number of entries in the RAM
//                   entries are in the FIFO
//
//  Tasks:
//    init         : Initialized the contents to 0 and the min and max to 
//                   0 and 2**WIDTH-1 respectively
//    set_min_max  : to set the min and max of a cell
//    write        : to write to the memory and
//
//  Functions:
//    read         : to read from the memory
//
//
//  Internal variables:
//    reg [WIDTH-1:0] val     [0:DEPTH-1] - the array for storing data
//    reg [WIDTH-1:0] max_val [0:DEPTH-1] - the array for storing the max
//    reg [WIDTH-1:0] min_val [0:DEPTH-1] - the array for storing the min
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


module tb_ram ();

`include "clogb2.vh"

//***************************************************************************
// Parameter definitions
//***************************************************************************

  parameter         WIDTH        = 16;
  parameter         DEPTH        = 1024;

  localparam        ADDR_WID    = clogb2(DEPTH);

//***************************************************************************
// Register declarations
//***************************************************************************

  reg [WIDTH-1:0] val     [0:DEPTH-1]; // the array for storing data
  reg [WIDTH-1:0] max_val [0:DEPTH-1]; // the array for storing max
  reg [WIDTH-1:0] min_val [0:DEPTH-1]; // the array for storing min

//***************************************************************************
// Functions
//***************************************************************************

  function [WIDTH-1:0] read;
    input [ADDR_WID-1:0] addr;
  begin
    read = val[addr];
  end
  endfunction

  function write; // returns a 1 bit return code
    input [ADDR_WID-1:0] addr;
    input [WIDTH-1:0]    value;
  begin
    if ((value >= min_val[addr]) && (value <= max_val[addr]))
    begin
      $display("%t       Writing %x to RAM location %x",
                $realtime(), value, addr);
      val[addr] = value;
      write     = 1'b1;
    end
    else // The value is out of range
    begin
      $display("%t       NOT Writing %x to RAM location %x",
                $realtime(), value ,addr);
      write = 1'b0;
    end
  end // task
  endfunction

//***************************************************************************
// Tasks
//***************************************************************************
  task init;
    integer i;
  begin
    for (i=0; i<=DEPTH-1; i=i+1)
    begin
      val[i]     = {WIDTH{1'b0}};
      min_val[i] = {WIDTH{1'b0}};
      max_val[i] = {WIDTH{1'b1}};
    end
  end     // task
  endtask // init

  task set_min_max;
    input [ADDR_WID-1:0] addr;
    input [WIDTH-1:0]    min;
    input [WIDTH-1:0]    max;
  begin
    min_val[addr] = min;
    max_val[addr] = max;
  end
  endtask // set_min_max


//***************************************************************************
// Code
//***************************************************************************

endmodule

