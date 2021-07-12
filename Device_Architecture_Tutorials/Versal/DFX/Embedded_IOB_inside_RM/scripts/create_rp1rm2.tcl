set curdesign [current_bd_design]
create_bd_design -boundary_from_container [get_bd_cells /rp1] rp1rm2
current_bd_design $curdesign
set_property -dict [list CONFIG.LIST_SYNTH_BD {rp1rm1.bd:rp1rm2.bd} CONFIG.LIST_SIM_BD {rp1rm1.bd:rp1rm2.bd}] [get_bd_cells /rp1]
current_bd_design [get_bd_designs rp1rm2]
update_compile_order -fileset sources_1
regenerate_bd_layout
#Creating IPs of RP1RM2
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0
set_property -dict [list CONFIG.C_BUF_TYPE {IOBUF}] [get_bd_cells util_ds_buf_0]
set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
#Connecting RM Ports to IPs
connect_bd_intf_net [get_bd_intf_ports S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_ports S_AXI1] [get_bd_intf_pins smartconnect_0/S01_AXI]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins smartconnect_0/aclk]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
connect_bd_net [get_bd_ports IOBUF_IO_IO] [get_bd_pins util_ds_buf_0/IOBUF_IO_IO]
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins util_ds_buf_0/IOBUF_IO_I]
connect_bd_intf_net [get_bd_intf_ports GPIO_0] [get_bd_intf_pins axi_gpio_0/GPIO2]

regenerate_bd_layout
#Assign address

assign_bd_address
set_property offset 0x80010000 [get_bd_addr_segs {S_AXI/SEG_axi_gpio_0_Reg}]
set_property offset 0x80030000 [get_bd_addr_segs {S_AXI1/SEG_axi_gpio_0_Reg}]
validate_bd_design
save_bd_design
