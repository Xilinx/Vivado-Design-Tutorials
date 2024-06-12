# © Copyright 2020-2023 Xilinx, Inc.
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
set scripts_vivado_version 2024.1
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
xilinx.com:ip:axi_noc:1.1\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:perf_axi_tg:1.0\
xilinx.com:ip:sim_trig:1.0\
xilinx.com:ip:versal_cips:3.4\
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
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 axi_noc_1 ]
  set_property -dict [ list \
    CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
    CONFIG.MC0_FLIPPED_PINOUT {true} \
    CONFIG.MC_CHANNEL_INTERLEAVING {true} \
    CONFIG.MC_CHAN_REGION0 {DDR_CH1} \
    CONFIG.MC_CH_INTERLEAVING_SIZE {256_Bytes} \
    CONFIG.MC_EN_INTR_RESP {false} \
    CONFIG.MC_INPUTCLK0_PERIOD {4963} \
    CONFIG.MC_NO_CHANNELS {Dual} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {BANK_ROW_COLUMN} \
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
  set axi_noc_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 axi_noc_3 ]
  set_property -dict [list \
    CONFIG.CONTROLLERTYPE {LPDDR4_SDRAM} \
    CONFIG.MC0_FLIPPED_PINOUT {true} \
    CONFIG.MC_CHANNEL_INTERLEAVING {true} \
    CONFIG.MC_CHAN_REGION0 {DDR_CH2} \
    CONFIG.MC_CH_INTERLEAVING_SIZE {128_Bytes} \
    CONFIG.MC_EN_INTR_RESP {false} \
    CONFIG.MC_INPUTCLK0_PERIOD {4963} \
    CONFIG.MC_NO_CHANNELS {Dual} \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {3} \
  ] $axi_noc_3


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {2800} write_bw {2270} read_avg_burst {2} write_avg_burst {2}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_3/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {2800} write_bw {0} read_avg_burst {2} write_avg_burst {1}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_3/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {2800} write_bw {0} read_avg_burst {2} write_avg_burst {1}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_3/S02_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI} \
 ] [get_bd_pins /axi_noc_3/aclk0]

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_MBUFGCE_MODE {PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE,PERFORMANCE} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {250.000,100.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.USE_LOCKED {false} \
  ] $clk_wizard_0


  # Create instance: perf_axi_tg_0, and set properties
  set perf_axi_tg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_0 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {0} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_0


  # Create instance: perf_axi_tg_1, and set properties
  set perf_axi_tg_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_1 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {1} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_1


  # Create instance: perf_axi_tg_2, and set properties
  set perf_axi_tg_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_2 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {2} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_2


  # Create instance: perf_axi_tg_3, and set properties
  set perf_axi_tg_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_3 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {3} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_3


  # Create instance: perf_axi_tg_4, and set properties
  set perf_axi_tg_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_4 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {4} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_4


  # Create instance: perf_axi_tg_5, and set properties
  set perf_axi_tg_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_5 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {5} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_5


  # Create instance: perf_axi_tg_6, and set properties
  set perf_axi_tg_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_6 ]
  set_property -dict [list \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_DEBUG_INTF {TRUE} \
    CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Incremental_ID} \
    CONFIG.USER_PARAM_SRC_ID {6} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../../scripts/EMPTY.csv} \
    CONFIG.USER_SYN_ID_WIDTH {2} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $perf_axi_tg_6


  # Create instance: sim_trig_0, and set properties
  set sim_trig_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sim_trig:1.0 sim_trig_0 ]
  set_property -dict [list \
    CONFIG.USER_DEBUG_INTF {INTERNAL_VIO} \
    CONFIG.USER_NUM_AXI_TG {7} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $sim_trig_0


  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.IO_CONFIG_MODE { Custom } \
    CONFIG.PS_PMC_CONFIG { \
      IO_CONFIG_MODE {Custom} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_UART1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
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
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins axi_noc_1/aclk0] [get_bd_pins axi_noc_3/aclk0] [get_bd_pins perf_axi_tg_0/clk] [get_bd_pins perf_axi_tg_0/pclk] [get_bd_pins perf_axi_tg_1/clk] [get_bd_pins perf_axi_tg_1/pclk] [get_bd_pins perf_axi_tg_2/clk] [get_bd_pins perf_axi_tg_2/pclk] [get_bd_pins perf_axi_tg_3/clk] [get_bd_pins perf_axi_tg_3/pclk] [get_bd_pins perf_axi_tg_4/clk] [get_bd_pins perf_axi_tg_4/pclk] [get_bd_pins perf_axi_tg_5/clk] [get_bd_pins perf_axi_tg_5/pclk] [get_bd_pins perf_axi_tg_6/clk] [get_bd_pins perf_axi_tg_6/pclk] [get_bd_pins sim_trig_0/pclk]
  connect_bd_net -net perf_axi_tg_0_axi_tg_done [get_bd_pins perf_axi_tg_0/axi_tg_done] [get_bd_pins sim_trig_0/all_done_00]
  connect_bd_net -net perf_axi_tg_1_axi_tg_done [get_bd_pins perf_axi_tg_1/axi_tg_done] [get_bd_pins sim_trig_0/all_done_01]
  connect_bd_net -net perf_axi_tg_2_axi_tg_done [get_bd_pins perf_axi_tg_2/axi_tg_done] [get_bd_pins sim_trig_0/all_done_02]
  connect_bd_net -net perf_axi_tg_3_axi_tg_done [get_bd_pins perf_axi_tg_3/axi_tg_done] [get_bd_pins sim_trig_0/all_done_03]
  connect_bd_net -net perf_axi_tg_4_axi_tg_done [get_bd_pins perf_axi_tg_4/axi_tg_done] [get_bd_pins sim_trig_0/all_done_04]
  connect_bd_net -net perf_axi_tg_5_axi_tg_done [get_bd_pins perf_axi_tg_5/axi_tg_done] [get_bd_pins sim_trig_0/all_done_06]
  connect_bd_net -net perf_axi_tg_6_axi_tg_done [get_bd_pins perf_axi_tg_6/axi_tg_done] [get_bd_pins sim_trig_0/all_done_05]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins perf_axi_tg_0/tg_rst_n] [get_bd_pins perf_axi_tg_0/axi_tg_start] [get_bd_pins perf_axi_tg_1/tg_rst_n] [get_bd_pins perf_axi_tg_1/axi_tg_start] [get_bd_pins perf_axi_tg_2/tg_rst_n] [get_bd_pins perf_axi_tg_2/axi_tg_start] [get_bd_pins perf_axi_tg_3/tg_rst_n] [get_bd_pins perf_axi_tg_3/axi_tg_start] [get_bd_pins perf_axi_tg_4/tg_rst_n] [get_bd_pins perf_axi_tg_4/axi_tg_start] [get_bd_pins perf_axi_tg_5/tg_rst_n] [get_bd_pins perf_axi_tg_5/axi_tg_start] [get_bd_pins perf_axi_tg_6/tg_rst_n] [get_bd_pins perf_axi_tg_6/axi_tg_start] [get_bd_pins sim_trig_0/rst_n]

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
