`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2022 11:36:47 AM
// Design Name: 
// Module Name: Command_Decode
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


module Command_Decode(
input clk,
input CS_n,
input ACT_n, 
input [16:0] adr,
input [1:0] ba,
input [1:0] bg,
output write, 
output read, 
output prechargeSingle, 
output prechargeAll, 
output refresh,
output activate, 
output other,
output [16:0] write_c,
output [16:0] read_c,
output [16:0] prechargeSingle_c,
output [16:0] prechargeAll_c,
output [16:0] refresh_c,
output [16:0] activate_c,
output [16:0] other_c,
output [16:0] Row_adr,
output [9:0] Column_adr
);
    
reg write_reg;
reg [16:0] write_count;
reg read_reg;
reg [16:0] read_count;
reg prechargeSingle_reg;
reg [16:0] prechargeSingle_count;
reg prechargeAll_reg;
reg [16:0] prechargeAll_count;
reg refresh_reg;
reg [16:0] refresh_count;
reg activate_reg;
reg [16:0]activate_count;
reg other_reg;
reg [16:0] other_count;
reg [16:0] Row_reg [15:0];
reg [16:0] Row_adr_reg;
reg [9:0] Column_adr_reg;

initial begin
other_count = 0;
activate_count = 0;
refresh_count = 0;
prechargeAll_count = 0;
prechargeSingle_count = 0;
read_count = 0;
write_count = 0;
end

              //write, read, activate, precharge (single bank and all bank), refresh
   
always@(posedge clk)
begin
if(!ACT_n && !CS_n)
begin
    write_reg <= 0;
    read_reg <= 0;
    prechargeSingle_reg <= 0;
    prechargeAll_reg <= 0;
    refresh_reg <= 0;
    activate_reg <= 1;
    other_reg <= 0;
    activate_count <= activate_count + 1;
    Row_reg[{ba,bg}] <= adr;
end
else
begin
    if(!CS_n && !adr[16] && !adr[15] && !adr[14])
    begin
        //Mode register set 
        write_reg <= 0;
        read_reg <= 0;
        prechargeSingle_reg <= 0;
        prechargeAll_reg <= 0;
        refresh_reg <= 0;
        activate_reg <= 0;
        other_reg <= 1;
        other_count <= other_count + 1;
    end
    else if(!CS_n && !adr[16] && !adr[15] && adr[14])
    begin
    //Refresh 
        write_reg <= 0;
        read_reg <= 0;
        prechargeSingle_reg <= 0;
        prechargeAll_reg <= 0;
        refresh_reg <= 1;
        activate_reg <= 0;
        other_reg <= 0;
        refresh_count <= refresh_count + 1;
    end
    else if(!CS_n && !adr[16] && adr[15] && !adr[14] && !adr[10])
    begin
    //Single Bank Precharge  4
        write_reg <= 0;
        read_reg <= 0;
        prechargeSingle_reg <= 1;
        prechargeAll_reg <= 0;
        refresh_reg <= 0;
        activate_reg <= 0;
        other_reg <= 0;
        prechargeSingle_count <= prechargeSingle_count + 1;
    end
    else if(!CS_n && !adr[16] && adr[15] && !adr[14] && adr[10])
    begin
    //Precharge  all
        write_reg <= 0;
        read_reg <= 0;
        prechargeSingle_reg <= 0;
        prechargeAll_reg <= 1;
        refresh_reg <= 0;
        activate_reg <= 0;
        other_reg <= 0;
        prechargeAll_count <= prechargeAll_count + 1;
    end
    else if(!CS_n && adr[16] && !adr[15] && !adr[14])
    begin
    //Write 
        write_reg <= 1;
        read_reg <= 0;
        prechargeSingle_reg <= 0;
        prechargeAll_reg <= 0;
        refresh_reg <= 0;
        activate_reg <= 0;
        other_reg <= 0;
        write_count <= write_count + 1;
        Row_adr_reg <= Row_reg[{ba,bg}];
        Column_adr_reg <= adr[9:0];
        
    end
    else if(!CS_n && adr[16] && !adr[15] && adr[14])
    begin
    //Read 
        write_reg <= 0;
        read_reg<= 1;
        prechargeSingle_reg <= 0;
        prechargeAll_reg <= 0;
        refresh_reg <= 0;
        activate_reg <= 0;
        other_reg <= 0;
        read_count <= read_count + 1;
        Row_adr_reg <= Row_reg[{ba,bg}];
        Column_adr_reg <= adr[9:0];
    end
    else if((!CS_n && adr[16] && adr[15] && adr[14]) || (CS_n))
    begin
        //NOP and Device Deselected and PowerDown commands don't do anything
        
    // NOP <- do nothing
    // Deselect <- do nothing
    // row column decoding 
    end
    else
    begin
    //other
        write_reg <= 0;
        read_reg <= 0;
        prechargeSingle_reg <= 0;
        prechargeAll_reg <= 0;
        refresh_reg <= 0;
        activate_reg <= 0;
        other_reg <= 1;
        other_count <= other_count + 1;
     end
end
end

always @(negedge clk)
begin
write_reg <= 0;
read_reg <= 0;
prechargeSingle_reg <= 0;
prechargeAll_reg <= 0;
refresh_reg <= 0;
activate_reg <= 0;
other_reg <= 0;
end

assign write = write_reg;
assign read = read_reg;
assign prechargeSingle = prechargeSingle_reg;
assign prechargeAll = prechargeAll_reg;
assign refresh = refresh_reg;
assign activate = activate_reg;
assign other = other_reg;
assign write_c = write_count;
assign read_c = read_count;
assign prechargeSingle_c = prechargeSingle_count;
assign prechargeAll_c = prechargeAll_count;
assign refresh_c = refresh_count;
assign activate_c = activate_count;
assign other_c = other_count;
assign Row_adr = Row_adr_reg;
assign Column_adr = Column_adr_reg;
endmodule
