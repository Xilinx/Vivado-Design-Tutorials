#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

# Create Project - VCK190 Eval Board
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 ../vivado_prj -part xcvc1902-vsva2197-2MP-e-S -force
   set_property BOARD_PART xilinx.com:vck190:part0:2.2 [current_project]
}

add_files -norecurse -scan_for_includes {../sources/up_counter_rtl.v}
import_files {../sources/up_counter_rtl.v}
update_compile_order -fileset sources_1

source rp1rm1.tcl
source rp1rm2.tcl
source rp1rm3.tcl
source rp1rm4.tcl
source top_bd.tcl
