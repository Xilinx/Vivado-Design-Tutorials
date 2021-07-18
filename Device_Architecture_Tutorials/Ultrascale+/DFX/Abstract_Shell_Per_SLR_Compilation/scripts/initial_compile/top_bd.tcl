
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
# rp_slr0, rp_slr1, rp_slr2, rp_slr3

# Please add the sources before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu13p-fhga2104-3-e
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
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:debug_bridge:3.0\
xilinx.com:ip:proc_sys_reset:5.0\
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
set list_bdc_active "rp_slr0, rp_slr1, rp_slr2, rp_slr3"

array set map_bdc_missing {}
set map_bdc_missing(ACTIVE) ""
set map_bdc_missing(BDC) ""

if { $bCheckSources == 1 } {
   set list_check_srcs "\ 
rp_slr0 \
rp_slr1 \
rp_slr2 \
rp_slr3 \
"

   common::send_gid_msg -ssname BD::TCL -id 2056 -severity "INFO" "Checking if the following sources for block design container exist in the project: $list_check_srcs .\n\n"

   foreach src $list_check_srcs {
      if { [can_resolve_reference $src] == 0 } {
         if { [lsearch $list_bdc_active $src] != -1 } {
            set map_bdc_missing(ACTIVE) "$map_bdc_missing(ACTIVE) $src"
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


# Hierarchical cell: static_region
proc create_hier_cell_static_region { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_static_region() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:bscan_rtl:1.0 m0_bscan

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:bscan_rtl:1.0 m1_bscan

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:bscan_rtl:1.0 m2_bscan

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:bscan_rtl:1.0 m3_bscan


  # Create pins
  create_bd_pin -dir I -type clk clk_in1_0
  create_bd_pin -dir I -type rst ext_reset_in_0
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn2
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn3
  create_bd_pin -dir O -type clk slowest_sync_clk

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {98.427} \
   CONFIG.CLKOUT1_PHASE_ERROR {87.466} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {11.875} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.750} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: debug_bridge_0, and set properties
  set debug_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_0 ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_MODE {7} \
   CONFIG.C_DESIGN_TYPE {0} \
   CONFIG.C_NUM_BS_MASTER {4} \
 ] $debug_bridge_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]

  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m1_bscan] [get_bd_intf_pins debug_bridge_0/m1_bscan]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m3_bscan] [get_bd_intf_pins debug_bridge_0/m3_bscan]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins m0_bscan] [get_bd_intf_pins debug_bridge_0/m0_bscan]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins m2_bscan] [get_bd_intf_pins debug_bridge_0/m2_bscan]

  # Create port connections
  connect_bd_net -net clk_in1_0_1 [get_bd_pins clk_in1_0] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins slowest_sync_clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins proc_sys_reset_2/slowest_sync_clk] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_3/dcm_locked]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_pins ext_reset_in_0] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins peripheral_aresetn1] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_2_peripheral_aresetn [get_bd_pins peripheral_aresetn2] [get_bd_pins proc_sys_reset_2/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_3_peripheral_aresetn [get_bd_pins peripheral_aresetn3] [get_bd_pins proc_sys_reset_3/peripheral_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slr3_to_2_crossing
proc create_hier_cell_slr3_to_2_crossing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_slr3_to_2_crossing() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI15

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS15


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_3

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_4

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_5

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_6

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_7

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_8

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_9

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_10

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_11

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_12

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_13

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_14

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_15

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_16

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_17

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_18

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_19

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_20

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_21

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_22

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_23

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_24

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_25

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_26

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_27

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_28

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_29

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_30

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_31

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins axi_register_slice_16/S_AXI]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins S_AXI9] [get_bd_intf_pins axi_register_slice_18/S_AXI]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins S_AXI10] [get_bd_intf_pins axi_register_slice_20/S_AXI]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins S_AXI11] [get_bd_intf_pins axi_register_slice_22/S_AXI]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins S_AXI12] [get_bd_intf_pins axi_register_slice_24/S_AXI]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins S_AXI13] [get_bd_intf_pins axi_register_slice_26/S_AXI]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins S_AXI14] [get_bd_intf_pins axi_register_slice_28/S_AXI]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins axi_register_slice_30/S_AXI]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins S_AXIS3] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins S_AXIS4] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins S_AXIS5] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins S_AXIS6] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins S_AXIS7] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net Conn25 [get_bd_intf_pins S_AXIS8] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net Conn26 [get_bd_intf_pins S_AXIS9] [get_bd_intf_pins axis_register_slice_18/S_AXIS]
  connect_bd_intf_net -intf_net Conn27 [get_bd_intf_pins S_AXIS10] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net Conn28 [get_bd_intf_pins S_AXIS11] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net Conn29 [get_bd_intf_pins S_AXIS12] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net Conn30 [get_bd_intf_pins S_AXIS13] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net Conn31 [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net Conn32 [get_bd_intf_pins S_AXIS14] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net Conn33 [get_bd_intf_pins S_AXIS15] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net Conn34 [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net Conn35 [get_bd_intf_pins M_AXIS3] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net Conn36 [get_bd_intf_pins M_AXIS4] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net Conn37 [get_bd_intf_pins M_AXIS5] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net Conn38 [get_bd_intf_pins M_AXIS6] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net Conn39 [get_bd_intf_pins M_AXIS7] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net Conn40 [get_bd_intf_pins M_AXIS8] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net Conn41 [get_bd_intf_pins M_AXIS9] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net Conn42 [get_bd_intf_pins M_AXIS10] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net Conn43 [get_bd_intf_pins M_AXIS11] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net Conn44 [get_bd_intf_pins M_AXIS12] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net Conn45 [get_bd_intf_pins M_AXIS13] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net Conn46 [get_bd_intf_pins M_AXIS14] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net Conn47 [get_bd_intf_pins M_AXIS15] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net S_AXI14_1 [get_bd_intf_pins M_AXI14] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI1 [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI2 [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI3 [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI4 [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI5 [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI6 [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI7 [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI8 [get_bd_intf_pins axi_register_slice_16/M_AXI] [get_bd_intf_pins axi_register_slice_17/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI9 [get_bd_intf_pins axi_register_slice_18/M_AXI] [get_bd_intf_pins axi_register_slice_19/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI10 [get_bd_intf_pins axi_register_slice_20/M_AXI] [get_bd_intf_pins axi_register_slice_21/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI11 [get_bd_intf_pins axi_register_slice_22/M_AXI] [get_bd_intf_pins axi_register_slice_23/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI12 [get_bd_intf_pins axi_register_slice_24/M_AXI] [get_bd_intf_pins axi_register_slice_25/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI13 [get_bd_intf_pins axi_register_slice_26/M_AXI] [get_bd_intf_pins axi_register_slice_27/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI14 [get_bd_intf_pins axi_register_slice_28/M_AXI] [get_bd_intf_pins axi_register_slice_29/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI15 [get_bd_intf_pins axi_register_slice_30/M_AXI] [get_bd_intf_pins axi_register_slice_31/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI1 [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI2 [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI3 [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI4 [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI5 [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI6 [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_13/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI7 [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_15/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI8 [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI9 [get_bd_intf_pins M_AXI9] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI10 [get_bd_intf_pins M_AXI10] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI11 [get_bd_intf_pins M_AXI11] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI12 [get_bd_intf_pins M_AXI12] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI13 [get_bd_intf_pins M_AXI13] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_pins M_AXI15] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS1 [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS2 [get_bd_intf_pins axis_register_slice_4/M_AXIS] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS3 [get_bd_intf_pins axis_register_slice_6/M_AXIS] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS4 [get_bd_intf_pins axis_register_slice_8/M_AXIS] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS5 [get_bd_intf_pins axis_register_slice_10/M_AXIS] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS6 [get_bd_intf_pins axis_register_slice_12/M_AXIS] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS7 [get_bd_intf_pins axis_register_slice_14/M_AXIS] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS8 [get_bd_intf_pins axis_register_slice_16/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS9 [get_bd_intf_pins axis_register_slice_18/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS10 [get_bd_intf_pins axis_register_slice_20/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS11 [get_bd_intf_pins axis_register_slice_22/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS12 [get_bd_intf_pins axis_register_slice_24/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS13 [get_bd_intf_pins axis_register_slice_26/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS14 [get_bd_intf_pins axis_register_slice_28/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS15 [get_bd_intf_pins axis_register_slice_30/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slr2_to_3_crossing
proc create_hier_cell_slr2_to_3_crossing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_slr2_to_3_crossing() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI15

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS15


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_3

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_4

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_5

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_6

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_7

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_8

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_9

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_10

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_11

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_12

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_13

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_14

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_15

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_16

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_17

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_18

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_19

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_20

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_21

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_22

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_23

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_24

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_25

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_26

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_27

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_28

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_29

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_30

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_31

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins axi_register_slice_16/S_AXI]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins S_AXI9] [get_bd_intf_pins axi_register_slice_18/S_AXI]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins S_AXI10] [get_bd_intf_pins axi_register_slice_20/S_AXI]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins S_AXI11] [get_bd_intf_pins axi_register_slice_22/S_AXI]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins S_AXI12] [get_bd_intf_pins axi_register_slice_24/S_AXI]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins S_AXI13] [get_bd_intf_pins axi_register_slice_26/S_AXI]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins S_AXI14] [get_bd_intf_pins axi_register_slice_28/S_AXI]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins axi_register_slice_30/S_AXI]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins S_AXIS3] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins S_AXIS4] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins S_AXIS5] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins S_AXIS6] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins S_AXIS7] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net Conn25 [get_bd_intf_pins S_AXIS8] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net Conn26 [get_bd_intf_pins S_AXIS9] [get_bd_intf_pins axis_register_slice_18/S_AXIS]
  connect_bd_intf_net -intf_net Conn27 [get_bd_intf_pins S_AXIS10] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net Conn28 [get_bd_intf_pins S_AXIS11] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net Conn29 [get_bd_intf_pins S_AXIS12] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net Conn30 [get_bd_intf_pins S_AXIS13] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net Conn31 [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net Conn32 [get_bd_intf_pins S_AXIS14] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net Conn33 [get_bd_intf_pins S_AXIS15] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net Conn34 [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net Conn35 [get_bd_intf_pins M_AXIS3] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net Conn36 [get_bd_intf_pins M_AXIS4] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net Conn37 [get_bd_intf_pins M_AXIS5] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net Conn38 [get_bd_intf_pins M_AXIS6] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net Conn39 [get_bd_intf_pins M_AXIS7] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net Conn40 [get_bd_intf_pins M_AXIS8] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net Conn41 [get_bd_intf_pins M_AXIS9] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net Conn42 [get_bd_intf_pins M_AXIS10] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net Conn43 [get_bd_intf_pins M_AXIS11] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net Conn44 [get_bd_intf_pins M_AXIS12] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net Conn45 [get_bd_intf_pins M_AXIS13] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net Conn46 [get_bd_intf_pins M_AXIS14] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net Conn47 [get_bd_intf_pins M_AXIS15] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net S_AXI14_1 [get_bd_intf_pins M_AXI14] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI1 [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI2 [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI3 [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI4 [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI5 [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI6 [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI7 [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI8 [get_bd_intf_pins axi_register_slice_16/M_AXI] [get_bd_intf_pins axi_register_slice_17/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI9 [get_bd_intf_pins axi_register_slice_18/M_AXI] [get_bd_intf_pins axi_register_slice_19/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI10 [get_bd_intf_pins axi_register_slice_20/M_AXI] [get_bd_intf_pins axi_register_slice_21/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI11 [get_bd_intf_pins axi_register_slice_22/M_AXI] [get_bd_intf_pins axi_register_slice_23/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI12 [get_bd_intf_pins axi_register_slice_24/M_AXI] [get_bd_intf_pins axi_register_slice_25/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI13 [get_bd_intf_pins axi_register_slice_26/M_AXI] [get_bd_intf_pins axi_register_slice_27/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI14 [get_bd_intf_pins axi_register_slice_28/M_AXI] [get_bd_intf_pins axi_register_slice_29/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI15 [get_bd_intf_pins axi_register_slice_30/M_AXI] [get_bd_intf_pins axi_register_slice_31/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI1 [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI2 [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI3 [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI4 [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI5 [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI6 [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_13/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI7 [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_15/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI8 [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI9 [get_bd_intf_pins M_AXI9] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI10 [get_bd_intf_pins M_AXI10] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI11 [get_bd_intf_pins M_AXI11] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI12 [get_bd_intf_pins M_AXI12] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI13 [get_bd_intf_pins M_AXI13] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_pins M_AXI15] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS1 [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS2 [get_bd_intf_pins axis_register_slice_4/M_AXIS] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS3 [get_bd_intf_pins axis_register_slice_6/M_AXIS] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS4 [get_bd_intf_pins axis_register_slice_8/M_AXIS] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS5 [get_bd_intf_pins axis_register_slice_10/M_AXIS] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS6 [get_bd_intf_pins axis_register_slice_12/M_AXIS] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS7 [get_bd_intf_pins axis_register_slice_14/M_AXIS] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS8 [get_bd_intf_pins axis_register_slice_16/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS9 [get_bd_intf_pins axis_register_slice_18/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS10 [get_bd_intf_pins axis_register_slice_20/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS11 [get_bd_intf_pins axis_register_slice_22/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS12 [get_bd_intf_pins axis_register_slice_24/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS13 [get_bd_intf_pins axis_register_slice_26/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS14 [get_bd_intf_pins axis_register_slice_28/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS15 [get_bd_intf_pins axis_register_slice_30/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slr2_to_1_crossing
proc create_hier_cell_slr2_to_1_crossing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_slr2_to_1_crossing() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI15

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS15


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_3

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_4

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_5

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_6

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_7

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_8

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_9

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_10

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_11

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_12

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_13

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_14

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_15

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_16

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_17

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_18

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_19

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_20

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_21

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_22

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_23

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_24

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_25

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_26

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_27

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_28

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_29

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_30

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_31

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins axi_register_slice_16/S_AXI]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins S_AXI9] [get_bd_intf_pins axi_register_slice_18/S_AXI]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins S_AXI10] [get_bd_intf_pins axi_register_slice_20/S_AXI]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins S_AXI11] [get_bd_intf_pins axi_register_slice_22/S_AXI]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins S_AXI12] [get_bd_intf_pins axi_register_slice_24/S_AXI]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins S_AXI13] [get_bd_intf_pins axi_register_slice_26/S_AXI]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins S_AXI14] [get_bd_intf_pins axi_register_slice_28/S_AXI]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins axi_register_slice_30/S_AXI]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins S_AXIS3] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins S_AXIS4] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins S_AXIS5] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins S_AXIS6] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins S_AXIS7] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net Conn25 [get_bd_intf_pins S_AXIS8] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net Conn26 [get_bd_intf_pins S_AXIS9] [get_bd_intf_pins axis_register_slice_18/S_AXIS]
  connect_bd_intf_net -intf_net Conn27 [get_bd_intf_pins S_AXIS10] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net Conn28 [get_bd_intf_pins S_AXIS11] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net Conn29 [get_bd_intf_pins S_AXIS12] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net Conn30 [get_bd_intf_pins S_AXIS13] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net Conn31 [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net Conn32 [get_bd_intf_pins S_AXIS14] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net Conn33 [get_bd_intf_pins S_AXIS15] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net Conn34 [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net Conn35 [get_bd_intf_pins M_AXIS3] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net Conn36 [get_bd_intf_pins M_AXIS4] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net Conn37 [get_bd_intf_pins M_AXIS5] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net Conn38 [get_bd_intf_pins M_AXIS6] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net Conn39 [get_bd_intf_pins M_AXIS7] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net Conn40 [get_bd_intf_pins M_AXIS8] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net Conn41 [get_bd_intf_pins M_AXIS9] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net Conn42 [get_bd_intf_pins M_AXIS10] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net Conn43 [get_bd_intf_pins M_AXIS11] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net Conn44 [get_bd_intf_pins M_AXIS12] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net Conn45 [get_bd_intf_pins M_AXIS13] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net Conn46 [get_bd_intf_pins M_AXIS14] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net Conn47 [get_bd_intf_pins M_AXIS15] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net S_AXI14_1 [get_bd_intf_pins M_AXI14] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI1 [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI2 [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI3 [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI4 [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI5 [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI6 [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI7 [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI8 [get_bd_intf_pins axi_register_slice_16/M_AXI] [get_bd_intf_pins axi_register_slice_17/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI9 [get_bd_intf_pins axi_register_slice_18/M_AXI] [get_bd_intf_pins axi_register_slice_19/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI10 [get_bd_intf_pins axi_register_slice_20/M_AXI] [get_bd_intf_pins axi_register_slice_21/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI11 [get_bd_intf_pins axi_register_slice_22/M_AXI] [get_bd_intf_pins axi_register_slice_23/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI12 [get_bd_intf_pins axi_register_slice_24/M_AXI] [get_bd_intf_pins axi_register_slice_25/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI13 [get_bd_intf_pins axi_register_slice_26/M_AXI] [get_bd_intf_pins axi_register_slice_27/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI14 [get_bd_intf_pins axi_register_slice_28/M_AXI] [get_bd_intf_pins axi_register_slice_29/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI15 [get_bd_intf_pins axi_register_slice_30/M_AXI] [get_bd_intf_pins axi_register_slice_31/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI1 [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI2 [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI3 [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI4 [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI5 [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI6 [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_13/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI7 [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_15/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI8 [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI9 [get_bd_intf_pins M_AXI9] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI10 [get_bd_intf_pins M_AXI10] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI11 [get_bd_intf_pins M_AXI11] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI12 [get_bd_intf_pins M_AXI12] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI13 [get_bd_intf_pins M_AXI13] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_pins M_AXI15] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS1 [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS2 [get_bd_intf_pins axis_register_slice_4/M_AXIS] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS3 [get_bd_intf_pins axis_register_slice_6/M_AXIS] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS4 [get_bd_intf_pins axis_register_slice_8/M_AXIS] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS5 [get_bd_intf_pins axis_register_slice_10/M_AXIS] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS6 [get_bd_intf_pins axis_register_slice_12/M_AXIS] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS7 [get_bd_intf_pins axis_register_slice_14/M_AXIS] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS8 [get_bd_intf_pins axis_register_slice_16/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS9 [get_bd_intf_pins axis_register_slice_18/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS10 [get_bd_intf_pins axis_register_slice_20/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS11 [get_bd_intf_pins axis_register_slice_22/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS12 [get_bd_intf_pins axis_register_slice_24/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS13 [get_bd_intf_pins axis_register_slice_26/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS14 [get_bd_intf_pins axis_register_slice_28/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS15 [get_bd_intf_pins axis_register_slice_30/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slr1_to_2_crossing
proc create_hier_cell_slr1_to_2_crossing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_slr1_to_2_crossing() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI15

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS15


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_3

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_4

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_5

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_6

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_7

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_8

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_9

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_10

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_11

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_12

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_13

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_14

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_15

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_16

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_17

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_18

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_19

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_20

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_21

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_22

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_23

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_24

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_25

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_26

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_27

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_28

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_29

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_30

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_31

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXI15] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXIS3] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXIS4] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXIS5] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXIS6] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins M_AXIS7] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins M_AXIS8] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins M_AXIS9] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins M_AXIS10] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins M_AXIS11] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins M_AXIS12] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins M_AXIS13] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins M_AXIS14] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins M_AXIS15] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins M_AXI13] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins M_AXI14] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net Conn25 [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net Conn26 [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net Conn27 [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net Conn28 [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_13/M_AXI]
  connect_bd_intf_net -intf_net Conn29 [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_15/M_AXI]
  connect_bd_intf_net -intf_net Conn30 [get_bd_intf_pins M_AXI9] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net Conn31 [get_bd_intf_pins M_AXI10] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net Conn32 [get_bd_intf_pins M_AXI11] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net Conn33 [get_bd_intf_pins M_AXI12] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net S_AXI11_1 [get_bd_intf_pins S_AXI10] [get_bd_intf_pins axi_register_slice_22/S_AXI]
  connect_bd_intf_net -intf_net S_AXI13_1 [get_bd_intf_pins S_AXI12] [get_bd_intf_pins axi_register_slice_26/S_AXI]
  connect_bd_intf_net -intf_net S_AXI15_1 [get_bd_intf_pins S_AXI14] [get_bd_intf_pins axi_register_slice_30/S_AXI]
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net S_AXI3_1 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net S_AXI5_1 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net S_AXI7_1 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net S_AXI9_1 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins axi_register_slice_18/S_AXI]
  connect_bd_intf_net -intf_net S_AXIS10_1 [get_bd_intf_pins S_AXIS10] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS12_1 [get_bd_intf_pins S_AXIS12] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS14_1 [get_bd_intf_pins S_AXIS14] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS2_1 [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS4_1 [get_bd_intf_pins S_AXIS4] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS6_1 [get_bd_intf_pins S_AXIS6] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS8_1 [get_bd_intf_pins S_AXIS8] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_10_M_AXI [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_12_M_AXI [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_14_M_AXI [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_16_M_AXI [get_bd_intf_pins axi_register_slice_16/M_AXI] [get_bd_intf_pins axi_register_slice_17/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_18_M_AXI [get_bd_intf_pins axi_register_slice_18/M_AXI] [get_bd_intf_pins axi_register_slice_19/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_20_M_AXI [get_bd_intf_pins axi_register_slice_20/M_AXI] [get_bd_intf_pins axi_register_slice_21/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_22_M_AXI [get_bd_intf_pins axi_register_slice_22/M_AXI] [get_bd_intf_pins axi_register_slice_23/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_24_M_AXI [get_bd_intf_pins axi_register_slice_24/M_AXI] [get_bd_intf_pins axi_register_slice_25/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_26_M_AXI [get_bd_intf_pins axi_register_slice_26/M_AXI] [get_bd_intf_pins axi_register_slice_27/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_28_M_AXI [get_bd_intf_pins axi_register_slice_28/M_AXI] [get_bd_intf_pins axi_register_slice_29/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_M_AXI [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_30_M_AXI [get_bd_intf_pins axi_register_slice_30/M_AXI] [get_bd_intf_pins axi_register_slice_31/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_6_M_AXI [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_8_M_AXI [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_10_M_AXIS [get_bd_intf_pins axis_register_slice_10/M_AXIS] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_12_M_AXIS [get_bd_intf_pins axis_register_slice_12/M_AXIS] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_14_M_AXIS [get_bd_intf_pins axis_register_slice_14/M_AXIS] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_16_M_AXIS [get_bd_intf_pins axis_register_slice_16/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_18_M_AXIS [get_bd_intf_pins axis_register_slice_18/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_20_M_AXIS [get_bd_intf_pins axis_register_slice_20/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_22_M_AXIS [get_bd_intf_pins axis_register_slice_22/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_24_M_AXIS [get_bd_intf_pins axis_register_slice_24/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_26_M_AXIS [get_bd_intf_pins axis_register_slice_26/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_28_M_AXIS [get_bd_intf_pins axis_register_slice_28/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_30_M_AXIS [get_bd_intf_pins axis_register_slice_30/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_4_M_AXIS [get_bd_intf_pins axis_register_slice_4/M_AXIS] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_6_M_AXIS [get_bd_intf_pins axis_register_slice_6/M_AXIS] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_8_M_AXIS [get_bd_intf_pins axis_register_slice_8/M_AXIS] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI10_SLR12 [get_bd_intf_pins S_AXI9] [get_bd_intf_pins axi_register_slice_20/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI12_SLR12 [get_bd_intf_pins S_AXI11] [get_bd_intf_pins axi_register_slice_24/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI14_SLR12 [get_bd_intf_pins S_AXI13] [get_bd_intf_pins axi_register_slice_28/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI2_SLR12 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI4_SLR12 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI6_SLR12 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI8_SLR12 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins axi_register_slice_16/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS11_SLR12 [get_bd_intf_pins S_AXIS11] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS13_SLR12 [get_bd_intf_pins S_AXIS15] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS15_SLR12 [get_bd_intf_pins S_AXIS13] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS1_SLR12 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS3_SLR12 [get_bd_intf_pins S_AXIS3] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS5_SLR12 [get_bd_intf_pins S_AXIS5] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS7_SLR12 [get_bd_intf_pins S_AXIS7] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS9_SLR12 [get_bd_intf_pins S_AXIS9] [get_bd_intf_pins axis_register_slice_18/S_AXIS]

  # Create port connections
  connect_bd_net -net aresetn_2 [get_bd_pins aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slr1_to_0_crossing
proc create_hier_cell_slr1_to_0_crossing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_slr1_to_0_crossing() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI15

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS15


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_3

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_4

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_5

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_6

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_7

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_8

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_9

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_10

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_11

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_12

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_13

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_14

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_15

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_16

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_17

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_18

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_19

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_20

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_21

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_22

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_23

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_24

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_25

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_26

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_27

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_28

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_29

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_30

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_31

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS15] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net S_AXI0_SLR01_1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net S_AXI11_SLR01_1 [get_bd_intf_pins M_AXI11] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net S_AXI13_SLR01_1 [get_bd_intf_pins M_AXI13] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net S_AXI15_SLR01_1 [get_bd_intf_pins M_AXI15] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net S_AXI1_SLR01_1 [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net S_AXI3_SLR01_1 [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net S_AXI5_SLR01_1 [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net S_AXI7_SLR01_1 [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_15/M_AXI]
  connect_bd_intf_net -intf_net S_AXI9_SLR01_1 [get_bd_intf_pins M_AXI9] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net S_AXIS10_SLR01_2 [get_bd_intf_pins M_AXIS10] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS12_SLR01_2 [get_bd_intf_pins M_AXIS12] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS14_SLR01_2 [get_bd_intf_pins M_AXIS14] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS2_SLR01_2 [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS4_SLR01_2 [get_bd_intf_pins M_AXIS4] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS6_SLR01_2 [get_bd_intf_pins M_AXIS6] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS8_SLR01_2 [get_bd_intf_pins M_AXIS8] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI1 [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI2 [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI3 [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI4 [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI5 [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI6 [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI7 [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI8 [get_bd_intf_pins axi_register_slice_16/M_AXI] [get_bd_intf_pins axi_register_slice_17/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI9 [get_bd_intf_pins axi_register_slice_18/M_AXI] [get_bd_intf_pins axi_register_slice_19/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI10 [get_bd_intf_pins axi_register_slice_20/M_AXI] [get_bd_intf_pins axi_register_slice_21/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI11 [get_bd_intf_pins axi_register_slice_22/M_AXI] [get_bd_intf_pins axi_register_slice_23/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI12 [get_bd_intf_pins axi_register_slice_24/M_AXI] [get_bd_intf_pins axi_register_slice_25/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI13 [get_bd_intf_pins axi_register_slice_26/M_AXI] [get_bd_intf_pins axi_register_slice_27/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI14 [get_bd_intf_pins axi_register_slice_28/M_AXI] [get_bd_intf_pins axi_register_slice_29/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI15 [get_bd_intf_pins axi_register_slice_30/M_AXI] [get_bd_intf_pins axi_register_slice_31/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_13_M_AXI [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_13/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_17_M_AXI [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_21_M_AXI [get_bd_intf_pins M_AXI10] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_25_M_AXI [get_bd_intf_pins M_AXI12] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_29_M_AXI [get_bd_intf_pins M_AXI14] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS1 [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS2 [get_bd_intf_pins axis_register_slice_4/M_AXIS] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS3 [get_bd_intf_pins axis_register_slice_6/M_AXIS] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS4 [get_bd_intf_pins axis_register_slice_8/M_AXIS] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS5 [get_bd_intf_pins axis_register_slice_10/M_AXIS] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS6 [get_bd_intf_pins axis_register_slice_12/M_AXIS] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS7 [get_bd_intf_pins axis_register_slice_14/M_AXIS] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS8 [get_bd_intf_pins axis_register_slice_16/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS9 [get_bd_intf_pins axis_register_slice_18/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS10 [get_bd_intf_pins axis_register_slice_20/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS11 [get_bd_intf_pins axis_register_slice_22/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS12 [get_bd_intf_pins axis_register_slice_24/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS13 [get_bd_intf_pins axis_register_slice_26/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS14 [get_bd_intf_pins axis_register_slice_28/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_11_M_AXIS [get_bd_intf_pins M_AXIS5] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_15_M_AXIS [get_bd_intf_pins M_AXIS7] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_19_M_AXIS [get_bd_intf_pins M_AXIS9] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_23_M_AXIS [get_bd_intf_pins M_AXIS11] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_27_M_AXIS [get_bd_intf_pins M_AXIS13] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_30_M_AXIS [get_bd_intf_pins axis_register_slice_30/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_31_M_AXIS [get_bd_intf_pins M_AXIS15] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS [get_bd_intf_pins M_AXIS3] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI0_SLR01 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI10_SLR01 [get_bd_intf_pins S_AXI10] [get_bd_intf_pins axi_register_slice_20/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI11_SLR01 [get_bd_intf_pins S_AXI11] [get_bd_intf_pins axi_register_slice_22/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI12_SLR01 [get_bd_intf_pins S_AXI12] [get_bd_intf_pins axi_register_slice_24/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI13_SLR01 [get_bd_intf_pins S_AXI13] [get_bd_intf_pins axi_register_slice_26/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI14_SLR01 [get_bd_intf_pins S_AXI14] [get_bd_intf_pins axi_register_slice_28/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI15_SLR01 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins axi_register_slice_30/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI1_SLR01 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI2_SLR01 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI3_SLR01 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI4_SLR01 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI5_SLR01 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI6_SLR01 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI7_SLR01 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI8_SLR01 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins axi_register_slice_16/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI9_SLR01 [get_bd_intf_pins S_AXI9] [get_bd_intf_pins axi_register_slice_18/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS0_SLR01 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS10_SLR01 [get_bd_intf_pins S_AXIS10] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS11_SLR01 [get_bd_intf_pins S_AXIS11] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS12_SLR01 [get_bd_intf_pins S_AXIS12] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS13_SLR01 [get_bd_intf_pins S_AXIS13] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS14_SLR01 [get_bd_intf_pins S_AXIS14] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS1_SLR01 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS2_SLR01 [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS3_SLR01 [get_bd_intf_pins S_AXIS3] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS4_SLR01 [get_bd_intf_pins S_AXIS4] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS5_SLR01 [get_bd_intf_pins S_AXIS5] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS6_SLR01 [get_bd_intf_pins S_AXIS6] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS7_SLR01 [get_bd_intf_pins S_AXIS7] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS8_SLR01 [get_bd_intf_pins S_AXIS8] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS9_SLR01 [get_bd_intf_pins S_AXIS9] [get_bd_intf_pins axis_register_slice_18/S_AXIS]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: slr0_to_1_crossing
proc create_hier_cell_slr0_to_1_crossing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_slr0_to_1_crossing() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI15

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS8

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS9

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS11

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS13

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS14

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI15

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS5

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS6

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS7

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS9

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS11

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS13

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS14

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS15


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_0

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_1

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_2

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_3

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_4

  # Create instance: axi_register_slice_5, and set properties
  set axi_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_5

  # Create instance: axi_register_slice_6, and set properties
  set axi_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_6

  # Create instance: axi_register_slice_7, and set properties
  set axi_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_7

  # Create instance: axi_register_slice_8, and set properties
  set axi_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_8

  # Create instance: axi_register_slice_9, and set properties
  set axi_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_9

  # Create instance: axi_register_slice_10, and set properties
  set axi_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_10

  # Create instance: axi_register_slice_11, and set properties
  set axi_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_11

  # Create instance: axi_register_slice_12, and set properties
  set axi_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_12

  # Create instance: axi_register_slice_13, and set properties
  set axi_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_13

  # Create instance: axi_register_slice_14, and set properties
  set axi_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_14

  # Create instance: axi_register_slice_15, and set properties
  set axi_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_15

  # Create instance: axi_register_slice_16, and set properties
  set axi_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_16

  # Create instance: axi_register_slice_17, and set properties
  set axi_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_17

  # Create instance: axi_register_slice_18, and set properties
  set axi_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_18

  # Create instance: axi_register_slice_19, and set properties
  set axi_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_19

  # Create instance: axi_register_slice_20, and set properties
  set axi_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_20

  # Create instance: axi_register_slice_21, and set properties
  set axi_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_21

  # Create instance: axi_register_slice_22, and set properties
  set axi_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_22

  # Create instance: axi_register_slice_23, and set properties
  set axi_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_23

  # Create instance: axi_register_slice_24, and set properties
  set axi_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_24

  # Create instance: axi_register_slice_25, and set properties
  set axi_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_25

  # Create instance: axi_register_slice_26, and set properties
  set axi_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_26

  # Create instance: axi_register_slice_27, and set properties
  set axi_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_27

  # Create instance: axi_register_slice_28, and set properties
  set axi_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_28

  # Create instance: axi_register_slice_29, and set properties
  set axi_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_29

  # Create instance: axi_register_slice_30, and set properties
  set axi_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {9} \
   CONFIG.REG_R {9} \
   CONFIG.REG_W {1} \
 ] $axi_register_slice_30

  # Create instance: axi_register_slice_31, and set properties
  set axi_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_AR {9} \
   CONFIG.REG_AW {9} \
   CONFIG.REG_B {1} \
   CONFIG.REG_W {9} \
 ] $axi_register_slice_31

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_3

  # Create instance: axis_register_slice_4, and set properties
  set axis_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_4 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_4

  # Create instance: axis_register_slice_5, and set properties
  set axis_register_slice_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_5 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_5

  # Create instance: axis_register_slice_6, and set properties
  set axis_register_slice_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_6 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_6

  # Create instance: axis_register_slice_7, and set properties
  set axis_register_slice_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_7 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_7

  # Create instance: axis_register_slice_8, and set properties
  set axis_register_slice_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_8 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_8

  # Create instance: axis_register_slice_9, and set properties
  set axis_register_slice_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_9 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_9

  # Create instance: axis_register_slice_10, and set properties
  set axis_register_slice_10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_10 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_10

  # Create instance: axis_register_slice_11, and set properties
  set axis_register_slice_11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_11 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_11

  # Create instance: axis_register_slice_12, and set properties
  set axis_register_slice_12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_12 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_12

  # Create instance: axis_register_slice_13, and set properties
  set axis_register_slice_13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_13 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_13

  # Create instance: axis_register_slice_14, and set properties
  set axis_register_slice_14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_14 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_14

  # Create instance: axis_register_slice_15, and set properties
  set axis_register_slice_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_15 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_15

  # Create instance: axis_register_slice_16, and set properties
  set axis_register_slice_16 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_16 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_16

  # Create instance: axis_register_slice_17, and set properties
  set axis_register_slice_17 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_17 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_17

  # Create instance: axis_register_slice_18, and set properties
  set axis_register_slice_18 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_18 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_18

  # Create instance: axis_register_slice_19, and set properties
  set axis_register_slice_19 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_19 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_19

  # Create instance: axis_register_slice_20, and set properties
  set axis_register_slice_20 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_20 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_20

  # Create instance: axis_register_slice_21, and set properties
  set axis_register_slice_21 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_21 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_21

  # Create instance: axis_register_slice_22, and set properties
  set axis_register_slice_22 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_22 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_22

  # Create instance: axis_register_slice_23, and set properties
  set axis_register_slice_23 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_23 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_23

  # Create instance: axis_register_slice_24, and set properties
  set axis_register_slice_24 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_24 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_24

  # Create instance: axis_register_slice_25, and set properties
  set axis_register_slice_25 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_25 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_25

  # Create instance: axis_register_slice_26, and set properties
  set axis_register_slice_26 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_26 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_26

  # Create instance: axis_register_slice_27, and set properties
  set axis_register_slice_27 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_27 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_27

  # Create instance: axis_register_slice_28, and set properties
  set axis_register_slice_28 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_28 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_28

  # Create instance: axis_register_slice_29, and set properties
  set axis_register_slice_29 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_29 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_29

  # Create instance: axis_register_slice_30, and set properties
  set axis_register_slice_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_30 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_30

  # Create instance: axis_register_slice_31, and set properties
  set axis_register_slice_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_31 ]
  set_property -dict [ list \
   CONFIG.REG_CONFIG {8} \
 ] $axis_register_slice_31

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI4] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins S_AXI5] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins S_AXI6] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins S_AXI7] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins S_AXI8] [get_bd_intf_pins axi_register_slice_16/S_AXI]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins S_AXI9] [get_bd_intf_pins axi_register_slice_18/S_AXI]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins S_AXI10] [get_bd_intf_pins axi_register_slice_20/S_AXI]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins S_AXI11] [get_bd_intf_pins axi_register_slice_22/S_AXI]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins S_AXI12] [get_bd_intf_pins axi_register_slice_24/S_AXI]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins S_AXI13] [get_bd_intf_pins axi_register_slice_26/S_AXI]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins S_AXI14] [get_bd_intf_pins axi_register_slice_28/S_AXI]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins S_AXI15] [get_bd_intf_pins axi_register_slice_30/S_AXI]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins S_AXIS1] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins S_AXIS2] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins S_AXIS3] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net Conn21 [get_bd_intf_pins S_AXIS4] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins S_AXIS5] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins S_AXIS6] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins S_AXIS7] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net Conn25 [get_bd_intf_pins S_AXIS8] [get_bd_intf_pins axis_register_slice_16/S_AXIS]
  connect_bd_intf_net -intf_net Conn26 [get_bd_intf_pins S_AXIS9] [get_bd_intf_pins axis_register_slice_18/S_AXIS]
  connect_bd_intf_net -intf_net Conn27 [get_bd_intf_pins S_AXIS10] [get_bd_intf_pins axis_register_slice_20/S_AXIS]
  connect_bd_intf_net -intf_net Conn28 [get_bd_intf_pins S_AXIS11] [get_bd_intf_pins axis_register_slice_22/S_AXIS]
  connect_bd_intf_net -intf_net Conn29 [get_bd_intf_pins S_AXIS12] [get_bd_intf_pins axis_register_slice_24/S_AXIS]
  connect_bd_intf_net -intf_net Conn30 [get_bd_intf_pins S_AXIS13] [get_bd_intf_pins axis_register_slice_30/S_AXIS]
  connect_bd_intf_net -intf_net Conn31 [get_bd_intf_pins M_AXIS1] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net Conn32 [get_bd_intf_pins S_AXIS14] [get_bd_intf_pins axis_register_slice_28/S_AXIS]
  connect_bd_intf_net -intf_net Conn33 [get_bd_intf_pins S_AXIS15] [get_bd_intf_pins axis_register_slice_26/S_AXIS]
  connect_bd_intf_net -intf_net Conn34 [get_bd_intf_pins M_AXIS2] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net Conn35 [get_bd_intf_pins M_AXIS3] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net Conn36 [get_bd_intf_pins M_AXIS4] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net Conn37 [get_bd_intf_pins M_AXIS5] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net Conn38 [get_bd_intf_pins M_AXIS6] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net Conn39 [get_bd_intf_pins M_AXIS7] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net Conn40 [get_bd_intf_pins M_AXIS8] [get_bd_intf_pins axis_register_slice_17/M_AXIS]
  connect_bd_intf_net -intf_net Conn41 [get_bd_intf_pins M_AXIS9] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net Conn42 [get_bd_intf_pins M_AXIS10] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net Conn43 [get_bd_intf_pins M_AXIS11] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net Conn44 [get_bd_intf_pins M_AXIS12] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net Conn45 [get_bd_intf_pins M_AXIS13] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net Conn46 [get_bd_intf_pins M_AXIS14] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net Conn47 [get_bd_intf_pins M_AXIS15] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net S_AXI14_1 [get_bd_intf_pins M_AXI14] [get_bd_intf_pins axi_register_slice_29/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI1 [get_bd_intf_pins axi_register_slice_2/M_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI2 [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI3 [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI4 [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI5 [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI6 [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI7 [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI8 [get_bd_intf_pins axi_register_slice_16/M_AXI] [get_bd_intf_pins axi_register_slice_17/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI9 [get_bd_intf_pins axi_register_slice_18/M_AXI] [get_bd_intf_pins axi_register_slice_19/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI10 [get_bd_intf_pins axi_register_slice_20/M_AXI] [get_bd_intf_pins axi_register_slice_21/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI11 [get_bd_intf_pins axi_register_slice_22/M_AXI] [get_bd_intf_pins axi_register_slice_23/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI12 [get_bd_intf_pins axi_register_slice_24/M_AXI] [get_bd_intf_pins axi_register_slice_25/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI13 [get_bd_intf_pins axi_register_slice_26/M_AXI] [get_bd_intf_pins axi_register_slice_27/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI14 [get_bd_intf_pins axi_register_slice_28/M_AXI] [get_bd_intf_pins axi_register_slice_29/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI15 [get_bd_intf_pins axi_register_slice_30/M_AXI] [get_bd_intf_pins axi_register_slice_31/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI1 [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI2 [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI3 [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_7/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI4 [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_9/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI5 [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_11/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI6 [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_13/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI7 [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_15/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI8 [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_17/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI9 [get_bd_intf_pins M_AXI9] [get_bd_intf_pins axi_register_slice_19/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI10 [get_bd_intf_pins M_AXI10] [get_bd_intf_pins axi_register_slice_21/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI11 [get_bd_intf_pins M_AXI11] [get_bd_intf_pins axi_register_slice_23/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI12 [get_bd_intf_pins M_AXI12] [get_bd_intf_pins axi_register_slice_25/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI13 [get_bd_intf_pins M_AXI13] [get_bd_intf_pins axi_register_slice_27/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_pins M_AXI15] [get_bd_intf_pins axi_register_slice_31/M_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS1 [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS2 [get_bd_intf_pins axis_register_slice_4/M_AXIS] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS3 [get_bd_intf_pins axis_register_slice_6/M_AXIS] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS4 [get_bd_intf_pins axis_register_slice_8/M_AXIS] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS5 [get_bd_intf_pins axis_register_slice_10/M_AXIS] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS6 [get_bd_intf_pins axis_register_slice_12/M_AXIS] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS7 [get_bd_intf_pins axis_register_slice_14/M_AXIS] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS8 [get_bd_intf_pins axis_register_slice_16/M_AXIS] [get_bd_intf_pins axis_register_slice_17/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS9 [get_bd_intf_pins axis_register_slice_18/M_AXIS] [get_bd_intf_pins axis_register_slice_19/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS10 [get_bd_intf_pins axis_register_slice_20/M_AXIS] [get_bd_intf_pins axis_register_slice_21/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS11 [get_bd_intf_pins axis_register_slice_22/M_AXIS] [get_bd_intf_pins axis_register_slice_23/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS12 [get_bd_intf_pins axis_register_slice_24/M_AXIS] [get_bd_intf_pins axis_register_slice_25/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS13 [get_bd_intf_pins axis_register_slice_26/M_AXIS] [get_bd_intf_pins axis_register_slice_27/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS14 [get_bd_intf_pins axis_register_slice_28/M_AXIS] [get_bd_intf_pins axis_register_slice_29/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS15 [get_bd_intf_pins axis_register_slice_30/M_AXIS] [get_bd_intf_pins axis_register_slice_31/S_AXIS]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins aclk] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_16/aclk] [get_bd_pins axi_register_slice_17/aclk] [get_bd_pins axi_register_slice_18/aclk] [get_bd_pins axi_register_slice_19/aclk] [get_bd_pins axi_register_slice_2/aclk] [get_bd_pins axi_register_slice_20/aclk] [get_bd_pins axi_register_slice_21/aclk] [get_bd_pins axi_register_slice_22/aclk] [get_bd_pins axi_register_slice_23/aclk] [get_bd_pins axi_register_slice_24/aclk] [get_bd_pins axi_register_slice_25/aclk] [get_bd_pins axi_register_slice_26/aclk] [get_bd_pins axi_register_slice_27/aclk] [get_bd_pins axi_register_slice_28/aclk] [get_bd_pins axi_register_slice_29/aclk] [get_bd_pins axi_register_slice_3/aclk] [get_bd_pins axi_register_slice_30/aclk] [get_bd_pins axi_register_slice_31/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_16/aclk] [get_bd_pins axis_register_slice_17/aclk] [get_bd_pins axis_register_slice_18/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_16/aresetn] [get_bd_pins axi_register_slice_17/aresetn] [get_bd_pins axi_register_slice_18/aresetn] [get_bd_pins axi_register_slice_19/aresetn] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins axi_register_slice_20/aresetn] [get_bd_pins axi_register_slice_21/aresetn] [get_bd_pins axi_register_slice_22/aresetn] [get_bd_pins axi_register_slice_23/aresetn] [get_bd_pins axi_register_slice_24/aresetn] [get_bd_pins axi_register_slice_25/aresetn] [get_bd_pins axi_register_slice_26/aresetn] [get_bd_pins axi_register_slice_27/aresetn] [get_bd_pins axi_register_slice_28/aresetn] [get_bd_pins axi_register_slice_29/aresetn] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins axi_register_slice_30/aresetn] [get_bd_pins axi_register_slice_31/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_16/aresetn] [get_bd_pins axis_register_slice_17/aresetn] [get_bd_pins axis_register_slice_18/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn]

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
  set C0_DDR4_SLR0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 -portmaps { \
   ACT_N { physical_name C0_DDR4_SLR0_act_n direction O } \
   ADR { physical_name C0_DDR4_SLR0_adr direction O left 16 right 0 } \
   BA { physical_name C0_DDR4_SLR0_ba direction O left 1 right 0 } \
   BG { physical_name C0_DDR4_SLR0_bg direction O left 1 right 0 } \
   CK_C { physical_name C0_DDR4_SLR0_ck_c direction O left 0 right 0 } \
   CK_T { physical_name C0_DDR4_SLR0_ck_t direction O left 0 right 0 } \
   CKE { physical_name C0_DDR4_SLR0_cke direction O left 0 right 0 } \
   CS_N { physical_name C0_DDR4_SLR0_cs_n direction O left 0 right 0 } \
   DM_N { physical_name C0_DDR4_SLR0_dm_n direction IO left 0 right 0 } \
   DQ { physical_name C0_DDR4_SLR0_dq direction IO left 7 right 0 } \
   DQS_C { physical_name C0_DDR4_SLR0_dqs_c direction IO left 0 right 0 } \
   DQS_T { physical_name C0_DDR4_SLR0_dqs_t direction IO left 0 right 0 } \
   ODT { physical_name C0_DDR4_SLR0_odt direction O left 0 right 0 } \
   RESET_N { physical_name C0_DDR4_SLR0_reset_n direction O } \
   } \
  C0_DDR4_SLR0 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $C0_DDR4_SLR0
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_DDR4_SLR0]

  set C0_DDR4_SLR1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 -portmaps { \
   ACT_N { physical_name C0_DDR4_SLR1_act_n direction O } \
   ADR { physical_name C0_DDR4_SLR1_adr direction O left 16 right 0 } \
   BA { physical_name C0_DDR4_SLR1_ba direction O left 1 right 0 } \
   BG { physical_name C0_DDR4_SLR1_bg direction O left 1 right 0 } \
   CK_C { physical_name C0_DDR4_SLR1_ck_c direction O left 0 right 0 } \
   CK_T { physical_name C0_DDR4_SLR1_ck_t direction O left 0 right 0 } \
   CKE { physical_name C0_DDR4_SLR1_cke direction O left 0 right 0 } \
   CS_N { physical_name C0_DDR4_SLR1_cs_n direction O left 0 right 0 } \
   DM_N { physical_name C0_DDR4_SLR1_dm_n direction IO left 0 right 0 } \
   DQ { physical_name C0_DDR4_SLR1_dq direction IO left 7 right 0 } \
   DQS_C { physical_name C0_DDR4_SLR1_dqs_c direction IO left 0 right 0 } \
   DQS_T { physical_name C0_DDR4_SLR1_dqs_t direction IO left 0 right 0 } \
   ODT { physical_name C0_DDR4_SLR1_odt direction O left 0 right 0 } \
   RESET_N { physical_name C0_DDR4_SLR1_reset_n direction O } \
   } \
  C0_DDR4_SLR1 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $C0_DDR4_SLR1
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_DDR4_SLR1]

  set C0_DDR4_SLR2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 -portmaps { \
   ACT_N { physical_name C0_DDR4_SLR2_act_n direction O } \
   ADR { physical_name C0_DDR4_SLR2_adr direction O left 16 right 0 } \
   BA { physical_name C0_DDR4_SLR2_ba direction O left 1 right 0 } \
   BG { physical_name C0_DDR4_SLR2_bg direction O left 1 right 0 } \
   CK_C { physical_name C0_DDR4_SLR2_ck_c direction O left 0 right 0 } \
   CK_T { physical_name C0_DDR4_SLR2_ck_t direction O left 0 right 0 } \
   CKE { physical_name C0_DDR4_SLR2_cke direction O left 0 right 0 } \
   CS_N { physical_name C0_DDR4_SLR2_cs_n direction O left 0 right 0 } \
   DM_N { physical_name C0_DDR4_SLR2_dm_n direction IO left 0 right 0 } \
   DQ { physical_name C0_DDR4_SLR2_dq direction IO left 7 right 0 } \
   DQS_C { physical_name C0_DDR4_SLR2_dqs_c direction IO left 0 right 0 } \
   DQS_T { physical_name C0_DDR4_SLR2_dqs_t direction IO left 0 right 0 } \
   ODT { physical_name C0_DDR4_SLR2_odt direction O left 0 right 0 } \
   RESET_N { physical_name C0_DDR4_SLR2_reset_n direction O } \
   } \
  C0_DDR4_SLR2 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $C0_DDR4_SLR2
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_DDR4_SLR2]

  set C0_DDR4_SLR3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 -portmaps { \
   ACT_N { physical_name C0_DDR4_SLR3_act_n direction O } \
   ADR { physical_name C0_DDR4_SLR3_adr direction O left 16 right 0 } \
   BA { physical_name C0_DDR4_SLR3_ba direction O left 1 right 0 } \
   BG { physical_name C0_DDR4_SLR3_bg direction O left 1 right 0 } \
   CK_C { physical_name C0_DDR4_SLR3_ck_c direction O left 0 right 0 } \
   CK_T { physical_name C0_DDR4_SLR3_ck_t direction O left 0 right 0 } \
   CKE { physical_name C0_DDR4_SLR3_cke direction O left 0 right 0 } \
   CS_N { physical_name C0_DDR4_SLR3_cs_n direction O left 0 right 0 } \
   DM_N { physical_name C0_DDR4_SLR3_dm_n direction IO left 0 right 0 } \
   DQ { physical_name C0_DDR4_SLR3_dq direction IO left 7 right 0 } \
   DQS_C { physical_name C0_DDR4_SLR3_dqs_c direction IO left 0 right 0 } \
   DQS_T { physical_name C0_DDR4_SLR3_dqs_t direction IO left 0 right 0 } \
   ODT { physical_name C0_DDR4_SLR3_odt direction O left 0 right 0 } \
   RESET_N { physical_name C0_DDR4_SLR3_reset_n direction O } \
   } \
  C0_DDR4_SLR3 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   ] $C0_DDR4_SLR3
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_DDR4_SLR3]

  set C0_SYS_CLK_SLR0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name C0_SYS_CLK_SLR0_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name C0_SYS_CLK_SLR0_clk_p direction I left 0 right 0 } \
   } \
  C0_SYS_CLK_SLR0 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $C0_SYS_CLK_SLR0
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports C0_SYS_CLK_SLR0]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_SYS_CLK_SLR0]

  set C0_SYS_CLK_SLR1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name C0_SYS_CLK_SLR1_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name C0_SYS_CLK_SLR1_clk_p direction I left 0 right 0 } \
   } \
  C0_SYS_CLK_SLR1 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $C0_SYS_CLK_SLR1
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports C0_SYS_CLK_SLR1]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_SYS_CLK_SLR1]

  set C0_SYS_CLK_SLR2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name C0_SYS_CLK_SLR2_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name C0_SYS_CLK_SLR2_clk_p direction I left 0 right 0 } \
   } \
  C0_SYS_CLK_SLR2 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $C0_SYS_CLK_SLR2
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports C0_SYS_CLK_SLR2]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_SYS_CLK_SLR2]

  set C0_SYS_CLK_SLR3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name C0_SYS_CLK_SLR3_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name C0_SYS_CLK_SLR3_clk_p direction I left 0 right 0 } \
   } \
  C0_SYS_CLK_SLR3 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $C0_SYS_CLK_SLR3
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports C0_SYS_CLK_SLR3]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports C0_SYS_CLK_SLR3]

  set clock_qdma_slr1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name clock_qdma_slr1_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name clock_qdma_slr1_clk_p direction I left 0 right 0 } \
   } \
  clock_qdma_slr1 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $clock_qdma_slr1
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports clock_qdma_slr1]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports clock_qdma_slr1]

  set clock_qdma_slr2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -portmaps { \
   CLK_N { physical_name clock_qdma_slr2_clk_n direction I left 0 right 0 } \
   CLK_P { physical_name clock_qdma_slr2_clk_p direction I left 0 right 0 } \
   } \
  clock_qdma_slr2 ]
  set_property -dict [ list \
   CONFIG.CAN_DEBUG {false} \
   CONFIG.FREQ_HZ {100000000} \
   ] $clock_qdma_slr2
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports clock_qdma_slr2]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports clock_qdma_slr2]

  set pcie_7x_mgt_rtl_SLR1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 -portmaps { \
   rxn { physical_name pcie_7x_mgt_rtl_SLR1_rxn direction I } \
   rxp { physical_name pcie_7x_mgt_rtl_SLR1_rxp direction I } \
   txn { physical_name pcie_7x_mgt_rtl_SLR1_txn direction O } \
   txp { physical_name pcie_7x_mgt_rtl_SLR1_txp direction O } \
   } \
  pcie_7x_mgt_rtl_SLR1 ]
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports pcie_7x_mgt_rtl_SLR1]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports pcie_7x_mgt_rtl_SLR1]

  set pcie_7x_mgt_rtl_SLR2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 -portmaps { \
   rxn { physical_name pcie_7x_mgt_rtl_SLR2_rxn direction I } \
   rxp { physical_name pcie_7x_mgt_rtl_SLR2_rxp direction I } \
   txn { physical_name pcie_7x_mgt_rtl_SLR2_txn direction O } \
   txp { physical_name pcie_7x_mgt_rtl_SLR2_txp direction O } \
   } \
  pcie_7x_mgt_rtl_SLR2 ]
  set_property HDL_ATTRIBUTE.IO_BUFFER_TYPE {NONE} [get_bd_intf_ports pcie_7x_mgt_rtl_SLR2]
  set_property HDL_ATTRIBUTE.LOCKED {TRUE} [get_bd_intf_ports pcie_7x_mgt_rtl_SLR2]


  # Create ports
  set clk_in1_0 [ create_bd_port -dir I -type clk clk_in1_0 ]
  set ext_reset_in_0 [ create_bd_port -dir I -type rst ext_reset_in_0 ]

  # Create instance: rp_slr0, and set properties
  set rp_slr0 [ create_bd_cell -type container -reference rp_slr0 rp_slr0 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp_slr0.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp_slr0.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp_slr0.bd} \
   CONFIG.LIST_SYNTH_BD {rp_slr0.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $rp_slr0

  # Create instance: rp_slr1, and set properties
  set rp_slr1 [ create_bd_cell -type container -reference rp_slr1 rp_slr1 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp_slr1.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp_slr1.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp_slr1.bd} \
   CONFIG.LIST_SYNTH_BD {rp_slr1.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $rp_slr1

  # Create instance: rp_slr2, and set properties
  set rp_slr2 [ create_bd_cell -type container -reference rp_slr2 rp_slr2 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp_slr2.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp_slr2.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp_slr2.bd} \
   CONFIG.LIST_SYNTH_BD {rp_slr2.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $rp_slr2

  # Create instance: rp_slr3, and set properties
  set rp_slr3 [ create_bd_cell -type container -reference rp_slr3 rp_slr3 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp_slr3.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp_slr3.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp_slr3.bd} \
   CONFIG.LIST_SYNTH_BD {rp_slr3.bd} \
   CONFIG.LOCK_PROPAGATE {true} \
 ] $rp_slr3

  # Create instance: slr0_to_1_crossing
  create_hier_cell_slr0_to_1_crossing [current_bd_instance .] slr0_to_1_crossing

  # Create instance: slr1_to_0_crossing
  create_hier_cell_slr1_to_0_crossing [current_bd_instance .] slr1_to_0_crossing

  # Create instance: slr1_to_2_crossing
  create_hier_cell_slr1_to_2_crossing [current_bd_instance .] slr1_to_2_crossing

  # Create instance: slr2_to_1_crossing
  create_hier_cell_slr2_to_1_crossing [current_bd_instance .] slr2_to_1_crossing

  # Create instance: slr2_to_3_crossing
  create_hier_cell_slr2_to_3_crossing [current_bd_instance .] slr2_to_3_crossing

  # Create instance: slr3_to_2_crossing
  create_hier_cell_slr3_to_2_crossing [current_bd_instance .] slr3_to_2_crossing

  # Create instance: static_region
  create_hier_cell_static_region [current_bd_instance .] static_region

  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_0_1 [get_bd_intf_ports C0_SYS_CLK_SLR3] [get_bd_intf_pins rp_slr3/C0_SYS_CLK_0]
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_0_2 [get_bd_intf_ports C0_SYS_CLK_SLR2] [get_bd_intf_pins rp_slr2/C0_SYS_CLK_0]
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_0_3 [get_bd_intf_ports C0_SYS_CLK_SLR1] [get_bd_intf_pins rp_slr1/C0_SYS_CLK_0]
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_0_4 [get_bd_intf_ports C0_SYS_CLK_SLR0] [get_bd_intf_pins rp_slr0/C0_SYS_CLK_0]
  connect_bd_intf_net -intf_net S_AXI0_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI0_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI]
  connect_bd_intf_net -intf_net S_AXI0_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI0_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI15]
  connect_bd_intf_net -intf_net S_AXI0_SLR12_2 [get_bd_intf_pins rp_slr1/S_AXI0_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI]
  connect_bd_intf_net -intf_net S_AXI10_1 [get_bd_intf_pins rp_slr2/M_AXI10_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI10]
  connect_bd_intf_net -intf_net S_AXI10_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI10_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI10]
  connect_bd_intf_net -intf_net S_AXI10_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI10_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI2]
  connect_bd_intf_net -intf_net S_AXI11_1 [get_bd_intf_pins rp_slr1/M_AXI11_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI10]
  connect_bd_intf_net -intf_net S_AXI11_2 [get_bd_intf_pins rp_slr2/M_AXI11_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI11]
  connect_bd_intf_net -intf_net S_AXI11_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI11_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI11]
  connect_bd_intf_net -intf_net S_AXI11_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI11_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI3]
  connect_bd_intf_net -intf_net S_AXI11_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI11_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI11]
  connect_bd_intf_net -intf_net S_AXI12_1 [get_bd_intf_pins rp_slr2/M_AXI12_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI12]
  connect_bd_intf_net -intf_net S_AXI12_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI12_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI12]
  connect_bd_intf_net -intf_net S_AXI12_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI12_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI11]
  connect_bd_intf_net -intf_net S_AXI13_1 [get_bd_intf_pins rp_slr1/M_AXI13_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI12]
  connect_bd_intf_net -intf_net S_AXI13_2 [get_bd_intf_pins rp_slr2/M_AXI13_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI13]
  connect_bd_intf_net -intf_net S_AXI13_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI13_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI13]
  connect_bd_intf_net -intf_net S_AXI13_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI13_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI12]
  connect_bd_intf_net -intf_net S_AXI13_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI13_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI13]
  connect_bd_intf_net -intf_net S_AXI14_1 [get_bd_intf_pins rp_slr1/S_AXI14_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI14]
  connect_bd_intf_net -intf_net S_AXI14_2 [get_bd_intf_pins rp_slr2/M_AXI14_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI14]
  connect_bd_intf_net -intf_net S_AXI14_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI14_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI14]
  connect_bd_intf_net -intf_net S_AXI14_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI14_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI1]
  connect_bd_intf_net -intf_net S_AXI15_1 [get_bd_intf_pins rp_slr1/M_AXI15_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI14]
  connect_bd_intf_net -intf_net S_AXI15_2 [get_bd_intf_pins rp_slr2/M_AXI15_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI15]
  connect_bd_intf_net -intf_net S_AXI15_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI15_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI15]
  connect_bd_intf_net -intf_net S_AXI15_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI15_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI13]
  connect_bd_intf_net -intf_net S_AXI15_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI15_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI15]
  connect_bd_intf_net -intf_net S_AXI1_1 [get_bd_intf_pins rp_slr1/M_AXI1_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI]
  connect_bd_intf_net -intf_net S_AXI1_2 [get_bd_intf_pins rp_slr2/M_AXI1_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI1]
  connect_bd_intf_net -intf_net S_AXI1_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI1_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI1]
  connect_bd_intf_net -intf_net S_AXI1_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI1_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI]
  connect_bd_intf_net -intf_net S_AXI1_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI1_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI1]
  connect_bd_intf_net -intf_net S_AXI2_1 [get_bd_intf_pins rp_slr2/M_AXI2_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI2]
  connect_bd_intf_net -intf_net S_AXI2_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI2_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI2]
  connect_bd_intf_net -intf_net S_AXI2_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI2_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI14]
  connect_bd_intf_net -intf_net S_AXI3_1 [get_bd_intf_pins rp_slr1/M_AXI3_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI2]
  connect_bd_intf_net -intf_net S_AXI3_2 [get_bd_intf_pins rp_slr2/M_AXI3_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI3]
  connect_bd_intf_net -intf_net S_AXI3_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI3_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI3]
  connect_bd_intf_net -intf_net S_AXI3_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI3_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI4]
  connect_bd_intf_net -intf_net S_AXI3_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI3_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI3]
  connect_bd_intf_net -intf_net S_AXI4_1 [get_bd_intf_pins rp_slr2/M_AXI4_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI4]
  connect_bd_intf_net -intf_net S_AXI4_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI4_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI4]
  connect_bd_intf_net -intf_net S_AXI4_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI4_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI5]
  connect_bd_intf_net -intf_net S_AXI5_1 [get_bd_intf_pins rp_slr1/M_AXI5_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI4]
  connect_bd_intf_net -intf_net S_AXI5_2 [get_bd_intf_pins rp_slr2/M_AXI5_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI5]
  connect_bd_intf_net -intf_net S_AXI5_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI5_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI5]
  connect_bd_intf_net -intf_net S_AXI5_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI5_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI6]
  connect_bd_intf_net -intf_net S_AXI5_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI5_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI5]
  connect_bd_intf_net -intf_net S_AXI6_1 [get_bd_intf_pins rp_slr2/M_AXI6_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI6]
  connect_bd_intf_net -intf_net S_AXI6_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI6_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI6]
  connect_bd_intf_net -intf_net S_AXI6_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI6_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI7]
  connect_bd_intf_net -intf_net S_AXI7_1 [get_bd_intf_pins rp_slr1/M_AXI7_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI6]
  connect_bd_intf_net -intf_net S_AXI7_2 [get_bd_intf_pins rp_slr2/M_AXI7_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI7]
  connect_bd_intf_net -intf_net S_AXI7_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI7_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI7]
  connect_bd_intf_net -intf_net S_AXI7_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI7_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI8]
  connect_bd_intf_net -intf_net S_AXI7_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI7_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI7]
  connect_bd_intf_net -intf_net S_AXI8_1 [get_bd_intf_pins rp_slr2/M_AXI8_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI8]
  connect_bd_intf_net -intf_net S_AXI8_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXI8_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI8]
  connect_bd_intf_net -intf_net S_AXI8_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXI8_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI9]
  connect_bd_intf_net -intf_net S_AXI9_1 [get_bd_intf_pins rp_slr1/M_AXI9_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI8]
  connect_bd_intf_net -intf_net S_AXI9_2 [get_bd_intf_pins rp_slr2/M_AXI9_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI9]
  connect_bd_intf_net -intf_net S_AXI9_SLR01_1 [get_bd_intf_pins rp_slr0/S_AXI9_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI9]
  connect_bd_intf_net -intf_net S_AXI9_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXI9_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXI10]
  connect_bd_intf_net -intf_net S_AXI9_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXI9_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI9]
  connect_bd_intf_net -intf_net S_AXIS0_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS0_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS0_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS0_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS]
  connect_bd_intf_net -intf_net S_AXIS10_1 [get_bd_intf_pins rp_slr1/M_AXIS10_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS10]
  connect_bd_intf_net -intf_net S_AXIS10_2 [get_bd_intf_pins rp_slr2/M_AXIS10_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS10]
  connect_bd_intf_net -intf_net S_AXIS10_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS10_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS10]
  connect_bd_intf_net -intf_net S_AXIS10_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS10_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS10]
  connect_bd_intf_net -intf_net S_AXIS10_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS10_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS1]
  connect_bd_intf_net -intf_net S_AXIS10_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXIS10_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS10]
  connect_bd_intf_net -intf_net S_AXIS11_1 [get_bd_intf_pins rp_slr2/M_AXIS11_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS11]
  connect_bd_intf_net -intf_net S_AXIS11_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS11_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS11]
  connect_bd_intf_net -intf_net S_AXIS11_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS11_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS2]
  connect_bd_intf_net -intf_net S_AXIS11_SLR12_2 [get_bd_intf_pins rp_slr1/S_AXIS11_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS11]
  connect_bd_intf_net -intf_net S_AXIS12_1 [get_bd_intf_pins rp_slr1/M_AXIS12_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS12]
  connect_bd_intf_net -intf_net S_AXIS12_2 [get_bd_intf_pins rp_slr2/M_AXIS12_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS12]
  connect_bd_intf_net -intf_net S_AXIS12_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS12_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS12]
  connect_bd_intf_net -intf_net S_AXIS12_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS12_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS12]
  connect_bd_intf_net -intf_net S_AXIS12_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS12_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS3]
  connect_bd_intf_net -intf_net S_AXIS13_1 [get_bd_intf_pins rp_slr0/M_AXIS15_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS13]
  connect_bd_intf_net -intf_net S_AXIS13_2 [get_bd_intf_pins rp_slr2/M_AXIS13_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS13]
  connect_bd_intf_net -intf_net S_AXIS13_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS13_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS13]
  connect_bd_intf_net -intf_net S_AXIS13_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS13_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS4]
  connect_bd_intf_net -intf_net S_AXIS13_SLR12_2 [get_bd_intf_pins rp_slr1/S_AXIS13_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS13]
  connect_bd_intf_net -intf_net S_AXIS14_1 [get_bd_intf_pins rp_slr1/M_AXIS14_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS14]
  connect_bd_intf_net -intf_net S_AXIS14_2 [get_bd_intf_pins rp_slr2/M_AXIS14_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS14]
  connect_bd_intf_net -intf_net S_AXIS14_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS14_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS14]
  connect_bd_intf_net -intf_net S_AXIS14_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS14_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS14]
  connect_bd_intf_net -intf_net S_AXIS14_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS14_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS5]
  connect_bd_intf_net -intf_net S_AXIS15_1 [get_bd_intf_pins rp_slr2/M_AXIS15_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS15]
  connect_bd_intf_net -intf_net S_AXIS15_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS15_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS15]
  connect_bd_intf_net -intf_net S_AXIS15_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS15_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS6]
  connect_bd_intf_net -intf_net S_AXIS15_SLR12_2 [get_bd_intf_pins rp_slr1/S_AXIS15_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS15]
  connect_bd_intf_net -intf_net S_AXIS1_1 [get_bd_intf_pins rp_slr2/M_AXIS1_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS1]
  connect_bd_intf_net -intf_net S_AXIS1_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS1_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS1]
  connect_bd_intf_net -intf_net S_AXIS1_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS1_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS7]
  connect_bd_intf_net -intf_net S_AXIS1_SLR12_2 [get_bd_intf_pins rp_slr1/S_AXIS1_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS1]
  connect_bd_intf_net -intf_net S_AXIS1_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXIS1_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS1]
  connect_bd_intf_net -intf_net S_AXIS2_1 [get_bd_intf_pins rp_slr1/M_AXIS2_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS2]
  connect_bd_intf_net -intf_net S_AXIS2_2 [get_bd_intf_pins rp_slr2/M_AXIS2_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS2]
  connect_bd_intf_net -intf_net S_AXIS2_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS2_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS2]
  connect_bd_intf_net -intf_net S_AXIS2_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS2_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS2]
  connect_bd_intf_net -intf_net S_AXIS2_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS2_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS8]
  connect_bd_intf_net -intf_net S_AXIS3_1 [get_bd_intf_pins rp_slr2/M_AXIS3_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS3]
  connect_bd_intf_net -intf_net S_AXIS3_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS3_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS3]
  connect_bd_intf_net -intf_net S_AXIS3_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXIS3_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS3]
  connect_bd_intf_net -intf_net S_AXIS3_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXIS3_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS9]
  connect_bd_intf_net -intf_net S_AXIS3_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXIS3_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS3]
  connect_bd_intf_net -intf_net S_AXIS4_1 [get_bd_intf_pins rp_slr1/M_AXIS4_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS4]
  connect_bd_intf_net -intf_net S_AXIS4_2 [get_bd_intf_pins rp_slr2/M_AXIS4_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS4]
  connect_bd_intf_net -intf_net S_AXIS4_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS4_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS4]
  connect_bd_intf_net -intf_net S_AXIS4_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS4_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS4]
  connect_bd_intf_net -intf_net S_AXIS4_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS4_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS10]
  connect_bd_intf_net -intf_net S_AXIS5_1 [get_bd_intf_pins rp_slr2/M_AXIS5_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS5]
  connect_bd_intf_net -intf_net S_AXIS5_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS5_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS5]
  connect_bd_intf_net -intf_net S_AXIS5_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXIS5_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS5]
  connect_bd_intf_net -intf_net S_AXIS5_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXIS5_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS11]
  connect_bd_intf_net -intf_net S_AXIS5_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXIS5_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS5]
  connect_bd_intf_net -intf_net S_AXIS6_1 [get_bd_intf_pins rp_slr1/M_AXIS6_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS6]
  connect_bd_intf_net -intf_net S_AXIS6_2 [get_bd_intf_pins rp_slr2/M_AXIS6_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS6]
  connect_bd_intf_net -intf_net S_AXIS6_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS6_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS6]
  connect_bd_intf_net -intf_net S_AXIS6_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS6_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS6]
  connect_bd_intf_net -intf_net S_AXIS6_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS6_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS12]
  connect_bd_intf_net -intf_net S_AXIS7_1 [get_bd_intf_pins rp_slr2/M_AXIS7_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS7]
  connect_bd_intf_net -intf_net S_AXIS7_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS7_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS7]
  connect_bd_intf_net -intf_net S_AXIS7_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXIS7_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS7]
  connect_bd_intf_net -intf_net S_AXIS7_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXIS7_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS13]
  connect_bd_intf_net -intf_net S_AXIS7_SLR23_1 [get_bd_intf_pins rp_slr2/S_AXIS7_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS7]
  connect_bd_intf_net -intf_net S_AXIS8_1 [get_bd_intf_pins rp_slr1/M_AXIS8_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS8]
  connect_bd_intf_net -intf_net S_AXIS8_2 [get_bd_intf_pins rp_slr2/M_AXIS8_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS8]
  connect_bd_intf_net -intf_net S_AXIS8_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS8_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS8]
  connect_bd_intf_net -intf_net S_AXIS8_SLR01_2 [get_bd_intf_pins rp_slr0/S_AXIS8_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS8]
  connect_bd_intf_net -intf_net S_AXIS8_SLR12_1 [get_bd_intf_pins rp_slr2/S_AXIS8_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS14]
  connect_bd_intf_net -intf_net S_AXIS9_1 [get_bd_intf_pins rp_slr2/M_AXIS9_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS9]
  connect_bd_intf_net -intf_net S_AXIS9_SLR01_1 [get_bd_intf_pins rp_slr1/S_AXIS9_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXIS9]
  connect_bd_intf_net -intf_net S_AXIS9_SLR12_1 [get_bd_intf_pins rp_slr1/S_AXIS9_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS9]
  connect_bd_intf_net -intf_net S_AXIS9_SLR12_2 [get_bd_intf_pins rp_slr2/S_AXIS9_SLR12] [get_bd_intf_pins slr1_to_2_crossing/M_AXIS15]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins rp_slr1/M_AXIS0_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS_2 [get_bd_intf_pins rp_slr2/M_AXIS0_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins rp_slr2/M_AXI0_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_2 [get_bd_intf_pins rp_slr3/M_AXI0_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI]
  connect_bd_intf_net -intf_net S_BSCAN_0_1 [get_bd_intf_pins rp_slr1/S_BSCAN_0] [get_bd_intf_pins static_region/m1_bscan]
  connect_bd_intf_net -intf_net S_BSCAN_0_2 [get_bd_intf_pins rp_slr3/S_BSCAN_0] [get_bd_intf_pins static_region/m3_bscan]
  connect_bd_intf_net -intf_net S_BSCAN_0_3 [get_bd_intf_pins rp_slr0/S_BSCAN_0] [get_bd_intf_pins static_region/m0_bscan]
  connect_bd_intf_net -intf_net S_BSCAN_0_4 [get_bd_intf_pins rp_slr2/S_BSCAN_0] [get_bd_intf_pins static_region/m2_bscan]
  connect_bd_intf_net -intf_net axi_register_slice_13_M_AXI [get_bd_intf_pins rp_slr0/S_AXI6_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI6]
  connect_bd_intf_net -intf_net axi_register_slice_17_M_AXI [get_bd_intf_pins rp_slr0/S_AXI8_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI8]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins rp_slr1/S_AXI0_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI1 [get_bd_intf_pins rp_slr1/S_AXI1_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI1]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI2 [get_bd_intf_pins rp_slr1/S_AXI2_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI2]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI3 [get_bd_intf_pins rp_slr1/S_AXI3_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI3]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI4 [get_bd_intf_pins rp_slr1/S_AXI4_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI4]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI5 [get_bd_intf_pins rp_slr1/S_AXI5_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI5]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI6 [get_bd_intf_pins rp_slr1/S_AXI6_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI6]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI7 [get_bd_intf_pins rp_slr1/S_AXI7_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI7]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI8 [get_bd_intf_pins rp_slr1/S_AXI8_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI8]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI9 [get_bd_intf_pins rp_slr1/S_AXI9_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI9]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI10 [get_bd_intf_pins rp_slr1/S_AXI10_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI10]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI11 [get_bd_intf_pins rp_slr1/S_AXI11_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI11]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI12 [get_bd_intf_pins rp_slr1/S_AXI12_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI12]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI13 [get_bd_intf_pins rp_slr1/S_AXI13_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI13]
  connect_bd_intf_net -intf_net axi_register_slice_21_M_AXI [get_bd_intf_pins rp_slr0/S_AXI10_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI10]
  connect_bd_intf_net -intf_net axi_register_slice_25_M_AXI [get_bd_intf_pins rp_slr0/S_AXI12_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI12]
  connect_bd_intf_net -intf_net axi_register_slice_29_M_AXI [get_bd_intf_pins rp_slr0/S_AXI14_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI14]
  connect_bd_intf_net -intf_net axi_register_slice_31_M_AXI [get_bd_intf_pins rp_slr1/S_AXI15_SLR01] [get_bd_intf_pins slr0_to_1_crossing/M_AXI15]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI [get_bd_intf_pins rp_slr0/S_AXI2_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI2]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI [get_bd_intf_pins rp_slr0/S_AXI4_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXI4]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins rp_slr0/M_AXI0_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_11_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS5_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS5]
  connect_bd_intf_net -intf_net axis_register_slice_15_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS7_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS7]
  connect_bd_intf_net -intf_net axis_register_slice_19_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS9_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS9]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS0_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_23_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS11_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS11]
  connect_bd_intf_net -intf_net axis_register_slice_27_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS13_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS13]
  connect_bd_intf_net -intf_net axis_register_slice_31_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS15_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS15]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS1_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS1]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS [get_bd_intf_pins rp_slr0/S_AXIS3_SLR01] [get_bd_intf_pins slr1_to_0_crossing/M_AXIS3]
  connect_bd_intf_net -intf_net clock_qdma_slr1_0_1 [get_bd_intf_ports clock_qdma_slr1] [get_bd_intf_pins rp_slr1/clock_qdma_slr1]
  connect_bd_intf_net -intf_net clock_qdma_slr2_0_1 [get_bd_intf_ports clock_qdma_slr2] [get_bd_intf_pins rp_slr2/clock_qdma_slr2]
  connect_bd_intf_net -intf_net rp_slr0_C0_DDR4_0 [get_bd_intf_ports C0_DDR4_SLR0] [get_bd_intf_pins rp_slr0/C0_DDR4_0]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI10_SLR01 [get_bd_intf_pins rp_slr0/M_AXI10_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI10]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI11_SLR01 [get_bd_intf_pins rp_slr0/M_AXI11_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI11]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI12_SLR01 [get_bd_intf_pins rp_slr0/M_AXI12_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI12]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI13_SLR01 [get_bd_intf_pins rp_slr0/M_AXI13_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI13]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI14_SLR01 [get_bd_intf_pins rp_slr0/M_AXI14_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI14]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI15_SLR01 [get_bd_intf_pins rp_slr0/M_AXI15_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI15]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI1_SLR01 [get_bd_intf_pins rp_slr0/M_AXI1_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI1]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI2_SLR01 [get_bd_intf_pins rp_slr0/M_AXI2_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI2]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI3_SLR01 [get_bd_intf_pins rp_slr0/M_AXI3_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI3]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI4_SLR01 [get_bd_intf_pins rp_slr0/M_AXI4_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI4]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI5_SLR01 [get_bd_intf_pins rp_slr0/M_AXI5_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI5]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI6_SLR01 [get_bd_intf_pins rp_slr0/M_AXI6_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI6]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI7_SLR01 [get_bd_intf_pins rp_slr0/M_AXI7_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI7]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI8_SLR01 [get_bd_intf_pins rp_slr0/M_AXI8_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI8]
  connect_bd_intf_net -intf_net rp_slr0_M_AXI9_SLR01 [get_bd_intf_pins rp_slr0/M_AXI9_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXI9]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS0_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS0_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS10_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS10_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS10]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS11_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS11_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS11]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS12_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS12_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS12]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS13_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS13_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS15]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS14_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS14_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS14]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS1_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS1_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS1]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS2_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS2_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS2]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS3_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS3_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS3]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS4_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS4_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS4]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS5_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS5_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS5]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS6_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS6_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS6]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS7_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS7_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS7]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS8_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS8_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS8]
  connect_bd_intf_net -intf_net rp_slr0_M_AXIS9_SLR01 [get_bd_intf_pins rp_slr0/M_AXIS9_SLR01] [get_bd_intf_pins slr0_to_1_crossing/S_AXIS9]
  connect_bd_intf_net -intf_net rp_slr1_C0_DDR4_0 [get_bd_intf_ports C0_DDR4_SLR1] [get_bd_intf_pins rp_slr1/C0_DDR4_0]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI0_SLR01 [get_bd_intf_pins rp_slr1/M_AXI0_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI0_SLR12 [get_bd_intf_pins rp_slr1/M_AXI0_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI15]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI10_SLR01 [get_bd_intf_pins rp_slr1/M_AXI10_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI10]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI10_SLR12 [get_bd_intf_pins rp_slr1/M_AXI10_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI9]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI11_SLR01 [get_bd_intf_pins rp_slr1/M_AXI11_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI11]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI12_SLR01 [get_bd_intf_pins rp_slr1/M_AXI12_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI12]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI12_SLR12 [get_bd_intf_pins rp_slr1/M_AXI12_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI11]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI13_SLR01 [get_bd_intf_pins rp_slr1/M_AXI13_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI13]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI14_SLR01 [get_bd_intf_pins rp_slr1/M_AXI14_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI14]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI14_SLR12 [get_bd_intf_pins rp_slr1/M_AXI14_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI13]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI15_SLR01 [get_bd_intf_pins rp_slr1/M_AXI15_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI15]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI1_SLR01 [get_bd_intf_pins rp_slr1/M_AXI1_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI1]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI2_SLR01 [get_bd_intf_pins rp_slr1/M_AXI2_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI2]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI2_SLR12 [get_bd_intf_pins rp_slr1/M_AXI2_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI1]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI3_SLR01 [get_bd_intf_pins rp_slr1/M_AXI3_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI3]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI4_SLR01 [get_bd_intf_pins rp_slr1/M_AXI4_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI4]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI4_SLR12 [get_bd_intf_pins rp_slr1/M_AXI4_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI3]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI5_SLR01 [get_bd_intf_pins rp_slr1/M_AXI5_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI5]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI6_SLR01 [get_bd_intf_pins rp_slr1/M_AXI6_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI6]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI6_SLR12 [get_bd_intf_pins rp_slr1/M_AXI6_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI5]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI7_SLR01 [get_bd_intf_pins rp_slr1/M_AXI7_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI7]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI8_SLR01 [get_bd_intf_pins rp_slr1/M_AXI8_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI8]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI8_SLR12 [get_bd_intf_pins rp_slr1/M_AXI8_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXI7]
  connect_bd_intf_net -intf_net rp_slr1_M_AXI9_SLR01 [get_bd_intf_pins rp_slr1/M_AXI9_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXI9]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS0_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS0_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS10_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS10_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS10]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS11_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS11_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS11]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS11_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS11_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS11]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS12_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS12_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS12]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS13_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS13_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS13]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS13_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS13_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS15]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS14_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS14_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS14]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS15_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS15_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS15]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS15_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS15_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS13]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS1_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS1_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS1]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS1_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS1_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS1]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS2_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS2_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS2]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS3_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS3_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS3]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS3_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS3_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS3]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS4_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS4_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS4]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS5_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS5_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS5]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS5_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS5_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS5]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS6_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS6_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS6]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS7_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS7_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS7]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS7_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS7_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS7]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS8_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS8_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS8]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS9_SLR01 [get_bd_intf_pins rp_slr1/M_AXIS9_SLR01] [get_bd_intf_pins slr1_to_0_crossing/S_AXIS9]
  connect_bd_intf_net -intf_net rp_slr1_M_AXIS9_SLR12 [get_bd_intf_pins rp_slr1/M_AXIS9_SLR12] [get_bd_intf_pins slr1_to_2_crossing/S_AXIS9]
  connect_bd_intf_net -intf_net rp_slr1_pcie_7x_mgt_rtl_0 [get_bd_intf_ports pcie_7x_mgt_rtl_SLR1] [get_bd_intf_pins rp_slr1/pcie_7x_mgt_rtl_0]
  connect_bd_intf_net -intf_net rp_slr2_C0_DDR4_0 [get_bd_intf_ports C0_DDR4_SLR2] [get_bd_intf_pins rp_slr2/C0_DDR4_0]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI0_SLR12 [get_bd_intf_pins rp_slr2/M_AXI0_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI10_SLR12 [get_bd_intf_pins rp_slr2/M_AXI10_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI10]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI11_SLR23 [get_bd_intf_pins rp_slr2/M_AXI11_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI11]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI12_SLR12 [get_bd_intf_pins rp_slr2/M_AXI12_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI12]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI13_SLR23 [get_bd_intf_pins rp_slr2/M_AXI13_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI13]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI14_SLR12 [get_bd_intf_pins rp_slr2/M_AXI14_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI14]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI15_SLR23 [get_bd_intf_pins rp_slr2/M_AXI15_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI15]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI1_SLR23 [get_bd_intf_pins rp_slr2/M_AXI1_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI1]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI2_SLR12 [get_bd_intf_pins rp_slr2/M_AXI2_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI2]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI3_SLR23 [get_bd_intf_pins rp_slr2/M_AXI3_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI3]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI4_SLR12 [get_bd_intf_pins rp_slr2/M_AXI4_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI4]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI5_SLR23 [get_bd_intf_pins rp_slr2/M_AXI5_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI5]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI6_SLR12 [get_bd_intf_pins rp_slr2/M_AXI6_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI6]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI7_SLR23 [get_bd_intf_pins rp_slr2/M_AXI7_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI7]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI8_SLR12 [get_bd_intf_pins rp_slr2/M_AXI8_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXI8]
  connect_bd_intf_net -intf_net rp_slr2_M_AXI9_SLR23 [get_bd_intf_pins rp_slr2/M_AXI9_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXI9]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS0_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS0_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS10_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS10_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS10]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS11_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS11_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS11]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS12_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS12_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS12]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS13_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS13_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS13]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS14_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS14_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS14]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS15_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS15_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS15]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS1_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS1_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS1]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS2_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS2_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS2]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS3_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS3_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS3]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS4_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS4_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS4]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS5_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS5_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS5]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS6_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS6_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS6]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS7_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS7_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS7]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS8_SLR12 [get_bd_intf_pins rp_slr2/M_AXIS8_SLR12] [get_bd_intf_pins slr2_to_1_crossing/S_AXIS8]
  connect_bd_intf_net -intf_net rp_slr2_M_AXIS9_SLR23 [get_bd_intf_pins rp_slr2/M_AXIS9_SLR23] [get_bd_intf_pins slr2_to_3_crossing/S_AXIS9]
  connect_bd_intf_net -intf_net rp_slr2_pcie_7x_mgt_rtl_0 [get_bd_intf_ports pcie_7x_mgt_rtl_SLR2] [get_bd_intf_pins rp_slr2/pcie_7x_mgt_rtl_0]
  connect_bd_intf_net -intf_net rp_slr3_C0_DDR4_0 [get_bd_intf_ports C0_DDR4_SLR3] [get_bd_intf_pins rp_slr3/C0_DDR4_0]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI10_SLR23 [get_bd_intf_pins rp_slr3/M_AXI10_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI10]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI11_SLR23 [get_bd_intf_pins rp_slr3/M_AXI11_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI11]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI12_SLR23 [get_bd_intf_pins rp_slr3/M_AXI12_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI12]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI13_SLR23 [get_bd_intf_pins rp_slr3/M_AXI13_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI13]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI14_SLR23 [get_bd_intf_pins rp_slr3/M_AXI14_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI14]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI15_SLR23 [get_bd_intf_pins rp_slr3/M_AXI15_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI15]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI1_SLR23 [get_bd_intf_pins rp_slr3/M_AXI1_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI1]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI2_SLR23 [get_bd_intf_pins rp_slr3/M_AXI2_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI2]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI3_SLR23 [get_bd_intf_pins rp_slr3/M_AXI3_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI3]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI4_SLR23 [get_bd_intf_pins rp_slr3/M_AXI4_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI4]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI5_SLR23 [get_bd_intf_pins rp_slr3/M_AXI5_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI5]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI6_SLR23 [get_bd_intf_pins rp_slr3/M_AXI6_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI6]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI7_SLR23 [get_bd_intf_pins rp_slr3/M_AXI7_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI7]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI8_SLR23 [get_bd_intf_pins rp_slr3/M_AXI8_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI8]
  connect_bd_intf_net -intf_net rp_slr3_M_AXI9_SLR23 [get_bd_intf_pins rp_slr3/M_AXI9_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXI9]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS0_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS0_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS10_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS10_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS10]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS11_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS11_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS11]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS12_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS12_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS12]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS13_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS13_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS13]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS14_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS14_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS14]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS15_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS15_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS15]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS1_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS1_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS1]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS2_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS2_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS2]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS3_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS3_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS3]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS4_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS4_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS4]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS5_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS5_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS5]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS6_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS6_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS6]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS7_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS7_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS7]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS8_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS8_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS8]
  connect_bd_intf_net -intf_net rp_slr3_M_AXIS9_SLR23 [get_bd_intf_pins rp_slr3/M_AXIS9_SLR23] [get_bd_intf_pins slr3_to_2_crossing/S_AXIS9]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI1 [get_bd_intf_pins rp_slr1/S_AXI1_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI1]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI3 [get_bd_intf_pins rp_slr1/S_AXI3_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI3]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI5 [get_bd_intf_pins rp_slr1/S_AXI5_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI5]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI7 [get_bd_intf_pins rp_slr1/S_AXI7_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI7]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI9 [get_bd_intf_pins rp_slr1/S_AXI9_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI9]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI11 [get_bd_intf_pins rp_slr1/S_AXI11_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI11]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI13 [get_bd_intf_pins rp_slr1/S_AXI13_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI13]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXI15 [get_bd_intf_pins rp_slr1/S_AXI15_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXI15]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS [get_bd_intf_pins rp_slr1/S_AXIS0_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS2 [get_bd_intf_pins rp_slr1/S_AXIS2_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS2]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS4 [get_bd_intf_pins rp_slr1/S_AXIS4_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS4]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS6 [get_bd_intf_pins rp_slr1/S_AXIS6_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS6]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS8 [get_bd_intf_pins rp_slr1/S_AXIS8_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS8]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS10 [get_bd_intf_pins rp_slr1/S_AXIS10_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS10]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS12 [get_bd_intf_pins rp_slr1/S_AXIS12_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS12]
  connect_bd_intf_net -intf_net slr2_to_1_crossing_M_AXIS14 [get_bd_intf_pins rp_slr1/S_AXIS14_SLR12] [get_bd_intf_pins slr2_to_1_crossing/M_AXIS14]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI [get_bd_intf_pins rp_slr3/S_AXI0_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI1 [get_bd_intf_pins rp_slr3/S_AXI1_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI1]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI2 [get_bd_intf_pins rp_slr3/S_AXI2_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI2]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI3 [get_bd_intf_pins rp_slr3/S_AXI3_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI3]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI4 [get_bd_intf_pins rp_slr3/S_AXI4_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI4]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI5 [get_bd_intf_pins rp_slr3/S_AXI5_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI5]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI6 [get_bd_intf_pins rp_slr3/S_AXI6_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI6]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI7 [get_bd_intf_pins rp_slr3/S_AXI7_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI7]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI8 [get_bd_intf_pins rp_slr3/S_AXI8_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI8]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI9 [get_bd_intf_pins rp_slr3/S_AXI9_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI9]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI10 [get_bd_intf_pins rp_slr3/S_AXI10_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI10]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI11 [get_bd_intf_pins rp_slr3/S_AXI11_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI11]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI12 [get_bd_intf_pins rp_slr3/S_AXI12_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI12]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI13 [get_bd_intf_pins rp_slr3/S_AXI13_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI13]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI14 [get_bd_intf_pins rp_slr3/S_AXI14_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI14]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXI15 [get_bd_intf_pins rp_slr3/S_AXI15_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXI15]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS [get_bd_intf_pins rp_slr3/S_AXIS0_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS1 [get_bd_intf_pins rp_slr3/S_AXIS1_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS1]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS2 [get_bd_intf_pins rp_slr3/S_AXIS2_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS2]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS3 [get_bd_intf_pins rp_slr3/S_AXIS3_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS3]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS4 [get_bd_intf_pins rp_slr3/S_AXIS4_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS4]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS5 [get_bd_intf_pins rp_slr3/S_AXIS5_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS5]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS6 [get_bd_intf_pins rp_slr3/S_AXIS6_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS6]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS7 [get_bd_intf_pins rp_slr3/S_AXIS7_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS7]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS8 [get_bd_intf_pins rp_slr3/S_AXIS8_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS8]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS9 [get_bd_intf_pins rp_slr3/S_AXIS9_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS9]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS10 [get_bd_intf_pins rp_slr3/S_AXIS10_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS10]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS11 [get_bd_intf_pins rp_slr3/S_AXIS11_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS11]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS12 [get_bd_intf_pins rp_slr3/S_AXIS12_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS12]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS13 [get_bd_intf_pins rp_slr3/S_AXIS13_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS13]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS14 [get_bd_intf_pins rp_slr3/S_AXIS14_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS14]
  connect_bd_intf_net -intf_net slr2_to_3_crossing_M_AXIS15 [get_bd_intf_pins rp_slr3/S_AXIS15_SLR23] [get_bd_intf_pins slr2_to_3_crossing/M_AXIS15]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI [get_bd_intf_pins rp_slr2/S_AXI0_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI2 [get_bd_intf_pins rp_slr2/S_AXI2_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI2]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI4 [get_bd_intf_pins rp_slr2/S_AXI4_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI4]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI6 [get_bd_intf_pins rp_slr2/S_AXI6_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI6]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI8 [get_bd_intf_pins rp_slr2/S_AXI8_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI8]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI10 [get_bd_intf_pins rp_slr2/S_AXI10_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI10]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI12 [get_bd_intf_pins rp_slr2/S_AXI12_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI12]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXI14 [get_bd_intf_pins rp_slr2/S_AXI14_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXI14]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS [get_bd_intf_pins rp_slr2/S_AXIS0_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS2 [get_bd_intf_pins rp_slr2/S_AXIS2_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS2]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS4 [get_bd_intf_pins rp_slr2/S_AXIS4_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS4]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS6 [get_bd_intf_pins rp_slr2/S_AXIS6_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS6]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS8 [get_bd_intf_pins rp_slr2/S_AXIS8_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS8]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS9 [get_bd_intf_pins rp_slr2/S_AXIS9_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS9]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS11 [get_bd_intf_pins rp_slr2/S_AXIS11_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS11]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS12 [get_bd_intf_pins rp_slr2/S_AXIS12_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS12]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS13 [get_bd_intf_pins rp_slr2/S_AXIS13_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS13]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS14 [get_bd_intf_pins rp_slr2/S_AXIS14_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS14]
  connect_bd_intf_net -intf_net slr3_to_2_crossing_M_AXIS15 [get_bd_intf_pins rp_slr2/S_AXIS15_SLR23] [get_bd_intf_pins slr3_to_2_crossing/M_AXIS15]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins rp_slr1/s_axis_aresetn] [get_bd_pins slr0_to_1_crossing/aresetn] [get_bd_pins slr1_to_0_crossing/aresetn] [get_bd_pins static_region/peripheral_aresetn1]
  connect_bd_net -net aresetn_2 [get_bd_pins rp_slr2/s_axis_aresetn] [get_bd_pins slr1_to_2_crossing/aresetn] [get_bd_pins slr2_to_1_crossing/aresetn] [get_bd_pins static_region/peripheral_aresetn2]
  connect_bd_net -net aresetn_3 [get_bd_pins rp_slr3/s_axis_aresetn] [get_bd_pins slr2_to_3_crossing/aresetn] [get_bd_pins slr3_to_2_crossing/aresetn] [get_bd_pins static_region/peripheral_aresetn3]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins static_region/clk_in1_0]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins rp_slr0/s_axi_aclk] [get_bd_pins rp_slr1/s_axi_aclk] [get_bd_pins rp_slr2/s_axi_aclk] [get_bd_pins rp_slr3/s_axi_aclk] [get_bd_pins slr0_to_1_crossing/aclk] [get_bd_pins slr1_to_0_crossing/aclk] [get_bd_pins slr1_to_2_crossing/aclk] [get_bd_pins slr2_to_1_crossing/aclk] [get_bd_pins slr2_to_3_crossing/aclk] [get_bd_pins slr3_to_2_crossing/aclk] [get_bd_pins static_region/slowest_sync_clk]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_ports ext_reset_in_0] [get_bd_pins static_region/ext_reset_in_0]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins rp_slr0/s_axis_aresetn] [get_bd_pins static_region/peripheral_aresetn]

  # Create address segments
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_16/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_26/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_27/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_28/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_29/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_30/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_31/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_17/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_18/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_19/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_20/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_21/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_22/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_6/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_23/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_7/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_24/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_8/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr0/axi_vip_25/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_9/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_16/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_26/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_27/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_28/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_29/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_30/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_31/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_17/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_18/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_40/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_32/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_41/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_33/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_51/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_34/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_52/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_35/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_53/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_36/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_54/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_37/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_56/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_38/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_57/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_39/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_19/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_42/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_44/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_20/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_43/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_55/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_45/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_58/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_46/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_59/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_21/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_47/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_60/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_48/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_61/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_49/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_62/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_50/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_63/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_22/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_6/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_23/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_7/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_24/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_8/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr1/axi_vip_25/Master_AXI] [get_bd_addr_segs rp_slr0/axi_vip_9/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_16/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_26/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_27/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_28/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_29/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_30/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_31/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_17/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_18/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_40/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_32/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_41/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_33/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_51/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_34/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_52/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_35/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_53/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_36/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_54/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_37/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_56/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_38/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_57/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_39/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_19/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_42/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_44/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_20/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_43/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_55/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_45/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_58/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_46/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_59/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_21/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_47/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_60/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_48/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_61/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_49/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_62/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_50/Master_AXI] [get_bd_addr_segs rp_slr1/axi_vip_63/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_22/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_6/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_23/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_7/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_24/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_8/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr2/axi_vip_25/Master_AXI] [get_bd_addr_segs rp_slr3/axi_vip_9/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_16/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_26/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_27/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_28/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_29/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_30/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_31/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_17/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_18/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_19/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_20/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_21/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_22/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_6/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_23/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_7/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_24/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_8/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces rp_slr3/axi_vip_25/Master_AXI] [get_bd_addr_segs rp_slr2/axi_vip_9/S_AXI/Reg] -force


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



