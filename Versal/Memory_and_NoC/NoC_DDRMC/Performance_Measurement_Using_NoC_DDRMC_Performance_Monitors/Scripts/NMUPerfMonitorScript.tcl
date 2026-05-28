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

puts "AXI NoC_1 NMUs (Linear Traffic)"
puts "----------------------------------------"
puts "----------------------------------------"


#design_1_i/axi_noc_1/inst/S01_AXI_nmu/bd_4bb4_S01_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X0Y6 | 0xF6F60000 | 0x100000000 | 0x106F60000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6F6000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
mwr -force 0xF6F6088C 0x0000000B
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6F608AC 0x00000003
after 500
#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6F60880]
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set timebaseOver22 [expr {2**22}]
set NPIFreqMHz 300.00
set NMU_X0Y6_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y6 Write BW $NMU_X0Y6_BW"
#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6F608A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count_read
set NMU_X0Y6_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y6 Read BW $NMU_X0Y6_BW"


#Write
puts "----------------------------------------"
puts "Write Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0870)   00000067 ('d103)
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6F60870]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0874)	 000001CC ('d406)
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6F60874]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) (0878)	0
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6F60878]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits) (087C) 00F3C1DB ('d15974875)
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6F6087C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR_Dec"

#Read REG_PERF_MON0_CNT_AND_OFL (0884)	0
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F60884]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL_Dec"

#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Average Latency $averageLatency"

#Read
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6F60890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6F60894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6F60898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6F6089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F608A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count_read }]
puts "Average Latency $averageLatency"
puts ""
puts ""








#design_1_i/axi_noc_1/inst/S02_AXI_nmu/bd_4bb4_S02_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X0Y3 | 0xF6EE0000 | 0x100000000 | 0x106EE0000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6EE000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
mwr -force 0xF6EE088C 0x0000000B
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6EE08AC 0x00000003
after 500
#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6EE0880]
#puts "reg_perf_mon_burst_count $reg_perf_mon_burst_count"
#Read REG_PERF_MON0_CNT_AND_OFL
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6EE0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set NMU_X0Y3_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y3 Write BW $NMU_X0Y3_BW"

#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6EE08A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count_read
set NMU_X0Y3_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y3 Read BW $NMU_X0Y3_BW"

#Write
puts "----------------------------------------"
puts "Write Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0870)   00000067 ('d103)
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6EE0870]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0874)	 000001CC ('d406)
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6EE0874]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) (0878)	0
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6EE0878]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits) (087C) 00F3C1DB ('d15974875)
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6EE087C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR_Dec"

#Read REG_PERF_MON0_CNT_AND_OFL (0884)	0
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6EE0884]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL_Dec"

#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Average Latency $averageLatency"

#Read
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6EE0890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6EE0894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6EE0898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6EE089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6EE08A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count_read }]
puts "Average Latency $averageLatency"
puts ""
puts ""







#design_1_i/axi_noc_1/inst/S03_AXI_nmu/bd_4bb4_S03_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X0Y1 | 0xF6E90000 | 0x100000000 | 0x106E90000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6E9000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
mwr -force 0xF6E9088C 0x0000000B
after 500
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6E908AC 0x00000003
#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6E90880]
#puts "reg_perf_mon_burst_count $reg_perf_mon_burst_count"
#Read REG_PERF_MON0_CNT_AND_OFL
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6E90884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set NMU_X0Y1_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y1 Write BW $NMU_X0Y1_BW"

#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6E908A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count_read
set NMU_X0Y1_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y1 Read BW $NMU_X0Y1_BW" 

#Write
puts "----------------------------------------"
puts "Write Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0870)   00000067 ('d103)
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6E90870]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0874)	 000001CC ('d406)
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6E90874]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) (0878)	0
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6E90878]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits) (087C) 00F3C1DB ('d15974875)
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6E9087C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR_Dec"

#Read REG_PERF_MON0_CNT_AND_OFL (0884)	0
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6E90884]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL_Dec"

#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Average Latency $averageLatency"

#Read
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6E90890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6E90894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6E90898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6E9089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6E908A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count_read }]
puts "Read Average Latency $averageLatency"
puts ""
puts ""








