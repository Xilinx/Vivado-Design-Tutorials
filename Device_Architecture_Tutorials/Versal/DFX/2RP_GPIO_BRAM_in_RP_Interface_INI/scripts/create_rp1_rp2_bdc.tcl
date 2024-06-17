#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#Create a hierarchy for static region
group_bd_cells static_region [get_bd_cells clk_wizard_0] [get_bd_cells axi_bram_ctrl_0] [get_bd_cells smartconnect_0] [get_bd_cells versal_cips_0] [get_bd_cells xlconstant_0] [get_bd_cells axi_gpio_0] [get_bd_cells proc_sys_reset_0] [get_bd_cells axi_noc_0] [get_bd_cells axi_bram_ctrl_0_bram]
#Create a hierarchy for RP1
group_bd_cells rp1 [get_bd_cells smartconnect_1] [get_bd_cells axi_gpio_1] [get_bd_cells axi_noc_1] [get_bd_cells xlconstant_1]
#Create a hierarchy for RP2
group_bd_cells rp2 [get_bd_cells axi_bram_ctrl_1] [get_bd_cells axi_bram_ctrl_1_bram] [get_bd_cells axi_noc_2]
validate_bd_design
save_bd_design

#Create BDC for the RP1 hierarchy
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

#Reflect the changes made in RP1 at the top BD
current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design

#Create BDC for the RP2 hierarchy
set curdesign [current_bd_design]
create_bd_design -cell [get_bd_cells /rp2] rp2rm1
current_bd_design $curdesign
set new_cell [create_bd_cell -type container -reference rp2rm1 rp2_temp]
replace_bd_cell [get_bd_cells /rp2] $new_cell
delete_bd_objs  [get_bd_cells /rp2]
set_property name rp2 $new_cell
current_bd_design [get_bd_designs rp2rm1]
update_compile_order -fileset sources_1
set_property range 8K [get_bd_addr_segs {S00_INI/SEG_axi_bram_ctrl_1_Mem0}]
validate_bd_design
save_bd_design

#Reflect the changes made in RP2 at the top BD
current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp2]
validate_bd_design
save_bd_design


