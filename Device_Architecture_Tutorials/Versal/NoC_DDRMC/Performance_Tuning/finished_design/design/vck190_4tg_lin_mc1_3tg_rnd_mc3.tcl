# © Copyright 2020-2021 Xilinx, Inc.
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

################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:perf_axi_tg:1.0\
xilinx.com:ip:sim_trig:1.0\
xilinx.com:ip:versal_cips:3.0\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CH0_LPDDR4_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH0_LPDDR4_1 ]

  set CH0_LPDDR4_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH0_LPDDR4_3 ]

  set CH1_LPDDR4_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH1_LPDDR4_1 ]

  set CH1_LPDDR4_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH1_LPDDR4_3 ]

  set SYS_CLK0_IN_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 SYS_CLK0_IN_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {201501000} \
   ] $SYS_CLK0_IN_0

  set SYS_CLK1_IN_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 SYS_CLK1_IN_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $SYS_CLK1_IN_0

  set SYS_CLK2_IN_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 SYS_CLK2_IN_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {201501000} \
   ] $SYS_CLK2_IN_0


  # Create ports

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1 ]
  set_property -dict [ list \
   CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
   CONFIG.HBM_DENSITY_PER_CHNL {1GB} \
   CONFIG.LOGO_FILE {data/noc_mc.png} \
   CONFIG.MC0_CONFIG_NUM {config26} \
   CONFIG.MC0_FLIPPED_PINOUT {true} \
   CONFIG.MC1_CONFIG_NUM {config26} \
   CONFIG.MC2_CONFIG_NUM {config26} \
   CONFIG.MC3_CONFIG_NUM {config26} \
   CONFIG.MC_ADDR_BIT2 {CA0} \
   CONFIG.MC_ADDR_BIT3 {CA1} \
   CONFIG.MC_ADDR_BIT4 {CA2} \
   CONFIG.MC_ADDR_BIT5 {CA3} \
   CONFIG.MC_ADDR_BIT6 {CA4} \
   CONFIG.MC_ADDR_BIT7 {CA5} \
   CONFIG.MC_ADDR_BIT8 {CH_SEL} \
   CONFIG.MC_ADDR_BIT9 {CA6} \
   CONFIG.MC_ADDR_BIT10 {CA7} \
   CONFIG.MC_ADDR_BIT11 {CA8} \
   CONFIG.MC_ADDR_BIT12 {CA9} \
   CONFIG.MC_ADDR_BIT13 {RA0} \
   CONFIG.MC_ADDR_BIT14 {RA1} \
   CONFIG.MC_ADDR_BIT15 {RA2} \
   CONFIG.MC_ADDR_BIT16 {RA3} \
   CONFIG.MC_ADDR_BIT17 {RA4} \
   CONFIG.MC_ADDR_BIT18 {RA5} \
   CONFIG.MC_ADDR_BIT19 {RA6} \
   CONFIG.MC_ADDR_BIT20 {RA7} \
   CONFIG.MC_ADDR_BIT21 {RA8} \
   CONFIG.MC_ADDR_BIT22 {RA9} \
   CONFIG.MC_ADDR_BIT23 {RA10} \
   CONFIG.MC_ADDR_BIT24 {RA11} \
   CONFIG.MC_ADDR_BIT25 {RA12} \
   CONFIG.MC_ADDR_BIT26 {RA13} \
   CONFIG.MC_ADDR_BIT27 {RA14} \
   CONFIG.MC_ADDR_BIT28 {RA15} \
   CONFIG.MC_ADDR_BIT29 {BA0} \
   CONFIG.MC_ADDR_BIT30 {BA1} \
   CONFIG.MC_ADDR_BIT31 {BA2} \
   CONFIG.MC_ADDR_BIT32 {NA} \
   CONFIG.MC_ADDR_WIDTH {6} \
   CONFIG.MC_BA_WIDTH {3} \
   CONFIG.MC_BG_WIDTH {0} \
   CONFIG.MC_BURST_LENGTH {16} \
   CONFIG.MC_CASLATENCY {36} \
   CONFIG.MC_CASWRITELATENCY {18} \
   CONFIG.MC_CH0_LP4_CHA_ENABLE {true} \
   CONFIG.MC_CH0_LP4_CHB_ENABLE {true} \
   CONFIG.MC_CH1_LP4_CHA_ENABLE {true} \
   CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
   CONFIG.MC_CHANNEL_INTERLEAVING {true} \
   CONFIG.MC_CHAN_REGION0 {DDR_CH1} \
   CONFIG.MC_CH_INTERLEAVING_SIZE {256_Bytes} \
   CONFIG.MC_CKE_WIDTH {0} \
   CONFIG.MC_CK_WIDTH {0} \
   CONFIG.MC_COMPONENT_DENSITY {16Gb} \
   CONFIG.MC_COMPONENT_WIDTH {x32} \
   CONFIG.MC_CONFIG_NUM {config26} \
   CONFIG.MC_DATAWIDTH {32} \
   CONFIG.MC_DDR_INIT_TIMEOUT {0x00035ECC} \
   CONFIG.MC_DM_WIDTH {4} \
   CONFIG.MC_DQS_WIDTH {4} \
   CONFIG.MC_DQ_WIDTH {32} \
   CONFIG.MC_ECC {false} \
   CONFIG.MC_ECC_SCRUB_PERIOD {0x004CBF} \
   CONFIG.MC_ECC_SCRUB_SIZE {4096} \
   CONFIG.MC_EN_BACKGROUND_SCRUBBING {true} \
   CONFIG.MC_EN_ECC_SCRUBBING {false} \
   CONFIG.MC_F1_CASLATENCY {36} \
   CONFIG.MC_F1_CASWRITELATENCY {18} \
   CONFIG.MC_F1_LPDDR4_MR1 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR2 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR3 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
   CONFIG.MC_F1_TCCD_L {0} \
   CONFIG.MC_F1_TCCD_L_MIN {0} \
   CONFIG.MC_F1_TFAW {30000} \
   CONFIG.MC_F1_TFAWMIN {30000} \
   CONFIG.MC_F1_TMOD {0} \
   CONFIG.MC_F1_TMOD_MIN {0} \
   CONFIG.MC_F1_TMRD {14000} \
   CONFIG.MC_F1_TMRDMIN {14000} \
   CONFIG.MC_F1_TMRW {10000} \
   CONFIG.MC_F1_TMRWMIN {10000} \
   CONFIG.MC_F1_TRAS {42000} \
   CONFIG.MC_F1_TRASMIN {42000} \
   CONFIG.MC_F1_TRCD {18000} \
   CONFIG.MC_F1_TRCDMIN {18000} \
   CONFIG.MC_F1_TRPAB {21000} \
   CONFIG.MC_F1_TRPABMIN {21000} \
   CONFIG.MC_F1_TRPPB {18000} \
   CONFIG.MC_F1_TRPPBMIN {18000} \
   CONFIG.MC_F1_TRRD {7500} \
   CONFIG.MC_F1_TRRDMIN {7500} \
   CONFIG.MC_F1_TRRD_L {0} \
   CONFIG.MC_F1_TRRD_L_MIN {0} \
   CONFIG.MC_F1_TRRD_S {0} \
   CONFIG.MC_F1_TRRD_S_MIN {0} \
   CONFIG.MC_F1_TWR {18000} \
   CONFIG.MC_F1_TWRMIN {18000} \
   CONFIG.MC_F1_TWTR {10000} \
   CONFIG.MC_F1_TWTRMIN {10000} \
   CONFIG.MC_F1_TWTR_L {0} \
   CONFIG.MC_F1_TWTR_L_MIN {0} \
   CONFIG.MC_F1_TWTR_S {0} \
   CONFIG.MC_F1_TWTR_S_MIN {0} \
   CONFIG.MC_F1_TZQLAT {30000} \
   CONFIG.MC_F1_TZQLATMIN {30000} \
   CONFIG.MC_INPUTCLK0_PERIOD {4963} \
   CONFIG.MC_INPUT_FREQUENCY0 {201.501} \
   CONFIG.MC_IP_TIMEPERIOD0_FOR_OP {1071} \
   CONFIG.MC_IP_TIMEPERIOD1 {509} \
   CONFIG.MC_LP4_CA_A_WIDTH {6} \
   CONFIG.MC_LP4_CA_B_WIDTH {6} \
   CONFIG.MC_LP4_CKE_A_WIDTH {1} \
   CONFIG.MC_LP4_CKE_B_WIDTH {1} \
   CONFIG.MC_LP4_CKT_A_WIDTH {1} \
   CONFIG.MC_LP4_CKT_B_WIDTH {1} \
   CONFIG.MC_LP4_CS_A_WIDTH {1} \
   CONFIG.MC_LP4_CS_B_WIDTH {1} \
   CONFIG.MC_LP4_DMI_A_WIDTH {2} \
   CONFIG.MC_LP4_DMI_B_WIDTH {2} \
   CONFIG.MC_LP4_DQS_A_WIDTH {2} \
   CONFIG.MC_LP4_DQS_B_WIDTH {2} \
   CONFIG.MC_LP4_DQ_A_WIDTH {16} \
   CONFIG.MC_LP4_DQ_B_WIDTH {16} \
   CONFIG.MC_LP4_RESETN_WIDTH {1} \
   CONFIG.MC_MEMORY_DENSITY {2GB} \
   CONFIG.MC_MEMORY_DEVICE_DENSITY {16Gb} \
   CONFIG.MC_MEMORY_SPEEDGRADE {LPDDR4-4267} \
   CONFIG.MC_MEMORY_TIMEPERIOD0 {509} \
   CONFIG.MC_MEMORY_TIMEPERIOD1 {509} \
   CONFIG.MC_MEM_DEVICE_WIDTH {x32} \
   CONFIG.MC_NETLIST_SIMULATION {true} \
   CONFIG.MC_NO_CHANNELS {Dual} \
   CONFIG.MC_ODTLon {8} \
   CONFIG.MC_ODT_WIDTH {0} \
   CONFIG.MC_PER_RD_INTVL {0} \
   CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {BANK_ROW_COLUMN} \
   CONFIG.MC_READ_BANDWIDTH {7858.546} \
   CONFIG.MC_REFRESH_SPEED {1x} \
   CONFIG.MC_TCCD {8} \
   CONFIG.MC_TCCD_L {0} \
   CONFIG.MC_TCCD_L_MIN {0} \
   CONFIG.MC_TCKE {15} \
   CONFIG.MC_TCKEMIN {15} \
   CONFIG.MC_TDQS2DQ_MAX {800} \
   CONFIG.MC_TDQS2DQ_MIN {200} \
   CONFIG.MC_TDQSCK_MAX {3500} \
   CONFIG.MC_TFAW {30000} \
   CONFIG.MC_TFAWMIN {30000} \
   CONFIG.MC_TFAW_nCK {0} \
   CONFIG.MC_TMOD {0} \
   CONFIG.MC_TMOD_MIN {0} \
   CONFIG.MC_TMPRR {0} \
   CONFIG.MC_TMRD {14000} \
   CONFIG.MC_TMRDMIN {14000} \
   CONFIG.MC_TMRD_div4 {10} \
   CONFIG.MC_TMRD_nCK {28} \
   CONFIG.MC_TMRW {10000} \
   CONFIG.MC_TMRWMIN {10000} \
   CONFIG.MC_TMRW_div4 {10} \
   CONFIG.MC_TMRW_nCK {20} \
   CONFIG.MC_TODTon_MIN {3} \
   CONFIG.MC_TOSCO {40000} \
   CONFIG.MC_TOSCOMIN {40000} \
   CONFIG.MC_TOSCO_nCK {79} \
   CONFIG.MC_TPAR_ALERT_ON {0} \
   CONFIG.MC_TPAR_ALERT_PW_MAX {0} \
   CONFIG.MC_TPBR2PBR {90000} \
   CONFIG.MC_TPBR2PBRMIN {90000} \
   CONFIG.MC_TRAS {42000} \
   CONFIG.MC_TRASMIN {42000} \
   CONFIG.MC_TRAS_nCK {83} \
   CONFIG.MC_TRC {63000} \
   CONFIG.MC_TRCD {18000} \
   CONFIG.MC_TRCDMIN {18000} \
   CONFIG.MC_TRCD_nCK {36} \
   CONFIG.MC_TRCMIN {0} \
   CONFIG.MC_TREFI {3904000} \
   CONFIG.MC_TREFIPB {488000} \
   CONFIG.MC_TRFC {0} \
   CONFIG.MC_TRFCAB {280000} \
   CONFIG.MC_TRFCABMIN {280000} \
   CONFIG.MC_TRFCMIN {0} \
   CONFIG.MC_TRFCPB {140000} \
   CONFIG.MC_TRFCPBMIN {140000} \
   CONFIG.MC_TRP {0} \
   CONFIG.MC_TRPAB {21000} \
   CONFIG.MC_TRPABMIN {21000} \
   CONFIG.MC_TRPAB_nCK {42} \
   CONFIG.MC_TRPMIN {0} \
   CONFIG.MC_TRPPB {18000} \
   CONFIG.MC_TRPPBMIN {18000} \
   CONFIG.MC_TRPPB_nCK {36} \
   CONFIG.MC_TRPRE {1.8} \
   CONFIG.MC_TRRD {7500} \
   CONFIG.MC_TRRDMIN {7500} \
   CONFIG.MC_TRRD_L {0} \
   CONFIG.MC_TRRD_L_MIN {0} \
   CONFIG.MC_TRRD_S {0} \
   CONFIG.MC_TRRD_S_MIN {0} \
   CONFIG.MC_TRRD_nCK {15} \
   CONFIG.MC_TRTP_nCK {16} \
   CONFIG.MC_TWPRE {1.8} \
   CONFIG.MC_TWPST {0.4} \
   CONFIG.MC_TWR {18000} \
   CONFIG.MC_TWRMIN {18000} \
   CONFIG.MC_TWR_nCK {36} \
   CONFIG.MC_TWTR {10000} \
   CONFIG.MC_TWTRMIN {10000} \
   CONFIG.MC_TWTR_L {0} \
   CONFIG.MC_TWTR_S {0} \
   CONFIG.MC_TWTR_S_MIN {0} \
   CONFIG.MC_TWTR_nCK {20} \
   CONFIG.MC_TXP {15} \
   CONFIG.MC_TXPMIN {15} \
   CONFIG.MC_TXPR {0} \
   CONFIG.MC_TZQCAL {1000000} \
   CONFIG.MC_TZQCAL_div4 {492} \
   CONFIG.MC_TZQCS_ITVL {0} \
   CONFIG.MC_TZQLAT {30000} \
   CONFIG.MC_TZQLATMIN {30000} \
   CONFIG.MC_TZQLAT_div4 {15} \
   CONFIG.MC_TZQLAT_nCK {59} \
   CONFIG.MC_TZQ_START_ITVL {1000000000} \
   CONFIG.MC_USER_DEFINED_ADDRESS_MAP {16RA-3BA-10CA} \
   CONFIG.MC_WRITE_BANDWIDTH {7858.546} \
   CONFIG.MC_XPLL_CLKOUT1_PERIOD {1018} \
   CONFIG.MC_XPLL_CLKOUT1_PHASE {210.41257367387036} \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {4} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_SI {4} \
 ] $axi_noc_1

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {2780} write_bw {2780} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {2780} write_bw {2780} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {2780} write_bw {2780} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {2780} write_bw {2780} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/S03_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI:S03_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk0]

  # Create instance: axi_noc_3, and set properties
  set axi_noc_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_3 ]
  set_property -dict [ list \
   CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
   CONFIG.HBM_DENSITY_PER_CHNL {1GB} \
   CONFIG.LOGO_FILE {data/noc_mc.png} \
   CONFIG.MC0_CONFIG_NUM {config26} \
   CONFIG.MC0_FLIPPED_PINOUT {true} \
   CONFIG.MC1_CONFIG_NUM {config26} \
   CONFIG.MC2_CONFIG_NUM {config26} \
   CONFIG.MC3_CONFIG_NUM {config26} \
   CONFIG.MC_ADDR_BIT2 {CA0} \
   CONFIG.MC_ADDR_BIT3 {CA1} \
   CONFIG.MC_ADDR_BIT4 {CA2} \
   CONFIG.MC_ADDR_BIT5 {CA3} \
   CONFIG.MC_ADDR_BIT6 {CA4} \
   CONFIG.MC_ADDR_BIT7 {CH_SEL} \
   CONFIG.MC_ADDR_BIT8 {CA5} \
   CONFIG.MC_ADDR_BIT9 {CA6} \
   CONFIG.MC_ADDR_BIT10 {CA7} \
   CONFIG.MC_ADDR_BIT11 {CA8} \
   CONFIG.MC_ADDR_BIT12 {CA9} \
   CONFIG.MC_ADDR_BIT13 {BA0} \
   CONFIG.MC_ADDR_BIT14 {BA1} \
   CONFIG.MC_ADDR_BIT15 {BA2} \
   CONFIG.MC_ADDR_BIT16 {RA0} \
   CONFIG.MC_ADDR_BIT17 {RA1} \
   CONFIG.MC_ADDR_BIT18 {RA2} \
   CONFIG.MC_ADDR_BIT19 {RA3} \
   CONFIG.MC_ADDR_BIT20 {RA4} \
   CONFIG.MC_ADDR_BIT21 {RA5} \
   CONFIG.MC_ADDR_BIT22 {RA6} \
   CONFIG.MC_ADDR_BIT23 {RA7} \
   CONFIG.MC_ADDR_BIT24 {RA8} \
   CONFIG.MC_ADDR_BIT25 {RA9} \
   CONFIG.MC_ADDR_BIT26 {RA10} \
   CONFIG.MC_ADDR_BIT27 {RA11} \
   CONFIG.MC_ADDR_BIT28 {RA12} \
   CONFIG.MC_ADDR_BIT29 {RA13} \
   CONFIG.MC_ADDR_BIT30 {RA14} \
   CONFIG.MC_ADDR_BIT31 {RA15} \
   CONFIG.MC_ADDR_BIT32 {NA} \
   CONFIG.MC_ADDR_WIDTH {6} \
   CONFIG.MC_BA_WIDTH {3} \
   CONFIG.MC_BG_WIDTH {0} \
   CONFIG.MC_BURST_LENGTH {16} \
   CONFIG.MC_CASLATENCY {36} \
   CONFIG.MC_CASWRITELATENCY {18} \
   CONFIG.MC_CH0_LP4_CHA_ENABLE {true} \
   CONFIG.MC_CH0_LP4_CHB_ENABLE {true} \
   CONFIG.MC_CH1_LP4_CHA_ENABLE {true} \
   CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
   CONFIG.MC_CHANNEL_INTERLEAVING {true} \
   CONFIG.MC_CHAN_REGION0 {DDR_CH2} \
   CONFIG.MC_CH_INTERLEAVING_SIZE {128_Bytes} \
   CONFIG.MC_CKE_WIDTH {0} \
   CONFIG.MC_CK_WIDTH {0} \
   CONFIG.MC_COMPONENT_DENSITY {16Gb} \
   CONFIG.MC_COMPONENT_WIDTH {x32} \
   CONFIG.MC_CONFIG_NUM {config26} \
   CONFIG.MC_DATAWIDTH {32} \
   CONFIG.MC_DDR_INIT_TIMEOUT {0x00035ECC} \
   CONFIG.MC_DM_WIDTH {4} \
   CONFIG.MC_DQS_WIDTH {4} \
   CONFIG.MC_DQ_WIDTH {32} \
   CONFIG.MC_ECC {false} \
   CONFIG.MC_ECC_SCRUB_PERIOD {0x004CBF} \
   CONFIG.MC_ECC_SCRUB_SIZE {4096} \
   CONFIG.MC_EN_BACKGROUND_SCRUBBING {true} \
   CONFIG.MC_EN_ECC_SCRUBBING {false} \
   CONFIG.MC_F1_CASLATENCY {36} \
   CONFIG.MC_F1_CASWRITELATENCY {18} \
   CONFIG.MC_F1_LPDDR4_MR1 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR2 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR3 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
   CONFIG.MC_F1_TCCD_L {0} \
   CONFIG.MC_F1_TCCD_L_MIN {0} \
   CONFIG.MC_F1_TFAW {30000} \
   CONFIG.MC_F1_TFAWMIN {30000} \
   CONFIG.MC_F1_TMOD {0} \
   CONFIG.MC_F1_TMOD_MIN {0} \
   CONFIG.MC_F1_TMRD {14000} \
   CONFIG.MC_F1_TMRDMIN {14000} \
   CONFIG.MC_F1_TMRW {10000} \
   CONFIG.MC_F1_TMRWMIN {10000} \
   CONFIG.MC_F1_TRAS {42000} \
   CONFIG.MC_F1_TRASMIN {42000} \
   CONFIG.MC_F1_TRCD {18000} \
   CONFIG.MC_F1_TRCDMIN {18000} \
   CONFIG.MC_F1_TRPAB {21000} \
   CONFIG.MC_F1_TRPABMIN {21000} \
   CONFIG.MC_F1_TRPPB {18000} \
   CONFIG.MC_F1_TRPPBMIN {18000} \
   CONFIG.MC_F1_TRRD {7500} \
   CONFIG.MC_F1_TRRDMIN {7500} \
   CONFIG.MC_F1_TRRD_L {0} \
   CONFIG.MC_F1_TRRD_L_MIN {0} \
   CONFIG.MC_F1_TRRD_S {0} \
   CONFIG.MC_F1_TRRD_S_MIN {0} \
   CONFIG.MC_F1_TWR {18000} \
   CONFIG.MC_F1_TWRMIN {18000} \
   CONFIG.MC_F1_TWTR {10000} \
   CONFIG.MC_F1_TWTRMIN {10000} \
   CONFIG.MC_F1_TWTR_L {0} \
   CONFIG.MC_F1_TWTR_L_MIN {0} \
   CONFIG.MC_F1_TWTR_S {0} \
   CONFIG.MC_F1_TWTR_S_MIN {0} \
   CONFIG.MC_F1_TZQLAT {30000} \
   CONFIG.MC_F1_TZQLATMIN {30000} \
   CONFIG.MC_INPUTCLK0_PERIOD {4963} \
   CONFIG.MC_INPUT_FREQUENCY0 {201.501} \
   CONFIG.MC_IP_TIMEPERIOD0_FOR_OP {1071} \
   CONFIG.MC_IP_TIMEPERIOD1 {509} \
   CONFIG.MC_LP4_CA_A_WIDTH {6} \
   CONFIG.MC_LP4_CA_B_WIDTH {6} \
   CONFIG.MC_LP4_CKE_A_WIDTH {1} \
   CONFIG.MC_LP4_CKE_B_WIDTH {1} \
   CONFIG.MC_LP4_CKT_A_WIDTH {1} \
   CONFIG.MC_LP4_CKT_B_WIDTH {1} \
   CONFIG.MC_LP4_CS_A_WIDTH {1} \
   CONFIG.MC_LP4_CS_B_WIDTH {1} \
   CONFIG.MC_LP4_DMI_A_WIDTH {2} \
   CONFIG.MC_LP4_DMI_B_WIDTH {2} \
   CONFIG.MC_LP4_DQS_A_WIDTH {2} \
   CONFIG.MC_LP4_DQS_B_WIDTH {2} \
   CONFIG.MC_LP4_DQ_A_WIDTH {16} \
   CONFIG.MC_LP4_DQ_B_WIDTH {16} \
   CONFIG.MC_LP4_RESETN_WIDTH {1} \
   CONFIG.MC_MEMORY_DENSITY {2GB} \
   CONFIG.MC_MEMORY_DEVICE_DENSITY {16Gb} \
   CONFIG.MC_MEMORY_SPEEDGRADE {LPDDR4-4267} \
   CONFIG.MC_MEMORY_TIMEPERIOD0 {509} \
   CONFIG.MC_MEMORY_TIMEPERIOD1 {509} \
   CONFIG.MC_MEM_DEVICE_WIDTH {x32} \
   CONFIG.MC_NETLIST_SIMULATION {true} \
   CONFIG.MC_NO_CHANNELS {Dual} \
   CONFIG.MC_ODTLon {8} \
   CONFIG.MC_ODT_WIDTH {0} \
   CONFIG.MC_PER_RD_INTVL {0} \
   CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN} \
   CONFIG.MC_READ_BANDWIDTH {7858.546} \
   CONFIG.MC_REFRESH_SPEED {1x} \
   CONFIG.MC_TCCD {8} \
   CONFIG.MC_TCCD_L {0} \
   CONFIG.MC_TCCD_L_MIN {0} \
   CONFIG.MC_TCKE {15} \
   CONFIG.MC_TCKEMIN {15} \
   CONFIG.MC_TDQS2DQ_MAX {800} \
   CONFIG.MC_TDQS2DQ_MIN {200} \
   CONFIG.MC_TDQSCK_MAX {3500} \
   CONFIG.MC_TFAW {30000} \
   CONFIG.MC_TFAWMIN {30000} \
   CONFIG.MC_TFAW_nCK {0} \
   CONFIG.MC_TMOD {0} \
   CONFIG.MC_TMOD_MIN {0} \
   CONFIG.MC_TMPRR {0} \
   CONFIG.MC_TMRD {14000} \
   CONFIG.MC_TMRDMIN {14000} \
   CONFIG.MC_TMRD_div4 {10} \
   CONFIG.MC_TMRD_nCK {28} \
   CONFIG.MC_TMRW {10000} \
   CONFIG.MC_TMRWMIN {10000} \
   CONFIG.MC_TMRW_div4 {10} \
   CONFIG.MC_TMRW_nCK {20} \
   CONFIG.MC_TODTon_MIN {3} \
   CONFIG.MC_TOSCO {40000} \
   CONFIG.MC_TOSCOMIN {40000} \
   CONFIG.MC_TOSCO_nCK {79} \
   CONFIG.MC_TPAR_ALERT_ON {0} \
   CONFIG.MC_TPAR_ALERT_PW_MAX {0} \
   CONFIG.MC_TPBR2PBR {90000} \
   CONFIG.MC_TPBR2PBRMIN {90000} \
   CONFIG.MC_TRAS {42000} \
   CONFIG.MC_TRASMIN {42000} \
   CONFIG.MC_TRAS_nCK {83} \
   CONFIG.MC_TRC {63000} \
   CONFIG.MC_TRCD {18000} \
   CONFIG.MC_TRCDMIN {18000} \
   CONFIG.MC_TRCD_nCK {36} \
   CONFIG.MC_TRCMIN {0} \
   CONFIG.MC_TREFI {3904000} \
   CONFIG.MC_TREFIPB {488000} \
   CONFIG.MC_TRFC {0} \
   CONFIG.MC_TRFCAB {280000} \
   CONFIG.MC_TRFCABMIN {280000} \
   CONFIG.MC_TRFCMIN {0} \
   CONFIG.MC_TRFCPB {140000} \
   CONFIG.MC_TRFCPBMIN {140000} \
   CONFIG.MC_TRP {0} \
   CONFIG.MC_TRPAB {21000} \
   CONFIG.MC_TRPABMIN {21000} \
   CONFIG.MC_TRPAB_nCK {42} \
   CONFIG.MC_TRPMIN {0} \
   CONFIG.MC_TRPPB {18000} \
   CONFIG.MC_TRPPBMIN {18000} \
   CONFIG.MC_TRPPB_nCK {36} \
   CONFIG.MC_TRPRE {1.8} \
   CONFIG.MC_TRRD {7500} \
   CONFIG.MC_TRRDMIN {7500} \
   CONFIG.MC_TRRD_L {0} \
   CONFIG.MC_TRRD_L_MIN {0} \
   CONFIG.MC_TRRD_S {0} \
   CONFIG.MC_TRRD_S_MIN {0} \
   CONFIG.MC_TRRD_nCK {15} \
   CONFIG.MC_TRTP_nCK {16} \
   CONFIG.MC_TWPRE {1.8} \
   CONFIG.MC_TWPST {0.4} \
   CONFIG.MC_TWR {18000} \
   CONFIG.MC_TWRMIN {18000} \
   CONFIG.MC_TWR_nCK {36} \
   CONFIG.MC_TWTR {10000} \
   CONFIG.MC_TWTRMIN {10000} \
   CONFIG.MC_TWTR_L {0} \
   CONFIG.MC_TWTR_S {0} \
   CONFIG.MC_TWTR_S_MIN {0} \
   CONFIG.MC_TWTR_nCK {20} \
   CONFIG.MC_TXP {15} \
   CONFIG.MC_TXPMIN {15} \
   CONFIG.MC_TXPR {0} \
   CONFIG.MC_TZQCAL {1000000} \
   CONFIG.MC_TZQCAL_div4 {492} \
   CONFIG.MC_TZQCS_ITVL {0} \
   CONFIG.MC_TZQLAT {30000} \
   CONFIG.MC_TZQLATMIN {30000} \
   CONFIG.MC_TZQLAT_div4 {15} \
   CONFIG.MC_TZQLAT_nCK {59} \
   CONFIG.MC_TZQ_START_ITVL {1000000000} \
   CONFIG.MC_USER_DEFINED_ADDRESS_MAP {16RA-3BA-10CA} \
   CONFIG.MC_WRITE_BANDWIDTH {7858.546} \
   CONFIG.MC_XPLL_CLKOUT1_PERIOD {1018} \
   CONFIG.MC_XPLL_CLKOUT1_PHASE {210.41257367387036} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {4} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_SI {3} \
 ] $axi_noc_3

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {4000} write_bw {2909} read_avg_burst {2} write_avg_burst {2}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_3/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {4000} write_bw {0} read_avg_burst {2} write_avg_burst {1}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_3/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {4000} write_bw {0} read_avg_burst {2} write_avg_burst {1}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_3/S02_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI} \
 ] [get_bd_pins /axi_noc_3/aclk0]

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
   CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
   CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
   CONFIG.CLKOUT_MBUFGCE_MODE {PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE}\
   CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
   CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
   CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {250.000,100.000,100.000,100.000,100.000,100.000,100.000} \
   CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
   CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
   CONFIG.PRIM_IN_FREQ {200.000} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.SECONDARY_IN_FREQ {144.000} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wizard_0

  # Create instance: perf_axi_tg_0, and set properties
  set perf_axi_tg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_0 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {0} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_0

  # Create instance: perf_axi_tg_1, and set properties
  set perf_axi_tg_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_1 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {1} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_1

  # Create instance: perf_axi_tg_2, and set properties
  set perf_axi_tg_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_2 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {2} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_2

  # Create instance: perf_axi_tg_3, and set properties
  set perf_axi_tg_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_3 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {3} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_3

  # Create instance: perf_axi_tg_4, and set properties
  set perf_axi_tg_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_4 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {4} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_4

  # Create instance: perf_axi_tg_5, and set properties
  set perf_axi_tg_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_5 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {5} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_5

  # Create instance: perf_axi_tg_6, and set properties
  set perf_axi_tg_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_6 ]
  set_property -dict [ list \
   CONFIG.USER_C_AXI_ARUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_AWUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_BUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_READ_SIZE {1} \
   CONFIG.USER_C_AXI_RUSER_WIDTH {16} \
   CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
   CONFIG.USER_C_AXI_WRITE_SIZE {1} \
   CONFIG.USER_C_AXI_WUSER_WIDTH {16} \
   CONFIG.USER_DEBUG_INTF {TRUE} \
   CONFIG.USER_DEST_ID_PORTS {NONE} \
   CONFIG.USER_DI_ERR_CNT_STOP_TRFC {0} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
   CONFIG.USER_PARAM_SRC_ID {6} \
   CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
   CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
   CONFIG.USER_SYN_ID_WIDTH {2} \
   CONFIG.USER_SYN_USER_WIDTH {0} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $perf_axi_tg_6

  # Create instance: sim_trig_0, and set properties
  set sim_trig_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sim_trig:1.0 sim_trig_0 ]
  set_property -dict [ list \
   CONFIG.USER_DEBUG_INTF {INTERNAL_VIO} \
   CONFIG.USER_EN_AXIS_VIO_IF {FALSE} \
   CONFIG.USER_NUM_AXI_TG {7} \
   CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
 ] $sim_trig_0

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.0 versal_cips_0 ]
  set_property -dict [ list \
   CONFIG.CPM_CONFIG {CPM_PCIE0_AXISTEN_IF_WIDTH 64 CPM_PCIE0_MODES None } \
   CONFIG.PS_PMC_CONFIG {PMC_CRP_NOC_REF_CTRL_FREQMHZ 950 PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ 240\
PMC_CRP_PL0_REF_CTRL_DIVISOR0 3 PMC_MIO_TREE_PERIPHERALS\
{#####################################GPIO 1#####UART 0#UART 0###UART 1#UART\
1##############################} PMC_MIO_TREE_SIGNALS\
#####################################gpio_1_pin[37]#####rxd#txd###txd#rxd##############################\
PMC_USE_PMC_NOC_AXI0 0 PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ 99.999001\
PS_CRL_UART1_REF_CTRL_ACT_FREQMHZ 99.999001 PS_NUM_FABRIC_RESETS 0\
PS_USE_M_AXI_FPD 0 PS_USE_M_AXI_LPD 0 PS_USE_NOC_FPD_CCI0 0 PS_USE_NOC_FPD_CCI1\
0 PS_USE_PMCPL_CLK0 0 PS_USE_FPD_CCI_NOC 0 PS_USE_NOC_LPD_AXI0 0\
PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} PS_UART1_PERIPHERAL\
{{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} PMC_MIO37 {{AUX_IO 0} {DIRECTION out}\
{DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow}\
{USAGE GPIO}} PMC_MIO43 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA}\
{OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}}\
PMC_MIO46 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA\
default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} SMON_ALARMS\
Set_Alarms_On SMON_ENABLE_TEMP_AVERAGING 0 SMON_TEMP_AVERAGING_SAMPLES 8\
PS_BOARD_INTERFACE Custom DESIGN_MODE 1 PS_PCIE1_PERIPHERAL_ENABLE 0\
PS_PCIE2_PERIPHERAL_ENABLE 0 PCIE_APERTURES_SINGLE_ENABLE 0\
PCIE_APERTURES_DUAL_ENABLE 0}\
   CONFIG.PS_PMC_CONFIG_APPLIED {1} \
 ] $versal_cips_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net SYS_CLK0_IN_0_1 [get_bd_intf_ports SYS_CLK0_IN_0] [get_bd_intf_pins axi_noc_1/sys_clk0]
  connect_bd_intf_net -intf_net SYS_CLK1_IN_0_1 [get_bd_intf_ports SYS_CLK1_IN_0] [get_bd_intf_pins clk_wizard_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net SYS_CLK2_IN_0_1 [get_bd_intf_ports SYS_CLK2_IN_0] [get_bd_intf_pins axi_noc_3/sys_clk0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports CH0_LPDDR4_3] [get_bd_intf_pins axi_noc_3/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports CH1_LPDDR4_3] [get_bd_intf_pins axi_noc_3/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_1_CH0_LPDDR4_0 [get_bd_intf_ports CH0_LPDDR4_1] [get_bd_intf_pins axi_noc_1/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_1_CH1_LPDDR4_0 [get_bd_intf_ports CH1_LPDDR4_1] [get_bd_intf_pins axi_noc_1/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net perf_axi_tg_0_M_AXI [get_bd_intf_pins axi_noc_1/S00_AXI] [get_bd_intf_pins perf_axi_tg_0/M_AXI]
  connect_bd_intf_net -intf_net perf_axi_tg_1_M_AXI [get_bd_intf_pins axi_noc_1/S01_AXI] [get_bd_intf_pins perf_axi_tg_1/M_AXI]
  connect_bd_intf_net -intf_net perf_axi_tg_2_M_AXI [get_bd_intf_pins axi_noc_1/S02_AXI] [get_bd_intf_pins perf_axi_tg_2/M_AXI]
  connect_bd_intf_net -intf_net perf_axi_tg_3_M_AXI [get_bd_intf_pins axi_noc_1/S03_AXI] [get_bd_intf_pins perf_axi_tg_3/M_AXI]
  connect_bd_intf_net -intf_net perf_axi_tg_4_M_AXI [get_bd_intf_pins axi_noc_3/S00_AXI] [get_bd_intf_pins perf_axi_tg_4/M_AXI]
  connect_bd_intf_net -intf_net perf_axi_tg_5_M_AXI [get_bd_intf_pins axi_noc_3/S02_AXI] [get_bd_intf_pins perf_axi_tg_6/M_AXI]
  connect_bd_intf_net -intf_net perf_axi_tg_6_M_AXI [get_bd_intf_pins axi_noc_3/S01_AXI] [get_bd_intf_pins perf_axi_tg_5/M_AXI]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_00 [get_bd_intf_pins perf_axi_tg_0/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_00]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_01 [get_bd_intf_pins perf_axi_tg_1/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_01]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_02 [get_bd_intf_pins perf_axi_tg_2/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_02]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_03 [get_bd_intf_pins perf_axi_tg_3/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_03]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_04 [get_bd_intf_pins perf_axi_tg_4/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_04]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_05 [get_bd_intf_pins perf_axi_tg_6/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_05]
  connect_bd_intf_net -intf_net sim_trig_0_MCSIO_OUT_06 [get_bd_intf_pins perf_axi_tg_5/MCSIO_IN] [get_bd_intf_pins sim_trig_0/MCSIO_OUT_06]

  # Create port connections
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins axi_noc_1/aclk0] [get_bd_pins axi_noc_3/aclk0] [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins perf_axi_tg_0/clk] [get_bd_pins perf_axi_tg_0/pclk] [get_bd_pins perf_axi_tg_1/clk] [get_bd_pins perf_axi_tg_1/pclk] [get_bd_pins perf_axi_tg_2/clk] [get_bd_pins perf_axi_tg_2/pclk] [get_bd_pins perf_axi_tg_3/clk] [get_bd_pins perf_axi_tg_3/pclk] [get_bd_pins perf_axi_tg_4/clk] [get_bd_pins perf_axi_tg_4/pclk] [get_bd_pins perf_axi_tg_5/clk] [get_bd_pins perf_axi_tg_5/pclk] [get_bd_pins perf_axi_tg_6/clk] [get_bd_pins perf_axi_tg_6/pclk] [get_bd_pins sim_trig_0/pclk]
  connect_bd_net -net perf_axi_tg_0_axi_tg_done [get_bd_pins perf_axi_tg_0/axi_tg_done] [get_bd_pins sim_trig_0/all_done_00]
  connect_bd_net -net perf_axi_tg_1_axi_tg_done [get_bd_pins perf_axi_tg_1/axi_tg_done] [get_bd_pins sim_trig_0/all_done_01]
  connect_bd_net -net perf_axi_tg_2_axi_tg_done [get_bd_pins perf_axi_tg_2/axi_tg_done] [get_bd_pins sim_trig_0/all_done_02]
  connect_bd_net -net perf_axi_tg_3_axi_tg_done [get_bd_pins perf_axi_tg_3/axi_tg_done] [get_bd_pins sim_trig_0/all_done_03]
  connect_bd_net -net perf_axi_tg_4_axi_tg_done [get_bd_pins perf_axi_tg_4/axi_tg_done] [get_bd_pins sim_trig_0/all_done_04]
  connect_bd_net -net perf_axi_tg_5_axi_tg_done [get_bd_pins perf_axi_tg_5/axi_tg_done] [get_bd_pins sim_trig_0/all_done_06]
  connect_bd_net -net perf_axi_tg_6_axi_tg_done [get_bd_pins perf_axi_tg_6/axi_tg_done] [get_bd_pins sim_trig_0/all_done_05]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins perf_axi_tg_0/axi_tg_start] [get_bd_pins perf_axi_tg_0/tg_rst_n] [get_bd_pins perf_axi_tg_1/axi_tg_start] [get_bd_pins perf_axi_tg_1/tg_rst_n] [get_bd_pins perf_axi_tg_2/axi_tg_start] [get_bd_pins perf_axi_tg_2/tg_rst_n] [get_bd_pins perf_axi_tg_3/axi_tg_start] [get_bd_pins perf_axi_tg_3/tg_rst_n] [get_bd_pins perf_axi_tg_4/axi_tg_start] [get_bd_pins perf_axi_tg_4/tg_rst_n] [get_bd_pins perf_axi_tg_5/axi_tg_start] [get_bd_pins perf_axi_tg_5/tg_rst_n] [get_bd_pins perf_axi_tg_6/axi_tg_start] [get_bd_pins perf_axi_tg_6/tg_rst_n] [get_bd_pins sim_trig_0/rst_n] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x050000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_0/Data] [get_bd_addr_segs axi_noc_1/S00_AXI/C1_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_1/Data] [get_bd_addr_segs axi_noc_1/S01_AXI/C2_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_2/Data] [get_bd_addr_segs axi_noc_1/S02_AXI/C0_DDR_CH1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_3/Data] [get_bd_addr_segs axi_noc_1/S03_AXI/C3_DDR_CH1] -force
  assign_bd_address -offset 0x060000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_4/Data] [get_bd_addr_segs axi_noc_3/S00_AXI/C0_DDR_CH2] -force
  assign_bd_address -offset 0x060000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_5/Data] [get_bd_addr_segs axi_noc_3/S01_AXI/C1_DDR_CH2] -force
  assign_bd_address -offset 0x060000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces perf_axi_tg_6/Data] [get_bd_addr_segs axi_noc_3/S02_AXI/C2_DDR_CH2] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

