//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : tb_cmd_gen.v
//  Parent   : tb_wave_gen
//  Children : none
//
//  Description: 
//    This module implements the user commands in the testbench environment.
//    It is responsible for sending characters to the UUT (via the
//    uart_driver), putting expected responses into the character FIFO,
//    and querying and updating the internal state of the testbench (in the
//    tb_ram instances), and controlling the sample checker 
//
//  Parameters: 
//    STR_LEN          : Maximum length of strings
//
//    VAR_NSAMP, VAR_PRESCALE, VAR_SPEED: Constants that correspond to the
//                       nsamp, prescale, and speed locations in tb_var_ram
//
//  Tasks:
//    do_cmd           : Send a command to the UUT and put the cmd/rsp pair
//                       into the char_fifo. cmd & rsp are arguments. The
//                       end of line (8'h0d) is added after each rsp
//    write            : execute the *W command
//    read             : execute the *R command
//    set_nsamp
//    set_speed
//    set_prescale     : execute the *N, *S, *P commands
//    set_var          : underlying task to support *N, *S, *P
//    get_nsamp
//    get_speed
//    get_prescale     : execute the *n, *s, *P commands
//    get_var          : underlying task to support *n, *s, *p
//
//  Functions:
//
//    to_dec_str       : Convert a number to a decimal string w/ leading 0s
//
//  Internal variables:
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


module tb_cmd_gen ();  // No I/O

//***************************************************************************
// Parameter definitions
//***************************************************************************

  // All strings used myst be smaller than STR_LEN-1 characters to ensure that
  // there is room for at least one character of zero padding (to detect the
  // end of the string).
  parameter  STR_LEN      = 80;
  
  parameter  MAX_ADDR     = 1024;

  parameter  ADDR_WID     = 16;
  parameter  DATA_WID     = 16;

  localparam VAR_NSAMP    = 0,
             VAR_PRESCALE = 1,
             VAR_SPEED    = 2;

  localparam ACK_STR = "-OK",
             ERR_STR = "-ERR";


//***************************************************************************
// Register declarations
//***************************************************************************

//***************************************************************************
// Functions
//***************************************************************************

  function [0:5*8-1] to_dec_str;
    input [DATA_WID-1:0] val;
    integer i;
  begin
    $sformat(to_dec_str,"%d",val);
    for (i=0; i<=4; i=i+1)
      if (to_dec_str[8*i+:8] == " ")
        to_dec_str[8*i+:8] = "0";
  end
  endfunction

