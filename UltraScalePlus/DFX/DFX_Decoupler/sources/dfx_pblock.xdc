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

create_pblock pblock_hier_1
add_cells_to_pblock [get_pblocks pblock_hier_1] [get_cells -quiet [list dfx_shdn_mgr_i/hier_1]]
resize_pblock [get_pblocks pblock_hier_1] -add {SLICE_X56Y185:SLICE_X63Y205}
resize_pblock [get_pblocks pblock_hier_1] -add {DSP48E2_X5Y74:DSP48E2_X5Y81}
set_property SNAPPING_MODE ON [get_pblocks pblock_hier_1]
