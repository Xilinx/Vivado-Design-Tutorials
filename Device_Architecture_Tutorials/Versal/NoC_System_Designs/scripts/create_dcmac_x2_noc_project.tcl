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
# Description : This script creates a trial project for build purposes, design is based off
#               DCMAC example design
#                 400G Port 0, DCMAC X1Y1
#               RX path of 400G is routed through NoC prior to connection to 2nd DCMAC
#               
#               Flags for usage
#                 dontbuild
#                   if set non-zero, project will be created and will generate any
#                      targets associated with the block diagram or other IP
#                   TCL script will exit just prior to synthesis launch
#                 createziparchive
#                   if set non-zero, zip archive is created in project build
#                      directory containing source and initial project
#                   if set zero, no archive is created
#                 snapshotsources
#                   if set non-zero, copy all sources into the build directory before starting the build
#
#               User Settings
#                 project_name
#                   defines target project name for Vivado project
#                 project_subdir
#                   defines target project directory for Vivado project
#                   nominal set to '.', can be replaced with arbitrary name to produce
#                     sub-directory name
#

#               Uses Vivado 2023.1
#               Instructions:
#                 Browse to script folder
#                 Open vivado instance, run this file by entering
#                    source create_proj_x2.tcl
#                 in TCL console, temp project will be created in folder path below
#                 specified by 'vivado_projects_dir' variable
#                 Alternately, command-line build can be done from shell with the command
#                    vivado -mode batch -source create_proj_x2.tcl
#
#--------------------------------------------------------------------------------------

# user defined names
set project_name    dcmac_x2_over_noc_ref
set project_subdir  .

# user defined flags (defined in header notes)
set dontbuild               1
set createziparchive        1
set snapshotsources         1

set scriptdir  [file dirname [file normalize [info script]]]
set scriptname [file tail [info script]]

# Set the common project parameters
set board_part              xilinx.com:vpk180:part0:1.1
set top_level_name          dcmac_0_exdes_imp_top
set top_sim_level_name      dcmac_0_exdes
set top_level_sim_tb_name   dcmac_0_exdes_tb
set bd_list            [dict create ]
dict set  bd_list   dcmac_0_cips           bd_cips.tcl
dict set  bd_list   bd_noc                 bd_s2a_noc_a2s.tcl
dict set  bd_list   dcmac_0_exdes_support  bd_dcmac_xcvrs.tcl

# Set directories
set rtl_dir              [file normalize "$scriptdir/../src"]
set sim_dir              [file normalize "$scriptdir/../sim"]
set constraints_dir      [file normalize "$scriptdir/../constraints"]
set bd_tcl_dir           [file normalize "$scriptdir/bd"]
set ip_gen_dir           [file normalize "$scriptdir/../src"]
set vivado_projects_dir  [file normalize "$scriptdir/vivado/$project_subdir"]


################################################################################################
# Build start-up, define project
################################################################################################

# create new project directory
if {![expr [file exists $scriptdir/vivado]]} {
    file mkdir $scriptdir/vivado
} elseif {[expr [file exists $vivado_projects_dir]]} {
    file delete -force $vivado_projects_dir
}
# make snapshot directory to contain current source, use snapshot to populate project
set src_snapshot_dirname "src"
set src_snapshot_dir_path "$vivado_projects_dir/$src_snapshot_dirname"
file mkdir $src_snapshot_dir_path
set sim_snapshot_dirname "sim"
set sim_snapshot_dir_path "$vivado_projects_dir/$sim_snapshot_dirname"
file mkdir $sim_snapshot_dir_path
set build_snapshot_dirname "build"
set build_snapshot_dir_path "$vivado_projects_dir/$build_snapshot_dirname"
file mkdir $build_snapshot_dir_path

# create project
create_project $project_name $build_snapshot_dir_path
set_property "board_part" $board_part [current_project]

