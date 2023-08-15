set f [open $name "r"]
set lines [split [read $f] "\n"]
close $f

set label ",output write,output read,output prechargeSingle,output prechargeAll,output refresh,output activate,output other,output [16:0] write_count,output [16:0] read_count,output [16:0] prechargeSingle_count,output [16:0] prechargeAll_count,output [16:0] refresh_count,output [16:0] activate_count,output [16:0] other_count,output [16:0] Row_adr,output [9:0] Column_adr"
set lines [linsert $lines 81 $label]
set label2 "Command_Decode Command_Decode (.CS_n(ddr4_cs_n), .ACT_n(ddr4_act_n), .adr(ddr4_adr), .clk(ddr4_ck_t), .write(write), .read(read), .prechargeSingle(prechargeSingle), .prechargeAll(prechargeAll), .refresh(refresh), .activate(activate), .other(other), .write_c(write_count), .read_c(read_count), .prechargeSingle_c(prechargeSingle_count), .prechargeAll_c(prechargeAll_count), .refresh_c(refresh_count), .activate_c(activate_count), .other_c(other_count), .Row_adr(Row_adr), .Column_adr(Column_adr), .ba(ddr4_ba), .bg(ddr4_bg));"
set lines [linsert $lines 131 $label2]


# Write the lines back to the file
set f [open $name "w"]
puts $f [join $lines "\n"]
close $f