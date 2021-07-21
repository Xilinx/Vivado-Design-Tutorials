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


create_pblock pblock_RP1
add_cells_to_pblock [get_pblocks pblock_RP1] [get_cells -quiet [list design_1_i/RP1]]
resize_pblock [get_pblocks pblock_RP1] -add {CLOCKREGION_X1Y2:CLOCKREGION_X1Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP1]



create_pblock pblock_RP2
add_cells_to_pblock [get_pblocks pblock_RP2] [get_cells -quiet [list design_1_i/RP2]]
resize_pblock [get_pblocks pblock_RP2] -add {CLOCKREGION_X3Y2:CLOCKREGION_X3Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP2]

create_pblock pblock_RP3
add_cells_to_pblock pblock_RP3 [get_cells [list design_1_i/RP3]] 
resize_pblock [get_pblocks pblock_RP3] -add {CLOCKREGION_X5Y2:CLOCKREGION_X5Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP3]

create_pblock pblock_RP4
add_cells_to_pblock pblock_RP4 [get_cells [list design_1_i/RP4]] 
resize_pblock [get_pblocks pblock_RP4] -add {CLOCKREGION_X7Y2:CLOCKREGION_X7Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP4]
