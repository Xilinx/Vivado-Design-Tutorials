# #########################################################################
#Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.

#SPDX-License-Identifier: MIT
# ###########################################################################


########################################################################
# NOTE: This is a tool-generated file and should not be edited manually.
########################################################################

# Core: u_ila_0
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_MEMORY_TYPE 0 [get_debug_cores u_ila_0]
set_property C_NUM_OF_PROBES 5 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
connect_debug_port u_ila_0/clk [get_nets [list {design_1_i/clk_wizard_0/inst/clock_primitive_inst/clk_out1} ]]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/rtl_block_0/inst/L[0]} {design_1_i/rtl_block_0/inst/L[1]} {design_1_i/rtl_block_0/inst/L[2]} {design_1_i/rtl_block_0/inst/L[3]} {design_1_i/rtl_block_0/inst/L[4]} {design_1_i/rtl_block_0/inst/L[5]} {design_1_i/rtl_block_0/inst/L[6]} {design_1_i/rtl_block_0/inst/L[7]} {design_1_i/rtl_block_0/inst/L[8]} {design_1_i/rtl_block_0/inst/L[9]} {design_1_i/rtl_block_0/inst/L[10]} {design_1_i/rtl_block_0/inst/L[11]} {design_1_i/rtl_block_0/inst/L[12]} {design_1_i/rtl_block_0/inst/L[13]} {design_1_i/rtl_block_0/inst/L[14]} {design_1_i/rtl_block_0/inst/L[15]} {design_1_i/rtl_block_0/inst/L[16]} {design_1_i/rtl_block_0/inst/L[17]} {design_1_i/rtl_block_0/inst/L[18]} {design_1_i/rtl_block_0/inst/L[19]} {design_1_i/rtl_block_0/inst/L[20]} {design_1_i/rtl_block_0/inst/L[21]} {design_1_i/rtl_block_0/inst/L[22]} {design_1_i/rtl_block_0/inst/L[23]} {design_1_i/rtl_block_0/inst/L[24]} {design_1_i/rtl_block_0/inst/L[25]} {design_1_i/rtl_block_0/inst/L[26]} {design_1_i/rtl_block_0/inst/L[27]} {design_1_i/rtl_block_0/inst/L[28]} {design_1_i/rtl_block_0/inst/L[29]} {design_1_i/rtl_block_0/inst/L[30]} {design_1_i/rtl_block_0/inst/L[31]} ]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/rtl_block_0/inst/CE} ]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/rtl_block_0/inst/LOAD} ]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/rtl_block_0/inst/SCLR} ]]
create_debug_port u_ila_0 probe
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/rtl_block_0/inst/UP} ]]
create_debug_port u_ila_0 probe
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/rtl_block_0/inst/Q[0]} {design_1_i/rtl_block_0/inst/Q[1]} {design_1_i/rtl_block_0/inst/Q[2]} {design_1_i/rtl_block_0/inst/Q[3]} {design_1_i/rtl_block_0/inst/Q[4]} {design_1_i/rtl_block_0/inst/Q[5]} {design_1_i/rtl_block_0/inst/Q[6]} {design_1_i/rtl_block_0/inst/Q[7]} {design_1_i/rtl_block_0/inst/Q[8]} {design_1_i/rtl_block_0/inst/Q[9]} {design_1_i/rtl_block_0/inst/Q[10]} {design_1_i/rtl_block_0/inst/Q[11]} {design_1_i/rtl_block_0/inst/Q[12]} {design_1_i/rtl_block_0/inst/Q[13]} {design_1_i/rtl_block_0/inst/Q[14]} {design_1_i/rtl_block_0/inst/Q[15]} {design_1_i/rtl_block_0/inst/Q[16]} {design_1_i/rtl_block_0/inst/Q[17]} {design_1_i/rtl_block_0/inst/Q[18]} {design_1_i/rtl_block_0/inst/Q[19]} {design_1_i/rtl_block_0/inst/Q[20]} {design_1_i/rtl_block_0/inst/Q[21]} {design_1_i/rtl_block_0/inst/Q[22]} {design_1_i/rtl_block_0/inst/Q[23]} {design_1_i/rtl_block_0/inst/Q[24]} {design_1_i/rtl_block_0/inst/Q[25]} {design_1_i/rtl_block_0/inst/Q[26]} {design_1_i/rtl_block_0/inst/Q[27]} {design_1_i/rtl_block_0/inst/Q[28]} {design_1_i/rtl_block_0/inst/Q[29]} {design_1_i/rtl_block_0/inst/Q[30]} {design_1_i/rtl_block_0/inst/Q[31]} ]]


