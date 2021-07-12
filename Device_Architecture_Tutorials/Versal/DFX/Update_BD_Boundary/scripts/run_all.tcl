#Source this script to compile the full Versal DFX tutorial design in Vivado 2020.2
#Source individual steps to work more interactively with the tools / flow

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project -force bdc_dfx_ports_match ../vivado_prj -part xcvc1902-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vck190:part0:2.2 [current_project]
}


#Create the flat deisgn using IPI
source create_top_bd.tcl


#Create the BDC for RP1 hierarchy
source create_rp1_bdc.tcl


#Enable DFX for the RP1 BDC
source enable_dfx_bdc.tcl


#Create the RM2 variant of RP1
source create_rp1rm2.tcl 

#Create the RM3 variant of RP1
source create_rp1rm3.tcl

#Update the boundary of RMs
source update_rm_boundary.tcl


#Update the top BD (static)
source update_top_bd.tcl

#Match the aperture of the interface to RP1 BDC at the TOP with the aperture property of respective ports inside the RM BDs
source match_aperture.tcl


#Create an HDL Wrapper, set up the DFX Wizard, then run the implementation flow through programming image generation and XSA export
source run_impl.tcl

