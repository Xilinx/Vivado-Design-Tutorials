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
# This is a generated script based on design: rp2rm2
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
# source rp2rm2_script.tcl

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
set design_name rp2rm2

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
xilinx.com:ip:axi_traffic_gen:3.0\
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
  set M00_INI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 -portmaps { \
   INTERNOC { physical_name M00_INI_internoc direction O left 0 right 0 } \
   } \
  M00_INI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {auto} \
   ] $M00_INI
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M00_INI]
  set_property APERTURES {{0x203_4000_0000 64K}} [get_bd_intf_ports M00_INI]

  set S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI_araddr direction I left 41 right 0 } \
   ARBURST { physical_name S_AXI_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI_arcache direction I left 3 right 0 } \
   ARLEN { physical_name S_AXI_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI_arready direction O } \
   ARSIZE { physical_name S_AXI_arsize direction I left 2 right 0 } \
   ARVALID { physical_name S_AXI_arvalid direction I } \
   AWADDR { physical_name S_AXI_awaddr direction I left 41 right 0 } \
   AWBURST { physical_name S_AXI_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI_awcache direction I left 3 right 0 } \
   AWLEN { physical_name S_AXI_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI_awready direction O } \
   AWSIZE { physical_name S_AXI_awsize direction I left 2 right 0 } \
   AWVALID { physical_name S_AXI_awvalid direction I } \
   BREADY { physical_name S_AXI_bready direction I } \
   BRESP { physical_name S_AXI_bresp direction O left 1 right 0 } \
   BVALID { physical_name S_AXI_bvalid direction O } \
   RDATA { physical_name S_AXI_rdata direction O left 31 right 0 } \
   RLAST { physical_name S_AXI_rlast direction O } \
   RREADY { physical_name S_AXI_rready direction I } \
   RRESP { physical_name S_AXI_rresp direction O left 1 right 0 } \
   RVALID { physical_name S_AXI_rvalid direction O } \
   WDATA { physical_name S_AXI_wdata direction I left 31 right 0 } \
   WLAST { physical_name S_AXI_wlast direction I } \
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
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {7} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {7} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI]
  set_property APERTURES {{0x202_8000_0000 64K}} [get_bd_intf_ports S_AXI]


  # Create ports
  set aclk0 [ create_bd_port -dir I -type clk aclk0 ]
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1 ]
  set_property -dict [ list \
   CONFIG.MC_NETLIST_SIMULATION {true} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NMI {1} \
   CONFIG.NUM_NSI {0} \
   CONFIG.NUM_SI {1} \
 ] $axi_noc_1

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.APERTURES {{0x202_0000_0000 1G}} \
 ] [get_bd_intf_pins /axi_noc_1/M00_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {M00_INI { read_bw {1720} write_bw {1720}} } \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/S00_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk0]

  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [ list \
   CONFIG.C_ATG_MODE_L2 {Static} \
   CONFIG.C_ATG_STATIC_INCR {true} \
   CONFIG.C_ATG_STATIC_RD_ADDRESS {0x40000000} \
   CONFIG.C_ATG_STATIC_RD_ADDRESS_EXT {0x00000203} \
   CONFIG.C_ATG_STATIC_RD_HIGH_ADDRESS {0x40001FFF} \
   CONFIG.C_ATG_STATIC_RD_HIGH_ADDRESS_EXT {0x00000203} \
   CONFIG.C_ATG_STATIC_WR_ADDRESS {0x40000000} \
   CONFIG.C_ATG_STATIC_WR_ADDRESS_EXT {0x00000203} \
   CONFIG.C_ATG_STATIC_WR_HIGH_ADDRESS {0x40001FFF} \
   CONFIG.C_ATG_STATIC_WR_HIGH_ADDRESS_EXT {0x00000203} \
   CONFIG.C_EXTENDED_ADDRESS_WIDTH {64} \
 ] $axi_traffic_gen_0

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_ports S_AXI] [get_bd_intf_pins axi_traffic_gen_0/S_AXI]
  connect_bd_intf_net -intf_net axi_noc_1_M00_INI [get_bd_intf_ports M00_INI] [get_bd_intf_pins axi_noc_1/M00_INI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins axi_noc_1/S00_AXI] [get_bd_intf_pins axi_traffic_gen_0/M_AXI]

  # Create port connections
  connect_bd_net -net aclk0_1 [get_bd_ports aclk0] [get_bd_pins axi_noc_1/aclk0] [get_bd_pins axi_traffic_gen_0/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_ports s_axi_aresetn] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn]

  # Create address segments
  assign_bd_address -offset 0x020340000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Data] [get_bd_addr_segs M00_INI/Reg] -force
  assign_bd_address -offset 0x020280000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI] [get_bd_addr_segs axi_traffic_gen_0/S_AXI/Reg0] -force


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


