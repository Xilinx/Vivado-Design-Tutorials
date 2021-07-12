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


#Create a hierarchy for RP1
group_bd_cells rp1 [get_bd_cells smartconnect_0] [get_bd_cells xlconstant_1] [get_bd_cells axi_gpio_1] [get_bd_cells axi_noc_1]
#Create a hierarchy for static region
group_bd_cells static_region [get_bd_cells smartconnect_1] [get_bd_cells xlconstant_0] [get_bd_cells versal_cips_0] [get_bd_cells clk_wizard_0] [get_bd_cells axi_gpio_0] [get_bd_cells axi_noc_0] [get_bd_cells proc_sys_reset_0]

regenerate_bd_layout
validate_bd_design
save_bd_design

#Create the block design container for hierarchy RP1
set curdesign [current_bd_design]
create_bd_design -cell [get_bd_cells /rp1] rp1rm1
current_bd_design $curdesign
set new_cell [create_bd_cell -type container -reference rp1rm1 rp1_temp]
replace_bd_cell [get_bd_cells /rp1] $new_cell
delete_bd_objs  [get_bd_cells /rp1]
set_property name rp1 $new_cell
current_bd_design [get_bd_designs rp1rm1]
update_compile_order -fileset sources_1
set_property range 64K [get_bd_addr_segs {S00_INI/SEG_axi_gpio_1_Reg}]
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design

