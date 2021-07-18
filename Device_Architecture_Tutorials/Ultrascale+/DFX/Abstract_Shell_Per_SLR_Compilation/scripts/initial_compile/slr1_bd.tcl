
################################################################
# This is a generated script based on design: rp_slr1
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
# source rp_slr1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu13p-fhga2104-3-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name rp_slr1

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
   ARADDR { physical_name M_AXI0_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI0_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI0_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI0_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI0_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI0_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI0_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI0_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI0_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI0_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI0_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI0_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI0_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI0_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI0_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI0_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI0_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI0_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI0_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI0_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI0_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI0_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI0_SLR01_bready direction O } \
   BRESP { physical_name M_AXI0_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI0_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI0_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI0_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI0_SLR01_rready direction O } \
   RRESP { physical_name M_AXI0_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI0_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI0_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI0_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI0_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI0_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI0_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI0_SLR01]

  set M_AXI0_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI0_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI0_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI0_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI0_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI0_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI0_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI0_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI0_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI0_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI0_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI0_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI0_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI0_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI0_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI0_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI0_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI0_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI0_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI0_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI0_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI0_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI0_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI0_SLR12_bready direction O } \
   BRESP { physical_name M_AXI0_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI0_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI0_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI0_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI0_SLR12_rready direction O } \
   RRESP { physical_name M_AXI0_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI0_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI0_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI0_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI0_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI0_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI0_SLR12_wvalid direction O } \
   } \
  M_AXI0_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI0_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI0_SLR12]

  set M_AXI10_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI10_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI10_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI10_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI10_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI10_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI10_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI10_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI10_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI10_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI10_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI10_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI10_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI10_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI10_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI10_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI10_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI10_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI10_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI10_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI10_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI10_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI10_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI10_SLR01_bready direction O } \
   BRESP { physical_name M_AXI10_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI10_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI10_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI10_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI10_SLR01_rready direction O } \
   RRESP { physical_name M_AXI10_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI10_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI10_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI10_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI10_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI10_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI10_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI10_SLR01]

  set M_AXI10_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI10_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI10_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI10_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI10_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI10_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI10_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI10_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI10_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI10_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI10_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI10_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI10_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI10_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI10_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI10_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI10_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI10_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI10_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI10_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI10_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI10_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI10_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI10_SLR12_bready direction O } \
   BRESP { physical_name M_AXI10_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI10_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI10_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI10_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI10_SLR12_rready direction O } \
   RRESP { physical_name M_AXI10_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI10_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI10_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI10_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI10_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI10_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI10_SLR12_wvalid direction O } \
   } \
  M_AXI10_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI10_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI10_SLR12]

  set M_AXI11_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI11_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI11_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI11_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI11_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI11_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI11_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI11_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI11_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI11_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI11_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI11_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI11_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI11_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI11_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI11_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI11_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI11_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI11_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI11_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI11_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI11_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI11_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI11_SLR01_bready direction O } \
   BRESP { physical_name M_AXI11_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI11_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI11_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI11_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI11_SLR01_rready direction O } \
   RRESP { physical_name M_AXI11_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI11_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI11_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI11_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI11_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI11_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI11_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI11_SLR01]

  set M_AXI11_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI11_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI11_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI11_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI11_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI11_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI11_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI11_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI11_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI11_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI11_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI11_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI11_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI11_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI11_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI11_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI11_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI11_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI11_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI11_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI11_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI11_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI11_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI11_SLR12_bready direction O } \
   BRESP { physical_name M_AXI11_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI11_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI11_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI11_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI11_SLR12_rready direction O } \
   RRESP { physical_name M_AXI11_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI11_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI11_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI11_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI11_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI11_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI11_SLR12_wvalid direction O } \
   } \
  M_AXI11_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI11_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI11_SLR12]

  set M_AXI12_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI12_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI12_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI12_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI12_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI12_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI12_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI12_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI12_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI12_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI12_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI12_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI12_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI12_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI12_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI12_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI12_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI12_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI12_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI12_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI12_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI12_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI12_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI12_SLR01_bready direction O } \
   BRESP { physical_name M_AXI12_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI12_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI12_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI12_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI12_SLR01_rready direction O } \
   RRESP { physical_name M_AXI12_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI12_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI12_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI12_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI12_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI12_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI12_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI12_SLR01]

  set M_AXI12_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI12_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI12_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI12_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI12_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI12_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI12_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI12_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI12_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI12_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI12_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI12_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI12_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI12_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI12_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI12_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI12_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI12_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI12_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI12_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI12_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI12_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI12_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI12_SLR12_bready direction O } \
   BRESP { physical_name M_AXI12_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI12_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI12_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI12_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI12_SLR12_rready direction O } \
   RRESP { physical_name M_AXI12_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI12_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI12_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI12_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI12_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI12_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI12_SLR12_wvalid direction O } \
   } \
  M_AXI12_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI12_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI12_SLR12]

  set M_AXI13_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI13_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI13_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI13_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI13_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI13_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI13_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI13_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI13_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI13_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI13_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI13_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI13_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI13_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI13_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI13_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI13_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI13_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI13_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI13_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI13_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI13_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI13_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI13_SLR01_bready direction O } \
   BRESP { physical_name M_AXI13_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI13_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI13_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI13_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI13_SLR01_rready direction O } \
   RRESP { physical_name M_AXI13_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI13_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI13_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI13_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI13_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI13_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI13_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI13_SLR01]

  set M_AXI13_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI13_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI13_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI13_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI13_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI13_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI13_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI13_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI13_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI13_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI13_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI13_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI13_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI13_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI13_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI13_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI13_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI13_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI13_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI13_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI13_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI13_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI13_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI13_SLR12_bready direction O } \
   BRESP { physical_name M_AXI13_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI13_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI13_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI13_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI13_SLR12_rready direction O } \
   RRESP { physical_name M_AXI13_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI13_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI13_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI13_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI13_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI13_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI13_SLR12_wvalid direction O } \
   } \
  M_AXI13_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI13_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI13_SLR12]

  set M_AXI14_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI14_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI14_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI14_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI14_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI14_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI14_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI14_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI14_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI14_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI14_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI14_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI14_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI14_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI14_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI14_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI14_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI14_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI14_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI14_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI14_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI14_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI14_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI14_SLR01_bready direction O } \
   BRESP { physical_name M_AXI14_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI14_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI14_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI14_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI14_SLR01_rready direction O } \
   RRESP { physical_name M_AXI14_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI14_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI14_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI14_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI14_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI14_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI14_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI14_SLR01]

  set M_AXI14_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI14_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI14_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI14_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI14_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI14_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI14_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI14_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI14_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI14_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI14_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI14_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI14_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI14_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI14_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI14_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI14_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI14_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI14_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI14_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI14_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI14_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI14_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI14_SLR12_bready direction O } \
   BRESP { physical_name M_AXI14_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI14_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI14_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI14_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI14_SLR12_rready direction O } \
   RRESP { physical_name M_AXI14_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI14_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI14_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI14_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI14_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI14_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI14_SLR12_wvalid direction O } \
   } \
  M_AXI14_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI14_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI14_SLR12]

  set M_AXI15_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI15_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI15_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI15_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI15_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI15_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI15_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI15_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI15_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI15_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI15_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI15_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI15_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI15_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI15_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI15_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI15_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI15_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI15_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI15_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI15_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI15_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI15_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI15_SLR01_bready direction O } \
   BRESP { physical_name M_AXI15_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI15_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI15_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI15_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI15_SLR01_rready direction O } \
   RRESP { physical_name M_AXI15_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI15_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI15_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI15_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI15_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI15_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI15_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI15_SLR01]

  set M_AXI15_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI15_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI15_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI15_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI15_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI15_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI15_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI15_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI15_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI15_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI15_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI15_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI15_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI15_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI15_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI15_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI15_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI15_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI15_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI15_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI15_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI15_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI15_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI15_SLR12_bready direction O } \
   BRESP { physical_name M_AXI15_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI15_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI15_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI15_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI15_SLR12_rready direction O } \
   RRESP { physical_name M_AXI15_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI15_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI15_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI15_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI15_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI15_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI15_SLR12_wvalid direction O } \
   } \
  M_AXI15_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI15_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI15_SLR12]

  set M_AXI1_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI1_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI1_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI1_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI1_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI1_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI1_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI1_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI1_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI1_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI1_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI1_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI1_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI1_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI1_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI1_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI1_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI1_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI1_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI1_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI1_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI1_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI1_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI1_SLR01_bready direction O } \
   BRESP { physical_name M_AXI1_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI1_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI1_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI1_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI1_SLR01_rready direction O } \
   RRESP { physical_name M_AXI1_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI1_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI1_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI1_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI1_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI1_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI1_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI1_SLR01]

  set M_AXI1_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI1_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI1_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI1_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI1_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI1_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI1_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI1_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI1_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI1_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI1_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI1_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI1_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI1_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI1_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI1_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI1_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI1_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI1_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI1_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI1_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI1_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI1_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI1_SLR12_bready direction O } \
   BRESP { physical_name M_AXI1_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI1_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI1_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI1_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI1_SLR12_rready direction O } \
   RRESP { physical_name M_AXI1_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI1_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI1_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI1_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI1_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI1_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI1_SLR12_wvalid direction O } \
   } \
  M_AXI1_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI1_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI1_SLR12]

  set M_AXI2_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI2_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI2_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI2_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI2_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI2_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI2_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI2_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI2_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI2_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI2_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI2_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI2_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI2_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI2_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI2_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI2_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI2_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI2_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI2_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI2_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI2_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI2_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI2_SLR01_bready direction O } \
   BRESP { physical_name M_AXI2_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI2_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI2_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI2_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI2_SLR01_rready direction O } \
   RRESP { physical_name M_AXI2_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI2_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI2_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI2_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI2_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI2_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI2_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI2_SLR01]

  set M_AXI2_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI2_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI2_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI2_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI2_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI2_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI2_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI2_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI2_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI2_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI2_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI2_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI2_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI2_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI2_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI2_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI2_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI2_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI2_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI2_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI2_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI2_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI2_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI2_SLR12_bready direction O } \
   BRESP { physical_name M_AXI2_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI2_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI2_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI2_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI2_SLR12_rready direction O } \
   RRESP { physical_name M_AXI2_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI2_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI2_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI2_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI2_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI2_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI2_SLR12_wvalid direction O } \
   } \
  M_AXI2_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI2_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI2_SLR12]

  set M_AXI3_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI3_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI3_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI3_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI3_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI3_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI3_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI3_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI3_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI3_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI3_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI3_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI3_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI3_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI3_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI3_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI3_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI3_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI3_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI3_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI3_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI3_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI3_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI3_SLR01_bready direction O } \
   BRESP { physical_name M_AXI3_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI3_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI3_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI3_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI3_SLR01_rready direction O } \
   RRESP { physical_name M_AXI3_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI3_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI3_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI3_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI3_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI3_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI3_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI3_SLR01]

  set M_AXI3_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI3_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI3_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI3_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI3_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI3_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI3_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI3_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI3_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI3_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI3_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI3_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI3_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI3_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI3_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI3_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI3_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI3_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI3_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI3_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI3_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI3_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI3_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI3_SLR12_bready direction O } \
   BRESP { physical_name M_AXI3_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI3_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI3_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI3_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI3_SLR12_rready direction O } \
   RRESP { physical_name M_AXI3_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI3_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI3_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI3_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI3_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI3_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI3_SLR12_wvalid direction O } \
   } \
  M_AXI3_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI3_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI3_SLR12]

  set M_AXI4_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI4_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI4_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI4_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI4_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI4_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI4_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI4_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI4_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI4_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI4_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI4_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI4_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI4_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI4_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI4_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI4_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI4_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI4_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI4_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI4_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI4_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI4_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI4_SLR01_bready direction O } \
   BRESP { physical_name M_AXI4_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI4_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI4_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI4_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI4_SLR01_rready direction O } \
   RRESP { physical_name M_AXI4_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI4_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI4_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI4_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI4_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI4_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI4_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI4_SLR01]

  set M_AXI4_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI4_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI4_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI4_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI4_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI4_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI4_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI4_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI4_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI4_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI4_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI4_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI4_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI4_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI4_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI4_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI4_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI4_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI4_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI4_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI4_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI4_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI4_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI4_SLR12_bready direction O } \
   BRESP { physical_name M_AXI4_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI4_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI4_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI4_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI4_SLR12_rready direction O } \
   RRESP { physical_name M_AXI4_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI4_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI4_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI4_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI4_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI4_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI4_SLR12_wvalid direction O } \
   } \
  M_AXI4_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI4_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI4_SLR12]

  set M_AXI5_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI5_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI5_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI5_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI5_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI5_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI5_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI5_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI5_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI5_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI5_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI5_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI5_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI5_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI5_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI5_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI5_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI5_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI5_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI5_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI5_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI5_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI5_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI5_SLR01_bready direction O } \
   BRESP { physical_name M_AXI5_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI5_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI5_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI5_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI5_SLR01_rready direction O } \
   RRESP { physical_name M_AXI5_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI5_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI5_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI5_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI5_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI5_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI5_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI5_SLR01]

  set M_AXI5_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI5_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI5_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI5_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI5_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI5_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI5_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI5_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI5_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI5_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI5_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI5_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI5_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI5_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI5_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI5_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI5_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI5_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI5_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI5_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI5_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI5_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI5_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI5_SLR12_bready direction O } \
   BRESP { physical_name M_AXI5_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI5_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI5_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI5_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI5_SLR12_rready direction O } \
   RRESP { physical_name M_AXI5_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI5_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI5_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI5_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI5_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI5_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI5_SLR12_wvalid direction O } \
   } \
  M_AXI5_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI5_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI5_SLR12]

  set M_AXI6_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI6_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI6_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI6_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI6_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI6_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI6_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI6_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI6_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI6_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI6_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI6_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI6_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI6_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI6_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI6_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI6_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI6_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI6_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI6_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI6_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI6_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI6_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI6_SLR01_bready direction O } \
   BRESP { physical_name M_AXI6_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI6_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI6_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI6_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI6_SLR01_rready direction O } \
   RRESP { physical_name M_AXI6_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI6_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI6_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI6_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI6_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI6_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI6_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI6_SLR01]

  set M_AXI6_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI6_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI6_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI6_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI6_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI6_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI6_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI6_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI6_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI6_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI6_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI6_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI6_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI6_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI6_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI6_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI6_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI6_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI6_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI6_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI6_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI6_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI6_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI6_SLR12_bready direction O } \
   BRESP { physical_name M_AXI6_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI6_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI6_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI6_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI6_SLR12_rready direction O } \
   RRESP { physical_name M_AXI6_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI6_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI6_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI6_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI6_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI6_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI6_SLR12_wvalid direction O } \
   } \
  M_AXI6_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI6_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI6_SLR12]

  set M_AXI7_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI7_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI7_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI7_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI7_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI7_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI7_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI7_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI7_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI7_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI7_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI7_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI7_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI7_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI7_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI7_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI7_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI7_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI7_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI7_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI7_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI7_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI7_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI7_SLR01_bready direction O } \
   BRESP { physical_name M_AXI7_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI7_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI7_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI7_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI7_SLR01_rready direction O } \
   RRESP { physical_name M_AXI7_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI7_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI7_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI7_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI7_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI7_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI7_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI7_SLR01]

  set M_AXI7_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI7_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI7_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI7_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI7_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI7_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI7_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI7_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI7_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI7_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI7_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI7_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI7_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI7_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI7_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI7_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI7_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI7_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI7_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI7_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI7_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI7_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI7_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI7_SLR12_bready direction O } \
   BRESP { physical_name M_AXI7_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI7_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI7_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI7_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI7_SLR12_rready direction O } \
   RRESP { physical_name M_AXI7_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI7_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI7_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI7_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI7_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI7_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI7_SLR12_wvalid direction O } \
   } \
  M_AXI7_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI7_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI7_SLR12]

  set M_AXI8_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI8_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI8_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI8_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI8_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI8_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI8_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI8_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI8_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI8_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI8_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI8_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI8_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI8_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI8_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI8_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI8_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI8_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI8_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI8_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI8_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI8_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI8_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI8_SLR01_bready direction O } \
   BRESP { physical_name M_AXI8_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI8_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI8_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI8_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI8_SLR01_rready direction O } \
   RRESP { physical_name M_AXI8_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI8_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI8_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI8_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI8_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI8_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI8_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI8_SLR01]

  set M_AXI8_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI8_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI8_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI8_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI8_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI8_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI8_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI8_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI8_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI8_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI8_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI8_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI8_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI8_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI8_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI8_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI8_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI8_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI8_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI8_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI8_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI8_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI8_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI8_SLR12_bready direction O } \
   BRESP { physical_name M_AXI8_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI8_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI8_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI8_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI8_SLR12_rready direction O } \
   RRESP { physical_name M_AXI8_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI8_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI8_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI8_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI8_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI8_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI8_SLR12_wvalid direction O } \
   } \
  M_AXI8_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI8_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI8_SLR12]

  set M_AXI9_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI9_SLR01_araddr direction O } \
   ARBURST { physical_name M_AXI9_SLR01_arburst direction O } \
   ARCACHE { physical_name M_AXI9_SLR01_arcache direction O } \
   ARLEN { physical_name M_AXI9_SLR01_arlen direction O } \
   ARLOCK { physical_name M_AXI9_SLR01_arlock direction O } \
   ARPROT { physical_name M_AXI9_SLR01_arprot direction O } \
   ARQOS { physical_name M_AXI9_SLR01_arqos direction O } \
   ARREADY { physical_name M_AXI9_SLR01_arready direction I } \
   ARREGION { physical_name M_AXI9_SLR01_arregion direction O } \
   ARSIZE { physical_name M_AXI9_SLR01_arsize direction O } \
   ARVALID { physical_name M_AXI9_SLR01_arvalid direction O } \
   AWADDR { physical_name M_AXI9_SLR01_awaddr direction O } \
   AWBURST { physical_name M_AXI9_SLR01_awburst direction O } \
   AWCACHE { physical_name M_AXI9_SLR01_awcache direction O } \
   AWLEN { physical_name M_AXI9_SLR01_awlen direction O } \
   AWLOCK { physical_name M_AXI9_SLR01_awlock direction O } \
   AWPROT { physical_name M_AXI9_SLR01_awprot direction O } \
   AWQOS { physical_name M_AXI9_SLR01_awqos direction O } \
   AWREADY { physical_name M_AXI9_SLR01_awready direction I } \
   AWREGION { physical_name M_AXI9_SLR01_awregion direction O } \
   AWSIZE { physical_name M_AXI9_SLR01_awsize direction O } \
   AWVALID { physical_name M_AXI9_SLR01_awvalid direction O } \
   BREADY { physical_name M_AXI9_SLR01_bready direction O } \
   BRESP { physical_name M_AXI9_SLR01_bresp direction I } \
   BVALID { physical_name M_AXI9_SLR01_bvalid direction I } \
   RDATA { physical_name M_AXI9_SLR01_rdata direction I } \
   RLAST { physical_name M_AXI9_SLR01_rlast direction I } \
   RREADY { physical_name M_AXI9_SLR01_rready direction O } \
   RRESP { physical_name M_AXI9_SLR01_rresp direction I } \
   RVALID { physical_name M_AXI9_SLR01_rvalid direction I } \
   WDATA { physical_name M_AXI9_SLR01_wdata direction O } \
   WLAST { physical_name M_AXI9_SLR01_wlast direction O } \
   WREADY { physical_name M_AXI9_SLR01_wready direction I } \
   WSTRB { physical_name M_AXI9_SLR01_wstrb direction O } \
   WVALID { physical_name M_AXI9_SLR01_wvalid direction O } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI9_SLR01]

  set M_AXI9_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name M_AXI9_SLR12_araddr direction O } \
   ARBURST { physical_name M_AXI9_SLR12_arburst direction O } \
   ARCACHE { physical_name M_AXI9_SLR12_arcache direction O } \
   ARLEN { physical_name M_AXI9_SLR12_arlen direction O } \
   ARLOCK { physical_name M_AXI9_SLR12_arlock direction O } \
   ARPROT { physical_name M_AXI9_SLR12_arprot direction O } \
   ARQOS { physical_name M_AXI9_SLR12_arqos direction O } \
   ARREADY { physical_name M_AXI9_SLR12_arready direction I } \
   ARREGION { physical_name M_AXI9_SLR12_arregion direction O } \
   ARSIZE { physical_name M_AXI9_SLR12_arsize direction O } \
   ARVALID { physical_name M_AXI9_SLR12_arvalid direction O } \
   AWADDR { physical_name M_AXI9_SLR12_awaddr direction O } \
   AWBURST { physical_name M_AXI9_SLR12_awburst direction O } \
   AWCACHE { physical_name M_AXI9_SLR12_awcache direction O } \
   AWLEN { physical_name M_AXI9_SLR12_awlen direction O } \
   AWLOCK { physical_name M_AXI9_SLR12_awlock direction O } \
   AWPROT { physical_name M_AXI9_SLR12_awprot direction O } \
   AWQOS { physical_name M_AXI9_SLR12_awqos direction O } \
   AWREADY { physical_name M_AXI9_SLR12_awready direction I } \
   AWREGION { physical_name M_AXI9_SLR12_awregion direction O } \
   AWSIZE { physical_name M_AXI9_SLR12_awsize direction O } \
   AWVALID { physical_name M_AXI9_SLR12_awvalid direction O } \
   BREADY { physical_name M_AXI9_SLR12_bready direction O } \
   BRESP { physical_name M_AXI9_SLR12_bresp direction I } \
   BVALID { physical_name M_AXI9_SLR12_bvalid direction I } \
   RDATA { physical_name M_AXI9_SLR12_rdata direction I } \
   RLAST { physical_name M_AXI9_SLR12_rlast direction I } \
   RREADY { physical_name M_AXI9_SLR12_rready direction O } \
   RRESP { physical_name M_AXI9_SLR12_rresp direction I } \
   RVALID { physical_name M_AXI9_SLR12_rvalid direction I } \
   WDATA { physical_name M_AXI9_SLR12_wdata direction O } \
   WLAST { physical_name M_AXI9_SLR12_wlast direction O } \
   WREADY { physical_name M_AXI9_SLR12_wready direction I } \
   WSTRB { physical_name M_AXI9_SLR12_wstrb direction O } \
   WVALID { physical_name M_AXI9_SLR12_wvalid direction O } \
   } \
  M_AXI9_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   ] $M_AXI9_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXI9_SLR12]

  set M_AXIS0_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS0_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS0_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS0_SLR01_tvalid direction O } \
   } \
  M_AXIS0_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS0_SLR01]

  set M_AXIS0_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS0_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS0_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS0_SLR12_tvalid direction O } \
   } \
  M_AXIS0_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS0_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS0_SLR12]

  set M_AXIS10_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS10_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS10_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS10_SLR01_tvalid direction O } \
   } \
  M_AXIS10_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS10_SLR01]

  set M_AXIS10_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS10_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS10_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS10_SLR12_tvalid direction O } \
   } \
  M_AXIS10_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS10_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS10_SLR12]

  set M_AXIS11_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS11_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS11_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS11_SLR01_tvalid direction O } \
   } \
  M_AXIS11_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS11_SLR01]

  set M_AXIS11_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS11_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS11_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS11_SLR12_tvalid direction O } \
   } \
  M_AXIS11_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS11_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS11_SLR12]

  set M_AXIS12_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS12_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS12_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS12_SLR01_tvalid direction O } \
   } \
  M_AXIS12_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS12_SLR01]

  set M_AXIS12_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS12_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS12_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS12_SLR12_tvalid direction O } \
   } \
  M_AXIS12_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS12_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS12_SLR12]

  set M_AXIS13_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS13_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS13_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS13_SLR01_tvalid direction O } \
   } \
  M_AXIS13_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS13_SLR01]

  set M_AXIS13_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS13_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS13_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS13_SLR12_tvalid direction O } \
   } \
  M_AXIS13_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS13_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS13_SLR12]

  set M_AXIS14_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS14_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS14_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS14_SLR01_tvalid direction O } \
   } \
  M_AXIS14_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS14_SLR01]

  set M_AXIS14_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS14_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS14_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS14_SLR12_tvalid direction O } \
   } \
  M_AXIS14_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS14_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS14_SLR12]

  set M_AXIS15_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS15_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS15_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS15_SLR01_tvalid direction O } \
   } \
  M_AXIS15_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS15_SLR01]

  set M_AXIS15_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS15_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS15_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS15_SLR12_tvalid direction O } \
   } \
  M_AXIS15_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS15_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS15_SLR12]

  set M_AXIS1_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS1_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS1_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS1_SLR01_tvalid direction O } \
   } \
  M_AXIS1_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS1_SLR01]

  set M_AXIS1_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS1_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS1_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS1_SLR12_tvalid direction O } \
   } \
  M_AXIS1_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS1_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS1_SLR12]

  set M_AXIS2_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS2_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS2_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS2_SLR01_tvalid direction O } \
   } \
  M_AXIS2_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS2_SLR01]

  set M_AXIS2_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS2_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS2_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS2_SLR12_tvalid direction O } \
   } \
  M_AXIS2_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS2_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS2_SLR12]

  set M_AXIS3_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS3_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS3_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS3_SLR01_tvalid direction O } \
   } \
  M_AXIS3_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS3_SLR01]

  set M_AXIS3_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS3_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS3_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS3_SLR12_tvalid direction O } \
   } \
  M_AXIS3_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS3_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS3_SLR12]

  set M_AXIS4_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS4_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS4_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS4_SLR01_tvalid direction O } \
   } \
  M_AXIS4_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS4_SLR01]

  set M_AXIS4_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS4_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS4_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS4_SLR12_tvalid direction O } \
   } \
  M_AXIS4_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS4_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS4_SLR12]

  set M_AXIS5_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS5_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS5_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS5_SLR01_tvalid direction O } \
   } \
  M_AXIS5_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS5_SLR01]

  set M_AXIS5_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS5_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS5_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS5_SLR12_tvalid direction O } \
   } \
  M_AXIS5_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS5_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS5_SLR12]

  set M_AXIS6_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS6_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS6_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS6_SLR01_tvalid direction O } \
   } \
  M_AXIS6_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS6_SLR01]

  set M_AXIS6_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS6_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS6_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS6_SLR12_tvalid direction O } \
   } \
  M_AXIS6_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS6_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS6_SLR12]

  set M_AXIS7_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS7_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS7_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS7_SLR01_tvalid direction O } \
   } \
  M_AXIS7_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS7_SLR01]

  set M_AXIS7_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS7_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS7_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS7_SLR12_tvalid direction O } \
   } \
  M_AXIS7_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS7_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS7_SLR12]

  set M_AXIS8_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS8_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS8_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS8_SLR01_tvalid direction O } \
   } \
  M_AXIS8_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS8_SLR01]

  set M_AXIS8_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS8_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS8_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS8_SLR12_tvalid direction O } \
   } \
  M_AXIS8_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS8_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS8_SLR12]

  set M_AXIS9_SLR01 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS9_SLR01_tdata direction O } \
   TREADY { physical_name M_AXIS9_SLR01_tready direction I } \
   TVALID { physical_name M_AXIS9_SLR01_tvalid direction O } \
   } \
  M_AXIS9_SLR01 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS9_SLR01]

  set M_AXIS9_SLR12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name M_AXIS9_SLR12_tdata direction O } \
   TREADY { physical_name M_AXIS9_SLR12_tready direction I } \
   TVALID { physical_name M_AXIS9_SLR12_tvalid direction O } \
   } \
  M_AXIS9_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.PHASE {0.0} \
   ] $M_AXIS9_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports M_AXIS9_SLR12]

  set S_AXI0_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI0_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI0_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI0_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI0_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI0_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI0_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI0_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI0_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI0_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI0_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI0_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI0_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI0_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI0_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI0_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI0_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI0_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI0_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI0_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI0_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI0_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI0_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI0_SLR01_bready direction I } \
   BRESP { physical_name S_AXI0_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI0_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI0_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI0_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI0_SLR01_rready direction I } \
   RRESP { physical_name S_AXI0_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI0_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI0_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI0_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI0_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI0_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI0_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI0_SLR01]

  set S_AXI0_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI0_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI0_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI0_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI0_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI0_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI0_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI0_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI0_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI0_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI0_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI0_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI0_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI0_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI0_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI0_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI0_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI0_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI0_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI0_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI0_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI0_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI0_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI0_SLR12_bready direction I } \
   BRESP { physical_name S_AXI0_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI0_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI0_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI0_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI0_SLR12_rready direction I } \
   RRESP { physical_name S_AXI0_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI0_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI0_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI0_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI0_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI0_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI0_SLR12_wvalid direction I } \
   } \
  S_AXI0_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI0_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI0_SLR12]

  set S_AXI10_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI10_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI10_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI10_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI10_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI10_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI10_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI10_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI10_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI10_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI10_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI10_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI10_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI10_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI10_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI10_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI10_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI10_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI10_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI10_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI10_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI10_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI10_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI10_SLR01_bready direction I } \
   BRESP { physical_name S_AXI10_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI10_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI10_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI10_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI10_SLR01_rready direction I } \
   RRESP { physical_name S_AXI10_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI10_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI10_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI10_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI10_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI10_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI10_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI10_SLR01]

  set S_AXI10_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI10_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI10_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI10_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI10_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI10_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI10_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI10_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI10_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI10_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI10_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI10_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI10_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI10_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI10_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI10_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI10_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI10_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI10_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI10_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI10_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI10_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI10_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI10_SLR12_bready direction I } \
   BRESP { physical_name S_AXI10_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI10_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI10_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI10_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI10_SLR12_rready direction I } \
   RRESP { physical_name S_AXI10_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI10_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI10_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI10_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI10_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI10_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI10_SLR12_wvalid direction I } \
   } \
  S_AXI10_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI10_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI10_SLR12]

  set S_AXI11_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI11_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI11_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI11_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI11_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI11_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI11_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI11_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI11_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI11_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI11_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI11_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI11_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI11_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI11_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI11_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI11_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI11_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI11_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI11_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI11_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI11_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI11_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI11_SLR01_bready direction I } \
   BRESP { physical_name S_AXI11_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI11_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI11_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI11_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI11_SLR01_rready direction I } \
   RRESP { physical_name S_AXI11_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI11_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI11_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI11_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI11_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI11_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI11_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI11_SLR01]

  set S_AXI11_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI11_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI11_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI11_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI11_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI11_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI11_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI11_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI11_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI11_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI11_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI11_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI11_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI11_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI11_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI11_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI11_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI11_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI11_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI11_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI11_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI11_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI11_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI11_SLR12_bready direction I } \
   BRESP { physical_name S_AXI11_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI11_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI11_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI11_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI11_SLR12_rready direction I } \
   RRESP { physical_name S_AXI11_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI11_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI11_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI11_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI11_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI11_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI11_SLR12_wvalid direction I } \
   } \
  S_AXI11_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI11_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI11_SLR12]

  set S_AXI12_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI12_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI12_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI12_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI12_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI12_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI12_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI12_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI12_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI12_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI12_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI12_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI12_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI12_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI12_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI12_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI12_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI12_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI12_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI12_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI12_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI12_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI12_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI12_SLR01_bready direction I } \
   BRESP { physical_name S_AXI12_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI12_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI12_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI12_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI12_SLR01_rready direction I } \
   RRESP { physical_name S_AXI12_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI12_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI12_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI12_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI12_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI12_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI12_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI12_SLR01]

  set S_AXI12_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI12_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI12_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI12_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI12_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI12_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI12_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI12_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI12_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI12_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI12_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI12_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI12_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI12_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI12_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI12_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI12_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI12_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI12_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI12_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI12_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI12_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI12_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI12_SLR12_bready direction I } \
   BRESP { physical_name S_AXI12_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI12_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI12_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI12_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI12_SLR12_rready direction I } \
   RRESP { physical_name S_AXI12_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI12_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI12_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI12_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI12_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI12_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI12_SLR12_wvalid direction I } \
   } \
  S_AXI12_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI12_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI12_SLR12]

  set S_AXI13_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI13_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI13_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI13_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI13_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI13_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI13_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI13_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI13_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI13_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI13_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI13_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI13_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI13_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI13_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI13_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI13_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI13_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI13_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI13_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI13_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI13_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI13_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI13_SLR01_bready direction I } \
   BRESP { physical_name S_AXI13_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI13_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI13_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI13_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI13_SLR01_rready direction I } \
   RRESP { physical_name S_AXI13_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI13_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI13_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI13_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI13_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI13_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI13_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI13_SLR01]

  set S_AXI13_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI13_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI13_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI13_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI13_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI13_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI13_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI13_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI13_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI13_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI13_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI13_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI13_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI13_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI13_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI13_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI13_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI13_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI13_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI13_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI13_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI13_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI13_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI13_SLR12_bready direction I } \
   BRESP { physical_name S_AXI13_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI13_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI13_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI13_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI13_SLR12_rready direction I } \
   RRESP { physical_name S_AXI13_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI13_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI13_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI13_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI13_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI13_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI13_SLR12_wvalid direction I } \
   } \
  S_AXI13_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI13_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI13_SLR12]

  set S_AXI14_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI14_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI14_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI14_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI14_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI14_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI14_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI14_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI14_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI14_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI14_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI14_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI14_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI14_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI14_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI14_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI14_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI14_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI14_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI14_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI14_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI14_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI14_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI14_SLR01_bready direction I } \
   BRESP { physical_name S_AXI14_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI14_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI14_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI14_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI14_SLR01_rready direction I } \
   RRESP { physical_name S_AXI14_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI14_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI14_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI14_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI14_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI14_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI14_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI14_SLR01]

  set S_AXI14_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI14_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI14_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI14_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI14_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI14_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI14_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI14_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI14_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI14_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI14_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI14_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI14_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI14_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI14_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI14_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI14_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI14_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI14_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI14_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI14_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI14_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI14_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI14_SLR12_bready direction I } \
   BRESP { physical_name S_AXI14_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI14_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI14_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI14_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI14_SLR12_rready direction I } \
   RRESP { physical_name S_AXI14_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI14_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI14_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI14_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI14_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI14_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI14_SLR12_wvalid direction I } \
   } \
  S_AXI14_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI14_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI14_SLR12]

  set S_AXI15_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI15_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI15_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI15_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI15_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI15_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI15_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI15_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI15_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI15_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI15_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI15_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI15_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI15_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI15_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI15_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI15_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI15_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI15_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI15_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI15_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI15_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI15_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI15_SLR01_bready direction I } \
   BRESP { physical_name S_AXI15_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI15_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI15_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI15_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI15_SLR01_rready direction I } \
   RRESP { physical_name S_AXI15_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI15_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI15_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI15_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI15_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI15_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI15_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI15_SLR01]

  set S_AXI15_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI15_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI15_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI15_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI15_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI15_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI15_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI15_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI15_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI15_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI15_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI15_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI15_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI15_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI15_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI15_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI15_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI15_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI15_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI15_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI15_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI15_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI15_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI15_SLR12_bready direction I } \
   BRESP { physical_name S_AXI15_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI15_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI15_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI15_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI15_SLR12_rready direction I } \
   RRESP { physical_name S_AXI15_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI15_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI15_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI15_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI15_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI15_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI15_SLR12_wvalid direction I } \
   } \
  S_AXI15_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI15_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI15_SLR12]

  set S_AXI1_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI1_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI1_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI1_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI1_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI1_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI1_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI1_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI1_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI1_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI1_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI1_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI1_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI1_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI1_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI1_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI1_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI1_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI1_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI1_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI1_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI1_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI1_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI1_SLR01_bready direction I } \
   BRESP { physical_name S_AXI1_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI1_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI1_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI1_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI1_SLR01_rready direction I } \
   RRESP { physical_name S_AXI1_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI1_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI1_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI1_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI1_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI1_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI1_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI1_SLR01]

  set S_AXI1_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI1_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI1_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI1_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI1_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI1_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI1_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI1_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI1_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI1_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI1_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI1_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI1_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI1_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI1_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI1_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI1_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI1_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI1_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI1_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI1_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI1_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI1_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI1_SLR12_bready direction I } \
   BRESP { physical_name S_AXI1_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI1_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI1_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI1_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI1_SLR12_rready direction I } \
   RRESP { physical_name S_AXI1_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI1_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI1_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI1_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI1_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI1_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI1_SLR12_wvalid direction I } \
   } \
  S_AXI1_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI1_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI1_SLR12]

  set S_AXI2_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI2_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI2_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI2_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI2_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI2_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI2_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI2_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI2_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI2_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI2_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI2_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI2_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI2_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI2_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI2_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI2_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI2_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI2_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI2_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI2_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI2_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI2_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI2_SLR01_bready direction I } \
   BRESP { physical_name S_AXI2_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI2_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI2_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI2_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI2_SLR01_rready direction I } \
   RRESP { physical_name S_AXI2_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI2_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI2_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI2_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI2_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI2_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI2_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI2_SLR01]

  set S_AXI2_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI2_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI2_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI2_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI2_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI2_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI2_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI2_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI2_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI2_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI2_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI2_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI2_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI2_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI2_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI2_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI2_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI2_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI2_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI2_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI2_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI2_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI2_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI2_SLR12_bready direction I } \
   BRESP { physical_name S_AXI2_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI2_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI2_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI2_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI2_SLR12_rready direction I } \
   RRESP { physical_name S_AXI2_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI2_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI2_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI2_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI2_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI2_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI2_SLR12_wvalid direction I } \
   } \
  S_AXI2_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI2_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI2_SLR12]

  set S_AXI3_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI3_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI3_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI3_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI3_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI3_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI3_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI3_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI3_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI3_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI3_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI3_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI3_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI3_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI3_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI3_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI3_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI3_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI3_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI3_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI3_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI3_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI3_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI3_SLR01_bready direction I } \
   BRESP { physical_name S_AXI3_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI3_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI3_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI3_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI3_SLR01_rready direction I } \
   RRESP { physical_name S_AXI3_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI3_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI3_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI3_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI3_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI3_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI3_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI3_SLR01]

  set S_AXI3_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI3_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI3_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI3_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI3_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI3_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI3_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI3_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI3_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI3_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI3_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI3_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI3_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI3_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI3_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI3_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI3_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI3_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI3_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI3_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI3_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI3_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI3_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI3_SLR12_bready direction I } \
   BRESP { physical_name S_AXI3_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI3_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI3_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI3_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI3_SLR12_rready direction I } \
   RRESP { physical_name S_AXI3_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI3_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI3_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI3_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI3_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI3_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI3_SLR12_wvalid direction I } \
   } \
  S_AXI3_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI3_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI3_SLR12]

  set S_AXI4_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI4_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI4_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI4_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI4_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI4_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI4_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI4_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI4_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI4_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI4_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI4_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI4_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI4_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI4_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI4_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI4_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI4_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI4_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI4_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI4_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI4_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI4_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI4_SLR01_bready direction I } \
   BRESP { physical_name S_AXI4_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI4_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI4_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI4_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI4_SLR01_rready direction I } \
   RRESP { physical_name S_AXI4_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI4_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI4_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI4_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI4_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI4_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI4_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI4_SLR01]

  set S_AXI4_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI4_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI4_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI4_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI4_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI4_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI4_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI4_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI4_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI4_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI4_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI4_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI4_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI4_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI4_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI4_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI4_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI4_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI4_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI4_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI4_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI4_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI4_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI4_SLR12_bready direction I } \
   BRESP { physical_name S_AXI4_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI4_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI4_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI4_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI4_SLR12_rready direction I } \
   RRESP { physical_name S_AXI4_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI4_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI4_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI4_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI4_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI4_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI4_SLR12_wvalid direction I } \
   } \
  S_AXI4_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI4_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI4_SLR12]

  set S_AXI5_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI5_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI5_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI5_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI5_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI5_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI5_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI5_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI5_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI5_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI5_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI5_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI5_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI5_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI5_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI5_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI5_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI5_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI5_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI5_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI5_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI5_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI5_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI5_SLR01_bready direction I } \
   BRESP { physical_name S_AXI5_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI5_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI5_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI5_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI5_SLR01_rready direction I } \
   RRESP { physical_name S_AXI5_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI5_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI5_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI5_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI5_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI5_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI5_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI5_SLR01]

  set S_AXI5_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI5_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI5_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI5_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI5_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI5_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI5_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI5_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI5_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI5_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI5_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI5_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI5_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI5_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI5_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI5_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI5_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI5_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI5_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI5_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI5_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI5_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI5_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI5_SLR12_bready direction I } \
   BRESP { physical_name S_AXI5_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI5_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI5_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI5_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI5_SLR12_rready direction I } \
   RRESP { physical_name S_AXI5_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI5_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI5_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI5_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI5_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI5_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI5_SLR12_wvalid direction I } \
   } \
  S_AXI5_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI5_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI5_SLR12]

  set S_AXI6_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI6_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI6_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI6_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI6_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI6_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI6_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI6_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI6_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI6_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI6_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI6_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI6_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI6_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI6_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI6_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI6_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI6_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI6_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI6_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI6_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI6_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI6_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI6_SLR01_bready direction I } \
   BRESP { physical_name S_AXI6_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI6_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI6_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI6_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI6_SLR01_rready direction I } \
   RRESP { physical_name S_AXI6_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI6_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI6_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI6_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI6_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI6_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI6_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI6_SLR01]

  set S_AXI6_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI6_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI6_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI6_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI6_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI6_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI6_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI6_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI6_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI6_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI6_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI6_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI6_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI6_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI6_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI6_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI6_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI6_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI6_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI6_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI6_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI6_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI6_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI6_SLR12_bready direction I } \
   BRESP { physical_name S_AXI6_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI6_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI6_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI6_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI6_SLR12_rready direction I } \
   RRESP { physical_name S_AXI6_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI6_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI6_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI6_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI6_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI6_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI6_SLR12_wvalid direction I } \
   } \
  S_AXI6_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI6_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI6_SLR12]

  set S_AXI7_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI7_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI7_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI7_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI7_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI7_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI7_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI7_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI7_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI7_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI7_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI7_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI7_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI7_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI7_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI7_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI7_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI7_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI7_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI7_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI7_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI7_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI7_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI7_SLR01_bready direction I } \
   BRESP { physical_name S_AXI7_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI7_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI7_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI7_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI7_SLR01_rready direction I } \
   RRESP { physical_name S_AXI7_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI7_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI7_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI7_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI7_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI7_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI7_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI7_SLR01]

  set S_AXI7_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI7_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI7_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI7_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI7_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI7_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI7_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI7_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI7_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI7_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI7_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI7_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI7_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI7_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI7_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI7_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI7_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI7_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI7_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI7_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI7_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI7_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI7_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI7_SLR12_bready direction I } \
   BRESP { physical_name S_AXI7_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI7_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI7_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI7_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI7_SLR12_rready direction I } \
   RRESP { physical_name S_AXI7_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI7_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI7_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI7_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI7_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI7_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI7_SLR12_wvalid direction I } \
   } \
  S_AXI7_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI7_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI7_SLR12]

  set S_AXI8_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI8_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI8_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI8_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI8_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI8_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI8_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI8_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI8_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI8_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI8_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI8_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI8_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI8_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI8_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI8_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI8_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI8_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI8_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI8_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI8_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI8_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI8_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI8_SLR01_bready direction I } \
   BRESP { physical_name S_AXI8_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI8_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI8_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI8_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI8_SLR01_rready direction I } \
   RRESP { physical_name S_AXI8_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI8_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI8_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI8_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI8_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI8_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI8_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI8_SLR01]

  set S_AXI8_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI8_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI8_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI8_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI8_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI8_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI8_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI8_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI8_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI8_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI8_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI8_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI8_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI8_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI8_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI8_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI8_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI8_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI8_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI8_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI8_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI8_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI8_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI8_SLR12_bready direction I } \
   BRESP { physical_name S_AXI8_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI8_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI8_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI8_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI8_SLR12_rready direction I } \
   RRESP { physical_name S_AXI8_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI8_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI8_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI8_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI8_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI8_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI8_SLR12_wvalid direction I } \
   } \
  S_AXI8_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI8_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI8_SLR12]

  set S_AXI9_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI9_SLR01_araddr direction I } \
   ARBURST { physical_name S_AXI9_SLR01_arburst direction I } \
   ARCACHE { physical_name S_AXI9_SLR01_arcache direction I } \
   ARLEN { physical_name S_AXI9_SLR01_arlen direction I } \
   ARLOCK { physical_name S_AXI9_SLR01_arlock direction I } \
   ARPROT { physical_name S_AXI9_SLR01_arprot direction I } \
   ARQOS { physical_name S_AXI9_SLR01_arqos direction I } \
   ARREADY { physical_name S_AXI9_SLR01_arready direction O } \
   ARREGION { physical_name S_AXI9_SLR01_arregion direction I } \
   ARSIZE { physical_name S_AXI9_SLR01_arsize direction I } \
   ARVALID { physical_name S_AXI9_SLR01_arvalid direction I } \
   AWADDR { physical_name S_AXI9_SLR01_awaddr direction I } \
   AWBURST { physical_name S_AXI9_SLR01_awburst direction I } \
   AWCACHE { physical_name S_AXI9_SLR01_awcache direction I } \
   AWLEN { physical_name S_AXI9_SLR01_awlen direction I } \
   AWLOCK { physical_name S_AXI9_SLR01_awlock direction I } \
   AWPROT { physical_name S_AXI9_SLR01_awprot direction I } \
   AWQOS { physical_name S_AXI9_SLR01_awqos direction I } \
   AWREADY { physical_name S_AXI9_SLR01_awready direction O } \
   AWREGION { physical_name S_AXI9_SLR01_awregion direction I } \
   AWSIZE { physical_name S_AXI9_SLR01_awsize direction I } \
   AWVALID { physical_name S_AXI9_SLR01_awvalid direction I } \
   BREADY { physical_name S_AXI9_SLR01_bready direction I } \
   BRESP { physical_name S_AXI9_SLR01_bresp direction O } \
   BVALID { physical_name S_AXI9_SLR01_bvalid direction O } \
   RDATA { physical_name S_AXI9_SLR01_rdata direction O } \
   RLAST { physical_name S_AXI9_SLR01_rlast direction O } \
   RREADY { physical_name S_AXI9_SLR01_rready direction I } \
   RRESP { physical_name S_AXI9_SLR01_rresp direction O } \
   RVALID { physical_name S_AXI9_SLR01_rvalid direction O } \
   WDATA { physical_name S_AXI9_SLR01_wdata direction I } \
   WLAST { physical_name S_AXI9_SLR01_wlast direction I } \
   WREADY { physical_name S_AXI9_SLR01_wready direction O } \
   WSTRB { physical_name S_AXI9_SLR01_wstrb direction I } \
   WVALID { physical_name S_AXI9_SLR01_wvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI9_SLR01]

  set S_AXI9_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 -portmaps { \
   ARADDR { physical_name S_AXI9_SLR12_araddr direction I } \
   ARBURST { physical_name S_AXI9_SLR12_arburst direction I } \
   ARCACHE { physical_name S_AXI9_SLR12_arcache direction I } \
   ARLEN { physical_name S_AXI9_SLR12_arlen direction I } \
   ARLOCK { physical_name S_AXI9_SLR12_arlock direction I } \
   ARPROT { physical_name S_AXI9_SLR12_arprot direction I } \
   ARQOS { physical_name S_AXI9_SLR12_arqos direction I } \
   ARREADY { physical_name S_AXI9_SLR12_arready direction O } \
   ARREGION { physical_name S_AXI9_SLR12_arregion direction I } \
   ARSIZE { physical_name S_AXI9_SLR12_arsize direction I } \
   ARVALID { physical_name S_AXI9_SLR12_arvalid direction I } \
   AWADDR { physical_name S_AXI9_SLR12_awaddr direction I } \
   AWBURST { physical_name S_AXI9_SLR12_awburst direction I } \
   AWCACHE { physical_name S_AXI9_SLR12_awcache direction I } \
   AWLEN { physical_name S_AXI9_SLR12_awlen direction I } \
   AWLOCK { physical_name S_AXI9_SLR12_awlock direction I } \
   AWPROT { physical_name S_AXI9_SLR12_awprot direction I } \
   AWQOS { physical_name S_AXI9_SLR12_awqos direction I } \
   AWREADY { physical_name S_AXI9_SLR12_awready direction O } \
   AWREGION { physical_name S_AXI9_SLR12_awregion direction I } \
   AWSIZE { physical_name S_AXI9_SLR12_awsize direction I } \
   AWVALID { physical_name S_AXI9_SLR12_awvalid direction I } \
   BREADY { physical_name S_AXI9_SLR12_bready direction I } \
   BRESP { physical_name S_AXI9_SLR12_bresp direction O } \
   BVALID { physical_name S_AXI9_SLR12_bvalid direction O } \
   RDATA { physical_name S_AXI9_SLR12_rdata direction O } \
   RLAST { physical_name S_AXI9_SLR12_rlast direction O } \
   RREADY { physical_name S_AXI9_SLR12_rready direction I } \
   RRESP { physical_name S_AXI9_SLR12_rresp direction O } \
   RVALID { physical_name S_AXI9_SLR12_rvalid direction O } \
   WDATA { physical_name S_AXI9_SLR12_wdata direction I } \
   WLAST { physical_name S_AXI9_SLR12_wlast direction I } \
   WREADY { physical_name S_AXI9_SLR12_wready direction O } \
   WSTRB { physical_name S_AXI9_SLR12_wstrb direction I } \
   WVALID { physical_name S_AXI9_SLR12_wvalid direction I } \
   } \
  S_AXI9_SLR12 ]
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
   CONFIG.PHASE {0.0} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI9_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXI9_SLR12]

  set S_AXIS0_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS0_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS0_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS0_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS0_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS0_SLR01]

  set S_AXIS0_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS0_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS0_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS0_SLR12_tvalid direction I } \
   } \
  S_AXIS0_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS0_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS0_SLR12]

  set S_AXIS10_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS10_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS10_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS10_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS10_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS10_SLR01]

  set S_AXIS10_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS10_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS10_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS10_SLR12_tvalid direction I } \
   } \
  S_AXIS10_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS10_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS10_SLR12]

  set S_AXIS11_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS11_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS11_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS11_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS11_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS11_SLR01]

  set S_AXIS11_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS11_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS11_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS11_SLR12_tvalid direction I } \
   } \
  S_AXIS11_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS11_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS11_SLR12]

  set S_AXIS12_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS12_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS12_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS12_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS12_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS12_SLR01]

  set S_AXIS12_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS12_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS12_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS12_SLR12_tvalid direction I } \
   } \
  S_AXIS12_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS12_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS12_SLR12]

  set S_AXIS13_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS13_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS13_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS13_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS13_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS13_SLR01]

  set S_AXIS13_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS13_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS13_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS13_SLR12_tvalid direction I } \
   } \
  S_AXIS13_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS13_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS13_SLR12]

  set S_AXIS14_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS14_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS14_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS14_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS14_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS14_SLR01]

  set S_AXIS14_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS14_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS14_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS14_SLR12_tvalid direction I } \
   } \
  S_AXIS14_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS14_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS14_SLR12]

  set S_AXIS15_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS15_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS15_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS15_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS15_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS15_SLR01]

  set S_AXIS15_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS15_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS15_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS15_SLR12_tvalid direction I } \
   } \
  S_AXIS15_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS15_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS15_SLR12]

  set S_AXIS1_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS1_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS1_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS1_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS1_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS1_SLR01]

  set S_AXIS1_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS1_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS1_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS1_SLR12_tvalid direction I } \
   } \
  S_AXIS1_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS1_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS1_SLR12]

  set S_AXIS2_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS2_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS2_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS2_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS2_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS2_SLR01]

  set S_AXIS2_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS2_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS2_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS2_SLR12_tvalid direction I } \
   } \
  S_AXIS2_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS2_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS2_SLR12]

  set S_AXIS3_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS3_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS3_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS3_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS3_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS3_SLR01]

  set S_AXIS3_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS3_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS3_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS3_SLR12_tvalid direction I } \
   } \
  S_AXIS3_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS3_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS3_SLR12]

  set S_AXIS4_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS4_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS4_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS4_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS4_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS4_SLR01]

  set S_AXIS4_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS4_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS4_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS4_SLR12_tvalid direction I } \
   } \
  S_AXIS4_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS4_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS4_SLR12]

  set S_AXIS5_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS5_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS5_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS5_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS5_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS5_SLR01]

  set S_AXIS5_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS5_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS5_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS5_SLR12_tvalid direction I } \
   } \
  S_AXIS5_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS5_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS5_SLR12]

  set S_AXIS6_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS6_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS6_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS6_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS6_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS6_SLR01]

  set S_AXIS6_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS6_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS6_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS6_SLR12_tvalid direction I } \
   } \
  S_AXIS6_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS6_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS6_SLR12]

  set S_AXIS7_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS7_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS7_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS7_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS7_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS7_SLR01]

  set S_AXIS7_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS7_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS7_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS7_SLR12_tvalid direction I } \
   } \
  S_AXIS7_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS7_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS7_SLR12]

  set S_AXIS8_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS8_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS8_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS8_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS8_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS8_SLR01]

  set S_AXIS8_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS8_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS8_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS8_SLR12_tvalid direction I } \
   } \
  S_AXIS8_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS8_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS8_SLR12]

  set S_AXIS9_SLR01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS9_SLR01_tdata direction I } \
   TREADY { physical_name S_AXIS9_SLR01_tready direction O } \
   TVALID { physical_name S_AXIS9_SLR01_tvalid direction I } \
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
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS9_SLR01
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS9_SLR01]

  set S_AXIS9_SLR12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 -portmaps { \
   TDATA { physical_name S_AXIS9_SLR12_tdata direction I } \
   TREADY { physical_name S_AXIS9_SLR12_tready direction O } \
   TVALID { physical_name S_AXIS9_SLR12_tvalid direction I } \
   } \
  S_AXIS9_SLR12 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.INSERT_VIP {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.PHASE {0.0} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $S_AXIS9_SLR12
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports S_AXIS9_SLR12]

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

  set clock_qdma_slr1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name clock_qdma_slr1_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name clock_qdma_slr1_clk_p direction I left 0 right 0 } \
   } \
  clock_qdma_slr1 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $clock_qdma_slr1
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports clock_qdma_slr1]

  set pcie_7x_mgt_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 -portmaps { \
   rxn { physical_name pcie_7x_mgt_rtl_0_rxn direction I } \
   rxp { physical_name pcie_7x_mgt_rtl_0_rxp direction I } \
   txn { physical_name pcie_7x_mgt_rtl_0_txn direction O } \
   txp { physical_name pcie_7x_mgt_rtl_0_txp direction O } \
   } \
  pcie_7x_mgt_rtl_0 ]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports pcie_7x_mgt_rtl_0]


  # Create ports
  set s_axi_aclk [ create_bd_port -dir I -type clk -freq_hz 250000000 s_axi_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M_AXI0_SLR01:M_AXI10_SLR01:M_AXI11_SLR01:M_AXI12_SLR01:M_AXI13_SLR01:M_AXI14_SLR01:M_AXI15_SLR01:M_AXI1_SLR01:M_AXI2_SLR01:M_AXI3_SLR01:M_AXI4_SLR01:M_AXI5_SLR01:M_AXI6_SLR01:M_AXI7_SLR01:M_AXI8_SLR01:M_AXI9_SLR01:M_AXIS0_SLR01:M_AXIS10_SLR01:M_AXIS11_SLR01:M_AXIS12_SLR01:M_AXIS13_SLR01:M_AXIS14_SLR01:M_AXIS15_SLR01:M_AXIS1_SLR01:M_AXIS2_SLR01:M_AXIS3_SLR01:M_AXIS4_SLR01:M_AXIS5_SLR01:M_AXIS6_SLR01:M_AXIS7_SLR01:M_AXIS8_SLR01:M_AXIS9_SLR01:S_AXI0_SLR01:S_AXI10_SLR01:S_AXI11_SLR01:S_AXI12_SLR01:S_AXI13_SLR01:S_AXI14_SLR01:S_AXI15_SLR01:S_AXI1_SLR01:S_AXI2_SLR01:S_AXI3_SLR01:S_AXI4_SLR01:S_AXI5_SLR01:S_AXI6_SLR01:S_AXI7_SLR01:S_AXI8_SLR01:S_AXI9_SLR01:S_AXIS0_SLR01:S_AXIS10_SLR01:S_AXIS11_SLR01:S_AXIS12_SLR01:S_AXIS13_SLR01:S_AXIS14_SLR01:S_AXIS15_SLR01:S_AXIS1_SLR01:S_AXIS2_SLR01:S_AXIS3_SLR01:S_AXIS4_SLR01:S_AXIS5_SLR01:S_AXIS6_SLR01:S_AXIS7_SLR01:S_AXIS8_SLR01:S_AXIS9_SLR01:M_AXI0_SLR12:M_AXI10_SLR12:M_AXI11_SLR12:M_AXI12_SLR12:M_AXI13_SLR12:M_AXI14_SLR12:M_AXI15_SLR12:M_AXI1_SLR12:M_AXI2_SLR12:M_AXI3_SLR12:M_AXI4_SLR12:M_AXI5_SLR12:M_AXI6_SLR12:M_AXI7_SLR12:M_AXI8_SLR12:M_AXI9_SLR12:M_AXIS0_SLR12:M_AXIS10_SLR12:M_AXIS11_SLR12:M_AXIS12_SLR12:M_AXIS13_SLR12:M_AXIS14_SLR12:M_AXIS15_SLR12:M_AXIS1_SLR12:M_AXIS2_SLR12:M_AXIS3_SLR12:M_AXIS4_SLR12:M_AXIS5_SLR12:M_AXIS6_SLR12:M_AXIS7_SLR12:M_AXIS8_SLR12:M_AXIS9_SLR12:S_AXI0_SLR12:S_AXI10_SLR12:S_AXI11_SLR12:S_AXI12_SLR12:S_AXI13_SLR12:S_AXI14_SLR12:S_AXI15_SLR12:S_AXI1_SLR12:S_AXI2_SLR12:S_AXI3_SLR12:S_AXI4_SLR12:S_AXI5_SLR12:S_AXI6_SLR12:S_AXI7_SLR12:S_AXI8_SLR12:S_AXI9_SLR12:S_AXIS0_SLR12:S_AXIS10_SLR12:S_AXIS11_SLR12:S_AXIS12_SLR12:S_AXIS13_SLR12:S_AXIS14_SLR12:S_AXIS15_SLR12:S_AXIS1_SLR12:S_AXIS2_SLR12:S_AXIS3_SLR12:S_AXIS4_SLR12:S_AXIS5_SLR12:S_AXIS6_SLR12:S_AXIS7_SLR12:S_AXIS8_SLR12:S_AXIS9_SLR12} \
   CONFIG.ASSOCIATED_RESET {s_axis_aresetn} \
 ] $s_axi_aclk
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

  # Create instance: axi4stream_vip_32, and set properties
  set axi4stream_vip_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_32 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_32

  # Create instance: axi4stream_vip_33, and set properties
  set axi4stream_vip_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_33 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TUSER_WIDTH {0} \
 ] $axi4stream_vip_33

  # Create instance: axi4stream_vip_34, and set properties
  set axi4stream_vip_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_34 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_34

  # Create instance: axi4stream_vip_35, and set properties
  set axi4stream_vip_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_35 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_35

  # Create instance: axi4stream_vip_36, and set properties
  set axi4stream_vip_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_36 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_36

  # Create instance: axi4stream_vip_37, and set properties
  set axi4stream_vip_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_37 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_37

  # Create instance: axi4stream_vip_38, and set properties
  set axi4stream_vip_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_38 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_38

  # Create instance: axi4stream_vip_39, and set properties
  set axi4stream_vip_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_39 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_39

  # Create instance: axi4stream_vip_40, and set properties
  set axi4stream_vip_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_40 ]
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
 ] $axi4stream_vip_40

  # Create instance: axi4stream_vip_41, and set properties
  set axi4stream_vip_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_41 ]
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
 ] $axi4stream_vip_41

  # Create instance: axi4stream_vip_42, and set properties
  set axi4stream_vip_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_42 ]
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
 ] $axi4stream_vip_42

  # Create instance: axi4stream_vip_43, and set properties
  set axi4stream_vip_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_43 ]
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
 ] $axi4stream_vip_43

  # Create instance: axi4stream_vip_44, and set properties
  set axi4stream_vip_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_44 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_44

  # Create instance: axi4stream_vip_45, and set properties
  set axi4stream_vip_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_45 ]
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
 ] $axi4stream_vip_45

  # Create instance: axi4stream_vip_46, and set properties
  set axi4stream_vip_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_46 ]
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
 ] $axi4stream_vip_46

  # Create instance: axi4stream_vip_47, and set properties
  set axi4stream_vip_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_47 ]
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
 ] $axi4stream_vip_47

  # Create instance: axi4stream_vip_48, and set properties
  set axi4stream_vip_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_48 ]
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
 ] $axi4stream_vip_48

  # Create instance: axi4stream_vip_49, and set properties
  set axi4stream_vip_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_49 ]
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
 ] $axi4stream_vip_49

  # Create instance: axi4stream_vip_50, and set properties
  set axi4stream_vip_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_50 ]
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
 ] $axi4stream_vip_50

  # Create instance: axi4stream_vip_51, and set properties
  set axi4stream_vip_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_51 ]
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
 ] $axi4stream_vip_51

  # Create instance: axi4stream_vip_52, and set properties
  set axi4stream_vip_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_52 ]
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
 ] $axi4stream_vip_52

  # Create instance: axi4stream_vip_53, and set properties
  set axi4stream_vip_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_53 ]
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
 ] $axi4stream_vip_53

  # Create instance: axi4stream_vip_54, and set properties
  set axi4stream_vip_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_54 ]
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
 ] $axi4stream_vip_54

  # Create instance: axi4stream_vip_55, and set properties
  set axi4stream_vip_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_55 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_55

  # Create instance: axi4stream_vip_56, and set properties
  set axi4stream_vip_56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_56 ]
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
 ] $axi4stream_vip_56

  # Create instance: axi4stream_vip_57, and set properties
  set axi4stream_vip_57 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_57 ]
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
 ] $axi4stream_vip_57

  # Create instance: axi4stream_vip_58, and set properties
  set axi4stream_vip_58 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_58 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_58

  # Create instance: axi4stream_vip_59, and set properties
  set axi4stream_vip_59 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_59 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_59

  # Create instance: axi4stream_vip_60, and set properties
  set axi4stream_vip_60 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_60 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_60

  # Create instance: axi4stream_vip_61, and set properties
  set axi4stream_vip_61 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_61 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_61

  # Create instance: axi4stream_vip_62, and set properties
  set axi4stream_vip_62 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_62 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_62

  # Create instance: axi4stream_vip_63, and set properties
  set axi4stream_vip_63 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axi4stream_vip_63 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi4stream_vip_63

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

  # Create instance: axi_register_slice_32, and set properties
  set axi_register_slice_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_32 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_32

  # Create instance: axi_register_slice_33, and set properties
  set axi_register_slice_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_33 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_33

  # Create instance: axi_register_slice_34, and set properties
  set axi_register_slice_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_34 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_34

  # Create instance: axi_register_slice_35, and set properties
  set axi_register_slice_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_35 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_35

  # Create instance: axi_register_slice_36, and set properties
  set axi_register_slice_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_36 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_36

  # Create instance: axi_register_slice_37, and set properties
  set axi_register_slice_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_37 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_37

  # Create instance: axi_register_slice_38, and set properties
  set axi_register_slice_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_38 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_38

  # Create instance: axi_register_slice_39, and set properties
  set axi_register_slice_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_39 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_39

  # Create instance: axi_register_slice_40, and set properties
  set axi_register_slice_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_40 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_40

  # Create instance: axi_register_slice_41, and set properties
  set axi_register_slice_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_41 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_41

  # Create instance: axi_register_slice_42, and set properties
  set axi_register_slice_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_42 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_42

  # Create instance: axi_register_slice_43, and set properties
  set axi_register_slice_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_43 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_43

  # Create instance: axi_register_slice_44, and set properties
  set axi_register_slice_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_44 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_44

  # Create instance: axi_register_slice_45, and set properties
  set axi_register_slice_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_45 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_45

  # Create instance: axi_register_slice_46, and set properties
  set axi_register_slice_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_46 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_46

  # Create instance: axi_register_slice_47, and set properties
  set axi_register_slice_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_47 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_47

  # Create instance: axi_register_slice_48, and set properties
  set axi_register_slice_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_48 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_48

  # Create instance: axi_register_slice_49, and set properties
  set axi_register_slice_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_49 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_49

  # Create instance: axi_register_slice_50, and set properties
  set axi_register_slice_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_50 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_50

  # Create instance: axi_register_slice_51, and set properties
  set axi_register_slice_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_51 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_51

  # Create instance: axi_register_slice_52, and set properties
  set axi_register_slice_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_52 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_52

  # Create instance: axi_register_slice_53, and set properties
  set axi_register_slice_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_53 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_53

  # Create instance: axi_register_slice_54, and set properties
  set axi_register_slice_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_54 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_54

  # Create instance: axi_register_slice_55, and set properties
  set axi_register_slice_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_55 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_55

  # Create instance: axi_register_slice_56, and set properties
  set axi_register_slice_56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_56 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_56

  # Create instance: axi_register_slice_57, and set properties
  set axi_register_slice_57 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_57 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_57

  # Create instance: axi_register_slice_58, and set properties
  set axi_register_slice_58 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_58 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_58

  # Create instance: axi_register_slice_59, and set properties
  set axi_register_slice_59 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_59 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_59

  # Create instance: axi_register_slice_60, and set properties
  set axi_register_slice_60 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_60 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_60

  # Create instance: axi_register_slice_61, and set properties
  set axi_register_slice_61 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_61 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_61

  # Create instance: axi_register_slice_62, and set properties
  set axi_register_slice_62 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_62 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_62

  # Create instance: axi_register_slice_63, and set properties
  set axi_register_slice_63 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_63 ]
  set_property -dict [ list \
   CONFIG.REG_AR {7} \
   CONFIG.REG_AW {7} \
   CONFIG.REG_B {7} \
   CONFIG.REG_R {7} \
   CONFIG.REG_W {7} \
 ] $axi_register_slice_63

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

  # Create instance: axi_vip_32, and set properties
  set axi_vip_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_32 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_32

  # Create instance: axi_vip_33, and set properties
  set axi_vip_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_33 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.INTERFACE_MODE {SLAVE} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
 ] $axi_vip_33

  # Create instance: axi_vip_34, and set properties
  set axi_vip_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_34 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_34

  # Create instance: axi_vip_35, and set properties
  set axi_vip_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_35 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_35

  # Create instance: axi_vip_36, and set properties
  set axi_vip_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_36 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_36

  # Create instance: axi_vip_37, and set properties
  set axi_vip_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_37 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_37

  # Create instance: axi_vip_38, and set properties
  set axi_vip_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_38 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_38

  # Create instance: axi_vip_39, and set properties
  set axi_vip_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_39 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_39

  # Create instance: axi_vip_40, and set properties
  set axi_vip_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_40 ]
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
 ] $axi_vip_40

  # Create instance: axi_vip_41, and set properties
  set axi_vip_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_41 ]
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
 ] $axi_vip_41

  # Create instance: axi_vip_42, and set properties
  set axi_vip_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_42 ]
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
 ] $axi_vip_42

  # Create instance: axi_vip_43, and set properties
  set axi_vip_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_43 ]
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
 ] $axi_vip_43

  # Create instance: axi_vip_44, and set properties
  set axi_vip_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_44 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_44

  # Create instance: axi_vip_45, and set properties
  set axi_vip_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_45 ]
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
 ] $axi_vip_45

  # Create instance: axi_vip_46, and set properties
  set axi_vip_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_46 ]
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
 ] $axi_vip_46

  # Create instance: axi_vip_47, and set properties
  set axi_vip_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_47 ]
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
 ] $axi_vip_47

  # Create instance: axi_vip_48, and set properties
  set axi_vip_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_48 ]
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
 ] $axi_vip_48

  # Create instance: axi_vip_49, and set properties
  set axi_vip_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_49 ]
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
 ] $axi_vip_49

  # Create instance: axi_vip_50, and set properties
  set axi_vip_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_50 ]
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
 ] $axi_vip_50

  # Create instance: axi_vip_51, and set properties
  set axi_vip_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_51 ]
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
 ] $axi_vip_51

  # Create instance: axi_vip_52, and set properties
  set axi_vip_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_52 ]
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
 ] $axi_vip_52

  # Create instance: axi_vip_53, and set properties
  set axi_vip_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_53 ]
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
 ] $axi_vip_53

  # Create instance: axi_vip_54, and set properties
  set axi_vip_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_54 ]
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
 ] $axi_vip_54

  # Create instance: axi_vip_55, and set properties
  set axi_vip_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_55 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_55

  # Create instance: axi_vip_56, and set properties
  set axi_vip_56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_56 ]
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
 ] $axi_vip_56

  # Create instance: axi_vip_57, and set properties
  set axi_vip_57 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_57 ]
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
 ] $axi_vip_57

  # Create instance: axi_vip_58, and set properties
  set axi_vip_58 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_58 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_58

  # Create instance: axi_vip_59, and set properties
  set axi_vip_59 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_59 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_59

  # Create instance: axi_vip_60, and set properties
  set axi_vip_60 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_60 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_60

  # Create instance: axi_vip_61, and set properties
  set axi_vip_61 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_61 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_61

  # Create instance: axi_vip_62, and set properties
  set axi_vip_62 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_62 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_62

  # Create instance: axi_vip_63, and set properties
  set axi_vip_63 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_63 ]
  set_property -dict [ list \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_63

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

  # Create instance: axis_register_slice_32, and set properties
  set axis_register_slice_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_32 ]

  # Create instance: axis_register_slice_33, and set properties
  set axis_register_slice_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_33 ]

  # Create instance: axis_register_slice_34, and set properties
  set axis_register_slice_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_34 ]

  # Create instance: axis_register_slice_35, and set properties
  set axis_register_slice_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_35 ]

  # Create instance: axis_register_slice_36, and set properties
  set axis_register_slice_36 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_36 ]

  # Create instance: axis_register_slice_37, and set properties
  set axis_register_slice_37 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_37 ]

  # Create instance: axis_register_slice_38, and set properties
  set axis_register_slice_38 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_38 ]

  # Create instance: axis_register_slice_39, and set properties
  set axis_register_slice_39 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_39 ]

  # Create instance: axis_register_slice_40, and set properties
  set axis_register_slice_40 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_40 ]

  # Create instance: axis_register_slice_41, and set properties
  set axis_register_slice_41 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_41 ]

  # Create instance: axis_register_slice_42, and set properties
  set axis_register_slice_42 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_42 ]

  # Create instance: axis_register_slice_43, and set properties
  set axis_register_slice_43 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_43 ]

  # Create instance: axis_register_slice_44, and set properties
  set axis_register_slice_44 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_44 ]

  # Create instance: axis_register_slice_45, and set properties
  set axis_register_slice_45 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_45 ]

  # Create instance: axis_register_slice_46, and set properties
  set axis_register_slice_46 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_46 ]

  # Create instance: axis_register_slice_47, and set properties
  set axis_register_slice_47 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_47 ]

  # Create instance: axis_register_slice_48, and set properties
  set axis_register_slice_48 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_48 ]

  # Create instance: axis_register_slice_49, and set properties
  set axis_register_slice_49 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_49 ]

  # Create instance: axis_register_slice_50, and set properties
  set axis_register_slice_50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_50 ]

  # Create instance: axis_register_slice_51, and set properties
  set axis_register_slice_51 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_51 ]

  # Create instance: axis_register_slice_52, and set properties
  set axis_register_slice_52 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_52 ]

  # Create instance: axis_register_slice_53, and set properties
  set axis_register_slice_53 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_53 ]

  # Create instance: axis_register_slice_54, and set properties
  set axis_register_slice_54 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_54 ]

  # Create instance: axis_register_slice_55, and set properties
  set axis_register_slice_55 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_55 ]

  # Create instance: axis_register_slice_56, and set properties
  set axis_register_slice_56 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_56 ]

  # Create instance: axis_register_slice_57, and set properties
  set axis_register_slice_57 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_57 ]

  # Create instance: axis_register_slice_58, and set properties
  set axis_register_slice_58 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_58 ]

  # Create instance: axis_register_slice_59, and set properties
  set axis_register_slice_59 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_59 ]

  # Create instance: axis_register_slice_60, and set properties
  set axis_register_slice_60 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_60 ]

  # Create instance: axis_register_slice_61, and set properties
  set axis_register_slice_61 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_61 ]

  # Create instance: axis_register_slice_62, and set properties
  set axis_register_slice_62 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_62 ]

  # Create instance: axis_register_slice_63, and set properties
  set axis_register_slice_63 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_63 ]

  # Create instance: debug_bridge_0, and set properties
  set debug_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI0_SLR01_1 [get_bd_intf_ports S_AXI0_SLR01] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI0_SLR01_2 [get_bd_intf_ports S_AXI0_SLR12] [get_bd_intf_pins axi_register_slice_32/S_AXI]
  connect_bd_intf_net -intf_net S_AXI10_SLR01_1 [get_bd_intf_ports S_AXI10_SLR01] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net S_AXI10_SLR01_2 [get_bd_intf_ports S_AXI10_SLR12] [get_bd_intf_pins axi_register_slice_34/S_AXI]
  connect_bd_intf_net -intf_net S_AXI11_SLR01_1 [get_bd_intf_ports S_AXI11_SLR01] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net S_AXI11_SLR01_2 [get_bd_intf_ports S_AXI11_SLR12] [get_bd_intf_pins axi_register_slice_35/S_AXI]
  connect_bd_intf_net -intf_net S_AXI12_SLR01_1 [get_bd_intf_ports S_AXI12_SLR01] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net S_AXI12_SLR01_2 [get_bd_intf_ports S_AXI12_SLR12] [get_bd_intf_pins axi_register_slice_36/S_AXI]
  connect_bd_intf_net -intf_net S_AXI13_SLR01_1 [get_bd_intf_ports S_AXI13_SLR01] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net S_AXI13_SLR01_2 [get_bd_intf_ports S_AXI13_SLR12] [get_bd_intf_pins axi_register_slice_37/S_AXI]
  connect_bd_intf_net -intf_net S_AXI14_SLR01_1 [get_bd_intf_ports S_AXI14_SLR01] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net S_AXI14_SLR01_2 [get_bd_intf_ports S_AXI14_SLR12] [get_bd_intf_pins axi_register_slice_38/S_AXI]
  connect_bd_intf_net -intf_net S_AXI15_SLR01_1 [get_bd_intf_ports S_AXI15_SLR01] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net S_AXI15_SLR01_2 [get_bd_intf_ports S_AXI15_SLR12] [get_bd_intf_pins axi_register_slice_39/S_AXI]
  connect_bd_intf_net -intf_net S_AXI1_SLR01_1 [get_bd_intf_ports S_AXI1_SLR01] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net S_AXI1_SLR01_2 [get_bd_intf_ports S_AXI1_SLR12] [get_bd_intf_pins axi_register_slice_33/S_AXI]
  connect_bd_intf_net -intf_net S_AXI2_SLR01_1 [get_bd_intf_ports S_AXI2_SLR01] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net S_AXI2_SLR01_2 [get_bd_intf_ports S_AXI2_SLR12] [get_bd_intf_pins axi_register_slice_44/S_AXI]
  connect_bd_intf_net -intf_net S_AXI3_SLR01_1 [get_bd_intf_ports S_AXI3_SLR01] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net S_AXI3_SLR01_2 [get_bd_intf_ports S_AXI3_SLR12] [get_bd_intf_pins axi_register_slice_55/S_AXI]
  connect_bd_intf_net -intf_net S_AXI4_SLR01_1 [get_bd_intf_ports S_AXI4_SLR01] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net S_AXI4_SLR01_2 [get_bd_intf_ports S_AXI4_SLR12] [get_bd_intf_pins axi_register_slice_58/S_AXI]
  connect_bd_intf_net -intf_net S_AXI5_SLR01_1 [get_bd_intf_ports S_AXI5_SLR01] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net S_AXI5_SLR01_2 [get_bd_intf_ports S_AXI5_SLR12] [get_bd_intf_pins axi_register_slice_59/S_AXI]
  connect_bd_intf_net -intf_net S_AXI6_SLR01_1 [get_bd_intf_ports S_AXI6_SLR01] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net S_AXI6_SLR01_2 [get_bd_intf_ports S_AXI6_SLR12] [get_bd_intf_pins axi_register_slice_60/S_AXI]
  connect_bd_intf_net -intf_net S_AXI7_SLR01_1 [get_bd_intf_ports S_AXI7_SLR01] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net S_AXI7_SLR01_2 [get_bd_intf_ports S_AXI7_SLR12] [get_bd_intf_pins axi_register_slice_61/S_AXI]
  connect_bd_intf_net -intf_net S_AXI8_SLR01_1 [get_bd_intf_ports S_AXI8_SLR01] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net S_AXI8_SLR01_2 [get_bd_intf_ports S_AXI8_SLR12] [get_bd_intf_pins axi_register_slice_62/S_AXI]
  connect_bd_intf_net -intf_net S_AXI9_SLR01_1 [get_bd_intf_ports S_AXI9_SLR01] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net S_AXI9_SLR01_2 [get_bd_intf_ports S_AXI9_SLR12] [get_bd_intf_pins axi_register_slice_63/S_AXI]
  connect_bd_intf_net -intf_net S_AXIS0_SLR01_1 [get_bd_intf_ports S_AXIS0_SLR01] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS0_SLR01_2 [get_bd_intf_ports S_AXIS0_SLR12] [get_bd_intf_pins axis_register_slice_32/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS10_SLR01_1 [get_bd_intf_ports S_AXIS10_SLR01] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS10_SLR01_2 [get_bd_intf_ports S_AXIS10_SLR12] [get_bd_intf_pins axis_register_slice_34/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS11_SLR01_1 [get_bd_intf_ports S_AXIS11_SLR01] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS11_SLR01_2 [get_bd_intf_ports S_AXIS11_SLR12] [get_bd_intf_pins axis_register_slice_35/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS12_SLR01_1 [get_bd_intf_ports S_AXIS12_SLR01] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS12_SLR01_2 [get_bd_intf_ports S_AXIS12_SLR12] [get_bd_intf_pins axis_register_slice_36/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS13_SLR01_1 [get_bd_intf_ports S_AXIS13_SLR01] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS13_SLR01_2 [get_bd_intf_ports S_AXIS13_SLR12] [get_bd_intf_pins axis_register_slice_37/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS14_SLR01_1 [get_bd_intf_ports S_AXIS14_SLR01] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS14_SLR01_2 [get_bd_intf_ports S_AXIS14_SLR12] [get_bd_intf_pins axis_register_slice_38/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS15_SLR01_1 [get_bd_intf_ports S_AXIS15_SLR01] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS15_SLR01_2 [get_bd_intf_ports S_AXIS15_SLR12] [get_bd_intf_pins axis_register_slice_39/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS1_SLR01_1 [get_bd_intf_ports S_AXIS1_SLR01] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS1_SLR01_2 [get_bd_intf_ports S_AXIS1_SLR12] [get_bd_intf_pins axis_register_slice_33/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS2_SLR01_1 [get_bd_intf_ports S_AXIS2_SLR01] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS2_SLR01_2 [get_bd_intf_ports S_AXIS2_SLR12] [get_bd_intf_pins axis_register_slice_44/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS3_SLR01_1 [get_bd_intf_ports S_AXIS3_SLR01] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS3_SLR01_2 [get_bd_intf_ports S_AXIS3_SLR12] [get_bd_intf_pins axis_register_slice_55/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS4_SLR01_1 [get_bd_intf_ports S_AXIS4_SLR01] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS4_SLR01_2 [get_bd_intf_ports S_AXIS4_SLR12] [get_bd_intf_pins axis_register_slice_58/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS5_SLR01_1 [get_bd_intf_ports S_AXIS5_SLR01] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS5_SLR01_2 [get_bd_intf_ports S_AXIS5_SLR12] [get_bd_intf_pins axis_register_slice_59/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS6_SLR01_1 [get_bd_intf_ports S_AXIS6_SLR01] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS6_SLR01_2 [get_bd_intf_ports S_AXIS6_SLR12] [get_bd_intf_pins axis_register_slice_60/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS7_SLR01_1 [get_bd_intf_ports S_AXIS7_SLR01] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS7_SLR01_2 [get_bd_intf_ports S_AXIS7_SLR12] [get_bd_intf_pins axis_register_slice_61/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS8_SLR01_1 [get_bd_intf_ports S_AXIS8_SLR01] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS8_SLR01_2 [get_bd_intf_ports S_AXIS8_SLR12] [get_bd_intf_pins axis_register_slice_62/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS9_SLR01_1 [get_bd_intf_ports S_AXIS9_SLR01] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS9_SLR01_2 [get_bd_intf_ports S_AXIS9_SLR12] [get_bd_intf_pins axis_register_slice_63/S_AXIS]
  connect_bd_intf_net -intf_net S_BSCAN_0_1 [get_bd_intf_ports S_BSCAN_0] [get_bd_intf_pins debug_bridge_0/S_BSCAN]
  connect_bd_intf_net -intf_net axi4stream_vip_16_M_AXIS [get_bd_intf_pins axi4stream_vip_16/M_AXIS] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_16_M_AXIS1 [get_bd_intf_pins axi4stream_vip_40/M_AXIS] [get_bd_intf_pins axis_register_slice_40/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_17_M_AXIS [get_bd_intf_pins axi4stream_vip_17/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_17_M_AXIS1 [get_bd_intf_pins axi4stream_vip_41/M_AXIS] [get_bd_intf_pins axis_register_slice_41/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_18_M_AXIS [get_bd_intf_pins axi4stream_vip_18/M_AXIS] [get_bd_intf_pins axis_register_slice_18/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_18_M_AXIS1 [get_bd_intf_pins axi4stream_vip_42/M_AXIS] [get_bd_intf_pins axis_register_slice_42/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_19_M_AXIS [get_bd_intf_pins axi4stream_vip_19/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_19_M_AXIS1 [get_bd_intf_pins axi4stream_vip_43/M_AXIS] [get_bd_intf_pins axis_register_slice_43/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_20_M_AXIS [get_bd_intf_pins axi4stream_vip_20/M_AXIS] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_20_M_AXIS1 [get_bd_intf_pins axi4stream_vip_45/M_AXIS] [get_bd_intf_pins axis_register_slice_45/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_21_M_AXIS [get_bd_intf_pins axi4stream_vip_21/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_21_M_AXIS1 [get_bd_intf_pins axi4stream_vip_46/M_AXIS] [get_bd_intf_pins axis_register_slice_46/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_22_M_AXIS [get_bd_intf_pins axi4stream_vip_22/M_AXIS] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_22_M_AXIS1 [get_bd_intf_pins axi4stream_vip_47/M_AXIS] [get_bd_intf_pins axis_register_slice_47/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_23_M_AXIS [get_bd_intf_pins axi4stream_vip_23/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_23_M_AXIS1 [get_bd_intf_pins axi4stream_vip_48/M_AXIS] [get_bd_intf_pins axis_register_slice_48/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_24_M_AXIS [get_bd_intf_pins axi4stream_vip_24/M_AXIS] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_24_M_AXIS1 [get_bd_intf_pins axi4stream_vip_49/M_AXIS] [get_bd_intf_pins axis_register_slice_49/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_25_M_AXIS [get_bd_intf_pins axi4stream_vip_25/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_25_M_AXIS1 [get_bd_intf_pins axi4stream_vip_50/M_AXIS] [get_bd_intf_pins axis_register_slice_50/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_26_M_AXIS [get_bd_intf_pins axi4stream_vip_26/M_AXIS] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_26_M_AXIS1 [get_bd_intf_pins axi4stream_vip_51/M_AXIS] [get_bd_intf_pins axis_register_slice_51/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_27_M_AXIS [get_bd_intf_pins axi4stream_vip_27/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_27_M_AXIS1 [get_bd_intf_pins axi4stream_vip_52/M_AXIS] [get_bd_intf_pins axis_register_slice_52/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_28_M_AXIS [get_bd_intf_pins axi4stream_vip_28/M_AXIS] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_28_M_AXIS1 [get_bd_intf_pins axi4stream_vip_53/M_AXIS] [get_bd_intf_pins axis_register_slice_53/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_29_M_AXIS [get_bd_intf_pins axi4stream_vip_29/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_29_M_AXIS1 [get_bd_intf_pins axi4stream_vip_54/M_AXIS] [get_bd_intf_pins axis_register_slice_54/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_30_M_AXIS [get_bd_intf_pins axi4stream_vip_30/M_AXIS] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_30_M_AXIS1 [get_bd_intf_pins axi4stream_vip_56/M_AXIS] [get_bd_intf_pins axis_register_slice_56/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_31_M_AXIS [get_bd_intf_pins axi4stream_vip_31/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]
  connect_bd_intf_net -intf_net axi4stream_vip_31_M_AXIS1 [get_bd_intf_pins axi4stream_vip_57/M_AXIS] [get_bd_intf_pins axis_register_slice_57/S_AXIS]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_vip_0/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI1 [get_bd_intf_pins axi_register_slice_32/M_AXI] [get_bd_intf_pins axi_vip_32/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_10_M_AXI [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_vip_10/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_10_M_AXI1 [get_bd_intf_pins axi_register_slice_34/M_AXI] [get_bd_intf_pins axi_vip_34/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_11_M_AXI [get_bd_intf_pins axi_register_slice_11/M_AXI] [get_bd_intf_pins axi_vip_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_11_M_AXI1 [get_bd_intf_pins axi_register_slice_35/M_AXI] [get_bd_intf_pins axi_vip_35/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_12_M_AXI [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_vip_12/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_12_M_AXI1 [get_bd_intf_pins axi_register_slice_36/M_AXI] [get_bd_intf_pins axi_vip_36/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_13_M_AXI [get_bd_intf_pins axi_register_slice_13/M_AXI] [get_bd_intf_pins axi_vip_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_13_M_AXI1 [get_bd_intf_pins axi_register_slice_37/M_AXI] [get_bd_intf_pins axi_vip_37/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_14_M_AXI [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_vip_14/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_14_M_AXI1 [get_bd_intf_pins axi_register_slice_38/M_AXI] [get_bd_intf_pins axi_vip_38/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_15_M_AXI [get_bd_intf_pins axi_register_slice_15/M_AXI] [get_bd_intf_pins axi_vip_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_15_M_AXI1 [get_bd_intf_pins axi_register_slice_39/M_AXI] [get_bd_intf_pins axi_vip_39/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_16_M_AXI [get_bd_intf_ports M_AXI0_SLR01] [get_bd_intf_pins axi_register_slice_16/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_16_M_AXI1 [get_bd_intf_ports M_AXI0_SLR12] [get_bd_intf_pins axi_register_slice_40/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_17_M_AXI [get_bd_intf_ports M_AXI1_SLR01] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_17_M_AXI1 [get_bd_intf_ports M_AXI1_SLR12] [get_bd_intf_pins axi_register_slice_41/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_18_M_AXI [get_bd_intf_ports M_AXI2_SLR01] [get_bd_intf_pins axi_register_slice_18/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_18_M_AXI1 [get_bd_intf_ports M_AXI2_SLR12] [get_bd_intf_pins axi_register_slice_42/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_19_M_AXI [get_bd_intf_ports M_AXI3_SLR01] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_19_M_AXI1 [get_bd_intf_ports M_AXI3_SLR12] [get_bd_intf_pins axi_register_slice_43/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins axi_register_slice_1/M_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI1 [get_bd_intf_pins axi_register_slice_33/M_AXI] [get_bd_intf_pins axi_vip_33/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_20_M_AXI [get_bd_intf_ports M_AXI4_SLR01] [get_bd_intf_pins axi_register_slice_20/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_20_M_AXI1 [get_bd_intf_ports M_AXI4_SLR12] [get_bd_intf_pins axi_register_slice_45/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_21_M_AXI [get_bd_intf_ports M_AXI5_SLR01] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_21_M_AXI1 [get_bd_intf_ports M_AXI5_SLR12] [get_bd_intf_pins axi_register_slice_46/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_22_M_AXI [get_bd_intf_ports M_AXI6_SLR01] [get_bd_intf_pins axi_register_slice_22/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_22_M_AXI1 [get_bd_intf_ports M_AXI6_SLR12] [get_bd_intf_pins axi_register_slice_47/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_23_M_AXI [get_bd_intf_ports M_AXI7_SLR01] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_23_M_AXI1 [get_bd_intf_ports M_AXI7_SLR12] [get_bd_intf_pins axi_register_slice_48/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_24_M_AXI [get_bd_intf_ports M_AXI8_SLR01] [get_bd_intf_pins axi_register_slice_24/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_24_M_AXI1 [get_bd_intf_ports M_AXI8_SLR12] [get_bd_intf_pins axi_register_slice_49/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_25_M_AXI [get_bd_intf_ports M_AXI9_SLR01] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_25_M_AXI1 [get_bd_intf_ports M_AXI9_SLR12] [get_bd_intf_pins axi_register_slice_50/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_26_M_AXI [get_bd_intf_ports M_AXI10_SLR01] [get_bd_intf_pins axi_register_slice_26/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_26_M_AXI1 [get_bd_intf_ports M_AXI10_SLR12] [get_bd_intf_pins axi_register_slice_51/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_27_M_AXI [get_bd_intf_ports M_AXI11_SLR01] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_27_M_AXI1 [get_bd_intf_ports M_AXI11_SLR12] [get_bd_intf_pins axi_register_slice_52/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_28_M_AXI [get_bd_intf_ports M_AXI12_SLR01] [get_bd_intf_pins axi_register_slice_28/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_28_M_AXI1 [get_bd_intf_ports M_AXI12_SLR12] [get_bd_intf_pins axi_register_slice_53/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_29_M_AXI [get_bd_intf_ports M_AXI13_SLR01] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_29_M_AXI1 [get_bd_intf_ports M_AXI13_SLR12] [get_bd_intf_pins axi_register_slice_54/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_M_AXI [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_vip_2/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_M_AXI1 [get_bd_intf_pins axi_register_slice_44/M_AXI] [get_bd_intf_pins axi_vip_44/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_30_M_AXI [get_bd_intf_ports M_AXI14_SLR01] [get_bd_intf_pins axi_register_slice_30/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_30_M_AXI1 [get_bd_intf_ports M_AXI14_SLR12] [get_bd_intf_pins axi_register_slice_56/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_ports M_AXI15_SLR01] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI1 [get_bd_intf_ports M_AXI15_SLR12] [get_bd_intf_pins axi_register_slice_57/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_M_AXI [get_bd_intf_pins axi_register_slice_3/M_AXI] [get_bd_intf_pins axi_vip_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_M_AXI1 [get_bd_intf_pins axi_register_slice_55/M_AXI] [get_bd_intf_pins axi_vip_55/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_vip_4/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI1 [get_bd_intf_pins axi_register_slice_58/M_AXI] [get_bd_intf_pins axi_vip_58/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI [get_bd_intf_pins axi_register_slice_5/M_AXI] [get_bd_intf_pins axi_vip_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI1 [get_bd_intf_pins axi_register_slice_59/M_AXI] [get_bd_intf_pins axi_vip_59/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_6_M_AXI [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_vip_6/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_6_M_AXI1 [get_bd_intf_pins axi_register_slice_60/M_AXI] [get_bd_intf_pins axi_vip_60/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_7_M_AXI [get_bd_intf_pins axi_register_slice_7/M_AXI] [get_bd_intf_pins axi_vip_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_7_M_AXI1 [get_bd_intf_pins axi_register_slice_61/M_AXI] [get_bd_intf_pins axi_vip_61/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_8_M_AXI [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_vip_8/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_8_M_AXI1 [get_bd_intf_pins axi_register_slice_62/M_AXI] [get_bd_intf_pins axi_vip_62/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI [get_bd_intf_pins axi_register_slice_9/M_AXI] [get_bd_intf_pins axi_vip_9/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI1 [get_bd_intf_pins axi_register_slice_63/M_AXI] [get_bd_intf_pins axi_vip_63/S_AXI]
  connect_bd_intf_net -intf_net axi_vip_16_M_AXI [get_bd_intf_pins axi_register_slice_16/S_AXI] [get_bd_intf_pins axi_vip_16/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_16_M_AXI1 [get_bd_intf_pins axi_register_slice_40/S_AXI] [get_bd_intf_pins axi_vip_40/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_17_M_AXI [get_bd_intf_pins axi_register_slice_17/S_AXI] [get_bd_intf_pins axi_vip_17/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_17_M_AXI1 [get_bd_intf_pins axi_register_slice_41/S_AXI] [get_bd_intf_pins axi_vip_41/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_18_M_AXI [get_bd_intf_pins axi_register_slice_18/S_AXI] [get_bd_intf_pins axi_vip_18/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_18_M_AXI1 [get_bd_intf_pins axi_register_slice_42/S_AXI] [get_bd_intf_pins axi_vip_42/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_19_M_AXI [get_bd_intf_pins axi_register_slice_19/S_AXI] [get_bd_intf_pins axi_vip_19/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_19_M_AXI1 [get_bd_intf_pins axi_register_slice_43/S_AXI] [get_bd_intf_pins axi_vip_43/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_20_M_AXI [get_bd_intf_pins axi_register_slice_20/S_AXI] [get_bd_intf_pins axi_vip_20/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_20_M_AXI1 [get_bd_intf_pins axi_register_slice_45/S_AXI] [get_bd_intf_pins axi_vip_45/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_21_M_AXI [get_bd_intf_pins axi_register_slice_21/S_AXI] [get_bd_intf_pins axi_vip_21/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_21_M_AXI1 [get_bd_intf_pins axi_register_slice_46/S_AXI] [get_bd_intf_pins axi_vip_46/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_22_M_AXI [get_bd_intf_pins axi_register_slice_22/S_AXI] [get_bd_intf_pins axi_vip_22/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_22_M_AXI1 [get_bd_intf_pins axi_register_slice_47/S_AXI] [get_bd_intf_pins axi_vip_47/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_23_M_AXI [get_bd_intf_pins axi_register_slice_23/S_AXI] [get_bd_intf_pins axi_vip_23/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_23_M_AXI1 [get_bd_intf_pins axi_register_slice_48/S_AXI] [get_bd_intf_pins axi_vip_48/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_24_M_AXI [get_bd_intf_pins axi_register_slice_24/S_AXI] [get_bd_intf_pins axi_vip_24/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_24_M_AXI1 [get_bd_intf_pins axi_register_slice_49/S_AXI] [get_bd_intf_pins axi_vip_49/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_25_M_AXI [get_bd_intf_pins axi_register_slice_25/S_AXI] [get_bd_intf_pins axi_vip_25/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_25_M_AXI1 [get_bd_intf_pins axi_register_slice_50/S_AXI] [get_bd_intf_pins axi_vip_50/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_26_M_AXI [get_bd_intf_pins axi_register_slice_26/S_AXI] [get_bd_intf_pins axi_vip_26/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_26_M_AXI1 [get_bd_intf_pins axi_register_slice_51/S_AXI] [get_bd_intf_pins axi_vip_51/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_27_M_AXI [get_bd_intf_pins axi_register_slice_27/S_AXI] [get_bd_intf_pins axi_vip_27/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_27_M_AXI1 [get_bd_intf_pins axi_register_slice_52/S_AXI] [get_bd_intf_pins axi_vip_52/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_28_M_AXI [get_bd_intf_pins axi_register_slice_28/S_AXI] [get_bd_intf_pins axi_vip_28/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_28_M_AXI1 [get_bd_intf_pins axi_register_slice_53/S_AXI] [get_bd_intf_pins axi_vip_53/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_29_M_AXI [get_bd_intf_pins axi_register_slice_29/S_AXI] [get_bd_intf_pins axi_vip_29/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_29_M_AXI1 [get_bd_intf_pins axi_register_slice_54/S_AXI] [get_bd_intf_pins axi_vip_54/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_30_M_AXI [get_bd_intf_pins axi_register_slice_30/S_AXI] [get_bd_intf_pins axi_vip_30/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_30_M_AXI1 [get_bd_intf_pins axi_register_slice_56/S_AXI] [get_bd_intf_pins axi_vip_56/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_31_M_AXI [get_bd_intf_pins axi_register_slice_31/S_AXI] [get_bd_intf_pins axi_vip_31/M_AXI]
  connect_bd_intf_net -intf_net axi_vip_31_M_AXI1 [get_bd_intf_pins axi_register_slice_57/S_AXI] [get_bd_intf_pins axi_vip_57/M_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axi4stream_vip_0/S_AXIS] [get_bd_intf_pins axis_register_slice_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS1 [get_bd_intf_pins axi4stream_vip_32/S_AXIS] [get_bd_intf_pins axis_register_slice_32/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_10_M_AXIS [get_bd_intf_pins axi4stream_vip_10/S_AXIS] [get_bd_intf_pins axis_register_slice_10/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_10_M_AXIS1 [get_bd_intf_pins axi4stream_vip_34/S_AXIS] [get_bd_intf_pins axis_register_slice_34/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_11_M_AXIS [get_bd_intf_pins axi4stream_vip_11/S_AXIS] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_11_M_AXIS1 [get_bd_intf_pins axi4stream_vip_35/S_AXIS] [get_bd_intf_pins axis_register_slice_35/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_12_M_AXIS [get_bd_intf_pins axi4stream_vip_12/S_AXIS] [get_bd_intf_pins axis_register_slice_12/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_12_M_AXIS1 [get_bd_intf_pins axi4stream_vip_36/S_AXIS] [get_bd_intf_pins axis_register_slice_36/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_13_M_AXIS [get_bd_intf_pins axi4stream_vip_13/S_AXIS] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_13_M_AXIS1 [get_bd_intf_pins axi4stream_vip_37/S_AXIS] [get_bd_intf_pins axis_register_slice_37/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_14_M_AXIS [get_bd_intf_pins axi4stream_vip_14/S_AXIS] [get_bd_intf_pins axis_register_slice_14/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_14_M_AXIS1 [get_bd_intf_pins axi4stream_vip_38/S_AXIS] [get_bd_intf_pins axis_register_slice_38/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_15_M_AXIS [get_bd_intf_pins axi4stream_vip_15/S_AXIS] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_15_M_AXIS1 [get_bd_intf_pins axi4stream_vip_39/S_AXIS] [get_bd_intf_pins axis_register_slice_39/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_16_M_AXIS [get_bd_intf_ports M_AXIS0_SLR01] [get_bd_intf_pins axis_register_slice_16/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_16_M_AXIS1 [get_bd_intf_ports M_AXIS0_SLR12] [get_bd_intf_pins axis_register_slice_40/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_17_M_AXIS [get_bd_intf_ports M_AXIS1_SLR01] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_17_M_AXIS1 [get_bd_intf_ports M_AXIS1_SLR12] [get_bd_intf_pins axis_register_slice_41/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_18_M_AXIS [get_bd_intf_ports M_AXIS2_SLR01] [get_bd_intf_pins axis_register_slice_18/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_18_M_AXIS1 [get_bd_intf_ports M_AXIS2_SLR12] [get_bd_intf_pins axis_register_slice_42/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_19_M_AXIS [get_bd_intf_ports M_AXIS3_SLR01] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_19_M_AXIS1 [get_bd_intf_ports M_AXIS3_SLR12] [get_bd_intf_pins axis_register_slice_43/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins axi4stream_vip_1/S_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS1 [get_bd_intf_pins axi4stream_vip_33/S_AXIS] [get_bd_intf_pins axis_register_slice_33/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_20_M_AXIS [get_bd_intf_ports M_AXIS4_SLR01] [get_bd_intf_pins axis_register_slice_20/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_20_M_AXIS1 [get_bd_intf_ports M_AXIS4_SLR12] [get_bd_intf_pins axis_register_slice_45/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_21_M_AXIS [get_bd_intf_ports M_AXIS5_SLR01] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_21_M_AXIS1 [get_bd_intf_ports M_AXIS5_SLR12] [get_bd_intf_pins axis_register_slice_46/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_22_M_AXIS [get_bd_intf_ports M_AXIS6_SLR01] [get_bd_intf_pins axis_register_slice_22/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_22_M_AXIS1 [get_bd_intf_ports M_AXIS6_SLR12] [get_bd_intf_pins axis_register_slice_47/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_23_M_AXIS [get_bd_intf_ports M_AXIS7_SLR01] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_23_M_AXIS1 [get_bd_intf_ports M_AXIS7_SLR12] [get_bd_intf_pins axis_register_slice_48/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_24_M_AXIS [get_bd_intf_ports M_AXIS8_SLR01] [get_bd_intf_pins axis_register_slice_24/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_24_M_AXIS1 [get_bd_intf_ports M_AXIS8_SLR12] [get_bd_intf_pins axis_register_slice_49/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_25_M_AXIS [get_bd_intf_ports M_AXIS9_SLR01] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_25_M_AXIS1 [get_bd_intf_ports M_AXIS9_SLR12] [get_bd_intf_pins axis_register_slice_50/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_26_M_AXIS [get_bd_intf_ports M_AXIS10_SLR01] [get_bd_intf_pins axis_register_slice_26/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_26_M_AXIS1 [get_bd_intf_ports M_AXIS10_SLR12] [get_bd_intf_pins axis_register_slice_51/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_27_M_AXIS [get_bd_intf_ports M_AXIS11_SLR01] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_27_M_AXIS1 [get_bd_intf_ports M_AXIS11_SLR12] [get_bd_intf_pins axis_register_slice_52/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_28_M_AXIS [get_bd_intf_ports M_AXIS12_SLR01] [get_bd_intf_pins axis_register_slice_28/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_28_M_AXIS1 [get_bd_intf_ports M_AXIS12_SLR12] [get_bd_intf_pins axis_register_slice_53/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_29_M_AXIS [get_bd_intf_ports M_AXIS13_SLR01] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_29_M_AXIS1 [get_bd_intf_ports M_AXIS13_SLR12] [get_bd_intf_pins axis_register_slice_54/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins axi4stream_vip_2/S_AXIS] [get_bd_intf_pins axis_register_slice_2/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS1 [get_bd_intf_pins axi4stream_vip_44/S_AXIS] [get_bd_intf_pins axis_register_slice_44/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_30_M_AXIS [get_bd_intf_ports M_AXIS14_SLR01] [get_bd_intf_pins axis_register_slice_30/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_30_M_AXIS1 [get_bd_intf_ports M_AXIS14_SLR12] [get_bd_intf_pins axis_register_slice_56/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_31_M_AXIS [get_bd_intf_ports M_AXIS15_SLR01] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_31_M_AXIS1 [get_bd_intf_ports M_AXIS15_SLR12] [get_bd_intf_pins axis_register_slice_57/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins axi4stream_vip_3/S_AXIS] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS1 [get_bd_intf_pins axi4stream_vip_55/S_AXIS] [get_bd_intf_pins axis_register_slice_55/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_4_M_AXIS [get_bd_intf_pins axi4stream_vip_4/S_AXIS] [get_bd_intf_pins axis_register_slice_4/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_4_M_AXIS1 [get_bd_intf_pins axi4stream_vip_58/S_AXIS] [get_bd_intf_pins axis_register_slice_58/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_5_M_AXIS [get_bd_intf_pins axi4stream_vip_5/S_AXIS] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_5_M_AXIS1 [get_bd_intf_pins axi4stream_vip_59/S_AXIS] [get_bd_intf_pins axis_register_slice_59/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_6_M_AXIS [get_bd_intf_pins axi4stream_vip_6/S_AXIS] [get_bd_intf_pins axis_register_slice_6/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_6_M_AXIS1 [get_bd_intf_pins axi4stream_vip_60/S_AXIS] [get_bd_intf_pins axis_register_slice_60/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS [get_bd_intf_pins axi4stream_vip_7/S_AXIS] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS1 [get_bd_intf_pins axi4stream_vip_61/S_AXIS] [get_bd_intf_pins axis_register_slice_61/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_8_M_AXIS [get_bd_intf_pins axi4stream_vip_8/S_AXIS] [get_bd_intf_pins axis_register_slice_8/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_8_M_AXIS1 [get_bd_intf_pins axi4stream_vip_62/S_AXIS] [get_bd_intf_pins axis_register_slice_62/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_9_M_AXIS [get_bd_intf_pins axi4stream_vip_9/S_AXIS] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_9_M_AXIS1 [get_bd_intf_pins axi4stream_vip_63/S_AXIS] [get_bd_intf_pins axis_register_slice_63/M_AXIS]

  # Create port connections
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi4stream_vip_0/aclk] [get_bd_pins axi4stream_vip_1/aclk] [get_bd_pins axi4stream_vip_10/aclk] [get_bd_pins axi4stream_vip_11/aclk] [get_bd_pins axi4stream_vip_12/aclk] [get_bd_pins axi4stream_vip_13/aclk] [get_bd_pins axi4stream_vip_14/aclk] [get_bd_pins axi4stream_vip_15/aclk] [get_bd_pins axi4stream_vip_16/aclk] [get_bd_pins axi4stream_vip_17/aclk] [get_bd_pins axi4stream_vip_18/aclk] [get_bd_pins axi4stream_vip_19/aclk] [get_bd_pins axi4stream_vip_2/aclk] [get_bd_pins axi4stream_vip_20/aclk] [get_bd_pins axi4stream_vip_21/aclk] [get_bd_pins axi4stream_vip_22/aclk] [get_bd_pins axi4stream_vip_23/aclk] [get_bd_pins axi4stream_vip_24/aclk] [get_bd_pins axi4stream_vip_25/aclk] [get_bd_pins axi4stream_vip_26/aclk] [get_bd_pins axi4stream_vip_27/aclk] [get_bd_pins axi4stream_vip_28/aclk] [get_bd_pins axi4stream_vip_29/aclk] [get_bd_pins axi4stream_vip_3/aclk] [get_bd_pins axi4stream_vip_30/aclk] [get_bd_pins axi4stream_vip_31/aclk] [get_bd_pins axi4stream_vip_32/aclk] [get_bd_pins axi4stream_vip_33/aclk] [get_bd_pins axi4stream_vip_34/aclk] [get_bd_pins axi4stream_vip_35/aclk] [get_bd_pins axi4stream_vip_36/aclk] [get_bd_pins axi4stream_vip_37/aclk] [get_bd_pins axi4stream_vip_38/aclk] [get_bd_pins axi4stream_vip_39/aclk] [get_bd_pins axi4stream_vip_4/aclk] [get_bd_pins axi4stream_vip_40/aclk] [get_bd_pins axi4stream_vip_41/aclk] [get_bd_pins axi4stream_vip_42/aclk] [get_bd_pins axi4stream_vip_43/aclk] [get_bd_pins axi4stream_vip_44/aclk] [get_bd_pins axi4stream_vip_45/aclk] [get_bd_pins axi4stream_vip_46/aclk] [get_bd_pins axi4stream_vip_47/aclk] [get_bd_pins axi4stream_vip_48/aclk] [get_bd_pins axi4stream_vip_49/aclk] [get_bd_pins axi4stream_vip_5/aclk] [get_bd_pins axi4stream_vip_50/aclk] [get_bd_pins axi4stream_vip_51/aclk] [get_bd_pins axi4stream_vip_52/aclk] [get_bd_pins axi4stream_vip_53/aclk] [get_bd_pins axi4stream_vip_54/aclk] [get_bd_pins axi4stream_vip_55/aclk] [get_bd_pins axi4stream_vip_56/aclk] [get_bd_pins axi4stream_vip_57/aclk] [get_bd_pins axi4stream_vip_58/aclk] [get_bd_pins axi4stream_vip_59/aclk] [get_bd_pins axi4stream_vip_6/aclk] [get_bd_pins axi4stream_vip_60/aclk] [get_bd_pins axi4stream_vip_61/aclk] [get_bd_pins axi4stream_vip_62/aclk] [get_bd_pins axi4stream_vip_63/aclk] [get_bd_pins axi4stream_vip_7/aclk] [get_bd_pins axi4stream_vip_8/aclk] [get_bd_pins axi4stream_vip_9/aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_32/aclk] [get_bd_pins axi_register_slice_33/aclk] [get_bd_pins axi_register_slice_34/aclk] [get_bd_pins axi_register_slice_35/aclk] [get_bd_pins axi_register_slice_36/aclk] [get_bd_pins axi_register_slice_37/aclk] [get_bd_pins axi_register_slice_38/aclk] [get_bd_pins axi_register_slice_39/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_40/aclk] [get_bd_pins axi_register_slice_41/aclk] [get_bd_pins axi_register_slice_42/aclk] [get_bd_pins axi_register_slice_43/aclk] [get_bd_pins axi_register_slice_44/aclk] [get_bd_pins axi_register_slice_45/aclk] [get_bd_pins axi_register_slice_46/aclk] [get_bd_pins axi_register_slice_47/aclk] [get_bd_pins axi_register_slice_48/aclk] [get_bd_pins axi_register_slice_49/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_50/aclk] [get_bd_pins axi_register_slice_51/aclk] [get_bd_pins axi_register_slice_52/aclk] [get_bd_pins axi_register_slice_53/aclk] [get_bd_pins axi_register_slice_54/aclk] [get_bd_pins axi_register_slice_55/aclk] [get_bd_pins axi_register_slice_56/aclk] [get_bd_pins axi_register_slice_57/aclk] [get_bd_pins axi_register_slice_58/aclk] [get_bd_pins axi_register_slice_59/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_60/aclk] [get_bd_pins axi_register_slice_61/aclk] [get_bd_pins axi_register_slice_62/aclk] [get_bd_pins axi_register_slice_63/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins axi_vip_10/aclk] [get_bd_pins axi_vip_11/aclk] [get_bd_pins axi_vip_12/aclk] [get_bd_pins axi_vip_13/aclk] [get_bd_pins axi_vip_14/aclk] [get_bd_pins axi_vip_15/aclk] [get_bd_pins axi_vip_16/aclk] [get_bd_pins axi_vip_17/aclk] [get_bd_pins axi_vip_18/aclk] [get_bd_pins axi_vip_19/aclk] [get_bd_pins axi_vip_2/aclk] [get_bd_pins axi_vip_20/aclk] [get_bd_pins axi_vip_21/aclk] [get_bd_pins axi_vip_22/aclk] [get_bd_pins axi_vip_23/aclk] [get_bd_pins axi_vip_24/aclk] [get_bd_pins axi_vip_25/aclk] [get_bd_pins axi_vip_26/aclk] [get_bd_pins axi_vip_27/aclk] [get_bd_pins axi_vip_28/aclk] [get_bd_pins axi_vip_29/aclk] [get_bd_pins axi_vip_3/aclk] [get_bd_pins axi_vip_30/aclk] [get_bd_pins axi_vip_31/aclk] [get_bd_pins axi_vip_32/aclk] [get_bd_pins axi_vip_33/aclk] [get_bd_pins axi_vip_34/aclk] [get_bd_pins axi_vip_35/aclk] [get_bd_pins axi_vip_36/aclk] [get_bd_pins axi_vip_37/aclk] [get_bd_pins axi_vip_38/aclk] [get_bd_pins axi_vip_39/aclk] [get_bd_pins axi_vip_4/aclk] [get_bd_pins axi_vip_40/aclk] [get_bd_pins axi_vip_41/aclk] [get_bd_pins axi_vip_42/aclk] [get_bd_pins axi_vip_43/aclk] [get_bd_pins axi_vip_44/aclk] [get_bd_pins axi_vip_45/aclk] [get_bd_pins axi_vip_46/aclk] [get_bd_pins axi_vip_47/aclk] [get_bd_pins axi_vip_48/aclk] [get_bd_pins axi_vip_49/aclk] [get_bd_pins axi_vip_5/aclk] [get_bd_pins axi_vip_50/aclk] [get_bd_pins axi_vip_51/aclk] [get_bd_pins axi_vip_52/aclk] [get_bd_pins axi_vip_53/aclk] [get_bd_pins axi_vip_54/aclk] [get_bd_pins axi_vip_55/aclk] [get_bd_pins axi_vip_56/aclk] [get_bd_pins axi_vip_57/aclk] [get_bd_pins axi_vip_58/aclk] [get_bd_pins axi_vip_59/aclk] [get_bd_pins axi_vip_6/aclk] [get_bd_pins axi_vip_60/aclk] [get_bd_pins axi_vip_61/aclk] [get_bd_pins axi_vip_62/aclk] [get_bd_pins axi_vip_63/aclk] [get_bd_pins axi_vip_7/aclk] [get_bd_pins axi_vip_8/aclk] [get_bd_pins axi_vip_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_32/aclk] [get_bd_pins axis_register_slice_33/aclk] [get_bd_pins axis_register_slice_34/aclk] [get_bd_pins axis_register_slice_35/aclk] [get_bd_pins axis_register_slice_36/aclk] [get_bd_pins axis_register_slice_37/aclk] [get_bd_pins axis_register_slice_38/aclk] [get_bd_pins axis_register_slice_39/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_40/aclk] [get_bd_pins axis_register_slice_41/aclk] [get_bd_pins axis_register_slice_42/aclk] [get_bd_pins axis_register_slice_43/aclk] [get_bd_pins axis_register_slice_44/aclk] [get_bd_pins axis_register_slice_45/aclk] [get_bd_pins axis_register_slice_46/aclk] [get_bd_pins axis_register_slice_47/aclk] [get_bd_pins axis_register_slice_48/aclk] [get_bd_pins axis_register_slice_49/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_50/aclk] [get_bd_pins axis_register_slice_51/aclk] [get_bd_pins axis_register_slice_52/aclk] [get_bd_pins axis_register_slice_53/aclk] [get_bd_pins axis_register_slice_54/aclk] [get_bd_pins axis_register_slice_55/aclk] [get_bd_pins axis_register_slice_56/aclk] [get_bd_pins axis_register_slice_57/aclk] [get_bd_pins axis_register_slice_58/aclk] [get_bd_pins axis_register_slice_59/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_60/aclk] [get_bd_pins axis_register_slice_61/aclk] [get_bd_pins axis_register_slice_62/aclk] [get_bd_pins axis_register_slice_63/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk] [get_bd_pins debug_bridge_0/clk]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_ports s_axis_aresetn] [get_bd_pins axi4stream_vip_0/aresetn] [get_bd_pins axi4stream_vip_1/aresetn] [get_bd_pins axi4stream_vip_10/aresetn] [get_bd_pins axi4stream_vip_11/aresetn] [get_bd_pins axi4stream_vip_12/aresetn] [get_bd_pins axi4stream_vip_13/aresetn] [get_bd_pins axi4stream_vip_14/aresetn] [get_bd_pins axi4stream_vip_15/aresetn] [get_bd_pins axi4stream_vip_16/aresetn] [get_bd_pins axi4stream_vip_17/aresetn] [get_bd_pins axi4stream_vip_18/aresetn] [get_bd_pins axi4stream_vip_19/aresetn] [get_bd_pins axi4stream_vip_2/aresetn] [get_bd_pins axi4stream_vip_20/aresetn] [get_bd_pins axi4stream_vip_21/aresetn] [get_bd_pins axi4stream_vip_22/aresetn] [get_bd_pins axi4stream_vip_23/aresetn] [get_bd_pins axi4stream_vip_24/aresetn] [get_bd_pins axi4stream_vip_25/aresetn] [get_bd_pins axi4stream_vip_26/aresetn] [get_bd_pins axi4stream_vip_27/aresetn] [get_bd_pins axi4stream_vip_28/aresetn] [get_bd_pins axi4stream_vip_29/aresetn] [get_bd_pins axi4stream_vip_3/aresetn] [get_bd_pins axi4stream_vip_30/aresetn] [get_bd_pins axi4stream_vip_31/aresetn] [get_bd_pins axi4stream_vip_32/aresetn] [get_bd_pins axi4stream_vip_33/aresetn] [get_bd_pins axi4stream_vip_34/aresetn] [get_bd_pins axi4stream_vip_35/aresetn] [get_bd_pins axi4stream_vip_36/aresetn] [get_bd_pins axi4stream_vip_37/aresetn] [get_bd_pins axi4stream_vip_38/aresetn] [get_bd_pins axi4stream_vip_39/aresetn] [get_bd_pins axi4stream_vip_4/aresetn] [get_bd_pins axi4stream_vip_40/aresetn] [get_bd_pins axi4stream_vip_41/aresetn] [get_bd_pins axi4stream_vip_42/aresetn] [get_bd_pins axi4stream_vip_43/aresetn] [get_bd_pins axi4stream_vip_44/aresetn] [get_bd_pins axi4stream_vip_45/aresetn] [get_bd_pins axi4stream_vip_46/aresetn] [get_bd_pins axi4stream_vip_47/aresetn] [get_bd_pins axi4stream_vip_48/aresetn] [get_bd_pins axi4stream_vip_49/aresetn] [get_bd_pins axi4stream_vip_5/aresetn] [get_bd_pins axi4stream_vip_50/aresetn] [get_bd_pins axi4stream_vip_51/aresetn] [get_bd_pins axi4stream_vip_52/aresetn] [get_bd_pins axi4stream_vip_53/aresetn] [get_bd_pins axi4stream_vip_54/aresetn] [get_bd_pins axi4stream_vip_55/aresetn] [get_bd_pins axi4stream_vip_56/aresetn] [get_bd_pins axi4stream_vip_57/aresetn] [get_bd_pins axi4stream_vip_58/aresetn] [get_bd_pins axi4stream_vip_59/aresetn] [get_bd_pins axi4stream_vip_6/aresetn] [get_bd_pins axi4stream_vip_60/aresetn] [get_bd_pins axi4stream_vip_61/aresetn] [get_bd_pins axi4stream_vip_62/aresetn] [get_bd_pins axi4stream_vip_63/aresetn] [get_bd_pins axi4stream_vip_7/aresetn] [get_bd_pins axi4stream_vip_8/aresetn] [get_bd_pins axi4stream_vip_9/aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_32/aresetn] [get_bd_pins axi_register_slice_33/aresetn] [get_bd_pins axi_register_slice_34/aresetn] [get_bd_pins axi_register_slice_35/aresetn] [get_bd_pins axi_register_slice_36/aresetn] [get_bd_pins axi_register_slice_37/aresetn] [get_bd_pins axi_register_slice_38/aresetn] [get_bd_pins axi_register_slice_39/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_40/aresetn] [get_bd_pins axi_register_slice_41/aresetn] [get_bd_pins axi_register_slice_42/aresetn] [get_bd_pins axi_register_slice_43/aresetn] [get_bd_pins axi_register_slice_44/aresetn] [get_bd_pins axi_register_slice_45/aresetn] [get_bd_pins axi_register_slice_46/aresetn] [get_bd_pins axi_register_slice_47/aresetn] [get_bd_pins axi_register_slice_48/aresetn] [get_bd_pins axi_register_slice_49/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_50/aresetn] [get_bd_pins axi_register_slice_51/aresetn] [get_bd_pins axi_register_slice_52/aresetn] [get_bd_pins axi_register_slice_53/aresetn] [get_bd_pins axi_register_slice_54/aresetn] [get_bd_pins axi_register_slice_55/aresetn] [get_bd_pins axi_register_slice_56/aresetn] [get_bd_pins axi_register_slice_57/aresetn] [get_bd_pins axi_register_slice_58/aresetn] [get_bd_pins axi_register_slice_59/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_60/aresetn] [get_bd_pins axi_register_slice_61/aresetn] [get_bd_pins axi_register_slice_62/aresetn] [get_bd_pins axi_register_slice_63/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins axi_vip_10/aresetn] [get_bd_pins axi_vip_11/aresetn] [get_bd_pins axi_vip_12/aresetn] [get_bd_pins axi_vip_13/aresetn] [get_bd_pins axi_vip_14/aresetn] [get_bd_pins axi_vip_15/aresetn] [get_bd_pins axi_vip_16/aresetn] [get_bd_pins axi_vip_17/aresetn] [get_bd_pins axi_vip_18/aresetn] [get_bd_pins axi_vip_19/aresetn] [get_bd_pins axi_vip_2/aresetn] [get_bd_pins axi_vip_20/aresetn] [get_bd_pins axi_vip_21/aresetn] [get_bd_pins axi_vip_22/aresetn] [get_bd_pins axi_vip_23/aresetn] [get_bd_pins axi_vip_24/aresetn] [get_bd_pins axi_vip_25/aresetn] [get_bd_pins axi_vip_26/aresetn] [get_bd_pins axi_vip_27/aresetn] [get_bd_pins axi_vip_28/aresetn] [get_bd_pins axi_vip_29/aresetn] [get_bd_pins axi_vip_3/aresetn] [get_bd_pins axi_vip_30/aresetn] [get_bd_pins axi_vip_31/aresetn] [get_bd_pins axi_vip_32/aresetn] [get_bd_pins axi_vip_33/aresetn] [get_bd_pins axi_vip_34/aresetn] [get_bd_pins axi_vip_35/aresetn] [get_bd_pins axi_vip_36/aresetn] [get_bd_pins axi_vip_37/aresetn] [get_bd_pins axi_vip_38/aresetn] [get_bd_pins axi_vip_39/aresetn] [get_bd_pins axi_vip_4/aresetn] [get_bd_pins axi_vip_40/aresetn] [get_bd_pins axi_vip_41/aresetn] [get_bd_pins axi_vip_42/aresetn] [get_bd_pins axi_vip_43/aresetn] [get_bd_pins axi_vip_44/aresetn] [get_bd_pins axi_vip_45/aresetn] [get_bd_pins axi_vip_46/aresetn] [get_bd_pins axi_vip_47/aresetn] [get_bd_pins axi_vip_48/aresetn] [get_bd_pins axi_vip_49/aresetn] [get_bd_pins axi_vip_5/aresetn] [get_bd_pins axi_vip_50/aresetn] [get_bd_pins axi_vip_51/aresetn] [get_bd_pins axi_vip_52/aresetn] [get_bd_pins axi_vip_53/aresetn] [get_bd_pins axi_vip_54/aresetn] [get_bd_pins axi_vip_55/aresetn] [get_bd_pins axi_vip_56/aresetn] [get_bd_pins axi_vip_57/aresetn] [get_bd_pins axi_vip_58/aresetn] [get_bd_pins axi_vip_59/aresetn] [get_bd_pins axi_vip_6/aresetn] [get_bd_pins axi_vip_60/aresetn] [get_bd_pins axi_vip_61/aresetn] [get_bd_pins axi_vip_62/aresetn] [get_bd_pins axi_vip_63/aresetn] [get_bd_pins axi_vip_7/aresetn] [get_bd_pins axi_vip_8/aresetn] [get_bd_pins axi_vip_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_32/aresetn] [get_bd_pins axis_register_slice_33/aresetn] [get_bd_pins axis_register_slice_34/aresetn] [get_bd_pins axis_register_slice_35/aresetn] [get_bd_pins axis_register_slice_36/aresetn] [get_bd_pins axis_register_slice_37/aresetn] [get_bd_pins axis_register_slice_38/aresetn] [get_bd_pins axis_register_slice_39/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_40/aresetn] [get_bd_pins axis_register_slice_41/aresetn] [get_bd_pins axis_register_slice_42/aresetn] [get_bd_pins axis_register_slice_43/aresetn] [get_bd_pins axis_register_slice_44/aresetn] [get_bd_pins axis_register_slice_45/aresetn] [get_bd_pins axis_register_slice_46/aresetn] [get_bd_pins axis_register_slice_47/aresetn] [get_bd_pins axis_register_slice_48/aresetn] [get_bd_pins axis_register_slice_49/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_50/aresetn] [get_bd_pins axis_register_slice_51/aresetn] [get_bd_pins axis_register_slice_52/aresetn] [get_bd_pins axis_register_slice_53/aresetn] [get_bd_pins axis_register_slice_54/aresetn] [get_bd_pins axis_register_slice_55/aresetn] [get_bd_pins axis_register_slice_56/aresetn] [get_bd_pins axis_register_slice_57/aresetn] [get_bd_pins axis_register_slice_58/aresetn] [get_bd_pins axis_register_slice_59/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_60/aresetn] [get_bd_pins axis_register_slice_61/aresetn] [get_bd_pins axis_register_slice_62/aresetn] [get_bd_pins axis_register_slice_63/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]

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
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_40/Master_AXI] [get_bd_addr_segs M_AXI0_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_41/Master_AXI] [get_bd_addr_segs M_AXI1_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_42/Master_AXI] [get_bd_addr_segs M_AXI2_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_43/Master_AXI] [get_bd_addr_segs M_AXI3_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_45/Master_AXI] [get_bd_addr_segs M_AXI4_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_46/Master_AXI] [get_bd_addr_segs M_AXI5_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_47/Master_AXI] [get_bd_addr_segs M_AXI6_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_48/Master_AXI] [get_bd_addr_segs M_AXI7_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_49/Master_AXI] [get_bd_addr_segs M_AXI8_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_50/Master_AXI] [get_bd_addr_segs M_AXI9_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_51/Master_AXI] [get_bd_addr_segs M_AXI10_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_52/Master_AXI] [get_bd_addr_segs M_AXI11_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_53/Master_AXI] [get_bd_addr_segs M_AXI12_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_54/Master_AXI] [get_bd_addr_segs M_AXI13_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_56/Master_AXI] [get_bd_addr_segs M_AXI14_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_57/Master_AXI] [get_bd_addr_segs M_AXI15_SLR12/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR01] [get_bd_addr_segs axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI10_SLR01] [get_bd_addr_segs axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI11_SLR01] [get_bd_addr_segs axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI12_SLR01] [get_bd_addr_segs axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI13_SLR01] [get_bd_addr_segs axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI14_SLR01] [get_bd_addr_segs axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI15_SLR01] [get_bd_addr_segs axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR01] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR01] [get_bd_addr_segs axi_vip_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR12] [get_bd_addr_segs axi_vip_32/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR12] [get_bd_addr_segs axi_vip_33/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI10_SLR12] [get_bd_addr_segs axi_vip_34/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI11_SLR12] [get_bd_addr_segs axi_vip_35/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI12_SLR12] [get_bd_addr_segs axi_vip_36/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI13_SLR12] [get_bd_addr_segs axi_vip_37/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI14_SLR12] [get_bd_addr_segs axi_vip_38/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI15_SLR12] [get_bd_addr_segs axi_vip_39/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR01] [get_bd_addr_segs axi_vip_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR12] [get_bd_addr_segs axi_vip_44/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI4_SLR01] [get_bd_addr_segs axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR12] [get_bd_addr_segs axi_vip_55/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI4_SLR12] [get_bd_addr_segs axi_vip_58/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI5_SLR12] [get_bd_addr_segs axi_vip_59/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI5_SLR01] [get_bd_addr_segs axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI6_SLR12] [get_bd_addr_segs axi_vip_60/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI7_SLR12] [get_bd_addr_segs axi_vip_61/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI8_SLR12] [get_bd_addr_segs axi_vip_62/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI9_SLR12] [get_bd_addr_segs axi_vip_63/S_AXI/Reg] -force
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


