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

cd ./scripts/initial_compile
vivado -mode batch -source run_all.tcl
cd ../slr0_rm2_compile
vivado -mode batch -source slr0_rm2_compile.tcl
cd ../slr1_rm2_compile
vivado -mode batch -source slr1_rm2_compile.tcl
cd ../slr2_rm2_compile
vivado -mode batch -source slr2_rm2_compile.tcl
cd ../slr3_rm2_compile
vivado -mode batch -source slr3_rm2_compile.tcl
cd ../link_final_dcp
vivado -mode batch -source link_dcps.tcl
