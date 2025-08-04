`timescale 1ns / 1ps
// Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.

module up_counter_rtl(
    input clk,
    input rst,
    output reg [3:0] count_out
    );
    
    (* mark_debug = "true" *) reg [3:0] count_out;
    
    always @ (posedge clk) begin
        if (!rst)
            count_out <= 0;
        else
            count_out <= count_out + 1;
    end
        
endmodule
