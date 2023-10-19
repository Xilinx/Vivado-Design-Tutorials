#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


#Adding a new DFX Decoupler interface
set_property -dict [list CONFIG.ALL_PARAMS {HAS_AXI_LITE 1 INTF {intf_0 {ID 0 VLNV xilinx.com:interface:aximm_rtl:1.0 MODE slave SIGNALS {ARVALID {PRESENT 1 WIDTH 1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1 WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT 1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY {PRESENT 1 WIDTH 1} AWID {PRESENT 0 WIDTH 0} AWADDR {PRESENT 1 WIDTH 13} AWLEN {PRESENT 1 WIDTH 8} AWSIZE {PRESENT 1 WIDTH 3} AWBURST {PRESENT 1 WIDTH 2} AWLOCK {PRESENT 1 WIDTH 1} AWCACHE {PRESENT 1 WIDTH 4} AWPROT {PRESENT 1 WIDTH 3} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0 WIDTH 0} WID {PRESENT 0 WIDTH 0} WDATA {PRESENT 1 WIDTH 32} WSTRB {PRESENT 1 WIDTH 4} WLAST {PRESENT 1 WIDTH 1} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 0 WIDTH 0} BRESP {PRESENT 1 WIDTH 2} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 0 WIDTH 0} ARADDR {PRESENT 1 WIDTH 13} ARLEN {PRESENT 1 WIDTH 8} ARSIZE {PRESENT 1 WIDTH 3} ARBURST {PRESENT 1 WIDTH 2} ARLOCK {PRESENT 1 WIDTH 1} ARCACHE {PRESENT 1 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} ARREGION {PRESENT 1 WIDTH 4} ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 0 WIDTH 0} RDATA {PRESENT 1 WIDTH 32} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 1 WIDTH 1} RUSER {PRESENT 0 WIDTH 0}}} intf_1 {ID 1 VLNV xilinx.com:interface:aximm_rtl:1.0 MODE slave SIGNALS {ARVALID {PRESENT 1 WIDTH 1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1 WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT 1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY {PRESENT 1 WIDTH 1} AWID {PRESENT 0 WIDTH 0} AWADDR {PRESENT 1 WIDTH 9} AWLEN {PRESENT 0 WIDTH 8} AWSIZE {PRESENT 0 WIDTH 3} AWBURST {PRESENT 0 WIDTH 2} AWLOCK {PRESENT 0 WIDTH 1} AWCACHE {PRESENT 0 WIDTH 4} AWPROT {PRESENT 1 WIDTH 3} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0 WIDTH 0} WID {PRESENT 0 WIDTH 0} WDATA {PRESENT 1 WIDTH 32} WSTRB {PRESENT 1 WIDTH 4} WLAST {PRESENT 0 WIDTH 1} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 0 WIDTH 0} BRESP {PRESENT 1 WIDTH 2} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 0 WIDTH 0} ARADDR {PRESENT 1 WIDTH 9} ARLEN {PRESENT 0 WIDTH 8} ARSIZE {PRESENT 0 WIDTH 3} ARBURST {PRESENT 0 WIDTH 2} ARLOCK {PRESENT 0 WIDTH 1} ARCACHE {PRESENT 0 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} ARREGION {PRESENT 1 WIDTH 4} ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 0 WIDTH 0} RDATA {PRESENT 1 WIDTH 32} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 0 WIDTH 1} RUSER {PRESENT 0 WIDTH 0}} PROTOCOL axi4lite} intf_2 {ID 2 MODE slave VLNV xilinx.com:interface:aximm_rtl:1.0 PROTOCOL axi4lite SIGNALS {ARVALID {PRESENT 1} ARREADY {PRESENT 1} AWVALID {PRESENT 1} AWREADY {PRESENT 1} BVALID {PRESENT 1} BREADY {PRESENT 1} RVALID {PRESENT 1} RREADY {PRESENT 1} WVALID {PRESENT 1} WREADY {PRESENT 1} AWADDR {PRESENT 1} AWLEN {PRESENT 0} AWSIZE {PRESENT 0} AWBURST {PRESENT 0} AWLOCK {PRESENT 0} AWCACHE {PRESENT 0} AWPROT {PRESENT 1} WDATA {PRESENT 1} WSTRB {PRESENT 1} WLAST {PRESENT 0} BRESP {PRESENT 1} ARADDR {PRESENT 1} ARLEN {PRESENT 0} ARSIZE {PRESENT 0} ARBURST {PRESENT 0} ARLOCK {PRESENT 0} ARCACHE {PRESENT 0} ARPROT {PRESENT 1} RDATA {PRESENT 1} RRESP {PRESENT 1} RLAST {PRESENT 0}}}} HAS_SIGNAL_CONTROL 0 HAS_SIGNAL_STATUS 0 IPI_PROP_COUNT 5} CONFIG.GUI_SELECT_INTERFACE {2} CONFIG.GUI_INTERFACE_NAME {intf_2} CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:aximm_rtl:1.0} CONFIG.GUI_INTERFACE_PROTOCOL {axi4lite} CONFIG.GUI_SELECT_MODE {slave} CONFIG.GUI_SIGNAL_SELECT_0 {ARVALID} CONFIG.GUI_SIGNAL_SELECT_1 {ARREADY} CONFIG.GUI_SIGNAL_SELECT_2 {AWVALID} CONFIG.GUI_SIGNAL_SELECT_3 {AWREADY} CONFIG.GUI_SIGNAL_SELECT_4 {BVALID} CONFIG.GUI_SIGNAL_SELECT_5 {BREADY} CONFIG.GUI_SIGNAL_SELECT_6 {RVALID} CONFIG.GUI_SIGNAL_SELECT_7 {RREADY} CONFIG.GUI_SIGNAL_SELECT_8 {WVALID} CONFIG.GUI_SIGNAL_SELECT_9 {WREADY} CONFIG.GUI_SIGNAL_DECOUPLED_0 {true} CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} CONFIG.GUI_SIGNAL_DECOUPLED_2 {true} CONFIG.GUI_SIGNAL_DECOUPLED_3 {true} CONFIG.GUI_SIGNAL_DECOUPLED_4 {true} CONFIG.GUI_SIGNAL_DECOUPLED_5 {true} CONFIG.GUI_SIGNAL_DECOUPLED_6 {true} CONFIG.GUI_SIGNAL_DECOUPLED_7 {true} CONFIG.GUI_SIGNAL_DECOUPLED_8 {true} CONFIG.GUI_SIGNAL_DECOUPLED_9 {true} CONFIG.GUI_SIGNAL_PRESENT_0 {true} CONFIG.GUI_SIGNAL_PRESENT_1 {true} CONFIG.GUI_SIGNAL_PRESENT_2 {true} CONFIG.GUI_SIGNAL_PRESENT_3 {true} CONFIG.GUI_SIGNAL_PRESENT_4 {true} CONFIG.GUI_SIGNAL_PRESENT_5 {true} CONFIG.GUI_SIGNAL_PRESENT_6 {true} CONFIG.GUI_SIGNAL_PRESENT_7 {true} CONFIG.GUI_SIGNAL_PRESENT_8 {true} CONFIG.GUI_SIGNAL_PRESENT_9 {true}] [get_bd_cells static_region/dfx_decoupler_0]

#Adding a new master interface for smc
set_property -dict [list CONFIG.NUM_MI {4}] [get_bd_cells static_region/smartconnect_0]

connect_bd_net [get_bd_pins static_region/dfx_decoupler_0/intf_2_aclk] [get_bd_pins static_region/versal_cips_0/pl0_ref_clk]
connect_bd_net [get_bd_pins static_region/dfx_decoupler_0/intf_2_arstn] [get_bd_pins static_region/proc_sys_reset_0/peripheral_aresetn]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins rp1/S_AXI_0] [get_bd_intf_pins static_region/dfx_decoupler_0/rp_intf_2]
connect_bd_intf_net [get_bd_intf_pins static_region/dfx_decoupler_0/s_intf_2] [get_bd_intf_pins static_region/smartconnect_0/M03_AXI]

validate_bd_design
save_bd_design

