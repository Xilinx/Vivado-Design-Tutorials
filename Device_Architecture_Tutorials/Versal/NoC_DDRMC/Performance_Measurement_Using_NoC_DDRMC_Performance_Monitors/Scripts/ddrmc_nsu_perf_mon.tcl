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

#Unlock DDRMC_NOC_1 and 3 NPI registers pcsr_lock
ta 1; mwr -force 0xF621000C 0xF9E8D7C6;
ta 1; mwr -force 0xF64F000C 0xF9E8D7C6;

#Change all four timebases from default 0x17 to 0x19
ta 1; mwr -force 0xF62104D4 0x000CE739;
ta 1; mwr -force 0xF64F04D4 0x000CE739;

#Disable counters nsu0_perf_mon_ctl_0_0, nsu0_perf_mon_ctl_1_0, nsu1_perf_mon_ctl_0_0, nsu1_perf_mon_ctl_1_0,
#nsu2_perf_mon_ctl_0_0, nsu2_perf_mon_ctl_1_0, nsu3_perf_mon_ctl_0_0, nsu3_perf_mon_ctl_1_0
ta 1; mwr -force 0xF62104D8 0x0; mwr -force 0xF62104F8 0x0;
ta 1; mwr -force 0xF6210518 0x0; mwr -force 0xF6210538 0x0;
ta 1; mwr -force 0xF6210558 0x0; mwr -force 0xF6210578 0x0;
ta 1; mwr -force 0xF6210598 0x0; mwr -force 0xF62105B8 0x0;
ta 1; mwr -force 0xF64F04D8 0x0; mwr -force 0xF64F04F8 0x0;
ta 1; mwr -force 0xF64F0518 0x0; mwr -force 0xF64F0538 0x0;
ta 1; mwr -force 0xF64F0558 0x0; mwr -force 0xF64F0578 0x0;
ta 1; mwr -force 0xF64F0598 0x0; mwr -force 0xF64F05B8 0x0;

#Set perf_mon_0 to BER and perf_mon_1 to BEW
ta 1; mwr -force 0xF62104DC 0x023; mwr -force 0xF62104FC 0x083;
ta 1; mwr -force 0xF621051C 0x023; mwr -force 0xF621053C 0x083;
ta 1; mwr -force 0xF621055C 0x023; mwr -force 0xF621057C 0x083;
ta 1; mwr -force 0xF621059C 0x023; mwr -force 0xF62105BC 0x083;
ta 1; mwr -force 0xF64F04DC 0x023; mwr -force 0xF64F04FC 0x083;
ta 1; mwr -force 0xF64F051C 0x023; mwr -force 0xF64F053C 0x083;
ta 1; mwr -force 0xF64F055C 0x023; mwr -force 0xF64F057C 0x083;
ta 1; mwr -force 0xF64F059C 0x023; mwr -force 0xF64F05BC 0x083;

#Clear counters nsu[01]_perf_mon_[01]*
ta 1; mwr -force 0xF62104EC 0x0 3; mwr -force 0xF621050C 0x0 3;
ta 1; mwr -force 0xF621052C 0x0 3; mwr -force 0xF621054C 0x0 3;
ta 1; mwr -force 0xF621056C 0x0 3; mwr -force 0xF621058C 0x0 3;
ta 1; mwr -force 0xF62105AC 0x0 3; mwr -force 0xF62105CC 0x0 3;
ta 1; mwr -force 0xF64F04EC 0x0 3; mwr -force 0xF64F050C 0x0 3;
ta 1; mwr -force 0xF64F052C 0x0 3; mwr -force 0xF64F054C 0x0 3;
ta 1; mwr -force 0xF64F056C 0x0 3; mwr -force 0xF64F058C 0x0 3;
ta 1; mwr -force 0xF64F05AC 0x0 3; mwr -force 0xF64F05CC 0x0 3;


#Start counters nsu[01]_perf_mon_[01]
ta 1; mwr -force 0xF62104D8 0x1; mwr -force 0xF62104F8 0x1;
ta 1; mwr -force 0xF6210518 0x1; mwr -force 0xF6210538 0x1;
ta 1; mwr -force 0xF6210558 0x1; mwr -force 0xF6210578 0x1;
ta 1; mwr -force 0xF6210598 0x1; mwr -force 0xF62105B8 0x1;
ta 1; mwr -force 0xF64F04D8 0x1; mwr -force 0xF64F04F8 0x1;
ta 1; mwr -force 0xF64F0518 0x1; mwr -force 0xF64F0538 0x1;
ta 1; mwr -force 0xF64F0558 0x1; mwr -force 0xF64F0578 0x1;
ta 1; mwr -force 0xF64F0598 0x1; mwr -force 0xF64F05B8 0x1;

