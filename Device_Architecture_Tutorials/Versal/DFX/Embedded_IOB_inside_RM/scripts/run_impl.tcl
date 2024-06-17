#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


#Create a wrapper for Top BD
#In tutorial, we already created the wrapper verilog file, edited it and provided in src directory
#make_wrapper -files [get_files ./embedded_IOB_inside_RM/embedded_IOB_inside_RM.srcs/sources_1/bd/design_1/design_1.bd] -top
#add_files -norecurse embedded_IOB_inside_RM/embedded_IOB_inside_RM.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v

add_files -norecurse ../sources/design_1_wrapper.v
update_compile_order -fileset sources_1

##Add the pblock constraints
add_files -fileset constrs_1 -norecurse ../constraints/pblocks.xdc
import_files -fileset constrs_1 [get_files pblocks.xdc]
add_files -fileset constrs_1 -norecurse ../constraints/io.xdc
import_files -fileset constrs_1 [get_files io.xdc]


#Add a new constraints set that are specific to child implementation

create_fileset -constrset constrs_2
add_files -fileset constrs_2 -norecurse ../constraints/io_child_0_impl_1.xdc
import_files -fileset constrs_2 [get_files io_child_0_impl_1.xdc]

##Generate the targets
generate_target all [get_files ../vivado_prj/embedded_IOB_inside_RM.srcs/sources_1/bd/design_1/design_1.bd]

##DFX Wizard to configure parent/child implementation
create_pr_configuration -name config_1 -partitions [list design_1_i/rp1:rp1rm1_inst_0 ]
create_pr_configuration -name config_2 -partitions [list design_1_i/rp1:rp1rm2_inst_0 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
create_run child_0_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2020} -pr_config config_2
set_property CONSTRSET constrs_2 [get_runs child_0_impl_1]
set_property APPLY_CONSTRSET 1 [get_runs child_0_impl_1]

##Launch OOC synthesis of RMs, Parent Synthesis, Parent Implementation and Child Implementation
launch_runs impl_1 child_0_impl_1 -to_step write_device_image -jobs 28
wait_on_run child_0_impl_1
                      