//***************************************************************************
// Tasks
//***************************************************************************

  // The bit period is in nanoseconds since you can't pass a real to a task
  task do_cmd;
    input [0:STR_LEN*8-1]   cmd;
    input [0:STR_LEN*8-1]   rsp;
    integer                 i;
  begin
    // We must push the expected cmd/rsp pair into the character FIFO BEFORE
    // we start sending the command to the UUT, since the UUT will start
    // echoing commands as soon as they arrive.

    $display("%t       Sending cmd = %s, expecting rsp = %s",
             $realtime(),cmd,rsp);

    // Push cmd and rsp into the char FIFO - cmd first
    for (i=0; i<= STR_LEN-1; i=i+1)
    begin
      if (cmd[i*8+:8] != 8'h00) // Test Null and don't send it
      begin
        tb_char_fifo_i0.push(cmd[i*8+:8]);
      end // if
    end // for

    // Now rsp into char FIFO
    for (i=0; i<= STR_LEN-1; i=i+1)
    begin
      if (rsp[i*8+:8] != 8'h00) // Test Null and don't send it
      begin
        tb_char_fifo_i0.push(rsp[i*8+:8]);
      end // if
    end // for

    tb_char_fifo_i0.push(8'h0d); // Newline
    tb_char_fifo_i0.push(8'h0a); // LineFeed
    
    // Now send the command only to the UUT
    for (i=0; i<= STR_LEN-1; i=i+1)
    begin
      if (cmd[i*8+:8] != 8'h00) // Test Null and don't send it
      begin
        tb_uart_driver_i0.send_char(cmd[i*8+:8]);
      end // if
    end // for
  end
  endtask


  task write (
    input [ADDR_WID-1:0] addr,
    input [DATA_WID-1:0] val
  );
    reg [0:STR_LEN*8-1]  cmd, rsp;
    reg                  ret;       // return code from write
  begin
    $sformat(cmd, "*W%x%x",addr,val);
    if (addr <= MAX_ADDR) // Address is in legal range
    begin 
      $display ("%t       Writing %x to sample address %x",
                $realtime, val, addr);
      ret = tb_samp_ram_i0.write(addr,val);   // Update the sample RAM
      // We don't care about the return code - it should always be 1)
      rsp=ACK_STR;
    end
    else
    begin
      $display ("%t       Writing to illegal address %x",$realtime, addr);
      rsp=ERR_STR;
    end
    do_cmd(cmd,rsp);
  end
  endtask

  task read (
    input [ADDR_WID-1:0]  addr
  );
    reg   [DATA_WID-1:0]  val;
    reg   [0:5*8-1]       dec_val;
    reg   [0:STR_LEN*8-1] cmd, rsp;

  begin
    $sformat(cmd, "*R%x",addr);
    if (addr <= MAX_ADDR) // Address is in legal range
    begin 
      val = tb_samp_ram_i0.read(addr);
      $display ("%t       Reading %x from sample address %x",
                 $realtime, val, addr);
      dec_val = to_dec_str(val);
      $sformat(rsp,"-%x %s",val,dec_val);
    end
    else
    begin
      $display ("%t       Reading from illegal sample address %x",
                 $realtime, addr);
      rsp = ERR_STR;
    end
    do_cmd(cmd,rsp);
  end
  endtask

  task set_var (
    input [15:0] var,
    input [15:0] val
  ); 
    reg                   ret_code;
    reg   [0:STR_LEN*8-1] cmd, rsp;

  begin
    // Generate the command string
    case (var)
      VAR_NSAMP:    $sformat(cmd,"*N%h",val);
      VAR_PRESCALE: $sformat(cmd,"*P%h",val);
      VAR_SPEED:    $sformat(cmd,"*S%h",val);
    endcase

    // Attempt the variable update
    ret_code = tb_var_ram_i0.write(var,val);

    // Generate the response
    if (ret_code) // success
      rsp = ACK_STR;
    else
      rsp = ERR_STR;

    // Issue the command/response
    do_cmd(cmd,rsp);
  end
  endtask

  task set_nsamp (
    input [15:0] val
  ); 
  begin
    set_var(VAR_NSAMP,val);
  end
  endtask

  task set_prescale (
    input [15:0] val
  ); 
  begin
    set_var(VAR_PRESCALE,val);
  end
  endtask

  task set_speed (
    input [15:0] val
  ); 
  begin
    set_var(VAR_SPEED,val);
  end
  endtask

  task get_var (
    input [15:0] var
  ); 
    reg   [15:0]          val;
    reg   [0:STR_LEN*8-1] cmd, rsp;
    reg   [0:5*8-1]       dec_val;
  begin
    // Generate the command string
    case (var)
      VAR_NSAMP:    cmd = "*n";
      VAR_PRESCALE: cmd = "*p";
      VAR_SPEED:    cmd = "*s";
    endcase

    // Read the variable from the testbench
    val = tb_var_ram_i0.read(var);

    // Format the response
    dec_val = to_dec_str(val);
    $sformat(rsp,"-%x %s",val,dec_val);

    // Issue the command/response
    do_cmd(cmd,rsp);
  end
  endtask

  task get_nsamp;
  begin
    get_var(VAR_NSAMP);
  end
  endtask

  task get_prescale;
  begin
    get_var(VAR_PRESCALE);
  end
  endtask

  task get_speed; 
  begin
    get_var(VAR_SPEED);
  end
  endtask

//***************************************************************************
// Code
//***************************************************************************

endmodule

