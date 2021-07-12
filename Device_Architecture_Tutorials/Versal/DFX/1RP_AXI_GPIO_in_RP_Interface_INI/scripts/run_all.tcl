# #########################################################################
#© Copyright 2021 Xilinx, Inc.

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
# ###########################################################################


#Source this script to compile the full Versal DFX tutorial design in Vivado 2020.2
#Source individual steps to work more interactively with the tools / flow


set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project axi_gpio_in_rp_versal ../vivado_prj -part xcvc1902-vsva2197-2MP-e-S -force
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


#Match the aperture of the interface to RP1 BDC at the TOP with the aperture property of respective ports inside the RM BDs
source match_aperture.tcl


#Create an HDL Wrapper, set up the DFX Wizard, then run the implementation flow through programming image generation and XSA export
source run_impl.tcl

