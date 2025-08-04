#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#
##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source axi_traffic_gen_0.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project project_1 vivado_prj -part xcvc1902-vsva2197-2MP-e-S
  set_property BOARD_PART xilinx.com:vck190:part0:3.2 [current_project]
  set_property target_language Verilog [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:axi_traffic_gen:3.0 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP axi_traffic_gen_0
##################################################################

set axi_traffic_gen_0 [create_ip -name axi_traffic_gen -vendor xilinx.com -library ip -version 3.0 -module_name axi_traffic_gen_0]

# User Parameters
set_property -dict [list \
  CONFIG.ATG_OPTIONS {High Level Traffic} \
  CONFIG.C_ATG_MODE {AXI4} \
  CONFIG.C_ATG_REPEAT_TYPE {One_Shot} \
  CONFIG.C_ATG_STATIC_HLTP_INCR {true} \
  CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {32} \
  CONFIG.C_M_AXI_DATA_WIDTH {512} \
  CONFIG.DATA_ITG_GAP {7} \
  CONFIG.DATA_SIZE_AVG {1} \
  CONFIG.DATA_TRAFFIC_PATTERN {Fixed} \
  CONFIG.DATA_TRANS_GAP {Fixed} \
  CONFIG.DATA_TRANS_TYPE {Read_Write} \
  CONFIG.MASTER_AXI_WIDTH {512} \
  CONFIG.TRAFFIC_PROFILE {Data} \
] [get_ips axi_traffic_gen_0]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axi_traffic_gen_0

##################################################################

