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
set fs  [open write_reg.tcl w]
puts $fs "proc write_reg { a d  } {"

puts $fs "set_property OUTPUT_VALUE 0 \[get_hw_probes $path/vio_wren -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
puts $fs "commit_hw_vio \[get_hw_probes {$path/vio_wren} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $fs "set_property OUTPUT_VALUE \$a \[get_hw_probes $path/vio_addr_t -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
puts $fs "commit_hw_vio \[get_hw_probes {$path/vio_addr_t} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $fs "set_property OUTPUT_VALUE \$d \[get_hw_probes $path/vio_wdata -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
puts $fs "commit_hw_vio \[get_hw_probes {$path/vio_wdata} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $fs "set_property OUTPUT_VALUE 1 \[get_hw_probes $path/vio_wren -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
puts $fs "commit_hw_vio \[get_hw_probes {$path/vio_wren} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"

puts $fs "set_property OUTPUT_VALUE 0 \[get_hw_probes $path/vio_wren -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
puts $fs "commit_hw_vio \[get_hw_probes {$path/vio_wren} -of_objects \[get_hw_vios -of_objects \[get_hw_devices $device\] -filter {CELL_NAME=~\"$path/u_vio_tg_load\"\}\]\]"
puts $fs "}"

close $fs

source ./write_reg.tcl
