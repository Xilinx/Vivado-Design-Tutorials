# © Copyright 2019 – 2022 Xilinx, Inc.
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

################################################################################
# Script sets up unique directory with timestamp and generates ref design
################################################################################

catch {internal::enable_all_devices}

#Setup project directory
set epoch [clock seconds]
set proj_dir ./runs

#Run script to generate reference design and create PDI
source ./Scripts/create_jtag_refdesign.tcl

#PL GPIO constraints file input source
add_files -fileset constrs_1 -norecurse ./Design/pl.xdc
import_files -fileset constrs_1 ./Design/pl.xdc

#Setup
generate_target  all  [get_files  $proj_dir/project_1.srcs/sources_1/bd/design_1/design_1.bd]
set_property generate_synth_checkpoint true [get_files -norecurse *.bd]
make_wrapper -files [get_files $proj_dir/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $proj_dir/project_1.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
write_bd_layout -format pdf -force -orientation portrait jtagboot_es1.pdf

launch_runs impl_1 -to_step write_device_image -jobs 16
wait_on_run impl_1

open_run impl_1

write_hw_platform -fixed -force -include_bit -file jtagboot_es1.xsa
