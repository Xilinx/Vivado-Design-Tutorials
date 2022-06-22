# #########################################################################
#© Copyright 2021 Xilinx, Inc.

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
# ###########################################################################


################################################################
# This is a generated script based on design: rp1rm3
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
set scripts_vivado_version 2022.1
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
# source rp1rm3_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vck190:part0:2.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name rp1rm3

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
xilinx.com:ip:axi_dbg_hub:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:axis_ila:1.1\
xilinx.com:ip:axis_vio:1.0\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:smartconnect:1.0\
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
  set S00_INI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 -portmaps { \
   INTERNOC { physical_name S00_INI_internoc direction I left 0 right 0 } \
   } \
  S00_INI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {load} \
   ] $S00_INI
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S00_INI]

  set S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI_araddr direction I left 31 right 0 } \
   ARREADY { physical_name S_AXI_arready direction O } \
   ARVALID { physical_name S_AXI_arvalid direction I } \
   AWADDR { physical_name S_AXI_awaddr direction I left 31 right 0 } \
   AWREADY { physical_name S_AXI_awready direction O } \
   AWVALID { physical_name S_AXI_awvalid direction I } \
   BREADY { physical_name S_AXI_bready direction I } \
   BRESP { physical_name S_AXI_bresp direction O left 1 right 0 } \
   BVALID { physical_name S_AXI_bvalid direction O } \
   RDATA { physical_name S_AXI_rdata direction O left 31 right 0 } \
   RREADY { physical_name S_AXI_rready direction I } \
   RRESP { physical_name S_AXI_rresp direction O left 1 right 0 } \
   RVALID { physical_name S_AXI_rvalid direction O } \
   WDATA { physical_name S_AXI_wdata direction I left 31 right 0 } \
   WREADY { physical_name S_AXI_wready direction O } \
   WSTRB { physical_name S_AXI_wstrb direction I left 3 right 0 } \
   WVALID { physical_name S_AXI_wvalid direction I } \
   } \
  S_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {99999900} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI]


  # Create ports
  set s_axi_aclk [ create_bd_port -dir I -type clk -freq_hz 99999900 s_axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S_AXI} \
   CONFIG.ASSOCIATED_CLKEN {CE} \
   CONFIG.ASSOCIATED_RESET {s_axi_aresetn} \
   CONFIG.CLK_DOMAIN {design_1_clk_wizard_0_0_clk_out1} \
   CONFIG.FREQ_TOLERANCE_HZ {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
 ] $s_axi_aclk
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]
  set_property -dict [ list \
   CONFIG.INSERT_VIP {0} \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $s_axi_aresetn

  # Create instance: axi_dbg_hub_0, and set properties
  set axi_dbg_hub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:2.0 axi_dbg_hub_0 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
 ] $axi_gpio_1

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1 ]
  set_property -dict [ list \
   CONFIG.HBM_CHNL0_CONFIG {\
HBM_PC0_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC1_PRE_DEFINED_ADDRESS_MAP\
ROW_BANK_COLUMN HBM_PC0_USER_DEFINED_ADDRESS_MAP NONE\
HBM_PC1_USER_DEFINED_ADDRESS_MAP NONE} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {0} \
 ] $axi_noc_1

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/M00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /axi_noc_1/S00_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk0]

  # Create instance: axis_ila_0, and set properties
  set axis_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.1 axis_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {1} \
   CONFIG.C_MON_TYPE {Net_Probes} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_PROBE0_WIDTH {32} \
 ] $axis_ila_0

  # Create instance: axis_ila_1, and set properties
  set axis_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.1 axis_ila_1 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {1} \
   CONFIG.C_MON_TYPE {Net_Probes} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_PROBE0_WIDTH {32} \
 ] $axis_ila_1

  # Create instance: axis_vio_0, and set properties
  set axis_vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_vio:1.0 axis_vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_OUT {0} \
   CONFIG.C_PROBE_IN0_WIDTH {32} \
 ] $axis_vio_0

  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [ list \
   CONFIG.Count_Mode {UP} \
   CONFIG.Output_Width {32} \
 ] $c_counter_binary_0

  # Create instance: c_counter_binary_1, and set properties
  set c_counter_binary_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_1 ]
  set_property -dict [ list \
   CONFIG.Count_Mode {DOWN} \
   CONFIG.Output_Width {32} \
 ] $c_counter_binary_1

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_ports S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M00_INI [get_bd_intf_ports S00_INI] [get_bd_intf_pins axi_noc_1/S00_INI]
  connect_bd_intf_net -intf_net axi_noc_1_M00_AXI [get_bd_intf_pins axi_dbg_hub_0/S_AXI] [get_bd_intf_pins axi_noc_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]

  # Create port connections
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins axis_ila_0/probe0] [get_bd_pins axis_vio_0/probe_in0] [get_bd_pins c_counter_binary_0/Q]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets c_counter_binary_0_Q]
  connect_bd_net -net c_counter_binary_1_Q [get_bd_pins axi_gpio_1/gpio_io_i] [get_bd_pins axis_ila_1/probe0] [get_bd_pins c_counter_binary_1/Q]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets c_counter_binary_1_Q]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_ports s_axi_aclk] [get_bd_pins axi_dbg_hub_0/aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_noc_1/aclk0] [get_bd_pins axis_ila_0/clk] [get_bd_pins axis_ila_1/clk] [get_bd_pins axis_vio_0/clk] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins c_counter_binary_1/CLK] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_ports s_axi_aresetn] [get_bd_pins axi_dbg_hub_0/aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn]

  # Create address segments
  assign_bd_address -offset 0x020100000000 -range 0x00200000 -target_address_space [get_bd_addr_spaces S00_INI] [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
  assign_bd_address -offset 0x80220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force


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


