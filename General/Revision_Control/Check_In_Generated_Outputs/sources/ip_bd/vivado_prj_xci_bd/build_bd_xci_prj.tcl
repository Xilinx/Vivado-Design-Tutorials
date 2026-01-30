#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

create_project vivado_prj_xci_bd -force  -part xcvc1902-vsva2197-2MP-e-S

set_property board_part xilinx.com:vck190:part0:3.2 [current_project]

source ./ip_bd_tcl/my_bd.tcl
source ./ip_bd_tcl/my_ip.tcl

generate_target all [get_files { axis_MxN_vio.xci axi_bram_ctrl_pl_slave_from_pl_master.xci axi_bram_ctrl_pl_slave_from_ps.xci axi_tg_pl_master_to_ddr.xci axis_vio_pl_master_to_ddr.xci axis_vio_pl_master_to_pl_slave.xci axis_vio_pl_master_to_ps.xci axi_tg_pl_to_pl.xci axi_tg_pl_to_ps.xci design_1.bd}]

create_ip_run [get_files axis_MxN_vio.xci]
create_ip_run [get_files axi_bram_ctrl_pl_slave_from_pl_master.xci] 
create_ip_run [get_files axi_bram_ctrl_pl_slave_from_ps.xci] 
create_ip_run [get_files axi_tg_pl_master_to_ddr.xci] 
create_ip_run [get_files axis_vio_pl_master_to_ddr.xci] 
create_ip_run [get_files axis_vio_pl_master_to_pl_slave.xci] 
create_ip_run [get_files axis_vio_pl_master_to_ps.xci] 
create_ip_run [get_files axi_tg_pl_to_pl.xci]
create_ip_run [get_files axi_tg_pl_to_ps.xci] 
create_ip_run [get_files design_1.bd]

launch_runs *_synth_1 -jobs 16
wait_on_runs [get_runs *_synth_1]
exit