#design_1_i/axi_noc_1/inst/S00_AXI_nmu/bd_4bb4_S00_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X0Y5 | 0xF6F30000 | 0x100000000 | 0x106F30000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6F3000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
mwr -force 0xF6F3088C 0x0000000B
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6F308AC 0x00000003
after 500
#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6F30880]
#puts "reg_perf_mon_burst_count $reg_perf_mon_burst_count"
#Read REG_PERF_MON0_CNT_AND_OFL
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F30884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set NMU_X0Y5_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y5 Write BW $NMU_X0Y5_BW"

#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6F308A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count_read
set NMU_X0Y5_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y5 Read BW $NMU_X0Y5_BW"

#Write
puts "----------------------------------------"
puts "Write Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0870)   00000067 ('d103)
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6F30870]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0874)	 000001CC ('d406)
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6F30874]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) (0878)	0
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6F30878]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits) (087C) 00F3C1DB ('d15974875)
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6F3087C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR_Dec"

#Read REG_PERF_MON0_CNT_AND_OFL (0884)	0
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F30884]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL_Dec"

#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Average Latency $averageLatency"

#Read
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6F30890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6F30894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6F30898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6F3089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F308A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count_read }]
puts "Average Latency $averageLatency"
puts ""
puts ""










puts "AXI NoC_3 NMUs (Random Traffic)"
puts "----------------------------------------"
puts "----------------------------------------"
#design_1_i/axi_noc_3/inst/S02_AXI_nmu/bd_8b15_S02_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X2Y6 | 0xF6BC0000 | 0x100000000 | 0x106BC0000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6BC000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
#mwr -force 0xF6BC088C 0x0000000B
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6BC08AC 0x00000003
#after 500
#Read REG_PERF_MON0_BURST_CNT
#set reg_perf_mon_burst_count_npi [mrd -force 0xF6BC0880]
#Read REG_PERF_MON0_CNT_AND_OFL
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6BC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
#set NMU_X2Y6_BW [expr {[expr {$reg_perf_mon_burst_count * 128* $NPIFreqMHz}] / $timebaseOver22 }]
#puts "NMU512_X2Y6 Write BW $NMU_X2Y6_BW"

