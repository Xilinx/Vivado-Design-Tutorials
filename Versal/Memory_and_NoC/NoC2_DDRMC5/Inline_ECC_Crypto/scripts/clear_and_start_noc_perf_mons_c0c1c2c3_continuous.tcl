#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


#Define Register Base Addresses
set DDRMC5E_NOC_0_BASE 0xF6550000
set DDRMC5E_NOC_1_BASE 0xF6640000
set DDRMC5E_NOC_2_BASE 0xF6B80000
set DDRMC5E_NOC_3_BASE 0xF6ED0000
set DDRMC5E_NOC_4_BASE 0xF6FB0000

#Define Register Offset Addresses
set pcsr_lock 0xC
set nsu0_perf_mon_ctl_0_0 0x488
set nsu0_perf_mon_ctl_1_0 0x4C8
set nsu1_perf_mon_ctl_0_0 0x508
set nsu1_perf_mon_ctl_1_0 0x548
set nsu0_perf_mon_ctl_0_1 0x48C
set nsu0_perf_mon_ctl_1_1 0x4CC
set nsu1_perf_mon_ctl_0_1 0x50C
set nsu1_perf_mon_ctl_1_1 0x54C
set nsu0_perf_mon_0_0 0x49C
set nsu0_perf_mon_1_0 0x4DC
set nsu1_perf_mon_0_0 0x51C
set nsu1_perf_mon_1_0 0x55C
set nsu0_perf_mon_0_2 0x4A4
set nsu0_perf_mon_1_2 0x4E4
set nsu1_perf_mon_0_2 0x524
set nsu1_perf_mon_1_2 0x564

#Unlock DDRMC5E_NOC_0,1,2,3 and 4 NPI registers pcsr_lock
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $pcsr_lock}] 0xF9E8D7C6;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $pcsr_lock}] 0xF9E8D7C6;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $pcsr_lock}] 0xF9E8D7C6;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $pcsr_lock}] 0xF9E8D7C6;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $pcsr_lock}] 0xF9E8D7C6;

#Disable counters nsu0_perf_mon_ctl_0, nsu0_perf_mon_ctl_1, nsu1_perf_mon_ctl_0, nsu1_perf_mon_ctl_1
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_1_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_ctl_0_0}] 0x0;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_ctl_1_0}] 0x0;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_0_0}] 0x0;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_1_0}] 0x0;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_ctl_0_0}] 0x0;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_ctl_1_0}] 0x0;

#Set perf_mon_0 to BER and perf_mon_1 to BEW
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_1_1}] 0x103;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_ctl_0_1}] 0x043;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_ctl_1_1}] 0x103;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_0_1}] 0x043;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_1_1}] 0x103;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_ctl_0_1}] 0x043;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_ctl_1_1}] 0x103;

#Clear counters nsu[01]_perf_mon_[01]*
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_1_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_0_0}] 0x0 11;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_1_0}] 0x0 11;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_0_0}] 0x0 11;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_1_0}] 0x0 11;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_0_0}] 0x0 11;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_1_0}] 0x0 11;

#Print perfmon register contents
#puts "\nPrinting cleared registers ..."
#ta 1; mrd -force 0xF72F1030 42;

#Start counters nsu[01]_perf_mon_[01]
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_1_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_ctl_0_0}] 0x1;
ta 1; mwr -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_ctl_1_0}] 0x1;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_0_0}] 0x1;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_1_0}] 0x1;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_ctl_0_0}] 0x1;
#ta 1; mwr -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_ctl_1_0}] 0x1;

after 50
puts "\nPrinting after enabling counts..."
#Print perfmon register contents
after 50
ta 1; mrd -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_ctl_0_0}] 64;

set c4Ch0BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_0_2}]]
scan $c4Ch0BERBurstCountNPI {%x%[:]%x} address - c4Ch0BERBurstCount
set c4Ch0BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_0_BASE + $nsu0_perf_mon_1_2}]]
scan $c4Ch0BEWBurstCountNPI {%x%[:]%x} address - c4Ch0BEWBurstCount
set c4Ch1BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_0_2}]]
scan $c4Ch1BERBurstCountNPI {%x%[:]%x} address - c4Ch1BERBurstCount
set c4Ch1BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_0_BASE + $nsu1_perf_mon_1_2}]]
scan $c4Ch1BEWBurstCountNPI {%x%[:]%x} address - c4Ch1BEWBurstCount

ta 1; mrd -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_ctl_0_0}] 64;

set c3Ch0BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_0_2}]]
scan $c3Ch0BERBurstCountNPI {%x%[:]%x} address - c3Ch0BERBurstCount
set c3Ch0BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_1_BASE + $nsu0_perf_mon_1_2}]]
scan $c3Ch0BEWBurstCountNPI {%x%[:]%x} address - c3Ch0BEWBurstCount
set c3Ch1BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_0_2}]]
scan $c3Ch1BERBurstCountNPI {%x%[:]%x} address - c3Ch1BERBurstCount
set c3Ch1BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_1_BASE + $nsu1_perf_mon_1_2}]]
scan $c3Ch1BEWBurstCountNPI {%x%[:]%x} address - c3Ch1BEWBurstCount

ta 1; mrd -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_ctl_0_0}] 64;

set c2Ch0BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_0_2}]]
scan $c2Ch0BERBurstCountNPI {%x%[:]%x} address - c2Ch0BERBurstCount
set c2Ch0BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_2_BASE + $nsu0_perf_mon_1_2}]]
scan $c2Ch0BEWBurstCountNPI {%x%[:]%x} address - c2Ch0BEWBurstCount
set c2Ch1BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_0_2}]]
scan $c2Ch1BERBurstCountNPI {%x%[:]%x} address - c2Ch1BERBurstCount
set c2Ch1BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_2_BASE + $nsu1_perf_mon_1_2}]]
scan $c2Ch1BEWBurstCountNPI {%x%[:]%x} address - c2Ch1BEWBurstCount

