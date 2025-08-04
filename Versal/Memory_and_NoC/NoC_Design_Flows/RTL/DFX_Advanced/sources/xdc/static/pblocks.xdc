#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


####################################################################################
# Constraints from file : 'pblocks.xdc'
####################################################################################

current_instance -quiet
create_pblock dynamic_region
add_cells_to_pblock [get_pblocks dynamic_region] [get_cells -quiet [list RP1_inst]]
resize_pblock [get_pblocks dynamic_region] -add {SLICE_X76Y0:SLICE_X331Y327}
resize_pblock [get_pblocks dynamic_region] -add {BLI_A_GRP0_X40Y0:BLI_A_GRP0_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_A_GRP1_X40Y0:BLI_A_GRP1_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_A_GRP2_X40Y0:BLI_A_GRP2_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_B_GRP0_X40Y0:BLI_B_GRP0_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_B_GRP1_X40Y0:BLI_B_GRP1_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_B_GRP2_X40Y0:BLI_B_GRP2_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_C_GRP0_X40Y0:BLI_C_GRP0_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_C_GRP1_X40Y0:BLI_C_GRP1_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_C_GRP2_X40Y0:BLI_C_GRP2_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_D_GRP4_X40Y0:BLI_D_GRP4_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_D_GRP5_X40Y0:BLI_D_GRP5_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_D_GRP6_X40Y0:BLI_D_GRP6_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_D_GRP7_X40Y0:BLI_D_GRP7_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BLI_TMR_X40Y0:BLI_TMR_X186Y1}
resize_pblock [get_pblocks dynamic_region] -add {BUFDIV_LEAF_X96Y0:BUFDIV_LEAF_X116Y223 BUFDIV_LEAF_X27Y0:BUFDIV_LEAF_X95Y255}
resize_pblock [get_pblocks dynamic_region] -add {BUFGCE_X4Y0:BUFGCE_X10Y23}
resize_pblock [get_pblocks dynamic_region] -add {BUFGCE_DIV_X4Y0:BUFGCE_DIV_X10Y3}
resize_pblock [get_pblocks dynamic_region] -add {BUFGCTRL_X4Y0:BUFGCTRL_X10Y7}
resize_pblock [get_pblocks dynamic_region] -add {BUFG_FABRIC_X2Y0:BUFG_FABRIC_X4Y95}
resize_pblock [get_pblocks dynamic_region] -add {DDRMC_X1Y0:DDRMC_X3Y0}
resize_pblock [get_pblocks dynamic_region] -add {DDRMC_RIU_X2Y0:DDRMC_RIU_X3Y0}
resize_pblock [get_pblocks dynamic_region] -add {DPLL_X5Y0:DPLL_X11Y0}
resize_pblock [get_pblocks dynamic_region] -add {DSP58_CPLX_X0Y0:DSP58_CPLX_X5Y163}
resize_pblock [get_pblocks dynamic_region] -add {DSP_X0Y0:DSP_X11Y163}
resize_pblock [get_pblocks dynamic_region] -add {GCLK_DELAY_X3Y0:GCLK_DELAY_X5Y191}
resize_pblock [get_pblocks dynamic_region] -add {GCLK_PD_X12Y0:GCLK_PD_X13Y239 GCLK_PD_X4Y0:GCLK_PD_X11Y287}
resize_pblock [get_pblocks dynamic_region] -add {GCLK_TAPS_DECODE_VNOC_X1Y0:GCLK_TAPS_DECODE_VNOC_X3Y3}
resize_pblock [get_pblocks dynamic_region] -add {IOB_X32Y0:IOB_X92Y2}
resize_pblock [get_pblocks dynamic_region] -add {IRI_QUAD_X47Y0:IRI_QUAD_X206Y1367}
resize_pblock [get_pblocks dynamic_region] -add {MISR_X0Y0:MISR_X3Y3}
resize_pblock [get_pblocks dynamic_region] -add {MMCM_X4Y0:MMCM_X9Y0}
resize_pblock [get_pblocks dynamic_region] -add {NOC_NMU512_X1Y0:NOC_NMU512_X3Y6}
resize_pblock [get_pblocks dynamic_region] -add {NOC_NPS_VNOC_X1Y0:NOC_NPS_VNOC_X3Y13}
resize_pblock [get_pblocks dynamic_region] -add {NOC_NSU512_X1Y0:NOC_NSU512_X3Y6}
resize_pblock [get_pblocks dynamic_region] -add {RAMB18_X11Y0:RAMB18_X11Y165 RAMB18_X2Y0:RAMB18_X10Y167}
resize_pblock [get_pblocks dynamic_region] -add {RAMB36_X11Y0:RAMB36_X11Y82 RAMB36_X2Y0:RAMB36_X10Y83}
resize_pblock [get_pblocks dynamic_region] -add {URAM288_X2Y0:URAM288_X4Y82}
resize_pblock [get_pblocks dynamic_region] -add {URAM_CAS_DLY_X2Y0:URAM_CAS_DLY_X4Y2}
resize_pblock [get_pblocks dynamic_region] -add {XPHY_X31Y0:XPHY_X91Y0}
resize_pblock [get_pblocks dynamic_region] -add {XPIOLOGIC_X31Y0:XPIOLOGIC_X91Y2}
resize_pblock [get_pblocks dynamic_region] -add {XPIO_VREF_X31Y0:XPIO_VREF_X91Y0}
resize_pblock [get_pblocks dynamic_region] -add {XPLL_X7Y0:XPLL_X19Y0}
set_property SNAPPING_MODE ON [get_pblocks dynamic_region]

