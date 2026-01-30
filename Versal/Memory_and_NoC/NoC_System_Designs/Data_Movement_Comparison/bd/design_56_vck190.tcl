# © Copyright 2021 Xilinx, Inc.
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
set scripts_vivado_version 2020.2
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
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S-es1
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
xilinx.com:hls:kmeans_top:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:versal_cips:2.1\
xilinx.com:ip:xlconcat:2.1\
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

  set CH1_LPDDR4_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH1_LPDDR4_1 ]

  set CH0_LPDDR4_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH0_LPDDR4_3 ]

  set CH1_LPDDR4_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 CH1_LPDDR4_3 ]

  set sys_clk0_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk0_0 ]
  set_property CONFIG.FREQ_HZ 201501000 [get_bd_intf_ports /sys_clk0_0]

  #set sys_clk1_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk1_0 ]
  #set_property CONFIG.FREQ_HZ 200000000 [get_bd_intf_ports /sys_clk1_0]

  #set sys_clk2_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk2_0 ]
  #set_property CONFIG.FREQ_HZ 201501000 [get_bd_intf_ports /sys_clk2_0]

  set sys_clk1_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk1_0 ]
  set_property CONFIG.FREQ_HZ 201501000 [get_bd_intf_ports /sys_clk1_0]

  # Create ports

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [ list \
   CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
   CONFIG.MC0_CONFIG_NUM {config26} \
   CONFIG.MC0_FLIPPED_PINOUT {true} \
   CONFIG.MC1_CONFIG_NUM {config26} \
   CONFIG.MC1_FLIPPED_PINOUT {true} \
   CONFIG.MC2_CONFIG_NUM {config26} \
   CONFIG.MC3_CONFIG_NUM {config26} \
   CONFIG.MC_ADDR_BIT9 {CA6} \
   CONFIG.MC_ADDR_WIDTH {6} \
   CONFIG.MC_BA_WIDTH {3} \
   CONFIG.MC_BG_WIDTH {0} \
   CONFIG.MC_BURST_LENGTH {16} \
   CONFIG.MC_CASLATENCY {36} \
   CONFIG.MC_CASWRITELATENCY {18} \
   CONFIG.MC_CH1_LP4_CHB_ENABLE {true} \
   CONFIG.MC_CHANNEL_INTERLEAVING {true} \
   CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
   CONFIG.MC_CH_INTERLEAVING_SIZE {64_Bytes} \
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
   CONFIG.MC_F1_LPDDR4_MR11 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR13 {0x00C0} \
   CONFIG.MC_F1_LPDDR4_MR22 {0x0000} \
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
   CONFIG.MC_F1_TWRMIN {18000} \
   CONFIG.MC_F1_TWTR {10000} \
   CONFIG.MC_F1_TWTRMIN {10000} \
   CONFIG.MC_F1_TWTR_L {0} \
   CONFIG.MC_F1_TWTR_L_MIN {0} \
   CONFIG.MC_F1_TWTR_S {0} \
   CONFIG.MC_F1_TWTR_S_MIN {0} \
   CONFIG.MC_F1_TZQLAT {30000} \
   CONFIG.MC_F1_TZQLATMIN {30000} \
   CONFIG.MC_INIT_MEM_USING_ECC_SCRUB {false} \
   CONFIG.MC_INPUTCLK0_PERIOD {4963} \
   CONFIG.MC_INPUT_FREQUENCY0 {201.501} \
   CONFIG.MC_INTERLEAVE_SIZE {4096} \
   CONFIG.MC_IP_TIMEPERIOD0_FOR_OP {1071} \
   CONFIG.MC_LP4_RESETN_WIDTH {1} \
   CONFIG.MC_MEMORY_DENSITY {2GB} \
   CONFIG.MC_MEMORY_DEVICE_DENSITY {16Gb} \
   CONFIG.MC_MEMORY_SPEEDGRADE {LPDDR4-4267} \
   CONFIG.MC_MEMORY_TIMEPERIOD0 {509} \
   CONFIG.MC_MEMORY_TIMEPERIOD1 {509} \
   CONFIG.MC_MEM_DEVICE_WIDTH {x32} \
   CONFIG.MC_NO_CHANNELS {Dual} \
   CONFIG.MC_ODTLon {8} \
   CONFIG.MC_PER_RD_INTVL {0} \
   CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN} \
   CONFIG.MC_REFRESH_SPEED {1x} \
   CONFIG.MC_TCCD_L {0} \
   CONFIG.MC_TCKE {15} \
   CONFIG.MC_TCKEMIN {15} \
   CONFIG.MC_TFAW {30000} \
   CONFIG.MC_TFAWMIN {30000} \
   CONFIG.MC_TMOD {0} \
   CONFIG.MC_TMPRR {0} \
   CONFIG.MC_TMRD {14000} \
   CONFIG.MC_TMRDMIN {14000} \
   CONFIG.MC_TMRD_div4 {10} \
   CONFIG.MC_TMRW {10000} \
   CONFIG.MC_TMRW_div4 {10} \
   CONFIG.MC_TODTon_MIN {3} \
   CONFIG.MC_TOSCO {40000} \
   CONFIG.MC_TPBR2PBR {90000} \
   CONFIG.MC_TRAS {42000} \
   CONFIG.MC_TRC {63000} \
   CONFIG.MC_TRCD {18000} \
   CONFIG.MC_TREFI {3904000} \
   CONFIG.MC_TREFIPB {488000} \
   CONFIG.MC_TRFC {0} \
   CONFIG.MC_TRFCAB {280000} \
   CONFIG.MC_TRFCMIN {0} \
   CONFIG.MC_TRFCPB {140000} \
   CONFIG.MC_TRFCPBMIN {140000} \
   CONFIG.MC_TRP {0} \
   CONFIG.MC_TRPAB {21000} \
   CONFIG.MC_TRPMIN {0} \
   CONFIG.MC_TRPPB {18000} \
   CONFIG.MC_TRPRE {1.8} \
   CONFIG.MC_TRRD {7500} \
   CONFIG.MC_TRRD_L {0} \
   CONFIG.MC_TRRD_S {0} \
   CONFIG.MC_TRRD_S_MIN {0} \
   CONFIG.MC_TRTP_nCK {16} \
   CONFIG.MC_TWPRE {1.8} \
   CONFIG.MC_TWPST {0.4} \
   CONFIG.MC_TWR {18000} \
   CONFIG.MC_TWTR {10000} \
   CONFIG.MC_TWTR_L {0} \
   CONFIG.MC_TWTR_S {0} \
   CONFIG.MC_TWTR_S_MIN {0} \
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
   CONFIG.NUM_CLKS {9} \
   CONFIG.NUM_MC {2} \
   CONFIG.NUM_MCP {4} \
   CONFIG.NUM_MI {28} \
   CONFIG.NUM_SI {36} \
 ] $axi_noc_0

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x202_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x202_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x202_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x202_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x203_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x203_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M09_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x203_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M10_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x203_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M11_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x204_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M12_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x204_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M13_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x304_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M14_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x304_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M15_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x305_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M16_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x305_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M17_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x305_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M18_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x305_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M19_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x306_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M20_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x306_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M21_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x306_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M22_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x306_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M23_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x307_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M24_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x307_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M25_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x307_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M26_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x307_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/M27_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {BEST_EFFORT} \
   CONFIG.W_TRAFFIC_CLASS {BEST_EFFORT} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {860} write_bw {860} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]
   #CONFIG.DEST_IDS {M03_AXI:0xdc0:M08_AXI:0xd80:M01_AXI:0xd40:M06_AXI:0xd00:M12_AXI:0xbc0:M10_AXI:0xb80:M04_AXI:0xb40:M02_AXI:0xb00:M00_AXI:0x9c0:M13_AXI:0x940:M05_AXI:0x980:M11_AXI:0x900:M07_AXI:0x7c0:M09_AXI:0x780} \

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]
   #CONFIG.DEST_IDS {M27_AXI:0x740:M19_AXI:0x700:M14_AXI:0x5c0:M16_AXI:0x580:M25_AXI:0x540:M23_AXI:0x500:M21_AXI:0x3c0:M15_AXI:0x380:M26_AXI:0x340:M17_AXI:0x300:M24_AXI:0x81:M18_AXI:0x1c0:M20_AXI:0x41:M22_AXI:0x1} \

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M08_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {860} write_bw {860} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M06_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M12_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M10_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M04_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M02_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M13_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M05_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M11_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M07_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M09_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M03_AXI:0xdc0:M08_AXI:0xd80:M01_AXI:0xd40:M06_AXI:0xd00:M12_AXI:0xbc0:M10_AXI:0xb80:M04_AXI:0xb40:M02_AXI:0xb00:M00_AXI:0x9c0:M13_AXI:0x980:M05_AXI:0x940:M11_AXI:0x900:M07_AXI:0x7c0:M09_AXI:0x780} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M27_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {860} write_bw {860} read_avg_burst {4} write_avg_burst {4}} M19_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M14_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M16_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M25_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M23_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M21_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M15_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M26_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M17_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M24_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M18_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M20_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} M22_AXI { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M27_AXI:0x740:M19_AXI:0x700:M14_AXI:0x5c0:M16_AXI:0x580:M25_AXI:0x540:M23_AXI:0x500:M21_AXI:0x3c0:M15_AXI:0x380:M26_AXI:0x340:M17_AXI:0x300:M24_AXI:0x1c0:M18_AXI:0x81:M20_AXI:0x41:M22_AXI:0x1} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]
   #CONFIG.DEST_IDS {M03_AXI:0xdc0:M08_AXI:0xd80:M01_AXI:0xd40:M06_AXI:0xd00:M12_AXI:0xbc0:M10_AXI:0xb80:M04_AXI:0xb40:M02_AXI:0xb00:M00_AXI:0x9c0:M13_AXI:0x940:M05_AXI:0x980:M11_AXI:0x900:M07_AXI:0x7c0:M09_AXI:0x780} \

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {220} write_bw {220} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]
   #CONFIG.DEST_IDS {M27_AXI:0x740:M19_AXI:0x700:M14_AXI:0x5c0:M16_AXI:0x580:M25_AXI:0x540:M23_AXI:0x500:M21_AXI:0x3c0:M15_AXI:0x380:M26_AXI:0x340:M17_AXI:0x300:M24_AXI:0x81:M18_AXI:0x1c0:M20_AXI:0x41:M22_AXI:0x1} \

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S10_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S11_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S12_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S13_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S14_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S15_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S16_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S17_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S18_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S19_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S20_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S21_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S22_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S23_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S24_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S25_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S26_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S27_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S28_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S29_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S30_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S31_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S32_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {860} write_bw {1040} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S33_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {860} write_bw {860} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S34_AXI]
   #CONFIG.DEST_IDS {M03_AXI:0xdc0:M08_AXI:0xd80:M01_AXI:0xd40:M06_AXI:0xd00:M12_AXI:0xbc0:M10_AXI:0xb80:M04_AXI:0xb40:M02_AXI:0xb00:M00_AXI:0x9c0:M05_AXI:0x980:M13_AXI:0x940:M11_AXI:0x900:M07_AXI:0x7c0:M09_AXI:0x780} \

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {860} write_bw {860} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S35_AXI]
   #CONFIG.DEST_IDS {M27_AXI:0x740:M19_AXI:0x700:M14_AXI:0x5c0:M16_AXI:0x580:M25_AXI:0x540:M23_AXI:0x500:M21_AXI:0x3c0:M15_AXI:0x380:M26_AXI:0x340:M17_AXI:0x300:M18_AXI:0x1c0:M24_AXI:0x81:M20_AXI:0x41:M22_AXI:0x1} \

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:M01_AXI:M02_AXI:M03_AXI:M04_AXI:M05_AXI:M06_AXI:M07_AXI:M08_AXI:M09_AXI:M10_AXI:M11_AXI:M12_AXI:M13_AXI:M14_AXI:M15_AXI:M16_AXI:M17_AXI:M18_AXI:M19_AXI:M20_AXI:M21_AXI:M22_AXI:M23_AXI:M24_AXI:M25_AXI:M26_AXI:M27_AXI:S06_AXI:S07_AXI:S08_AXI:S09_AXI:S10_AXI:S11_AXI:S12_AXI:S13_AXI:S14_AXI:S15_AXI:S16_AXI:S17_AXI:S18_AXI:S19_AXI:S20_AXI:S21_AXI:S22_AXI:S23_AXI:S24_AXI:S25_AXI:S26_AXI:S27_AXI:S28_AXI:S29_AXI:S30_AXI:S31_AXI:S32_AXI:S33_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S34_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S35_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk8]

