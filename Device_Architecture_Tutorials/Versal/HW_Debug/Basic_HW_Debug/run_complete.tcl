# #########################################################################
#Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.

#SPDX-License-Identifier: MIT
# ###########################################################################


create_project debugLab debugLab -part xcvc1902-vsva2197-2MP-e-S
set_property BOARD_PART xilinx.com:vck190:part0:3.0 [current_project]

add_files hdl/debuglab_top.v
add_files hdl/rtl_block_complete.v
add_files hdl/rtl_counter.v
add_files -fileset constrs_1 hdl/debuglab_top_debug.xdc

source bd/base_design_complete.tcl

set_property top debuglab_top [current_fileset]

## Generate RTL VIO
create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_vio_0
set_property -dict [list CONFIG.C_PROBE_OUT2_INIT_VAL {0x1} CONFIG.C_PROBE_OUT0_INIT_VAL {0x1} CONFIG.C_PROBE_OUT4_WIDTH {32} CONFIG.C_PROBE_IN0_WIDTH {32} CONFIG.C_NUM_PROBE_OUT {5}] [get_ips axis_vio_0]
generate_target {instantiation_template} [get_files ./debugLab/debugLab.srcs/sources_1/ip/axis_vio_0/axis_vio_0.xci]
update_compile_order -fileset sources_1
update_module_reference design_1_rtl_block_0_0

