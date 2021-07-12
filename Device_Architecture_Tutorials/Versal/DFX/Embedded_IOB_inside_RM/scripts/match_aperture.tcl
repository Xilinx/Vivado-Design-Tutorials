# #########################################################################
#© Copyright 2021 Xilinx, Inc.

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
# ###########################################################################

#set the aperture for RP1
current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {{0x8001_0000 64K}} [get_bd_intf_ports /S_AXI]
set_property APERTURES {{0x8003_0000 64K}} [get_bd_intf_ports /S_AXI1]
validate_bd_design
save_bd_design

#set the aperture for RP2
current_bd_design [get_bd_designs rp1rm2]
set_property APERTURES {{0x8001_0000 64K}} [get_bd_intf_ports /S_AXI]
set_property APERTURES {{0x8003_0000 64K}} [get_bd_intf_ports /S_AXI1]
validate_bd_design
save_bd_design


#Upgrade the modified RP BDC at the top. Corresponds to clicking "Refresh Modules" banner at the top
current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design



