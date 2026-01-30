#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#
# FLOORPLAN TO SEE SIGNAL NET B/W DISJOINT PBLOCK UNROUTE DURING ROUTER SLL ASSIGNMENT  

create_clock -period 10 -name clk_in1_0 [get_ports clk_in1_0]
create_clock -period 10 -name clk_in1_0_0 [get_ports clk_in1_0_0]

create_pblock pblock_rp1
add_cells_to_pblock [get_pblocks pblock_rp1] [get_cells -quiet [list design_1_i/rp1rm1_0]]
resize_pblock [get_pblocks pblock_rp1] -add {SLICE_X72Y0:SLICE_X83Y14}
resize_pblock [get_pblocks pblock_rp1] -add {BUFGCE_X3Y0:BUFGCE_X3Y23}
resize_pblock [get_pblocks pblock_rp1] -add {BUFGCE_DIV_X3Y0:BUFGCE_DIV_X3Y3}
resize_pblock [get_pblocks pblock_rp1] -add {BUFGCTRL_X3Y0:BUFGCTRL_X3Y7}
resize_pblock [get_pblocks pblock_rp1] -add {DDRMC_RIU_X1Y0:DDRMC_RIU_X1Y0}
resize_pblock [get_pblocks pblock_rp1] -add {DPLL_X4Y0:DPLL_X4Y0}
resize_pblock [get_pblocks pblock_rp1] -add {IOB_X27Y0:IOB_X30Y2}
resize_pblock [get_pblocks pblock_rp1] -add {MMCM_X3Y0:MMCM_X3Y0}
resize_pblock [get_pblocks pblock_rp1] -add {XPHY_X27Y0:XPHY_X30Y0}
resize_pblock [get_pblocks pblock_rp1] -add {XPIOLOGIC_X27Y0:XPIOLOGIC_X30Y2}
resize_pblock [get_pblocks pblock_rp1] -add {XPIO_VREF_X27Y0:XPIO_VREF_X30Y0}
resize_pblock [get_pblocks pblock_rp1] -add {XPLL_X6Y0:XPLL_X7Y0}
resize_pblock [get_pblocks pblock_rp1] -add {CLOCKREGION_X0Y5:CLOCKREGION_X6Y5}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp1]


create_pblock pblock_rp2
add_cells_to_pblock [get_pblocks pblock_rp2] [get_cells -quiet [list design_1_i/rp2rm1_0]]
#resize pblock to fix BLI overlap error at opt_design
resize_pblock pblock_rp2 -add {CLOCKREGION_X2Y2:CLOCKREGION_X6Y4 CLOCKREGION_X3Y1:CLOCKREGION_X6Y1}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp2]

create_pblock pblock_xpm_cdc_gen
resize_pblock [get_pblocks pblock_xpm_cdc_gen] -add {CLOCKREGION_X1Y6:CLOCKREGION_X2Y6}
add_cells_to_pblock [get_pblocks pblock_xpm_cdc_gen] [get_cells [list design_1_i/static_region/xpm_cdc_gen_0]]

create_pblock pblock_c_counter_binary
add_cells_to_pblock [get_pblocks pblock_c_counter_binary] [get_cells [list design_1_i/static_region/c_counter_binary_0]]
resize_pblock [get_pblocks pblock_c_counter_binary] -add CLOCKREGION_X1Y2:CLOCKREGION_X1Y4 


