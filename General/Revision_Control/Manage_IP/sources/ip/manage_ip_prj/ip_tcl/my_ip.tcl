#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source all.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project vivado_prj_xci_bd vivado_prj_xci_bd -part xcvc1902-vsva2197-2MP-e-S
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
  set list_check_ips { xilinx.com:ip:axi_bram_ctrl:4.1 xilinx.com:ip:axi_traffic_gen:3.0 xilinx.com:ip:axis_vio:1.0 }
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
# CREATE IP axi_bram_ctrl_pl_slave_from_pl_master
##################################################################

set axi_bram_ctrl_pl_slave_from_pl_master [create_ip -name axi_bram_ctrl -vendor xilinx.com -library ip -version 4.1 -module_name axi_bram_ctrl_pl_slave_from_pl_master]

# User Parameters
set_property -dict [list \
  CONFIG.BMG_INSTANCE {INTERNAL} \
  CONFIG.DATA_WIDTH {512} \
  CONFIG.ID_WIDTH {2} \
  CONFIG.MEM_DEPTH {1024} \
  CONFIG.SINGLE_PORT_BRAM {1} \
] [get_ips axi_bram_ctrl_pl_slave_from_pl_master]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axi_bram_ctrl_pl_slave_from_pl_master

##################################################################

##################################################################
# CREATE IP axi_bram_ctrl_pl_slave_from_ps
##################################################################

set axi_bram_ctrl_pl_slave_from_ps [create_ip -name axi_bram_ctrl -vendor xilinx.com -library ip -version 4.1 -module_name axi_bram_ctrl_pl_slave_from_ps]

# User Parameters
set_property -dict [list \
  CONFIG.BMG_INSTANCE {INTERNAL} \
  CONFIG.DATA_WIDTH {512} \
  CONFIG.ID_WIDTH {2} \
  CONFIG.MEM_DEPTH {1024} \
  CONFIG.SINGLE_PORT_BRAM {1} \
] [get_ips axi_bram_ctrl_pl_slave_from_ps]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axi_bram_ctrl_pl_slave_from_ps

##################################################################

##################################################################
# CREATE IP axi_tg_pl_master_to_ddr
##################################################################

set axi_tg_pl_master_to_ddr [create_ip -name axi_traffic_gen -vendor xilinx.com -library ip -version 3.0 -module_name axi_tg_pl_master_to_ddr]

# User Parameters
set_property -dict [list \
  CONFIG.ATG_OPTIONS {High Level Traffic} \
  CONFIG.C_ATG_MODE {AXI4} \
  CONFIG.C_EXTENDED_ADDRESS_WIDTH {48} \
  CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {48} \
  CONFIG.C_HIGHADDR {0xffffffff} \
  CONFIG.C_M_AXI_DATA_WIDTH {512} \
  CONFIG.DATA_SIZE_AVG {8} \
  CONFIG.DATA_SIZE_MAX {64} \
  CONFIG.MASTER_AXI_WIDTH {512} \
  CONFIG.MASTER_HIGH_ADDRESS {0x7FFFFFFF} \
  CONFIG.TRAFFIC_PROFILE {Data} \
] [get_ips axi_tg_pl_master_to_ddr]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axi_tg_pl_master_to_ddr

##################################################################

##################################################################
# CREATE IP axi_tg_pl_to_pl
##################################################################

set axi_tg_pl_to_pl [create_ip -name axi_traffic_gen -vendor xilinx.com -library ip -version 3.0 -module_name axi_tg_pl_to_pl]

# User Parameters
set_property -dict [list \
  CONFIG.ATG_OPTIONS {High Level Traffic} \
  CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {48} \
  CONFIG.MASTER_AXI_WIDTH {512} \
  CONFIG.MASTER_BASE_ADDRESS_EXT {0x00000202} \
  CONFIG.MASTER_HIGH_ADDRESS {0x001FFFFF} \
  CONFIG.MASTER_HIGH_ADDRESS_EXT {0x00000202} \
  CONFIG.TRAFFIC_PROFILE {Data} \
] [get_ips axi_tg_pl_to_pl]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axi_tg_pl_to_pl

##################################################################

##################################################################
# CREATE IP axi_tg_pl_to_ps
##################################################################

set axi_tg_pl_to_ps [create_ip -name axi_traffic_gen -vendor xilinx.com -library ip -version 3.0 -module_name axi_tg_pl_to_ps]

# User Parameters
set_property -dict [list \
  CONFIG.ATG_OPTIONS {High Level Traffic} \
  CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {48} \
  CONFIG.MASTER_AXI_WIDTH {128} \
  CONFIG.MASTER_BASE_ADDRESS {0xFFFC0000} \
  CONFIG.MASTER_HIGH_ADDRESS {0xFFFFFFFF} \
  CONFIG.TRAFFIC_PROFILE {Data} \
] [get_ips axi_tg_pl_to_ps]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axi_tg_pl_to_ps

##################################################################

##################################################################
# CREATE IP axis_MxN_vio
##################################################################

set axis_MxN_vio [create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_MxN_vio]

# User Parameters
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {2} \
  CONFIG.C_PROBE_IN0_WIDTH {16} \
  CONFIG.C_PROBE_IN1_WIDTH {16} \
] [get_ips axis_MxN_vio]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axis_MxN_vio

##################################################################

##################################################################
# CREATE IP axis_vio_pl_master_to_ddr
##################################################################

set axis_vio_pl_master_to_ddr [create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_vio_pl_master_to_ddr]

# User Parameters
set_property -dict [list \
  CONFIG.C_PROBE_IN0_WIDTH {2} \
  CONFIG.C_PROBE_OUT0_WIDTH {2} \
] [get_ips axis_vio_pl_master_to_ddr]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axis_vio_pl_master_to_ddr

##################################################################

##################################################################
# CREATE IP axis_vio_pl_master_to_pl_slave
##################################################################

set axis_vio_pl_master_to_pl_slave [create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_vio_pl_master_to_pl_slave]

# User Parameters
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {1} \
  CONFIG.C_NUM_PROBE_OUT {1} \
  CONFIG.C_PROBE_IN0_WIDTH {2} \
  CONFIG.C_PROBE_OUT0_WIDTH {2} \
] [get_ips axis_vio_pl_master_to_pl_slave]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axis_vio_pl_master_to_pl_slave

##################################################################

##################################################################
# CREATE IP axis_vio_pl_master_to_ps
##################################################################

set axis_vio_pl_master_to_ps [create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_vio_pl_master_to_ps]

# User Parameters
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {1} \
  CONFIG.C_PROBE_IN0_WIDTH {2} \
  CONFIG.C_PROBE_OUT0_WIDTH {2} \
] [get_ips axis_vio_pl_master_to_ps]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $axis_vio_pl_master_to_ps

##################################################################