#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6BC08A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set NMU_X2Y6_BW [expr {[expr {$reg_perf_mon_burst_count * 128 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X2Y6 Read BW $NMU_X2Y6_BW"
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6BC0890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6BC0894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6BC0898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6BC089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6BC08A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Read Average Latency $averageLatency"
puts ""
puts ""











 
#design_1_i/axi_noc_3/inst/S00_AXI_nmu/bd_8b15_S00_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X2Y5 | 0xF6B90000 | 0x100000000 | 0x106B90000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6B9000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
mwr -force 0xF6B9088C 0x0000000B
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6B908AC 0x00000003
after 500
#Read REG_PERF_MON0_BURST_CNT
#set reg_perf_mon_burst_count_npi [mrd -force 0xF6B90880]
#puts "reg_perf_mon_burst_count $reg_perf_mon_burst_count"
#Read REG_PERF_MON0_CNT_AND_OFL
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6B90884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set NMU_X2Y5_BW [expr {[expr {$reg_perf_mon_burst_count * 128 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X2Y5 Write BW $NMU_X2Y5_BW"

#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6B908A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count_read
set NMU_X0Y5_BW [expr {[expr {$reg_perf_mon_burst_count * 128 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X2Y5 Read BW $NMU_X2Y5_BW"

#Write
puts "----------------------------------------"
puts "Write Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0870)   00000067 ('d103)
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6B90870]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0874)	 000001CC ('d406)
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6B90874]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) (0878)	0
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6B90878]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits) (087C) 00F3C1DB ('d15974875)
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6B9087C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR_Dec"

#Read REG_PERF_MON0_CNT_AND_OFL (0884)	0
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6B90884]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL_Dec"

#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Average Latency $averageLatency"

#Read
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6B90890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6B90894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6B90898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6B9089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6B908A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count_read }]
puts "Average Latency $averageLatency"
puts ""
puts ""








#design_1_i/axi_noc_3/inst/S01_AXI_nmu/bd_8b15_S01_AXI_nmu_0_top_INST/NOC_NMU512_INST |
#NOC_NMU512_X0Y4 | 0xF6F10000 | 0x100000000 | 0x106F10000 | 0
#Unlock NMU PCSR_LOCK 
mwr -force 0xF6F1000C 0xF9E8D7C6
#Enable Performance Monitor, Latency Select End of burst (EOB), No Filter, Writes 
#mwr -force 0xF6F1088C 0x0000000B
#Enable Read Performance Monitor, Latency Select End of burst (EOB), No Filter, Reads 
mwr -force 0xF6F108AC 0x00000003
#after 500
#Read REG_PERF_MON0_BURST_CNT
#set reg_perf_mon_burst_count_npi [mrd -force 0xF6F10880]
#puts "reg_perf_mon_burst_count $reg_perf_mon_burst_count"
#Read REG_PERF_MON0_CNT_AND_OFL
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F10884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
#set NMU_X0Y4_BW [expr {[expr {$reg_perf_mon_burst_count * 128 * $NPIFreqMHz}] / $timebaseOver22 }]
#puts "NMU512_X0Y4 Write BW $NMU_X0Y4_BW"

#Read REG_PERF_MON0_BURST_CNT
set reg_perf_mon_burst_count_npi [mrd -force 0xF6F108A0]
#set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6AC0884]
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
scan $reg_perf_mon_burst_count_npi {%x%[:]%x} address - reg_perf_mon_burst_count
set NMU_X0Y4_BW [expr {[expr {$reg_perf_mon_burst_count * 128 * $NPIFreqMHz}] / $timebaseOver22 }]
puts "NMU512_X0Y4 Read BW $NMU_X0Y4_BW"

#Read
puts "----------------------------------------"
puts "Read Latency"
puts "----------------------------------------"
#Read REG_PERF_MON0_LATENCY_MIN (0890)   
set REG_PERF_MON0_LATENCY_MIN [mrd -force 0xF6F10890]
scan $REG_PERF_MON0_LATENCY_MIN {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MIN_Dec
puts "REG_PERF_MON0_LATENCY_MIN $REG_PERF_MON0_LATENCY_MIN_Dec"

#Read REG_PERF_MON0_LATENCY_MAX (0894)	 
set REG_PERF_MON0_LATENCY_MAX [mrd -force 0xF6F10894]
scan $REG_PERF_MON0_LATENCY_MAX {%x%[:]%x} address - REG_PERF_MON0_LATENCY_MAX_Dec
puts "REG_PERF_MON0_LATENCY_MAX $REG_PERF_MON0_LATENCY_MAX_Dec"

#Read REG_PERF_MON0_LATENCY_ACC_UPR 	(Accumulated latency upper 16-bits) 0898
set REG_PERF_MON0_LATENCY_ACC_UPR [mrd -force 0xF6F10898]
scan $REG_PERF_MON0_LATENCY_ACC_UPR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_UPR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_UPR $REG_PERF_MON0_LATENCY_ACC_UPR"

#Read REG_PERF_MON0_LATENCY_ACC_LWR	(Accumulated latency lower 32-bits)  089c
set REG_PERF_MON0_LATENCY_ACC_LWR [mrd -force 0xF6F1089C]
scan $REG_PERF_MON0_LATENCY_ACC_LWR {%x%[:]%x} address - REG_PERF_MON0_LATENCY_ACC_LWR_Dec
#puts "REG_PERF_MON0_LATENCY_ACC_LWR $REG_PERF_MON0_LATENCY_ACC_LWR"

#Read REG_PERF_MON0_CNT_AND_OFL (08A4)	
set REG_PERF_MON0_CNT_AND_OFL [mrd -force 0xF6F108A4]
scan $REG_PERF_MON0_CNT_AND_OFL {%x%[:]%x} address - REG_PERF_MON0_CNT_AND_OFL_Dec
#puts "REG_PERF_MON0_CNT_AND_OFL $REG_PERF_MON0_CNT_AND_OFL"
#Write Average Latency 
set averageLatency [expr {[expr {$REG_PERF_MON0_LATENCY_ACC_LWR_Dec + $REG_PERF_MON0_LATENCY_ACC_UPR_Dec}] / $reg_perf_mon_burst_count }]
puts "Average Latency $averageLatency"