# copy over scripts as reference
set src_snapshot_subdir "$src_snapshot_dir_path"
file copy "$scriptdir/$scriptname" $build_snapshot_dir_path


################################################################################################
# Define RTL source files
################################################################################################

set src_snapshot_subdirname "source"
set src_snapshot_subdir "$src_snapshot_dir_path/$src_snapshot_subdirname"
file mkdir $src_snapshot_subdir

# unmodified reference files
set rtl_file_set [list]
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_cnt.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_ctrl_gen.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_gen_buffer_ctx.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_gen_dat_merge.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_gen_mty_shift.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_gen_ts.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_mon_dat_merge.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_mon_shift_seg.sv"
lappend rtl_file_set "eg_ref/dcmac_0_axis_pkt_mon_ts.sv"
lappend rtl_file_set "eg_ref/dcmac_0_core_sniffer.sv"
lappend rtl_file_set "eg_ref/dcmac_0_emu_gearbox_rx.sv"
lappend rtl_file_set "eg_ref/dcmac_0_emu_gearbox_tx.sv"
lappend rtl_file_set "eg_ref/dcmac_0_emu_register.sv"
lappend rtl_file_set "eg_ref/dcmac_0_mac_rx_stats_cnt.sv"
lappend rtl_file_set "eg_ref/dcmac_0_mac_tx_stats_cnt.sv"
lappend rtl_file_set "eg_ref/dcmac_0_prbs_gen_ts.sv"
lappend rtl_file_set "eg_ref/dcmac_0_prbs_mon_ts.sv"
lappend rtl_file_set "eg_ref/dcmac_0_syncer_reset.sv"
lappend rtl_file_set "eg_ref/dcmac_0_ts_context_mem_v2.sv"
lappend rtl_file_set "eg_ref/dcmac_0_tsmac_stats_cnt_external.sv"
# copy files
set proj_rtl_file_set [list]
file mkdir $src_snapshot_subdir/eg_ref
foreach file ${rtl_file_set} {
    file copy "$rtl_dir/$file" $src_snapshot_subdir/[file dirname $file]
    lappend proj_rtl_file_set "$src_snapshot_subdir/$file"
}

# modified reference files
set rtl_file_set [list]
lappend rtl_file_set "dcmac_0_exdes__2dcmac_noc.sv"
lappend rtl_file_set "dcmac_0_exdes_imp_top__2dcmac_noc.sv"
# copy files
foreach file ${rtl_file_set} {
    file copy "$rtl_dir/$file" $src_snapshot_subdir/[file dirname $file]
    lappend proj_rtl_file_set "$src_snapshot_subdir/$file"
}

# NoC transport solution files
set rtl_file_set [list]
lappend rtl_file_set "noc/axis_2x_seg_to_1x_axis.sv"
lappend rtl_file_set "noc/axis_1x_axis_to_2x_seg.sv"
lappend rtl_file_set "noc/axis_8x128seg_to_4x256axis.v"
lappend rtl_file_set "noc/axis_4x256axis_to_8x128seg.v"
lappend rtl_file_set "noc/reg_pipeline_comparison_only/register_pipeline_8x128seg_comparison.sv"
# copy files
file mkdir $src_snapshot_subdir/noc
file mkdir $src_snapshot_subdir/noc/reg_pipeline_comparison_only
foreach file ${rtl_file_set} {
    file copy "$rtl_dir/$file" $src_snapshot_subdir/[file dirname $file]
    lappend proj_rtl_file_set "$src_snapshot_subdir/$file"
}

# add rtl to project
add_files -fileset sources_1  -norecurse $proj_rtl_file_set

# disable register pipeline file, only to be swapped in by user in place of NoC solution for PAR comparison
set rtl_disable_file_set [list]
lappend rtl_disable_file_set [lsearch -inline $proj_rtl_file_set "*/register_pipeline_8x128seg_comparison.sv"]
set_property is_enabled false [get_files $rtl_disable_file_set]


