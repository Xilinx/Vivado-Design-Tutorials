create_project slr0_rm2_compile ../../output/slr0_rm2_compile -part xcvu13p-fhga2104-3-e -force

#Add abstract shell DCP for the partition
add_files ../../output/initial_compile/abs_shells/slr0_abs.dcp
#Import the corresponding partition's BD to the project
import_files ../../output/initial_compile/project_1.srcs/sources_1/bd/rp_slr0/rp_slr0.bd
#Convert the project to DFX project
set_property PR_FLOW 1 [current_project]
#Linking a OOC synthesized BD with a DCP is possible only with Design Mode set to GateLvl
set_property DESIGN_MODE GateLvl [current_fileset ]
#Set the top for the design
set_property top design_1_wrapper [current_fileset]
#Create partition definition and reconfigurable module for the BD. Associate reconfigurable module with the partition
create_partition_def -name rp_slr0 -module rp_slr0
create_reconfig_module -name rp_slr0_rm2 -partition_def [get_partition_defs rp_slr0 ] -define_from rp_slr0

#Create  a new configuration using DFX wizard
create_pr_configuration -name config_1 -partitions [list design_1_i/rp_slr0:rp_slr0_rm2]

#We do not need blackbox DCP to be generated at the end , because this is abstract shell based implementation. User can pick up same abstract shell for any other RM imlementation
set_property USE_BLACKBOX 0 [get_pr_configuration config_1]

#Associate the configuration with the implementation impl_1
set_property PR_CONFIGURATION config_1 [get_runs impl_1]

#Modify the BD with your IPs
open_bd_design {./slr0_rm2_compile/slr0_rm2_compile.srcs/sources_1/bd/rp_slr0/rp_slr0.bd}
source modify_slr0_bd_rm2.tcl

#Add constraints specific for implementing this partition. Please note you do not need to add pblock constraints again because it is already present in abstract shell
#Add constraints for slr0_rm2 xdc
add_files -fileset constrs_1 -norecurse ../../constraints/slr0_compile/slr0_rm2_misc.xdc
import_files -fileset constrs_1 [get_files slr0_rm2_misc.xdc]

#Launch OOC synthesis of BD. By default, we use OOC per IP mode for synthesis. This is recommended to get maximum parallelization. 
launch_runs rp_slr0_rm2_synth_1 -jobs 8 
wait_on_run rp_slr0_rm2_synth_1

#Add the generated OOC synthesized BD's DCP output to the project
add_files ../../output/slr0_rm2_compile/slr0_rm2_compile.runs/rp_slr0_rm2_synth_1/rp_slr0.dcp

#Scope the RM DCP to the corresponding cell in the reconfigurable partition
set_property SCOPED_TO_CELLS {design_1_i/rp_slr0} [get_files ../../output/slr0_rm2_compile/slr0_rm2_compile.runs/rp_slr0_rm2_synth_1/rp_slr0.dcp]

#Launch Implementation of partition using it abstract shell 
launch_runs impl_1 -jobs 8
wait_on_run impl_1
open_run impl_1

