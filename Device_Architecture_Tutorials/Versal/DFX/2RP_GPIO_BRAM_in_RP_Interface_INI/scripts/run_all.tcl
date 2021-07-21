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

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project 2RP_gpio_bram ../vivado_prj -part xcvc1902-vsva2197-2MP-e-S -force
   set_property BOARD_PART xilinx.com:vck190:part0:2.2 [current_project]
}


#Create the flat deisgn using IPI
source create_top_bd.tcl

#Create the BDC for RP1 and RP2 hierarchy
source create_rp1_rp2_bdc.tcl


#Enable DFX for the RP1 BDC and RP2 BDC
source enable_dfx_bdc.tcl


#Create the RM2 variant of RP1 
source create_rp1rm2.tcl 

#Create the RM2 variant of RP2
source create_rp2rm2.tcl 

#Match the aperture of the interface to RP1 BDC at the TOP with the aperture property of respective ports inside the RM BDs
source match_aperture.tcl

#Back-end Synthesis, Implementation & Hardware Export to XSA
source run_impl.tcl
