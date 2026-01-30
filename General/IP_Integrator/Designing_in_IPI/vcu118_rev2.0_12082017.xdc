############################################################################
### VCU118 Rev2.0 XDC 12/08/2017
############################################################################
#Other net   PACKAGE_PIN AE17     - DXN                       Bank   0 - DXN
#Other net   PACKAGE_PIN AE18     - DXP                       Bank   0 - DXP
#Other net   PACKAGE_PIN AD18     - GND                       Bank   0 - VREFP
#Other net   PACKAGE_PIN AC17     - GND                       Bank   0 - VREFN
#Other net   PACKAGE_PIN AC18     - SYSMON_VP                 Bank   0 - VP
#Other net   PACKAGE_PIN AD17     - SYSMON_VN                 Bank   0 - VN
#Other net   PACKAGE_PIN U10      - FPGA_M0                   Bank   0 - M0_0
#Other net   PACKAGE_PIN Y11      - FPGA_M1                   Bank   0 - M1_0
#Other net   PACKAGE_PIN AC12     - FPGA_INIT_B               Bank   0 - INIT_B_0
#Other net   PACKAGE_PIN W11      - FPGA_M2                   Bank   0 - M2_0
#Other net   PACKAGE_PIN AB11     - GND                       Bank   0 - RSVDGND
#Other net   PACKAGE_PIN AD12     - PUDC_B_PIN                Bank   0 - PUDC_B_0
#Other net   PACKAGE_PIN AG12     - POR_OVERRIDE_PIN          Bank   0 - POR_OVERRIDE
#Other net   PACKAGE_PIN AE12     - FPGA_DONE                 Bank   0 - DONE_0
#Other net   PACKAGE_PIN AH11     - FPGA_PROG_B               Bank   0 - PROGRAM_B_0
#Other net   PACKAGE_PIN AD13     - FPGA_TDO_FMC_TDI          Bank   0 - TDO_0
#Other net   PACKAGE_PIN AD15     - JTAG_TDI                  Bank   0 - TDI_0
#Other net   PACKAGE_PIN AJ11     - QSPI0_CS_B                Bank   0 - RDWR_FCS_B_0
#Other net   PACKAGE_PIN AM11     - QSPI0_DQ2                 Bank   0 - D02_0
#Other net   PACKAGE_PIN AP11     - QSPI0_DQ0                 Bank   0 - D00_MOSI_0
#Other net   PACKAGE_PIN AL11     - QSPI0_DQ3                 Bank   0 - D03_0
#Other net   PACKAGE_PIN AN11     - QSPI0_DQ1                 Bank   0 - D01_DIN_0
#Other net   PACKAGE_PIN AF15     - JTAG_TMS                  Bank   0 - TMS_0
#Other net   PACKAGE_PIN AF13     - QSPI_CCLK                 Bank   0 - CCLK_0
#Other net   PACKAGE_PIN AE13     - JTAG_TCK                  Bank   0 - TCK_0
#Other net   PACKAGE_PIN AT11     - FPGA_VBATT                Bank   0 - VBATT
#set_property PACKAGE_PIN A25      [get_ports ""] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T3U_N12_48
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T3U_N12_48
#set_property PACKAGE_PIN H25      [get_ports ""] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T2U_N12_48
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T2U_N12_48
#set_property PACKAGE_PIN J25      [get_ports ""] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T1U_N12_48
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T1U_N12_48
#set_property PACKAGE_PIN M26      [get_ports "VRP_48"] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_48
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_48"] ;# Bank  48 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_48
#Other net   PACKAGE_PIN T25      -                  Bank  48 - VREF_48
#set_property PACKAGE_PIN T29      [get_ports "VRP_47"] ;# Bank  47 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_47
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_47"] ;# Bank  47 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_47
#Other net   PACKAGE_PIN T28      - 43N2999                   Bank  47 - VREF_47
#set_property PACKAGE_PIN D36      [get_ports ""] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T3U_N12_46
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T3U_N12_46
#set_property PACKAGE_PIN C38      [get_ports ""] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T2U_N12_46
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T2U_N12_46
#set_property PACKAGE_PIN E36      [get_ports ""] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T1U_N12_46
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T1U_N12_46
#set_property PACKAGE_PIN K38      [get_ports "VRP_46"] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_46
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_46"] ;# Bank  46 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_46
#Other net   PACKAGE_PIN J34      -                  Bank  46 - VREF_46
#set_property PACKAGE_PIN K36      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T3U_N12_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T3U_N12_45
#set_property PACKAGE_PIN R36      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T2U_N12_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T2U_N12_45
#set_property PACKAGE_PIN L38      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L15N_T2L_N5_AD11N_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L15N_T2L_N5_AD11N_45
#set_property PACKAGE_PIN M37      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L15P_T2L_N4_AD11P_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L15P_T2L_N4_AD11P_45
#set_property PACKAGE_PIN R33      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L12N_T1U_N11_GC_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L12N_T1U_N11_GC_45
#set_property PACKAGE_PIN T33      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L12P_T1U_N10_GC_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L12P_T1U_N10_GC_45
#set_property PACKAGE_PIN W31      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L9N_T1L_N5_AD12N_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L9N_T1L_N5_AD12N_45
#set_property PACKAGE_PIN Y31      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L9P_T1L_N4_AD12P_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L9P_T1L_N4_AD12P_45
#set_property PACKAGE_PIN U32      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L8N_T1L_N3_AD5N_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L8N_T1L_N3_AD5N_45
#set_property PACKAGE_PIN U31      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L8P_T1L_N2_AD5P_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L8P_T1L_N2_AD5P_45
#set_property PACKAGE_PIN T31      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_45
#set_property PACKAGE_PIN T30      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_45
#set_property PACKAGE_PIN V30      [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T1U_N12_45
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T1U_N12_45
#set_property PACKAGE_PIN Y33      [get_ports "VRP_45"] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_45
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_45"] ;# Bank  45 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_45
#Other net   PACKAGE_PIN U30      - VREF_45                   Bank  45 - VREF_45
#set_property PACKAGE_PIN AM16     [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T3U_N12_67
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T3U_N12_67
#set_property PACKAGE_PIN AR15     [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T2U_N12_67
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T2U_N12_67
#set_property PACKAGE_PIN AN13     [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L15N_T2L_N5_AD11N_67
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L15N_T2L_N5_AD11N_67
#set_property PACKAGE_PIN AN14     [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L15P_T2L_N4_AD11P_67
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L15P_T2L_N4_AD11P_67
#set_property PACKAGE_PIN AU13     [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L11N_T1U_N9_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L11N_T1U_N9_GC_67
#set_property PACKAGE_PIN AU14     [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L11P_T1U_N8_GC_67
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L11P_T1U_N8_GC_67
#set_property PACKAGE_PIN BA12     [get_ports "VRP_67"] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_67
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_67"] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_67
#Other net   PACKAGE_PIN AL16     - VREF_67                   Bank  67 - VREF_67
#set_property PACKAGE_PIN BB8      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L14N_T2L_N3_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L14N_T2L_N3_GC_66
#set_property PACKAGE_PIN BB9      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L14P_T2L_N2_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L14P_T2L_N2_GC_66
#set_property PACKAGE_PIN BD10     [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L11N_T1U_N9_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L11N_T1U_N9_GC_66
#set_property PACKAGE_PIN BC10     [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L11P_T1U_N8_GC_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L11P_T1U_N8_GC_66
#set_property PACKAGE_PIN BE9      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L9N_T1L_N5_AD12N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L9N_T1L_N5_AD12N_66
#set_property PACKAGE_PIN BE10     [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L9P_T1L_N4_AD12P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L9P_T1L_N4_AD12P_66
#set_property PACKAGE_PIN BE7      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L8N_T1L_N3_AD5N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L8N_T1L_N3_AD5N_66
#set_property PACKAGE_PIN BE8      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L8P_T1L_N2_AD5P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L8P_T1L_N2_AD5P_66
#set_property PACKAGE_PIN BD7      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_66
#set_property PACKAGE_PIN BD8      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_66
#set_property PACKAGE_PIN BF7      [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_T1U_N12_66
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_T1U_N12_66
#set_property PACKAGE_PIN BD16     [get_ports "VRP_66"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_66
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_66"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_66
#Other net   PACKAGE_PIN BA11     - VREF_66                   Bank  66 - VREF_66
#set_property PACKAGE_PIN AL19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L24N_T3U_N11_DOUT_CSO_B_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L24N_T3U_N11_DOUT_CSO_B_65
#set_property PACKAGE_PIN AN18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L20N_T3L_N3_AD1N_D09_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L20N_T3L_N3_AD1N_D09_65
#set_property PACKAGE_PIN AN19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L20P_T3L_N2_AD1P_D08_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L20P_T3L_N2_AD1P_D08_65
#set_property PACKAGE_PIN AR17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L19N_T3L_N1_DBC_AD9N_D11_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L19N_T3L_N1_DBC_AD9N_D11_65
#set_property PACKAGE_PIN AR18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L19P_T3L_N0_DBC_AD9P_D10_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L19P_T3L_N0_DBC_AD9P_D10_65
#set_property PACKAGE_PIN AW17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_T2U_N12_CSI_ADV_B_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_T2U_N12_CSI_ADV_B_65
#set_property PACKAGE_PIN AT19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L18N_T2U_N11_AD2N_D13_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L18N_T2U_N11_AD2N_D13_65
#set_property PACKAGE_PIN AT20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L18P_T2U_N10_AD2P_D12_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L18P_T2U_N10_AD2P_D12_65
#set_property PACKAGE_PIN AU17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L17N_T2U_N9_AD10N_D15_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L17N_T2U_N9_AD10N_D15_65
#set_property PACKAGE_PIN AT17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L17P_T2U_N8_AD10P_D14_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L17P_T2U_N8_AD10P_D14_65
#set_property PACKAGE_PIN AR19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L16N_T2U_N7_QBC_AD3N_A01_D17_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L16N_T2U_N7_QBC_AD3N_A01_D17_65
#set_property PACKAGE_PIN AR20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65
#set_property PACKAGE_PIN AW20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L15N_T2L_N5_AD11N_A03_D19_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L15N_T2L_N5_AD11N_A03_D19_65
#set_property PACKAGE_PIN AV20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L15P_T2L_N4_AD11P_A02_D18_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L15P_T2L_N4_AD11P_A02_D18_65
#set_property PACKAGE_PIN AU18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L14N_T2L_N3_GC_A05_D21_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L14N_T2L_N3_GC_A05_D21_65
#set_property PACKAGE_PIN AU19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L14P_T2L_N2_GC_A04_D20_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L14P_T2L_N2_GC_A04_D20_65
#set_property PACKAGE_PIN AV18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L13N_T2L_N1_GC_QBC_A07_D23_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L13N_T2L_N1_GC_QBC_A07_D23_65
#set_property PACKAGE_PIN AV19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L13P_T2L_N0_GC_QBC_A06_D22_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L13P_T2L_N0_GC_QBC_A06_D22_65
#set_property PACKAGE_PIN AY18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L12N_T1U_N11_GC_A09_D25_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L12N_T1U_N11_GC_A09_D25_65
#set_property PACKAGE_PIN AW18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L12P_T1U_N10_GC_A08_D24_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L12P_T1U_N10_GC_A08_D24_65
#set_property PACKAGE_PIN BA19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L11N_T1U_N9_GC_A11_D27_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L11N_T1U_N9_GC_A11_D27_65
#set_property PACKAGE_PIN AY19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L11P_T1U_N8_GC_A10_D26_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L11P_T1U_N8_GC_A10_D26_65
#set_property PACKAGE_PIN BB17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10N_T1U_N7_QBC_AD4N_A13_D29_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10N_T1U_N7_QBC_AD4N_A13_D29_65
#set_property PACKAGE_PIN BA17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10P_T1U_N6_QBC_AD4P_A12_D28_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L10P_T1U_N6_QBC_AD4P_A12_D28_65
#set_property PACKAGE_PIN BC19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9N_T1L_N5_AD12N_A15_D31_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9N_T1L_N5_AD12N_A15_D31_65
#set_property PACKAGE_PIN BB19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9P_T1L_N4_AD12P_A14_D30_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L9P_T1L_N4_AD12P_A14_D30_65
#set_property PACKAGE_PIN BC18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8N_T1L_N3_AD5N_A17_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8N_T1L_N3_AD5N_A17_65
#set_property PACKAGE_PIN BB18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8P_T1L_N2_AD5P_A16_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L8P_T1L_N2_AD5P_A16_65
#set_property PACKAGE_PIN BA20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_A19_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7N_T1L_N1_QBC_AD13N_A19_65
#set_property PACKAGE_PIN AY20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_A18_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L7P_T1L_N0_QBC_AD13P_A18_65
#set_property PACKAGE_PIN AY17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_T1U_N12_SMBALERT_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_T1U_N12_SMBALERT_65
#set_property PACKAGE_PIN BF21     [get_ports "VRP_65"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_T0U_N12_VRP_A28_65
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_65"] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_T0U_N12_VRP_A28_65
#set_property PACKAGE_PIN BD17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L6N_T0U_N11_AD6N_A21_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L6N_T0U_N11_AD6N_A21_65
#set_property PACKAGE_PIN BD18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L6P_T0U_N10_AD6P_A20_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L6P_T0U_N10_AD6P_A20_65
#set_property PACKAGE_PIN BD20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L5N_T0U_N9_AD14N_A23_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L5N_T0U_N9_AD14N_A23_65
#set_property PACKAGE_PIN BC20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L5P_T0U_N8_AD14P_A22_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L5P_T0U_N8_AD14P_A22_65
#set_property PACKAGE_PIN BE17     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L4N_T0U_N7_DBC_AD7N_A25_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L4N_T0U_N7_DBC_AD7N_A25_65
#set_property PACKAGE_PIN BE18     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L4P_T0U_N6_DBC_AD7P_A24_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L4P_T0U_N6_DBC_AD7P_A24_65
#set_property PACKAGE_PIN BF19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L3N_T0L_N5_AD15N_A27_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L3N_T0L_N5_AD15N_A27_65
#set_property PACKAGE_PIN BE19     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L3P_T0L_N4_AD15P_A26_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L3P_T0L_N4_AD15P_A26_65
#set_property PACKAGE_PIN BF20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L1N_T0L_N1_DBC_RS1_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L1N_T0L_N1_DBC_RS1_65
#set_property PACKAGE_PIN BE20     [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L1P_T0L_N0_DBC_RS0_65
#set_property IOSTANDARD  LVCMOSxx [get_ports ""] ;# Bank  65 VCCO - VCC1V8_FPGA - IO_L1P_T0L_N0_DBC_RS0_65
#Other net   PACKAGE_PIN AL17     - 8N8196                    Bank  65 - VREF_65
#set_property PACKAGE_PIN BC24     [get_ports "PCIE_WAKE_B_LS"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_T0U_N12_VRP_64
#set_property IOSTANDARD  LVCMOS18 [get_ports "PCIE_WAKE_B_LS"] ;# Bank  64 VCCO - VCC1V8_FPGA - IO_T0U_N12_VRP_64
#Other net   PACKAGE_PIN AL22     - 30N4994                   Bank  64 - VREF_64
#set_property PACKAGE_PIN AR34     [get_ports "VRP_43"] ;# Bank  43 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_43
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_43"] ;# Bank  43 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_43
#Other net   PACKAGE_PIN AJ29     - VREF_43                   Bank  43 - VREF_43
#set_property PACKAGE_PIN BB34     [get_ports "VRP_42"] ;# Bank  42 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_42
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_42"] ;# Bank  42 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_42
#Other net   PACKAGE_PIN AU36     - 5N11683                   Bank  42 - VREF_42
#set_property PACKAGE_PIN BC29     [get_ports "VRP_41"] ;# Bank  41 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_41
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_41"] ;# Bank  41 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_41
#Other net   PACKAGE_PIN AL26     - 6N5608                    Bank  41 - VREF_41
#set_property PACKAGE_PIN BC30     [get_ports "VRP_40"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_40
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_40"] ;# Bank  40 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_40
#Other net   PACKAGE_PIN AN29     - 5N11680                   Bank  40 - VREF_40
#set_property PACKAGE_PIN T18      [get_ports "VRP_73"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_73
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_73"] ;# Bank  73 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_73
#Other net   PACKAGE_PIN T19      - 5329N4282                 Bank  73 - VREF_73
#set_property PACKAGE_PIN T21      [get_ports "VRP_72"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_72
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_72"] ;# Bank  72 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_72
#Other net   PACKAGE_PIN T20      - 5329N4288                 Bank  72 - VREF_72
#set_property PACKAGE_PIN D8       [get_ports "VRP_71"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_71
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_71"] ;# Bank  71 VCCO - VCC1V2_FPGA - IO_T0U_N12_VRP_71
#Other net   PACKAGE_PIN J15      - 7N8237                    Bank  71 - VREF_71
#set_property PACKAGE_PIN W15      [get_ports "VRP_70"] ;# Bank  70 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_70
#set_property IOSTANDARD  LVCMOSxx [get_ports "VRP_70"] ;# Bank  70 VCCO - VADJ_1V8_FPGA - IO_T0U_N12_VRP_70
#Other net   PACKAGE_PIN AB13     - VREF_70                   Bank  70 - VREF_70
#Other net   PACKAGE_PIN BF42     - MGTAVTT_FPGA              Bank 121 - MGTAVTTRCAL_LS
#Other net   PACKAGE_PIN L40      - MGTAVTT_FPGA              Bank 126 - MGTAVTTRCAL_LN
#Other net   PACKAGE_PIN BD3      - MGTAVTT_FPGA              Bank 226 - MGTAVTTRCAL_RS
#Other net   PACKAGE_PIN A5       - MGTAVTT_FPGA              Bank 231 - MGTAVTTRCAL_RN

