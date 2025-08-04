# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11

set_property -dict [list \
  CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
  CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
  CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../csv/module2_part2_tg_synth_wr_followed_by_rd_rnd_0.csv} \
] [get_bd_cells noc_tg]


set_property -dict [list \
  CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
  CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
  CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../csv/module2_part2_tg_synth_wr_followed_by_rd_rnd_1.csv} \
] [get_bd_cells noc_tg_1]


set_property -dict [list \
  CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
  CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
  CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../csv/module2_part2_tg_synth_wr_followed_by_rd_rnd_2.csv} \
] [get_bd_cells noc_tg_2]


set_property -dict [list \
  CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
  CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
  CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../csv/module2_part2_tg_synth_wr_followed_by_rd_rnd_3.csv} \
] [get_bd_cells noc_tg_3]