set_property PACKAGE_PIN AK14 [get_ports {CH0_DDR4_0_0_0_act_n[0]}]
set_property PACKAGE_PIN AJ15 [get_ports {CH0_DDR4_0_0_0_adr[0]}]
set_property PACKAGE_PIN AL12 [get_ports {CH0_DDR4_0_0_0_adr[10]}]
set_property PACKAGE_PIN AT10 [get_ports {CH0_DDR4_0_0_0_adr[11]}]
set_property PACKAGE_PIN BD12 [get_ports {CH0_DDR4_0_0_0_adr[12]}]
set_property PACKAGE_PIN AU12 [get_ports {CH0_DDR4_0_0_0_adr[13]}]
set_property PACKAGE_PIN AT14 [get_ports {CH0_DDR4_0_0_0_adr[14]}]
set_property PACKAGE_PIN AR13 [get_ports {CH0_DDR4_0_0_0_adr[15]}]
set_property PACKAGE_PIN AJ13 [get_ports {CH0_DDR4_0_0_0_adr[16]}]
set_property PACKAGE_PIN AV13 [get_ports {CH0_DDR4_0_0_0_adr[1]}]
set_property PACKAGE_PIN AU14 [get_ports {CH0_DDR4_0_0_0_adr[2]}]
set_property PACKAGE_PIN AL15 [get_ports {CH0_DDR4_0_0_0_adr[3]}]
set_property PACKAGE_PIN AN14 [get_ports {CH0_DDR4_0_0_0_adr[4]}]
set_property PACKAGE_PIN AU11 [get_ports {CH0_DDR4_0_0_0_adr[5]}]
set_property PACKAGE_PIN AT11 [get_ports {CH0_DDR4_0_0_0_adr[6]}]
set_property PACKAGE_PIN AY14 [get_ports {CH0_DDR4_0_0_0_adr[7]}]
set_property PACKAGE_PIN AU9 [get_ports {CH0_DDR4_0_0_0_adr[8]}]
set_property PACKAGE_PIN AJ12 [get_ports {CH0_DDR4_0_0_0_adr[9]}]
set_property PACKAGE_PIN AM15 [get_ports {CH0_DDR4_0_0_0_ba[0]}]
set_property PACKAGE_PIN AP15 [get_ports {CH0_DDR4_0_0_0_ba[1]}]
set_property PACKAGE_PIN AK13 [get_ports {CH0_DDR4_0_0_0_bg[0]}]
set_property PACKAGE_PIN AV12 [get_ports {CH0_DDR4_0_0_0_bg[1]}]
set_property PACKAGE_PIN AP14 [get_ports {CH0_DDR4_0_0_0_ck_t[0]}]
set_property PACKAGE_PIN AR15 [get_ports {CH0_DDR4_0_0_0_ck_c[0]}]
set_property PACKAGE_PIN AM12 [get_ports {CH0_DDR4_0_0_0_cke[0]}]
set_property PACKAGE_PIN AP12 [get_ports {CH0_DDR4_0_0_0_cs_n[0]}]
set_property PACKAGE_PIN AW14 [get_ports {CH0_DDR4_0_0_0_dm_n[0]}]
set_property PACKAGE_PIN BC13 [get_ports {CH0_DDR4_0_0_0_dm_n[1]}]
set_property PACKAGE_PIN BE13 [get_ports {CH0_DDR4_0_0_0_dm_n[2]}]
set_property PACKAGE_PIN BJ7 [get_ports {CH0_DDR4_0_0_0_dm_n[3]}]
set_property PACKAGE_PIN BM6 [get_ports {CH0_DDR4_0_0_0_dm_n[4]}]
set_property PACKAGE_PIN BL13 [get_ports {CH0_DDR4_0_0_0_dm_n[5]}]
set_property PACKAGE_PIN BM14 [get_ports {CH0_DDR4_0_0_0_dm_n[6]}]
set_property PACKAGE_PIN BH17 [get_ports {CH0_DDR4_0_0_0_dm_n[7]}]
set_property PACKAGE_PIN AY12 [get_ports {CH0_DDR4_0_0_0_dq[0]}]
set_property PACKAGE_PIN BC12 [get_ports {CH0_DDR4_0_0_0_dq[10]}]
set_property PACKAGE_PIN BA10 [get_ports {CH0_DDR4_0_0_0_dq[11]}]
set_property PACKAGE_PIN BD10 [get_ports {CH0_DDR4_0_0_0_dq[12]}]
set_property PACKAGE_PIN BE9 [get_ports {CH0_DDR4_0_0_0_dq[13]}]
set_property PACKAGE_PIN BE10 [get_ports {CH0_DDR4_0_0_0_dq[14]}]
set_property PACKAGE_PIN BF10 [get_ports {CH0_DDR4_0_0_0_dq[15]}]
set_property PACKAGE_PIN BF11 [get_ports {CH0_DDR4_0_0_0_dq[16]}]
set_property PACKAGE_PIN BH12 [get_ports {CH0_DDR4_0_0_0_dq[17]}]
set_property PACKAGE_PIN BG10 [get_ports {CH0_DDR4_0_0_0_dq[18]}]
set_property PACKAGE_PIN BH11 [get_ports {CH0_DDR4_0_0_0_dq[19]}]
set_property PACKAGE_PIN AY11 [get_ports {CH0_DDR4_0_0_0_dq[1]}]
set_property PACKAGE_PIN BE12 [get_ports {CH0_DDR4_0_0_0_dq[20]}]
set_property PACKAGE_PIN BG13 [get_ports {CH0_DDR4_0_0_0_dq[21]}]
set_property PACKAGE_PIN BG12 [get_ports {CH0_DDR4_0_0_0_dq[22]}]
set_property PACKAGE_PIN BH10 [get_ports {CH0_DDR4_0_0_0_dq[23]}]
set_property PACKAGE_PIN BJ5 [get_ports {CH0_DDR4_0_0_0_dq[24]}]
set_property PACKAGE_PIN BK2 [get_ports {CH0_DDR4_0_0_0_dq[25]}]
set_property PACKAGE_PIN BK5 [get_ports {CH0_DDR4_0_0_0_dq[26]}]
set_property PACKAGE_PIN BJ2 [get_ports {CH0_DDR4_0_0_0_dq[27]}]
set_property PACKAGE_PIN BK3 [get_ports {CH0_DDR4_0_0_0_dq[28]}]
set_property PACKAGE_PIN BL3 [get_ports {CH0_DDR4_0_0_0_dq[29]}]
set_property PACKAGE_PIN AW13 [get_ports {CH0_DDR4_0_0_0_dq[2]}]
set_property PACKAGE_PIN BJ3 [get_ports {CH0_DDR4_0_0_0_dq[30]}]
set_property PACKAGE_PIN BL4 [get_ports {CH0_DDR4_0_0_0_dq[31]}]
set_property PACKAGE_PIN BL6 [get_ports {CH0_DDR4_0_0_0_dq[32]}]
set_property PACKAGE_PIN BM7 [get_ports {CH0_DDR4_0_0_0_dq[33]}]
set_property PACKAGE_PIN BN7 [get_ports {CH0_DDR4_0_0_0_dq[34]}]
set_property PACKAGE_PIN BK7 [get_ports {CH0_DDR4_0_0_0_dq[35]}]
set_property PACKAGE_PIN BL5 [get_ports {CH0_DDR4_0_0_0_dq[36]}]
set_property PACKAGE_PIN BL8 [get_ports {CH0_DDR4_0_0_0_dq[37]}]
set_property PACKAGE_PIN BM4 [get_ports {CH0_DDR4_0_0_0_dq[38]}]
set_property PACKAGE_PIN BN5 [get_ports {CH0_DDR4_0_0_0_dq[39]}]
set_property PACKAGE_PIN AW11 [get_ports {CH0_DDR4_0_0_0_dq[3]}]
set_property PACKAGE_PIN BL11 [get_ports {CH0_DDR4_0_0_0_dq[40]}]
set_property PACKAGE_PIN BM12 [get_ports {CH0_DDR4_0_0_0_dq[41]}]
set_property PACKAGE_PIN BL10 [get_ports {CH0_DDR4_0_0_0_dq[42]}]
set_property PACKAGE_PIN BN12 [get_ports {CH0_DDR4_0_0_0_dq[43]}]
set_property PACKAGE_PIN BK11 [get_ports {CH0_DDR4_0_0_0_dq[44]}]
set_property PACKAGE_PIN BK10 [get_ports {CH0_DDR4_0_0_0_dq[45]}]
set_property PACKAGE_PIN BJ12 [get_ports {CH0_DDR4_0_0_0_dq[46]}]
set_property PACKAGE_PIN BJ10 [get_ports {CH0_DDR4_0_0_0_dq[47]}]
set_property PACKAGE_PIN BM18 [get_ports {CH0_DDR4_0_0_0_dq[48]}]
set_property PACKAGE_PIN BK16 [get_ports {CH0_DDR4_0_0_0_dq[49]}]
set_property PACKAGE_PIN BA13 [get_ports {CH0_DDR4_0_0_0_dq[4]}]
set_property PACKAGE_PIN BN17 [get_ports {CH0_DDR4_0_0_0_dq[50]}]
set_property PACKAGE_PIN BN15 [get_ports {CH0_DDR4_0_0_0_dq[51]}]
set_property PACKAGE_PIN BN16 [get_ports {CH0_DDR4_0_0_0_dq[52]}]
set_property PACKAGE_PIN BL15 [get_ports {CH0_DDR4_0_0_0_dq[53]}]
set_property PACKAGE_PIN BM17 [get_ports {CH0_DDR4_0_0_0_dq[54]}]
set_property PACKAGE_PIN BM16 [get_ports {CH0_DDR4_0_0_0_dq[55]}]
set_property PACKAGE_PIN BJ17 [get_ports {CH0_DDR4_0_0_0_dq[56]}]
set_property PACKAGE_PIN BH14 [get_ports {CH0_DDR4_0_0_0_dq[57]}]
set_property PACKAGE_PIN BH16 [get_ports {CH0_DDR4_0_0_0_dq[58]}]
set_property PACKAGE_PIN BK15 [get_ports {CH0_DDR4_0_0_0_dq[59]}]
set_property PACKAGE_PIN BB11 [get_ports {CH0_DDR4_0_0_0_dq[5]}]
set_property PACKAGE_PIN BL18 [get_ports {CH0_DDR4_0_0_0_dq[60]}]
set_property PACKAGE_PIN BL14 [get_ports {CH0_DDR4_0_0_0_dq[61]}]
set_property PACKAGE_PIN BK18 [get_ports {CH0_DDR4_0_0_0_dq[62]}]
set_property PACKAGE_PIN BJ14 [get_ports {CH0_DDR4_0_0_0_dq[63]}]
set_property PACKAGE_PIN BB12 [get_ports {CH0_DDR4_0_0_0_dq[6]}]
set_property PACKAGE_PIN BA12 [get_ports {CH0_DDR4_0_0_0_dq[7]}]
set_property PACKAGE_PIN BD11 [get_ports {CH0_DDR4_0_0_0_dq[8]}]
set_property PACKAGE_PIN BB10 [get_ports {CH0_DDR4_0_0_0_dq[9]}]
set_property PACKAGE_PIN AY9 [get_ports {CH0_DDR4_0_0_0_dqs_t[0]}]
set_property PACKAGE_PIN BA9 [get_ports {CH0_DDR4_0_0_0_dqs_c[0]}]
set_property PACKAGE_PIN BC9 [get_ports {CH0_DDR4_0_0_0_dqs_t[1]}]
set_property PACKAGE_PIN BC10 [get_ports {CH0_DDR4_0_0_0_dqs_c[1]}]
set_property PACKAGE_PIN BG9 [get_ports {CH0_DDR4_0_0_0_dqs_t[2]}]
set_property PACKAGE_PIN BH9 [get_ports {CH0_DDR4_0_0_0_dqs_c[2]}]
set_property PACKAGE_PIN BH4 [get_ports {CH0_DDR4_0_0_0_dqs_t[3]}]
set_property PACKAGE_PIN BJ4 [get_ports {CH0_DDR4_0_0_0_dqs_c[3]}]
set_property PACKAGE_PIN BN9 [get_ports {CH0_DDR4_0_0_0_dqs_t[4]}]
set_property PACKAGE_PIN BM8 [get_ports {CH0_DDR4_0_0_0_dqs_c[4]}]
set_property PACKAGE_PIN BM11 [get_ports {CH0_DDR4_0_0_0_dqs_t[5]}]
set_property PACKAGE_PIN BN11 [get_ports {CH0_DDR4_0_0_0_dqs_c[5]}]
set_property PACKAGE_PIN BK17 [get_ports {CH0_DDR4_0_0_0_dqs_t[6]}]
set_property PACKAGE_PIN BL16 [get_ports {CH0_DDR4_0_0_0_dqs_c[6]}]
set_property PACKAGE_PIN BH15 [get_ports {CH0_DDR4_0_0_0_dqs_t[7]}]
set_property PACKAGE_PIN BJ15 [get_ports {CH0_DDR4_0_0_0_dqs_c[7]}]
set_property PACKAGE_PIN AN13 [get_ports {CH0_DDR4_0_0_0_odt[0]}]
set_property PACKAGE_PIN BN10 [get_ports {CH0_DDR4_0_0_0_reset_n[0]}]
set_property PACKAGE_PIN BL9 [get_ports {sys_clk0_0_clk_p[0]}]
set_property PACKAGE_PIN BK8 [get_ports {sys_clk0_0_clk_n[0]}]



set_property NOC_HIGH_ID_MAX 63 [get_pblocks pblock_rp1]
set_property NOC_HIGH_ID_MIN 47 [get_pblocks pblock_rp1]
set_property NOC_HIGH_ID_MAX 46 [get_pblocks pblock_rp2]
set_property NOC_HIGH_ID_MIN 18 [get_pblocks pblock_rp2]


set_property PACKAGE_PIN R32 [get_ports clk_in1_0]
set_property PACKAGE_PIN K35 [get_ports reset_0]
set_property PACKAGE_PIN L36 [get_ports CE_0]
set_property PACKAGE_PIN K36 [get_ports ext_reset_in_0]
set_property PACKAGE_PIN AY21 [get_ports clk_in1_0_0]

set_property IOSTANDARD LVCMOS15 [get_ports clk_in1_0]
set_property IOSTANDARD LVCMOS15 [get_ports reset_0]
set_property IOSTANDARD LVCMOS15 [get_ports CE_0]
set_property IOSTANDARD LVCMOS15 [get_ports ext_reset_in_0]
set_property IOSTANDARD LVCMOS15 [get_ports clk_in1_0_0]