after 50
puts "\nPrinting after enabling counts..."
after 50
set c1Ch0BERBurstCountNPI [mrd -force 0xF62104F0]
scan $c1Ch0BERBurstCountNPI {%x%[:]%x} address - c1Ch0BERBurstCount
set c1Ch0BEWBurstCountNPI [mrd -force 0xF6210510]
scan $c1Ch0BEWBurstCountNPI {%x%[:]%x} address - c1Ch0BEWBurstCount
set c1Ch1BERBurstCountNPI [mrd -force 0xF6210530]
scan $c1Ch1BERBurstCountNPI {%x%[:]%x} address - c1Ch1BERBurstCount
set c1Ch1BEWBurstCountNPI [mrd -force 0xF6210550]
scan $c1Ch1BEWBurstCountNPI {%x%[:]%x} address - c1Ch1BEWBurstCount
set c1Ch2BERBurstCountNPI [mrd -force 0xF6210570]
scan $c1Ch2BERBurstCountNPI {%x%[:]%x} address - c1Ch2BERBurstCount
set c1Ch2BEWBurstCountNPI [mrd -force 0xF6210590]
scan $c1Ch2BEWBurstCountNPI {%x%[:]%x} address - c1Ch2BEWBurstCount
set c1Ch3BERBurstCountNPI [mrd -force 0xF62105B0]
scan $c1Ch3BERBurstCountNPI {%x%[:]%x} address - c1Ch3BERBurstCount
set c1Ch3BEWBurstCountNPI [mrd -force 0xF62105D0]
scan $c1Ch3BEWBurstCountNPI {%x%[:]%x} address - c1Ch3BEWBurstCount
set c3Ch0BERBurstCountNPI [mrd -force 0xF64F04F0]
scan $c3Ch0BERBurstCountNPI {%x%[:]%x} address - c3Ch0BERBurstCount
set c3Ch0BEWBurstCountNPI [mrd -force 0xF64F0510]
scan $c3Ch0BEWBurstCountNPI {%x%[:]%x} address - c3Ch0BEWBurstCount
set c3Ch1BERBurstCountNPI [mrd -force 0xF64F0530]
scan $c3Ch1BERBurstCountNPI {%x%[:]%x} address - c3Ch1BERBurstCount
set c3Ch1BEWBurstCountNPI [mrd -force 0xF64F0550]
scan $c3Ch1BEWBurstCountNPI {%x%[:]%x} address - c3Ch1BEWBurstCount
set c3Ch2BERBurstCountNPI [mrd -force 0xF64F0570]
scan $c3Ch2BERBurstCountNPI {%x%[:]%x} address - c3Ch2BERBurstCount
set c3Ch2BEWBurstCountNPI [mrd -force 0xF64F0590]
scan $c3Ch2BEWBurstCountNPI {%x%[:]%x} address - c3Ch2BEWBurstCount
set c3Ch3BERBurstCountNPI [mrd -force 0xF64F05B0]
scan $c3Ch3BERBurstCountNPI {%x%[:]%x} address - c3Ch3BERBurstCount
set c3Ch3BEWBurstCountNPI [mrd -force 0xF64F05D0]
scan $c3Ch3BEWBurstCountNPI {%x%[:]%x} address - c3Ch3BEWBurstCount

#Each NoC databurst is 16B
#timebaseOver16 = selected timebase value divided by 16.  Default timebase = 0x17
set timebaseOver16 [expr {2**21}]
set NoCFreqMHz 1000.00
puts "NoCFreqMHz $NoCFreqMHz"
set c1Ch0BERBW [expr {[expr {$c1Ch0BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c1Ch1BERBW [expr {[expr {$c1Ch1BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c1Ch2BERBW [expr {[expr {$c1Ch2BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c1Ch3BERBW [expr {[expr {$c1Ch3BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch0BERBW [expr {[expr {$c3Ch0BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch1BERBW [expr {[expr {$c3Ch1BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch2BERBW [expr {[expr {$c3Ch2BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch3BERBW [expr {[expr {$c3Ch3BERBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
puts "DDRMC_1 Port 0 Read BW $c1Ch0BERBW"
puts "DDRMC_1 Port 1 Read BW $c1Ch1BERBW"
puts "DDRMC_1 Port 2 Read BW $c1Ch2BERBW"
puts "DDRMC_1 Port 3 Read BW $c1Ch3BERBW"
puts "DDRMC_3 Port 0 Read BW $c3Ch0BERBW"
puts "DDRMC_3 Port 1 Read BW $c3Ch1BERBW"
puts "DDRMC_3 Port 2 Read BW $c3Ch2BERBW"
puts "DDRMC_3 Port 3 Read BW $c3Ch3BERBW"
set c1Ch0BEWBW [expr {[expr {$c1Ch0BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c1Ch1BEWBW [expr {[expr {$c1Ch1BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c1Ch2BEWBW [expr {[expr {$c1Ch2BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c1Ch3BEWBW [expr {[expr {$c1Ch3BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch0BEWBW [expr {[expr {$c3Ch0BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch1BEWBW [expr {[expr {$c3Ch1BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch2BEWBW [expr {[expr {$c3Ch2BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
set c3Ch3BEWBW [expr {[expr {$c3Ch3BEWBurstCount * $NoCFreqMHz}] / $timebaseOver16 }]
puts "DDRMC_1 Port 0 Write BW $c1Ch0BEWBW"
puts "DDRMC_1 Port 1 Write BW $c1Ch1BEWBW"
puts "DDRMC_1 Port 2 Write BW $c1Ch2BEWBW"
puts "DDRMC_1 Port 3 Write BW $c1Ch3BEWBW"
puts "DDRMC_3 Port 0 Write BW $c3Ch0BEWBW"
puts "DDRMC_3 Port 1 Write BW $c3Ch1BEWBW"
puts "DDRMC_3 Port 2 Write BW $c3Ch2BEWBW"
puts "DDRMC_3 Port 3 Write BW $c3Ch3BEWBW"


