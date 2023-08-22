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

set WORKING_DIR [pwd]

cd $WORKING_DIR

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project axi_gpio_in_rp_versal ./vivado_prj -part xcvc1902-vsva2197-2MP-e-S -force
   set_property BOARD_PART xilinx.com:vck190:part0:2.2 [current_project]
}


# Create the RM1 variant of RP1
source ./scripts/create_rp1rm1.tcl

# Create the RM2 variant of RP1
source ./scripts/create_rp1rm2.tcl

# Create the RM3 variant of RP1
source ./scripts/create_rp1rm3.tcl

# Create the top BD with RP1 (DFX enabled)
source ./scripts/create_top_bd.tcl

# Create an HDL Wrapper, set up the DFX Wizard, then run the implementation flow through programming image generation and XSA export
source ./scripts/run_impl.tcl
