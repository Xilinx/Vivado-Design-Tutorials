#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Retrieve the cache repository directory from the argument
set CACHE_REPO_DIR [lindex $argv 0]  ;# Get the first argument from the command line

#Create the project in the output directory
create_project vivado_prj_from_tcl -force  -part xcvc1902-vsva2197-2MP-e-S

#Set the board part
set_property board_part xilinx.com:vck190:part0:3.2 [current_project]

config_ip_cache -use_cache_location ../$CACHE_REPO_DIR/   

#####Read all sources for building the project#####

#Generate the system BD that has only CIPS and DDR NOCs
source ../../sources/bd/bd.tcl

#Generate the XCI files for BRAMs, Performance Traffic Generators and VIO IPs
source ../../sources/ip/axi_bram_ctrl_pl_slave_from_pl_master.tcl
source ../../sources/ip/axi_bram_ctrl_pl_slave_from_ps.tcl
source ../../sources/ip/axis_vio_pl_master_to_ddr.tcl
source ../../sources/ip/axis_vio_pl_master_to_pl_slave.tcl
source ../../sources/ip/axis_vio_pl_master_to_ps.tcl
source ../../sources/ip/axis_MxN_vio.tcl
source ../../sources/ip/axi_tg_pl_to_pl.tcl
source ../../sources/ip/axi_tg_pl_to_ps.tcl
source ../../sources/ip/axi_tg_pl_master_to_ddr.tcl

#####Generate all targets : XCI/BD######
generate_target {all} [get_files { axis_MxN_vio.xci axi_bram_ctrl_pl_slave_from_pl_master.xci axi_bram_ctrl_pl_slave_from_ps.xci axis_vio_pl_master_to_ddr.xci axis_vio_pl_master_to_pl_slave.xci axis_vio_pl_master_to_ps.xci axi_tg_pl_master_to_ddr.xci axi_tg_pl_to_pl.xci axi_tg_pl_to_ps.xci design_1.bd}]

#create_OOC runs for IP and BD 
set ip_list {axis_MxN_vio.xci axi_bram_ctrl_pl_slave_from_pl_master.xci axi_bram_ctrl_pl_slave_from_ps.xci axis_vio_pl_master_to_ddr.xci axis_vio_pl_master_to_pl_slave.xci axis_vio_pl_master_to_ps.xci axi_tg_pl_master_to_ddr.xci axi_tg_pl_to_pl.xci axi_tg_pl_to_ps.xci design_1.bd}
foreach current_ip $ip_list {
    create_ip_run [get_files $current_ip]
}

#launch_runs *_synth_1
launch_runs *_synth_1 -jobs 4
wait_on_runs *_synth_1
exit
