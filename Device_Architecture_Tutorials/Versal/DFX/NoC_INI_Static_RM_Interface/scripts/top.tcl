
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
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# block design container source references:
# rp1rm1, rp1rm2, rp2rm1, rp2rm2, rp3rm1, rp4rm1

# Please add the sources before sourcing this Tcl script.

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
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:emb_mem_gen:1.0\
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:axi_traffic_gen:3.0\
xilinx.com:ip:axis_noc:1.0\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:dfx_decoupler:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:versal_cips:3.0\
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

##################################################################
# CHECK Block Design Container Sources
##################################################################
set bCheckSources 1
set list_bdc_active "rp1rm1, rp2rm1, rp3rm1, rp4rm1"
set list_bdc_dfx "rp1rm2, rp2rm2"

array set map_bdc_missing {}
set map_bdc_missing(ACTIVE) ""
set map_bdc_missing(DFX) ""
set map_bdc_missing(BDC) ""

if { $bCheckSources == 1 } {
   set list_check_srcs "\ 
rp1rm1 \
rp1rm2 \
rp2rm1 \
rp2rm2 \
rp3rm1 \
rp4rm1 \
"

   common::send_gid_msg -ssname BD::TCL -id 2056 -severity "INFO" "Checking if the following sources for block design container exist in the project: $list_check_srcs .\n\n"

   foreach src $list_check_srcs {
      if { [can_resolve_reference $src] == 0 } {
         if { [lsearch $list_bdc_active $src] != -1 } {
            set map_bdc_missing(ACTIVE) "$map_bdc_missing(ACTIVE) $src"
         } elseif { [lsearch $list_bdc_dfx $src] != -1 } {
            set map_bdc_missing(DFX) "$map_bdc_missing(DFX) $src"
         } else {
            set map_bdc_missing(BDC) "$map_bdc_missing(BDC) $src"
         }
      }
   }

   if { [llength $map_bdc_missing(ACTIVE)] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2057 -severity "ERROR" "The following source(s) of Active variants are not found in the project: $map_bdc_missing(ACTIVE)" }
      common::send_gid_msg -ssname BD::TCL -id 2060 -severity "INFO" "Please add source files for the missing source(s) above."
      set bCheckIPsPassed 0
   }
   if { [llength $map_bdc_missing(DFX)] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2058 -severity "ERROR" "The following source(s) of DFX variants are not found in the project: $map_bdc_missing(DFX)" }
      common::send_gid_msg -ssname BD::TCL -id 2060 -severity "INFO" "Please add source files for the missing source(s) above."
      set bCheckIPsPassed 0
   }
   if { [llength $map_bdc_missing(BDC)] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2059 -severity "WARNING" "The following source(s) of variants are not found in the project: $map_bdc_missing(BDC)" }
      common::send_gid_msg -ssname BD::TCL -id 2060 -severity "INFO" "Please add source files for the missing source(s) above."
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: Static_Region
proc create_hier_cell_Static_Region { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Static_Region() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M00_INI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inis_rtl:1.0 M00_INIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S00_INI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:inis_rtl:1.0 S00_INIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_dimm1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_dimm1_sma_clk

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rp_intf_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rp_intf_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 rp_intf_2


  # Create pins
  create_bd_pin -dir O -type clk clk_out1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 axi_bram_ctrl_0_bram ]
  set_property -dict [ list \
   CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
 ] $axi_bram_ctrl_0_bram

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [ list \
   CONFIG.CH0_DDR4_0_BOARD_INTERFACE {ddr4_dimm1} \
   CONFIG.CONTROLLERTYPE {DDR4_SDRAM} \
   CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
   CONFIG.MC_COMPONENT_WIDTH {x8} \
   CONFIG.MC_DATAWIDTH {64} \
   CONFIG.MC_INPUTCLK0_PERIOD {5000} \
   CONFIG.MC_INTERLEAVE_SIZE {128} \
   CONFIG.MC_MEMORY_DEVICETYPE {UDIMMs} \
   CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
   CONFIG.MC_NO_CHANNELS {Single} \
   CONFIG.MC_RANK {1} \
   CONFIG.MC_ROWADDRESSWIDTH {16} \
   CONFIG.MC_STACKHEIGHT {1} \
   CONFIG.MC_SYSTEM_CLOCK {Differential} \
   CONFIG.NUM_CLKS {7} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {4} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_NMI {1} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {6} \
   CONFIG.sys_clk0_BOARD_INTERFACE {ddr4_dimm1_sma_clk} \
 ] $axi_noc_0

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/M00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x201_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/M01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x203_4000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/M02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.APERTURES {{0x202_C000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/M03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.DEST_IDS {M01_AXI:0x100:M00_AXI:0x40} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M02_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S00_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} MC_0 { read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}} M01_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_INI { read_bw {1720} write_bw {1720}} } \
   CONFIG.DEST_IDS {M03_AXI:0x0:M01_AXI:0x100:M00_AXI:0x40} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI:M01_AXI:M02_AXI:M03_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_0/aclk6]

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1 ]
  set_property -dict [ list \
   CONFIG.MC_NETLIST_SIMULATION {true} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NMI {1} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {1} \
 ] $axi_noc_1

  set_property -dict [ list \
   CONFIG.APERTURES {{0x202_0000_0000 1G}} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_1/M00_INI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.CONNECTIONS {M00_INI { read_bw {1720} write_bw {1720}} } \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /Static_Region/axi_noc_1/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M00_INI { read_bw {0} write_bw {0}} } \
 ] [get_bd_intf_pins /Static_Region/axi_noc_1/S00_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /Static_Region/axi_noc_1/aclk0]

  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [ list \
   CONFIG.C_ATG_MODE_L2 {Static} \
   CONFIG.C_ATG_STATIC_INCR {false} \
   CONFIG.C_ATG_STATIC_RD_ADDRESS {0x80000000} \
   CONFIG.C_ATG_STATIC_RD_ADDRESS_EXT {0x00000201} \
   CONFIG.C_ATG_STATIC_WR_ADDRESS {0x80000000} \
   CONFIG.C_ATG_STATIC_WR_ADDRESS_EXT {0x00000201} \
   CONFIG.C_EXTENDED_ADDRESS_WIDTH {64} \
 ] $axi_traffic_gen_0

  # Create instance: axis_noc_1, and set properties
  set axis_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_noc:1.0 axis_noc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {0} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NMI {1} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {0} \
 ] $axis_noc_1

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {auto} \
 ] [get_bd_intf_pins /Static_Region/axis_noc_1/M00_INIS]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {auto} \
   CONFIG.CONNECTIONS {M00_INIS { write_bw {5}} } \
 ] [get_bd_intf_pins /Static_Region/axis_noc_1/S00_INIS]

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [ list \
   CONFIG.USE_LOCKED {true} \
 ] $clk_wizard_0

  # Create instance: dfx_decoupler_0, and set properties
  set dfx_decoupler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_decoupler:1.0 dfx_decoupler_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PARAMS {HAS_AXI_LITE 1 HAS_SIGNAL_CONTROL 0 HAS_SIGNAL_STATUS 0 INTF {intf_0 {ID 0 VLNV\
xilinx.com:interface:aximm_rtl:1.0 MODE slave SIGNALS {ARVALID {PRESENT 1 WIDTH\
1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1\
WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT\
1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY\
{PRESENT 1 WIDTH 1} AWID {PRESENT 0 WIDTH 0} AWADDR {PRESENT 1 WIDTH 42} AWLEN\
{PRESENT 1 WIDTH 8} AWSIZE {PRESENT 1 WIDTH 3} AWBURST {PRESENT 1 WIDTH 2}\
AWLOCK {PRESENT 1 WIDTH 1} AWCACHE {PRESENT 1 WIDTH 4} AWPROT {PRESENT 1 WIDTH\
3} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0\
WIDTH 0} WID {PRESENT 0 WIDTH 0} WDATA {PRESENT 1 WIDTH 32} WSTRB {PRESENT 1\
WIDTH 4} WLAST {PRESENT 1 WIDTH 1} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 0\
WIDTH 0} BRESP {PRESENT 1 WIDTH 2} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 0\
WIDTH 0} ARADDR {PRESENT 1 WIDTH 42} ARLEN {PRESENT 1 WIDTH 8} ARSIZE {PRESENT\
1 WIDTH 3} ARBURST {PRESENT 1 WIDTH 2} ARLOCK {PRESENT 1 WIDTH 1} ARCACHE\
{PRESENT 1 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} ARREGION {PRESENT 1 WIDTH 4}\
ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 0 WIDTH 0}\
RDATA {PRESENT 1 WIDTH 32} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 1 WIDTH 1}\
RUSER {PRESENT 0 WIDTH 0}}}} IPI_PROP_COUNT 1}\
   CONFIG.GUI_HAS_AXI_LITE {true} \
   CONFIG.GUI_HAS_SIGNAL_CONTROL {false} \
   CONFIG.GUI_HAS_SIGNAL_STATUS {false} \
   CONFIG.GUI_INTERFACE_NAME {intf_0} \
   CONFIG.GUI_INTERFACE_PROTOCOL {axi4} \
   CONFIG.GUI_SELECT_INTERFACE {0} \
   CONFIG.GUI_SELECT_MODE {slave} \
   CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.GUI_SIGNAL_DECOUPLED_0 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_2 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_3 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_4 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_5 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_6 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_7 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_8 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_9 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_0 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_1 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_2 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_3 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_4 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_5 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_6 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_7 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_8 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_9 {true} \
   CONFIG.GUI_SIGNAL_SELECT_0 {ARVALID} \
   CONFIG.GUI_SIGNAL_SELECT_1 {ARREADY} \
   CONFIG.GUI_SIGNAL_SELECT_2 {AWVALID} \
   CONFIG.GUI_SIGNAL_SELECT_3 {AWREADY} \
   CONFIG.GUI_SIGNAL_SELECT_4 {BVALID} \
   CONFIG.GUI_SIGNAL_SELECT_5 {BREADY} \
   CONFIG.GUI_SIGNAL_SELECT_6 {RVALID} \
   CONFIG.GUI_SIGNAL_SELECT_7 {RREADY} \
   CONFIG.GUI_SIGNAL_SELECT_8 {WVALID} \
   CONFIG.GUI_SIGNAL_SELECT_9 {WREADY} \
 ] $dfx_decoupler_0

  # Create instance: dfx_decoupler_1, and set properties
  set dfx_decoupler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_decoupler:1.0 dfx_decoupler_1 ]
  set_property -dict [ list \
   CONFIG.ALL_PARAMS {HAS_AXI_LITE 1 HAS_SIGNAL_CONTROL 0 HAS_SIGNAL_STATUS 0 INTF {intf_0 {ID 0 VLNV\
xilinx.com:interface:aximm_rtl:1.0 MODE slave SIGNALS {ARVALID {PRESENT 1 WIDTH\
1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1\
WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT\
1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY\
{PRESENT 1 WIDTH 1} AWID {PRESENT 0 WIDTH 0} AWADDR {PRESENT 1 WIDTH 42} AWLEN\
{PRESENT 1 WIDTH 8} AWSIZE {PRESENT 1 WIDTH 3} AWBURST {PRESENT 1 WIDTH 2}\
AWLOCK {PRESENT 1 WIDTH 1} AWCACHE {PRESENT 1 WIDTH 4} AWPROT {PRESENT 1 WIDTH\
3} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0\
WIDTH 0} WID {PRESENT 0 WIDTH 0} WDATA {PRESENT 1 WIDTH 32} WSTRB {PRESENT 1\
WIDTH 4} WLAST {PRESENT 1 WIDTH 1} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 0\
WIDTH 0} BRESP {PRESENT 1 WIDTH 2} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 0\
WIDTH 0} ARADDR {PRESENT 1 WIDTH 42} ARLEN {PRESENT 1 WIDTH 8} ARSIZE {PRESENT\
1 WIDTH 3} ARBURST {PRESENT 1 WIDTH 2} ARLOCK {PRESENT 1 WIDTH 1} ARCACHE\
{PRESENT 1 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} ARREGION {PRESENT 1 WIDTH 4}\
ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 0 WIDTH 0}\
RDATA {PRESENT 1 WIDTH 32} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 1 WIDTH 1}\
RUSER {PRESENT 0 WIDTH 0}}} intf_1 {ID 1 VLNV\
xilinx.com:interface:aximm_rtl:1.0 MODE slave SIGNALS {ARVALID {PRESENT 1 WIDTH\
1} ARREADY {PRESENT 1 WIDTH 1} AWVALID {PRESENT 1 WIDTH 1} AWREADY {PRESENT 1\
WIDTH 1} BVALID {PRESENT 1 WIDTH 1} BREADY {PRESENT 1 WIDTH 1} RVALID {PRESENT\
1 WIDTH 1} RREADY {PRESENT 1 WIDTH 1} WVALID {PRESENT 1 WIDTH 1} WREADY\
{PRESENT 1 WIDTH 1} AWID {PRESENT 0 WIDTH 0} AWADDR {PRESENT 1 WIDTH 42} AWLEN\
{PRESENT 0 WIDTH 8} AWSIZE {PRESENT 0 WIDTH 3} AWBURST {PRESENT 0 WIDTH 2}\
AWLOCK {PRESENT 0 WIDTH 1} AWCACHE {PRESENT 0 WIDTH 4} AWPROT {PRESENT 1 WIDTH\
3} AWREGION {PRESENT 1 WIDTH 4} AWQOS {PRESENT 1 WIDTH 4} AWUSER {PRESENT 0\
WIDTH 0} WID {PRESENT 0 WIDTH 0} WDATA {PRESENT 1 WIDTH 32} WSTRB {PRESENT 1\
WIDTH 4} WLAST {PRESENT 0 WIDTH 1} WUSER {PRESENT 0 WIDTH 0} BID {PRESENT 0\
WIDTH 0} BRESP {PRESENT 1 WIDTH 2} BUSER {PRESENT 0 WIDTH 0} ARID {PRESENT 0\
WIDTH 0} ARADDR {PRESENT 1 WIDTH 42} ARLEN {PRESENT 0 WIDTH 8} ARSIZE {PRESENT\
0 WIDTH 3} ARBURST {PRESENT 0 WIDTH 2} ARLOCK {PRESENT 0 WIDTH 1} ARCACHE\
{PRESENT 0 WIDTH 4} ARPROT {PRESENT 1 WIDTH 3} ARREGION {PRESENT 1 WIDTH 4}\
ARQOS {PRESENT 1 WIDTH 4} ARUSER {PRESENT 0 WIDTH 0} RID {PRESENT 0 WIDTH 0}\
RDATA {PRESENT 1 WIDTH 32} RRESP {PRESENT 1 WIDTH 2} RLAST {PRESENT 0 WIDTH 1}\
RUSER {PRESENT 0 WIDTH 0}} PROTOCOL axi4lite}} IPI_PROP_COUNT 4}\
   CONFIG.GUI_HAS_AXI_LITE {true} \
   CONFIG.GUI_HAS_SIGNAL_CONTROL {false} \
   CONFIG.GUI_HAS_SIGNAL_STATUS {false} \
   CONFIG.GUI_INTERFACE_NAME {intf_0} \
   CONFIG.GUI_INTERFACE_PROTOCOL {axi4} \
   CONFIG.GUI_SELECT_INTERFACE {0} \
   CONFIG.GUI_SELECT_MODE {slave} \
   CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:aximm_rtl:1.0} \
   CONFIG.GUI_SIGNAL_DECOUPLED_0 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_2 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_3 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_4 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_5 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_6 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_7 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_8 {true} \
   CONFIG.GUI_SIGNAL_DECOUPLED_9 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_0 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_1 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_2 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_3 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_4 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_5 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_6 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_7 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_8 {true} \
   CONFIG.GUI_SIGNAL_PRESENT_9 {true} \
   CONFIG.GUI_SIGNAL_SELECT_0 {ARVALID} \
   CONFIG.GUI_SIGNAL_SELECT_1 {ARREADY} \
   CONFIG.GUI_SIGNAL_SELECT_2 {AWVALID} \
   CONFIG.GUI_SIGNAL_SELECT_3 {AWREADY} \
   CONFIG.GUI_SIGNAL_SELECT_4 {BVALID} \
   CONFIG.GUI_SIGNAL_SELECT_5 {BREADY} \
   CONFIG.GUI_SIGNAL_SELECT_6 {RVALID} \
   CONFIG.GUI_SIGNAL_SELECT_7 {RREADY} \
   CONFIG.GUI_SIGNAL_SELECT_8 {WVALID} \
   CONFIG.GUI_SIGNAL_SELECT_9 {WREADY} \
 ] $dfx_decoupler_1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $smartconnect_1

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.0 versal_cips_0 ]
  set_property -dict [ list \
   CONFIG.DDR_MEMORY_MODE {Enable} \
   CONFIG.DEBUG_MODE {JTAG} \
   CONFIG.DESIGN_MODE {1} \
   CONFIG.PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
   CONFIG.PS_PMC_CONFIG {PS_USE_PMCPL_CLK0 1 PS_NUM_FABRIC_RESETS 1 DDR_MEMORY_MODE {Connectivity to DDR\
via NOC} DEBUG_MODE JTAG PMC_USE_PMC_NOC_AXI0 1 PS_HSDP_EGRESS_TRAFFIC JTAG\
PS_HSDP_INGRESS_TRAFFIC JTAG PS_HSDP_MODE None PS_USE_FPD_CCI_NOC 1\
PS_USE_FPD_CCI_NOC0 1 PS_USE_NOC_LPD_AXI0 1 PS_MIO7 {{AUX_IO 0} {DIRECTION in}\
{DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW\
slow} {USAGE Reserved}} PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA}\
{OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}}\
PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default}\
{PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} PS_MIO21 {{AUX_IO 0}\
{DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable}\
{SCHMITT 0} {SLEW slow} {USAGE Reserved}} PMC_MIO37 {{AUX_IO 0} {DIRECTION out}\
{DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow}\
{USAGE GPIO}} PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1}\
{POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 1}} {WP_ENABLE 0}\
{WP_IO {PMC_MIO 1}}} PMC_SD1_COHERENCY 0 PMC_SD1_DATA_TRANSFER_MODE 8Bit\
PMC_SD1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 36}}} PMC_SD1_SLOT_TYPE {SD\
3.0} PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}}\
PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}}\
PMC_I2CPMC_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} PMC_OSPI_PERIPHERAL\
{{ENABLE 0} {IO {PMC_MIO 0 .. 11}} {MODE Single}} PMC_QSPI_COHERENCY 0\
PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} PMC_QSPI_PERIPHERAL_DATA_MODE x4\
PMC_QSPI_PERIPHERAL_ENABLE 1 PMC_QSPI_PERIPHERAL_MODE {Dual Parallel}\
PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 40 .. 41}}} PS_ENET0_MDIO {{ENABLE\
1} {IO {PS_MIO 24 .. 25}}} PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 ..\
11}}} PS_ENET1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 12 .. 23}}}\
PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} PS_UART0_PERIPHERAL\
{{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} PS_USB3_PERIPHERAL {{ENABLE 1} {IO\
{PMC_MIO 13 .. 25}}} PMC_REF_CLK_FREQMHZ 33.3333 PS_GEN_IPI0_ENABLE 1\
PS_GEN_IPI0_MASTER A72 PS_GEN_IPI1_ENABLE 1 PS_GEN_IPI2_ENABLE 1\
PS_GEN_IPI3_ENABLE 1 PS_GEN_IPI4_ENABLE 1 PS_GEN_IPI5_ENABLE 1\
PS_GEN_IPI6_ENABLE 1 PS_PCIE_RESET {{ENABLE 1} {IO {PMC_MIO 38 .. 39}}}\
PS_BOARD_INTERFACE ps_pmc_fixed_io SMON_ALARMS Set_Alarms_On\
SMON_ENABLE_TEMP_AVERAGING 0 SMON_TEMP_AVERAGING_SAMPLES 8 DESIGN_MODE 1\
PS_PCIE1_PERIPHERAL_ENABLE 0 PS_PCIE2_PERIPHERAL_ENABLE 0\
PCIE_APERTURES_SINGLE_ENABLE 0 PCIE_APERTURES_DUAL_ENABLE 0}\
 ] $versal_cips_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins rp_intf_0] [get_bd_intf_pins dfx_decoupler_0/rp_intf_0]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins ddr4_dimm1] [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins rp_intf_1] [get_bd_intf_pins dfx_decoupler_1/rp_intf_0]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S00_INIS] [get_bd_intf_pins axis_noc_1/S00_INIS]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M00_INIS] [get_bd_intf_pins axis_noc_1/M00_INIS]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins ddr4_dimm1_sma_clk] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net S00_INI1_1 [get_bd_intf_pins S00_INI1] [get_bd_intf_pins axi_noc_0/S00_INI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_noc_0_M00_AXI [get_bd_intf_pins axi_noc_0/M00_AXI] [get_bd_intf_pins axi_traffic_gen_0/S_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M00_INI [get_bd_intf_pins axi_noc_0/M00_INI] [get_bd_intf_pins axi_noc_1/S00_INI]
  connect_bd_intf_net -intf_net axi_noc_0_M01_AXI [get_bd_intf_pins axi_noc_0/M01_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M02_AXI [get_bd_intf_pins axi_noc_0/M02_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net axi_noc_0_M03_AXI [get_bd_intf_pins axi_noc_0/M03_AXI] [get_bd_intf_pins smartconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net axi_noc_1_M00_INI [get_bd_intf_pins M00_INI] [get_bd_intf_pins axi_noc_1/M00_INI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins axi_noc_1/S00_AXI] [get_bd_intf_pins axi_traffic_gen_0/M_AXI]
  connect_bd_intf_net -intf_net dfx_decoupler_1_rp_intf_1 [get_bd_intf_pins rp_intf_2] [get_bd_intf_pins dfx_decoupler_1/rp_intf_1]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins dfx_decoupler_0/s_intf_0] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins dfx_decoupler_0/s_axi_reg] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins dfx_decoupler_1/s_intf_0] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins dfx_decoupler_1/s_axi_reg] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins dfx_decoupler_1/s_intf_1] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0]

  # Create port connections
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_out1] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_noc_0/aclk6] [get_bd_pins axi_noc_1/aclk0] [get_bd_pins axi_traffic_gen_0/s_axi_aclk] [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins dfx_decoupler_0/aclk] [get_bd_pins dfx_decoupler_0/intf_0_aclk] [get_bd_pins dfx_decoupler_1/aclk] [get_bd_pins dfx_decoupler_1/intf_0_aclk] [get_bd_pins dfx_decoupler_1/intf_1_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net clk_wizard_0_locked [get_bd_pins clk_wizard_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] [get_bd_pins dfx_decoupler_0/intf_0_arstn] [get_bd_pins dfx_decoupler_0/s_axi_reg_aresetn] [get_bd_pins dfx_decoupler_1/intf_0_arstn] [get_bd_pins dfx_decoupler_1/intf_1_arstn] [get_bd_pins dfx_decoupler_1/s_axi_reg_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins axi_noc_0/aclk0] [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins axi_noc_0/aclk1] [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins axi_noc_0/aclk2] [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins axi_noc_0/aclk3] [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins axi_noc_0/aclk4] [get_bd_pins versal_cips_0/lpd_axi_noc_clk]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins clk_wizard_0/clk_in1] [get_bd_pins versal_cips_0/pl0_ref_clk]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins versal_cips_0/pl0_resetn]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk5] [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set ddr4_dimm1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_dimm1 ]

  set ddr4_dimm1_sma_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_dimm1_sma_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $ddr4_dimm1_sma_clk


  # Create ports

  # Create instance: RP1, and set properties
  set RP1 [ create_bd_cell -type container -reference rp1rm1 RP1 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp1rm1.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp1rm1.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp1rm1.bd:rp1rm2.bd} \
   CONFIG.LIST_SYNTH_BD {rp1rm1.bd:rp1rm2.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $RP1

  # Create instance: RP2, and set properties
  set RP2 [ create_bd_cell -type container -reference rp2rm1 RP2 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp2rm1.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp2rm1.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp2rm1.bd:rp2rm2.bd} \
   CONFIG.LIST_SYNTH_BD {rp2rm1.bd:rp2rm2.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $RP2

  # Create instance: RP3, and set properties
  set RP3 [ create_bd_cell -type container -reference rp3rm1 RP3 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp3rm1.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp3rm1.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp3rm1.bd} \
   CONFIG.LIST_SYNTH_BD {rp3rm1.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $RP3

  # Create instance: RP4, and set properties
  set RP4 [ create_bd_cell -type container -reference rp4rm1 RP4 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp4rm1.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp4rm1.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp4rm1.bd} \
   CONFIG.LIST_SYNTH_BD {rp4rm1.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $RP4

  # Create instance: Static_Region
  create_hier_cell_Static_Region [current_bd_instance .] Static_Region

  # Create interface connections
  connect_bd_intf_net -intf_net RP2_M00_INI [get_bd_intf_pins RP2/M00_INI] [get_bd_intf_pins Static_Region/S00_INI1]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins RP2/S_AXI] [get_bd_intf_pins Static_Region/rp_intf_0]
  connect_bd_intf_net -intf_net Static_Region_M00_INIS [get_bd_intf_pins RP4/S00_INIS] [get_bd_intf_pins Static_Region/M00_INIS]
  connect_bd_intf_net -intf_net Static_Region_ddr4_dimm1 [get_bd_intf_ports ddr4_dimm1] [get_bd_intf_pins Static_Region/ddr4_dimm1]
  connect_bd_intf_net -intf_net Static_Region_rp_intf_1 [get_bd_intf_pins RP3/S_AXI] [get_bd_intf_pins Static_Region/rp_intf_1]
  connect_bd_intf_net -intf_net Static_Region_rp_intf_2 [get_bd_intf_pins RP4/S_AXI] [get_bd_intf_pins Static_Region/rp_intf_2]
  connect_bd_intf_net -intf_net axi_noc_1_M00_INI [get_bd_intf_pins RP1/S00_INI] [get_bd_intf_pins Static_Region/M00_INI]
  connect_bd_intf_net -intf_net axis_noc_0_M00_INIS [get_bd_intf_pins RP3/M00_INIS] [get_bd_intf_pins Static_Region/S00_INIS]
  connect_bd_intf_net -intf_net ddr4_dimm1_sma_clk_1 [get_bd_intf_ports ddr4_dimm1_sma_clk] [get_bd_intf_pins Static_Region/ddr4_dimm1_sma_clk]

  # Create port connections
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins RP1/aclk0] [get_bd_pins RP2/aclk0] [get_bd_pins RP3/aclk0] [get_bd_pins RP4/aclk0] [get_bd_pins Static_Region/clk_out1]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins RP1/s_axi_aresetn] [get_bd_pins RP2/s_axi_aresetn] [get_bd_pins RP3/s_axi_aresetn] [get_bd_pins RP4/s_axi_aresetn] [get_bd_pins Static_Region/peripheral_aresetn]

  # Create address segments
  assign_bd_address -offset 0x020340000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces RP2/axi_traffic_gen_0/Data] [get_bd_addr_segs Static_Region/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020180000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces Static_Region/axi_traffic_gen_0/Data] [get_bd_addr_segs RP1/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020180000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs RP1/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020140030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs RP4/axi_fifo_mm_s_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x020140030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs RP4/axi_fifo_mm_s_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs Static_Region/axi_noc_0/S05_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs Static_Region/axi_noc_0/S00_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs Static_Region/axi_noc_0/S04_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs Static_Region/axi_noc_0/S00_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs Static_Region/axi_noc_0/S05_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs Static_Region/axi_noc_0/S04_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs Static_Region/axi_noc_0/S01_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs Static_Region/axi_noc_0/S01_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs Static_Region/axi_noc_0/S02_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs Static_Region/axi_noc_0/S02_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs Static_Region/axi_noc_0/S03_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs Static_Region/axi_noc_0/S03_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x020140000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs RP3/axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x020140000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs RP3/axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs Static_Region/axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x020100000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs Static_Region/axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x020140010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs Static_Region/dfx_decoupler_0/s_axi_reg/Reg] -force
  assign_bd_address -offset 0x020140010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs Static_Region/dfx_decoupler_0/s_axi_reg/Reg] -force
  assign_bd_address -offset 0x020140020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs Static_Region/dfx_decoupler_1/s_axi_reg/Reg] -force
  assign_bd_address -offset 0x020140020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs Static_Region/dfx_decoupler_1/s_axi_reg/Reg] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs RP2/axi_traffic_gen_0/S_AXI/Reg0]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs Static_Region/axi_bram_ctrl_0/S_AXI/Mem0]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces Static_Region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs RP2/axi_traffic_gen_0/S_AXI/Reg0]


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


