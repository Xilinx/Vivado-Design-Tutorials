#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#Create a wrapper for Top BD
make_wrapper -files [get_files design_1.bd] -top
add_files -norecurse ../vivado_prj/project_1.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v 
update_compile_order -fileset sources_1

###Add the pblock constraints
add_files -fileset constrs_1 -norecurse ../constraints/pblocks.xdc
add_files -fileset constrs_1 -norecurse ../constraints/bram_init.xdc
import_files -fileset constrs_1 [get_files pblocks.xdc]
import_files -fileset constrs_1 [get_files bram_init.xdc]

#Enable DFX
#set_property PR_FLOW 1 [current_project]

#Generate the targets
generate_target all [get_files design_1.bd]


###DFX Wizard to configure parent/child implementation
create_pr_configuration -name config_1 -partitions [list design_1_i/RP1:rp1rm1_inst_0 design_1_i/RP2:rp2rm1_inst_0 design_1_i/RP3:rp3rm1_inst_0 design_1_i/RP4:rp4rm1_inst_0 ]
create_pr_configuration -name config_2 -partitions [list design_1_i/RP1:rp1rm2_inst_0 design_1_i/RP2:rp2rm2_inst_0 ] -greyboxes [list design_1_i/RP3 design_1_i/RP4 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
create_run child_0_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config config_2

##Constraint set is not automatically enabled for child implementation. Setting it manually
set_property APPLY_CONSTRSET 1 [get_runs child_0_impl_1]

###Launch OOC synthesis of RMs, Parent Synthesis, Parent Implementation and Child Implementation
launch_runs impl_1 child_0_impl_1 -to_step write_bitstream -jobs 28
wait_on_run child_0_impl_1
#
##Static XSA is written out only for internal verification to make sure they are identical.(static_impl_1.xsa and static_child_0_impl_1.xsa)
##Export the XSA from parent implementation
open_run impl_1
write_hw_platform -fixed -force ../xsa/design_1_wrapper_impl_1.xsa
close_design

##Export the XSA from child implementation
open_run child_0_impl_1
write_hw_platform -fixed -force ../xsa/child_xsa/design_1_wrapper_child_0_impl_1.xsa
close_design
