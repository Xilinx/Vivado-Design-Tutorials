
#Create a wrapper for Top BD
make_wrapper -files [get_files ../vivado_prj/vnoc_sharing.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ../vivado_prj/vnoc_sharing.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1

##Add the pblock constraints
add_files -fileset constrs_1 -norecurse ../constraints/pblocks.xdc
import_files -fileset constrs_1 [get_files pblocks.xdc]
add_files -fileset constrs_1 -norecurse ../constraints/timing.xdc
import_files -fileset constrs_1 [get_files timing.xdc]

##Generate the targets
generate_target all [get_files ../vivado_prj/vnoc_sharing.srcs/sources_1/bd/design_1/design_1.bd]

##DFX Wizard to configure parent/child implementation
create_pr_configuration -name config_1 -partitions [list design_1_i/rp1:rp1rm1_inst_0 design_1_i/rp2:rp2rm1_inst_0 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]

##Launch OOC synthesis of RMs, Parent Synthesis, Parent Implementation and Child Implementation
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
                      

