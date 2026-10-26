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
# This is a generated script based on design: rp_slr0
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
# source rp_slr0_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu13p-fhga2104-3-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name rp_slr0

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
xilinx.com:ip:axi4stream_vip:1.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:debug_bridge:3.0\
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
  set C0_DDR4_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 -portmaps { \
   ACT_N { physical_name C0_DDR4_0_act_n direction O } \
   ADR { physical_name C0_DDR4_0_adr direction O left 16 right 0 } \
   BA { physical_name C0_DDR4_0_ba direction O left 1 right 0 } \
   BG { physical_name C0_DDR4_0_bg direction O left 1 right 0 } \
   CK_C { physical_name C0_DDR4_0_ck_c direction O left 0 right 0 } \
   CK_T { physical_name C0_DDR4_0_ck_t direction O left 0 right 0 } \
   CKE { physical_name C0_DDR4_0_cke direction O left 0 right 0 } \
   CS_N { physical_name C0_DDR4_0_cs_n direction O left 0 right 0 } \
   DM_N { physical_name C0_DDR4_0_dm_n direction IO left 0 right 0 } \
   DQ { physical_name C0_DDR4_0_dq direction IO left 7 right 0 } \
   DQS_C { physical_name C0_DDR4_0_dqs_c direction IO left 0 right 0 } \
   DQS_T { physical_name C0_DDR4_0_dqs_t direction IO left 0 right 0 } \
   ODT { physical_name C0_DDR4_0_odt direction O left 0 right 0 } \
   RESET_N { physical_name C0_DDR4_0_reset_n direction O } \
   } \
  C0_DDR4_0 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $C0_DDR4_0
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_DDR4_0]

  set C0_SYS_CLK_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name C0_SYS_CLK_0_clk_n direction I } \
   CLK_P { physical_name C0_SYS_CLK_0_clk_p direction I } \
   } \
  C0_SYS_CLK_0 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $C0_SYS_CLK_0
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_SYS_CLK_0]

  set M_AXI0_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI0_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI0_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI0_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI0_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI0_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI0_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI0_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI0_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI0_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI0_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI0_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI0_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI0_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI0_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI0_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI0_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI0_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI0_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI0_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI0_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI0_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI0_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI0_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI0_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI0_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI0_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI0_SLR01_bid direction I } \
   BREADY { physical_name M_AXI0_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI0_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI0_SLR01_buser direction I } \
   BVALID { physical_name M_AXI0_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI0_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI0_SLR01_rid direction I } \
   RLAST { physical_name M_AXI0_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI0_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI0_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI0_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI0_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI0_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI0_SLR01_wid direction O } \
   WLAST { physical_name M_AXI0_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI0_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI0_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI0_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI0_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI0_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI0_SLR01]

  set M_AXI10_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI10_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI10_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI10_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI10_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI10_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI10_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI10_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI10_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI10_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI10_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI10_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI10_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI10_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI10_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI10_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI10_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI10_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI10_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI10_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI10_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI10_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI10_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI10_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI10_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI10_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI10_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI10_SLR01_bid direction I } \
   BREADY { physical_name M_AXI10_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI10_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI10_SLR01_buser direction I } \
   BVALID { physical_name M_AXI10_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI10_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI10_SLR01_rid direction I } \
   RLAST { physical_name M_AXI10_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI10_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI10_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI10_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI10_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI10_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI10_SLR01_wid direction O } \
   WLAST { physical_name M_AXI10_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI10_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI10_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI10_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI10_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI10_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI10_SLR01]

  set M_AXI11_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI11_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI11_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI11_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI11_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI11_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI11_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI11_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI11_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI11_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI11_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI11_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI11_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI11_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI11_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI11_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI11_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI11_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI11_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI11_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI11_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI11_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI11_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI11_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI11_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI11_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI11_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI11_SLR01_bid direction I } \
   BREADY { physical_name M_AXI11_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI11_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI11_SLR01_buser direction I } \
   BVALID { physical_name M_AXI11_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI11_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI11_SLR01_rid direction I } \
   RLAST { physical_name M_AXI11_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI11_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI11_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI11_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI11_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI11_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI11_SLR01_wid direction O } \
   WLAST { physical_name M_AXI11_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI11_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI11_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI11_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI11_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI11_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI11_SLR01]

  set M_AXI12_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI12_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI12_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI12_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI12_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI12_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI12_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI12_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI12_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI12_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI12_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI12_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI12_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI12_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI12_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI12_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI12_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI12_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI12_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI12_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI12_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI12_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI12_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI12_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI12_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI12_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI12_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI12_SLR01_bid direction I } \
   BREADY { physical_name M_AXI12_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI12_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI12_SLR01_buser direction I } \
   BVALID { physical_name M_AXI12_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI12_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI12_SLR01_rid direction I } \
   RLAST { physical_name M_AXI12_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI12_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI12_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI12_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI12_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI12_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI12_SLR01_wid direction O } \
   WLAST { physical_name M_AXI12_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI12_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI12_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI12_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI12_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI12_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI12_SLR01]

  set M_AXI13_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI13_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI13_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI13_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI13_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI13_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI13_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI13_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI13_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI13_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI13_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI13_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI13_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI13_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI13_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI13_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI13_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI13_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI13_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI13_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI13_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI13_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI13_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI13_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI13_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI13_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI13_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI13_SLR01_bid direction I } \
   BREADY { physical_name M_AXI13_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI13_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI13_SLR01_buser direction I } \
   BVALID { physical_name M_AXI13_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI13_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI13_SLR01_rid direction I } \
   RLAST { physical_name M_AXI13_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI13_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI13_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI13_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI13_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI13_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI13_SLR01_wid direction O } \
   WLAST { physical_name M_AXI13_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI13_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI13_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI13_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI13_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI13_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI13_SLR01]

  set M_AXI14_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI14_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI14_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI14_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI14_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI14_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI14_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI14_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI14_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI14_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI14_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI14_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI14_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI14_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI14_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI14_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI14_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI14_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI14_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI14_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI14_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI14_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI14_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI14_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI14_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI14_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI14_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI14_SLR01_bid direction I } \
   BREADY { physical_name M_AXI14_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI14_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI14_SLR01_buser direction I } \
   BVALID { physical_name M_AXI14_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI14_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI14_SLR01_rid direction I } \
   RLAST { physical_name M_AXI14_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI14_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI14_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI14_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI14_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI14_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI14_SLR01_wid direction O } \
   WLAST { physical_name M_AXI14_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI14_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI14_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI14_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI14_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI14_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI14_SLR01]

  set M_AXI15_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI15_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI15_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI15_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI15_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI15_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI15_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI15_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI15_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI15_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI15_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI15_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI15_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI15_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI15_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI15_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI15_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI15_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI15_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI15_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI15_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI15_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI15_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI15_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI15_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI15_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI15_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI15_SLR01_bid direction I } \
   BREADY { physical_name M_AXI15_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI15_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI15_SLR01_buser direction I } \
   BVALID { physical_name M_AXI15_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI15_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI15_SLR01_rid direction I } \
   RLAST { physical_name M_AXI15_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI15_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI15_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI15_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI15_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI15_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI15_SLR01_wid direction O } \
   WLAST { physical_name M_AXI15_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI15_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI15_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI15_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI15_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI15_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI15_SLR01]

  set M_AXI1_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI1_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI1_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI1_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI1_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI1_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI1_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI1_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI1_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI1_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI1_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI1_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI1_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI1_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI1_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI1_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI1_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI1_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI1_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI1_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI1_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI1_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI1_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI1_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI1_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI1_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI1_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI1_SLR01_bid direction I } \
   BREADY { physical_name M_AXI1_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI1_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI1_SLR01_buser direction I } \
   BVALID { physical_name M_AXI1_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI1_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI1_SLR01_rid direction I } \
   RLAST { physical_name M_AXI1_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI1_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI1_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI1_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI1_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI1_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI1_SLR01_wid direction O } \
   WLAST { physical_name M_AXI1_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI1_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI1_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI1_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI1_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI1_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI1_SLR01]

  set M_AXI2_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI2_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI2_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI2_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI2_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI2_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI2_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI2_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI2_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI2_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI2_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI2_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI2_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI2_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI2_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI2_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI2_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI2_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI2_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI2_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI2_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI2_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI2_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI2_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI2_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI2_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI2_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI2_SLR01_bid direction I } \
   BREADY { physical_name M_AXI2_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI2_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI2_SLR01_buser direction I } \
   BVALID { physical_name M_AXI2_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI2_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI2_SLR01_rid direction I } \
   RLAST { physical_name M_AXI2_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI2_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI2_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI2_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI2_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI2_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI2_SLR01_wid direction O } \
   WLAST { physical_name M_AXI2_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI2_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI2_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI2_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI2_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI2_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI2_SLR01]

  set M_AXI3_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI3_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI3_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI3_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI3_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI3_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI3_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI3_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI3_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI3_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI3_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI3_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI3_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI3_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI3_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI3_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI3_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI3_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI3_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI3_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI3_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI3_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI3_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI3_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI3_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI3_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI3_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI3_SLR01_bid direction I } \
   BREADY { physical_name M_AXI3_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI3_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI3_SLR01_buser direction I } \
   BVALID { physical_name M_AXI3_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI3_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI3_SLR01_rid direction I } \
   RLAST { physical_name M_AXI3_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI3_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI3_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI3_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI3_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI3_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI3_SLR01_wid direction O } \
   WLAST { physical_name M_AXI3_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI3_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI3_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI3_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI3_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI3_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI3_SLR01]

  set M_AXI4_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI4_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI4_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI4_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI4_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI4_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI4_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI4_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI4_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI4_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI4_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI4_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI4_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI4_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI4_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI4_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI4_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI4_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI4_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI4_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI4_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI4_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI4_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI4_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI4_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI4_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI4_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI4_SLR01_bid direction I } \
   BREADY { physical_name M_AXI4_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI4_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI4_SLR01_buser direction I } \
   BVALID { physical_name M_AXI4_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI4_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI4_SLR01_rid direction I } \
   RLAST { physical_name M_AXI4_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI4_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI4_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI4_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI4_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI4_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI4_SLR01_wid direction O } \
   WLAST { physical_name M_AXI4_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI4_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI4_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI4_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI4_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI4_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI4_SLR01]

  set M_AXI5_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI5_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI5_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI5_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI5_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI5_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI5_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI5_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI5_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI5_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI5_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI5_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI5_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI5_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI5_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI5_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI5_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI5_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI5_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI5_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI5_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI5_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI5_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI5_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI5_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI5_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI5_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI5_SLR01_bid direction I } \
   BREADY { physical_name M_AXI5_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI5_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI5_SLR01_buser direction I } \
   BVALID { physical_name M_AXI5_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI5_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI5_SLR01_rid direction I } \
   RLAST { physical_name M_AXI5_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI5_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI5_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI5_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI5_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI5_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI5_SLR01_wid direction O } \
   WLAST { physical_name M_AXI5_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI5_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI5_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI5_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI5_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI5_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI5_SLR01]

  set M_AXI6_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI6_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI6_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI6_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI6_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI6_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI6_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI6_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI6_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI6_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI6_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI6_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI6_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI6_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI6_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI6_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI6_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI6_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI6_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI6_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI6_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI6_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI6_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI6_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI6_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI6_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI6_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI6_SLR01_bid direction I } \
   BREADY { physical_name M_AXI6_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI6_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI6_SLR01_buser direction I } \
   BVALID { physical_name M_AXI6_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI6_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI6_SLR01_rid direction I } \
   RLAST { physical_name M_AXI6_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI6_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI6_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI6_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI6_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI6_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI6_SLR01_wid direction O } \
   WLAST { physical_name M_AXI6_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI6_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI6_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI6_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI6_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI6_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI6_SLR01]

  set M_AXI7_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI7_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI7_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI7_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI7_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI7_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI7_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI7_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI7_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI7_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI7_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI7_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI7_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI7_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI7_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI7_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI7_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI7_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI7_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI7_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI7_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI7_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI7_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI7_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI7_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI7_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI7_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI7_SLR01_bid direction I } \
   BREADY { physical_name M_AXI7_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI7_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI7_SLR01_buser direction I } \
   BVALID { physical_name M_AXI7_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI7_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI7_SLR01_rid direction I } \
   RLAST { physical_name M_AXI7_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI7_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI7_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI7_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI7_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI7_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI7_SLR01_wid direction O } \
   WLAST { physical_name M_AXI7_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI7_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI7_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI7_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI7_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI7_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI7_SLR01]

  set M_AXI8_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI8_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI8_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI8_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI8_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI8_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI8_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI8_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI8_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI8_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI8_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI8_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI8_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI8_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI8_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI8_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI8_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI8_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI8_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI8_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI8_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI8_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI8_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI8_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI8_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI8_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI8_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI8_SLR01_bid direction I } \
   BREADY { physical_name M_AXI8_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI8_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI8_SLR01_buser direction I } \
   BVALID { physical_name M_AXI8_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI8_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI8_SLR01_rid direction I } \
   RLAST { physical_name M_AXI8_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI8_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI8_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI8_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI8_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI8_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI8_SLR01_wid direction O } \
   WLAST { physical_name M_AXI8_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI8_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI8_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI8_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI8_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI8_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI8_SLR01]

  set M_AXI9_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI9_SLR01_araddr direction O left 31 right 0 } \
   ARBURST { physical_name M_AXI9_SLR01_arburst direction O left 1 right 0 } \
   ARCACHE { physical_name M_AXI9_SLR01_arcache direction O left 3 right 0 } \
   ARID { physical_name M_AXI9_SLR01_arid direction O } \
   ARLEN { physical_name M_AXI9_SLR01_arlen direction O left 7 right 0 } \
   ARLOCK { physical_name M_AXI9_SLR01_arlock direction O left 0 right 0 } \
   ARPROT { physical_name M_AXI9_SLR01_arprot direction O left 2 right 0 } \
   ARQOS { physical_name M_AXI9_SLR01_arqos direction O left 3 right 0 } \
   ARREADY { physical_name M_AXI9_SLR01_arready direction I left 0 right 0 } \
   ARREGION { physical_name M_AXI9_SLR01_arregion direction O left 3 right 0 } \
   ARSIZE { physical_name M_AXI9_SLR01_arsize direction O left 2 right 0 } \
   ARUSER { physical_name M_AXI9_SLR01_aruser direction O } \
   ARVALID { physical_name M_AXI9_SLR01_arvalid direction O left 0 right 0 } \
   AWADDR { physical_name M_AXI9_SLR01_awaddr direction O left 31 right 0 } \
   AWBURST { physical_name M_AXI9_SLR01_awburst direction O left 1 right 0 } \
   AWCACHE { physical_name M_AXI9_SLR01_awcache direction O left 3 right 0 } \
   AWID { physical_name M_AXI9_SLR01_awid direction O } \
   AWLEN { physical_name M_AXI9_SLR01_awlen direction O left 7 right 0 } \
   AWLOCK { physical_name M_AXI9_SLR01_awlock direction O left 0 right 0 } \
   AWPROT { physical_name M_AXI9_SLR01_awprot direction O left 2 right 0 } \
   AWQOS { physical_name M_AXI9_SLR01_awqos direction O left 3 right 0 } \
   AWREADY { physical_name M_AXI9_SLR01_awready direction I left 0 right 0 } \
   AWREGION { physical_name M_AXI9_SLR01_awregion direction O left 3 right 0 } \
   AWSIZE { physical_name M_AXI9_SLR01_awsize direction O left 2 right 0 } \
   AWUSER { physical_name M_AXI9_SLR01_awuser direction O } \
   AWVALID { physical_name M_AXI9_SLR01_awvalid direction O left 0 right 0 } \
   BID { physical_name M_AXI9_SLR01_bid direction I } \
   BREADY { physical_name M_AXI9_SLR01_bready direction O left 0 right 0 } \
   BRESP { physical_name M_AXI9_SLR01_bresp direction I left 1 right 0 } \
   BUSER { physical_name M_AXI9_SLR01_buser direction I } \
   BVALID { physical_name M_AXI9_SLR01_bvalid direction I left 0 right 0 } \
   RDATA { physical_name M_AXI9_SLR01_rdata direction I left 31 right 0 } \
   RID { physical_name M_AXI9_SLR01_rid direction I } \
   RLAST { physical_name M_AXI9_SLR01_rlast direction I left 0 right 0 } \
   RREADY { physical_name M_AXI9_SLR01_rready direction O left 0 right 0 } \
   RRESP { physical_name M_AXI9_SLR01_rresp direction I left 1 right 0 } \
   RUSER { physical_name M_AXI9_SLR01_ruser direction I } \
   RVALID { physical_name M_AXI9_SLR01_rvalid direction I left 0 right 0 } \
   WDATA { physical_name M_AXI9_SLR01_wdata direction O left 31 right 0 } \
   WID { physical_name M_AXI9_SLR01_wid direction O } \
   WLAST { physical_name M_AXI9_SLR01_wlast direction O left 0 right 0 } \
   WREADY { physical_name M_AXI9_SLR01_wready direction I left 0 right 0 } \
   WSTRB { physical_name M_AXI9_SLR01_wstrb direction O left 3 right 0 } \
   WUSER { physical_name M_AXI9_SLR01_wuser direction O } \
   WVALID { physical_name M_AXI9_SLR01_wvalid direction O left 0 right 0 } \
   } \
  M_AXI9_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI9_SLR01]

  set M_AXIS0_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS0_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS0_SLR01_tdest direction O } \
   TID { physical_name M_AXIS0_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS0_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS0_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS0_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS0_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS0_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS0_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS0_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS0_SLR01]

  set M_AXIS10_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS10_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS10_SLR01_tdest direction O } \
   TID { physical_name M_AXIS10_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS10_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS10_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS10_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS10_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS10_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS10_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS10_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS10_SLR01]

  set M_AXIS11_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS11_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS11_SLR01_tdest direction O } \
   TID { physical_name M_AXIS11_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS11_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS11_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS11_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS11_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS11_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS11_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS11_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS11_SLR01]

  set M_AXIS12_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS12_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS12_SLR01_tdest direction O } \
   TID { physical_name M_AXIS12_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS12_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS12_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS12_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS12_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS12_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS12_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS12_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS12_SLR01]

  set M_AXIS13_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS13_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS13_SLR01_tdest direction O } \
   TID { physical_name M_AXIS13_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS13_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS13_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS13_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS13_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS13_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS13_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS13_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS13_SLR01]

  set M_AXIS14_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS14_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS14_SLR01_tdest direction O } \
   TID { physical_name M_AXIS14_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS14_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS14_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS14_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS14_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS14_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS14_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS14_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS14_SLR01]

  set M_AXIS15_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS15_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS15_SLR01_tdest direction O } \
   TID { physical_name M_AXIS15_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS15_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS15_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS15_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS15_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS15_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS15_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS15_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS15_SLR01]

  set M_AXIS1_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS1_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS1_SLR01_tdest direction O } \
   TID { physical_name M_AXIS1_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS1_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS1_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS1_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS1_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS1_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS1_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS1_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS1_SLR01]

  set M_AXIS2_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS2_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS2_SLR01_tdest direction O } \
   TID { physical_name M_AXIS2_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS2_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS2_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS2_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS2_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS2_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS2_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS2_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS2_SLR01]

  set M_AXIS3_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS3_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS3_SLR01_tdest direction O } \
   TID { physical_name M_AXIS3_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS3_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS3_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS3_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS3_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS3_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS3_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS3_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS3_SLR01]

  set M_AXIS4_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS4_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS4_SLR01_tdest direction O } \
   TID { physical_name M_AXIS4_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS4_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS4_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS4_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS4_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS4_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS4_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS4_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS4_SLR01]

  set M_AXIS5_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS5_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS5_SLR01_tdest direction O } \
   TID { physical_name M_AXIS5_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS5_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS5_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS5_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS5_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS5_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS5_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS5_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS5_SLR01]

  set M_AXIS6_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS6_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS6_SLR01_tdest direction O } \
   TID { physical_name M_AXIS6_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS6_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS6_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS6_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS6_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS6_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS6_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS6_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS6_SLR01]

  set M_AXIS7_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS7_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS7_SLR01_tdest direction O } \
   TID { physical_name M_AXIS7_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS7_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS7_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS7_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS7_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS7_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS7_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS7_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS7_SLR01]

  set M_AXIS8_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS8_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS8_SLR01_tdest direction O } \
   TID { physical_name M_AXIS8_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS8_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS8_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS8_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS8_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS8_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS8_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS8_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS8_SLR01]

  set M_AXIS9_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS9_SLR01_tdata direction O left 7 right 0 } \
   TDEST { physical_name M_AXIS9_SLR01_tdest direction O } \
   TID { physical_name M_AXIS9_SLR01_tid direction O } \
   TKEEP { physical_name M_AXIS9_SLR01_tkeep direction O } \
   TLAST { physical_name M_AXIS9_SLR01_tlast direction O left 0 right 0 } \
   TREADY { physical_name M_AXIS9_SLR01_tready direction I left 0 right 0 } \
   TSTRB { physical_name M_AXIS9_SLR01_tstrb direction O } \
   TUSER { physical_name M_AXIS9_SLR01_tuser direction O } \
   TVALID { physical_name M_AXIS9_SLR01_tvalid direction O left 0 right 0 } \
   } \
  M_AXIS9_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   ] $M_AXIS9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS9_SLR01]

  set S_AXI0_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI0_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI0_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI0_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI0_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI0_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI0_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI0_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI0_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI0_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI0_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI0_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI0_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI0_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI0_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI0_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI0_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI0_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI0_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI0_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI0_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI0_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI0_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI0_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI0_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI0_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI0_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI0_SLR01_bid direction O } \
   BREADY { physical_name S_AXI0_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI0_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI0_SLR01_buser direction O } \
   BVALID { physical_name S_AXI0_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI0_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI0_SLR01_rid direction O } \
   RLAST { physical_name S_AXI0_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI0_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI0_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI0_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI0_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI0_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI0_SLR01_wid direction I } \
   WLAST { physical_name S_AXI0_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI0_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI0_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI0_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI0_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI0_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI0_SLR01]

  set S_AXI10_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI10_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI10_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI10_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI10_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI10_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI10_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI10_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI10_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI10_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI10_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI10_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI10_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI10_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI10_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI10_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI10_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI10_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI10_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI10_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI10_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI10_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI10_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI10_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI10_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI10_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI10_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI10_SLR01_bid direction O } \
   BREADY { physical_name S_AXI10_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI10_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI10_SLR01_buser direction O } \
   BVALID { physical_name S_AXI10_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI10_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI10_SLR01_rid direction O } \
   RLAST { physical_name S_AXI10_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI10_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI10_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI10_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI10_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI10_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI10_SLR01_wid direction I } \
   WLAST { physical_name S_AXI10_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI10_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI10_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI10_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI10_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI10_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI10_SLR01]

  set S_AXI11_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI11_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI11_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI11_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI11_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI11_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI11_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI11_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI11_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI11_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI11_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI11_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI11_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI11_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI11_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI11_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI11_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI11_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI11_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI11_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI11_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI11_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI11_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI11_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI11_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI11_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI11_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI11_SLR01_bid direction O } \
   BREADY { physical_name S_AXI11_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI11_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI11_SLR01_buser direction O } \
   BVALID { physical_name S_AXI11_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI11_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI11_SLR01_rid direction O } \
   RLAST { physical_name S_AXI11_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI11_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI11_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI11_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI11_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI11_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI11_SLR01_wid direction I } \
   WLAST { physical_name S_AXI11_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI11_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI11_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI11_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI11_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI11_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI11_SLR01]

  set S_AXI12_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI12_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI12_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI12_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI12_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI12_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI12_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI12_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI12_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI12_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI12_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI12_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI12_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI12_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI12_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI12_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI12_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI12_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI12_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI12_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI12_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI12_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI12_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI12_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI12_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI12_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI12_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI12_SLR01_bid direction O } \
   BREADY { physical_name S_AXI12_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI12_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI12_SLR01_buser direction O } \
   BVALID { physical_name S_AXI12_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI12_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI12_SLR01_rid direction O } \
   RLAST { physical_name S_AXI12_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI12_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI12_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI12_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI12_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI12_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI12_SLR01_wid direction I } \
   WLAST { physical_name S_AXI12_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI12_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI12_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI12_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI12_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI12_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI12_SLR01]

  set S_AXI13_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI13_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI13_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI13_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI13_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI13_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI13_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI13_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI13_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI13_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI13_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI13_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI13_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI13_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI13_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI13_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI13_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI13_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI13_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI13_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI13_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI13_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI13_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI13_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI13_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI13_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI13_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI13_SLR01_bid direction O } \
   BREADY { physical_name S_AXI13_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI13_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI13_SLR01_buser direction O } \
   BVALID { physical_name S_AXI13_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI13_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI13_SLR01_rid direction O } \
   RLAST { physical_name S_AXI13_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI13_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI13_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI13_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI13_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI13_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI13_SLR01_wid direction I } \
   WLAST { physical_name S_AXI13_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI13_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI13_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI13_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI13_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI13_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI13_SLR01]

  set S_AXI14_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI14_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI14_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI14_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI14_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI14_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI14_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI14_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI14_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI14_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI14_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI14_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI14_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI14_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI14_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI14_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI14_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI14_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI14_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI14_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI14_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI14_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI14_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI14_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI14_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI14_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI14_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI14_SLR01_bid direction O } \
   BREADY { physical_name S_AXI14_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI14_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI14_SLR01_buser direction O } \
   BVALID { physical_name S_AXI14_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI14_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI14_SLR01_rid direction O } \
   RLAST { physical_name S_AXI14_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI14_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI14_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI14_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI14_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI14_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI14_SLR01_wid direction I } \
   WLAST { physical_name S_AXI14_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI14_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI14_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI14_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI14_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI14_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI14_SLR01]

  set S_AXI15_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI15_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI15_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI15_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI15_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI15_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI15_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI15_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI15_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI15_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI15_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI15_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI15_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI15_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI15_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI15_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI15_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI15_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI15_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI15_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI15_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI15_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI15_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI15_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI15_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI15_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI15_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI15_SLR01_bid direction O } \
   BREADY { physical_name S_AXI15_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI15_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI15_SLR01_buser direction O } \
   BVALID { physical_name S_AXI15_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI15_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI15_SLR01_rid direction O } \
   RLAST { physical_name S_AXI15_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI15_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI15_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI15_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI15_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI15_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI15_SLR01_wid direction I } \
   WLAST { physical_name S_AXI15_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI15_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI15_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI15_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI15_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI15_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI15_SLR01]

  set S_AXI1_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI1_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI1_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI1_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI1_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI1_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI1_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI1_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI1_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI1_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI1_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI1_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI1_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI1_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI1_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI1_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI1_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI1_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI1_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI1_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI1_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI1_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI1_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI1_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI1_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI1_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI1_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI1_SLR01_bid direction O } \
   BREADY { physical_name S_AXI1_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI1_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI1_SLR01_buser direction O } \
   BVALID { physical_name S_AXI1_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI1_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI1_SLR01_rid direction O } \
   RLAST { physical_name S_AXI1_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI1_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI1_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI1_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI1_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI1_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI1_SLR01_wid direction I } \
   WLAST { physical_name S_AXI1_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI1_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI1_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI1_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI1_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI1_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI1_SLR01]

  set S_AXI2_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI2_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI2_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI2_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI2_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI2_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI2_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI2_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI2_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI2_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI2_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI2_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI2_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI2_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI2_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI2_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI2_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI2_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI2_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI2_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI2_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI2_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI2_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI2_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI2_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI2_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI2_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI2_SLR01_bid direction O } \
   BREADY { physical_name S_AXI2_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI2_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI2_SLR01_buser direction O } \
   BVALID { physical_name S_AXI2_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI2_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI2_SLR01_rid direction O } \
   RLAST { physical_name S_AXI2_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI2_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI2_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI2_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI2_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI2_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI2_SLR01_wid direction I } \
   WLAST { physical_name S_AXI2_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI2_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI2_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI2_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI2_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI2_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI2_SLR01]

  set S_AXI3_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI3_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI3_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI3_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI3_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI3_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI3_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI3_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI3_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI3_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI3_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI3_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI3_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI3_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI3_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI3_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI3_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI3_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI3_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI3_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI3_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI3_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI3_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI3_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI3_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI3_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI3_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI3_SLR01_bid direction O } \
   BREADY { physical_name S_AXI3_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI3_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI3_SLR01_buser direction O } \
   BVALID { physical_name S_AXI3_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI3_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI3_SLR01_rid direction O } \
   RLAST { physical_name S_AXI3_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI3_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI3_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI3_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI3_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI3_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI3_SLR01_wid direction I } \
   WLAST { physical_name S_AXI3_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI3_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI3_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI3_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI3_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI3_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI3_SLR01]

  set S_AXI4_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI4_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI4_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI4_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI4_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI4_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI4_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI4_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI4_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI4_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI4_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI4_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI4_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI4_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI4_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI4_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI4_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI4_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI4_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI4_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI4_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI4_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI4_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI4_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI4_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI4_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI4_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI4_SLR01_bid direction O } \
   BREADY { physical_name S_AXI4_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI4_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI4_SLR01_buser direction O } \
   BVALID { physical_name S_AXI4_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI4_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI4_SLR01_rid direction O } \
   RLAST { physical_name S_AXI4_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI4_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI4_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI4_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI4_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI4_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI4_SLR01_wid direction I } \
   WLAST { physical_name S_AXI4_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI4_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI4_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI4_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI4_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI4_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI4_SLR01]

  set S_AXI5_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI5_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI5_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI5_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI5_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI5_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI5_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI5_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI5_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI5_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI5_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI5_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI5_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI5_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI5_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI5_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI5_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI5_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI5_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI5_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI5_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI5_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI5_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI5_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI5_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI5_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI5_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI5_SLR01_bid direction O } \
   BREADY { physical_name S_AXI5_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI5_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI5_SLR01_buser direction O } \
   BVALID { physical_name S_AXI5_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI5_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI5_SLR01_rid direction O } \
   RLAST { physical_name S_AXI5_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI5_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI5_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI5_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI5_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI5_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI5_SLR01_wid direction I } \
   WLAST { physical_name S_AXI5_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI5_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI5_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI5_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI5_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI5_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI5_SLR01]

  set S_AXI6_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI6_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI6_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI6_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI6_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI6_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI6_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI6_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI6_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI6_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI6_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI6_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI6_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI6_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI6_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI6_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI6_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI6_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI6_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI6_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI6_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI6_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI6_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI6_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI6_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI6_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI6_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI6_SLR01_bid direction O } \
   BREADY { physical_name S_AXI6_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI6_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI6_SLR01_buser direction O } \
   BVALID { physical_name S_AXI6_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI6_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI6_SLR01_rid direction O } \
   RLAST { physical_name S_AXI6_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI6_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI6_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI6_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI6_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI6_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI6_SLR01_wid direction I } \
   WLAST { physical_name S_AXI6_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI6_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI6_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI6_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI6_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI6_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI6_SLR01]

  set S_AXI7_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI7_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI7_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI7_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI7_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI7_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI7_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI7_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI7_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI7_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI7_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI7_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI7_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI7_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI7_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI7_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI7_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI7_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI7_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI7_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI7_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI7_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI7_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI7_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI7_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI7_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI7_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI7_SLR01_bid direction O } \
   BREADY { physical_name S_AXI7_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI7_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI7_SLR01_buser direction O } \
   BVALID { physical_name S_AXI7_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI7_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI7_SLR01_rid direction O } \
   RLAST { physical_name S_AXI7_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI7_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI7_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI7_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI7_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI7_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI7_SLR01_wid direction I } \
   WLAST { physical_name S_AXI7_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI7_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI7_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI7_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI7_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI7_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI7_SLR01]

  set S_AXI8_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI8_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI8_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI8_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI8_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI8_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI8_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI8_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI8_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI8_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI8_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI8_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI8_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI8_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI8_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI8_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI8_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI8_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI8_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI8_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI8_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI8_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI8_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI8_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI8_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI8_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI8_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI8_SLR01_bid direction O } \
   BREADY { physical_name S_AXI8_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI8_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI8_SLR01_buser direction O } \
   BVALID { physical_name S_AXI8_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI8_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI8_SLR01_rid direction O } \
   RLAST { physical_name S_AXI8_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI8_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI8_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI8_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI8_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI8_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI8_SLR01_wid direction I } \
   WLAST { physical_name S_AXI8_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI8_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI8_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI8_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI8_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI8_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI8_SLR01]

  set S_AXI9_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI9_SLR01_araddr direction I left 31 right 0 } \
   ARBURST { physical_name S_AXI9_SLR01_arburst direction I left 1 right 0 } \
   ARCACHE { physical_name S_AXI9_SLR01_arcache direction I left 3 right 0 } \
   ARID { physical_name S_AXI9_SLR01_arid direction I } \
   ARLEN { physical_name S_AXI9_SLR01_arlen direction I left 7 right 0 } \
   ARLOCK { physical_name S_AXI9_SLR01_arlock direction I left 0 right 0 } \
   ARPROT { physical_name S_AXI9_SLR01_arprot direction I left 2 right 0 } \
   ARQOS { physical_name S_AXI9_SLR01_arqos direction I left 3 right 0 } \
   ARREADY { physical_name S_AXI9_SLR01_arready direction O left 0 right 0 } \
   ARREGION { physical_name S_AXI9_SLR01_arregion direction I left 3 right 0 } \
   ARSIZE { physical_name S_AXI9_SLR01_arsize direction I left 2 right 0 } \
   ARUSER { physical_name S_AXI9_SLR01_aruser direction I } \
   ARVALID { physical_name S_AXI9_SLR01_arvalid direction I left 0 right 0 } \
   AWADDR { physical_name S_AXI9_SLR01_awaddr direction I left 31 right 0 } \
   AWBURST { physical_name S_AXI9_SLR01_awburst direction I left 1 right 0 } \
   AWCACHE { physical_name S_AXI9_SLR01_awcache direction I left 3 right 0 } \
   AWID { physical_name S_AXI9_SLR01_awid direction I } \
   AWLEN { physical_name S_AXI9_SLR01_awlen direction I left 7 right 0 } \
   AWLOCK { physical_name S_AXI9_SLR01_awlock direction I left 0 right 0 } \
   AWPROT { physical_name S_AXI9_SLR01_awprot direction I left 2 right 0 } \
   AWQOS { physical_name S_AXI9_SLR01_awqos direction I left 3 right 0 } \
   AWREADY { physical_name S_AXI9_SLR01_awready direction O left 0 right 0 } \
   AWREGION { physical_name S_AXI9_SLR01_awregion direction I left 3 right 0 } \
   AWSIZE { physical_name S_AXI9_SLR01_awsize direction I left 2 right 0 } \
   AWUSER { physical_name S_AXI9_SLR01_awuser direction I } \
   AWVALID { physical_name S_AXI9_SLR01_awvalid direction I left 0 right 0 } \
   BID { physical_name S_AXI9_SLR01_bid direction O } \
   BREADY { physical_name S_AXI9_SLR01_bready direction I left 0 right 0 } \
   BRESP { physical_name S_AXI9_SLR01_bresp direction O left 1 right 0 } \
   BUSER { physical_name S_AXI9_SLR01_buser direction O } \
   BVALID { physical_name S_AXI9_SLR01_bvalid direction O left 0 right 0 } \
   RDATA { physical_name S_AXI9_SLR01_rdata direction O left 31 right 0 } \
   RID { physical_name S_AXI9_SLR01_rid direction O } \
   RLAST { physical_name S_AXI9_SLR01_rlast direction O left 0 right 0 } \
   RREADY { physical_name S_AXI9_SLR01_rready direction I left 0 right 0 } \
   RRESP { physical_name S_AXI9_SLR01_rresp direction O left 1 right 0 } \
   RUSER { physical_name S_AXI9_SLR01_ruser direction O } \
   RVALID { physical_name S_AXI9_SLR01_rvalid direction O left 0 right 0 } \
   WDATA { physical_name S_AXI9_SLR01_wdata direction I left 31 right 0 } \
   WID { physical_name S_AXI9_SLR01_wid direction I } \
   WLAST { physical_name S_AXI9_SLR01_wlast direction I left 0 right 0 } \
   WREADY { physical_name S_AXI9_SLR01_wready direction O left 0 right 0 } \
   WSTRB { physical_name S_AXI9_SLR01_wstrb direction I left 3 right 0 } \
   WUSER { physical_name S_AXI9_SLR01_wuser direction I } \
   WVALID { physical_name S_AXI9_SLR01_wvalid direction I left 0 right 0 } \
   } \
  S_AXI9_SLR01 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI9_SLR01]

  set S_AXIS0_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS0_SLR01_tdata direction I left 7 right 0 } \
   TREADY { physical_name S_AXIS0_SLR01_tready direction O left 0 right 0 } \
   TVALID { physical_name S_AXIS0_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS0_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS0_SLR01]

  set S_AXIS10_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS10_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS10_SLR01_tdest direction I } \
   TID { physical_name S_AXIS10_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS10_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS10_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS10_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS10_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS10_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS10_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS10_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS10_SLR01]

  set S_AXIS11_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS11_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS11_SLR01_tdest direction I } \
   TID { physical_name S_AXIS11_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS11_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS11_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS11_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS11_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS11_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS11_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS11_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS11_SLR01]

  set S_AXIS12_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS12_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS12_SLR01_tdest direction I } \
   TID { physical_name S_AXIS12_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS12_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS12_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS12_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS12_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS12_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS12_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS12_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS12_SLR01]

  set S_AXIS13_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS13_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS13_SLR01_tdest direction I } \
   TID { physical_name S_AXIS13_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS13_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS13_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS13_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS13_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS13_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS13_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS13_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS13_SLR01]

  set S_AXIS14_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS14_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS14_SLR01_tdest direction I } \
   TID { physical_name S_AXIS14_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS14_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS14_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS14_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS14_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS14_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS14_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS14_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS14_SLR01]

  set S_AXIS15_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS15_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS15_SLR01_tdest direction I } \
   TID { physical_name S_AXIS15_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS15_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS15_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS15_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS15_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS15_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS15_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS15_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS15_SLR01]

  set S_AXIS1_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS1_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS1_SLR01_tdest direction I } \
   TID { physical_name S_AXIS1_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS1_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS1_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS1_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS1_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS1_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS1_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS1_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS1_SLR01]

  set S_AXIS2_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS2_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS2_SLR01_tdest direction I } \
   TID { physical_name S_AXIS2_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS2_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS2_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS2_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS2_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS2_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS2_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS2_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS2_SLR01]

  set S_AXIS3_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS3_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS3_SLR01_tdest direction I } \
   TID { physical_name S_AXIS3_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS3_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS3_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS3_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS3_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS3_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS3_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS3_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS3_SLR01]

  set S_AXIS4_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS4_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS4_SLR01_tdest direction I } \
   TID { physical_name S_AXIS4_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS4_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS4_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS4_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS4_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS4_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS4_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS4_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS4_SLR01]

  set S_AXIS5_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS5_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS5_SLR01_tdest direction I } \
   TID { physical_name S_AXIS5_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS5_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS5_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS5_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS5_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS5_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS5_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS5_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS5_SLR01]

  set S_AXIS6_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS6_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS6_SLR01_tdest direction I } \
   TID { physical_name S_AXIS6_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS6_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS6_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS6_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS6_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS6_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS6_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS6_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS6_SLR01]

  set S_AXIS7_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS7_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS7_SLR01_tdest direction I } \
   TID { physical_name S_AXIS7_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS7_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS7_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS7_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS7_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS7_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS7_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS7_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS7_SLR01]

  set S_AXIS8_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS8_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS8_SLR01_tdest direction I } \
   TID { physical_name S_AXIS8_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS8_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS8_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS8_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS8_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS8_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS8_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS8_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS8_SLR01]

  set S_AXIS9_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS9_SLR01_tdata direction I left 7 right 0 } \
   TDEST { physical_name S_AXIS9_SLR01_tdest direction I } \
   TID { physical_name S_AXIS9_SLR01_tid direction I } \
   TKEEP { physical_name S_AXIS9_SLR01_tkeep direction I } \
   TLAST { physical_name S_AXIS9_SLR01_tlast direction I left 0 right 0 } \
   TREADY { physical_name S_AXIS9_SLR01_tready direction O left 0 right 0 } \
   TSTRB { physical_name S_AXIS9_SLR01_tstrb direction I } \
   TUSER { physical_name S_AXIS9_SLR01_tuser direction I } \
   TVALID { physical_name S_AXIS9_SLR01_tvalid direction I left 0 right 0 } \
   } \
  S_AXIS9_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS9_SLR01]

  set S_BSCAN_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:bscan_rtl:1.0 -portmaps { \
   BSCANID_EN { physical_name S_BSCAN_0_bscanid_en direction I } \
   CAPTURE { physical_name S_BSCAN_0_capture direction I } \
   DRCK { physical_name S_BSCAN_0_drck direction I } \
   RESET { physical_name S_BSCAN_0_reset direction I } \
   RUNTEST { physical_name S_BSCAN_0_runtest direction I } \
   SEL { physical_name S_BSCAN_0_sel direction I } \
   SHIFT { physical_name S_BSCAN_0_shift direction I } \
   TCK { physical_name S_BSCAN_0_tck direction I } \
   TDI { physical_name S_BSCAN_0_tdi direction I } \
   TDO { physical_name S_BSCAN_0_tdo direction O } \
   TMS { physical_name S_BSCAN_0_tms direction I } \
   UPDATE { physical_name S_BSCAN_0_update direction I } \
   } \
  S_BSCAN_0 ]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_BSCAN_0]


  # Create ports
  set s_axi_aclk [ create_bd_port -dir I -type clk -freq_hz 250000000 s_axi_aclk ]
  set s_axis_aresetn [ create_bd_port -dir I -type rst s_axis_aresetn ]

  # Create instance: axi4stream_vip_0, and set properties
  set axi4stream_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_0 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_0

  # Create instance: axi4stream_vip_1, and set properties
  set axi4stream_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_1 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_1

  # Create instance: axi4stream_vip_2, and set properties
  set axi4stream_vip_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_2 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_2

  # Create instance: axi4stream_vip_3, and set properties
  set axi4stream_vip_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_3 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_3

  # Create instance: axi4stream_vip_4, and set properties
  set axi4stream_vip_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_4 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_4

  # Create instance: axi4stream_vip_5, and set properties
  set axi4stream_vip_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_5 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_5

  # Create instance: axi4stream_vip_6, and set properties
  set axi4stream_vip_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_6 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_6

  # Create instance: axi4stream_vip_7, and set properties
  set axi4stream_vip_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_7 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_7

  # Create instance: axi4stream_vip_8, and set properties
  set axi4stream_vip_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_8 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_8

  # Create instance: axi4stream_vip_9, and set properties
  set axi4stream_vip_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_9 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_9

  # Create instance: axi4stream_vip_10, and set properties
  set axi4stream_vip_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_10 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_10

  # Create instance: axi4stream_vip_11, and set properties
  set axi4stream_vip_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_11 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_11

  # Create instance: axi4stream_vip_12, and set properties
  set axi4stream_vip_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_12 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_12

  # Create instance: axi4stream_vip_13, and set properties
  set axi4stream_vip_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_13 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_13

  # Create instance: axi4stream_vip_14, and set properties
  set axi4stream_vip_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_14 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_14

  # Create instance: axi4stream_vip_15, and set properties
  set axi4stream_vip_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_15 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_15

  # Create instance: axi4stream_vip_16, and set properties
  set axi4stream_vip_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_16 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_16

  # Create instance: axi4stream_vip_17, and set properties
  set axi4stream_vip_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_17 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_17

  # Create instance: axi4stream_vip_18, and set properties
  set axi4stream_vip_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_18 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_18

  # Create instance: axi4stream_vip_19, and set properties
  set axi4stream_vip_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_19 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_19

  # Create instance: axi4stream_vip_20, and set properties
  set axi4stream_vip_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_20 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_20

  # Create instance: axi4stream_vip_21, and set properties
  set axi4stream_vip_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_21 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_21

  # Create instance: axi4stream_vip_22, and set properties
  set axi4stream_vip_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_22 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_22

  # Create instance: axi4stream_vip_23, and set properties
  set axi4stream_vip_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_23 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_23

  # Create instance: axi4stream_vip_24, and set properties
  set axi4stream_vip_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_24 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_24

  # Create instance: axi4stream_vip_25, and set properties
  set axi4stream_vip_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_25 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_25

  # Create instance: axi4stream_vip_26, and set properties
  set axi4stream_vip_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_26 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_26

  # Create instance: axi4stream_vip_27, and set properties
  set axi4stream_vip_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_27 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_27

  # Create instance: axi4stream_vip_28, and set properties
  set axi4stream_vip_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_28 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_28

  # Create instance: axi4stream_vip_29, and set properties
  set axi4stream_vip_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_29 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_29

  # Create instance: axi4stream_vip_30, and set properties
  set axi4stream_vip_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_30 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_30

  # Create instance: axi4stream_vip_31, and set properties
  set axi4stream_vip_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_31 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_31

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_31

  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_0

  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.INTERFACE_MODE {SLAVE} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
 ] $axi_vip_1

  # Create instance: axi_vip_2, and set properties
  set axi_vip_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_2 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_2

  # Create instance: axi_vip_3, and set properties
  set axi_vip_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_3 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_3

  # Create instance: axi_vip_4, and set properties
  set axi_vip_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_4 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_4

  # Create instance: axi_vip_5, and set properties
  set axi_vip_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_5 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_5

  # Create instance: axi_vip_6, and set properties
  set axi_vip_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_6 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_6

  # Create instance: axi_vip_7, and set properties
  set axi_vip_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_7 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_7

  # Create instance: axi_vip_8, and set properties
  set axi_vip_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_8 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_8

  # Create instance: axi_vip_9, and set properties
  set axi_vip_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_9 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_9

  # Create instance: axi_vip_10, and set properties
  set axi_vip_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_10 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_10

  # Create instance: axi_vip_11, and set properties
  set axi_vip_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_11 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_11

  # Create instance: axi_vip_12, and set properties
  set axi_vip_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_12 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_12

  # Create instance: axi_vip_13, and set properties
  set axi_vip_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_13 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_13

  # Create instance: axi_vip_14, and set properties
  set axi_vip_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_14 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_14

  # Create instance: axi_vip_15, and set properties
  set axi_vip_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_15 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_15

  # Create instance: axi_vip_16, and set properties
  set axi_vip_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_16 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_16

  # Create instance: axi_vip_17, and set properties
  set axi_vip_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_17 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_17

  # Create instance: axi_vip_18, and set properties
  set axi_vip_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_18 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_18

  # Create instance: axi_vip_19, and set properties
  set axi_vip_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_19 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_19

  # Create instance: axi_vip_20, and set properties
  set axi_vip_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_20 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_20

  # Create instance: axi_vip_21, and set properties
  set axi_vip_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_21 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_21

  # Create instance: axi_vip_22, and set properties
  set axi_vip_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_22 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_22

  # Create instance: axi_vip_23, and set properties
  set axi_vip_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_23 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_23

  # Create instance: axi_vip_24, and set properties
  set axi_vip_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_24 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_24

  # Create instance: axi_vip_25, and set properties
  set axi_vip_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_25 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_25

  # Create instance: axi_vip_26, and set properties
  set axi_vip_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_26 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_26

  # Create instance: axi_vip_27, and set properties
  set axi_vip_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_27 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_27

  # Create instance: axi_vip_28, and set properties
  set axi_vip_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_28 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_28

  # Create instance: axi_vip_29, and set properties
  set axi_vip_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_29 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_29

  # Create instance: axi_vip_30, and set properties
  set axi_vip_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_30 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_30

  # Create instance: axi_vip_31, and set properties
  set axi_vip_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_31 ]
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
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $axi_vip_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]

  # Create instance: debug_bridge_0, and set properties
  set debug_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI0_SLR01_1 [get_bd_intf_ports S_AXI0_SLR01] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI10_SLR01_1 [get_bd_intf_ports S_AXI10_SLR01] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net S_AXI11_SLR01_1 [get_bd_intf_ports S_AXI11_SLR01] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net S_AXI12_SLR01_1 [get_bd_intf_ports S_AXI12_SLR01] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net S_AXI13_SLR01_1 [get_bd_intf_ports S_AXI13_SLR01] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net S_AXI14_SLR01_1 [get_bd_intf_ports S_AXI14_SLR01] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net S_AXI15_SLR01_1 [get_bd_intf_ports S_AXI15_SLR01] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net S_AXI1_SLR01_1 [get_bd_intf_ports S_AXI1_SLR01] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net S_AXI2_SLR01_1 [get_bd_intf_ports S_AXI2_SLR01] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net S_AXI3_SLR01_1 [get_bd_intf_ports S_AXI3_SLR01] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net S_AXI4_SLR01_1 [get_bd_intf_ports S_AXI4_SLR01] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net S_AXI5_SLR01_1 [get_bd_intf_ports S_AXI5_SLR01] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net S_AXI6_SLR01_1 [get_bd_intf_ports S_AXI6_SLR01] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net S_AXI7_SLR01_1 [get_bd_intf_ports S_AXI7_SLR01] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net S_AXI8_SLR01_1 [get_bd_intf_ports S_AXI8_SLR01] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net S_AXI9_SLR01_1 [get_bd_intf_ports S_AXI9_SLR01] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net S_AXIS0_SLR01_1 [get_bd_intf_ports S_AXIS0_SLR01] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS10_SLR01_1 [get_bd_intf_ports S_AXIS10_SLR01] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS11_SLR01_1 [get_bd_intf_ports S_AXIS11_SLR01] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS12_SLR01_1 [get_bd_intf_ports S_AXIS12_SLR01] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS13_SLR01_1 [get_bd_intf_ports S_AXIS13_SLR01] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS14_SLR01_1 [get_bd_intf_ports S_AXIS14_SLR01] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS15_SLR01_1 [get_bd_intf_ports S_AXIS15_SLR01] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS1_SLR01_1 [get_bd_intf_ports S_AXIS1_SLR01] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS2_SLR01_1 [get_bd_intf_ports S_AXIS2_SLR01] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS3_SLR01_1 [get_bd_intf_ports S_AXIS3_SLR01] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS4_SLR01_1 [get_bd_intf_ports S_AXIS4_SLR01] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS5_SLR01_1 [get_bd_intf_ports S_AXIS5_SLR01] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS6_SLR01_1 [get_bd_intf_ports S_AXIS6_SLR01] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS7_SLR01_1 [get_bd_intf_ports S_AXIS7_SLR01] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS8_SLR01_1 [get_bd_intf_ports S_AXIS8_SLR01] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS9_SLR01_1 [get_bd_intf_ports S_AXIS9_SLR01] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net S_BSCAN_0_1 [get_bd_intf_ports S_BSCAN_0] [get_bd_intf_pins debug_bridge_0/S_BSCAN]
  connect_bd_intf_net -intf_net axi4stream_vip_16_M_AXIS [get_bd_intf_pins axi4stream_vip_16/M_AXIS] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_17_M_AXIS [get_bd_intf_pins axi4stream_vip_17/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_18_M_AXIS [get_bd_intf_pins axi4stream_vip_18/M_AXIS] [get_bd_intf_pins axis_register_slice_18/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_19_M_AXIS [get_bd_intf_pins axi4stream_vip_19/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_20_M_AXIS [get_bd_intf_pins axi4stream_vip_20/M_AXIS] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_21_M_AXIS [get_bd_intf_pins axi4stream_vip_21/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_22_M_AXIS [get_bd_intf_pins axi4stream_vip_22/M_AXIS] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_23_M_AXIS [get_bd_intf_pins axi4stream_vip_23/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_24_M_AXIS [get_bd_intf_pins axi4stream_vip_24/M_AXIS] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_25_M_AXIS [get_bd_intf_pins axi4stream_vip_25/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_26_M_AXIS [get_bd_intf_pins axi4stream_vip_26/M_AXIS] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_27_M_AXIS [get_bd_intf_pins axi4stream_vip_27/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_28_M_AXIS [get_bd_intf_pins axi4stream_vip_28/M_AXIS] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_29_M_AXIS [get_bd_intf_pins axi4stream_vip_29/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_30_M_AXIS [get_bd_intf_pins axi4stream_vip_30/M_AXIS] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_31_M_AXIS [get_bd_intf_pins axi4stream_vip_31/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_vip_0/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_10_M_AXI [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_vip_10/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_11_M_AXI [get_bd_intf_pins axi_register_slice_11/M_AXI] [get_bd_intf_pins axi_vip_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_12_M_AXI [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_vip_12/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_13_M_AXI [get_bd_intf_pins axi_register_slice_13/M_AXI] [get_bd_intf_pins axi_vip_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_14_M_AXI [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_vip_14/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_15_M_AXI [get_bd_intf_pins axi_register_slice_15/M_AXI] [get_bd_intf_pins axi_vip_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_16_M_AXI [get_bd_intf_ports M_AXI0_SLR01] [get_bd_intf_pins axi_register_slice_16/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_17_M_AXI [get_bd_intf_ports M_AXI1_SLR01] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_18_M_AXI [get_bd_intf_ports M_AXI2_SLR01] [get_bd_intf_pins axi_register_slice_18/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_19_M_AXI [get_bd_intf_ports M_AXI3_SLR01] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins axi_register_slice_1/M_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_20_M_AXI [get_bd_intf_ports M_AXI4_SLR01] [get_bd_intf_pins axi_register_slice_20/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_21_M_AXI [get_bd_intf_ports M_AXI5_SLR01] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_22_M_AXI [get_bd_intf_ports M_AXI6_SLR01] [get_bd_intf_pins axi_register_slice_22/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_23_M_AXI [get_bd_intf_ports M_AXI7_SLR01] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_24_M_AXI [get_bd_intf_ports M_AXI8_SLR01] [get_bd_intf_pins axi_register_slice_24/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_25_M_AXI [get_bd_intf_ports M_AXI9_SLR01] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_26_M_AXI [get_bd_intf_ports M_AXI10_SLR01] [get_bd_intf_pins axi_register_slice_26/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_27_M_AXI [get_bd_intf_ports M_AXI11_SLR01] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_28_M_AXI [get_bd_intf_ports M_AXI12_SLR01] [get_bd_intf_pins axi_register_slice_28/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_29_M_AXI [get_bd_intf_ports M_AXI13_SLR01] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_M_AXI [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_vip_2/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_30_M_AXI [get_bd_intf_ports M_AXI14_SLR01] [get_bd_intf_pins axi_register_slice_30/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_ports M_AXI15_SLR01] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_M_AXI [get_bd_intf_pins axi_register_slice_3/M_AXI] [get_bd_intf_pins axi_vip_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_vip_4/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI [get_bd_intf_pins axi_register_slice_5/M_AXI] [get_bd_intf_pins axi_vip_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_6_M_AXI [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_vip_6/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_7_M_AXI [get_bd_intf_pins axi_register_slice_7/M_AXI] [get_bd_intf_pins axi_vip_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_8_M_AXI [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_vip_8/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI [get_bd_intf_pins axi_register_slice_9/M_AXI] [get_bd_intf_pins axi_vip_9/S_AXI]
  connect_bd_intf_net -intf_net axi_vip_16_M_AXI [get_bd_intf_pins axi_register_slice_16/S_AXI] [get_bd_intf_pins axi_vip_16/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_17_M_AXI [get_bd_intf_pins axi_register_slice_17/S_AXI] [get_bd_intf_pins axi_vip_17/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_18_M_AXI [get_bd_intf_pins axi_register_slice_18/S_AXI] [get_bd_intf_pins axi_vip_18/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_19_M_AXI [get_bd_intf_pins axi_register_slice_19/S_AXI] [get_bd_intf_pins axi_vip_19/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_20_M_AXI [get_bd_intf_pins axi_register_slice_20/S_AXI] [get_bd_intf_pins axi_vip_20/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_21_M_AXI [get_bd_intf_pins axi_register_slice_21/S_AXI] [get_bd_intf_pins axi_vip_21/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_22_M_AXI [get_bd_intf_pins axi_register_slice_22/S_AXI] [get_bd_intf_pins axi_vip_22/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_23_M_AXI [get_bd_intf_pins axi_register_slice_23/S_AXI] [get_bd_intf_pins axi_vip_23/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_24_M_AXI [get_bd_intf_pins axi_register_slice_24/S_AXI] [get_bd_intf_pins axi_vip_24/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_25_M_AXI [get_bd_intf_pins axi_register_slice_25/S_AXI] [get_bd_intf_pins axi_vip_25/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_26_M_AXI [get_bd_intf_pins axi_register_slice_26/S_AXI] [get_bd_intf_pins axi_vip_26/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_27_M_AXI [get_bd_intf_pins axi_register_slice_27/S_AXI] [get_bd_intf_pins axi_vip_27/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_28_M_AXI [get_bd_intf_pins axi_register_slice_28/S_AXI] [get_bd_intf_pins axi_vip_28/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_29_M_AXI [get_bd_intf_pins axi_register_slice_29/S_AXI] [get_bd_intf_pins axi_vip_29/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_30_M_AXI [get_bd_intf_pins axi_register_slice_30/S_AXI] [get_bd_intf_pins axi_vip_30/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_31_M_AXI [get_bd_intf_pins axi_register_slice_31/S_AXI] [get_bd_intf_pins axi_vip_31/M_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axi4stream_vip_0/S_AXIS] [get_bd_intf_pins axis_register_slice_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_10_M_AXIS [get_bd_intf_pins axi4stream_vip_10/S_AXIS] [get_bd_intf_pins axis_register_slice_10/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_11_M_AXIS [get_bd_intf_pins axi4stream_vip_11/S_AXIS] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_12_M_AXIS [get_bd_intf_pins axi4stream_vip_12/S_AXIS] [get_bd_intf_pins axis_register_slice_12/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_13_M_AXIS [get_bd_intf_pins axi4stream_vip_13/S_AXIS] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_14_M_AXIS [get_bd_intf_pins axi4stream_vip_14/S_AXIS] [get_bd_intf_pins axis_register_slice_14/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_15_M_AXIS [get_bd_intf_pins axi4stream_vip_15/S_AXIS] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_16_M_AXIS [get_bd_intf_ports M_AXIS0_SLR01] [get_bd_intf_pins axis_register_slice_16/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_17_M_AXIS [get_bd_intf_ports M_AXIS1_SLR01] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_18_M_AXIS [get_bd_intf_ports M_AXIS2_SLR01] [get_bd_intf_pins axis_register_slice_18/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_19_M_AXIS [get_bd_intf_ports M_AXIS3_SLR01] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins axi4stream_vip_1/S_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_20_M_AXIS [get_bd_intf_ports M_AXIS4_SLR01] [get_bd_intf_pins axis_register_slice_20/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_21_M_AXIS [get_bd_intf_ports M_AXIS5_SLR01] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_22_M_AXIS [get_bd_intf_ports M_AXIS6_SLR01] [get_bd_intf_pins axis_register_slice_22/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_23_M_AXIS [get_bd_intf_ports M_AXIS7_SLR01] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_24_M_AXIS [get_bd_intf_ports M_AXIS8_SLR01] [get_bd_intf_pins axis_register_slice_24/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_25_M_AXIS [get_bd_intf_ports M_AXIS9_SLR01] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_26_M_AXIS [get_bd_intf_ports M_AXIS10_SLR01] [get_bd_intf_pins axis_register_slice_26/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_27_M_AXIS [get_bd_intf_ports M_AXIS11_SLR01] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_28_M_AXIS [get_bd_intf_ports M_AXIS12_SLR01] [get_bd_intf_pins axis_register_slice_28/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_29_M_AXIS [get_bd_intf_ports M_AXIS13_SLR01] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins axi4stream_vip_2/S_AXIS] [get_bd_intf_pins axis_register_slice_2/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_30_M_AXIS [get_bd_intf_ports M_AXIS14_SLR01] [get_bd_intf_pins axis_register_slice_30/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_31_M_AXIS [get_bd_intf_ports M_AXIS15_SLR01] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins axi4stream_vip_3/S_AXIS] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_4_M_AXIS [get_bd_intf_pins axi4stream_vip_4/S_AXIS] [get_bd_intf_pins axis_register_slice_4/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_5_M_AXIS [get_bd_intf_pins axi4stream_vip_5/S_AXIS] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_6_M_AXIS [get_bd_intf_pins axi4stream_vip_6/S_AXIS] [get_bd_intf_pins axis_register_slice_6/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS [get_bd_intf_pins axi4stream_vip_7/S_AXIS] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_8_M_AXIS [get_bd_intf_pins axi4stream_vip_8/S_AXIS] [get_bd_intf_pins axis_register_slice_8/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_9_M_AXIS [get_bd_intf_pins axi4stream_vip_9/S_AXIS] [get_bd_intf_pins axis_register_slice_9/M_AXIS]

  # Create port connections
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi4stream_vip_0/aclk] [get_bd_pins axi4stream_vip_1/aclk] [get_bd_pins axi4stream_vip_10/aclk] [get_bd_pins axi4stream_vip_11/aclk] [get_bd_pins axi4stream_vip_12/aclk] [get_bd_pins axi4stream_vip_13/aclk] [get_bd_pins axi4stream_vip_14/aclk] [get_bd_pins axi4stream_vip_15/aclk] [get_bd_pins axi4stream_vip_16/aclk] [get_bd_pins axi4stream_vip_17/aclk] [get_bd_pins axi4stream_vip_18/aclk] [get_bd_pins axi4stream_vip_19/aclk] [get_bd_pins axi4stream_vip_2/aclk] [get_bd_pins axi4stream_vip_20/aclk] [get_bd_pins axi4stream_vip_21/aclk] [get_bd_pins axi4stream_vip_22/aclk] [get_bd_pins axi4stream_vip_23/aclk] [get_bd_pins axi4stream_vip_24/aclk] [get_bd_pins axi4stream_vip_25/aclk] [get_bd_pins axi4stream_vip_26/aclk] [get_bd_pins axi4stream_vip_27/aclk] [get_bd_pins axi4stream_vip_28/aclk] [get_bd_pins axi4stream_vip_29/aclk] [get_bd_pins axi4stream_vip_3/aclk] [get_bd_pins axi4stream_vip_30/aclk] [get_bd_pins axi4stream_vip_31/aclk] [get_bd_pins axi4stream_vip_4/aclk] [get_bd_pins axi4stream_vip_5/aclk] [get_bd_pins axi4stream_vip_6/aclk] [get_bd_pins axi4stream_vip_7/aclk] [get_bd_pins axi4stream_vip_8/aclk] [get_bd_pins axi4stream_vip_9/aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins axi_vip_10/aclk] [get_bd_pins axi_vip_11/aclk] [get_bd_pins axi_vip_12/aclk] [get_bd_pins axi_vip_13/aclk] [get_bd_pins axi_vip_14/aclk] [get_bd_pins axi_vip_15/aclk] [get_bd_pins axi_vip_16/aclk] [get_bd_pins axi_vip_17/aclk] [get_bd_pins axi_vip_18/aclk] [get_bd_pins axi_vip_19/aclk] [get_bd_pins axi_vip_2/aclk] [get_bd_pins axi_vip_20/aclk] [get_bd_pins axi_vip_21/aclk] [get_bd_pins axi_vip_22/aclk] [get_bd_pins axi_vip_23/aclk] [get_bd_pins axi_vip_24/aclk] [get_bd_pins axi_vip_25/aclk] [get_bd_pins axi_vip_26/aclk] [get_bd_pins axi_vip_27/aclk] [get_bd_pins axi_vip_28/aclk] [get_bd_pins axi_vip_29/aclk] [get_bd_pins axi_vip_3/aclk] [get_bd_pins axi_vip_30/aclk] [get_bd_pins axi_vip_31/aclk] [get_bd_pins axi_vip_4/aclk] [get_bd_pins axi_vip_5/aclk] [get_bd_pins axi_vip_6/aclk] [get_bd_pins axi_vip_7/aclk] [get_bd_pins axi_vip_8/aclk] [get_bd_pins axi_vip_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk] [get_bd_pins debug_bridge_0/clk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_ports s_axis_aresetn] [get_bd_pins axi4stream_vip_0/aresetn] [get_bd_pins axi4stream_vip_1/aresetn] [get_bd_pins axi4stream_vip_10/aresetn] [get_bd_pins axi4stream_vip_11/aresetn] [get_bd_pins axi4stream_vip_12/aresetn] [get_bd_pins axi4stream_vip_13/aresetn] [get_bd_pins axi4stream_vip_14/aresetn] [get_bd_pins axi4stream_vip_15/aresetn] [get_bd_pins axi4stream_vip_16/aresetn] [get_bd_pins axi4stream_vip_17/aresetn] [get_bd_pins axi4stream_vip_18/aresetn] [get_bd_pins axi4stream_vip_19/aresetn] [get_bd_pins axi4stream_vip_2/aresetn] [get_bd_pins axi4stream_vip_20/aresetn] [get_bd_pins axi4stream_vip_21/aresetn] [get_bd_pins axi4stream_vip_22/aresetn] [get_bd_pins axi4stream_vip_23/aresetn] [get_bd_pins axi4stream_vip_24/aresetn] [get_bd_pins axi4stream_vip_25/aresetn] [get_bd_pins axi4stream_vip_26/aresetn] [get_bd_pins axi4stream_vip_27/aresetn] [get_bd_pins axi4stream_vip_28/aresetn] [get_bd_pins axi4stream_vip_29/aresetn] [get_bd_pins axi4stream_vip_3/aresetn] [get_bd_pins axi4stream_vip_30/aresetn] [get_bd_pins axi4stream_vip_31/aresetn] [get_bd_pins axi4stream_vip_4/aresetn] [get_bd_pins axi4stream_vip_5/aresetn] [get_bd_pins axi4stream_vip_6/aresetn] [get_bd_pins axi4stream_vip_7/aresetn] [get_bd_pins axi4stream_vip_8/aresetn] [get_bd_pins axi4stream_vip_9/aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins axi_vip_10/aresetn] [get_bd_pins axi_vip_11/aresetn] [get_bd_pins axi_vip_12/aresetn] [get_bd_pins axi_vip_13/aresetn] [get_bd_pins axi_vip_14/aresetn] [get_bd_pins axi_vip_15/aresetn] [get_bd_pins axi_vip_16/aresetn] [get_bd_pins axi_vip_17/aresetn] [get_bd_pins axi_vip_18/aresetn] [get_bd_pins axi_vip_19/aresetn] [get_bd_pins axi_vip_2/aresetn] [get_bd_pins axi_vip_20/aresetn] [get_bd_pins axi_vip_21/aresetn] [get_bd_pins axi_vip_22/aresetn] [get_bd_pins axi_vip_23/aresetn] [get_bd_pins axi_vip_24/aresetn] [get_bd_pins axi_vip_25/aresetn] [get_bd_pins axi_vip_26/aresetn] [get_bd_pins axi_vip_27/aresetn] [get_bd_pins axi_vip_28/aresetn] [get_bd_pins axi_vip_29/aresetn] [get_bd_pins axi_vip_3/aresetn] [get_bd_pins axi_vip_30/aresetn] [get_bd_pins axi_vip_31/aresetn] [get_bd_pins axi_vip_4/aresetn] [get_bd_pins axi_vip_5/aresetn] [get_bd_pins axi_vip_6/aresetn] [get_bd_pins axi_vip_7/aresetn] [get_bd_pins axi_vip_8/aresetn] [get_bd_pins axi_vip_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]

  # Create address segments
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_16/Master_AXI] [get_bd_addr_segs M_AXI0_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_17/Master_AXI] [get_bd_addr_segs M_AXI1_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_18/Master_AXI] [get_bd_addr_segs M_AXI2_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_19/Master_AXI] [get_bd_addr_segs M_AXI3_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_20/Master_AXI] [get_bd_addr_segs M_AXI4_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_21/Master_AXI] [get_bd_addr_segs M_AXI5_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_22/Master_AXI] [get_bd_addr_segs M_AXI6_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_23/Master_AXI] [get_bd_addr_segs M_AXI7_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_24/Master_AXI] [get_bd_addr_segs M_AXI8_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_25/Master_AXI] [get_bd_addr_segs M_AXI9_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_26/Master_AXI] [get_bd_addr_segs M_AXI10_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_27/Master_AXI] [get_bd_addr_segs M_AXI11_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_28/Master_AXI] [get_bd_addr_segs M_AXI12_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_29/Master_AXI] [get_bd_addr_segs M_AXI13_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_30/Master_AXI] [get_bd_addr_segs M_AXI14_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_31/Master_AXI] [get_bd_addr_segs M_AXI15_SLR01/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR01] [get_bd_addr_segs axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI10_SLR01] [get_bd_addr_segs axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI11_SLR01] [get_bd_addr_segs axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI12_SLR01] [get_bd_addr_segs axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI13_SLR01] [get_bd_addr_segs axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI14_SLR01] [get_bd_addr_segs axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI15_SLR01] [get_bd_addr_segs axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR01] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR01] [get_bd_addr_segs axi_vip_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR01] [get_bd_addr_segs axi_vip_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI4_SLR01] [get_bd_addr_segs axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI5_SLR01] [get_bd_addr_segs axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI6_SLR01] [get_bd_addr_segs axi_vip_6/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI7_SLR01] [get_bd_addr_segs axi_vip_7/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI8_SLR01] [get_bd_addr_segs axi_vip_8/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI9_SLR01] [get_bd_addr_segs axi_vip_9/S_AXI/Reg] -force


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


