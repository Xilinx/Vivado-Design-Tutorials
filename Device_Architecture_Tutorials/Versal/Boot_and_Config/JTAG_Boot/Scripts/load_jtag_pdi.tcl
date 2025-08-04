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
# Example commands below to program the reference design PDI
# Update connect_hw_server, current_hw_target for target board
# Update PROGRAM_FILE location
################################################################################

#start_gui
#open_hw_manager
#connect_hw_server -url gomphus2:3121 -allow_non_jtag
#current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/12805005A099A]
#set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Xilinx/12805005A099A]

#open_hw_target
#current_hw_device [get_hw_devices xcvc1902_1]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvc1902_1] 0]

#set_property PROBES.FILE {} [get_hw_devices xcvc1902_1]
#set_property FULL_PROBES.FILE {} [get_hw_devices xcvc1902_1]
#set_property PROGRAM.FILE {C:/JTAGBoot/runs/jtagboot_es1_<timestamp>/project_1.runs/impl_1/design_1_wrapper.pdi} [get_hw_devices xcvc1902_1]
#program_hw_devices [get_hw_devices xcvc1902_1]
#refresh_hw_device [lindex [get_hw_devices xcvc1902_1] 0]
