#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

create_pblock pblock_rp1
add_cells_to_pblock [get_pblocks pblock_rp1] [get_cells -quiet [list design_1_i/rp1]]
resize_pblock [get_pblocks pblock_rp1] -add {SLICE_X116Y140:SLICE_X147Y187}
resize_pblock [get_pblocks pblock_rp1] -add {BUFGCE_X4Y0:BUFGCE_X4Y23}
resize_pblock [get_pblocks pblock_rp1] -add {BUFGCE_DIV_X4Y0:BUFGCE_DIV_X4Y3}
resize_pblock [get_pblocks pblock_rp1] -add {BUFGCTRL_X4Y0:BUFGCTRL_X4Y7}
resize_pblock [get_pblocks pblock_rp1] -add {DPLL_X6Y0:DPLL_X6Y0}
resize_pblock [get_pblocks pblock_rp1] -add {DSP58_CPLX_X1Y70:DSP58_CPLX_X1Y93}
resize_pblock [get_pblocks pblock_rp1] -add {DSP_X2Y70:DSP_X3Y93}
resize_pblock [get_pblocks pblock_rp1] -add {IOB_X37Y0:IOB_X45Y2}
resize_pblock [get_pblocks pblock_rp1] -add {MMCM_X4Y0:MMCM_X4Y0}
resize_pblock [get_pblocks pblock_rp1] -add {RAMB18_X3Y72:RAMB18_X4Y95}
resize_pblock [get_pblocks pblock_rp1] -add {RAMB36_X3Y36:RAMB36_X4Y47}
resize_pblock [get_pblocks pblock_rp1] -add {URAM288_X2Y36:URAM288_X2Y47}
resize_pblock [get_pblocks pblock_rp1] -add {URAM_CAS_DLY_X2Y1:URAM_CAS_DLY_X2Y1}
resize_pblock [get_pblocks pblock_rp1] -add {XPHY_X36Y0:XPHY_X44Y0}
resize_pblock [get_pblocks pblock_rp1] -add {XPIOLOGIC_X36Y0:XPIOLOGIC_X44Y2}
resize_pblock [get_pblocks pblock_rp1] -add {XPIO_DCI_X4Y0:XPIO_DCI_X4Y0}
resize_pblock [get_pblocks pblock_rp1] -add {XPIO_VREF_X36Y0:XPIO_VREF_X44Y0}
resize_pblock [get_pblocks pblock_rp1] -add {XPLL_X8Y0:XPLL_X9Y0}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp1]


create_pblock pblock_rp2
add_cells_to_pblock [get_pblocks pblock_rp2] [get_cells -quiet [list design_1_i/rp2]]
resize_pblock [get_pblocks pblock_rp2] -add {SLICE_X116Y92:SLICE_X147Y139}
resize_pblock [get_pblocks pblock_rp2] -add {BUFGCE_X6Y0:BUFGCE_X6Y23}
resize_pblock [get_pblocks pblock_rp2] -add {BUFGCE_DIV_X6Y0:BUFGCE_DIV_X6Y3}
resize_pblock [get_pblocks pblock_rp2] -add {BUFGCTRL_X6Y0:BUFGCTRL_X6Y7}
resize_pblock [get_pblocks pblock_rp2] -add {DDRMC_X2Y0:DDRMC_X2Y0}
resize_pblock [get_pblocks pblock_rp2] -add {DPLL_X8Y0:DPLL_X8Y0}
resize_pblock [get_pblocks pblock_rp2] -add {DSP58_CPLX_X1Y46:DSP58_CPLX_X1Y69}
resize_pblock [get_pblocks pblock_rp2] -add {DSP_X2Y46:DSP_X3Y69}
resize_pblock [get_pblocks pblock_rp2] -add {IOB_X55Y0:IOB_X63Y2}
resize_pblock [get_pblocks pblock_rp2] -add {MMCM_X6Y0:MMCM_X6Y0}
resize_pblock [get_pblocks pblock_rp2] -add {RAMB18_X3Y48:RAMB18_X4Y71}
resize_pblock [get_pblocks pblock_rp2] -add {RAMB36_X3Y24:RAMB36_X4Y35}
resize_pblock [get_pblocks pblock_rp2] -add {URAM288_X2Y24:URAM288_X2Y35}
resize_pblock [get_pblocks pblock_rp2] -add {XPHY_X54Y0:XPHY_X62Y0}
resize_pblock [get_pblocks pblock_rp2] -add {XPIOLOGIC_X54Y0:XPIOLOGIC_X62Y2}
resize_pblock [get_pblocks pblock_rp2] -add {XPIO_DCI_X6Y0:XPIO_DCI_X6Y0}
resize_pblock [get_pblocks pblock_rp2] -add {XPIO_VREF_X54Y0:XPIO_VREF_X62Y0}
resize_pblock [get_pblocks pblock_rp2] -add {XPLL_X12Y0:XPLL_X13Y0}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp2]