ta 1; mrd -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_ctl_0_0}] 64;

set c1Ch0BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_0_2}]]
scan $c1Ch0BERBurstCountNPI {%x%[:]%x} address - c1Ch0BERBurstCount
set c1Ch0BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_3_BASE + $nsu0_perf_mon_1_2}]]
scan $c1Ch0BEWBurstCountNPI {%x%[:]%x} address - c1Ch0BEWBurstCount
set c1Ch1BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_0_2}]]
scan $c1Ch1BERBurstCountNPI {%x%[:]%x} address - c1Ch1BERBurstCount
set c1Ch1BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_3_BASE + $nsu1_perf_mon_1_2}]]
scan $c1Ch1BEWBurstCountNPI {%x%[:]%x} address - c1Ch1BEWBurstCount

#ta 1; mrd -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_ctl_0_0}] 64;

#set c0Ch0BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_0_2}]]
#scan $c0Ch0BERBurstCountNPI {%x%[:]%x} address - c0Ch0BERBurstCount
#set c0Ch0BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_4_BASE + $nsu0_perf_mon_1_2}]]
#scan $c0Ch0BEWBurstCountNPI {%x%[:]%x} address - c0Ch0BEWBurstCount
#set c0Ch1BERBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_0_2}]]
#scan $c0Ch1BERBurstCountNPI {%x%[:]%x} address - c0Ch1BERBurstCount
#set c0Ch1BEWBurstCountNPI [mrd -force [expr {$DDRMC5E_NOC_4_BASE + $nsu1_perf_mon_1_2}]]
#scan $c0Ch1BEWBurstCountNPI {%x%[:]%x} address - c0Ch1BEWBurstCount

set timebaseOver16 [expr {2**18}]
set NPIFreqMHz 299.997009
puts "NPIFreqMHz $NPIFreqMHz"
set c4Ch0BERBW [expr {[expr {$c4Ch0BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c4Ch1BERBW [expr {[expr {$c4Ch1BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c3Ch0BERBW [expr {[expr {$c3Ch0BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c3Ch1BERBW [expr {[expr {$c3Ch1BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c2Ch0BERBW [expr {[expr {$c2Ch0BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c2Ch1BERBW [expr {[expr {$c2Ch1BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c1Ch0BERBW [expr {[expr {$c1Ch0BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c1Ch1BERBW [expr {[expr {$c1Ch1BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
#set c0Ch0BERBW [expr {[expr {$c0Ch0BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
#set c0Ch1BERBW [expr {[expr {$c0Ch1BERBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
puts "CH4_LPDDR5X (GCM) Channel 0 Read BW $c4Ch0BERBW"
puts "CH4_LPDDR5X (GCM) Channel 1 Read BW $c4Ch1BERBW"
puts "CH3_LPDDR5X (XTS) Channel 0 Read BW $c3Ch0BERBW"
puts "CH3_LPDDR5X (XTS) Channel 1 Read BW $c3Ch1BERBW"
puts "CH2_LPDDR5X (ILECC) Channel 0 Read BW $c2Ch0BERBW"
puts "CH2_LPDDR5X (ILECC) Channel 1 Read BW $c2Ch1BERBW"
puts "CH1_LPDDR5X (None) Channel 0 Read BW $c1Ch0BERBW"
puts "CH1_LPDDR5X (None) Channel 1 Read BW $c1Ch1BERBW"
#puts "DDRMC_4 Channel 0 Read BW $c0Ch0BERBW"
#puts "DDRMC_4 Channel 1 Read BW $c0Ch1BERBW"
set c4Ch0BEWBW [expr {[expr {$c4Ch0BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c4Ch1BEWBW [expr {[expr {$c4Ch1BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c3Ch0BEWBW [expr {[expr {$c3Ch0BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c3Ch1BEWBW [expr {[expr {$c3Ch1BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c2Ch0BEWBW [expr {[expr {$c2Ch0BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c2Ch1BEWBW [expr {[expr {$c2Ch1BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c1Ch0BEWBW [expr {[expr {$c1Ch0BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
set c1Ch1BEWBW [expr {[expr {$c1Ch1BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
#set c0Ch0BEWBW [expr {[expr {$c0Ch0BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
#set c0Ch1BEWBW [expr {[expr {$c0Ch1BEWBurstCount * $NPIFreqMHz}] / $timebaseOver16 }]
puts "CH4_LPDDR5X (GCM) Channel 0 Write BW $c4Ch0BEWBW"
puts "CH4_LPDDR5X (GCM) Channel 1 Write BW $c4Ch1BEWBW"
puts "CH3_LPDDR5X (XTS) Channel 0 Write BW $c3Ch0BEWBW"
puts "CH3_LPDDR5X (XTS) Channel 1 Write BW $c3Ch1BEWBW"
puts "CH2_LPDDR5X (ILECC) Channel 0 Write BW $c2Ch0BEWBW"
puts "CH2_LPDDR5X (ILECC) Channel 1 Write BW $c2Ch1BEWBW"
puts "CH1_LPDDR5X (None) Channel 0 Write BW $c1Ch0BEWBW"
puts "CH1_LPDDR5X (None) Channel 1 Write BW $c1Ch1BEWBW"
#puts "DDRMC_4 Channel 0 Write BW $c0Ch0BEWBW"
#puts "DDRMC_4 Channel 1 Write BW $c0Ch1BEWBW"
