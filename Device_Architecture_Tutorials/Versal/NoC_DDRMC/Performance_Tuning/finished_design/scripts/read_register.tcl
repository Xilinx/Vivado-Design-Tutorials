# © Copyright 2019 – 2023 Xilinx, Inc.
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
set frg [open read_reg.tcl w]


puts $frg "set_property INPUT_VALUE_RADIX UNSIGNED \[get_hw_probes $path/vio_rdata -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
 

puts $frg "proc read_reg { r  } {"

puts $frg "set_property OUTPUT_VALUE \$r \[get_hw_probes $path/vio_addr_t -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]]"

puts $frg "commit_hw_vio \[get_hw_probes {$path/vio_addr_t} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $frg "set_property OUTPUT_VALUE 1 \[get_hw_probes $path/vio_rden -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $frg "commit_hw_vio \[get_hw_probes {$path/vio_rden} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $frg "set_property OUTPUT_VALUE 0 \[get_hw_probes $path/vio_rden -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $frg "commit_hw_vio \[get_hw_probes {$path/vio_rden} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $frg "refresh_hw_vio -update_output_values \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]"
puts $frg "return \[format %x \[get_property INPUT_VALUE \[get_hw_probes  $path/vio_rdata -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]\]\]"
puts $frg "}"

close $frg

source ./read_reg.tcl
