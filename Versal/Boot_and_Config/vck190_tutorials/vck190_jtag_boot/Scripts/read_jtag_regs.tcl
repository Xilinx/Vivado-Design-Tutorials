# © Copyright 2019 – 2022 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


################################################################################
# Reads Versal device JTAG registers and captures in file "register_reads.txt".
# IDCODE, EXTENDED_IDCODE, DNA, JTAG_STATUS, ERROR_STATUS, and USERCODE
################################################################################

#Start Read of Versal JTAG Registers

set number 0
puts "Number of lines: $number"
set outfile [open "register_reads.txt" w]

puts $outfile "Versal JTAG Registers Read:"; puts $outfile \n

#Read IDCODE Register
set IDCODE [get_property IDCODE_HEX [lindex [get_hw_devices] 1]]
puts $outfile "IDCODE[31:0]: $IDCODE"; puts $outfile \n

#Read EXTENDED_IDCODE Register
set EXTENDED_IDCODE [get_property REGISTER.EXTENDED_IDCODE [lindex [get_hw_devices] 1]]
puts $outfile "EXTENDED_IDCODE[31:0]: $EXTENDED_IDCODE"
set EXTENDED_IDCODE_BIT13_00_RESERVED [get_property REGISTER.EXTENDED_IDCODE.BIT[13:00]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[13:00]_RESERVED: $EXTENDED_IDCODE_BIT13_00_RESERVED"
set EXTENDED_IDCODE_BIT_27_14_EXTENDED_FAMILY_CODE [get_property REGISTER.EXTENDED_IDCODE.BIT[27:14]_EXTENDED_FAMILY_CODE [lindex [get_hw_devices] 1]]
puts $outfile "BIT[27:14]_EXTENDED_FAMILY_CODE: $EXTENDED_IDCODE_BIT_27_14_EXTENDED_FAMILY_CODE"
set EXTENDED_IDCODE_BIT29_28_CRYPTO_DISABLE [get_property REGISTER.EXTENDED_IDCODE.BIT[29:28]_CRYPTO_DISABLE [lindex [get_hw_devices] 1]]
puts $outfile "BIT[29:28]_CRYPTO_DISABLE: $EXTENDED_IDCODE_BIT29_28_CRYPTO_DISABLE"
set EXTENDED_IDCODE_BIT31_30_RESERVED [get_property REGISTER.EXTENDED_IDCODE.BIT[31:30]_RESERVED [lindex [get_hw_devices] 1]]\n
puts $outfile "BIT[31:30]_RESERVED: $EXTENDED_IDCODE_BIT31_30_RESERVED"; puts $outfile \n


#Read DNA Register
set DNA [get_property REGISTER.DNA [lindex [get_hw_devices] 1]]
puts $outfile "DNA[127:0]: $DNA"
set DNA_0 [get_property REGISTER.DNA.DNA_0 [lindex [get_hw_devices] 1]]
puts $outfile "DNA_0: $DNA_0"
set DNA_1 [get_property REGISTER.DNA.DNA_1 [lindex [get_hw_devices] 1]]
puts $outfile "DNA_1: $DNA_1"
set DNA_2 [get_property REGISTER.DNA.DNA_2 [lindex [get_hw_devices] 1]]
puts $outfile "DNA_2: $DNA_2"
set DNA_3 [get_property REGISTER.DNA.DNA_3 [lindex [get_hw_devices] 1]]\n
puts $outfile "DNA_3: $DNA_3"; puts $outfile \n


#Read JTAG_STATUS Register

set JTAG_STATUS [get_property REGISTER.JTAG_STATUS [lindex [get_hw_devices] 1]]
puts $outfile "JTAG_STATUS[35:0]: $JTAG_STATUS"
set BIT00_RSVD_READS_1 [get_property REGISTER.JTAG_STATUS.BIT[00]_RSVD_READS_1 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[00]_RSVD_READS_1: $BIT00_RSVD_READS_1"
set BIT01_RSVD_READS_0 [get_property REGISTER.JTAG_STATUS.BIT[01]_RSVD_READS_0 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[01]_RSVD_READS_0: $BIT01_RSVD_READS_0"
set BIT02_SBI_JTAG_BUSY [get_property REGISTER.JTAG_STATUS.BIT[02]_SBI_JTAG_BUSY [lindex [get_hw_devices] 1]]
puts $outfile "BIT[02]_SBI_JTAG_BUSY: $BIT02_SBI_JTAG_BUSY"
set BIT03_SBI_JTAG_ENABLED [get_property REGISTER.JTAG_STATUS.BIT[03]_SBI_JTAG_ENABLED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[03]_SBI_JTAG_ENABLED: $BIT03_SBI_JTAG_ENABLED"
set BIT05_04_SELECTMAP_BUS_WIDTH [get_property REGISTER.JTAG_STATUS.BIT[05:04]_SELECTMAP_BUS_WIDTH [lindex [get_hw_devices] 1]]
puts $outfile "BIT[05:04]_SELECTMAP_BUS_WIDTH: $BIT05_04_SELECTMAP_BUS_WIDTH"
set BIT06_BBRAM_KEY_ZEROIZED [get_property REGISTER.JTAG_STATUS.BIT[06]_BBRAM_KEY_ZEROIZED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[06]_BBRAM_KEY_ZEROIZED: $BIT06_BBRAM_KEY_ZEROIZED"
set BIT07_AES_KEY_ZEROIZED [get_property REGISTER.JTAG_STATUS.BIT[07]_AES_KEY_ZEROIZED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[07]_AES_KEY_ZEROIZED: $BIT07_AES_KEY_ZEROIZED"
set BIT08_VCC_SOC_DETECTED [get_property REGISTER.JTAG_STATUS.BIT[08]_VCC_SOC_DETECTED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[08]_VCC_SOC_DETECTED: $BIT08_VCC_SOC_DETECTED"
set BIT09_VCCINT_DETECTED [get_property REGISTER.JTAG_STATUS.BIT[09]_VCCINT_DETECTED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[09]_VCCINT_DETECTED: $BIT09_VCCINT_DETECTED"
set BIT10_VCC_PSLP_DETECTED [get_property REGISTER.JTAG_STATUS.BIT[10]_VCC_PSLP_DETECTED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[10]_VCC_PSLP_DETECTED: $BIT10_VCC_PSLP_DETECTED"
set BIT11_VCC_PMC_DETECTED [get_property REGISTER.JTAG_STATUS.BIT[11]_VCC_PMC_DETECTED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[11]_VCC_PMC_DETECTED: $BIT11_VCC_PMC_DETECTED"
set BIT15_12_BOOT_MODE [get_property REGISTER.JTAG_STATUS.BIT[15:12]_BOOT_MODE [lindex [get_hw_devices] 1]]
puts $outfile "BIT[15:12]_BOOT_MODE: $BIT15_12_BOOT_MODE"
set BIT16_RESERVED [get_property REGISTER.JTAG_STATUS.BIT[16]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[16]_RESERVED: $BIT16_RESERVED"
set BIT19_17_RESERVED [get_property REGISTER.JTAG_STATUS.BIT[19:17]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[19:17]_RESERVED: $BIT19_17_RESERVED"
set BIT20_PMC_SCAN_CLEAR_PASS [get_property REGISTER.JTAG_STATUS.BIT[20]_PMC_SCAN_CLEAR_PASS [lindex [get_hw_devices] 1]]
puts $outfile "BIT[20]_PMC_SCAN_CLEAR_PASS: $BIT20_PMC_SCAN_CLEAR_PASS"
set BIT21_PMC_SCAN_CLEAR_DONE [get_property REGISTER.JTAG_STATUS.BIT[21]_PMC_SCAN_CLEAR_DONE [lindex [get_hw_devices] 1]]
puts $outfile "BIT[21]_PMC_SCAN_CLEAR_DONE: $BIT21_PMC_SCAN_CLEAR_DONE"
set BIT22_RESERVED [get_property REGISTER.JTAG_STATUS.BIT[22]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[22]_RESERVED: $BIT22_RESERVED"
set BIT23_JTAG_SEC_GATE [get_property REGISTER.JTAG_STATUS.BIT[23]_JTAG_SEC_GATE [lindex [get_hw_devices] 1]]
puts $outfile "BIT[23]_JTAG_SEC_GATE: $BIT23_JTAG_SEC_GATE"
set BIT27_24_RESERVED [get_property REGISTER.JTAG_STATUS.BIT[27:24]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[27:24]_RESERVED: $BIT27_24_RESERVED"
set BIT31_28_PMC_VERSION [get_property REGISTER.JTAG_STATUS.BIT[31:28]_PMC_VERSION [lindex [get_hw_devices] 1]]
puts $outfile "BIT[31:28]_PMC_VERSION: $BIT31_28_PMC_VERSION"
set BIT32_JCONFIG_ERROR [get_property REGISTER.JTAG_STATUS.BIT[32]_JCONFIG_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[32]_JCONFIG_ERROR: $BIT32_JCONFIG_ERROR"
set BIT33_JRDBK_ERROR [get_property REGISTER.JTAG_STATUS.BIT[33]_JRDBK_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[33]_JRDBK_ERROR: $BIT33_JRDBK_ERROR"
set BIT34_DONE [get_property REGISTER.JTAG_STATUS.BIT[34]_DONE [lindex [get_hw_devices] 1]]
puts $outfile "BIT[34]_DONE: $BIT34_DONE"
set BIT35_RESERVED [get_property REGISTER.JTAG_STATUS.BIT[35]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[35]_RESERVED: $BIT35_RESERVED"; puts $outfile \n

#Read ERROR_STATUS Register
set ERROR_STATUS [get_property REGISTER.ERROR_STATUS [lindex [get_hw_devices] 1]]
puts $outfile "ERROR_STATUS[159:0]:$ERROR_STATUS"
set BIT000_SSIT_ERROR2 [get_property REGISTER.ERROR_STATUS.BIT[000]_SSIT_ERROR2 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[000]_SSIT_ERROR2: $BIT000_SSIT_ERROR2"
set BIT000_SSIT_ERROR1 [get_property REGISTER.ERROR_STATUS.BIT[001]_SSIT_ERROR1 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[000]_SSIT_ERROR1: $BIT000_SSIT_ERROR1"
set BIT002_SSIT_ERROR [get_property REGISTER.ERROR_STATUS.BIT[002]_SSIT_ERROR0 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[002]_SSIT_ERROR0: $BIT002_SSIT_ERROR"
set BIT003_PMC_XPPU_ERROR [get_property REGISTER.ERROR_STATUS.BIT[003]_PMC_XPPU_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[003]_PMC_XPPU_ERROR: $BIT003_PMC_XPPU_ERROR"
set BIT004_PMC_XMPU_ERROR [get_property REGISTER.ERROR_STATUS.BIT[004]_PMC_XMPU_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[004]_PMC_XMPU_ERROR: $BIT004_PMC_XMPU_ERROR"
set BIT005_PMC_TIMEOUT_ERROR [get_property REGISTER.ERROR_STATUS.BIT[005]_PMC_TIMEOUT_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[005]_PMC_TIMEOUT_ERROR: $BIT005_PMC_TIMEOUT_ERROR"
set BIT006_CLOCK_MONITOR_ERROR [get_property REGISTER.ERROR_STATUS.BIT[006]_CLOCK_MONITOR_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[006]_CLOCK_MONITOR_ERROR: $BIT006_CLOCK_MONITOR_ERROR"
set BIT007_PPLL_ERROR [get_property REGISTER.ERROR_STATUS.BIT[007]_PPLL_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[007]_PPLL_ERROR: $BIT007_PPLL_ERROR"
set BIT008_NPLL_ERROR [get_property REGISTER.ERROR_STATUS.BIT[008]_NPLL_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[008]_NPLL_ERROR: $BIT008_NPLL_ERROR"
set BIT009_RTC_ALARM [get_property REGISTER.ERROR_STATUS.BIT[009]_RTC_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[009]_RTC_ALARM: $BIT009_RTC_ALARM"
set BIT011_010_RSVD_READS_0 [get_property REGISTER.ERROR_STATUS.BIT[011:010]_RSVD_READS_0 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[011:010]_RSVD_READS_0: $BIT011_010_RSVD_READS_0"
set BIT012_SEU_ECC_ERROR [get_property REGISTER.ERROR_STATUS.BIT[012]_SEU_ECC_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[012]_SEU_ECC_ERROR: $BIT012_SEU_ECC_ERROR"
set BIT013_SEU_CRC_ERROR [get_property REGISTER.ERROR_STATUS.BIT[013]_SEU_CRC_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[013]_SEU_CRC_ERROR: $BIT013_SEU_CRC_ERROR"
set BIT014_CFI_NCR [get_property REGISTER.ERROR_STATUS.BIT[014]_CFI_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[014]_CFI_NCR: $BIT014_CFI_NCR"
set BIT015_PMC_SYSMON9_ALARM [get_property REGISTER.ERROR_STATUS.BIT[015]_PMC_SYSMON9_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[015]_PMC_SYSMON9_ALARM: $BIT015_PMC_SYSMON9_ALARM"
set BIT016_PMC_SYSMON8_ALARM [get_property REGISTER.ERROR_STATUS.BIT[016]_PMC_SYSMON8_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[016]_PMC_SYSMON8_ALARM: $BIT016_PMC_SYSMON8_ALARM"
set BIT017_PMC_SYSMON7_ALARM [get_property REGISTER.ERROR_STATUS.BIT[017]_PMC_SYSMON7_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[017]_PMC_SYSMON7_ALARM: $BIT017_PMC_SYSMON7_ALARM"
set BIT018_PMC_SYSMON6_ALARM [get_property REGISTER.ERROR_STATUS.BIT[018]_PMC_SYSMON6_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[018]_PMC_SYSMON6_ALARM: $BIT018_PMC_SYSMON6_ALARM"
set BIT019_PMC_SYSMON5_ALARM [get_property REGISTER.ERROR_STATUS.BIT[019]_PMC_SYSMON5_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[019]_PMC_SYSMON5_ALARM: $BIT019_PMC_SYSMON5_ALARM"
set BIT020_PMC_SYSMON4_ALARM [get_property REGISTER.ERROR_STATUS.BIT[020]_PMC_SYSMON4_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[020]_PMC_SYSMON4_ALARM: $BIT020_PMC_SYSMON4_ALARM"
set BIT021_PMC_SYSMON3_ALARM [get_property REGISTER.ERROR_STATUS.BIT[021]_PMC_SYSMON3_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[021]_PMC_SYSMON3_ALARM: $BIT021_PMC_SYSMON3_ALARM"
set BIT022_PMC_SYSMON2_ALARM [get_property REGISTER.ERROR_STATUS.BIT[022]_PMC_SYSMON2_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[022]_PMC_SYSMON2_ALARM: $BIT022_PMC_SYSMON2_ALARM"
set BIT023_PMC_SYSMON1_ALARM [get_property REGISTER.ERROR_STATUS.BIT[023]_PMC_SYSMON1_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[023]_PMC_SYSMON1_ALARM: $BIT023_PMC_SYSMON1_ALARM"
set BIT024_PMC_SYSMON0_ALARM [get_property REGISTER.ERROR_STATUS.BIT[024]_PMC_SYSMON0_ALARM [lindex [get_hw_devices] 1]]
puts $outfile "BIT[024]_PMC_SYSMON0_ALARM: $BIT024_PMC_SYSMON0_ALARM"
set BIT025_PMC_NCR [get_property REGISTER.ERROR_STATUS.BIT[025]_PMC_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[025]_PMC_NCR: $BIT025_PMC_NCR"
set BIT026_PMC_CR [get_property REGISTER.ERROR_STATUS.BIT[026]_PMC_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[026]_PMC_CR: $BIT026_PMC_CR"
set BIT027_PMC_PAR_ERROR [get_property REGISTER.ERROR_STATUS.BIT[027]_PMC_PAR_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[027]_PMC_PAR_ERROR: $BIT027_PMC_PAR_ERROR"
set BIT028_PPU_HARDWARE_ERROR [get_property REGISTER.ERROR_STATUS.BIT[028]_PPU_HARDWARE_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[028]_PPU_HARDWARE_ERROR: $BIT028_PPU_HARDWARE_ERROR"
set BIT029_RCU_HARDWARE_ERROR [get_property REGISTER.ERROR_STATUS.BIT[029]_RCU_HARDWARE_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[029]_RCU_HARDWARE_ERROR: $BIT029_RCU_HARDWARE_ERROR"
set BIT030_PMC_BOOTROM_ERROR [get_property REGISTER.ERROR_STATUS.BIT[030]_PMC_BOOTROM_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[030]_PMC_BOOTROM_ERROR: $BIT030_PMC_BOOTROM_ERROR"
set BIT031_PMC_APB_ERROR [get_property REGISTER.ERROR_STATUS.BIT[031]_PMC_APB_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[031]_PMC_APB_ERROR: $BIT031_PMC_APB_ERROR"
set BIT032_SSIT_ERROR5 [get_property REGISTER.ERROR_STATUS.BIT[032]_SSIT_ERROR5 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[032]_SSIT_ERROR5: $BIT032_SSIT_ERROR5"
set BIT033_SSIT_ERROR4 [get_property REGISTER.ERROR_STATUS.BIT[033]_SSIT_ERROR4 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[033]_SSIT_ERROR4: $BIT033_SSIT_ERROR4"
set BIT034_SSIT_ERROR3 [get_property REGISTER.ERROR_STATUS.BIT[034]_SSIT_ERROR3 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[034]_SSIT_ERROR3: $BIT034_SSIT_ERROR3"
set BIT035_NPI_ROOT_ERROR [get_property REGISTER.ERROR_STATUS.BIT[035]_NPI_ROOT_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[035]_NPI_ROOT_ERROR: $BIT035_NPI_ROOT_ERROR"
set BIT036_USER_PL3_ERROR [get_property REGISTER.ERROR_STATUS.BIT[036]_USER_PL3_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[036]_USER_PL3_ERROR: $BIT036_USER_PL3_ERROR"
set BIT037_USER_PL2_ERROR [get_property REGISTER.ERROR_STATUS.BIT[037]_USER_PL2_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[037]_USER_PL2_ERROR: $BIT037_USER_PL2_ERROR"
set BIT038_USER_PL1_ERROR [get_property REGISTER.ERROR_STATUS.BIT[038]_USER_PL1_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[038]_USER_PL1_ERROR: $BIT038_USER_PL1_ERROR"
set BIT039_USER_PL0_ERROR [get_property REGISTER.ERROR_STATUS.BIT[039]_USER_PL0_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[039]_USER_PL0_ERROR: $BIT039_USER_PL0_ERROR"
set BIT040_SYSMON_NCR [get_property REGISTER.ERROR_STATUS.BIT[040]_SYSMON_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[040]_SYSMON_NCR: $BIT040_SYSMON_NCR"
set BIT041_SYSMON_CR [get_property REGISTER.ERROR_STATUS.BIT[041]_SYSMON_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[041]_SYSMON_CR: BIT041_SYSMON_CR"
set BIT042_GT_NCR [get_property REGISTER.ERROR_STATUS.BIT[042]_GT_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[042]_GT_NCR: $BIT042_GT_NCR"
set BIT043_GT_CR [get_property REGISTER.ERROR_STATUS.BIT[043]_GT_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[043]_GT_CR: $BIT043_GT_CR"
set BIT044_DDRMC_MC_ECC_NCR [get_property REGISTER.ERROR_STATUS.BIT[044]_DDRMC_MC_ECC_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[044]_DDRMC_MC_ECC_NCR: $BIT044_DDRMC_MC_ECC_NCR"
set BIT045_DDRMC_MC_ECC_CR [get_property REGISTER.ERROR_STATUS.BIT[045]_DDRMC_MC_ECC_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[045]_DDRMC_MC_ECC_CR: $BIT045_DDRMC_MC_ECC_CR"
set BIT046_AIE_NCR [get_property REGISTER.ERROR_STATUS.BIT[046]_AIE_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[046]_AIE_NCR: $BIT046_AIE_NCR"
set BIT047_AIE_CR [get_property REGISTER.ERROR_STATUS.BIT[047]_AIE_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[047]_AIE_CR: $BIT047_AIE_CR"
set BIT048_MMCM_LOCK_ERROR [get_property REGISTER.ERROR_STATUS.BIT[048]_MMCM_LOCK_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[048]_MMCM_LOCK_ERROR: $BIT048_MMCM_LOCK_ERROR"
set BIT049_NOC_USER_ERROR [get_property REGISTER.ERROR_STATUS.BIT[049]_NOC_USER_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[049]_NOC_USER_ERROR: $BIT049_NOC_USER_ERROR"
set BIT050_NOC_NC [get_property REGISTER.ERROR_STATUS.BIT[050]_NOC_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[050]_NOC_NC: $BIT050_NOC_NC"
set BIT051_NOC_CR [get_property REGISTER.ERROR_STATUS.BIT[051]_NOC_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[051]_NOC_CR: $BIT051_NOC_CR"
set BIT052_DDRMC_MB_NCR [get_property REGISTER.ERROR_STATUS.BIT[052]_DDRMC_MB_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[052]_DDRMC_MB_NCR: $BIT052_DDRMC_MB_NCR"
set BIT053_DDRMC_MB_CR [get_property REGISTER.ERROR_STATUS.BIT[053]_DDRMC_MB_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[053]_DDRMC_MB_CR: $BIT053_DDRMC_MB_CR"
set BIT054_PSM_NCR [get_property REGISTER.ERROR_STATUS.BIT[054]_PSM_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[054]_PSM_NCR: $BIT054_PSM_NCR"
set BIT055_PSM_CR [get_property REGISTER.ERROR_STATUS.BIT[055]_PSM_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[055]_PSM_CR: $BIT055_PSM_CR"
set BIT056_CFRAME_ERROR [get_property REGISTER.ERROR_STATUS.BIT[056]_CFRAME_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[056]_CFRAME_ERROR: $BIT056_CFRAME_ERROR"
set BIT057_CFU_ERROR [get_property REGISTER.ERROR_STATUS.BIT[057]_CFU_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[057]_CFU_ERROR: $BIT057_CFU_ERROR"
set BIT058_GSW_NCR [get_property REGISTER.ERROR_STATUS.BIT[058]_GSW_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[058]_GSW_NCR: $BIT058_GSW_NCR"
set BIT059_GSW_C [get_property REGISTER.ERROR_STATUS.BIT[059]_GSW_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[059]_GSW_C: $BIT059_GSW_C"
set BIT060_PLM_NCR [get_property REGISTER.ERROR_STATUS.BIT[060]_PLM_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[060]_PLM_NCR: BIT060_PLM_NCR"
set BIT061_PLM_CR [get_property REGISTER.ERROR_STATUS.BIT[061]_PLM_CR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[061]_PLM_CR: $BIT061_PLM_CR"
set BIT062_BOOTROM_NCR [get_property REGISTER.ERROR_STATUS.BIT[062]_BOOTROM_NCR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[062]_BOOTROM_NCR: $BIT062_BOOTROM_NCR"
set BIT063_RESERVED [get_property REGISTER.ERROR_STATUS.BIT[063]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[063]_RESERVED: $BIT063_RESERVED"
set BIT093_064_GSW_ERROR [get_property REGISTER.ERROR_STATUS.BIT[093:064]_GSW_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[093:064]_GSW_ERROR: $BIT093_064_GSW_ERROR"
set BIT109_094_PLM_MINOR_ERROR [get_property REGISTER.ERROR_STATUS.BIT[109:094]_PLM_MINOR_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[109:094]_PLM_MINOR_ERROR: $BIT109_094_PLM_MINOR_ERROR"
set BIT123_110_PLM_MAJOR_ERROR [get_property REGISTER.ERROR_STATUS.BIT[123:110]_PLM_MAJOR_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[123:110]_PLM_MAJOR_ERROR: $BIT123_110_PLM_MAJOR_ERROR"
set BIT135_124_BOOTROM_LAST_ERROR [get_property REGISTER.ERROR_STATUS.BIT[135:124]_BOOTROM_LAST_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[135:124]_BOOTROM_LAST_ERROR: $BIT135_124_BOOTROM_LAST_ERROR"
set BIT147_136_BOOTROM_FIRST_ERROR [get_property REGISTER.ERROR_STATUS.BIT[147:136]_BOOTROM_FIRST_ERROR [lindex [get_hw_devices] 1]]
puts $outfile "BIT[147:136]_BOOTROM_FIRST_ERROR: $BIT147_136_BOOTROM_FIRST_ERROR"
set BIT154_148_RESERVED [get_property REGISTER.ERROR_STATUS.BIT[154:148]_RESERVED [lindex [get_hw_devices] 1]]
puts $outfile "BIT[154:148]_RESERVED: $BIT154_148_RESERVED"
set BIT159_155_RSVD_READS_0 [get_property REGISTER.ERROR_STATUS.BIT[159:155]_RSVD_READS_0 [lindex [get_hw_devices] 1]]
puts $outfile "BIT[159:155]_RSVD_READS_0: $BIT159_155_RSVD_READS_0"; puts $outfile \n

#Read USERCODE Register
set USERCODE [get_property REGISTER.USERCODE [lindex [get_hw_devices] 1]]
puts $outfile "USERCODE[31:0]: $USERCODE"; puts $outfile \n

close $outfile
