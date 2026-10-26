# © Copyright 2021 Xilinx, Inc.
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

set hex2bin_map {
  0  0000
  1  0001
  2  0010
  3  0011
  4  0100
  5  0101
  6  0110
  7  0111
  8  1000
  9  1001
  a  1010
  b  1011
  c  1100
  d  1101
  e  1110
  f  1111
}

proc hextobin { hex size } {
  global hex2bin_map
  if {![string is xdigit $hex]} {
    error "value \"$hex\" is not a hex integer"
  }
  set bin [string map -nocase $hex2bin_map $hex]
  set l [string length $bin]
  if { $l < $size} {
    return [format %0${size}s $bin]
  } else {
    return [string range $bin [expr $l - $size] [expr $l - 1]]
  }
}

proc toHex {decval} {
 set top48 [expr $decval/0x100000000]
 set low32 [expr $decval%0x100000000]
 return [format %012lX%08X $top48 $low32]
}


#Get stop() call count
set stop_count [mrd -force -value 0xFFFC0034]

#Get overflow counter value
#set overflow [mrd -force -value 0xFFFC0010]


#13C0 offset if only 1 start and stop
#set bin_period [string range [hextobin [toHex [mrd -force -value 0xFFFC0018]] 32] 26 30] always 11111
#set bin_period [string range [hextobin [toHex [mrd -force -value 0xFFFC0018]] 32] 26 30]
#set accum_period [expr "0b$bin_period"]
#set accum_cycle [expr 2**$accum_period]
#set bin_rollover [string range [hextobin [toHex [mrd -force -value 0xFFFC0018]] 32] 15 25]
#set num_rollover [expr "0b$bin_rollover"]
#set C [expr $accum_cycle * $num_rollover]
set apuCyclesTaken [expr [mrd -force -value 0xFFFC0038]]
after 100
set ddrCyclesTaken [expr $apuCyclesTaken * [expr double(1964.0 / 1350.0)] ]
set C $ddrCyclesTaken

#set accum_cycle 0;

#set period_addr 0xFFFC0018;
#for {set i 0} {$i < 28} {incr i} {
#	set bin_period [string range [hextobin [toHex [mrd -force -value $period_addr]] 32] 26 30]
#        set dec_period [expr "0b$bin_period"]
#	set accum_cycle [expr $dec_period+$accum_cycle]
#	set period_addr [expr $period_addr+0x4]
#}
#set C [expr 2**$accum_cycle]

#13C4 offset
set bin_act_00 [string range [hextobin [toHex [mrd -force -value 0xFFFC0004]] 32] 1 31]
set act_00 [expr "0b$bin_act_00"]

#13C8 offset
set bin_read_cas_00 [string range [hextobin [toHex [mrd -force -value 0xFFFC0008]] 32] 1 31]
set read_cas_00 [expr "0b$bin_read_cas_00"]
set rd_efficiency_00 [expr double($read_cas_00*8)/$C]
set rd_bandwidth_00 [expr $rd_efficiency_00*62.848]


#13CC offset
set bin_write_cas_00 [string range [hextobin [toHex [mrd -force -value 0xFFFC000C]] 32] 1 31]
set write_cas_00 [expr "0b$bin_write_cas_00"]
set wr_efficiency_00 [expr double($write_cas_00*8)/$C]
set wr_bandwidth_00 [expr $wr_efficiency_00*62.848]

#13C4 offset
set bin_act_01 [string range [hextobin [toHex [mrd -force -value 0xFFFC0010]] 32] 1 31]
set act_01 [expr "0b$bin_act_01"]

#13C8 offset
set bin_read_cas_01 [string range [hextobin [toHex [mrd -force -value 0xFFFC0014]] 32] 1 31]
set read_cas_01 [expr "0b$bin_read_cas_01"]

