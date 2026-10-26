#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

open_checkpoint ../vivado_impl_static_with_rm1/outputs/design_1_wrapper_post_route.dcp 
#Abstract Shell Creation
exec mkdir -p ./outputs
write_abstract_shell -cell RP1_inst ./outputs/abstract_shell.dcp -force 

#Full Shell Creation
update_design -black_box -cell RP1_inst
lock_design -level routing
write_checkpoint -force ./outputs/static_shell_bb.dcp
exit
