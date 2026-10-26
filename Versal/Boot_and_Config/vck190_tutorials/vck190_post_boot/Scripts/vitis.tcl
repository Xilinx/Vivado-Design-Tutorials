# Copyright 2020 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create Workspace
setws ../Software/Vitis/workspace

# Create HW platform with PMC domain
platform create -name vck190_platform -hw vck190
domain create -name {pmc_domain} -os {standalone} -proc {versal_cips_0_pspmc_0_psv_pmc_0} -arch {32-bit} -display-name {pmc_domain} -desc {} -runtime {cpp}
platform write
platform generate

# Create PLM application
app create -name plm -platform vck190_platform -sysproj plm_system -template "versal PLM"
file copy -force ../Software/Vitis/src/xplm_main.c ../Software/Vitis/workspace/plm/src/xplm_main.c
file copy -force ../Software/Vitis/src/lscript.ld ../Software/Vitis/workspace/plm/src/lscript.ld

# Build PLM application
app build -name plm

# Create Boot image
exec bootgen -arch versal -image ../Software/Vitis/bootimage/bootimage.bif -w -o ../Software/Vitis/bootimage/BOOT.bin
