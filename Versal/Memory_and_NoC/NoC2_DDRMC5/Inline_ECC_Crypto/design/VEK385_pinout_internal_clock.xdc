# (c) Copyright 2025 Advanced Micro Devices, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of AMD and is protected under U.S. and international copyright
# and other intellectual property laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# AMD, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) AMD shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or AMD had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# AMD products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of AMD products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
############################################################


#    set_property PACKAGE_PIN AP3        [get_ports "SYS_CLK0_clk_p"] ;# Bank 702 VCCO -          - IO_L3P_GC_H0O0P6_M0P70_702
#    set_property PACKAGE_PIN AP2        [get_ports "SYS_CLK0_clk_n"] ;# Bank 702 VCCO -          - IO_L3N_GC_H0O0P7_M0P71_70
#    set_property IOSTANDARD LVDS12      [get_ports {"SYS_CLK0_clk_p" "SYS_CLK0_clk_n"}]
#    set_property CTLE_EQ CTLE_EQ_LEVEL7 [get_ports {"SYS_CLK0_clk_p" "SYS_CLK0_clk_n"}]
#    set_property PULLTYPE OFF           [get_ports "SYS_CLK0_clk_p"]
#
#    set_property PACKAGE_PIN BA22       [get_ports "SYS_CLK1_clk_p"] ;# Bank 707 VCCO - VADJ_FMC - IO_L19P_GC_H1O0P6_707
#    set_property PACKAGE_PIN BA23       [get_ports "SYS_CLK1_clk_n"] ;# Bank 707 VCCO - VADJ_FMC - IO_L19N_GC_H1O0P7_707
#    set_property IOSTANDARD LVDS12      [get_ports {"SYS_CLK1_clk_p" "SYS_CLK1_clk_n"}]
#    set_property CTLE_EQ CTLE_EQ_LEVEL7 [get_ports {"SYS_CLK1_clk_p" "SYS_CLK1_clk_n"}]
#    set_property PULLTYPE OFF           [get_ports "SYS_CLK1_clk_p"]
#
#    set_property PACKAGE_PIN AV46       [get_ports "SYS_CLK2_clk_p"] ;# Bank 712 VCCO - VADJ_FMC - IO_L3P_GC_H0O0P6_M2P70_712
#    set_property PACKAGE_PIN AU46       [get_ports "SYS_CLK2_clk_n"] ;# Bank 712 VCCO - VADJ_FMC - IO_L3N_GC_H0O0P7_M2P71_7
#    set_property IOSTANDARD LVDS12      [get_ports {"SYS_CLK2_clk_p" "SYS_CLK2_clk_n"}]
#    set_property CTLE_EQ CTLE_EQ_LEVEL7 [get_ports {"SYS_CLK2_clk_p" "SYS_CLK2_clk_n"}]
#    set_property PULLTYPE OFF           [get_ports "SYS_CLK2_clk_p"]
#
    set_property PACKAGE_PIN AW13     [get_ports "CH1_LPDDR5X_dq[15]"] ;# Bank 703 VCCO -          - IO_L16P_H1O0P0_M1P96_703
    set_property PACKAGE_PIN AW12     [get_ports "CH1_LPDDR5X_dq[8]"] ;# Bank 703 VCCO -          - IO_L16N_H1O0P1_M1P97_703
    set_property PACKAGE_PIN AU12     [get_ports "CH1_LPDDR5X_rdqs_t[1]"] ;# Bank 703 VCCO -          - IO_L17P_XCC_H1O0P2_M1P98_703
    set_property PACKAGE_PIN AU11     [get_ports "CH1_LPDDR5X_rdqs_c[1]"] ;# Bank 703 VCCO -          - IO_L17N_XCC_H1O0P3_M1P99_703
    set_property PACKAGE_PIN AV11     [get_ports "CH1_LPDDR5X_dq[14]"] ;# Bank 703 VCCO -          - IO_L18P_H1O0P4_M1P100_703
    set_property PACKAGE_PIN AV10     [get_ports "CH1_LPDDR5X_dq[10]"] ;# Bank 703 VCCO -          - IO_L18N_H1O0P5_M1P101_703
    set_property PACKAGE_PIN AW10     [get_ports "CH1_LPDDR5X_ca[2]"] ;# Bank 703 VCCO -          - IO_L19P_GC_H1O0P6_M1P102_703
    set_property PACKAGE_PIN AW9      [get_ports "CH1_LPDDR5X_ca[1]"] ;# Bank 703 VCCO -          - IO_L19N_GC_H1O0P7_M1P103_703
    set_property PACKAGE_PIN AU9      [get_ports "CH1_LPDDR5X_dq[13]"] ;# Bank 703 VCCO -          - IO_L20P_H1O1P0_M1P104_703
    set_property PACKAGE_PIN AU8      [get_ports "CH1_LPDDR5X_dq[12]"] ;# Bank 703 VCCO -          - IO_L20N_H1O1P1_M1P105_703
    set_property PACKAGE_PIN AV8      [get_ports "CH1_LPDDR5X_wck_t[1]"] ;# Bank 703 VCCO -          - IO_L21P_XCC_H1O1P2_M1P106_703
    set_property PACKAGE_PIN AV7      [get_ports "CH1_LPDDR5X_wck_c[1]"] ;# Bank 703 VCCO -          - IO_L21N_XCC_H1O1P3_M1P107_703
    set_property PACKAGE_PIN AW7      [get_ports "CH1_LPDDR5X_dq[9]"] ;# Bank 703 VCCO -          - IO_L22P_H1O1P4_M1P108_703
    set_property PACKAGE_PIN AW6      [get_ports "CH1_LPDDR5X_dq[11]"] ;# Bank 703 VCCO -          - IO_L22N_H1O1P5_M1P109_703
    set_property PACKAGE_PIN AU6      [get_ports "CH1_LPDDR5X_dmi[1]"] ;# Bank 703 VCCO -          - IO_L23P_H1O1P6_M1P110_703
    set_property PACKAGE_PIN AU5      [get_ports "CH1_LPDDR5X_ca[3]"] ;# Bank 703 VCCO -          - IO_L23N_H1O1P7_M1P111_703
    set_property PACKAGE_PIN AY5      [get_ports "CH1_LPDDR5X_dq[7]"] ;# Bank 703 VCCO -          - IO_L24P_H1O2P0_M1P112_703
    set_property PACKAGE_PIN AW4      [get_ports "CH1_LPDDR5X_dq[6]"] ;# Bank 703 VCCO -          - IO_L24N_H1O2P1_M1P113_703
    set_property PACKAGE_PIN AV5      [get_ports "CH1_LPDDR5X_rdqs_t[0]"] ;# Bank 703 VCCO -          - IO_L25P_XCC_H1O2P2_M1P114_703
    set_property PACKAGE_PIN AV4      [get_ports "CH1_LPDDR5X_rdqs_c[0]"] ;# Bank 703 VCCO -          - IO_L25N_XCC_H1O2P3_M1P115_703
    set_property PACKAGE_PIN AW3      [get_ports "CH1_LPDDR5X_dq[4]"] ;# Bank 703 VCCO -          - IO_L26P_H1O2P4_M1P116_703
    set_property PACKAGE_PIN AY3      [get_ports "CH1_LPDDR5X_dq[5]"] ;# Bank 703 VCCO -          - IO_L26N_H1O2P5_M1P117_703
    set_property PACKAGE_PIN AU2      [get_ports "CH1_LPDDR5X_ca[5]"] ;# Bank 703 VCCO -          - IO_L27P_H1O2P6_M1P118_703
    set_property PACKAGE_PIN AV2      [get_ports "CH1_LPDDR5X_ca[4]"] ;# Bank 703 VCCO -          - IO_L27N_H1O2P7_M1P119_703
    set_property PACKAGE_PIN AT3      [get_ports "CH1_LPDDR5X_dq[0]"] ;# Bank 703 VCCO -          - IO_L28P_H1O3P0_M1P120_703
    set_property PACKAGE_PIN AU3      [get_ports "CH1_LPDDR5X_dq[2]"] ;# Bank 703 VCCO -          - IO_L28N_H1O3P1_M1P121_703
    set_property PACKAGE_PIN AY2      [get_ports "CH1_LPDDR5X_wck_t[0]"] ;# Bank 703 VCCO -          - IO_L29P_XCC_H1O3P2_M1P122_703
    set_property PACKAGE_PIN AY1      [get_ports "CH1_LPDDR5X_wck_c[0]"] ;# Bank 703 VCCO -          - IO_L29N_XCC_H1O3P3_M1P123_703
    set_property PACKAGE_PIN AV1      [get_ports "CH1_LPDDR5X_dq[1]"] ;# Bank 703 VCCO -          - IO_L30P_H1O3P4_M1P124_703
    set_property PACKAGE_PIN AW1      [get_ports "CH1_LPDDR5X_dq[3]"] ;# Bank 703 VCCO -          - IO_L30N_H1O3P5_M1P125_703
    set_property PACKAGE_PIN AT1      [get_ports "CH1_LPDDR5X_dmi[0]"] ;# Bank 703 VCCO -          - IO_L31P_H1O3P6_M1P126_703
    set_property PACKAGE_PIN AU1      [get_ports "CH1_LPDDR5X_ca[6]"] ;# Bank 703 VCCO -          - IO_L31N_H1O3P7_M1P127_703
    set_property PACKAGE_PIN BA1      [get_ports "CH1_LPDDR5X_dq[19]"] ;# Bank 704 VCCO -          - IO_L0P_H0O0P0_M1P128_704
    set_property PACKAGE_PIN BB1      [get_ports "CH1_LPDDR5X_dq[17]"] ;# Bank 704 VCCO -          - IO_L0N_H0O0P1_M1P129_704
    set_property PACKAGE_PIN BC6      [get_ports "CH1_LPDDR5X_rdqs_t[2]"] ;# Bank 704 VCCO -          - IO_L5P_XCC_H0O1P2_M1P138_704
    set_property PACKAGE_PIN BC5      [get_ports "CH1_LPDDR5X_rdqs_c[2]"] ;# Bank 704 VCCO -          - IO_L5N_XCC_H0O1P3_M1P139_704
    set_property PACKAGE_PIN BB7      [get_ports "CH1_LPDDR5X_dq[21]"] ;# Bank 704 VCCO -          - IO_L6P_H0O1P4_M1P140_704
    set_property PACKAGE_PIN BB6      [get_ports "CH1_LPDDR5X_dq[20]"] ;# Bank 704 VCCO -          - IO_L6N_H0O1P5_M1P141_704
    set_property PACKAGE_PIN BC9      [get_ports "CH1_LPDDR5X_dmi[2]"] ;# Bank 704 VCCO -          - IO_L7P_H0O1P6_M1P142_704
    set_property PACKAGE_PIN BC8      [get_ports "CH1_LPDDR5X_reset_n[0]"] ;# Bank 704 VCCO -          - IO_L7N_H0O1P7_M1P143_704
    set_property PACKAGE_PIN BA8      [get_ports "CH1_LPDDR5X_dq[25]"] ;# Bank 704 VCCO -          - IO_L8P_H0O2P0_M1P144_704
    set_property PACKAGE_PIN BA7      [get_ports "CH1_LPDDR5X_dq[26]"] ;# Bank 704 VCCO -          - IO_L8N_H0O2P1_M1P145_704
    set_property PACKAGE_PIN AY9      [get_ports "CH1_LPDDR5X_wck_t[3]"] ;# Bank 704 VCCO -          - IO_L9P_XCC_H0O2P2_M1P146_704
    set_property PACKAGE_PIN AY8      [get_ports "CH1_LPDDR5X_wck_c[3]"] ;# Bank 704 VCCO -          - IO_L9N_XCC_H0O2P3_M1P147_704
    set_property PACKAGE_PIN BC2      [get_ports "CH1_LPDDR5X_wck_t[2]"] ;# Bank 704 VCCO -          - IO_L1P_XCC_H0O0P2_M1P130_704
    set_property PACKAGE_PIN BB10     [get_ports "CH1_LPDDR5X_dq[31]"] ;# Bank 704 VCCO -          - IO_L10P_H0O2P4_M1P148_704
    set_property PACKAGE_PIN BB9      [get_ports "CH1_LPDDR5X_dq[27]"] ;# Bank 704 VCCO -          - IO_L10N_H0O2P5_M1P149_704
    set_property PACKAGE_PIN BA11     [get_ports "CH1_LPDDR5X_dmi[3]"] ;# Bank 704 VCCO -          - IO_L11P_H0O2P6_M1P150_704
    set_property PACKAGE_PIN BA10     [get_ports "CH1_LPDDR5X_ca[0]"] ;# Bank 704 VCCO -          - IO_L11N_H0O2P7_M1P151_704
    set_property PACKAGE_PIN AY12     [get_ports "CH1_LPDDR5X_dq[28]"] ;# Bank 704 VCCO -          - IO_L12P_H0O3P0_M1P152_704
    set_property PACKAGE_PIN AY11     [get_ports "CH1_LPDDR5X_dq[24]"] ;# Bank 704 VCCO -          - IO_L12N_H0O3P1_M1P153_704
    set_property PACKAGE_PIN BA13     [get_ports "CH1_LPDDR5X_rdqs_t[3]"] ;# Bank 704 VCCO -          - IO_L13P_XCC_H0O3P2_M1P154_704
    set_property PACKAGE_PIN BB13     [get_ports "CH1_LPDDR5X_rdqs_c[3]"] ;# Bank 704 VCCO -          - IO_L13N_XCC_H0O3P3_M1P155_704
    set_property PACKAGE_PIN BB12     [get_ports "CH1_LPDDR5X_dq[29]"] ;# Bank 704 VCCO -          - IO_L14P_H0O3P4_M1P156_704
    set_property PACKAGE_PIN BC11     [get_ports "CH1_LPDDR5X_dq[30]"] ;# Bank 704 VCCO -          - IO_L14N_H0O3P5_M1P157_704
    set_property PACKAGE_PIN BC1      [get_ports "CH1_LPDDR5X_wck_c[2]"] ;# Bank 704 VCCO -          - IO_L1N_XCC_H0O0P3_M1P131_704
    set_property PACKAGE_PIN AY14     [get_ports "CH1_LPDDR5X_ck_t[0]"] ;# Bank 704 VCCO -          - IO_L15P_H0O3P6_M1P158_704
    set_property PACKAGE_PIN BA14     [get_ports "CH1_LPDDR5X_ck_c[0]"] ;# Bank 704 VCCO -          - IO_L15N_H0O3P7_M1P159_704
    set_property PACKAGE_PIN BB3      [get_ports "CH1_LPDDR5X_dq[16]"] ;# Bank 704 VCCO -          - IO_L2P_H0O0P4_M1P132_704
    set_property PACKAGE_PIN BA2      [get_ports "CH1_LPDDR5X_dq[18]"] ;# Bank 704 VCCO -          - IO_L2N_H0O0P5_M1P133_704
    set_property PACKAGE_PIN AY6      [get_ports "CH1_LPDDR5X_cs[0]"] ;# Bank 704 VCCO -          - IO_L3P_GC_H0O0P6_M1P134_704
    set_property PACKAGE_PIN BA5      [get_ports "CH1_LPDDR5X_cs[1]"] ;# Bank 704 VCCO -          - IO_L3N_GC_H0O0P7_M1P135_704
    set_property PACKAGE_PIN BA4      [get_ports "CH1_LPDDR5X_dq[23]"] ;# Bank 704 VCCO -          - IO_L4P_H0O1P0_M1P136_704
    set_property PACKAGE_PIN BB4      [get_ports "CH1_LPDDR5X_dq[22]"] ;# Bank 704 VCCO -          - IO_L4N_H0O1P1_M1P137_704

    set_property PACKAGE_PIN BF25     [get_ports "CH2_LPDDR5X_dq[28]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L0P_H0O0P0_708
    set_property PACKAGE_PIN BF26     [get_ports "CH2_LPDDR5X_dq[29]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L0N_H0O0P1_708
    set_property PACKAGE_PIN BE25     [get_ports "CH2_LPDDR5X_wck_t[3]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L5P_XCC_H0O1P2_708
    set_property PACKAGE_PIN BF24     [get_ports "CH2_LPDDR5X_wck_c[3]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L5N_XCC_H0O1P3_708
    set_property PACKAGE_PIN BC26     [get_ports "CH2_LPDDR5X_dq[26]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L6P_H0O1P4_708
    set_property PACKAGE_PIN BD26     [get_ports "CH2_LPDDR5X_dq[27]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L6N_H0O1P5_708
    set_property PACKAGE_PIN BB28     [get_ports "CH2_LPDDR5X_dmi[3]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L7P_H0O1P6_708
    set_property PACKAGE_PIN BC27     [get_ports "CH2_LPDDR5X_reset_n[0]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L7N_H0O1P7_708
    set_property PACKAGE_PIN BA26     [get_ports "CH2_LPDDR5X_dq[20]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L8P_H0O2P0_708
    set_property PACKAGE_PIN BB27     [get_ports "CH2_LPDDR5X_dq[21]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L8N_H0O2P1_708
    set_property PACKAGE_PIN AW30     [get_ports "CH2_LPDDR5X_rdqs_t[2]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L9P_XCC_H0O2P2_708
    set_property PACKAGE_PIN AY30     [get_ports "CH2_LPDDR5X_rdqs_c[2]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L9N_XCC_H0O2P3_708
    set_property PACKAGE_PIN BE27     [get_ports "CH2_LPDDR5X_rdqs_t[3]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L1P_XCC_H0O0P2_708
    set_property PACKAGE_PIN AY29     [get_ports "CH2_LPDDR5X_dq[22]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L10P_H0O2P4_708
    set_property PACKAGE_PIN BA28     [get_ports "CH2_LPDDR5X_dq[23]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L10N_H0O2P5_708
    set_property PACKAGE_PIN AW27     [get_ports "CH2_LPDDR5X_dmi[2]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L11P_H0O2P6_708
    set_property PACKAGE_PIN AY27     [get_ports "CH2_LPDDR5X_ca[0]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L11N_H0O2P7_708
    set_property PACKAGE_PIN AU24     [get_ports "CH2_LPDDR5X_dq[16]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L12P_H0O3P0_708
    set_property PACKAGE_PIN AV25     [get_ports "CH2_LPDDR5X_dq[17]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L12N_H0O3P1_708
    set_property PACKAGE_PIN AY26     [get_ports "CH2_LPDDR5X_wck_t[2]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L13P_XCC_H0O3P2_708
    set_property PACKAGE_PIN BA25     [get_ports "CH2_LPDDR5X_wck_c[2]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L13N_XCC_H0O3P3_708
    set_property PACKAGE_PIN AT28     [get_ports "CH2_LPDDR5X_dq[18]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L14P_H0O3P4_708
    set_property PACKAGE_PIN AU27     [get_ports "CH2_LPDDR5X_dq[19]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L14N_H0O3P5_708
    set_property PACKAGE_PIN BF27     [get_ports "CH2_LPDDR5X_rdqs_c[3]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L1N_XCC_H0O0P3_708
    set_property PACKAGE_PIN AT24     [get_ports "CH2_LPDDR5X_ck_t[0]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L15P_H0O3P6_708
    set_property PACKAGE_PIN AT25     [get_ports "CH2_LPDDR5X_ck_c[0]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L15N_H0O3P7_708
    set_property PACKAGE_PIN BF28     [get_ports "CH2_LPDDR5X_dq[30]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L2P_H0O0P4_708
    set_property PACKAGE_PIN BF29     [get_ports "CH2_LPDDR5X_dq[31]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L2N_H0O0P5_708
    set_property PACKAGE_PIN BD28     [get_ports "CH2_LPDDR5X_cs[0]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L3P_GC_H0O0P6_708
    set_property PACKAGE_PIN BE28     [get_ports "CH2_LPDDR5X_cs[1]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L3N_GC_H0O0P7_708
    set_property PACKAGE_PIN BC29     [get_ports "CH2_LPDDR5X_dq[24]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L4P_H0O1P0_708
    set_property PACKAGE_PIN BD29     [get_ports "CH2_LPDDR5X_dq[25]"] ;# Bank 708 VCCO - VCCO_7XX_LP5 - IO_L4N_H0O1P1_708
    set_property PACKAGE_PIN AT31     [get_ports "CH2_LPDDR5X_dq[0]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L16P_H1O0P0_709
    set_property PACKAGE_PIN AU30     [get_ports "CH2_LPDDR5X_dq[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L16N_H1O0P1_709
    set_property PACKAGE_PIN AT33     [get_ports "CH2_LPDDR5X_wck_t[0]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L17P_XCC_H1O0P2_709
    set_property PACKAGE_PIN AT34     [get_ports "CH2_LPDDR5X_wck_c[0]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L17N_XCC_H1O0P3_709
    set_property PACKAGE_PIN AU33     [get_ports "CH2_LPDDR5X_dq[2]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L18P_H1O0P4_709
    set_property PACKAGE_PIN AV34     [get_ports "CH2_LPDDR5X_dq[3]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L18N_H1O0P5_709
    set_property PACKAGE_PIN BA31     [get_ports "CH2_LPDDR5X_dmi[0]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L19P_GC_H1O0P6_709
    set_property PACKAGE_PIN BA32     [get_ports "CH2_LPDDR5X_ca[6]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L19N_GC_H1O0P7_709
    set_property PACKAGE_PIN AY32     [get_ports "CH2_LPDDR5X_dq[4]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L20P_H1O1P0_709
    set_property PACKAGE_PIN AY33     [get_ports "CH2_LPDDR5X_dq[5]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L20N_H1O1P1_709
    set_property PACKAGE_PIN BC32     [get_ports "CH2_LPDDR5X_rdqs_t[0]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L21P_XCC_H1O1P2_709
    set_property PACKAGE_PIN BD32     [get_ports "CH2_LPDDR5X_rdqs_c[0]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L21N_XCC_H1O1P3_709
    set_property PACKAGE_PIN BA29     [get_ports "CH2_LPDDR5X_dq[6]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L22P_H1O1P4_709
    set_property PACKAGE_PIN BB30     [get_ports "CH2_LPDDR5X_dq[7]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L22N_H1O1P5_709
    set_property PACKAGE_PIN BB31     [get_ports "CH2_LPDDR5X_ca[5]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L23P_H1O1P6_709
    set_property PACKAGE_PIN BC30     [get_ports "CH2_LPDDR5X_ca[4]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L23N_H1O1P7_709
    set_property PACKAGE_PIN BB33     [get_ports "CH2_LPDDR5X_dq[8]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L24P_H1O2P0_709
    set_property PACKAGE_PIN BC33     [get_ports "CH2_LPDDR5X_dq[9]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L24N_H1O2P1_709
    set_property PACKAGE_PIN BE30     [get_ports "CH2_LPDDR5X_wck_t[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L25P_XCC_H1O2P2_709
    set_property PACKAGE_PIN BF30     [get_ports "CH2_LPDDR5X_wck_c[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L25N_XCC_H1O2P3_709
    set_property PACKAGE_PIN BD31     [get_ports "CH2_LPDDR5X_dq[10]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L26P_H1O2P4_709
    set_property PACKAGE_PIN BE31     [get_ports "CH2_LPDDR5X_dq[11]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L26N_H1O2P5_709
    set_property PACKAGE_PIN BF34     [get_ports "CH2_LPDDR5X_dmi[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L27P_H1O2P6_709
    set_property PACKAGE_PIN BF35     [get_ports "CH2_LPDDR5X_ca[3]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L27N_H1O2P7_709
    set_property PACKAGE_PIN BE33     [get_ports "CH2_LPDDR5X_dq[12]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L28P_H1O3P0_709
    set_property PACKAGE_PIN BF33     [get_ports "CH2_LPDDR5X_dq[13]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L28N_H1O3P1_709
    set_property PACKAGE_PIN BD34     [get_ports "CH2_LPDDR5X_rdqs_t[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L29P_XCC_H1O3P2_709
    set_property PACKAGE_PIN BE34     [get_ports "CH2_LPDDR5X_rdqs_c[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L29N_XCC_H1O3P3_709
    set_property PACKAGE_PIN BC35     [get_ports "CH2_LPDDR5X_dq[14]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L30P_H1O3P4_709
    set_property PACKAGE_PIN BD35     [get_ports "CH2_LPDDR5X_dq[15]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L30N_H1O3P5_709
    set_property PACKAGE_PIN BF31     [get_ports "CH2_LPDDR5X_ca[2]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L31P_H1O3P6_709
    set_property PACKAGE_PIN BF32     [get_ports "CH2_LPDDR5X_ca[1]"] ;# Bank 709 VCCO - VCCO_7XX_LP5 - IO_L31N_H1O3P7_709

    set_property PACKAGE_PIN BF44     [get_ports "CH3_LPDDR5X_dq[2]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L0P_H0O0P0_M2P0_710
    set_property PACKAGE_PIN BE45     [get_ports "CH3_LPDDR5X_dq[0]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L0N_H0O0P1_M2P1_710
    set_property PACKAGE_PIN BF43     [get_ports "CH3_LPDDR5X_rdqs_t[0]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L5P_XCC_H0O1P2_M2P10_710
    set_property PACKAGE_PIN BE43     [get_ports "CH3_LPDDR5X_rdqs_c[0]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L5N_XCC_H0O1P3_M2P11_710
    set_property PACKAGE_PIN BD40     [get_ports "CH3_LPDDR5X_dq[7]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L6P_H0O1P4_M2P12_710
    set_property PACKAGE_PIN BD41     [get_ports "CH3_LPDDR5X_dq[6]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L6N_H0O1P5_M2P13_710
    set_property PACKAGE_PIN BF42     [get_ports "CH3_LPDDR5X_ca[5]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L7P_H0O1P6_M2P14_710
    set_property PACKAGE_PIN BE42     [get_ports "CH3_LPDDR5X_ca[4]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L7N_H0O1P7_M2P15_710
    set_property PACKAGE_PIN BF40     [get_ports "CH3_LPDDR5X_dq[14]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L8P_H0O2P0_M2P16_710
    set_property PACKAGE_PIN BF41     [get_ports "CH3_LPDDR5X_dq[9]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L8N_H0O2P1_M2P17_710
    set_property PACKAGE_PIN BE39     [get_ports "CH3_LPDDR5X_wck_t[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L9P_XCC_H0O2P2_M2P18_710
    set_property PACKAGE_PIN BE40     [get_ports "CH3_LPDDR5X_wck_c[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L9N_XCC_H0O2P3_M2P19_710
    set_property PACKAGE_PIN BD44     [get_ports "CH3_LPDDR5X_wck_t[0]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L1P_XCC_H0O0P2_M2P2_710
    set_property PACKAGE_PIN BD37     [get_ports "CH3_LPDDR5X_dq[15]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L10P_H0O2P4_M2P20_710
    set_property PACKAGE_PIN BD38     [get_ports "CH3_LPDDR5X_dq[12]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L10N_H0O2P5_M2P21_710
    set_property PACKAGE_PIN BF38     [get_ports "CH3_LPDDR5X_dmi[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L11P_H0O2P6_M2P22_710
    set_property PACKAGE_PIN BF39     [get_ports "CH3_LPDDR5X_ca[3]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L11N_H0O2P7_M2P23_710
    set_property PACKAGE_PIN BB37     [get_ports "CH3_LPDDR5X_dq[11]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L12P_H0O3P0_M2P24_710
    set_property PACKAGE_PIN BC38     [get_ports "CH3_LPDDR5X_dq[13]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L12N_H0O3P1_M2P25_710
    set_property PACKAGE_PIN BC36     [get_ports "CH3_LPDDR5X_rdqs_t[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L13P_XCC_H0O3P2_M2P26_710
    set_property PACKAGE_PIN BB36     [get_ports "CH3_LPDDR5X_rdqs_c[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L13N_XCC_H0O3P3_M2P27_710
    set_property PACKAGE_PIN BF36     [get_ports "CH3_LPDDR5X_dq[10]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L14P_H0O3P4_M2P28_710
    set_property PACKAGE_PIN BF37     [get_ports "CH3_LPDDR5X_dq[8]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L14N_H0O3P5_M2P29_710
    set_property PACKAGE_PIN BC45     [get_ports "CH3_LPDDR5X_wck_c[0]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L1N_XCC_H0O0P3_M2P3_710
    set_property PACKAGE_PIN BE36     [get_ports "CH3_LPDDR5X_ca[2]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L15P_H0O3P6_M2P30_710
    set_property PACKAGE_PIN BE37     [get_ports "CH3_LPDDR5X_ca[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L15N_H0O3P7_M2P31_710
    set_property PACKAGE_PIN BD46     [get_ports "CH3_LPDDR5X_dq[3]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L2P_H0O0P4_M2P4_710
    set_property PACKAGE_PIN BC46     [get_ports "CH3_LPDDR5X_dq[1]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L2N_H0O0P5_M2P5_710
    set_property PACKAGE_PIN BB45     [get_ports "CH3_LPDDR5X_dmi[0]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L3P_GC_H0O0P6_M2P6_710
    set_property PACKAGE_PIN BB46     [get_ports "CH3_LPDDR5X_ca[6]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L3N_GC_H0O0P7_M2P7_710
    set_property PACKAGE_PIN BD43     [get_ports "CH3_LPDDR5X_dq[5]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L4P_H0O1P0_M2P8_710
    set_property PACKAGE_PIN BC44     [get_ports "CH3_LPDDR5X_dq[4]"] ;# Bank 710 VCCO - VCCO_7XX_LP5 - IO_L4N_H0O1P1_M2P9_710
    set_property PACKAGE_PIN BB34     [get_ports "CH3_LPDDR5X_dq[31]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L16P_H1O0P0_M2P32_711
    set_property PACKAGE_PIN BA34     [get_ports "CH3_LPDDR5X_dq[29]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L16N_H1O0P1_M2P33_711
    set_property PACKAGE_PIN BA35     [get_ports "CH3_LPDDR5X_rdqs_t[3]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L17P_XCC_H1O0P2_M2P34_711
    set_property PACKAGE_PIN AY35     [get_ports "CH3_LPDDR5X_rdqs_c[3]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L17N_XCC_H1O0P3_M2P35_711
    set_property PACKAGE_PIN AY36     [get_ports "CH3_LPDDR5X_dq[28]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L18P_H1O0P4_M2P36_711
    set_property PACKAGE_PIN BA37     [get_ports "CH3_LPDDR5X_dq[30]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L18N_H1O0P5_M2P37_711
    set_property PACKAGE_PIN BA38     [get_ports "CH3_LPDDR5X_cs[0]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L19P_GC_H1O0P6_M2P38_711
    set_property PACKAGE_PIN AY38     [get_ports "CH3_LPDDR5X_cs[1]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L19N_GC_H1O0P7_M2P39_711
    set_property PACKAGE_PIN AY39     [get_ports "CH3_LPDDR5X_dq[24]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L20P_H1O1P0_M2P40_711
    set_property PACKAGE_PIN AW39     [get_ports "CH3_LPDDR5X_dq[25]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L20N_H1O1P1_M2P41_711
    set_property PACKAGE_PIN BC39     [get_ports "CH3_LPDDR5X_wck_t[3]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L21P_XCC_H1O1P2_M2P42_711
    set_property PACKAGE_PIN BB39     [get_ports "CH3_LPDDR5X_wck_c[3]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L21N_XCC_H1O1P3_M2P43_711
    set_property PACKAGE_PIN AW40     [get_ports "CH3_LPDDR5X_dq[26]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L22P_H1O1P4_M2P44_711
    set_property PACKAGE_PIN AY41     [get_ports "CH3_LPDDR5X_dq[27]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L22N_H1O1P5_M2P45_711
    set_property PACKAGE_PIN BB40     [get_ports "CH3_LPDDR5X_dmi[3]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L23P_H1O1P6_M2P46_711
    set_property PACKAGE_PIN BA40     [get_ports "CH3_LPDDR5X_reset_n[0]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L23N_H1O1P7_M2P47_711
    set_property PACKAGE_PIN BB42     [get_ports "CH3_LPDDR5X_dq[20]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L24P_H1O2P0_M2P48_711
    set_property PACKAGE_PIN BA43     [get_ports "CH3_LPDDR5X_dq[21]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L24N_H1O2P1_M2P49_711
    set_property PACKAGE_PIN BA41     [get_ports "CH3_LPDDR5X_rdqs_t[2]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L25P_XCC_H1O2P2_M2P50_711
    set_property PACKAGE_PIN AY42     [get_ports "CH3_LPDDR5X_rdqs_c[2]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L25N_XCC_H1O2P3_M2P51_711
    set_property PACKAGE_PIN AW42     [get_ports "CH3_LPDDR5X_dq[22]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L26P_H1O2P4_M2P52_711
    set_property PACKAGE_PIN AW43     [get_ports "CH3_LPDDR5X_dq[19]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L26N_H1O2P5_M2P53_711
    set_property PACKAGE_PIN AY45     [get_ports "CH3_LPDDR5X_dmi[2]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L27P_H1O2P6_M2P54_711
    set_property PACKAGE_PIN AW46     [get_ports "CH3_LPDDR5X_ca[0]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L27N_H1O2P7_M2P55_711
    set_property PACKAGE_PIN AY44     [get_ports "CH3_LPDDR5X_dq[16]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L28P_H1O3P0_M2P56_711
    set_property PACKAGE_PIN AW45     [get_ports "CH3_LPDDR5X_dq[17]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L28N_H1O3P1_M2P57_711
    set_property PACKAGE_PIN BB43     [get_ports "CH3_LPDDR5X_wck_t[2]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L29P_XCC_H1O3P2_M2P58_711
    set_property PACKAGE_PIN BA44     [get_ports "CH3_LPDDR5X_wck_c[2]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L29N_XCC_H1O3P3_M2P59_711
    set_property PACKAGE_PIN BA46     [get_ports "CH3_LPDDR5X_dq[18]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L30P_H1O3P4_M2P60_711
    set_property PACKAGE_PIN AY46     [get_ports "CH3_LPDDR5X_dq[23]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L30N_H1O3P5_M2P61_711
    set_property PACKAGE_PIN BC41     [get_ports "CH3_LPDDR5X_ck_t[0]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L31P_H1O3P6_M2P62_711
    set_property PACKAGE_PIN BC42     [get_ports "CH3_LPDDR5X_ck_c[0]"] ;# Bank 711 VCCO - VCCO_7XX_LP5 - IO_L31N_H1O3P7_M2P63_711

    set_property PACKAGE_PIN AK45     [get_ports "CH4_LPDDR5X_dq[24]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L0P_H0O0P0_M3P128_714
    set_property PACKAGE_PIN AK46     [get_ports "CH4_LPDDR5X_dq[27]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L0N_H0O0P1_M3P129_714
    set_property PACKAGE_PIN AK42     [get_ports "CH4_LPDDR5X_wck_t[3]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L5P_XCC_H0O1P2_M3P138_714
    set_property PACKAGE_PIN AK43     [get_ports "CH4_LPDDR5X_wck_c[3]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L5N_XCC_H0O1P3_M3P139_714
    set_property PACKAGE_PIN AG42     [get_ports "CH4_LPDDR5X_dq[30]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L6P_H0O1P4_M3P140_714
    set_property PACKAGE_PIN AG43     [get_ports "CH4_LPDDR5X_dq[29]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L6N_H0O1P5_M3P141_714
    set_property PACKAGE_PIN AH41     [get_ports "CH4_LPDDR5X_dmi[3]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L7P_H0O1P6_M3P142_714
    set_property PACKAGE_PIN AH42     [get_ports "CH4_LPDDR5X_reset_n[0]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L7N_H0O1P7_M3P143_714
    set_property PACKAGE_PIN AJ40     [get_ports "CH4_LPDDR5X_dq[21]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L8P_H0O2P0_M3P144_714
    set_property PACKAGE_PIN AJ41     [get_ports "CH4_LPDDR5X_dq[20]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L8N_H0O2P1_M3P145_714
    set_property PACKAGE_PIN AK39     [get_ports "CH4_LPDDR5X_rdqs_t[2]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L9P_XCC_H0O2P2_M3P146_714
    set_property PACKAGE_PIN AK40     [get_ports "CH4_LPDDR5X_rdqs_c[2]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L9N_XCC_H0O2P3_M3P147_714
    set_property PACKAGE_PIN AJ46     [get_ports "CH4_LPDDR5X_rdqs_t[3]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L1P_XCC_H0O0P2_M3P130_714
    set_property PACKAGE_PIN AG39     [get_ports "CH4_LPDDR5X_dq[22]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L10P_H0O2P4_M3P148_714
    set_property PACKAGE_PIN AG40     [get_ports "CH4_LPDDR5X_dq[23]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L10N_H0O2P5_M3P149_714
    set_property PACKAGE_PIN AH38     [get_ports "CH4_LPDDR5X_dmi[2]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L11P_H0O2P6_M3P150_714
    set_property PACKAGE_PIN AH39     [get_ports "CH4_LPDDR5X_ca[0]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L11N_H0O2P7_M3P151_714
    set_property PACKAGE_PIN AJ37     [get_ports "CH4_LPDDR5X_dq[17]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L12P_H0O3P0_M3P152_714
    set_property PACKAGE_PIN AJ38     [get_ports "CH4_LPDDR5X_dq[19]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L12N_H0O3P1_M3P153_714
    set_property PACKAGE_PIN AG37     [get_ports "CH4_LPDDR5X_wck_t[2]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L13P_XCC_H0O3P2_M3P154_714
    set_property PACKAGE_PIN AF37     [get_ports "CH4_LPDDR5X_wck_c[2]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L13N_XCC_H0O3P3_M3P155_714
    set_property PACKAGE_PIN AH36     [get_ports "CH4_LPDDR5X_dq[18]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L14P_H0O3P4_M3P156_714
    set_property PACKAGE_PIN AG36     [get_ports "CH4_LPDDR5X_dq[16]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L14N_H0O3P5_M3P157_714
    set_property PACKAGE_PIN AH46     [get_ports "CH4_LPDDR5X_rdqs_c[3]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L1N_XCC_H0O0P3_M3P131_714
    set_property PACKAGE_PIN AK36     [get_ports "CH4_LPDDR5X_ck_t[0]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L15P_H0O3P6_M3P158_714
    set_property PACKAGE_PIN AK37     [get_ports "CH4_LPDDR5X_ck_c[0]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L15N_H0O3P7_M3P159_714
    set_property PACKAGE_PIN AG45     [get_ports "CH4_LPDDR5X_dq[28]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L2P_H0O0P4_M3P132_714
    set_property PACKAGE_PIN AG46     [get_ports "CH4_LPDDR5X_dq[31]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L2N_H0O0P5_M3P133_714
    set_property PACKAGE_PIN AH44     [get_ports "CH4_LPDDR5X_cs[0]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L3P_GC_H0O0P6_M3P134_714
    set_property PACKAGE_PIN AH45     [get_ports "CH4_LPDDR5X_cs[1]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L3N_GC_H0O0P7_M3P135_714
    set_property PACKAGE_PIN AJ43     [get_ports "CH4_LPDDR5X_dq[25]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L4P_H0O1P0_M3P136_714
    set_property PACKAGE_PIN AJ44     [get_ports "CH4_LPDDR5X_dq[26]"] ;# Bank 714 VCCO - VCCO_7XX_LP5 - IO_L4N_H0O1P1_M3P137_714
    set_property PACKAGE_PIN AE36     [get_ports "CH4_LPDDR5X_dq[7]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L16P_H1O0P0_M3P160_715
    set_property PACKAGE_PIN AD36     [get_ports "CH4_LPDDR5X_dq[6]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L16N_H1O0P1_M3P161_715
    set_property PACKAGE_PIN AD37     [get_ports "CH4_LPDDR5X_wck_t[0]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L17P_XCC_H1O0P2_M3P162_715
    set_property PACKAGE_PIN AC37     [get_ports "CH4_LPDDR5X_wck_c[0]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L17N_XCC_H1O0P3_M3P163_715
    set_property PACKAGE_PIN AF38     [get_ports "CH4_LPDDR5X_dq[2]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L18P_H1O0P4_M3P164_715
    set_property PACKAGE_PIN AE38     [get_ports "CH4_LPDDR5X_dq[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L18N_H1O0P5_M3P165_715
    set_property PACKAGE_PIN AE39     [get_ports "CH4_LPDDR5X_dmi[0]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L19P_GC_H1O0P6_M3P166_715
    set_property PACKAGE_PIN AD39     [get_ports "CH4_LPDDR5X_ca[6]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L19N_GC_H1O0P7_M3P167_715
    set_property PACKAGE_PIN AC38     [get_ports "CH4_LPDDR5X_dq[5]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L20P_H1O1P0_M3P168_715
    set_property PACKAGE_PIN AB38     [get_ports "CH4_LPDDR5X_dq[4]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L20N_H1O1P1_M3P169_715
    set_property PACKAGE_PIN AD40     [get_ports "CH4_LPDDR5X_rdqs_t[0]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L21P_XCC_H1O1P2_M3P170_715
    set_property PACKAGE_PIN AC40     [get_ports "CH4_LPDDR5X_rdqs_c[0]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L21N_XCC_H1O1P3_M3P171_715
    set_property PACKAGE_PIN AF40     [get_ports "CH4_LPDDR5X_dq[3]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L22P_H1O1P4_M3P172_715
    set_property PACKAGE_PIN AF41     [get_ports "CH4_LPDDR5X_dq[0]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L22N_H1O1P5_M3P173_715
    set_property PACKAGE_PIN AE41     [get_ports "CH4_LPDDR5X_ca[5]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L23P_H1O1P6_M3P174_715
    set_property PACKAGE_PIN AE42     [get_ports "CH4_LPDDR5X_ca[4]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L23N_H1O1P7_M3P175_715
    set_property PACKAGE_PIN AC41     [get_ports "CH4_LPDDR5X_dq[10]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L24P_H1O2P0_M3P176_715
    set_property PACKAGE_PIN AB41     [get_ports "CH4_LPDDR5X_dq[8]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L24N_H1O2P1_M3P177_715
    set_property PACKAGE_PIN AF43     [get_ports "CH4_LPDDR5X_wck_t[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L25P_XCC_H1O2P2_M3P178_715
    set_property PACKAGE_PIN AF44     [get_ports "CH4_LPDDR5X_wck_c[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L25N_XCC_H1O2P3_M3P179_715
    set_property PACKAGE_PIN AD42     [get_ports "CH4_LPDDR5X_dq[15]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L26P_H1O2P4_M3P180_715
    set_property PACKAGE_PIN AD43     [get_ports "CH4_LPDDR5X_dq[9]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L26N_H1O2P5_M3P181_715
    set_property PACKAGE_PIN AC43     [get_ports "CH4_LPDDR5X_dmi[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L27P_H1O2P6_M3P182_715
    set_property PACKAGE_PIN AC44     [get_ports "CH4_LPDDR5X_ca[3]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L27N_H1O2P7_M3P183_715
    set_property PACKAGE_PIN AE44     [get_ports "CH4_LPDDR5X_dq[14]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L28P_H1O3P0_M3P184_715
    set_property PACKAGE_PIN AE45     [get_ports "CH4_LPDDR5X_dq[12]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L28N_H1O3P1_M3P185_715
    set_property PACKAGE_PIN AD45     [get_ports "CH4_LPDDR5X_rdqs_t[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L29P_XCC_H1O3P2_M3P186_715
    set_property PACKAGE_PIN AD46     [get_ports "CH4_LPDDR5X_rdqs_c[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L29N_XCC_H1O3P3_M3P187_715
    set_property PACKAGE_PIN AC46     [get_ports "CH4_LPDDR5X_dq[13]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L30P_H1O3P4_M3P188_715
    set_property PACKAGE_PIN AB46     [get_ports "CH4_LPDDR5X_dq[11]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L30N_H1O3P5_M3P189_715
    set_property PACKAGE_PIN AF46     [get_ports "CH4_LPDDR5X_ca[2]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L31P_H1O3P6_M3P190_715
    set_property PACKAGE_PIN AE46     [get_ports "CH4_LPDDR5X_ca[1]"] ;# Bank 715 VCCO - VCCO_7XX_LP5 - IO_L31N_H1O3P7_M3P191_715
