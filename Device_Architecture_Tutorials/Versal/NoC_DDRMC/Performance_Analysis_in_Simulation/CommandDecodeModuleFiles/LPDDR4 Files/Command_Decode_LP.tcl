set f [open $name "r"]
set lines [split [read $f] "\n"]
close $f

set label " ,output write, output read, output precharge, output prechargeAll, output refresh, output refreshAll, output activate, output [9:0]  colAddrOut, output [18:0] rowAddrOut, output [2:0] BA, output [16:0] write_c, output [16:0] read_c, output [16:0] precharge_c, output [16:0] prechargeAll_c, output [16:0] refresh_c, output [16:0] refreshAll_c, output [16:0] activate_c"
set lines [linsert $lines 86 $label]
set label2 "Command_Decode_LP Command_Decode_LP (.clk(lpddr4_ck_t_a), .CS(lpddr4_cs_a), .CA(lpddr4_ca_a), .write(write), .read(read), .precharge(precharge), .refresh(refresh), .prechargeAll(prechargeAll), .refreshAll(refreshAll), .activate(activate), .colAddrOut(colAddrOut), .rowAddrOut(rowAddrOut), .BA(BA), .write_c(write_count), .read_c(read_count), .precharge_c(precharge_count), .refresh_c(refresh_count), .activate_c(activate_count),.refreshAll_c(refreshAll_c), .prechargeAll_c(prechargeAll_c));"
set lines [linsert $lines 142 $label2]


# Write the lines back to the file
set f [open $name "w"]
puts $f [join $lines "\n"]
close $f