################################################################################################
# Define/add repos
################################################################################################

set repo_dir_set    [ list  ]
lappend repo_dir_set "noc/axiseg_if"

foreach repo_dir ${repo_dir_set} {
    # create the snapshot sub-directory, copy everything, add to project
    file mkdir $src_snapshot_subdir/$repo_dir
    eval file copy [glob -directory $rtl_dir/$repo_dir *] $src_snapshot_subdir/$repo_dir
}
set_property  ip_repo_paths  "$src_snapshot_dir_path/source" [current_project]
update_ip_catalog


################################################################################################
# Define constraints files
################################################################################################

set src_snapshot_subdir "$src_snapshot_dir_path/constraints"
file mkdir $src_snapshot_subdir

# Add the constraints file
set constraints_file_set   [ list ]
lappend constraints_file_set "dcmac_0_example_top__2dcmac_noc.xdc"
lappend constraints_file_set "define_pblocks.tcl"
# copy files
set proj_constraints_file_set [list]
foreach file ${constraints_file_set} {
    file copy "$constraints_dir/$file" $src_snapshot_subdir/[file dirname $file]
    lappend proj_constraints_file_set "$src_snapshot_subdir/$file"
}

# add constraints to project
add_files -fileset constrs_1  -norecurse $proj_constraints_file_set

# good results using SLR strategy without floorplanning, disable floorplanning TCL but leave available for use
set_property used_in_synthesis false [get_files [lsearch -inline $proj_constraints_file_set "*define_pblocks.tcl"]]
set_property is_enabled false [get_files [lsearch -inline $proj_constraints_file_set "*define_pblocks.tcl"]]


################################################################################################
# Define/add IP cores
################################################################################################

set src_snapshot_subdirname "ip_generated"
set src_snapshot_subdir "$src_snapshot_dir_path/$src_snapshot_subdirname"
file mkdir $src_snapshot_subdir

# define list of existing Xilinx IP to use in this project
set ip_file_set    [ list ]
lappend ip_file_set "eg_ref/ip/dcmac_0_clk_wiz_0/dcmac_0_clk_wiz_0.xci"
lappend ip_file_set "noc/axis_register_slice_noc_ch/axis_register_slice_noc_ch.xci"

set proj_ip_file_set [list ]
file mkdir $src_snapshot_subdir/eg_ref/ip/dcmac_0_clk_wiz_0
file mkdir $src_snapshot_subdir/noc/axis_register_slice_noc_ch
foreach file ${ip_file_set} {
    file copy "$ip_gen_dir/$file" $src_snapshot_subdir/[file dirname $file]
    lappend proj_ip_file_set "$src_snapshot_subdir/$file"
}

# add IP to project
add_files -fileset sources_1  -norecurse $proj_ip_file_set


################################################################################################
# Create IPI BD (and wrapper)
################################################################################################

set src_snapshot_subdirname "scripts"
set src_snapshot_subdir "$src_snapshot_dir_path/$src_snapshot_subdirname"
file mkdir $src_snapshot_subdir

foreach bd_name [dict keys $bd_list] {
    set bd_script_name [dict get $bd_list $bd_name]
    file copy "$bd_tcl_dir/$bd_script_name" $src_snapshot_subdir
    set proj_bd_script "$src_snapshot_subdir/$bd_script_name"
    source $proj_bd_script
    make_wrapper -files [get_files $build_snapshot_dir_path/$project_name.srcs/sources_1/bd/$bd_name/$bd_name.bd] -top -import
}

# we need to make 2 DCMACs - same block diag connections & IPs, only different locations
# export the existing DCMAC BD with different name, source the exported TCL to create 2nd instance with different name
# modify the DCMAC location
# rename the main cells to avoid possible generated XDC clashes
set bd_to_copy  dcmac_0_exdes_support
set bd_copy_suffix  "_1"

