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
#Enable DFX for the BDC rp1 rp2
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells {rp1 rp2}]
#Lock the Static-RP interface
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells {rp1 rp2}]
#Set the Aperture for the interface ports of RP1
set_property APERTURES {0x80010000 64K} [get_bd_intf_pins /rp1/S_AXI]
set_property APERTURES {0x80030000 64K} [get_bd_intf_pins /rp2/S_AXI]

##Validate and Save the Top BD
validate_bd_design
save_bd_design

