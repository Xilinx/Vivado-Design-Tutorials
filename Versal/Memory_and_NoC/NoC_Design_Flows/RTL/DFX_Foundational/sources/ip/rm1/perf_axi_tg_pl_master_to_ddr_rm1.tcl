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
# source perf_axi_tg_pl_master_to_ddr_rm1.tcl
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
  set list_check_ips { xilinx.com:ip:perf_axi_tg:1.0 }
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
# CREATE IP perf_axi_tg_pl_master_to_ddr_rm1
##################################################################

set perf_axi_tg_pl_master_to_ddr_rm1 [create_ip -name perf_axi_tg -vendor xilinx.com -library ip -version 1.0 -module_name perf_axi_tg_pl_master_to_ddr_rm1]

# User Parameters
set_property -dict [list \
  CONFIG.EN_ILA_DEBUG {FALSE} \
  CONFIG.USER_C_AXI_READ_SIZE {1} \
  CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
  CONFIG.USER_C_AXI_WRITE_SIZE {1} \
  CONFIG.USER_DI_ERR_CNT_STOP_TRFC {1} \
  CONFIG.USER_EN_LATENCY_LOGIC {Enabled_with_Constant_ID} \
  CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
  CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
  CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../sources/csv/ptg_traffic.csv} \
  CONFIG.USER_SYNTH_DI_EN {Enabled_with_Constant_ID} \
  CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  CONFIG.USER_DEBUG_INTF {TRUE} \
] [get_ips perf_axi_tg_pl_master_to_ddr_rm1]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $perf_axi_tg_pl_master_to_ddr_rm1

##################################################################

