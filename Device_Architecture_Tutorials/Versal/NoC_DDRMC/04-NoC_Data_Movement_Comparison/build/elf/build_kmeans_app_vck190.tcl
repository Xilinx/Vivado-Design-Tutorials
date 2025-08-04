# © Copyright 2021 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set the workspace
setws ./kmeans_workspace_vck190
#
#
#
app create -name kmeans_top_vck190 -template {Empty Application} \
-proc psv_cortexa72_0 \
-hw ../design/kmeans_project_vck190/design_1_wrapper.xsa
app config -name kmeans_top_vck190 build-config release
platform generate design_1_wrapper
platform active design_1_wrapper
domain create -name standalone_psv_cortexa72_0 \
-display-name standalone_psv_cortexa72_0 \
-os standalone \
-proc psv_cortexa72_0 \
-arch 64-bit
domain active standalone_psv_cortexa72_0
importsources -name kmeans_top_vck190 -path ../../src/vck190
app build -name kmeans_top_vck190
