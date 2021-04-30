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

#Unlock various NPI register spaces
#mwr 0xF615000C 0xF9E8D7C6 ; #DDRMC_MAIN_0
mwr 0xF62C000C 0xF9E8D7C6 ; #DDRMC_MAIN_1
mwr 0xF65A000C 0xF9E8D7C6 ; #DDRMC_MAIN_3
#mwr 0xF611000C 0xF9E8D7C6 ; #DDRMC_UB_0
#mwr 0xF628000C 0xF9E8D7C6 ; #DDRMC_UB_1
#mwr 0xF656000C 0xF9E8D7C6 ; #DDRMC_UB_3
#mwr 0xF6110000 0x3C ; #ddrmc_pcsr_mask.ODISABLE Not sure why these two were set
#mwr 0xF6110004 0x3C ; #ddrmc_pcsr_control.ODISABLE

#Clear DDRMC_MAIN_0_DC0 perf_mon control and counters
#mwr 0xF61513C0 0x0000003E ; #dc0_perf_mon accum_period = 2^31 DDRMC clock period / 2
#mwr 0xF61513C4 0x00000000 ; #dc0_perf_mon_0 act_count
#mwr 0xF61513C8 0x00000000 ; #dc0_perf_mon_1 rd_count
#mwr 0xF61513CC 0x00000000 ; #dc0_perf_mon_2 wr_count
#mwr 0xF61513D0 0x00000000 ; #dc0_perf_mon_3 pre_count
#mwr 0xF61513D4 0x00000000 ; #dc0_perf_mon_4 prea_count
#mwr 0xF61513D8 0x00000000 ; #dc0_perf_mon_5 ref_count
#mwr 0xF61513DC 0x00000000 ; #dc0_perf_mon_6 qe_count
#mwr 0xF61513E0 0x00000000 ; #dc0_perf_mon_7 oh_count
#mwr 0xF61513E4 0x00000000 ; #dc0_perf_mon_8 ta_count

#Clear DDRMC_MAIN_0_DC1 perf_mon control and counters
#mwr 0xF61513E8 0x0000003E ; #dc1_perf_mon accum_period = 2^31 DDRMC clock period / 2
#mwr 0xF61513EC 0x00000000 ; #dc1_perf_mon_0 act_count
#mwr 0xF61513F0 0x00000000 ; #dc1_perf_mon_1 rd_count
#mwr 0xF61513F4 0x00000000 ; #dc1_perf_mon_2 wr_count
#mwr 0xF61513F8 0x00000000 ; #dc1_perf_mon_3 pre_count
#mwr 0xF61513FC 0x00000000 ; #dc1_perf_mon_4 prea_count
#mwr 0xF6151400 0x00000000 ; #dc1_perf_mon_5 ref_count
#mwr 0xF6151404 0x00000000 ; #dc1_perf_mon_6 qe_count
#mwr 0xF6151408 0x00000000 ; #dc1_perf_mon_7 oh_count
#mwr 0xF615140C 0x00000000 ; #dc1_perf_mon_8 ta_count

#Clear DDRMC_MAIN_1_DC0 perf_mon control and counters
mwr 0xF62C13C0 0x0000003E ; #dc0_perf_mon accum_period = 2^31 DDRMC clock period / 2
mwr 0xF62C13C4 0x00000000 ; #dc0_perf_mon_0 act_count
mwr 0xF62C13C8 0x00000000 ; #dc0_perf_mon_1 rd_count
mwr 0xF62C13CC 0x00000000 ; #dc0_perf_mon_2 wr_count
mwr 0xF62C13D0 0x00000000 ; #dc0_perf_mon_3 pre_count
mwr 0xF62C13D4 0x00000000 ; #dc0_perf_mon_4 prea_count
mwr 0xF62C13D8 0x00000000 ; #dc0_perf_mon_5 ref_count
mwr 0xF62C13DC 0x00000000 ; #dc0_perf_mon_6 qe_count
mwr 0xF62C13E0 0x00000000 ; #dc0_perf_mon_7 oh_count
mwr 0xF62C13E4 0x00000000 ; #dc0_perf_mon_8 ta_count

