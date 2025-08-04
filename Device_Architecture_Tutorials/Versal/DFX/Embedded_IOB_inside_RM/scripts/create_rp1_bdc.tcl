#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#Creating a hierarchy for rp1 and rp2
group_bd_cells rp1 [get_bd_cells util_ds_buf_0] [get_bd_cells axi_gpio_0] [get_bd_cells axi_gpio_1]
#Creating a hierarchy for static region
group_bd_cells static_region [get_bd_cells clk_wizard_0] [get_bd_cells proc_sys_reset_0] [get_bd_cells smartconnect_0] [get_bd_cells versal_cips_0] [get_bd_cells proc_sys_reset_0] [get_bd_cells dfx_decoupler_0] [get_bd_cells axi_noc_0]
regenerate_bd_layout
validate_bd_design
save_bd_design

set curdesign [current_bd_design]
create_bd_design -cell [get_bd_cells /rp1] rp1rm1
current_bd_design $curdesign
set new_cell [create_bd_cell -type container -reference rp1rm1 rp1_temp]
replace_bd_cell [get_bd_cells /rp1] $new_cell
delete_bd_objs  [get_bd_cells /rp1]
set_property name rp1 $new_cell
current_bd_design [get_bd_designs rp1rm1]
update_compile_order -fileset sources_1
validate_bd_design
save_bd_design


current_bd_design [get_bd_designs design_1]
validate_bd_design
save_bd_design


