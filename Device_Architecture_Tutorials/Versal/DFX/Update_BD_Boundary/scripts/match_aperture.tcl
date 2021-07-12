#set the aperture for RM1
current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]
set_property APERTURES {0xA403_0000 64K} [get_bd_intf_ports /S_AXI_0]
validate_bd_design
save_bd_design

#set the aperture for RM2
current_bd_design [get_bd_designs rp1rm2]
set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]
set_property APERTURES {0xA403_0000 64K} [get_bd_intf_ports /S_AXI_0]
validate_bd_design
save_bd_design

#set the aperture for RM2
current_bd_design [get_bd_designs rp1rm3]
set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]
set_property APERTURES {0xA403_0000 64K} [get_bd_intf_ports /S_AXI_0]
validate_bd_design
save_bd_design

#Upgrade the modified RP BDC at the top. Corresponds to clicking "Refresh Modules" banner at the top
current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
save_bd_design
validate_bd_design
save_bd_design