#Clear DDRMC_MAIN_1_DC1 perf_mon control and counters
mwr 0xF62C13E8 0x0000003E ; #dc1_perf_mon accum_period = 2^31 DDRMC clock period / 2
mwr 0xF62C13EC 0x00000000 ; #dc1_perf_mon_0 act_count
mwr 0xF62C13F0 0x00000000 ; #dc1_perf_mon_1 rd_count
mwr 0xF62C13F4 0x00000000 ; #dc1_perf_mon_2 wr_count
mwr 0xF62C13F8 0x00000000 ; #dc1_perf_mon_3 pre_count
mwr 0xF62C13FC 0x00000000 ; #dc1_perf_mon_4 prea_count
mwr 0xF62C1400 0x00000000 ; #dc1_perf_mon_5 ref_count
mwr 0xF62C1404 0x00000000 ; #dc1_perf_mon_6 qe_count
mwr 0xF62C1408 0x00000000 ; #dc1_perf_mon_7 oh_count
mwr 0xF62C140C 0x00000000 ; #dc1_perf_mon_8 ta_count

#Clear DDRMC_MAIN_3_DC0 perf_mon control and counters
mwr 0xF65A13C0 0x0000003E ; #dc0_perf_mon accum_period = 2^31 DDRMC clock period / 2
mwr 0xF65A13C4 0x00000000 ; #dc0_perf_mon_0 act_count
mwr 0xF65A13C8 0x00000000 ; #dc0_perf_mon_1 rd_count
mwr 0xF65A13CC 0x00000000 ; #dc0_perf_mon_2 wr_count
mwr 0xF65A13D0 0x00000000 ; #dc0_perf_mon_3 pre_count
mwr 0xF65A13D4 0x00000000 ; #dc0_perf_mon_4 prea_count
mwr 0xF65A13D8 0x00000000 ; #dc0_perf_mon_5 ref_count
mwr 0xF65A13DC 0x00000000 ; #dc0_perf_mon_6 qe_count
mwr 0xF65A13E0 0x00000000 ; #dc0_perf_mon_7 oh_count
mwr 0xF65A13E4 0x00000000 ; #dc0_perf_mon_8 ta_count

#Clear DDRMC_MAIN_3_DC1 perf_mon control and counters
mwr 0xF65A13E8 0x0000003E ; #dc1_perf_mon accum_period = 2^31 DDRMC clock period / 2
mwr 0xF65A13EC 0x00000000 ; #dc1_perf_mon_0 act_count
mwr 0xF65A13F0 0x00000000 ; #dc1_perf_mon_1 rd_count
mwr 0xF65A13F4 0x00000000 ; #dc1_perf_mon_2 wr_count
mwr 0xF65A13F8 0x00000000 ; #dc1_perf_mon_3 pre_count
mwr 0xF65A13FC 0x00000000 ; #dc1_perf_mon_4 prea_count
mwr 0xF65A1400 0x00000000 ; #dc1_perf_mon_5 ref_count
mwr 0xF65A1404 0x00000000 ; #dc1_perf_mon_6 qe_count
mwr 0xF65A1408 0x00000000 ; #dc1_perf_mon_7 oh_count
mwr 0xF65A140C 0x00000000 ; #dc1_perf_mon_8 ta_count

#mwr 0xF61513C0 0x0000003F
#mwr 0xF61513E8 0x0000003F
#
#ODISABLE
#mwr 0xF6110000 0x3C ; #ddrmc_pcsr_mask.ODISABLE Not sure why these two were set
#mwr 0xF6110004 0x00 ; #ddrmc_pcsr_control.ODISABLE
