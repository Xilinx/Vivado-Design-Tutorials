# © Copyright 2019 – 2021 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set total_nibble 96
set used_nibble 96


set strb_max [expr {($total_nibble - 8 ) / 8}]
set nibble_count  [expr {$strb_max * 8}]

set extra_nibble [expr {$total_nibble - $used_nibble}]
set extra_nibble_zeros [string repeat 0 $extra_nibble]

proc dec2bin i {
    #returns a string, e.g. dec2bin 10 => 1010 
    set res {} 
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res == {}} {set res 0}
    return $res
}

#set tg_addr [expr $tg - 1]
set tg_addr $tg
set tg_value   [format {%05d} [dec2bin $tg_addr]]
set fr [open output_tg_$tg.mem r]
#set fw [open load_bram_sim_tg$tg.sv w]
set fh [open load_bram_hw_tg$tg.tcl w]
set dword_cnt 0
set addr      0
set strb      $strb_max
set exbit     00
set bram      1
#puts $fw "#80000;"
#puts $fw "force  $sim_path.vio_wren           = 0;"
#puts $fw "force  $sim_path.vio_rden           = 0;"
#puts $fw "force {$sim_path.vio_addr_t\[31:0]} = 32'h00000000;"
#puts $fw "force {$sim_path.vio_wdata\[31:0]}  = 32'h00000000;"
#HW
puts $fh "set_property OUTPUT_VALUE 0 \[get_hw_probes $hw_path/vio_wren -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_wren} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
puts $fh "set_property OUTPUT_VALUE 00000000 \[get_hw_probes $hw_path/vio_addr_t -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_addr_t} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
puts $fh "set_property OUTPUT_VALUE 00000000 \[get_hw_probes $hw_path/vio_wdata -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_wdata} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";





while {1} {
  set line [gets $fr]
    if {[eof $fr]} {
        close $fr
        break
    }
    if {[string trim $line] eq ""} {
       close $fr
       break
       }
 

 
  #set wdth $extra_nibble_zeros$line
  set wdth $line
  set nb_cnt [string length $wdth]
  while {$dword_cnt <= $nibble_count  } {
    set dword [string range $wdth $dword_cnt $dword_cnt+7]
  
    set addr_value [format {%09d} [dec2bin $addr]]
    set strb_value [format {%04d} [dec2bin $strb]]
    set dec [expr "0b$tg_value$bram$addr_value$strb_value$exbit"]
    set inhex_addr [format %08x $dec]
    #puts $fw "force {$sim_path.vio_addr_t\[31:0]} = 32'h$inhex_addr;"
    #puts $fw "force {$sim_path.vio_wdata\[31:0]}  = 32'h$dword;"
    #HW
    puts $fh "set_property OUTPUT_VALUE $inhex_addr \[get_hw_probes $hw_path/vio_addr_t -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device ] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
    puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_addr_t} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
    puts $fh "set_property OUTPUT_VALUE $dword \[get_hw_probes $hw_path/vio_wdata -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
    puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_wdata} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
    
    puts $fh "set_property OUTPUT_VALUE 1 \[get_hw_probes $hw_path/vio_wren -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
    puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_wren} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
   # puts $fw "#80000;"
   # puts $fw "force  $sim_path.vio_wren           = 1;"
    puts $fh "set_property OUTPUT_VALUE 0 \[get_hw_probes $hw_path/vio_wren -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
    puts $fh "commit_hw_vio \[get_hw_probes {$hw_path/vio_wren} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device] -filter {CELL_NAME=~\"$hw_path/u_vio_tg_load\"}]]\n";
   # puts $fw "#80000;"
   # puts $fw "force  $sim_path.vio_wren           = 0;"
   # puts $fw "#80000;"
    set  strb [expr $strb - 1]
    set  dword_cnt [expr $dword_cnt + 8]
  } 
 set  dword_cnt 0
 set  strb      $strb_max
 set  addr [expr $addr + 1]
}

#close $fw
close $fh

