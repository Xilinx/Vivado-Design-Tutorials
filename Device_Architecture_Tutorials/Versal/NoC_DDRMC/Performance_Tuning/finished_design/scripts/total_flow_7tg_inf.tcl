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
set path "design_1_i/sim_trig_0/inst/sim_trig_inst"
set device "xcvc1902_1"
#set device "vjtag40_1"
source ./op_fl_gen.tcl
source ./read_register.tcl
source ./write_register.tcl
source ./start.tcl
source ./start_all.tcl
source ./pause.tcl
source ./reset.tcl
set argv [list 0 4TG_LIN_MC1_3TG_RND_MC3_M1]
source sptg_top_load_bram_vck190.tcl
set argv [list 1 4TG_LIN_MC1_3TG_RND_MC3_M2]
source sptg_top_load_bram_vck190.tcl
set argv [list 2 4TG_LIN_MC1_3TG_RND_MC3_M3]
source sptg_top_load_bram_vck190.tcl
set argv [list 3 4TG_LIN_MC1_3TG_RND_MC3_M4]
source sptg_top_load_bram_vck190.tcl
set argv [list 4 4TG_LIN_MC1_3TG_RND_MC3_M5]
source sptg_top_load_bram_vck190.tcl
set argv [list 5 4TG_LIN_MC1_3TG_RND_MC3_M6]
source sptg_top_load_bram_vck190.tcl
set argv [list 6 4TG_LIN_MC1_3TG_RND_MC3_M7]
source sptg_top_load_bram_vck190.tcl
pause 0
pause 1
pause 2
pause 3
pause 4
pause 5
pause 6
after 1000
reset 0
reset 1
reset 2
reset 3
reset 4
reset 5
reset 6
source ./load_bram_hw_tg0.tcl
source ./load_bram_hw_tg1.tcl
source ./load_bram_hw_tg2.tcl
source ./load_bram_hw_tg3.tcl
source ./load_bram_hw_tg4.tcl
source ./load_bram_hw_tg5.tcl
source ./load_bram_hw_tg6.tcl

set window_start 4000000 ; # Start bandwidth counters in TG after 4,000,000 TG clock cycles
set window_size 4000000 ; # Run bandwidth counters in TG for 4,000,000 TG clock cycles
set window_stop [expr {$window_start + $window_size}]

set window_start_hex [format %08X $window_start]
set window_stop_hex [format %08X $window_stop]

write_reg 0000_42D0 0000_0001
write_reg 0000_42D4 $window_start_hex
write_reg 0000_42D8 $window_stop_hex
write_reg 0001_42D0 0000_0001
write_reg 0001_42D4 $window_start_hex
write_reg 0001_42D8 $window_stop_hex
write_reg 0002_42D0 0000_0001
write_reg 0002_42D4 $window_start_hex
write_reg 0002_42D8 $window_stop_hex
write_reg 0003_42D0 0000_0001
write_reg 0003_42D4 $window_start_hex
write_reg 0003_42D8 $window_stop_hex
write_reg 0004_42D0 0000_0001
write_reg 0004_42D4 $window_start_hex
write_reg 0004_42D8 $window_stop_hex
write_reg 0005_42D0 0000_0001
write_reg 0005_42D4 $window_start_hex
write_reg 0005_42D8 $window_stop_hex
write_reg 0006_42D0 0000_0001
write_reg 0006_42D4 $window_start_hex
write_reg 0006_42D8 $window_stop_hex
start_all
after 10000 
set argv [list 0 4TG_LIN_MC1_3TG_RND_MC3_M1]
source ./rd_wr_eff_lat.tcl
set argv [list 1 4TG_LIN_MC1_3TG_RND_MC3_M2]
source ./rd_wr_eff_lat.tcl
set argv [list 2 4TG_LIN_MC1_3TG_RND_MC3_M3]
source ./rd_wr_eff_lat.tcl
set argv [list 3 4TG_LIN_MC1_3TG_RND_MC3_M4]
source ./rd_wr_eff_lat.tcl
set argv [list 4 4TG_LIN_MC1_3TG_RND_MC3_M5]
source ./rd_wr_eff_lat.tcl
set argv [list 5 4TG_LIN_MC1_3TG_RND_MC3_M6]
source ./rd_wr_eff_lat.tcl
set argv [list 6 4TG_LIN_MC1_3TG_RND_MC3_M7]
source ./rd_wr_eff_lat.tcl
after 1000

