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

set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
add_files ../../output/initial_compile/project_1.runs/impl_1/design_1_wrapper_routed_bb.dcp 
add_files ../../output/slr0_rm2_compile/slr0_rm2_compile.runs/impl_1/design_1_i_rp_slr0_rp_slr0_rm2_routed.dcp
add_files ../../output/slr1_rm2_compile/slr1_rm2_compile.runs/impl_1/design_1_i_rp_slr1_rp_slr1_rm2_routed.dcp
add_files ../../output/slr2_rm2_compile/slr2_rm2_compile.runs/impl_1/design_1_i_rp_slr2_rp_slr2_rm2_routed.dcp
add_files ../../output/slr3_rm2_compile/slr3_rm2_compile.runs/impl_1/design_1_i_rp_slr3_rp_slr3_rm2_routed.dcp

set_property SCOPED_TO_CELLS {design_1_i/rp_slr0} [get_files ../../output/slr0_rm2_compile/slr0_rm2_compile.runs/impl_1/design_1_i_rp_slr0_rp_slr0_rm2_routed.dcp]
set_property SCOPED_TO_CELLS {design_1_i/rp_slr1} [get_files ../../output/slr1_rm2_compile/slr1_rm2_compile.runs/impl_1/design_1_i_rp_slr1_rp_slr1_rm2_routed.dcp]
set_property SCOPED_TO_CELLS {design_1_i/rp_slr2} [get_files ../../output/slr2_rm2_compile/slr2_rm2_compile.runs/impl_1/design_1_i_rp_slr2_rp_slr2_rm2_routed.dcp]
set_property SCOPED_TO_CELLS {design_1_i/rp_slr3} [get_files ../../output/slr3_rm2_compile/slr3_rm2_compile.runs/impl_1/design_1_i_rp_slr3_rp_slr3_rm2_routed.dcp]

link_design -reconfig_partitions {design_1_i/rp_slr0 design_1_i/rp_slr1 design_1_i/rp_slr2 design_1_i/rp_slr3} 
exec mkdir -p ../../output/final_bitstream
write_bitstream -no_partial -force ../../output/final_bitstream/full.bit