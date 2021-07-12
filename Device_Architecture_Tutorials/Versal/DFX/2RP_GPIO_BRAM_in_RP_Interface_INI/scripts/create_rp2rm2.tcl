#create rp2rm2.bd
current_bd_design [get_bd_designs design_1]
set curdesign [current_bd_design]
create_bd_design -boundary_from_container [get_bd_cells /rp2] rp2rm2
current_bd_design $curdesign
set_property -dict [list CONFIG.LIST_SYNTH_BD {rp2rm1.bd:rp2rm2.bd} CONFIG.LIST_SIM_BD {rp2rm1.bd:rp2rm2.bd}] [get_bd_cells /rp2]
current_bd_design [get_bd_designs rp2rm2]
update_compile_order -fileset sources_1

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
set_property -dict [list CONFIG.NUM_SI {0} CONFIG.NUM_NSI {1}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } CONFIG.INI_STRATEGY {load}] [get_bd_intf_pins /axi_noc_0/S00_INI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {M00_AXI}] [get_bd_pins /axi_noc_0/aclk0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]

connect_bd_intf_net [get_bd_intf_ports S00_INI] [get_bd_intf_pins axi_noc_0/S00_INI]
connect_bd_net [get_bd_ports aclk0] [get_bd_pins axi_noc_0/aclk0]
connect_bd_net [get_bd_ports aclk0] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_noc_0/M00_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]

assign_bd_address -target_address_space /S00_INI [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
set_property offset 0x20180002000 [get_bd_addr_segs {S00_INI/SEG_axi_bram_ctrl_0_Mem0}]
set_property range 8K [get_bd_addr_segs {S00_INI/SEG_axi_bram_ctrl_0_Mem0}]
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs design_1]
validate_bd_design
save_bd_design

