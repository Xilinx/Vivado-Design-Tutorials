#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#an issue exists in Vivado 2022.2 regarding automatic address setting, requiring a revisit to the first RM
#this issue has been resolved in Vivado 2023.1
#assign addresses in rp1rm2 for Vivado 2022.x
current_bd_design [get_bd_designs rp1rm1]
delete_bd_objs [get_bd_addr_segs] [get_bd_addr_segs -excluded]
assign_bd_address
set_property offset 0x80010000 [get_bd_addr_segs {S_AXI/SEG_axi_gpio_0_Reg}]
set_property offset 0x80030000 [get_bd_addr_segs {S_AXI1/SEG_axi_gpio_1_Reg}]
validate_bd_design
save_bd_design


#Upgrade the modified RP BDC at the top. Corresponds to clicking "Refresh Modules" banner at the top
current_bd_design [get_bd_designs design_1]
update_compile_order -fileset sources_1
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design



