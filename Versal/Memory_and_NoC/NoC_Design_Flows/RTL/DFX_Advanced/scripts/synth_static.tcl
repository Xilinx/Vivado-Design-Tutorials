#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#Create the project in the output directory
set_part xcvc1902-vsva2197-2MP-e-S

#Set the board part
set_property board_part xilinx.com:vck190:part0:3.2 [current_project]

#####Read all sources for building the project#####

#Generate the system BD that has only CIPS and DDR NOCs
source ../sources/bd/bd.tcl

#Read the RTL files that has XPM NMUs and NSUs instantiated along with traffic generators and BRAM 
read_verilog {{../sources/rtl/static/design_1_wrapper.v} {../sources/rtl/static/RP1_blackbox.v}}

#Read the XDC files for creating NoC connection, setting its QoS settings and the aperture of XPM NSUs. 
read_xdc ../sources/xdc/static/noc_constraints.xdc


#####Set the USED_IN {synthesis_pre} for NoC constraints#####
set_property USED_IN {synthesis_pre} [get_files ../sources/xdc/static/noc_constraints.xdc]

#####Generate all targets : XCI/BD######
generate_target {synthesis implementation} [get_files design_1.bd]

##Updating the sourcefile set 
set_property source_mgmt_mode All [current_project]
update_compile_order

#start_gui
#Validate_noc happens in synth_design call. User can also call it explicitly 
synth_design -top design_1_wrapper -part xcvc1902-vsva2197-2MP-e-S
write_checkpoint -force outputs/dcps/static_synth.dcp

exit
