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

#an issue exists in Vivado 2022.x regarding automatic address setting, requiring a revisit to the first RM
#this issue has been resolved in Vivado 2023.1
#assign addresses in rp1rm2 for Vivado 2022.x
current_bd_design [get_bd_designs rp1rm1]
delete_bd_objs [get_bd_addr_segs] [get_bd_addr_segs -excluded]
assign_bd_address


#Upgrade the modified RP BDC at the top. Corresponds to clicking "Refresh Modules" banner at the top
current_bd_design [get_bd_designs design_1]
update_compile_order -fileset sources_1
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design



