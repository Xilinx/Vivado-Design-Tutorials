#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

# Open Synthesized Design with RM1
open_run synth_1 -name synth_1 -pr_config config_1;

create_debug_core design_1_i/rp1/rp1_u_ila_0 ila
set_property C_NUM_OF_PROBES 1 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property ALL_PROBE_SAME_MU true [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_MEMORY_TYPE 0 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property port_width 32 [get_debug_ports design_1_i/rp1/rp1_u_ila_0/probe0]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports design_1_i/rp1/rp1_u_ila_0/probe0]
connect_debug_port design_1_i/rp1/rp1_u_ila_0/probe0 [get_nets [list {design_1_i/rp1/c_counter_binary_0_Q[0]} {design_1_i/rp1/c_counter_binary_0_Q[1]} {design_1_i/rp1/c_counter_binary_0_Q[2]} {design_1_i/rp1/c_counter_binary_0_Q[3]} {design_1_i/rp1/c_counter_binary_0_Q[4]} {design_1_i/rp1/c_counter_binary_0_Q[5]} {design_1_i/rp1/c_counter_binary_0_Q[6]} {design_1_i/rp1/c_counter_binary_0_Q[7]} {design_1_i/rp1/c_counter_binary_0_Q[8]} {design_1_i/rp1/c_counter_binary_0_Q[9]} {design_1_i/rp1/c_counter_binary_0_Q[10]} {design_1_i/rp1/c_counter_binary_0_Q[11]} {design_1_i/rp1/c_counter_binary_0_Q[12]} {design_1_i/rp1/c_counter_binary_0_Q[13]} {design_1_i/rp1/c_counter_binary_0_Q[14]} {design_1_i/rp1/c_counter_binary_0_Q[15]} {design_1_i/rp1/c_counter_binary_0_Q[16]} {design_1_i/rp1/c_counter_binary_0_Q[17]} {design_1_i/rp1/c_counter_binary_0_Q[18]} {design_1_i/rp1/c_counter_binary_0_Q[19]} {design_1_i/rp1/c_counter_binary_0_Q[20]} {design_1_i/rp1/c_counter_binary_0_Q[21]} {design_1_i/rp1/c_counter_binary_0_Q[22]} {design_1_i/rp1/c_counter_binary_0_Q[23]} {design_1_i/rp1/c_counter_binary_0_Q[24]} {design_1_i/rp1/c_counter_binary_0_Q[25]} {design_1_i/rp1/c_counter_binary_0_Q[26]} {design_1_i/rp1/c_counter_binary_0_Q[27]} {design_1_i/rp1/c_counter_binary_0_Q[28]} {design_1_i/rp1/c_counter_binary_0_Q[29]} {design_1_i/rp1/c_counter_binary_0_Q[30]} {design_1_i/rp1/c_counter_binary_0_Q[31]} ]]
connect_debug_port design_1_i/rp1/rp1_u_ila_0/clk [get_nets [list design_1_i/rp1/s_axi_aclk ]]

save_constraints;

# Open Synthesized Design with RM2
open_run synth_1 -name synth_1 -pr_config config_2;

create_debug_core design_1_i/rp1/rp1_u_ila_0 ila
set_property C_NUM_OF_PROBES 1 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property ALL_PROBE_SAME_MU true [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_MEMORY_TYPE 0 [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores design_1_i/rp1/rp1_u_ila_0]
set_property port_width 4 [get_debug_ports design_1_i/rp1/rp1_u_ila_0/probe0]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports design_1_i/rp1/rp1_u_ila_0/probe0]
connect_debug_port design_1_i/rp1/rp1_u_ila_0/probe0 [get_nets [list {design_1_i/rp1/up_counter_rtl_0/inst/count_out[0]} {design_1_i/rp1/up_counter_rtl_0/inst/count_out[1]} {design_1_i/rp1/up_counter_rtl_0/inst/count_out[2]} {design_1_i/rp1/up_counter_rtl_0/inst/count_out[3]} ]]
connect_debug_port design_1_i/rp1/rp1_u_ila_0/clk [get_nets [list design_1_i/rp1/up_counter_rtl_0/inst/clk ]]

save_constraints;

