#--------------------------------------------------------------------------------------
#
# Copyright(C) 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# This document contains proprietary, confidential information that
# may be used, copied and/or disclosed only as authorized by a
# valid licensing agreement with Advanced Micro Devices, Inc. This copyright
# notice must be retained on all authorized copies.
#
# This code is provided "as is". Advanced Micro Devices, Inc. makes, and
# the end user receives, no warranties or conditions, express,
# implied, statutory or otherwise, and Advanced Micro Devices, Inc.
# specifically disclaims any implied warranties of merchantability,
# non-infringement, or fitness for a particular purpose.
#
#--------------------------------------------------------------------------------------

################################################################
# This is a generated script based on design: dcmac_0_cips
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
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source dcmac_0_cips_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvp1802-lsvc4072-2MP-e-S
   set_property BOARD_PART xilinx.com:vpk180:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name dcmac_0_cips

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
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:versal_cips:3.4\
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
  set APB_M2_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 APB_M2_0 ]

  set APB_M3_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 APB_M3_0 ]

  set APB_M_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 APB_M_0 ]

  set M00_AXI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_0

  set M00_AXI_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_1

  set M00_AXI_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_2

  set M00_AXI_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_3 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_3

  set M00_AXI_4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_4 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_4

  set M00_AXI_5 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_5 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_5

  set M00_AXI_6 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_6 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_6


  # Create ports
  set gt_reset_all_in [ create_bd_port -dir O -from 0 -to 0 -type rst gt_reset_all_in ]
  set gt_line_rate [ create_bd_port -dir O -from 7 -to 0 -type data gt_line_rate ]
  set gt_loopback [ create_bd_port -dir O -from 2 -to 0 -type data gt_loopback ]
  set gt_txprecursor [ create_bd_port -dir O -from 5 -to 0 -type data gt_txprecursor ]
  set gt_txpostcursor [ create_bd_port -dir O -from 5 -to 0 -type data gt_txpostcursor ]
  set gt_txmaincursor [ create_bd_port -dir O -from 6 -to 0 -type data gt_txmaincursor ]
  set gt_reset_rx_datapath_in [ create_bd_port -dir O -from 23 -to 0 gt_reset_rx_datapath_in ]
  set gt_reset_tx_datapath_in [ create_bd_port -dir O -from 23 -to 0 gt_reset_tx_datapath_in ]
  set tx_serdes_reset [ create_bd_port -dir O -from 5 -to 0 tx_serdes_reset ]
  set rx_serdes_reset [ create_bd_port -dir O -from 5 -to 0 rx_serdes_reset ]
  set tx_core_reset [ create_bd_port -dir O -from 0 -to 0 tx_core_reset ]
  set rx_core_reset [ create_bd_port -dir O -from 0 -to 0 rx_core_reset ]
  set gt_tx_reset_done [ create_bd_port -dir I -from 23 -to 0 gt_tx_reset_done ]
  set gt_rx_reset_done [ create_bd_port -dir I -from 23 -to 0 gt_rx_reset_done ]
  set gt_rxcdrhold [ create_bd_port -dir O -from 0 -to 0 -type data gt_rxcdrhold ]
  set pl0_ref_clk_0 [ create_bd_port -dir O -type clk pl0_ref_clk_0 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI_0:M00_AXI_1:M00_AXI_2:M00_AXI_3:M00_AXI_4:M00_AXI_5:M00_AXI_6} \
   CONFIG.ASSOCIATED_RESET {pl0_resetn_0} \
 ] $pl0_ref_clk_0
  set pl0_resetn_0 [ create_bd_port -dir O -from 0 -to 0 -type rst pl0_resetn_0 ]

  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_bridge_0 ]
  set_property CONFIG.C_APB_NUM_SLAVES {3} $axi_apb_bridge_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {13} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: axi_gpio_tx_datapath, and set properties
  set axi_gpio_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_tx_datapath ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_tx_datapath


  # Create instance: axi_gpio_rx_datapath, and set properties
  set axi_gpio_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_rx_datapath ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_rx_datapath


  # Create instance: axi_resets_dyn, and set properties
  set axi_resets_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_resets_dyn ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {14} \
  ] $axi_resets_dyn


  # Create instance: axi_reset_done_dyn, and set properties
  set axi_reset_done_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_reset_done_dyn ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {24} \
    CONFIG.C_GPIO_WIDTH {24} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_reset_done_dyn


  # Create instance: axi_gpio_gt_ctl, and set properties
  set axi_gpio_gt_ctl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_gt_ctl ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_gt_ctl


  # Create instance: xlslice_gt_reset, and set properties
  set xlslice_gt_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_reset ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset


  # Create instance: xlslice_gt_line_rate, and set properties
  set xlslice_gt_line_rate [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_line_rate ]
  set_property -dict [list \
    CONFIG.DIN_FROM {8} \
    CONFIG.DIN_TO {1} \
    CONFIG.DOUT_WIDTH {8} \
  ] $xlslice_gt_line_rate


  # Create instance: xlslice_gt_loopback, and set properties
  set xlslice_gt_loopback [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_loopback ]
  set_property -dict [list \
    CONFIG.DIN_FROM {11} \
    CONFIG.DIN_TO {9} \
    CONFIG.DOUT_WIDTH {3} \
  ] $xlslice_gt_loopback


  # Create instance: xlslice_gt_txprecursor, and set properties
  set xlslice_gt_txprecursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_txprecursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {17} \
    CONFIG.DIN_TO {12} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_gt_txprecursor


  # Create instance: xlslice_gt_txpostcursor, and set properties
  set xlslice_gt_txpostcursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_txpostcursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DIN_TO {18} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_gt_txpostcursor


  # Create instance: xlslice_gt_txmaincursor, and set properties
  set xlslice_gt_txmaincursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_txmaincursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {30} \
    CONFIG.DIN_TO {24} \
    CONFIG.DOUT_WIDTH {7} \
  ] $xlslice_gt_txmaincursor


  # Create instance: xlslice_gt_rxcdrhold, and set properties
  set xlslice_gt_rxcdrhold [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_gt_rxcdrhold ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {31} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_rxcdrhold


  # Create instance: xlslice_tx_serdes_rst, and set properties
  set xlslice_tx_serdes_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_serdes_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_tx_serdes_rst


  # Create instance: xlslice_rx_serdes_rst, and set properties
  set xlslice_rx_serdes_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_serdes_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {13} \
    CONFIG.DIN_TO {8} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_rx_serdes_rst


  # Create instance: xlslice_tx_core_rst, and set properties
  set xlslice_tx_core_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_core_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_core_rst


  # Create instance: xlslice_rx_core_rst, and set properties
  set xlslice_rx_core_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_core_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_core_rst


  # Create instance: xlslice_tx_datapath, and set properties
  set xlslice_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_tx_datapath ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DOUT_WIDTH {24} \
  ] $xlslice_tx_datapath


  # Create instance: xlslice_rx_datapath, and set properties
  set xlslice_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_rx_datapath ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DOUT_WIDTH {24} \
  ] $xlslice_rx_datapath


  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property CONFIG.PS_PMC_CONFIG { \
    DESIGN_MODE {0} \
    PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
    PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
    PS_BOARD_INTERFACE {Custom} \
    PS_NUM_FABRIC_RESETS {1} \
    PS_PCIE1_PERIPHERAL_ENABLE {0} \
    PS_PCIE2_PERIPHERAL_ENABLE {0} \
    PS_UART0_BAUD_RATE {115200} \
    PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
    PS_UART0_RTS_CTS {{ENABLE 0} {IO {PS_MIO 2 .. 3}}} \
    PS_USE_M_AXI_FPD {1} \
    PS_USE_PMCPL_CLK0 {1} \
    SMON_ALARMS {Set_Alarms_On} \
    SMON_ENABLE_TEMP_AVERAGING {0} \
    SMON_TEMP_AVERAGING_SAMPLES {0} \
  } $versal_cips_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_ports APB_M_0] [get_bd_intf_pins axi_apb_bridge_0/APB_M]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M2 [get_bd_intf_ports APB_M2_0] [get_bd_intf_pins axi_apb_bridge_0/APB_M2]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M3 [get_bd_intf_ports APB_M3_0] [get_bd_intf_pins axi_apb_bridge_0/APB_M3]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_ports M00_AXI_0] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_apb_bridge_0/AXI4_LITE] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_gt_ctl/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_ports M00_AXI_1] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_ports M00_AXI_2] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_ports M00_AXI_3] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_ports M00_AXI_4] [get_bd_intf_pins smartconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_ports M00_AXI_5] [get_bd_intf_pins smartconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M08_AXI [get_bd_intf_ports M00_AXI_6] [get_bd_intf_pins smartconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M09_AXI [get_bd_intf_pins axi_gpio_tx_datapath/S_AXI] [get_bd_intf_pins smartconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M10_AXI [get_bd_intf_pins axi_gpio_rx_datapath/S_AXI] [get_bd_intf_pins smartconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M11_AXI [get_bd_intf_pins axi_resets_dyn/S_AXI] [get_bd_intf_pins smartconnect_0/M11_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M12_AXI [get_bd_intf_pins axi_reset_done_dyn/S_AXI] [get_bd_intf_pins smartconnect_0/M12_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]

  # Create port connections
  connect_bd_net -net axi_gpio_gt_ctl_gpio_io_o [get_bd_pins axi_gpio_gt_ctl/gpio_io_o] [get_bd_pins xlslice_gt_reset/Din] [get_bd_pins xlslice_gt_line_rate/Din] [get_bd_pins xlslice_gt_loopback/Din] [get_bd_pins xlslice_gt_txprecursor/Din] [get_bd_pins xlslice_gt_txpostcursor/Din] [get_bd_pins xlslice_gt_txmaincursor/Din] [get_bd_pins xlslice_gt_rxcdrhold/Din]
  connect_bd_net -net axi_gpio_rx_datapath_gpio_io_o [get_bd_pins axi_gpio_rx_datapath/gpio_io_o] [get_bd_pins xlslice_rx_datapath/Din]
  connect_bd_net -net axi_gpio_tx_datapath_gpio_io_o [get_bd_pins axi_gpio_tx_datapath/gpio_io_o] [get_bd_pins xlslice_tx_datapath/Din]
  connect_bd_net -net axi_resets_dyn_gpio_io_o [get_bd_pins axi_resets_dyn/gpio_io_o] [get_bd_pins xlslice_tx_serdes_rst/Din] [get_bd_pins xlslice_rx_serdes_rst/Din] [get_bd_pins xlslice_rx_core_rst/Din] [get_bd_pins xlslice_tx_core_rst/Din]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_ports pl0_resetn_0] [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] [get_bd_pins axi_gpio_gt_ctl/s_axi_aresetn] [get_bd_pins axi_gpio_tx_datapath/s_axi_aresetn] [get_bd_pins axi_gpio_rx_datapath/s_axi_aresetn] [get_bd_pins axi_resets_dyn/s_axi_aresetn] [get_bd_pins axi_reset_done_dyn/s_axi_aresetn]
  connect_bd_net -net rx_reset_done [get_bd_ports gt_rx_reset_done] [get_bd_pins axi_reset_done_dyn/gpio2_io_i]
  connect_bd_net -net tx_reset_done [get_bd_ports gt_tx_reset_done] [get_bd_pins axi_reset_done_dyn/gpio_io_i]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_ports pl0_ref_clk_0] [get_bd_pins axi_apb_bridge_0/s_axi_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk] [get_bd_pins axi_gpio_gt_ctl/s_axi_aclk] [get_bd_pins axi_gpio_tx_datapath/s_axi_aclk] [get_bd_pins axi_gpio_rx_datapath/s_axi_aclk] [get_bd_pins axi_resets_dyn/s_axi_aclk] [get_bd_pins axi_reset_done_dyn/s_axi_aclk]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlslice_gt_line_rate_Dout [get_bd_pins xlslice_gt_line_rate/Dout] [get_bd_ports gt_line_rate]
  connect_bd_net -net xlslice_gt_loopback_Dout [get_bd_pins xlslice_gt_loopback/Dout] [get_bd_ports gt_loopback]
  connect_bd_net -net xlslice_gt_reset_Dout [get_bd_pins xlslice_gt_reset/Dout] [get_bd_ports gt_reset_all_in]
  connect_bd_net -net xlslice_gt_rxcdrhold_Dout [get_bd_pins xlslice_gt_rxcdrhold/Dout] [get_bd_ports gt_rxcdrhold]
  connect_bd_net -net xlslice_gt_txmaincursor_Dout [get_bd_pins xlslice_gt_txmaincursor/Dout] [get_bd_ports gt_txmaincursor]
  connect_bd_net -net xlslice_gt_txpostcursor_Dout [get_bd_pins xlslice_gt_txpostcursor/Dout] [get_bd_ports gt_txpostcursor]
  connect_bd_net -net xlslice_gt_txprecursor_Dout [get_bd_pins xlslice_gt_txprecursor/Dout] [get_bd_ports gt_txprecursor]
  connect_bd_net -net xlslice_rx_core_rst_Dout [get_bd_pins xlslice_rx_core_rst/Dout] [get_bd_ports rx_core_reset]
  connect_bd_net -net xlslice_rx_datapath_Dout [get_bd_pins xlslice_rx_datapath/Dout] [get_bd_ports gt_reset_rx_datapath_in]
  connect_bd_net -net xlslice_rx_serdes_rst_Dout [get_bd_pins xlslice_rx_serdes_rst/Dout] [get_bd_ports rx_serdes_reset]
  connect_bd_net -net xlslice_tx_core_rst_Dout [get_bd_pins xlslice_tx_core_rst/Dout] [get_bd_ports tx_core_reset]
  connect_bd_net -net xlslice_tx_datapath_Dout [get_bd_pins xlslice_tx_datapath/Dout] [get_bd_ports gt_reset_tx_datapath_in]
  connect_bd_net -net xlslice_tx_serdes_rst_Dout [get_bd_pins xlslice_tx_serdes_rst/Dout] [get_bd_ports tx_serdes_reset]

  # Create address segments
  assign_bd_address -offset 0xA4110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs APB_M2_0/Reg] -force
  assign_bd_address -offset 0xA4120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs APB_M3_0/Reg] -force
  assign_bd_address -offset 0xA4100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs APB_M_0/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_0/Reg] -force
  assign_bd_address -offset 0xA4A00000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_1/Reg] -force
  assign_bd_address -offset 0xA4B00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_2/Reg] -force
  assign_bd_address -offset 0xA4C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_3/Reg] -force
  assign_bd_address -offset 0xA4D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_4/Reg] -force
  assign_bd_address -offset 0xA4E00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_5/Reg] -force
  assign_bd_address -offset 0xA4F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs M00_AXI_6/Reg] -force
  assign_bd_address -offset 0xA4130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_gt_ctl/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4150000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_rx_datapath/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_tx_datapath/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4160000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_reset_done_dyn/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_resets_dyn/S_AXI/Reg] -force


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