add_files -fileset constrs_1 -norecurse ./lpddr4_mc3_vck190.xdc
make_wrapper -files [get_files ./myproj/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ./myproj/project_1.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1

regenerate_bd_layout

set_property synth_checkpoint_mode None [get_files  ./myproj/project_1.srcs/sources_1/bd/design_1/design_1.bd]
generate_target all [get_files  ./myproj/project_1.srcs/sources_1/bd/design_1/design_1.bd]
export_ip_user_files -of_objects [get_files ./myproj/project_1.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
export_simulation -of_objects [get_files ./myproj/project_1.srcs/sources_1/bd/design_1/design_1.bd] \
                  -directory ./myproj/project_1.ip_user_files/sim_scripts \
		  -ip_user_files_dir ./myproj/project_1.ip_user_files \
                  -ipstatic_source_dir ./myproj/project_1.ip_user_files/ipstatic \
                  -lib_map_path [list {modelsim=./myproj/project_1.cache/compile_simlib/modelsim} \
                                      {questa=./myproj/project_1.cache/compile_simlib/questa} \
                                      {ies=./myproj/project_1.cache/compile_simlib/ies} \
                                      {xcelium=./myproj/project_1.cache/compile_simlib/xcelium} \
                                      {vcs=./myproj/project_1.cache/compile_simlib/vcs} \
                                      {riviera=./myproj/project_1.cache/compile_simlib/riviera} \
                                ] \
                  -use_ip_compiled_libs -force -quiet

update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_device_image -jobs 32
wait_on_run impl_1
