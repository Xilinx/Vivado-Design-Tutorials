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

group_bd_cells hier_1 [get_bd_cells xlconstant_0] [get_bd_cells axi_gpio_1]
validate_bd_design
save_bd_design

startgroup
set curdesign [current_bd_design]
create_bd_design -cell [get_bd_cells /hier_1] gpio_rm1

current_bd_design $curdesign
set new_cell [create_bd_cell -type container -reference gpio_rm1 hier_1_temp]

replace_bd_cell [get_bd_cells /hier_1] $new_cell
delete_bd_objs  [get_bd_cells /hier_1]
set_property name hier_1 $new_cell
endgroup
current_bd_design [get_bd_designs gpio_rm1]
update_compile_order -fileset sources_1
current_bd_design [get_bd_designs dfx_shdn_mgr]
validate_bd_design
regenerate_bd_layout
save_bd_design
