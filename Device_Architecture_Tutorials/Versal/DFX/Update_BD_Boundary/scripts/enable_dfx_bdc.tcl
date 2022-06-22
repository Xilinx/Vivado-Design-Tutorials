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


current_bd_design [get_bd_designs design_1]
#Enable DFX for the BDC rp1
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells rp1]
##Lock the Static-RP interface
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells rp1]

#Observed that aperture in rp1rm1 is not reflected to right value. Hence manually setting
current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]
#Validate and Save the Top BD
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
##Validate and Save the Top BD
validate_bd_design
save_bd_design