#  # Create instance: axi_register_slice_0, and set properties
#  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
#
#  # Create instance: axi_register_slice_1, and set properties
#  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
#
#  # Create instance: axi_register_slice_2, and set properties
#  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
#
#  # Create instance: axi_register_slice_3, and set properties
#  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
#
#  # Create instance: axi_register_slice_4, and set properties
#  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
#
#  # Create instance: axi_register_slice_5, and set properties
#  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
#
#  # Create instance: axi_register_slice_6, and set properties
#  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
#
#  # Create instance: axi_register_slice_7, and set properties
#  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
#
#  # Create instance: axi_register_slice_8, and set properties
#  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
#
#  # Create instance: axi_register_slice_9, and set properties
#  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
#
#  # Create instance: axi_register_slice_10, and set properties
#  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
#
#  # Create instance: axi_register_slice_11, and set properties
#  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
#
#  # Create instance: axi_register_slice_12, and set properties
#  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
#
#  # Create instance: axi_register_slice_13, and set properties
#  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
#
#  # Create instance: axi_register_slice_14, and set properties
#  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
#
#  # Create instance: axi_register_slice_15, and set properties
#  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
#
#  # Create instance: axi_register_slice_16, and set properties
#  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
#
#  # Create instance: axi_register_slice_17, and set properties
#  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
#
#  # Create instance: axi_register_slice_18, and set properties
#  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
#
#  # Create instance: axi_register_slice_19, and set properties
#  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
#
#  # Create instance: axi_register_slice_20, and set properties
#  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
#
#  # Create instance: axi_register_slice_21, and set properties
#  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
#
#  # Create instance: axi_register_slice_22, and set properties
#  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
#
#  # Create instance: axi_register_slice_23, and set properties
#  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
#
#  # Create instance: axi_register_slice_24, and set properties
#  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
#
#  # Create instance: axi_register_slice_25, and set properties
#  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
#
#  # Create instance: axi_register_slice_26, and set properties
#  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
#
#  # Create instance: axi_register_slice_27, and set properties
#  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
#
#  # Create instance: axi_register_slice_28, and set properties
#  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
#
#  # Create instance: axi_register_slice_29, and set properties
#  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
#
#  # Create instance: axi_register_slice_30, and set properties
#  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
#
#  # Create instance: axi_register_slice_31, and set properties
#  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
#
#  # Create instance: axi_register_slice_32, and set properties
#  set axi_register_slice_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_32 ]
#
#  # Create instance: axi_register_slice_33, and set properties
#  set axi_register_slice_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_33 ]
#
#  # Create instance: axi_register_slice_34, and set properties
#  set axi_register_slice_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_34 ]
#
#  # Create instance: axi_register_slice_35, and set properties
#  set axi_register_slice_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_35 ]
#
#  # Create instance: axi_register_slice_36, and set properties
#  set axi_register_slice_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_36 ]
#
#  # Create instance: axi_register_slice_37, and set properties
#  set axi_register_slice_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_37 ]
#
#  # Create instance: axi_register_slice_38, and set properties
#  set axi_register_slice_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_38 ]
#
#  # Create instance: axi_register_slice_39, and set properties
#  set axi_register_slice_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_39 ]
#
#  # Create instance: axi_register_slice_40, and set properties
#  set axi_register_slice_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_40 ]
#
#  # Create instance: axi_register_slice_41, and set properties
#  set axi_register_slice_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_41 ]
#
#  # Create instance: axi_register_slice_42, and set properties
#  set axi_register_slice_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_42 ]
#
#  # Create instance: axi_register_slice_43, and set properties
#  set axi_register_slice_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_43 ]
#
#  # Create instance: axi_register_slice_44, and set properties
#  set axi_register_slice_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_44 ]
#
#  # Create instance: axi_register_slice_45, and set properties
#  set axi_register_slice_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_45 ]
#
#  # Create instance: axi_register_slice_46, and set properties
#  set axi_register_slice_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_46 ]
#
#  # Create instance: axi_register_slice_47, and set properties
#  set axi_register_slice_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_47 ]
#
#  # Create instance: axi_register_slice_48, and set properties
#  set axi_register_slice_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_48 ]
#
#  # Create instance: axi_register_slice_49, and set properties
#  set axi_register_slice_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_49 ]
#
#  # Create instance: axi_register_slice_50, and set properties
#  set axi_register_slice_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_50 ]
#
#  # Create instance: axi_register_slice_51, and set properties
#  set axi_register_slice_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_51 ]
#
#  # Create instance: axi_register_slice_52, and set properties
#  set axi_register_slice_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_52 ]
#
#  # Create instance: axi_register_slice_53, and set properties
#  set axi_register_slice_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_53 ]
#
#  # Create instance: axi_register_slice_54, and set properties
#  set axi_register_slice_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_54 ]
#
#  # Create instance: axi_register_slice_55, and set properties
#  set axi_register_slice_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_55 ]
#
#  # Create instance: axi_register_slice_56, and set properties
#  set axi_register_slice_56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_56 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
#   CONFIG.REG_R {1} \
#   CONFIG.REG_W {1} \
# ] $axi_register_slice_56
#
#  # Create instance: axi_register_slice_57, and set properties
#  set axi_register_slice_57 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_57 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_57
#
#  # Create instance: axi_register_slice_58, and set properties
#  set axi_register_slice_58 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_58 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_58
#
#  # Create instance: axi_register_slice_59, and set properties
#  set axi_register_slice_59 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_59 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_59
#
#  # Create instance: axi_register_slice_60, and set properties
#  set axi_register_slice_60 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_60 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_60
#
#  # Create instance: axi_register_slice_61, and set properties
#  set axi_register_slice_61 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_61 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_61
#
#  # Create instance: axi_register_slice_62, and set properties
#  set axi_register_slice_62 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_62 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_62
#
#  # Create instance: axi_register_slice_63, and set properties
#  set axi_register_slice_63 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_63 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_63
#
#  # Create instance: axi_register_slice_64, and set properties
#  set axi_register_slice_64 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_64 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_64
#
#  # Create instance: axi_register_slice_65, and set properties
#  set axi_register_slice_65 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_65 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_65
#
#  # Create instance: axi_register_slice_66, and set properties
#  set axi_register_slice_66 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_66 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_66
#
#  # Create instance: axi_register_slice_67, and set properties
#  set axi_register_slice_67 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_67 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_67
#
#  # Create instance: axi_register_slice_68, and set properties
#  set axi_register_slice_68 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_68 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_68
#
#  # Create instance: axi_register_slice_69, and set properties
#  set axi_register_slice_69 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_69 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_69
#
#  # Create instance: axi_register_slice_70, and set properties
#  set axi_register_slice_70 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_70 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_70
#
#  # Create instance: axi_register_slice_71, and set properties
#  set axi_register_slice_71 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_71 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_71
#
#  # Create instance: axi_register_slice_72, and set properties
#  set axi_register_slice_72 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_72 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_72
#
#  # Create instance: axi_register_slice_73, and set properties
#  set axi_register_slice_73 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_73 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_73
#
#  # Create instance: axi_register_slice_74, and set properties
#  set axi_register_slice_74 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_74 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_74
#
#  # Create instance: axi_register_slice_75, and set properties
#  set axi_register_slice_75 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_75 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_75
#
#  # Create instance: axi_register_slice_76, and set properties
#  set axi_register_slice_76 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_76 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_76
#
#  # Create instance: axi_register_slice_77, and set properties
#  set axi_register_slice_77 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_77 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_77
#
#  # Create instance: axi_register_slice_78, and set properties
#  set axi_register_slice_78 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_78 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_78
#
#  # Create instance: axi_register_slice_79, and set properties
#  set axi_register_slice_79 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_79 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_79
#
#  # Create instance: axi_register_slice_80, and set properties
#  set axi_register_slice_80 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_80 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_80
#
#  # Create instance: axi_register_slice_81, and set properties
#  set axi_register_slice_81 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_81 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_81
#
#  # Create instance: axi_register_slice_82, and set properties
#  set axi_register_slice_82 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_82 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_82
#
#  # Create instance: axi_register_slice_83, and set properties
#  set axi_register_slice_83 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_83 ]
#  set_property -dict [ list \
#   CONFIG.ID_WIDTH {2} \
#   CONFIG.PROTOCOL {AXI4} \
# ] $axi_register_slice_83

  # Create instance: kmeans_top_0, and set properties
  set kmeans_top_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_0 ]

  # Create instance: kmeans_top_1, and set properties
  set kmeans_top_1 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_1 ]

  # Create instance: kmeans_top_2, and set properties
  set kmeans_top_2 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_2 ]

  # Create instance: kmeans_top_3, and set properties
  set kmeans_top_3 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_3 ]

  # Create instance: kmeans_top_4, and set properties
  set kmeans_top_4 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_4 ]

  # Create instance: kmeans_top_5, and set properties
  set kmeans_top_5 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_5 ]

  # Create instance: kmeans_top_6, and set properties
  set kmeans_top_6 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_6 ]

  # Create instance: kmeans_top_7, and set properties
  set kmeans_top_7 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_7 ]

  # Create instance: kmeans_top_8, and set properties
  set kmeans_top_8 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_8 ]

  # Create instance: kmeans_top_9, and set properties
  set kmeans_top_9 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_9 ]

  # Create instance: kmeans_top_10, and set properties
  set kmeans_top_10 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_10 ]

  # Create instance: kmeans_top_11, and set properties
  set kmeans_top_11 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_11 ]

  # Create instance: kmeans_top_12, and set properties
  set kmeans_top_12 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_12 ]

  # Create instance: kmeans_top_13, and set properties
  set kmeans_top_13 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_13 ]

  # Create instance: kmeans_top_14, and set properties
  set kmeans_top_14 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_14 ]

  # Create instance: kmeans_top_15, and set properties
  set kmeans_top_15 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_15 ]

  # Create instance: kmeans_top_16, and set properties
  set kmeans_top_16 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_16 ]

  # Create instance: kmeans_top_17, and set properties
  set kmeans_top_17 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_17 ]

  # Create instance: kmeans_top_18, and set properties
  set kmeans_top_18 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_18 ]

  # Create instance: kmeans_top_19, and set properties
  set kmeans_top_19 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_19 ]

  # Create instance: kmeans_top_20, and set properties
  set kmeans_top_20 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_20 ]

  # Create instance: kmeans_top_21, and set properties
  set kmeans_top_21 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_21 ]

  # Create instance: kmeans_top_22, and set properties
  set kmeans_top_22 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_22 ]

  # Create instance: kmeans_top_23, and set properties
  set kmeans_top_23 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_23 ]

  # Create instance: kmeans_top_24, and set properties
  set kmeans_top_24 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_24 ]

  # Create instance: kmeans_top_25, and set properties
  set kmeans_top_25 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_25 ]

  # Create instance: kmeans_top_26, and set properties
  set kmeans_top_26 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_26 ]

  # Create instance: kmeans_top_27, and set properties
  set kmeans_top_27 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_27 ]

  # Create instance: kmeans_top_28, and set properties
  set kmeans_top_28 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_28 ]

  # Create instance: kmeans_top_29, and set properties
  set kmeans_top_29 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_29 ]

  # Create instance: kmeans_top_30, and set properties
  set kmeans_top_30 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_30 ]

  # Create instance: kmeans_top_31, and set properties
  set kmeans_top_31 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_31 ]

  # Create instance: kmeans_top_32, and set properties
  set kmeans_top_32 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_32 ]

  # Create instance: kmeans_top_33, and set properties
  set kmeans_top_33 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_33 ]

  # Create instance: kmeans_top_34, and set properties
  set kmeans_top_34 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_34 ]

  # Create instance: kmeans_top_35, and set properties
  set kmeans_top_35 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_35 ]

  # Create instance: kmeans_top_36, and set properties
  set kmeans_top_36 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_36 ]

  # Create instance: kmeans_top_37, and set properties
  set kmeans_top_37 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_37 ]

  # Create instance: kmeans_top_38, and set properties
  set kmeans_top_38 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_38 ]

  # Create instance: kmeans_top_39, and set properties
  set kmeans_top_39 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_39 ]

  # Create instance: kmeans_top_40, and set properties
  set kmeans_top_40 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_40 ]

  # Create instance: kmeans_top_41, and set properties
  set kmeans_top_41 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_41 ]

  # Create instance: kmeans_top_42, and set properties
  set kmeans_top_42 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_42 ]

  # Create instance: kmeans_top_43, and set properties
  set kmeans_top_43 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_43 ]

  # Create instance: kmeans_top_44, and set properties
  set kmeans_top_44 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_44 ]

  # Create instance: kmeans_top_45, and set properties
  set kmeans_top_45 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_45 ]

  # Create instance: kmeans_top_46, and set properties
  set kmeans_top_46 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_46 ]

  # Create instance: kmeans_top_47, and set properties
  set kmeans_top_47 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_47 ]

  # Create instance: kmeans_top_48, and set properties
  set kmeans_top_48 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_48 ]

  # Create instance: kmeans_top_49, and set properties
  set kmeans_top_49 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_49 ]

  # Create instance: kmeans_top_50, and set properties
  set kmeans_top_50 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_50 ]

  # Create instance: kmeans_top_51, and set properties
  set kmeans_top_51 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_51 ]

  # Create instance: kmeans_top_52, and set properties
  set kmeans_top_52 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_52 ]

  # Create instance: kmeans_top_53, and set properties
  set kmeans_top_53 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_53 ]

  # Create instance: kmeans_top_54, and set properties
  set kmeans_top_54 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_54 ]

  # Create instance: kmeans_top_55, and set properties
  set kmeans_top_55 [ create_bd_cell -type ip -vlnv xilinx.com:hls:kmeans_top:1.0 kmeans_top_55 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]

  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]

  # Create instance: smartconnect_3, and set properties
  set smartconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_3 ]

  # Create instance: smartconnect_4, and set properties
  set smartconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_4 ]

  # Create instance: smartconnect_5, and set properties
  set smartconnect_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_5 ]

  # Create instance: smartconnect_6, and set properties
  set smartconnect_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_6 ]

  # Create instance: smartconnect_7, and set properties
  set smartconnect_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_7 ]

  # Create instance: smartconnect_8, and set properties
  set smartconnect_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_8 ]

  # Create instance: smartconnect_9, and set properties
  set smartconnect_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_9 ]

  # Create instance: smartconnect_10, and set properties
  set smartconnect_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_10 ]

  # Create instance: smartconnect_11, and set properties
  set smartconnect_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_11 ]

  # Create instance: smartconnect_12, and set properties
  set smartconnect_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_12 ]

  # Create instance: smartconnect_13, and set properties
  set smartconnect_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_13 ]

  # Create instance: smartconnect_14, and set properties
  set smartconnect_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_14 ]

  # Create instance: smartconnect_15, and set properties
  set smartconnect_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_15 ]

  # Create instance: smartconnect_16, and set properties
  set smartconnect_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_16 ]

  # Create instance: smartconnect_17, and set properties
  set smartconnect_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_17 ]

  # Create instance: smartconnect_18, and set properties
  set smartconnect_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_18 ]

  # Create instance: smartconnect_19, and set properties
  set smartconnect_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_19 ]

  # Create instance: smartconnect_20, and set properties
  set smartconnect_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_20 ]

  # Create instance: smartconnect_21, and set properties
  set smartconnect_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_21 ]

  # Create instance: smartconnect_22, and set properties
  set smartconnect_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_22 ]

  # Create instance: smartconnect_23, and set properties
  set smartconnect_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_23 ]

  # Create instance: smartconnect_24, and set properties
  set smartconnect_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_24 ]

  # Create instance: smartconnect_25, and set properties
  set smartconnect_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_25 ]

  # Create instance: smartconnect_26, and set properties
  set smartconnect_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_26 ]

  # Create instance: smartconnect_27, and set properties
  set smartconnect_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_27 ]

  # Create instance: smartconnect_28, and set properties
  set smartconnect_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_28 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_28

  # Create instance: smartconnect_29, and set properties
  set smartconnect_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_29 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_29

  # Create instance: smartconnect_30, and set properties
  set smartconnect_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_30 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_30

  # Create instance: smartconnect_31, and set properties
  set smartconnect_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_31 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_31

  # Create instance: smartconnect_32, and set properties
  set smartconnect_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_32 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_32

  # Create instance: smartconnect_33, and set properties
  set smartconnect_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_33 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_33

  # Create instance: smartconnect_34, and set properties
  set smartconnect_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_34 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_34

  # Create instance: smartconnect_35, and set properties
  set smartconnect_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_35 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_35

  # Create instance: smartconnect_36, and set properties
  set smartconnect_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_36 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_36

  # Create instance: smartconnect_37, and set properties
  set smartconnect_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_37 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_37

  # Create instance: smartconnect_38, and set properties
  set smartconnect_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_38 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_38

  # Create instance: smartconnect_39, and set properties
  set smartconnect_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_39 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_39

  # Create instance: smartconnect_40, and set properties
  set smartconnect_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_40 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_40

  # Create instance: smartconnect_41, and set properties
  set smartconnect_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_41 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_41

  # Create instance: smartconnect_42, and set properties
  set smartconnect_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_42 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_42

  # Create instance: smartconnect_43, and set properties
  set smartconnect_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_43 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_43

  # Create instance: smartconnect_44, and set properties
  set smartconnect_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_44 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_44

  # Create instance: smartconnect_45, and set properties
  set smartconnect_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_45 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_45

  # Create instance: smartconnect_46, and set properties
  set smartconnect_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_46 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_46

  # Create instance: smartconnect_47, and set properties
  set smartconnect_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_47 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_47

  # Create instance: smartconnect_48, and set properties
  set smartconnect_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_48 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_48

  # Create instance: smartconnect_49, and set properties
  set smartconnect_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_49 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_49

  # Create instance: smartconnect_50, and set properties
  set smartconnect_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_50 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_50

  # Create instance: smartconnect_51, and set properties
  set smartconnect_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_51 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_51

  # Create instance: smartconnect_52, and set properties
  set smartconnect_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_52 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_52

  # Create instance: smartconnect_53, and set properties
  set smartconnect_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_53 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_53

  # Create instance: smartconnect_54, and set properties
  set smartconnect_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_54 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_54

  # Create instance: smartconnect_55, and set properties
  set smartconnect_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_55 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_55

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_0

  # Create instance: util_reduced_logic_1, and set properties
  set util_reduced_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_1

  # Create instance: util_reduced_logic_2, and set properties
  set util_reduced_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_2

  # Create instance: util_reduced_logic_3, and set properties
  set util_reduced_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_3 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_3

  # Create instance: util_reduced_logic_4, and set properties
  set util_reduced_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_4 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_4

  # Create instance: util_reduced_logic_5, and set properties
  set util_reduced_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_5 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_5

  # Create instance: util_reduced_logic_6, and set properties
  set util_reduced_logic_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_6 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_6

  # Create instance: util_reduced_logic_7, and set properties
  set util_reduced_logic_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_7 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_7

  # Create instance: util_reduced_logic_8, and set properties
  set util_reduced_logic_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_8 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_8

  # Create instance: util_reduced_logic_9, and set properties
  set util_reduced_logic_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_9 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_9

  # Create instance: util_reduced_logic_10, and set properties
  set util_reduced_logic_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_10 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_10

  # Create instance: util_reduced_logic_11, and set properties
  set util_reduced_logic_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_11 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_11

  # Create instance: util_reduced_logic_12, and set properties
  set util_reduced_logic_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_12 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_12

  # Create instance: util_reduced_logic_13, and set properties
  set util_reduced_logic_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_13 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {or} \
   CONFIG.C_SIZE {4} \
   CONFIG.LOGO_FILE {data/sym_orgate.png} \
 ] $util_reduced_logic_13

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:2.1 versal_cips_0 ]
  set_property -dict [ list \
   CONFIG.PMC_CRP_PL0_REF_CTRL_FREQMHZ {200} \
   CONFIG.PMC_MIO_37_DIRECTION {out} \
   CONFIG.PMC_MIO_37_OUTPUT_DATA {high} \
   CONFIG.PMC_MIO_37_USAGE {GPIO} \
   CONFIG.PMC_MIO_43_DIRECTION {out} \
   CONFIG.PMC_MIO_43_SCHMITT {1} \
   CONFIG.PMC_MIO_46_DIRECTION {out} \
   CONFIG.PMC_MIO_46_SCHMITT {1} \
   CONFIG.PMC_MIO_TREE_PERIPHERALS {##########################################UART 0#UART 0###UART 1#UART 1##############################} \
   CONFIG.PMC_MIO_TREE_SIGNALS {##########################################rxd#txd###txd#rxd##############################} \
   CONFIG.PMC_USE_PMC_NOC_AXI0 {1} \
   CONFIG.PS_NUM_FABRIC_RESETS {1} \
   CONFIG.PS_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART0_PERIPHERAL_IO {PMC_MIO 42 .. 43} \
   CONFIG.PS_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART1_PERIPHERAL_IO {PMC_MIO 46 .. 47} \
   CONFIG.PS_USE_IRQ_0 {1} \
   CONFIG.PS_USE_IRQ_1 {1} \
   CONFIG.PS_USE_IRQ_2 {1} \
   CONFIG.PS_USE_IRQ_3 {1} \
   CONFIG.PS_USE_IRQ_4 {1} \
   CONFIG.PS_USE_IRQ_5 {1} \
   CONFIG.PS_USE_IRQ_6 {1} \
   CONFIG.PS_USE_IRQ_7 {1} \
   CONFIG.PS_USE_IRQ_8 {1} \
   CONFIG.PS_USE_IRQ_9 {1} \
   CONFIG.PS_USE_IRQ_10 {1} \
   CONFIG.PS_USE_IRQ_11 {1} \
   CONFIG.PS_USE_IRQ_12 {1} \
   CONFIG.PS_USE_IRQ_13 {1} \
   CONFIG.PS_USE_PMCPL_CLK0 {1} \
   CONFIG.PS_USE_PS_NOC_CCI {1} \
   CONFIG.PS_USE_PS_NOC_NCI_0 {1} \
   CONFIG.PS_USE_PS_NOC_NCI_1 {1} \
   CONFIG.PS_USE_PS_NOC_RPU_0 {1} \
 ] $versal_cips_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_2

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_3

  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_4

  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_5

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_6

  # Create instance: xlconcat_7, and set properties
  set xlconcat_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_7 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_7

  # Create instance: xlconcat_8, and set properties
  set xlconcat_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_8 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_8

  # Create instance: xlconcat_9, and set properties
  set xlconcat_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_9 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_9

  # Create instance: xlconcat_10, and set properties
  set xlconcat_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_10 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_10

  # Create instance: xlconcat_11, and set properties
  set xlconcat_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_11 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_11

  # Create instance: xlconcat_12, and set properties
  set xlconcat_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_12 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_12

  # Create instance: xlconcat_13, and set properties
  set xlconcat_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_13 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {4} \
 ] $xlconcat_13

  # Create interface connections
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1 [get_bd_intf_ports CH0_LPDDR4_1] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1 [get_bd_intf_ports CH1_LPDDR4_1] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_3 [get_bd_intf_ports CH0_LPDDR4_3] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_3 [get_bd_intf_ports CH1_LPDDR4_3] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_M00_AXI [get_bd_intf_pins axi_noc_0/M00_AXI] [get_bd_intf_pins smartconnect_28/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M01_AXI [get_bd_intf_pins axi_noc_0/M01_AXI] [get_bd_intf_pins smartconnect_29/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M02_AXI [get_bd_intf_pins axi_noc_0/M02_AXI] [get_bd_intf_pins smartconnect_30/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M03_AXI [get_bd_intf_pins axi_noc_0/M03_AXI] [get_bd_intf_pins smartconnect_31/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M04_AXI [get_bd_intf_pins axi_noc_0/M04_AXI] [get_bd_intf_pins smartconnect_32/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M05_AXI [get_bd_intf_pins axi_noc_0/M05_AXI] [get_bd_intf_pins smartconnect_33/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M06_AXI [get_bd_intf_pins axi_noc_0/M06_AXI] [get_bd_intf_pins smartconnect_34/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M07_AXI [get_bd_intf_pins axi_noc_0/M07_AXI] [get_bd_intf_pins smartconnect_35/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M08_AXI [get_bd_intf_pins axi_noc_0/M08_AXI] [get_bd_intf_pins smartconnect_36/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M09_AXI [get_bd_intf_pins axi_noc_0/M09_AXI] [get_bd_intf_pins smartconnect_37/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M10_AXI [get_bd_intf_pins axi_noc_0/M10_AXI] [get_bd_intf_pins smartconnect_38/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M11_AXI [get_bd_intf_pins axi_noc_0/M11_AXI] [get_bd_intf_pins smartconnect_39/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M12_AXI [get_bd_intf_pins axi_noc_0/M12_AXI] [get_bd_intf_pins smartconnect_40/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M13_AXI [get_bd_intf_pins axi_noc_0/M13_AXI] [get_bd_intf_pins smartconnect_41/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M14_AXI [get_bd_intf_pins axi_noc_0/M14_AXI] [get_bd_intf_pins smartconnect_42/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M15_AXI [get_bd_intf_pins axi_noc_0/M15_AXI] [get_bd_intf_pins smartconnect_43/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M16_AXI [get_bd_intf_pins axi_noc_0/M16_AXI] [get_bd_intf_pins smartconnect_44/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M17_AXI [get_bd_intf_pins axi_noc_0/M17_AXI] [get_bd_intf_pins smartconnect_45/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M18_AXI [get_bd_intf_pins axi_noc_0/M18_AXI] [get_bd_intf_pins smartconnect_46/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M19_AXI [get_bd_intf_pins axi_noc_0/M19_AXI] [get_bd_intf_pins smartconnect_47/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M20_AXI [get_bd_intf_pins axi_noc_0/M20_AXI] [get_bd_intf_pins smartconnect_48/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M21_AXI [get_bd_intf_pins axi_noc_0/M21_AXI] [get_bd_intf_pins smartconnect_49/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M22_AXI [get_bd_intf_pins axi_noc_0/M22_AXI] [get_bd_intf_pins smartconnect_50/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M23_AXI [get_bd_intf_pins axi_noc_0/M23_AXI] [get_bd_intf_pins smartconnect_51/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M24_AXI [get_bd_intf_pins axi_noc_0/M24_AXI] [get_bd_intf_pins smartconnect_52/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M25_AXI [get_bd_intf_pins axi_noc_0/M25_AXI] [get_bd_intf_pins smartconnect_53/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M26_AXI [get_bd_intf_pins axi_noc_0/M26_AXI] [get_bd_intf_pins smartconnect_54/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M27_AXI [get_bd_intf_pins axi_noc_0/M27_AXI] [get_bd_intf_pins smartconnect_55/S00_AXI]
  connect_bd_intf_net -intf_net kmeans_top_0_m_axi_mem [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins kmeans_top_0/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_1_m_axi_mem [get_bd_intf_pins smartconnect_0/S01_AXI] [get_bd_intf_pins kmeans_top_1/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_2_m_axi_mem [get_bd_intf_pins smartconnect_1/S00_AXI] [get_bd_intf_pins kmeans_top_2/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_3_m_axi_mem [get_bd_intf_pins smartconnect_1/S01_AXI] [get_bd_intf_pins kmeans_top_3/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_4_m_axi_mem [get_bd_intf_pins smartconnect_2/S00_AXI] [get_bd_intf_pins kmeans_top_4/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_5_m_axi_mem [get_bd_intf_pins smartconnect_2/S01_AXI] [get_bd_intf_pins kmeans_top_5/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_6_m_axi_mem [get_bd_intf_pins smartconnect_3/S00_AXI] [get_bd_intf_pins kmeans_top_6/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_7_m_axi_mem [get_bd_intf_pins smartconnect_3/S01_AXI] [get_bd_intf_pins kmeans_top_7/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_8_m_axi_mem [get_bd_intf_pins smartconnect_4/S00_AXI] [get_bd_intf_pins kmeans_top_8/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_9_m_axi_mem [get_bd_intf_pins smartconnect_4/S01_AXI] [get_bd_intf_pins kmeans_top_9/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_10_m_axi_mem [get_bd_intf_pins smartconnect_5/S00_AXI] [get_bd_intf_pins kmeans_top_10/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_11_m_axi_mem [get_bd_intf_pins smartconnect_5/S01_AXI] [get_bd_intf_pins kmeans_top_11/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_12_m_axi_mem [get_bd_intf_pins smartconnect_6/S00_AXI] [get_bd_intf_pins kmeans_top_12/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_13_m_axi_mem [get_bd_intf_pins smartconnect_6/S01_AXI] [get_bd_intf_pins kmeans_top_13/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_14_m_axi_mem [get_bd_intf_pins smartconnect_7/S00_AXI] [get_bd_intf_pins kmeans_top_14/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_15_m_axi_mem [get_bd_intf_pins smartconnect_7/S01_AXI] [get_bd_intf_pins kmeans_top_15/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_16_m_axi_mem [get_bd_intf_pins smartconnect_8/S00_AXI] [get_bd_intf_pins kmeans_top_16/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_17_m_axi_mem [get_bd_intf_pins smartconnect_8/S01_AXI] [get_bd_intf_pins kmeans_top_17/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_18_m_axi_mem [get_bd_intf_pins smartconnect_9/S00_AXI] [get_bd_intf_pins kmeans_top_18/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_19_m_axi_mem [get_bd_intf_pins smartconnect_9/S01_AXI] [get_bd_intf_pins kmeans_top_19/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_20_m_axi_mem [get_bd_intf_pins smartconnect_10/S00_AXI] [get_bd_intf_pins kmeans_top_20/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_21_m_axi_mem [get_bd_intf_pins smartconnect_10/S01_AXI] [get_bd_intf_pins kmeans_top_21/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_22_m_axi_mem [get_bd_intf_pins smartconnect_11/S00_AXI] [get_bd_intf_pins kmeans_top_22/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_23_m_axi_mem [get_bd_intf_pins smartconnect_11/S01_AXI] [get_bd_intf_pins kmeans_top_23/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_24_m_axi_mem [get_bd_intf_pins smartconnect_12/S00_AXI] [get_bd_intf_pins kmeans_top_24/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_25_m_axi_mem [get_bd_intf_pins smartconnect_12/S01_AXI] [get_bd_intf_pins kmeans_top_25/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_26_m_axi_mem [get_bd_intf_pins smartconnect_13/S00_AXI] [get_bd_intf_pins kmeans_top_26/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_27_m_axi_mem [get_bd_intf_pins smartconnect_13/S01_AXI] [get_bd_intf_pins kmeans_top_27/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_28_m_axi_mem [get_bd_intf_pins smartconnect_14/S00_AXI] [get_bd_intf_pins kmeans_top_28/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_29_m_axi_mem [get_bd_intf_pins smartconnect_14/S01_AXI] [get_bd_intf_pins kmeans_top_29/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_30_m_axi_mem [get_bd_intf_pins smartconnect_15/S00_AXI] [get_bd_intf_pins kmeans_top_30/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_31_m_axi_mem [get_bd_intf_pins smartconnect_15/S01_AXI] [get_bd_intf_pins kmeans_top_31/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_32_m_axi_mem [get_bd_intf_pins smartconnect_16/S00_AXI] [get_bd_intf_pins kmeans_top_32/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_33_m_axi_mem [get_bd_intf_pins smartconnect_16/S01_AXI] [get_bd_intf_pins kmeans_top_33/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_34_m_axi_mem [get_bd_intf_pins smartconnect_17/S00_AXI] [get_bd_intf_pins kmeans_top_34/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_35_m_axi_mem [get_bd_intf_pins smartconnect_17/S01_AXI] [get_bd_intf_pins kmeans_top_35/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_36_m_axi_mem [get_bd_intf_pins smartconnect_18/S00_AXI] [get_bd_intf_pins kmeans_top_36/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_37_m_axi_mem [get_bd_intf_pins smartconnect_18/S01_AXI] [get_bd_intf_pins kmeans_top_37/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_38_m_axi_mem [get_bd_intf_pins smartconnect_19/S00_AXI] [get_bd_intf_pins kmeans_top_38/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_39_m_axi_mem [get_bd_intf_pins smartconnect_19/S01_AXI] [get_bd_intf_pins kmeans_top_39/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_40_m_axi_mem [get_bd_intf_pins smartconnect_20/S00_AXI] [get_bd_intf_pins kmeans_top_40/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_41_m_axi_mem [get_bd_intf_pins smartconnect_20/S01_AXI] [get_bd_intf_pins kmeans_top_41/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_42_m_axi_mem [get_bd_intf_pins smartconnect_21/S00_AXI] [get_bd_intf_pins kmeans_top_42/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_43_m_axi_mem [get_bd_intf_pins smartconnect_21/S01_AXI] [get_bd_intf_pins kmeans_top_43/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_44_m_axi_mem [get_bd_intf_pins smartconnect_22/S00_AXI] [get_bd_intf_pins kmeans_top_44/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_45_m_axi_mem [get_bd_intf_pins smartconnect_22/S01_AXI] [get_bd_intf_pins kmeans_top_45/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_46_m_axi_mem [get_bd_intf_pins smartconnect_23/S00_AXI] [get_bd_intf_pins kmeans_top_46/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_47_m_axi_mem [get_bd_intf_pins smartconnect_23/S01_AXI] [get_bd_intf_pins kmeans_top_47/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_48_m_axi_mem [get_bd_intf_pins smartconnect_24/S00_AXI] [get_bd_intf_pins kmeans_top_48/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_49_m_axi_mem [get_bd_intf_pins smartconnect_24/S01_AXI] [get_bd_intf_pins kmeans_top_49/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_50_m_axi_mem [get_bd_intf_pins smartconnect_25/S00_AXI] [get_bd_intf_pins kmeans_top_50/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_51_m_axi_mem [get_bd_intf_pins smartconnect_25/S01_AXI] [get_bd_intf_pins kmeans_top_51/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_52_m_axi_mem [get_bd_intf_pins smartconnect_26/S00_AXI] [get_bd_intf_pins kmeans_top_52/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_53_m_axi_mem [get_bd_intf_pins smartconnect_26/S01_AXI] [get_bd_intf_pins kmeans_top_53/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_54_m_axi_mem [get_bd_intf_pins smartconnect_27/S00_AXI] [get_bd_intf_pins kmeans_top_54/m_axi_mem]
  connect_bd_intf_net -intf_net kmeans_top_55_m_axi_mem [get_bd_intf_pins smartconnect_27/S01_AXI] [get_bd_intf_pins kmeans_top_55/m_axi_mem]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_noc_0/S06_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_10_M00_AXI [get_bd_intf_pins axi_noc_0/S16_AXI] [get_bd_intf_pins smartconnect_10/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_11_M00_AXI [get_bd_intf_pins axi_noc_0/S17_AXI] [get_bd_intf_pins smartconnect_11/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_12_M00_AXI [get_bd_intf_pins axi_noc_0/S18_AXI] [get_bd_intf_pins smartconnect_12/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_13_M00_AXI [get_bd_intf_pins axi_noc_0/S19_AXI] [get_bd_intf_pins smartconnect_13/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_14_M00_AXI [get_bd_intf_pins axi_noc_0/S20_AXI] [get_bd_intf_pins smartconnect_14/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_15_M00_AXI [get_bd_intf_pins axi_noc_0/S21_AXI] [get_bd_intf_pins smartconnect_15/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_16_M00_AXI [get_bd_intf_pins axi_noc_0/S22_AXI] [get_bd_intf_pins smartconnect_16/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_17_M00_AXI [get_bd_intf_pins axi_noc_0/S23_AXI] [get_bd_intf_pins smartconnect_17/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_18_M00_AXI [get_bd_intf_pins axi_noc_0/S24_AXI] [get_bd_intf_pins smartconnect_18/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_19_M00_AXI [get_bd_intf_pins axi_noc_0/S25_AXI] [get_bd_intf_pins smartconnect_19/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_noc_0/S07_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_20_M00_AXI [get_bd_intf_pins axi_noc_0/S26_AXI] [get_bd_intf_pins smartconnect_20/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_21_M00_AXI [get_bd_intf_pins axi_noc_0/S27_AXI] [get_bd_intf_pins smartconnect_21/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_22_M00_AXI [get_bd_intf_pins axi_noc_0/S28_AXI] [get_bd_intf_pins smartconnect_22/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_23_M00_AXI [get_bd_intf_pins axi_noc_0/S29_AXI] [get_bd_intf_pins smartconnect_23/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_24_M00_AXI [get_bd_intf_pins axi_noc_0/S30_AXI] [get_bd_intf_pins smartconnect_24/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_25_M00_AXI [get_bd_intf_pins axi_noc_0/S31_AXI] [get_bd_intf_pins smartconnect_25/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_26_M00_AXI [get_bd_intf_pins axi_noc_0/S32_AXI] [get_bd_intf_pins smartconnect_26/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_27_M00_AXI [get_bd_intf_pins axi_noc_0/S33_AXI] [get_bd_intf_pins smartconnect_27/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_28_M00_AXI [get_bd_intf_pins kmeans_top_0/s_axi_cfg] [get_bd_intf_pins smartconnect_28/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_28_M01_AXI [get_bd_intf_pins kmeans_top_1/s_axi_cfg] [get_bd_intf_pins smartconnect_28/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_29_M00_AXI [get_bd_intf_pins kmeans_top_2/s_axi_cfg] [get_bd_intf_pins smartconnect_29/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_29_M01_AXI [get_bd_intf_pins kmeans_top_3/s_axi_cfg] [get_bd_intf_pins smartconnect_29/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_pins axi_noc_0/S08_AXI] [get_bd_intf_pins smartconnect_2/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_30_M00_AXI [get_bd_intf_pins kmeans_top_4/s_axi_cfg] [get_bd_intf_pins smartconnect_30/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_30_M01_AXI [get_bd_intf_pins kmeans_top_5/s_axi_cfg] [get_bd_intf_pins smartconnect_30/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_31_M00_AXI [get_bd_intf_pins kmeans_top_6/s_axi_cfg] [get_bd_intf_pins smartconnect_31/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_31_M01_AXI [get_bd_intf_pins kmeans_top_7/s_axi_cfg] [get_bd_intf_pins smartconnect_31/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_32_M00_AXI [get_bd_intf_pins kmeans_top_8/s_axi_cfg] [get_bd_intf_pins smartconnect_32/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_32_M01_AXI [get_bd_intf_pins kmeans_top_9/s_axi_cfg] [get_bd_intf_pins smartconnect_32/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_33_M00_AXI [get_bd_intf_pins kmeans_top_10/s_axi_cfg] [get_bd_intf_pins smartconnect_33/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_33_M01_AXI [get_bd_intf_pins kmeans_top_11/s_axi_cfg] [get_bd_intf_pins smartconnect_33/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_34_M00_AXI [get_bd_intf_pins kmeans_top_12/s_axi_cfg] [get_bd_intf_pins smartconnect_34/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_34_M01_AXI [get_bd_intf_pins kmeans_top_13/s_axi_cfg] [get_bd_intf_pins smartconnect_34/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_35_M00_AXI [get_bd_intf_pins kmeans_top_14/s_axi_cfg] [get_bd_intf_pins smartconnect_35/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_35_M01_AXI [get_bd_intf_pins kmeans_top_15/s_axi_cfg] [get_bd_intf_pins smartconnect_35/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_36_M00_AXI [get_bd_intf_pins kmeans_top_16/s_axi_cfg] [get_bd_intf_pins smartconnect_36/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_36_M01_AXI [get_bd_intf_pins kmeans_top_17/s_axi_cfg] [get_bd_intf_pins smartconnect_36/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_37_M00_AXI [get_bd_intf_pins kmeans_top_18/s_axi_cfg] [get_bd_intf_pins smartconnect_37/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_37_M01_AXI [get_bd_intf_pins kmeans_top_19/s_axi_cfg] [get_bd_intf_pins smartconnect_37/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_38_M00_AXI [get_bd_intf_pins kmeans_top_20/s_axi_cfg] [get_bd_intf_pins smartconnect_38/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_38_M01_AXI [get_bd_intf_pins kmeans_top_21/s_axi_cfg] [get_bd_intf_pins smartconnect_38/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_39_M00_AXI [get_bd_intf_pins kmeans_top_22/s_axi_cfg] [get_bd_intf_pins smartconnect_39/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_39_M01_AXI [get_bd_intf_pins kmeans_top_23/s_axi_cfg] [get_bd_intf_pins smartconnect_39/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M00_AXI [get_bd_intf_pins axi_noc_0/S09_AXI] [get_bd_intf_pins smartconnect_3/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_40_M00_AXI [get_bd_intf_pins kmeans_top_24/s_axi_cfg] [get_bd_intf_pins smartconnect_40/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_40_M01_AXI [get_bd_intf_pins kmeans_top_25/s_axi_cfg] [get_bd_intf_pins smartconnect_40/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_41_M00_AXI [get_bd_intf_pins kmeans_top_26/s_axi_cfg] [get_bd_intf_pins smartconnect_41/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_41_M01_AXI [get_bd_intf_pins kmeans_top_27/s_axi_cfg] [get_bd_intf_pins smartconnect_41/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_42_M00_AXI [get_bd_intf_pins kmeans_top_28/s_axi_cfg] [get_bd_intf_pins smartconnect_42/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_42_M01_AXI [get_bd_intf_pins kmeans_top_29/s_axi_cfg] [get_bd_intf_pins smartconnect_42/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_43_M00_AXI [get_bd_intf_pins kmeans_top_30/s_axi_cfg] [get_bd_intf_pins smartconnect_43/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_43_M01_AXI [get_bd_intf_pins kmeans_top_31/s_axi_cfg] [get_bd_intf_pins smartconnect_43/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_44_M00_AXI [get_bd_intf_pins kmeans_top_32/s_axi_cfg] [get_bd_intf_pins smartconnect_44/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_44_M01_AXI [get_bd_intf_pins kmeans_top_33/s_axi_cfg] [get_bd_intf_pins smartconnect_44/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_45_M00_AXI [get_bd_intf_pins kmeans_top_34/s_axi_cfg] [get_bd_intf_pins smartconnect_45/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_45_M01_AXI [get_bd_intf_pins kmeans_top_35/s_axi_cfg] [get_bd_intf_pins smartconnect_45/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_46_M00_AXI [get_bd_intf_pins kmeans_top_36/s_axi_cfg] [get_bd_intf_pins smartconnect_46/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_46_M01_AXI [get_bd_intf_pins kmeans_top_37/s_axi_cfg] [get_bd_intf_pins smartconnect_46/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_47_M00_AXI [get_bd_intf_pins kmeans_top_38/s_axi_cfg] [get_bd_intf_pins smartconnect_47/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_47_M01_AXI [get_bd_intf_pins kmeans_top_39/s_axi_cfg] [get_bd_intf_pins smartconnect_47/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_48_M00_AXI [get_bd_intf_pins kmeans_top_40/s_axi_cfg] [get_bd_intf_pins smartconnect_48/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_48_M01_AXI [get_bd_intf_pins kmeans_top_41/s_axi_cfg] [get_bd_intf_pins smartconnect_48/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_49_M00_AXI [get_bd_intf_pins kmeans_top_42/s_axi_cfg] [get_bd_intf_pins smartconnect_49/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_49_M01_AXI [get_bd_intf_pins kmeans_top_43/s_axi_cfg] [get_bd_intf_pins smartconnect_49/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M00_AXI [get_bd_intf_pins axi_noc_0/S10_AXI] [get_bd_intf_pins smartconnect_4/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_50_M00_AXI [get_bd_intf_pins kmeans_top_44/s_axi_cfg] [get_bd_intf_pins smartconnect_50/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_50_M01_AXI [get_bd_intf_pins kmeans_top_45/s_axi_cfg] [get_bd_intf_pins smartconnect_50/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_51_M00_AXI [get_bd_intf_pins kmeans_top_46/s_axi_cfg] [get_bd_intf_pins smartconnect_51/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_51_M01_AXI [get_bd_intf_pins kmeans_top_47/s_axi_cfg] [get_bd_intf_pins smartconnect_51/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_52_M00_AXI [get_bd_intf_pins kmeans_top_48/s_axi_cfg] [get_bd_intf_pins smartconnect_52/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_52_M01_AXI [get_bd_intf_pins kmeans_top_49/s_axi_cfg] [get_bd_intf_pins smartconnect_52/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_53_M00_AXI [get_bd_intf_pins kmeans_top_50/s_axi_cfg] [get_bd_intf_pins smartconnect_53/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_53_M01_AXI [get_bd_intf_pins kmeans_top_51/s_axi_cfg] [get_bd_intf_pins smartconnect_53/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_54_M00_AXI [get_bd_intf_pins kmeans_top_52/s_axi_cfg] [get_bd_intf_pins smartconnect_54/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_54_M01_AXI [get_bd_intf_pins kmeans_top_53/s_axi_cfg] [get_bd_intf_pins smartconnect_54/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_55_M00_AXI [get_bd_intf_pins kmeans_top_54/s_axi_cfg] [get_bd_intf_pins smartconnect_55/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_55_M01_AXI [get_bd_intf_pins kmeans_top_55/s_axi_cfg] [get_bd_intf_pins smartconnect_55/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_5_M00_AXI [get_bd_intf_pins axi_noc_0/S11_AXI] [get_bd_intf_pins smartconnect_5/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_6_M00_AXI [get_bd_intf_pins axi_noc_0/S12_AXI] [get_bd_intf_pins smartconnect_6/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_7_M00_AXI [get_bd_intf_pins axi_noc_0/S13_AXI] [get_bd_intf_pins smartconnect_7/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_8_M00_AXI [get_bd_intf_pins axi_noc_0/S14_AXI] [get_bd_intf_pins smartconnect_8/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_9_M00_AXI [get_bd_intf_pins axi_noc_0/S15_AXI] [get_bd_intf_pins smartconnect_9/M00_AXI]
  connect_bd_intf_net -intf_net sys_clk0_0_1 [get_bd_intf_ports sys_clk0_0] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net sys_clk1_0_1 [get_bd_intf_ports sys_clk1_0] [get_bd_intf_pins axi_noc_0/sys_clk1]
  #connect_bd_intf_net -intf_net sys_clk2_0_1 [get_bd_intf_ports sys_clk2_0] [get_bd_intf_pins axi_noc_0/sys_clk2]
  #connect_bd_intf_net -intf_net sys_clk3_0_1 [get_bd_intf_ports sys_clk3_0] [get_bd_intf_pins axi_noc_0/sys_clk3]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_0 [get_bd_intf_pins axi_noc_0/S34_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_1 [get_bd_intf_pins axi_noc_0/S35_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3]
  connect_bd_intf_net -intf_net versal_cips_0_NOC_LPD_AXI_0 [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins versal_cips_0/NOC_LPD_AXI_0]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0]

  # Create port connections
  connect_bd_net -net kmeans_top_0_interrupt [get_bd_pins kmeans_top_0/interrupt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net kmeans_top_10_interrupt [get_bd_pins kmeans_top_10/interrupt] [get_bd_pins xlconcat_2/In2]
  connect_bd_net -net kmeans_top_11_interrupt [get_bd_pins kmeans_top_11/interrupt] [get_bd_pins xlconcat_2/In3]
  connect_bd_net -net kmeans_top_12_interrupt [get_bd_pins kmeans_top_12/interrupt] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net kmeans_top_13_interrupt [get_bd_pins kmeans_top_13/interrupt] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net kmeans_top_14_interrupt [get_bd_pins kmeans_top_14/interrupt] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net kmeans_top_15_interrupt [get_bd_pins kmeans_top_15/interrupt] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net kmeans_top_16_interrupt [get_bd_pins kmeans_top_16/interrupt] [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net kmeans_top_17_interrupt [get_bd_pins kmeans_top_17/interrupt] [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net kmeans_top_18_interrupt [get_bd_pins kmeans_top_18/interrupt] [get_bd_pins xlconcat_4/In2]
  connect_bd_net -net kmeans_top_19_interrupt [get_bd_pins kmeans_top_19/interrupt] [get_bd_pins xlconcat_4/In3]
  connect_bd_net -net kmeans_top_1_interrupt [get_bd_pins kmeans_top_1/interrupt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net kmeans_top_20_interrupt [get_bd_pins kmeans_top_20/interrupt] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net kmeans_top_21_interrupt [get_bd_pins kmeans_top_21/interrupt] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net kmeans_top_22_interrupt [get_bd_pins kmeans_top_22/interrupt] [get_bd_pins xlconcat_5/In2]
  connect_bd_net -net kmeans_top_23_interrupt [get_bd_pins kmeans_top_23/interrupt] [get_bd_pins xlconcat_5/In3]
  connect_bd_net -net kmeans_top_24_interrupt [get_bd_pins kmeans_top_24/interrupt] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net kmeans_top_25_interrupt [get_bd_pins kmeans_top_25/interrupt] [get_bd_pins xlconcat_6/In1]
  connect_bd_net -net kmeans_top_26_interrupt [get_bd_pins kmeans_top_26/interrupt] [get_bd_pins xlconcat_6/In2]
  connect_bd_net -net kmeans_top_27_interrupt [get_bd_pins kmeans_top_27/interrupt] [get_bd_pins xlconcat_6/In3]
  connect_bd_net -net kmeans_top_28_interrupt [get_bd_pins kmeans_top_28/interrupt] [get_bd_pins xlconcat_7/In0]
  connect_bd_net -net kmeans_top_29_interrupt [get_bd_pins kmeans_top_29/interrupt] [get_bd_pins xlconcat_7/In1]
  connect_bd_net -net kmeans_top_2_interrupt [get_bd_pins kmeans_top_2/interrupt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net kmeans_top_30_interrupt [get_bd_pins kmeans_top_30/interrupt] [get_bd_pins xlconcat_7/In2]
  connect_bd_net -net kmeans_top_31_interrupt [get_bd_pins kmeans_top_31/interrupt] [get_bd_pins xlconcat_7/In3]
  connect_bd_net -net kmeans_top_32_interrupt [get_bd_pins kmeans_top_32/interrupt] [get_bd_pins xlconcat_8/In0]
  connect_bd_net -net kmeans_top_33_interrupt [get_bd_pins kmeans_top_33/interrupt] [get_bd_pins xlconcat_8/In1]
  connect_bd_net -net kmeans_top_34_interrupt [get_bd_pins kmeans_top_34/interrupt] [get_bd_pins xlconcat_8/In2]
  connect_bd_net -net kmeans_top_35_interrupt [get_bd_pins kmeans_top_35/interrupt] [get_bd_pins xlconcat_8/In3]
  connect_bd_net -net kmeans_top_36_interrupt [get_bd_pins kmeans_top_36/interrupt] [get_bd_pins xlconcat_9/In0]
  connect_bd_net -net kmeans_top_37_interrupt [get_bd_pins kmeans_top_37/interrupt] [get_bd_pins xlconcat_9/In1]
  connect_bd_net -net kmeans_top_38_interrupt [get_bd_pins kmeans_top_38/interrupt] [get_bd_pins xlconcat_9/In2]
  connect_bd_net -net kmeans_top_39_interrupt [get_bd_pins kmeans_top_39/interrupt] [get_bd_pins xlconcat_9/In3]
  connect_bd_net -net kmeans_top_3_interrupt [get_bd_pins kmeans_top_3/interrupt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net kmeans_top_40_interrupt [get_bd_pins kmeans_top_40/interrupt] [get_bd_pins xlconcat_10/In0]
  connect_bd_net -net kmeans_top_41_interrupt [get_bd_pins kmeans_top_41/interrupt] [get_bd_pins xlconcat_10/In1]
  connect_bd_net -net kmeans_top_42_interrupt [get_bd_pins kmeans_top_42/interrupt] [get_bd_pins xlconcat_10/In2]
  connect_bd_net -net kmeans_top_43_interrupt [get_bd_pins kmeans_top_43/interrupt] [get_bd_pins xlconcat_10/In3]
  connect_bd_net -net kmeans_top_44_interrupt [get_bd_pins kmeans_top_44/interrupt] [get_bd_pins xlconcat_11/In0]
  connect_bd_net -net kmeans_top_45_interrupt [get_bd_pins kmeans_top_45/interrupt] [get_bd_pins xlconcat_11/In1]
  connect_bd_net -net kmeans_top_46_interrupt [get_bd_pins kmeans_top_46/interrupt] [get_bd_pins xlconcat_11/In2]
  connect_bd_net -net kmeans_top_47_interrupt [get_bd_pins kmeans_top_47/interrupt] [get_bd_pins xlconcat_11/In3]
  connect_bd_net -net kmeans_top_48_interrupt [get_bd_pins kmeans_top_48/interrupt] [get_bd_pins xlconcat_12/In0]
  connect_bd_net -net kmeans_top_49_interrupt [get_bd_pins kmeans_top_49/interrupt] [get_bd_pins xlconcat_12/In1]
  connect_bd_net -net kmeans_top_4_interrupt [get_bd_pins kmeans_top_4/interrupt] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net kmeans_top_50_interrupt [get_bd_pins kmeans_top_50/interrupt] [get_bd_pins xlconcat_12/In2]
  connect_bd_net -net kmeans_top_51_interrupt [get_bd_pins kmeans_top_51/interrupt] [get_bd_pins xlconcat_12/In3]
  connect_bd_net -net kmeans_top_52_interrupt [get_bd_pins kmeans_top_52/interrupt] [get_bd_pins xlconcat_13/In0]
  connect_bd_net -net kmeans_top_53_interrupt [get_bd_pins kmeans_top_53/interrupt] [get_bd_pins xlconcat_13/In1]
  connect_bd_net -net kmeans_top_54_interrupt [get_bd_pins kmeans_top_54/interrupt] [get_bd_pins xlconcat_13/In2]
  connect_bd_net -net kmeans_top_55_interrupt [get_bd_pins kmeans_top_55/interrupt] [get_bd_pins xlconcat_13/In3]
  connect_bd_net -net kmeans_top_5_interrupt [get_bd_pins kmeans_top_5/interrupt] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net kmeans_top_6_interrupt [get_bd_pins kmeans_top_6/interrupt] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net kmeans_top_7_interrupt [get_bd_pins kmeans_top_7/interrupt] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net kmeans_top_8_interrupt [get_bd_pins kmeans_top_8/interrupt] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net kmeans_top_9_interrupt [get_bd_pins kmeans_top_9/interrupt] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn] [get_bd_pins smartconnect_10/aresetn] [get_bd_pins smartconnect_11/aresetn] [get_bd_pins smartconnect_12/aresetn] [get_bd_pins smartconnect_13/aresetn] [get_bd_pins smartconnect_14/aresetn] [get_bd_pins smartconnect_15/aresetn] [get_bd_pins smartconnect_16/aresetn] [get_bd_pins smartconnect_17/aresetn] [get_bd_pins smartconnect_18/aresetn] [get_bd_pins smartconnect_19/aresetn] [get_bd_pins smartconnect_2/aresetn] [get_bd_pins smartconnect_20/aresetn] [get_bd_pins smartconnect_21/aresetn] [get_bd_pins smartconnect_22/aresetn] [get_bd_pins smartconnect_23/aresetn] [get_bd_pins smartconnect_24/aresetn] [get_bd_pins smartconnect_25/aresetn] [get_bd_pins smartconnect_26/aresetn] [get_bd_pins smartconnect_27/aresetn] [get_bd_pins smartconnect_28/aresetn] [get_bd_pins smartconnect_29/aresetn] [get_bd_pins smartconnect_3/aresetn] [get_bd_pins smartconnect_30/aresetn] [get_bd_pins smartconnect_31/aresetn] [get_bd_pins smartconnect_32/aresetn] [get_bd_pins smartconnect_33/aresetn] [get_bd_pins smartconnect_34/aresetn] [get_bd_pins smartconnect_35/aresetn] [get_bd_pins smartconnect_36/aresetn] [get_bd_pins smartconnect_37/aresetn] [get_bd_pins smartconnect_38/aresetn] [get_bd_pins smartconnect_39/aresetn] [get_bd_pins smartconnect_4/aresetn] [get_bd_pins smartconnect_40/aresetn] [get_bd_pins smartconnect_41/aresetn] [get_bd_pins smartconnect_42/aresetn] [get_bd_pins smartconnect_43/aresetn] [get_bd_pins smartconnect_44/aresetn] [get_bd_pins smartconnect_45/aresetn] [get_bd_pins smartconnect_46/aresetn] [get_bd_pins smartconnect_47/aresetn] [get_bd_pins smartconnect_48/aresetn] [get_bd_pins smartconnect_49/aresetn] [get_bd_pins smartconnect_5/aresetn] [get_bd_pins smartconnect_50/aresetn] [get_bd_pins smartconnect_51/aresetn] [get_bd_pins smartconnect_52/aresetn] [get_bd_pins smartconnect_53/aresetn] [get_bd_pins smartconnect_54/aresetn] [get_bd_pins smartconnect_55/aresetn] [get_bd_pins smartconnect_6/aresetn] [get_bd_pins smartconnect_7/aresetn] [get_bd_pins smartconnect_8/aresetn] [get_bd_pins smartconnect_9/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins kmeans_top_0/ap_rst_n] [get_bd_pins kmeans_top_1/ap_rst_n] [get_bd_pins kmeans_top_10/ap_rst_n] [get_bd_pins kmeans_top_11/ap_rst_n] [get_bd_pins kmeans_top_12/ap_rst_n] [get_bd_pins kmeans_top_13/ap_rst_n] [get_bd_pins kmeans_top_14/ap_rst_n] [get_bd_pins kmeans_top_15/ap_rst_n] [get_bd_pins kmeans_top_16/ap_rst_n] [get_bd_pins kmeans_top_17/ap_rst_n] [get_bd_pins kmeans_top_18/ap_rst_n] [get_bd_pins kmeans_top_19/ap_rst_n] [get_bd_pins kmeans_top_2/ap_rst_n] [get_bd_pins kmeans_top_20/ap_rst_n] [get_bd_pins kmeans_top_21/ap_rst_n] [get_bd_pins kmeans_top_22/ap_rst_n] [get_bd_pins kmeans_top_23/ap_rst_n] [get_bd_pins kmeans_top_24/ap_rst_n] [get_bd_pins kmeans_top_25/ap_rst_n] [get_bd_pins kmeans_top_26/ap_rst_n] [get_bd_pins kmeans_top_27/ap_rst_n] [get_bd_pins kmeans_top_28/ap_rst_n] [get_bd_pins kmeans_top_29/ap_rst_n] [get_bd_pins kmeans_top_3/ap_rst_n] [get_bd_pins kmeans_top_30/ap_rst_n] [get_bd_pins kmeans_top_31/ap_rst_n] [get_bd_pins kmeans_top_32/ap_rst_n] [get_bd_pins kmeans_top_33/ap_rst_n] [get_bd_pins kmeans_top_34/ap_rst_n] [get_bd_pins kmeans_top_35/ap_rst_n] [get_bd_pins kmeans_top_36/ap_rst_n] [get_bd_pins kmeans_top_37/ap_rst_n] [get_bd_pins kmeans_top_38/ap_rst_n] [get_bd_pins kmeans_top_39/ap_rst_n] [get_bd_pins kmeans_top_4/ap_rst_n] [get_bd_pins kmeans_top_40/ap_rst_n] [get_bd_pins kmeans_top_41/ap_rst_n] [get_bd_pins kmeans_top_42/ap_rst_n] [get_bd_pins kmeans_top_43/ap_rst_n] [get_bd_pins kmeans_top_44/ap_rst_n] [get_bd_pins kmeans_top_45/ap_rst_n] [get_bd_pins kmeans_top_46/ap_rst_n] [get_bd_pins kmeans_top_47/ap_rst_n] [get_bd_pins kmeans_top_48/ap_rst_n] [get_bd_pins kmeans_top_49/ap_rst_n] [get_bd_pins kmeans_top_5/ap_rst_n] [get_bd_pins kmeans_top_50/ap_rst_n] [get_bd_pins kmeans_top_51/ap_rst_n] [get_bd_pins kmeans_top_52/ap_rst_n] [get_bd_pins kmeans_top_53/ap_rst_n] [get_bd_pins kmeans_top_54/ap_rst_n] [get_bd_pins kmeans_top_55/ap_rst_n] [get_bd_pins kmeans_top_6/ap_rst_n] [get_bd_pins kmeans_top_7/ap_rst_n] [get_bd_pins kmeans_top_8/ap_rst_n] [get_bd_pins kmeans_top_9/ap_rst_n] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins versal_cips_0/pl_ps_irq0]
  connect_bd_net -net util_reduced_logic_10_Res [get_bd_pins util_reduced_logic_10/Res] [get_bd_pins versal_cips_0/pl_ps_irq10]
  connect_bd_net -net util_reduced_logic_11_Res [get_bd_pins util_reduced_logic_11/Res] [get_bd_pins versal_cips_0/pl_ps_irq11]
  connect_bd_net -net util_reduced_logic_12_Res [get_bd_pins util_reduced_logic_12/Res] [get_bd_pins versal_cips_0/pl_ps_irq12]
  connect_bd_net -net util_reduced_logic_13_Res [get_bd_pins util_reduced_logic_13/Res] [get_bd_pins versal_cips_0/pl_ps_irq13]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins util_reduced_logic_1/Res] [get_bd_pins versal_cips_0/pl_ps_irq1]
  connect_bd_net -net util_reduced_logic_2_Res [get_bd_pins util_reduced_logic_2/Res] [get_bd_pins versal_cips_0/pl_ps_irq2]
  connect_bd_net -net util_reduced_logic_3_Res [get_bd_pins util_reduced_logic_3/Res] [get_bd_pins versal_cips_0/pl_ps_irq3]
  connect_bd_net -net util_reduced_logic_4_Res [get_bd_pins util_reduced_logic_4/Res] [get_bd_pins versal_cips_0/pl_ps_irq4]
  connect_bd_net -net util_reduced_logic_5_Res [get_bd_pins util_reduced_logic_5/Res] [get_bd_pins versal_cips_0/pl_ps_irq5]
  connect_bd_net -net util_reduced_logic_6_Res [get_bd_pins util_reduced_logic_6/Res] [get_bd_pins versal_cips_0/pl_ps_irq6]
  connect_bd_net -net util_reduced_logic_7_Res [get_bd_pins util_reduced_logic_7/Res] [get_bd_pins versal_cips_0/pl_ps_irq7]
  connect_bd_net -net util_reduced_logic_8_Res [get_bd_pins util_reduced_logic_8/Res] [get_bd_pins versal_cips_0/pl_ps_irq8]
  connect_bd_net -net util_reduced_logic_9_Res [get_bd_pins util_reduced_logic_9/Res] [get_bd_pins versal_cips_0/pl_ps_irq9]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk7] [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi1_clk [get_bd_pins axi_noc_0/aclk8] [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins axi_noc_0/aclk3] [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins axi_noc_0/aclk4] [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins axi_noc_0/aclk5] [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins axi_noc_0/aclk6] [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins axi_noc_0/aclk2] [get_bd_pins versal_cips_0/lpd_axi_noc_clk]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins axi_noc_0/aclk0] [get_bd_pins kmeans_top_0/ap_clk] [get_bd_pins kmeans_top_1/ap_clk] [get_bd_pins kmeans_top_10/ap_clk] [get_bd_pins kmeans_top_11/ap_clk] [get_bd_pins kmeans_top_12/ap_clk] [get_bd_pins kmeans_top_13/ap_clk] [get_bd_pins kmeans_top_14/ap_clk] [get_bd_pins kmeans_top_15/ap_clk] [get_bd_pins kmeans_top_16/ap_clk] [get_bd_pins kmeans_top_17/ap_clk] [get_bd_pins kmeans_top_18/ap_clk] [get_bd_pins kmeans_top_19/ap_clk] [get_bd_pins kmeans_top_2/ap_clk] [get_bd_pins kmeans_top_20/ap_clk] [get_bd_pins kmeans_top_21/ap_clk] [get_bd_pins kmeans_top_22/ap_clk] [get_bd_pins kmeans_top_23/ap_clk] [get_bd_pins kmeans_top_24/ap_clk] [get_bd_pins kmeans_top_25/ap_clk] [get_bd_pins kmeans_top_26/ap_clk] [get_bd_pins kmeans_top_27/ap_clk] [get_bd_pins kmeans_top_28/ap_clk] [get_bd_pins kmeans_top_29/ap_clk] [get_bd_pins kmeans_top_3/ap_clk] [get_bd_pins kmeans_top_30/ap_clk] [get_bd_pins kmeans_top_31/ap_clk] [get_bd_pins kmeans_top_32/ap_clk] [get_bd_pins kmeans_top_33/ap_clk] [get_bd_pins kmeans_top_34/ap_clk] [get_bd_pins kmeans_top_35/ap_clk] [get_bd_pins kmeans_top_36/ap_clk] [get_bd_pins kmeans_top_37/ap_clk] [get_bd_pins kmeans_top_38/ap_clk] [get_bd_pins kmeans_top_39/ap_clk] [get_bd_pins kmeans_top_4/ap_clk] [get_bd_pins kmeans_top_40/ap_clk] [get_bd_pins kmeans_top_41/ap_clk] [get_bd_pins kmeans_top_42/ap_clk] [get_bd_pins kmeans_top_43/ap_clk] [get_bd_pins kmeans_top_44/ap_clk] [get_bd_pins kmeans_top_45/ap_clk] [get_bd_pins kmeans_top_46/ap_clk] [get_bd_pins kmeans_top_47/ap_clk] [get_bd_pins kmeans_top_48/ap_clk] [get_bd_pins kmeans_top_49/ap_clk] [get_bd_pins kmeans_top_5/ap_clk] [get_bd_pins kmeans_top_50/ap_clk] [get_bd_pins kmeans_top_51/ap_clk] [get_bd_pins kmeans_top_52/ap_clk] [get_bd_pins kmeans_top_53/ap_clk] [get_bd_pins kmeans_top_54/ap_clk] [get_bd_pins kmeans_top_55/ap_clk] [get_bd_pins kmeans_top_6/ap_clk] [get_bd_pins kmeans_top_7/ap_clk] [get_bd_pins kmeans_top_8/ap_clk] [get_bd_pins kmeans_top_9/ap_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk] [get_bd_pins smartconnect_10/aclk] [get_bd_pins smartconnect_11/aclk] [get_bd_pins smartconnect_12/aclk] [get_bd_pins smartconnect_13/aclk] [get_bd_pins smartconnect_14/aclk] [get_bd_pins smartconnect_15/aclk] [get_bd_pins smartconnect_16/aclk] [get_bd_pins smartconnect_17/aclk] [get_bd_pins smartconnect_18/aclk] [get_bd_pins smartconnect_19/aclk] [get_bd_pins smartconnect_2/aclk] [get_bd_pins smartconnect_20/aclk] [get_bd_pins smartconnect_21/aclk] [get_bd_pins smartconnect_22/aclk] [get_bd_pins smartconnect_23/aclk] [get_bd_pins smartconnect_24/aclk] [get_bd_pins smartconnect_25/aclk] [get_bd_pins smartconnect_26/aclk] [get_bd_pins smartconnect_27/aclk] [get_bd_pins smartconnect_28/aclk] [get_bd_pins smartconnect_29/aclk] [get_bd_pins smartconnect_3/aclk] [get_bd_pins smartconnect_30/aclk] [get_bd_pins smartconnect_31/aclk] [get_bd_pins smartconnect_32/aclk] [get_bd_pins smartconnect_33/aclk] [get_bd_pins smartconnect_34/aclk] [get_bd_pins smartconnect_35/aclk] [get_bd_pins smartconnect_36/aclk] [get_bd_pins smartconnect_37/aclk] [get_bd_pins smartconnect_38/aclk] [get_bd_pins smartconnect_39/aclk] [get_bd_pins smartconnect_4/aclk] [get_bd_pins smartconnect_40/aclk] [get_bd_pins smartconnect_41/aclk] [get_bd_pins smartconnect_42/aclk] [get_bd_pins smartconnect_43/aclk] [get_bd_pins smartconnect_44/aclk] [get_bd_pins smartconnect_45/aclk] [get_bd_pins smartconnect_46/aclk] [get_bd_pins smartconnect_47/aclk] [get_bd_pins smartconnect_48/aclk] [get_bd_pins smartconnect_49/aclk] [get_bd_pins smartconnect_5/aclk] [get_bd_pins smartconnect_50/aclk] [get_bd_pins smartconnect_51/aclk] [get_bd_pins smartconnect_52/aclk] [get_bd_pins smartconnect_53/aclk] [get_bd_pins smartconnect_54/aclk] [get_bd_pins smartconnect_55/aclk] [get_bd_pins smartconnect_6/aclk] [get_bd_pins smartconnect_7/aclk] [get_bd_pins smartconnect_8/aclk] [get_bd_pins smartconnect_9/aclk] [get_bd_pins versal_cips_0/pl0_ref_clk]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins versal_cips_0/pl0_resetn]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk1] [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_reduced_logic_0/Op1] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_10_dout [get_bd_pins util_reduced_logic_10/Op1] [get_bd_pins xlconcat_10/dout]
  connect_bd_net -net xlconcat_11_dout [get_bd_pins util_reduced_logic_11/Op1] [get_bd_pins xlconcat_11/dout]
  connect_bd_net -net xlconcat_12_dout [get_bd_pins util_reduced_logic_12/Op1] [get_bd_pins xlconcat_12/dout]
  connect_bd_net -net xlconcat_13_dout [get_bd_pins util_reduced_logic_13/Op1] [get_bd_pins xlconcat_13/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins util_reduced_logic_1/Op1] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins util_reduced_logic_2/Op1] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins util_reduced_logic_3/Op1] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins util_reduced_logic_4/Op1] [get_bd_pins xlconcat_4/dout]
  connect_bd_net -net xlconcat_5_dout [get_bd_pins util_reduced_logic_5/Op1] [get_bd_pins xlconcat_5/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins util_reduced_logic_6/Op1] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconcat_7_dout [get_bd_pins util_reduced_logic_7/Op1] [get_bd_pins xlconcat_7/dout]
  connect_bd_net -net xlconcat_8_dout [get_bd_pins util_reduced_logic_8/Op1] [get_bd_pins xlconcat_8/dout]
  connect_bd_net -net xlconcat_9_dout [get_bd_pins util_reduced_logic_9/Op1] [get_bd_pins xlconcat_9/dout]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_0/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S06_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_0/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S06_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_1/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S06_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_1/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S06_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_2/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_2/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_3/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_3/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_4/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_4/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_5/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_5/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S08_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_6/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S09_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_6/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S09_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_7/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S09_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_7/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S09_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_8/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S10_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_8/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S10_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_9/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S10_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_9/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S10_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_10/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S11_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_10/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S11_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_11/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S11_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_11/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S11_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_12/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S12_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_12/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S12_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_13/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S12_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_13/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S12_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_14/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S13_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_14/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S13_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_15/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S13_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_15/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S13_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_16/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S14_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_16/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S14_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_17/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S14_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_17/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S14_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_18/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S15_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_18/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S15_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_19/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S15_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_19/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S15_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_20/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_20/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_21/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_21/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S16_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_22/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_22/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_23/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_23/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S17_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_24/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S18_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_24/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S18_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_25/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S18_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_25/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S18_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_26/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S19_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_26/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S19_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_27/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S19_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_27/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S19_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_28/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S20_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_28/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S20_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_29/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S20_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_29/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S20_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_30/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S21_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_30/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S21_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_31/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S21_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_31/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S21_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_32/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S22_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_32/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S22_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_33/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S22_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_33/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S22_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_34/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S23_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_34/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S23_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_35/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S23_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_35/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S23_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_36/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S24_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_36/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S24_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_37/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S24_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_37/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S24_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_38/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S25_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_38/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S25_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_39/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S25_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_39/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S25_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_40/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S26_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_40/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S26_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_41/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S26_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_41/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S26_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_42/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S27_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_42/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S27_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_43/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S27_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_43/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S27_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_44/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S28_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_44/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S28_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_45/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S28_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_45/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S28_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_46/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S29_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_46/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S29_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_47/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S29_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_47/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S29_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_48/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S30_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_48/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S30_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_49/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S30_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_49/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S30_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_50/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S31_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_50/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S31_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_51/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S31_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_51/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S31_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_52/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S32_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_52/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S32_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_53/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S32_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_53/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S32_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_54/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S33_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_54/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S33_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces kmeans_top_55/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S33_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces kmeans_top_55/Data_m_axi_mem] [get_bd_addr_segs axi_noc_0/S33_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_RPU0] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_PMC] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI1] [get_bd_addr_segs axi_noc_0/S35_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI0] [get_bd_addr_segs axi_noc_0/S34_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI3] [get_bd_addr_segs axi_noc_0/S05_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI2] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs axi_noc_0/S03_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs axi_noc_0/S02_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_RPU0] [get_bd_addr_segs axi_noc_0/S01_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_PMC] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI1] [get_bd_addr_segs axi_noc_0/S35_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI0] [get_bd_addr_segs axi_noc_0/S34_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI3] [get_bd_addr_segs axi_noc_0/S05_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI2] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs axi_noc_0/S03_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x020100000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_0/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020240000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_10/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020240010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_11/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020280000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_12/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020280010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_13/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0202C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_14/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0202C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_15/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020300000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_16/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020300010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_17/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020340000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_18/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020340010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_19/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020100010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_1/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020380000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_20/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020380010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_21/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0203C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_22/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0203C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_23/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020400000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_24/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020400010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_25/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020440000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_26/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020440010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_27/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030480000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_28/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030480010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_29/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020140000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_2/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0304C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_30/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0304C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_31/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030500000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_32/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030500010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_33/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030540000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_34/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030540010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_35/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030580000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_36/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030580010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_37/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0305C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_38/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0305C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_39/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020140010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_3/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030600000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_40/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030600010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_41/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030640000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_42/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030640010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_43/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030680000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_44/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030680010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_45/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0306C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_46/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0306C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_47/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030700000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_48/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030700010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_49/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020180000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_4/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030740000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_50/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030740010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_51/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030780000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_52/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x030780010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_53/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0307C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_54/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0307C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs kmeans_top_55/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020180010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_5/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0201C0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_6/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x0201C0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_7/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020200000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_8/s_axi_cfg/Reg] -force
  assign_bd_address -offset 0x020200010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs kmeans_top_9/s_axi_cfg/Reg] -force


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