#13CC offset
set bin_write_cas_01 [string range [hextobin [toHex [mrd -force -value 0xFFFC0018]] 32] 1 31]
set write_cas_01 [expr "0b$bin_write_cas_01"]

#13C4 offset
set bin_act_10 [string range [hextobin [toHex [mrd -force -value 0xFFFC001C]] 32] 1 31]
set act_10 [expr "0b$bin_act_10"]

#13C8 offset
set bin_read_cas_10 [string range [hextobin [toHex [mrd -force -value 0xFFFC0020]] 32] 1 31]
set read_cas_10 [expr "0b$bin_read_cas_10"]

#13CC offset
set bin_write_cas_10 [string range [hextobin [toHex [mrd -force -value 0xFFFC0024]] 32] 1 31]
set write_cas_10 [expr "0b$bin_write_cas_10"]

#13C4 offset
set bin_act_11 [string range [hextobin [toHex [mrd -force -value 0xFFFC0028]] 32] 1 31]
set act_11 [expr "0b$bin_act_11"]

#13C8 offset
set bin_read_cas_11 [string range [hextobin [toHex [mrd -force -value 0xFFFC002C]] 32] 1 31]
set read_cas_11 [expr "0b$bin_read_cas_11"]

#13CC offset
set bin_write_cas_11 [string range [hextobin [toHex [mrd -force -value 0xFFFC0030]] 32] 1 31]
set write_cas_11 [expr "0b$bin_write_cas_11"]

#Calculate total read BW
set read_cas_all [expr ($read_cas_00 + $read_cas_01 + $read_cas_10 + $read_cas_11)]
set read_data_all [expr ($read_cas_all * 64)]
set read_data_per_apu [expr ($read_data_all / [expr double($apuCyclesTaken)])]
set read_bw_all [expr double($read_data_per_apu * 1350.0)]

#Calculate total write BW
set write_cas_all [expr ($write_cas_00 + $write_cas_01 + $write_cas_10 + $write_cas_11)]
set write_data_all [expr ($write_cas_all * 64)]
set write_data_per_apu [expr ($write_data_all / [expr double($apuCyclesTaken)])]
set write_bw_all [expr double($write_data_per_apu * 1350.0)]

puts " **********************************************"
puts "\n"
#puts "    STOP() count              $stop_count"
#puts "    Overflow counter          $overflow"
#puts "\n"
#puts "    DC Accumulation Period    $accum_period" 
puts "    Cycles Accumulated        $C" 
puts "\n"
puts "    ACTIVATE_00               $act_00"
puts "    ACTIVATE_01               $act_01"
puts "    ACTIVATE_10               $act_10"
puts "    ACTIVATE_11               $act_11"
puts "\n"
puts "    READ CAS_00               $read_cas_00"
puts "    READ CAS_01               $read_cas_01"
puts "    READ CAS_10               $read_cas_10"
puts "    READ CAS_11               $read_cas_11"
puts "    READ CAS_ALL              $read_cas_all"
puts "    READ DAT_ALL              $read_data_all"
puts "    READ DAT_PER_APU          $read_data_per_apu"
puts "    READ EFFICIENCY           $rd_efficiency_00"
puts "    READ BANDWIDTH            $rd_bandwidth_00"
puts "    TOTAL READ BANDWIDTH      $read_bw_all"
puts "\n"
puts "    WRITE CAS_00              $write_cas_00" 
puts "    WRITE CAS_01              $write_cas_01" 
puts "    WRITE CAS_10              $write_cas_10" 
puts "    WRITE CAS_11              $write_cas_11" 
puts "    WRITE DAT_ALL             $write_data_all"
puts "    WRITE DAT_PER_APU         $write_data_per_apu"
puts "    WRITE EFFICIENCY          $wr_efficiency_00"
puts "    WRITE BANDWIDTH           $wr_bandwidth_00"
puts "    TOTAL WRITE BANDWIDTH     $write_bw_all"
puts "\n"
puts " **********************************************"

