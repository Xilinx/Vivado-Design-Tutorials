#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

#Create the project in the output directory
create_project manage_ip_xcix_prj -force  -part xcvc1902-vsva2197-2MP-e-S -ip

#Enabling Core Container Technology
set_property coreContainer.enable 1 [current_project]


#Set the board part
set_property board_part xilinx.com:vck190:part0:3.2 [current_project]

#####Read all sources for building the project#####

#Generate the system BD that has only CIPS and DDR NOCs
#source ../../sources/bd/bd.tcl
#BD is not recommended to be created in Manage IP flow

#Read the RTL files that has XPM NMUs and NSUs instantiated along with traffic generators and BRAM 
#add_files ../../sources/rtl

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
generate_target all [get_files { axis_MxN_vio.xci axi_bram_ctrl_pl_slave_from_pl_master.xci axi_bram_ctrl_pl_slave_from_ps.xci axis_vio_pl_master_to_ddr.xci axis_vio_pl_master_to_pl_slave.xci axis_vio_pl_master_to_ps.xci axi_tg_pl_master_to_ddr.xci axi_tg_pl_to_pl.xci axi_tg_pl_to_ps.xci }]

#Create the OOC run for all IPs in the project 
create_ip_run [get_files axis_MxN_vio.xci]
create_ip_run [get_files axi_bram_ctrl_pl_slave_from_pl_master.xci] 
create_ip_run [get_files axi_bram_ctrl_pl_slave_from_ps.xci] 
create_ip_run [get_files axis_vio_pl_master_to_ddr.xci] 
create_ip_run [get_files axis_vio_pl_master_to_pl_slave.xci] 
create_ip_run [get_files axis_vio_pl_master_to_ps.xci] 
create_ip_run [get_files axi_tg_pl_master_to_ddr.xci] 
create_ip_run [get_files axi_tg_pl_to_pl.xci]
create_ip_run [get_files axi_tg_pl_to_ps.xci] 


launch_runs *_synth_1 -jobs 16
wait_on_runs [get_runs *_synth_1]

exit
