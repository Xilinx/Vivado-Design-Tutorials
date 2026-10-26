# #########################################################################
#Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.

#SPDX-License-Identifier: MIT
# ###########################################################################



create_project debugLab debugLab -part xcvc1902-vsva2197-2MP-e-S
set_property BOARD_PART xilinx.com:vck190:part0:3.0 [current_project]

add_files hdl/debuglab_top.v
add_files hdl/rtl_block.v
add_files hdl/rtl_counter.v

source bd/base_design.tcl

set_property top debuglab_top [current_fileset]

