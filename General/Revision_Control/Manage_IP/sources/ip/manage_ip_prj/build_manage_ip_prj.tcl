#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

create_project manage_ip_prj -force  -part xcvc1902-vsva2197-2MP-e-S -ip

set_property board_part xilinx.com:vck190:part0:3.2 [current_project]

source ./ip_tcl/my_ip.tcl

generate_target all [get_files { axis_MxN_vio.xci axi_bram_ctrl_pl_slave_from_pl_master.xci axi_bram_ctrl_pl_slave_from_ps.xci axi_tg_pl_master_to_ddr.xci axis_vio_pl_master_to_ddr.xci axis_vio_pl_master_to_pl_slave.xci axis_vio_pl_master_to_ps.xci axi_tg_pl_to_pl.xci axi_tg_pl_to_ps.xci }]

create_ip_run [get_files axis_MxN_vio.xci]
create_ip_run [get_files axi_bram_ctrl_pl_slave_from_pl_master.xci] 
create_ip_run [get_files axi_bram_ctrl_pl_slave_from_ps.xci] 
create_ip_run [get_files axi_tg_pl_master_to_ddr.xci] 
create_ip_run [get_files axis_vio_pl_master_to_ddr.xci] 
create_ip_run [get_files axis_vio_pl_master_to_pl_slave.xci] 
create_ip_run [get_files axis_vio_pl_master_to_ps.xci] 
create_ip_run [get_files axi_tg_pl_to_pl.xci]
create_ip_run [get_files axi_tg_pl_to_ps.xci] 

launch_runs *_synth_1 -jobs 16
wait_on_runs [get_runs *_synth_1]
exit
