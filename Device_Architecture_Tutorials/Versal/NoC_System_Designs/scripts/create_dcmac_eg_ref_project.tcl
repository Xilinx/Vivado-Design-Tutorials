#--------------------------------------------------------------------------------------
#
# Copyright(C) 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# This document contains proprietary, confidential information that
# may be used, copied and/or disclosed only as authorized by a
# valid licensing agreement with Advanced Micro Devices, Inc. This copyright
# notice must be retained on all authorized copies.
#
# This code is provided "as is". Advanced Micro Devices, Inc. makes, and
# the end user receives, no warranties or conditions, express,
# implied, statutory or otherwise, and Advanced Micro Devices, Inc.
# specifically disclaims any implied warranties of merchantability,
# non-infringement, or fitness for a particular purpose.
#
#--------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
#
# Description : This script creates the example DCMAC project to obtain the
#               DCMAC example design reference files
#                 400G link, DCMAC X1Y1
#               Will create
#                 RTL files (generated project, 'imports' sub-directory)
#                 BD TCL scripts (generated project, root)
#               Project creation only, no build
#               
#               User Settings
#                 project_name
#                   defines target project name for Vivado project
#                 project_subdir
#                   defines target project directory for Vivado project
#
#               Uses Vivado 2023.2
#               Instructions:
#                 Browse to script folder
#                 Open vivado instance, run this file by entering
#                    source create_dcmac_eg_ref_project.tcl
#                 in TCL console, temp project will be created in folder path below
#                 specified by 'vivado_projects_dir' variable
#                 Alternately, command-line build can be done from shell with the command
#                    vivado -mode batch -source create_dcmac_eg_ref_project.tcl
#
#--------------------------------------------------------------------------------------


# user defined names
set project_name    dcmac_eg_refdesign_gen
set project_subdir  .

# set common location variables
set scriptdir  [file dirname [file normalize [info script]]]
set scriptname [file tail [info script]]

# Set the common project parameters
set board_part  xilinx.com:vpk180:part0:1.1

set eg_project_name  dcmac_0_ex

set bd_list            [dict create ]
dict set  bd_list   dcmac_0_cips           bd_cips.tcl
dict set  bd_list   dcmac_0_exdes_support  bd_dcmac_xcvrs.tcl

# set output directory
set vivado_projects_dir  [file normalize "$scriptdir/vivado_eg_ref/$project_subdir"]


################################################################################################
# Build start-up, define project, datestamp
################################################################################################

# create new project directory
if {![expr [file exists $scriptdir/vivado]]} {
    file mkdir $scriptdir/vivado
} elseif {[expr [file exists $vivado_projects_dir]]} {
    file delete -force $vivado_projects_dir
}

set ip_proj_dir_path  "$vivado_projects_dir/ip_gen"
set eg_proj_dir_path  "$vivado_projects_dir/eg_ref"
file mkdir $ip_proj_dir_path
file mkdir $eg_proj_dir_path


# create project
create_project $project_name $ip_proj_dir_path
#set_property "part" $part_name [current_project]
set_property "board_part" $board_part [current_project]


################################################################################################
# IP Creation, example project export
#   RTL reference files will be created in $eg_proj_dir_path/$eg_project_name/imports/
#   BD TCL export files will be written to $eg_proj_dir_path/$eg_project_name/
################################################################################################

create_bd_design "bd"

create_bd_cell -type ip -vlnv xilinx.com:ip:dcmac:2.3 dcmac_inst
set_property -dict [list                    \
    CONFIG.DCMAC_LOCATION_C0   {DCMAC_X1Y1} \
    CONFIG.MAC_PORT4_CONFIG_C0 {Disabled}   \
    CONFIG.MAC_PORT5_CONFIG_C0 {Disabled}   \
] [get_bd_cells dcmac_inst]
save_bd_design
open_example_project -force -dir $eg_proj_dir_path -in_process [get_ips]

foreach bd_name [dict keys $bd_list] {
    open_bd_design "$eg_proj_dir_path/${eg_project_name}/${eg_project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd"
    set bd_script_name [dict get $bd_list $bd_name]
    write_bd_tcl "$eg_proj_dir_path/${bd_script_name}"
}