set bd_dcmac_copy_name       "${bd_to_copy}${bd_copy_suffix}"
set bd_dcmac_copy_script_name       "[file rootname [dict get $bd_list $bd_to_copy]]${bd_copy_suffix}.tcl"
current_bd_design $bd_to_copy
write_bd_tcl  -bd_name $bd_dcmac_copy_name  "$build_snapshot_dir_path/$bd_dcmac_copy_script_name"
source $build_snapshot_dir_path/$bd_dcmac_copy_script_name
set_property CONFIG.DCMAC_LOCATION_C0 {DCMAC_X0Y6} [get_bd_cells dcmac_0_core]
set_property name "dcmac_0_core${bd_copy_suffix}" [get_bd_cells dcmac_0_core]
set_property name "dcmac_0_gt_wrapper${bd_copy_suffix}" [get_bd_cells dcmac_0_gt_wrapper]
save_bd_design
make_wrapper -files [get_files $build_snapshot_dir_path/$project_name.srcs/sources_1/bd/$bd_dcmac_copy_name/$bd_dcmac_copy_name.bd] -top -import


################################################################################################
# Define sim files
################################################################################################

# # define base files, re-use from previous trial
set sim_file_set [list]
lappend sim_file_set "dcmac_0_exdes_tb__2dcmac_noc.sv"
lappend sim_file_set "reg_pipeline_comparison_only/register_pipeline_8x128seg_comparison_sim_wrapper.sv"
# copy files
set proj_sim_file_set [list ]
file mkdir $sim_snapshot_dir_path/reg_pipeline_comparison_only
foreach file ${sim_file_set} {
    file copy "$sim_dir/$file" $sim_snapshot_dir_path/[file dirname $file]
    lappend proj_sim_file_set "$sim_snapshot_dir_path/$file"
}

# add sim to project
add_files -fileset sim_1  -norecurse $proj_sim_file_set

# define parameter for faster simulation
set_property verilog_define "SIM_SPEED_UP=1" [get_filesets sim_1]

# disable register pipeline wrapper file, only to be swapped in by user in place of NoC solution to validate sim for pipeline
set sim_disable_file_set [list]
lappend sim_disable_file_set [lsearch -inline $proj_sim_file_set "*/register_pipeline_8x128seg_comparison_sim_wrapper.sv"]
set_property is_enabled false [get_files $sim_disable_file_set]


################################################################################################
# Generate NoC sim model
#   This needs special handling given the project has multiple block diagrams with NoC
#   capabilities, the models won't be generated with the set project as the tool likely
#   perceives a conflict in NoC model generation.
#   The CIPS block diagram needs to be removed from the project and the hierarchical level
#   of project being simulated needs to be set as top-level of the implementation project - 
#   note that this also involves disabling the nominal implementation top-level.
#   Only then will the NoC simulation model of interest be generated, as a sim wrapper to
#   the hierarchical level of simulation interest. The TB calls the wrapper which in turn
#   invokes the hierarchical level of simulation interest and the model.
#   After generation, the original hierarchy of the implementation project can reinstated.
################################################################################################

# set top level temporarily to sim hierarchy level of interest
set_property top $top_sim_level_name     [get_filesets sources_1]

# disable targeted files
set temp_disable_file_set [list]
lappend temp_disable_file_set [lsearch -inline $proj_rtl_file_set "*/dcmac_0_exdes_imp_top__2dcmac_noc.sv"]
lappend temp_disable_file_set "$build_snapshot_dir_path/$project_name.srcs/sources_1/bd/dcmac_0_cips/dcmac_0_cips.bd"
set_property is_enabled false [get_files $temp_disable_file_set]

# generate NoC model
generate_switch_network_for_noc

# re-enable targeted files
set_property is_enabled true [get_files $temp_disable_file_set]

