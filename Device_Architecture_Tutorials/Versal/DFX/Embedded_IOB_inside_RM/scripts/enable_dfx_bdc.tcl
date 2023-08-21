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

set_property PR_FLOW 1 [current_project]
current_bd_design [get_bd_designs design_1]
#Enable DFX for the BDC rp1 rp2
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells {rp1}]
#Lock the Static-RP interface
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells {rp1}]

current_bd_design rp1rm1
delete_bd_objs [get_bd_addr_segs] [get_bd_addr_segs -excluded]
assign_bd_address
validate_bd_design
save_bd_design

##Validate and Save the Top BD
update_compile_order -fileset sources_1
current_bd_design design_1
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design

