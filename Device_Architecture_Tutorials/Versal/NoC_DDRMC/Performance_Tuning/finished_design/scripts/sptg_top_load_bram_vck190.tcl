# © Copyright 2019 – 2020 Xilinx, Inc.
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
set hw_path "design_1_i/sim_trig_0/inst/sim_trig_inst"
set device "xcvc1902_1"
#set device "vjtag40_1"
set csv  "MULTIPLE_CSV"
#set csv  "SINGLE_CSV"
set isptg 0
set jsptg 0
set num_tg [lindex $argv 0]
set where [file dirname [info script]]

set csv_file [lindex $argv 1]
set argv "-csv $csv_file.csv -op_path . -ip_inst output_tg -mem_file_enc h -ip_id all -local_run -prot AXIMM"
source [file join $where ptg_mem.tcl]


if {$csv == "SINGLE_CSV" } {
while {$isptg < $num_tg} {
  set tg $isptg
  source [file join $where sptg_load_bram.tcl]
  set isptg [expr $isptg + 1]
  puts  "DONE: load_bram_hw_tg$tg.tcl generated sucessfully"
}
} elseif {$csv == "MULTIPLE_CSV"} {
     set tg $num_tg
    source [file join $where sptg_load_bram.tcl]
    puts  "DONE: load_bram_hw_tg$num_tg.tcl generated sucessfully"
}


