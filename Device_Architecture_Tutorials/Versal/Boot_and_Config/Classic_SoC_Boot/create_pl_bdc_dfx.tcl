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

#Create a hierarchy for the Programmable Logic (PL)
group_bd_cells PL [get_bd_cells axi_bram_ctrl_0] [get_bd_cells smartconnect_0] [get_bd_cells proc_sys_reset_0] [get_bd_cells emb_mem_gen_0]

regenerate_bd_layout
validate_bd_design
save_bd_design

#Create the block design container for hierarchy PL
startgroup
set curdesign [current_bd_design]
create_bd_design -cell [get_bd_cells /PL] bram_bd
current_bd_design $curdesign
set new_cell [create_bd_cell -type container -reference bram_bd PL_temp]
replace_bd_cell [get_bd_cells /PL] $new_cell
delete_bd_objs  [get_bd_cells /PL]
set_property name PL $new_cell
endgroup
current_bd_design [get_bd_designs bram_bd]
update_compile_order -fileset sources_1

#Convert the block design container to DFX
current_bd_design [get_bd_designs top]
set_property -dict [list CONFIG.LOCK_PROPAGATE {true} CONFIG.ENABLE_DFX {true}] [get_bd_cells PL]
regenerate_bd_layout
validate_bd_design
save_bd_design


