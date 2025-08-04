#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#start_gui
add_files ../vivado_synth_static/outputs/dcps/static_synth.dcp
add_files ../vivado_synth_rm1/outputs/dcps/rm1_synth.dcp
set_property SCOPED_TO_CELLS {RP1_inst} [get_files rm1_synth.dcp]
link_design -reconfig_partitions {RP1_inst} -top design_1_wrapper -part xcvc1902-vsva2197-2MP-e-S
write_checkpoint -force ./outputs/design_1_wrapper_post_link.dcp
read_xdc ../sources/xdc/static/pblocks.xdc
opt_design
write_checkpoint -force ./outputs/design_1_wrapper_post_opt.dcp
place_design
phys_opt_design
route_design
report_drc -file design_1_wrapper_drc_routed.rpt -pb design_1_wrapper_drc_routed.pb -rpx design_1_wrapper_drc_routed.rpx
report_timing_summary -max_paths 10 -report_unconstrained -file design_1_wrapper_timing_summary_routed.rpt -pb design_1_wrapper_timing_summary_routed.pb -rpx design_1_wrapper_timing_summary_routed.rpx -warn_on_violation
write_checkpoint -force ./outputs/design_1_wrapper_post_route.dcp
write_device_image -force ./outputs/design_1_wrapper_with_rm1.pdi
write_debug_probes -force ./outputs/design_1_wrapper_with_rm1.ltx
write_device_image -force -cell RP1_inst ./outputs/rp1_rm1_partial.pdi
write_debug_probes -force -cell RP1_inst ./outputs/rp1_rm1_partial.ltx
exit

