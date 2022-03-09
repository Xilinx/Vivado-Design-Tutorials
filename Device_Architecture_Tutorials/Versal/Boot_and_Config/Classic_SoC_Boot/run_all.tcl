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

#Source this script to compile the full Versal Classic SoC Boot tutorial design in Vivado 2021.1
#Source individual steps to work more interactively with the tools / flow

#How many RMs?  Set "one" or "two"
set num_RMs "two"


#Create the flat deisgn using IPI
source create_top_bd.tcl


#Create the BDC for PL hierarchy and convert to DFX
source create_pl_bdc_dfx.tcl


#Create the second RM variant of PL, if needed
if {$num_RMs == "two"} {
   source create_second_rm.tcl 
} else {
} 

#Create an HDL Wrapper, set up the DFX Wizard, then run the implementation flow through programming image generation and XSA export
if {$num_RMs == "two"} {
   source run_impl_twoRM.tcl
} else {
   source run_impl_oneRM.tcl
}  