# remove same files (+1) from simulation
lappend temp_disable_file_set "$build_snapshot_dir_path/$project_name.srcs/sources_1/imports/hdl/dcmac_0_cips_wrapper.v"
set_property used_in_simulation false [get_files $temp_disable_file_set]

current_bd_design bd_noc
validate_bd_design -force
save_bd_design


################################################################################################
# Misc copying, properties definition
################################################################################################

# Define top level
set_property top $top_level_name     [get_filesets sources_1]
set_property top $top_level_sim_tb_name [get_filesets sim_1]

set_property "default_lib" "xil_defaultlib" [current_project]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property -name {xsim.simulate.runtime} -value {400us} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

set_param noc.enableCompilerHiEffort true

puts "INFO: Vivado project generation complete"


################################################################################################
# Functions
################################################################################################

proc dcmac_proj__enable_pipeline {} {
    set proj_fileset [get_files]
    # disable NoC files
    set swap_disable_file_set [list]
    lappend swap_disable_file_set [lsearch -inline $proj_fileset "*.srcs/sources_1/bd/bd_noc/bd_noc.bd"]
    lappend swap_disable_file_set [lsearch -inline $proj_fileset "*.srcs/sources_1/imports/hdl/bd_noc_wrapper.v"]
    lappend swap_disable_file_set [lsearch -inline $proj_fileset "*.srcs/sim_1/bd/xlnoc/xlnoc.bd"]
    lappend swap_disable_file_set [lsearch -inline $proj_fileset "*.srcs/sources_1/common/hdl/dcmac_0_exdes_sim_wrapper.v"]
    set_property is_enabled false [get_files $swap_disable_file_set]
    # enable register pipeline files
    set swap_enable_file_set [list]
    lappend swap_enable_file_set [lsearch -inline $proj_fileset "*/register_pipeline_8x128seg_comparison.sv"]
    lappend swap_enable_file_set [lsearch -inline $proj_fileset "*/register_pipeline_8x128seg_comparison_sim_wrapper.sv"]
    set_property is_enabled true [get_files $swap_enable_file_set]
}

proc dcmac_proj__enable_noc {} {
    set proj_fileset [get_files]
    # disable register pipeline files
    set swap_disable_file_set [list]
    lappend swap_disable_file_set [lsearch -inline $proj_fileset "*/register_pipeline_8x128seg_comparison.sv"]
    lappend swap_disable_file_set [lsearch -inline $proj_fileset "*/register_pipeline_8x128seg_comparison_sim_wrapper.sv"]
    set_property is_enabled false [get_files $swap_disable_file_set]
    # enable NoC files
    set swap_enable_file_set [list]
    lappend swap_enable_file_set [lsearch -inline $proj_fileset "*.srcs/sources_1/bd/bd_noc/bd_noc.bd"]
    lappend swap_enable_file_set [lsearch -inline $proj_fileset "*.srcs/sources_1/imports/hdl/bd_noc_wrapper.v"]
    lappend swap_enable_file_set [lsearch -inline $proj_fileset "*.srcs/sim_1/bd/xlnoc/xlnoc.bd"]
    lappend swap_enable_file_set [lsearch -inline $proj_fileset "*.srcs/sources_1/common/hdl/dcmac_0_exdes_sim_wrapper.v"]
    set_property is_enabled true [get_files $swap_enable_file_set]
}


################################################################################################
# Synthesize & PAR
################################################################################################

set_property strategy Performance_HighUtilSLRs [get_runs impl_1]


################################################################################################
# Archive
################################################################################################

if {$createziparchive!=0} {
    cd $vivado_projects_dir
    exec zip -r ${project_subdir}_proj.zip $src_snapshot_dirname
    exec zip -r ${project_subdir}_proj.zip $sim_snapshot_dirname
    exec zip -r ${project_subdir}_proj.zip $build_snapshot_dirname
}
cd $scriptdir


################################################################################################
# Build
################################################################################################

if ($dontbuild) {
    return;
}

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

