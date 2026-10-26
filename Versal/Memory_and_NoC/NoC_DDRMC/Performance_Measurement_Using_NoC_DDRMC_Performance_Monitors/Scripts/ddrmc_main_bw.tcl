#Copyright(C) 2025 Advanced Micro Devices, Inc. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Unlock DDRMC_MAIN_[13] NPI registers pcsr_lock
ta 1
after 50
mwr -force 0xf62c000c 0xf9e8d7c6; #DDRMC_MAIN_1
after 50
mwr -force 0xf65a000c 0xf9e8d7c6; #DDRMC_MAIN_3
after 50


#Disable counters dc0_perf_mon and dc1_perf_mon clear, sngl=0, accum_period=1F, disable
ta 1; mwr -force 0xF62C13C0 0x3E; mwr -force 0xF62C13E8 0x3E;
after 50
ta 1; mwr -force 0xF65A13C0 0x3E; mwr -force 0xF65A13E8 0x3E;
after 50

#Clear counters dc0_perf_mon_accu_0 to dc1_perf_mon_8_hi
ta 1; mwr -force 0xF62C13C4 0x0 9; mwr -force 0xF62C13EC 0x0 9;
after 50
ta 1; mwr -force 0xF65A13C4 0x0 9; mwr -force 0xF65A13EC 0x0 9;
after 50

#Start counters dc0_perf_mon and dc1_perf_mon enable
ta 1; mwr -force 0xF62C13C0 0x3F; mwr -force 0xF62C13E8 0x3F;
after 50
ta 1; mwr -force 0xF65A13C0 0x3F; mwr -force 0xF65A13E8 0x3F;
after 50


#Both of these waits appear necessary, otherwise the register reads happen before results are ready.
after 10000
after 10000

ta 1;
after 50


set c1Ch0RdCountNPI [mrd -force 0xF62C13C8]
after 50
scan $c1Ch0RdCountNPI {%x%[:]%x} address - c1Ch0RdCount
after 50
set c1Ch0WrCountNPI [mrd -force 0xF62C13CC]
after 50
scan $c1Ch0WrCountNPI {%x%[:]%x} address - c1Ch0WrCount
after 50
set c1Ch1RdCountNPI [mrd -force 0xF62C13F0]
after 50
scan $c1Ch1RdCountNPI {%x%[:]%x} address - c1Ch1RdCount
after 50
set c1Ch1WrCountNPI [mrd -force 0xF62C13F4]
after 50
scan $c1Ch1WrCountNPI {%x%[:]%x} address - c1Ch1WrCount
after 50
set c3Ch0RdCountNPI [mrd -force 0xF65A13C8]
after 50
scan $c3Ch0RdCountNPI {%x%[:]%x} address - c3Ch0RdCount
after 50
set c3Ch0WrCountNPI [mrd -force 0xF65A13CC]
after 50
scan $c3Ch0WrCountNPI {%x%[:]%x} address - c3Ch0WrCount
after 50
set c3Ch1RdCountNPI [mrd -force 0xF65A13F0]
after 50
scan $c3Ch1RdCountNPI {%x%[:]%x} address - c3Ch1RdCount
after 50
set c3Ch1WrCountNPI [mrd -force 0xF65A13F4]
after 50
scan $c3Ch1WrCountNPI {%x%[:]%x} address - c3Ch1WrCount
after 50

#Accumulation period = 2**accum_period * MC clock period divided by 2
#accum_period = 0x1F from above
set timebaseDiv2 [expr {2**31}]
after 50

#MCClockFreqMHz = memory clock frequency from Vivado / 2
set MCClockFreqMHz [expr {1949.00/2}]
after 50
puts "MCClockFreqMHz $MCClockFreqMHz"
after 50

#Dual channel LP4 x32 per channel with burst length of 16 = 64B per read or write
set MCClockFreqMHzTimes64 [expr {64.0 * $MCClockFreqMHz}]

set c1Ch0RdBW [expr {[expr {$c1Ch0RdCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c1Ch0WrBW [expr {[expr {$c1Ch0WrCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c1Ch1RdBW [expr {[expr {$c1Ch1RdCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c1Ch1WrBW [expr {[expr {$c1Ch1WrCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c3Ch0RdBW [expr {[expr {$c3Ch0RdCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c3Ch0WrBW [expr {[expr {$c3Ch0WrCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c3Ch1RdBW [expr {[expr {$c3Ch1RdCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50
set c3Ch1WrBW [expr {[expr {$c3Ch1WrCount * $MCClockFreqMHzTimes64}] / $timebaseDiv2 }]
after 50

puts "DDRMC_1 Channel 0 Read BW $c1Ch0RdBW"
after 50
puts "DDRMC_1 Channel 0 Write BW $c1Ch0WrBW"
after 50
puts "DDRMC_1 Channel 1 Read BW $c1Ch1RdBW"
after 50
puts "DDRMC_1 Channel 1 Write BW $c1Ch1WrBW"
after 50
puts "DDRMC_3 Channel 0 Read BW $c3Ch0RdBW"
after 50
puts "DDRMC_3 Channel 0 Write BW $c3Ch0WrBW"
after 50
puts "DDRMC_3 Channel 1 Read BW $c3Ch1RdBW"
after 50
puts "DDRMC_3 Channel 1 Write BW $c3Ch1WrBW"