# Clock Constraints


set_property PACKAGE_PIN B16 [get_ports {DEBUG_0_reg_en[0]}]
set_property PACKAGE_PIN B15 [get_ports {DEBUG_0_reg_en[1]}]
set_property PACKAGE_PIN C15 [get_ports {DEBUG_0_reg_en[2]}]
set_property PACKAGE_PIN C14 [get_ports {DEBUG_0_reg_en[3]}]
set_property PACKAGE_PIN A14 [get_ports {DEBUG_0_reg_en[4]}]
set_property PACKAGE_PIN A13 [get_ports {DEBUG_0_reg_en[5]}]
set_property PACKAGE_PIN A16 [get_ports {DEBUG_0_reg_en[6]}]
set_property PACKAGE_PIN A15 [get_ports {DEBUG_0_reg_en[7]}]
set_property PACKAGE_PIN C12 [get_ports DEBUG_0_capture]
set_property PACKAGE_PIN C10 [get_ports DEBUG_0_clk]
set_property PACKAGE_PIN B12 [get_ports DEBUG_0_rst]
set_property PACKAGE_PIN C13 [get_ports DEBUG_0_shift]
set_property PACKAGE_PIN B13 [get_ports DEBUG_0_tdi]
set_property PACKAGE_PIN G15 [get_ports DEBUG_0_tdo]
set_property PACKAGE_PIN H15 [get_ports DEBUG_0_update]
set_property PACKAGE_PIN H14 [get_ports mb_debug_sys_rst_0]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {DEBUG_0_reg_en[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_capture]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_clk]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_rst]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_shift]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_tdi]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_tdo]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_update]
set_property IOSTANDARD LVCMOS18 [get_ports mb_debug_sys_rst_0]
set_property IOSTANDARD LVCMOS18 [get_ports DEBUG_0_disable]
