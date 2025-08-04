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

setws -switch ../Design/Software/Vitis/prj_plm

platform create -name vck190_wrapper -hw ../Design/Hardware/vck190_ddr4/design_1_wrapper.xsa

domain create -name pmc -os standalone -proc versal_cips_0_pspmc_0_psv_pmc_0 -support-app {versal_plm}

platform generate

bsp reload

bsp config plm_usb_en "true"

bsp write

bsp reload

catch {bsp regenerate}

platform generate

app create -name plm -sysproj plm_system -platform vck190_wrapper -domain pmc -template {versal PLM} -lang C
	
app build -name plm



