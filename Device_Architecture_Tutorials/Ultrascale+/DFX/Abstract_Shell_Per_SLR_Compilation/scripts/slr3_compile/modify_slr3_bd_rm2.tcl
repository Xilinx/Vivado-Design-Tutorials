
delete_bd_objs [get_bd_cells ]
delete_bd_objs [get_bd_intf_nets]
################################################################
# This is a generated script based on design: rp_slr3
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
# source rp_slr3_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu13p-fhga2104-3-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name rp_slr3

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
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_cdma:4.1\
xilinx.com:ip:axi_data_fifo:2.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_mcdma:1.1\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:axi_timebase_wdt:3.0\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_traffic_gen:3.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:debug_bridge:3.0\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
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


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CTRL

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CTRL1


  # Create pins
  create_bd_pin -dir O -type intr DLMB_Interrupt
  create_bd_pin -dir O -type intr ILMB_Interrupt
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst
  create_bd_pin -dir I -type rst S_AXI_CTRL_ARESETN

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_CE_COUNTER_WIDTH {20} \
   CONFIG.C_CE_FAILING_REGISTERS {1} \
   CONFIG.C_ECC {1} \
   CONFIG.C_ECC_ONOFF_REGISTER {1} \
   CONFIG.C_ECC_STATUS_REGISTERS {1} \
   CONFIG.C_FAULT_INJECT {1} \
   CONFIG.C_INTERCONNECT {2} \
   CONFIG.C_UE_FAILING_REGISTERS {1} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_CE_COUNTER_WIDTH {20} \
   CONFIG.C_CE_FAILING_REGISTERS {1} \
   CONFIG.C_ECC {1} \
   CONFIG.C_ECC_ONOFF_REGISTER {1} \
   CONFIG.C_ECC_STATUS_REGISTERS {1} \
   CONFIG.C_INTERCONNECT {2} \
   CONFIG.C_UE_FAILING_REGISTERS {1} \
   CONFIG.C_WRITE_ACCESS {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_axi [get_bd_intf_pins S_AXI_CTRL] [get_bd_intf_pins dlmb_bram_if_cntlr/S_AXI_CTRL]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_axi [get_bd_intf_pins S_AXI_CTRL1] [get_bd_intf_pins ilmb_bram_if_cntlr/S_AXI_CTRL]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net S_AXI_CTRL_ARESETN_1 [get_bd_pins S_AXI_CTRL_ARESETN] [get_bd_pins dlmb_bram_if_cntlr/S_AXI_CTRL_ARESETN] [get_bd_pins ilmb_bram_if_cntlr/S_AXI_CTRL_ARESETN]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/S_AXI_CTRL_ACLK] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/S_AXI_CTRL_ACLK] [get_bd_pins ilmb_v10/LMB_Clk]
  connect_bd_net -net microblaze_0_dlmb_int [get_bd_pins DLMB_Interrupt] [get_bd_pins dlmb_bram_if_cntlr/Interrupt]
  connect_bd_net -net microblaze_0_ilmb_int [get_bd_pins ILMB_Interrupt] [get_bd_pins ilmb_bram_if_cntlr/Interrupt]

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

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 axi_bram_ctrl_0_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
 ] $axi_bram_ctrl_0_bram

  # Create instance: axi_bram_ctrl_1, and set properties
  set axi_bram_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_1 ]

  # Create instance: axi_bram_ctrl_1_bram, and set properties
  set axi_bram_ctrl_1_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 axi_bram_ctrl_1_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
 ] $axi_bram_ctrl_1_bram

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_DRE {1} \
   CONFIG.C_INCLUDE_SF {1} \
 ] $axi_cdma_0

  # Create instance: axi_data_fifo_0, and set properties
  set axi_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_data_fifo:2.1 axi_data_fifo_0 ]
  set_property -dict [ list \
   CONFIG.READ_FIFO_DEPTH {512} \
   CONFIG.WRITE_FIFO_DEPTH {512} \
 ] $axi_data_fifo_0

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_enable_multi_channel {0} \
   CONFIG.c_micro_dma {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $axi_dma_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: axi_mcdma_0, and set properties
  set axi_mcdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_mcdma:1.1 axi_mcdma_0 ]
  set_property -dict [ list \
   CONFIG.c_group1_mm2s {0000000000000001} \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_num_mm2s_channels {1} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $axi_mcdma_0

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

  # Create instance: axi_timebase_wdt_0, and set properties
  set axi_timebase_wdt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timebase_wdt:3.0 axi_timebase_wdt_0 ]

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_timer_1, and set properties
  set axi_timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_1 ]

  # Create instance: axi_traffic_gen_0, and set properties
  set axi_traffic_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0 ]
  set_property -dict [ list \
   CONFIG.ATG_OPTIONS {Custom} \
 ] $axi_traffic_gen_0

  # Create instance: axi_traffic_gen_1, and set properties
  set axi_traffic_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_1 ]
  set_property -dict [ list \
   CONFIG.ATG_OPTIONS {High Level Traffic} \
   CONFIG.DATA_SIZE_AVG {16} \
   CONFIG.MASTER_AXI_WIDTH {64} \
   CONFIG.VIDEO_FRAME_RATE {75} \
   CONFIG.VIDEO_PIXEL_BITS {12} \
 ] $axi_traffic_gen_1

  # Create instance: axi_traffic_gen_2, and set properties
  set axi_traffic_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_2 ]
  set_property -dict [ list \
   CONFIG.ATG_HLT_STATIC_LENGTH {64} \
   CONFIG.ATG_OPTIONS {High Level Traffic} \
   CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {32} \
   CONFIG.DATA_SIZE_AVG {8} \
   CONFIG.DATA_SIZE_MAX {64} \
   CONFIG.MASTER_AXI_WIDTH {512} \
   CONFIG.PCIE_LANES {8} \
   CONFIG.PCIE_LANE_RATE {8} \
   CONFIG.PCIE_LOAD {50} \
   CONFIG.TRAFFIC_PROFILE {PCIe} \
   CONFIG.VIDEO_FRAME_RATE {75} \
   CONFIG.VIDEO_PIXEL_BITS {12} \
 ] $axi_traffic_gen_2

  # Create instance: axi_traffic_gen_3, and set properties
  set axi_traffic_gen_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_3 ]
  set_property -dict [ list \
   CONFIG.ATG_OPTIONS {High Level Traffic} \
   CONFIG.DATA_SIZE_AVG {16} \
   CONFIG.ETHERNET_LOAD {100} \
   CONFIG.MASTER_AXI_WIDTH {64} \
   CONFIG.TRAFFIC_PROFILE {Ethernet} \
   CONFIG.VIDEO_FRAME_RATE {75} \
   CONFIG.VIDEO_PIXEL_BITS {12} \
 ] $axi_traffic_gen_3

  # Create instance: axi_traffic_gen_4, and set properties
  set axi_traffic_gen_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_4 ]
  set_property -dict [ list \
   CONFIG.ATG_HLT_CH_SELECT {Write_Only} \
   CONFIG.ATG_OPTIONS {High Level Traffic} \
   CONFIG.C_ATG_REPEAT_TYPE {One_Shot} \
   CONFIG.DATA_SIZE_AVG {16} \
   CONFIG.MASTER_AXI_WIDTH {64} \
   CONFIG.TRAFFIC_PROFILE {USB} \
   CONFIG.USB_MODE {BULK} \
   CONFIG.VIDEO_FRAME_RATE {75} \
   CONFIG.VIDEO_PIXEL_BITS {12} \
 ] $axi_traffic_gen_4

  # Create instance: axi_traffic_gen_5, and set properties
  set axi_traffic_gen_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_5 ]
  set_property -dict [ list \
   CONFIG.ATG_HLT_CH_SELECT {Write_Only} \
   CONFIG.ATG_OPTIONS {High Level Traffic} \
   CONFIG.C_ATG_REPEAT_TYPE {One_Shot} \
   CONFIG.DATA_SIZE_AVG {16} \
   CONFIG.MASTER_AXI_WIDTH {64} \
   CONFIG.TRAFFIC_PROFILE {Data} \
   CONFIG.USB_MODE {BULK} \
   CONFIG.VIDEO_FRAME_RATE {75} \
   CONFIG.VIDEO_PIXEL_BITS {12} \
 ] $axi_traffic_gen_5

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_0 ]
  set_property -dict [ list \
   CONFIG.c_m_axi_mm2s_data_width {32} \
   CONFIG.c_mm2s_max_burst_length {16} \
   CONFIG.c_num_fstores {32} \
 ] $axi_vdma_0

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
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $axi_vip_16

  # Create instance: axis_interconnect_0, and set properties
  set axis_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_interconnect:2.1 axis_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
   CONFIG.NUM_SI {3} \
 ] $axis_interconnect_0

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

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {85.152} \
   CONFIG.CLKOUT1_PHASE_ERROR {78.266} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {4.750} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.750} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_1

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]

  # Create instance: debug_bridge_0, and set properties
  set debug_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:debug_bridge:3.0 debug_bridge_0 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_SIZE {32} \
   CONFIG.C_ADDR_TAG_BITS {1} \
   CONFIG.C_AREA_OPTIMIZED {2} \
   CONFIG.C_CACHE_BYTE_SIZE {65536} \
   CONFIG.C_DATA_SIZE {64} \
   CONFIG.C_DCACHE_ADDR_TAG {1} \
   CONFIG.C_DCACHE_BYTE_SIZE {65536} \
   CONFIG.C_DCACHE_LINE_LEN {16} \
   CONFIG.C_DCACHE_USE_WRITEBACK {0} \
   CONFIG.C_DEBUG_ENABLED {0} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ENABLE_DISCRETE_PORTS {0} \
   CONFIG.C_FSL_LINKS {1} \
   CONFIG.C_ICACHE_DATA_WIDTH {0} \
   CONFIG.C_ICACHE_LINE_LEN {16} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_MMU_DTLB_SIZE {2} \
   CONFIG.C_MMU_ITLB_SIZE {1} \
   CONFIG.C_MMU_ZONES {2} \
   CONFIG.C_USE_BARREL {1} \
   CONFIG.C_USE_BRANCH_TARGET_CACHE {1} \
   CONFIG.C_USE_DCACHE {1} \
   CONFIG.C_USE_DIV {1} \
   CONFIG.C_USE_EXTENDED_FSL_INSTR {0} \
   CONFIG.C_USE_FPU {1} \
   CONFIG.C_USE_HW_MUL {2} \
   CONFIG.C_USE_ICACHE {1} \
   CONFIG.C_USE_MMU {3} \
   CONFIG.C_USE_MSR_INSTR {1} \
   CONFIG.C_USE_PCMP_INSTR {1} \
   CONFIG.G_TEMPLATE_LIST {3} \
   CONFIG.G_USE_EXCEPTIONS {0} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
  set_property -dict [ list \
   CONFIG.C_HAS_FAST {1} \
 ] $microblaze_0_axi_intc

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {12} \
   CONFIG.NUM_SI {3} \
 ] $microblaze_0_axi_periph

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]

  # Create instance: rst_clk_wiz_1_250M, and set properties
  set rst_clk_wiz_1_250M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_250M ]

  # Create instance: rst_ddr4_0_333M, and set properties
  set rst_ddr4_0_333M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_333M ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {4} \
 ] $smartconnect_0

  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_2

  # Create instance: smartconnect_3, and set properties
  set smartconnect_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_3 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_3

  # Create instance: smartconnect_4, and set properties
  set smartconnect_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_4 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_4

  # Create instance: smartconnect_5, and set properties
  set smartconnect_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_5 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_5

  # Create instance: smartconnect_6, and set properties
  set smartconnect_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_6 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_6

  # Create instance: smartconnect_7, and set properties
  set smartconnect_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_7 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_7

  # Create instance: smartconnect_8, and set properties
  set smartconnect_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_8 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_8

  # Create instance: smartconnect_9, and set properties
  set smartconnect_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_9 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {2} \
 ] $smartconnect_9

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports C0_SYS_CLK_0] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net S00_AXIS_1 [get_bd_intf_pins axi_mcdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_interconnect_0/S00_AXIS]
  connect_bd_intf_net -intf_net S_AXI0_SLR23_1 [get_bd_intf_ports S_AXI0_SLR23] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net S_AXI10_SLR23_1 [get_bd_intf_ports S_AXI10_SLR23] [get_bd_intf_pins axi_register_slice_10/S_AXI]
  connect_bd_intf_net -intf_net S_AXI11_SLR23_1 [get_bd_intf_ports S_AXI11_SLR23] [get_bd_intf_pins axi_register_slice_11/S_AXI]
  connect_bd_intf_net -intf_net S_AXI12_SLR23_1 [get_bd_intf_ports S_AXI12_SLR23] [get_bd_intf_pins axi_register_slice_12/S_AXI]
  connect_bd_intf_net -intf_net S_AXI13_SLR23_1 [get_bd_intf_ports S_AXI13_SLR23] [get_bd_intf_pins axi_register_slice_13/S_AXI]
  connect_bd_intf_net -intf_net S_AXI14_SLR23_1 [get_bd_intf_ports S_AXI14_SLR23] [get_bd_intf_pins axi_register_slice_14/S_AXI]
  connect_bd_intf_net -intf_net S_AXI15_SLR23_1 [get_bd_intf_ports S_AXI15_SLR23] [get_bd_intf_pins axi_register_slice_15/S_AXI]
  connect_bd_intf_net -intf_net S_AXI1_SLR23_1 [get_bd_intf_ports S_AXI1_SLR23] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net S_AXI2_SLR23_1 [get_bd_intf_ports S_AXI2_SLR23] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net S_AXI3_SLR23_1 [get_bd_intf_ports S_AXI3_SLR23] [get_bd_intf_pins smartconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net S_AXI4_SLR23_1 [get_bd_intf_ports S_AXI4_SLR23] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net S_AXI5_SLR23_1 [get_bd_intf_ports S_AXI5_SLR23] [get_bd_intf_pins axi_register_slice_5/S_AXI]
  connect_bd_intf_net -intf_net S_AXI6_SLR23_1 [get_bd_intf_ports S_AXI6_SLR23] [get_bd_intf_pins axi_register_slice_6/S_AXI]
  connect_bd_intf_net -intf_net S_AXI7_SLR23_1 [get_bd_intf_ports S_AXI7_SLR23] [get_bd_intf_pins axi_register_slice_7/S_AXI]
  connect_bd_intf_net -intf_net S_AXI8_SLR23_1 [get_bd_intf_ports S_AXI8_SLR23] [get_bd_intf_pins axi_register_slice_8/S_AXI]
  connect_bd_intf_net -intf_net S_AXI9_SLR23_1 [get_bd_intf_ports S_AXI9_SLR23] [get_bd_intf_pins axi_register_slice_9/S_AXI]
  connect_bd_intf_net -intf_net S_AXIS0_SLR23_1 [get_bd_intf_ports S_AXIS0_SLR23] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS10_SLR23_1 [get_bd_intf_ports S_AXIS10_SLR23] [get_bd_intf_pins axis_register_slice_10/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS11_SLR23_1 [get_bd_intf_ports S_AXIS11_SLR23] [get_bd_intf_pins axis_register_slice_11/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS12_SLR23_1 [get_bd_intf_ports S_AXIS12_SLR23] [get_bd_intf_pins axis_register_slice_12/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS13_SLR23_1 [get_bd_intf_ports S_AXIS13_SLR23] [get_bd_intf_pins axis_register_slice_13/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS14_SLR23_1 [get_bd_intf_ports S_AXIS14_SLR23] [get_bd_intf_pins axis_register_slice_14/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS15_SLR23_1 [get_bd_intf_ports S_AXIS15_SLR23] [get_bd_intf_pins axis_register_slice_15/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS1_SLR23_1 [get_bd_intf_ports S_AXIS1_SLR23] [get_bd_intf_pins axis_register_slice_1/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS2_SLR23_1 [get_bd_intf_ports S_AXIS2_SLR23] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS3_SLR23_1 [get_bd_intf_ports S_AXIS3_SLR23] [get_bd_intf_pins axis_register_slice_3/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS4_SLR23_1 [get_bd_intf_ports S_AXIS4_SLR23] [get_bd_intf_pins axis_register_slice_4/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS5_SLR23_1 [get_bd_intf_ports S_AXIS5_SLR23] [get_bd_intf_pins axis_register_slice_5/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS6_SLR23_1 [get_bd_intf_ports S_AXIS6_SLR23] [get_bd_intf_pins axis_register_slice_6/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS7_SLR23_1 [get_bd_intf_ports S_AXIS7_SLR23] [get_bd_intf_pins axis_register_slice_7/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS8_SLR23_1 [get_bd_intf_ports S_AXIS8_SLR23] [get_bd_intf_pins axis_register_slice_8/S_AXIS]
  connect_bd_intf_net -intf_net S_AXIS9_SLR23_1 [get_bd_intf_ports S_AXIS9_SLR23] [get_bd_intf_pins axis_register_slice_9/S_AXIS]
  connect_bd_intf_net -intf_net S_BSCAN_0_1 [get_bd_intf_ports S_BSCAN_0] [get_bd_intf_pins debug_bridge_0/S_BSCAN]
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
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_1_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_1_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins smartconnect_6/S00_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI_SG [get_bd_intf_pins axi_cdma_0/M_AXI_SG] [get_bd_intf_pins smartconnect_6/S01_AXI]
  connect_bd_intf_net -intf_net axi_data_fifo_0_M_AXI [get_bd_intf_pins axi_data_fifo_0/M_AXI] [get_bd_intf_pins axi_vip_16/S_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_interconnect_0/S02_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_5/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_5/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins axi_dma_0/M_AXI_SG] [get_bd_intf_pins smartconnect_4/S01_AXI]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mcdma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_2/S01_AXI]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mcdma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_3/S00_AXI]
  connect_bd_intf_net -intf_net axi_mcdma_0_M_AXI_SG [get_bd_intf_pins axi_mcdma_0/M_AXI_SG] [get_bd_intf_pins smartconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_10_M_AXI [get_bd_intf_pins axi_register_slice_10/M_AXI] [get_bd_intf_pins axi_vip_10/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_11_M_AXI [get_bd_intf_pins axi_register_slice_11/M_AXI] [get_bd_intf_pins axi_vip_11/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_12_M_AXI [get_bd_intf_pins axi_register_slice_12/M_AXI] [get_bd_intf_pins axi_vip_12/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_13_M_AXI [get_bd_intf_pins axi_register_slice_13/M_AXI] [get_bd_intf_pins axi_vip_13/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_14_M_AXI [get_bd_intf_pins axi_register_slice_14/M_AXI] [get_bd_intf_pins axi_vip_14/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_15_M_AXI [get_bd_intf_pins axi_register_slice_15/M_AXI] [get_bd_intf_pins axi_vip_15/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI [get_bd_intf_pins axi_register_slice_4/M_AXI] [get_bd_intf_pins axi_vip_4/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_5_M_AXI [get_bd_intf_pins axi_register_slice_5/M_AXI] [get_bd_intf_pins axi_vip_5/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_6_M_AXI [get_bd_intf_pins axi_register_slice_6/M_AXI] [get_bd_intf_pins axi_vip_6/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_7_M_AXI [get_bd_intf_pins axi_register_slice_7/M_AXI] [get_bd_intf_pins axi_vip_7/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_8_M_AXI [get_bd_intf_pins axi_register_slice_8/M_AXI] [get_bd_intf_pins axi_vip_8/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_9_M_AXI [get_bd_intf_pins axi_register_slice_9/M_AXI] [get_bd_intf_pins axi_vip_9/S_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_0_M_AXI [get_bd_intf_pins axi_traffic_gen_0/M_AXI] [get_bd_intf_pins smartconnect_7/S01_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_1_M_AXI [get_bd_intf_pins axi_traffic_gen_1/M_AXI] [get_bd_intf_pins smartconnect_7/S00_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_2_M_AXI [get_bd_intf_pins axi_traffic_gen_2/M_AXI] [get_bd_intf_pins smartconnect_8/S00_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_3_M_AXI [get_bd_intf_pins axi_traffic_gen_3/M_AXI] [get_bd_intf_pins smartconnect_8/S01_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_4_M_AXI [get_bd_intf_pins axi_traffic_gen_4/M_AXI] [get_bd_intf_pins smartconnect_9/S01_AXI]
  connect_bd_intf_net -intf_net axi_traffic_gen_5_M_AXI [get_bd_intf_pins axi_traffic_gen_5/M_AXI] [get_bd_intf_pins smartconnect_9/S00_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_interconnect_0/S01_AXIS]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_3/S01_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_4/S00_AXI]
  connect_bd_intf_net -intf_net axis_interconnect_0_M00_AXIS [get_bd_intf_ports M_AXIS0_SLR23] [get_bd_intf_pins axis_interconnect_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_0_M01_AXIS [get_bd_intf_ports M_AXIS1_SLR23] [get_bd_intf_pins axis_interconnect_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_interconnect_0_M02_AXIS [get_bd_intf_ports M_AXIS2_SLR23] [get_bd_intf_pins axis_interconnect_0/M02_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axi4stream_vip_0/S_AXIS] [get_bd_intf_pins axis_register_slice_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_10_M_AXIS [get_bd_intf_pins axi4stream_vip_10/S_AXIS] [get_bd_intf_pins axis_register_slice_10/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_11_M_AXIS [get_bd_intf_pins axi4stream_vip_11/S_AXIS] [get_bd_intf_pins axis_register_slice_11/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_12_M_AXIS [get_bd_intf_pins axi4stream_vip_12/S_AXIS] [get_bd_intf_pins axis_register_slice_12/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_13_M_AXIS [get_bd_intf_pins axi4stream_vip_13/S_AXIS] [get_bd_intf_pins axis_register_slice_13/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_14_M_AXIS [get_bd_intf_pins axi4stream_vip_14/S_AXIS] [get_bd_intf_pins axis_register_slice_14/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_15_M_AXIS [get_bd_intf_pins axi4stream_vip_15/S_AXIS] [get_bd_intf_pins axis_register_slice_15/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_19_M_AXIS [get_bd_intf_ports M_AXIS3_SLR23] [get_bd_intf_pins axis_register_slice_19/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins axi4stream_vip_1/S_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_20_M_AXIS [get_bd_intf_ports M_AXIS4_SLR23] [get_bd_intf_pins axis_register_slice_20/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_21_M_AXIS [get_bd_intf_ports M_AXIS5_SLR23] [get_bd_intf_pins axis_register_slice_21/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_22_M_AXIS [get_bd_intf_ports M_AXIS6_SLR23] [get_bd_intf_pins axis_register_slice_22/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_23_M_AXIS [get_bd_intf_ports M_AXIS7_SLR23] [get_bd_intf_pins axis_register_slice_23/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_24_M_AXIS [get_bd_intf_ports M_AXIS8_SLR23] [get_bd_intf_pins axis_register_slice_24/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_25_M_AXIS [get_bd_intf_ports M_AXIS9_SLR23] [get_bd_intf_pins axis_register_slice_25/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_26_M_AXIS [get_bd_intf_ports M_AXIS10_SLR23] [get_bd_intf_pins axis_register_slice_26/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_27_M_AXIS [get_bd_intf_ports M_AXIS11_SLR23] [get_bd_intf_pins axis_register_slice_27/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_28_M_AXIS [get_bd_intf_ports M_AXIS12_SLR23] [get_bd_intf_pins axis_register_slice_28/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_29_M_AXIS [get_bd_intf_ports M_AXIS13_SLR23] [get_bd_intf_pins axis_register_slice_29/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins axi4stream_vip_2/S_AXIS] [get_bd_intf_pins axis_register_slice_2/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_30_M_AXIS [get_bd_intf_ports M_AXIS14_SLR23] [get_bd_intf_pins axis_register_slice_30/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_31_M_AXIS [get_bd_intf_ports M_AXIS15_SLR23] [get_bd_intf_pins axis_register_slice_31/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins axi4stream_vip_3/S_AXIS] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_4_M_AXIS [get_bd_intf_pins axi4stream_vip_4/S_AXIS] [get_bd_intf_pins axis_register_slice_4/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_5_M_AXIS [get_bd_intf_pins axi4stream_vip_5/S_AXIS] [get_bd_intf_pins axis_register_slice_5/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_6_M_AXIS [get_bd_intf_pins axi4stream_vip_6/S_AXIS] [get_bd_intf_pins axis_register_slice_6/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_7_M_AXIS [get_bd_intf_pins axi4stream_vip_7/S_AXIS] [get_bd_intf_pins axis_register_slice_7/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_8_M_AXIS [get_bd_intf_pins axi4stream_vip_8/S_AXIS] [get_bd_intf_pins axis_register_slice_8/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_9_M_AXIS [get_bd_intf_pins axi4stream_vip_9/S_AXIS] [get_bd_intf_pins axis_register_slice_9/M_AXIS]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports C0_DDR4_0] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins microblaze_0/M_AXI_DC] [get_bd_intf_pins microblaze_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins microblaze_0/M_AXI_IC] [get_bd_intf_pins microblaze_0_axi_periph/S02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins axi_traffic_gen_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins axi_mcdma_0/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_axi [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI] [get_bd_intf_pins microblaze_0_local_memory/S_AXI_CTRL]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_axi [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI] [get_bd_intf_pins microblaze_0_local_memory/S_AXI_CTRL1]
  connect_bd_intf_net -intf_net microblaze_0_intc_axi [get_bd_intf_pins microblaze_0_axi_intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins microblaze_0_axi_intc/interrupt]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_1/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_timebase_wdt_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_data_fifo_0/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins axi_timer_1/S_AXI] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_ports M_AXI0_SLR23] [get_bd_intf_pins smartconnect_2/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M01_AXI [get_bd_intf_ports M_AXI1_SLR23] [get_bd_intf_pins smartconnect_2/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M00_AXI [get_bd_intf_ports M_AXI2_SLR23] [get_bd_intf_pins smartconnect_3/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_3_M01_AXI [get_bd_intf_ports M_AXI3_SLR23] [get_bd_intf_pins smartconnect_3/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M00_AXI [get_bd_intf_ports M_AXI4_SLR23] [get_bd_intf_pins smartconnect_4/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_4_M01_AXI [get_bd_intf_ports M_AXI5_SLR23] [get_bd_intf_pins smartconnect_4/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_5_M00_AXI [get_bd_intf_ports M_AXI6_SLR23] [get_bd_intf_pins smartconnect_5/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_5_M01_AXI [get_bd_intf_ports M_AXI7_SLR23] [get_bd_intf_pins smartconnect_5/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_6_M00_AXI [get_bd_intf_ports M_AXI8_SLR23] [get_bd_intf_pins smartconnect_6/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_6_M01_AXI [get_bd_intf_ports M_AXI9_SLR23] [get_bd_intf_pins smartconnect_6/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_7_M00_AXI [get_bd_intf_ports M_AXI10_SLR23] [get_bd_intf_pins smartconnect_7/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_7_M01_AXI [get_bd_intf_ports M_AXI11_SLR23] [get_bd_intf_pins smartconnect_7/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_8_M00_AXI [get_bd_intf_ports M_AXI12_SLR23] [get_bd_intf_pins smartconnect_8/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_8_M01_AXI [get_bd_intf_ports M_AXI13_SLR23] [get_bd_intf_pins smartconnect_8/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_9_M00_AXI [get_bd_intf_ports M_AXI14_SLR23] [get_bd_intf_pins smartconnect_9/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_9_M01_AXI [get_bd_intf_ports M_AXI15_SLR23] [get_bd_intf_pins smartconnect_9/M01_AXI]

  # Create port connections
  connect_bd_net -net axi_timebase_wdt_0_wdt_reset [get_bd_pins axi_timebase_wdt_0/wdt_reset] [get_bd_pins ddr4_0/sys_rst]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_250M/dcm_locked]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins microblaze_0_axi_periph/M11_ACLK] [get_bd_pins rst_ddr4_0_333M/slowest_sync_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins rst_ddr4_0_333M/ext_reset_in]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_data_fifo_0/aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/m_axi_sg_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_mcdma_0/s_axi_aclk] [get_bd_pins axi_mcdma_0/s_axi_lite_aclk] [get_bd_pins axi_timebase_wdt_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_timer_1/s_axi_aclk] [get_bd_pins axi_traffic_gen_0/s_axi_aclk] [get_bd_pins axi_traffic_gen_1/s_axi_aclk] [get_bd_pins axi_traffic_gen_2/s_axi_aclk] [get_bd_pins axi_traffic_gen_3/s_axi_aclk] [get_bd_pins axi_traffic_gen_4/s_axi_aclk] [get_bd_pins axi_traffic_gen_5/s_axi_aclk] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axi_vip_16/aclk] [get_bd_pins axis_interconnect_0/ACLK] [get_bd_pins axis_interconnect_0/S00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S01_AXIS_ACLK] [get_bd_pins axis_interconnect_0/S02_AXIS_ACLK] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_intc/processor_clk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/M10_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_axi_periph/S01_ACLK] [get_bd_pins microblaze_0_axi_periph/S02_ACLK] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_250M/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_2/aclk] [get_bd_pins smartconnect_3/aclk] [get_bd_pins smartconnect_4/aclk] [get_bd_pins smartconnect_5/aclk] [get_bd_pins smartconnect_6/aclk] [get_bd_pins smartconnect_7/aclk] [get_bd_pins smartconnect_8/aclk] [get_bd_pins smartconnect_9/aclk]
  connect_bd_net -net microblaze_0_dlmb_int [get_bd_pins microblaze_0_local_memory/DLMB_Interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net microblaze_0_ilmb_int [get_bd_pins microblaze_0_local_memory/ILMB_Interrupt] [get_bd_pins microblaze_0_xlconcat/In1]
  connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_axi_intc/intr] [get_bd_pins microblaze_0_xlconcat/dout]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_250M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_0_axi_intc/processor_rst] [get_bd_pins rst_clk_wiz_1_250M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_data_fifo_0/aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_mcdma_0/axi_resetn] [get_bd_pins axi_timebase_wdt_0/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_timer_1/s_axi_aresetn] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn] [get_bd_pins axi_traffic_gen_1/s_axi_aresetn] [get_bd_pins axi_traffic_gen_2/s_axi_aresetn] [get_bd_pins axi_traffic_gen_3/s_axi_aresetn] [get_bd_pins axi_traffic_gen_4/s_axi_aresetn] [get_bd_pins axi_traffic_gen_5/s_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axi_vip_16/aresetn] [get_bd_pins axis_interconnect_0/ARESETN] [get_bd_pins axis_interconnect_0/S00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S01_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/S02_AXIS_ARESETN] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins microblaze_0_axi_periph/S01_ARESETN] [get_bd_pins microblaze_0_axi_periph/S02_ARESETN] [get_bd_pins microblaze_0_local_memory/S_AXI_CTRL_ARESETN] [get_bd_pins rst_clk_wiz_1_250M/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_2/aresetn] [get_bd_pins smartconnect_3/aresetn] [get_bd_pins smartconnect_4/aresetn] [get_bd_pins smartconnect_5/aresetn] [get_bd_pins smartconnect_6/aresetn] [get_bd_pins smartconnect_7/aresetn] [get_bd_pins smartconnect_8/aresetn] [get_bd_pins smartconnect_9/aresetn]
  connect_bd_net -net rst_ddr4_0_333M_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins microblaze_0_axi_periph/M11_ARESETN] [get_bd_pins rst_ddr4_0_333M/peripheral_aresetn]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi4stream_vip_0/aclk] [get_bd_pins axi4stream_vip_1/aclk] [get_bd_pins axi4stream_vip_10/aclk] [get_bd_pins axi4stream_vip_11/aclk] [get_bd_pins axi4stream_vip_12/aclk] [get_bd_pins axi4stream_vip_13/aclk] [get_bd_pins axi4stream_vip_14/aclk] [get_bd_pins axi4stream_vip_15/aclk] [get_bd_pins axi4stream_vip_19/aclk] [get_bd_pins axi4stream_vip_2/aclk] [get_bd_pins axi4stream_vip_20/aclk] [get_bd_pins axi4stream_vip_21/aclk] [get_bd_pins axi4stream_vip_22/aclk] [get_bd_pins axi4stream_vip_23/aclk] [get_bd_pins axi4stream_vip_24/aclk] [get_bd_pins axi4stream_vip_25/aclk] [get_bd_pins axi4stream_vip_26/aclk] [get_bd_pins axi4stream_vip_27/aclk] [get_bd_pins axi4stream_vip_28/aclk] [get_bd_pins axi4stream_vip_29/aclk] [get_bd_pins axi4stream_vip_3/aclk] [get_bd_pins axi4stream_vip_30/aclk] [get_bd_pins axi4stream_vip_31/aclk] [get_bd_pins axi4stream_vip_4/aclk] [get_bd_pins axi4stream_vip_5/aclk] [get_bd_pins axi4stream_vip_6/aclk] [get_bd_pins axi4stream_vip_7/aclk] [get_bd_pins axi4stream_vip_8/aclk] [get_bd_pins axi4stream_vip_9/aclk] [get_bd_pins axi_register_slice_10/aclk] [get_bd_pins axi_register_slice_11/aclk] [get_bd_pins axi_register_slice_12/aclk] [get_bd_pins axi_register_slice_13/aclk] [get_bd_pins axi_register_slice_14/aclk] [get_bd_pins axi_register_slice_15/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins axi_register_slice_5/aclk] [get_bd_pins axi_register_slice_6/aclk] [get_bd_pins axi_register_slice_7/aclk] [get_bd_pins axi_register_slice_8/aclk] [get_bd_pins axi_register_slice_9/aclk] [get_bd_pins axi_vip_10/aclk] [get_bd_pins axi_vip_11/aclk] [get_bd_pins axi_vip_12/aclk] [get_bd_pins axi_vip_13/aclk] [get_bd_pins axi_vip_14/aclk] [get_bd_pins axi_vip_15/aclk] [get_bd_pins axi_vip_4/aclk] [get_bd_pins axi_vip_5/aclk] [get_bd_pins axi_vip_6/aclk] [get_bd_pins axi_vip_7/aclk] [get_bd_pins axi_vip_8/aclk] [get_bd_pins axi_vip_9/aclk] [get_bd_pins axis_interconnect_0/M00_AXIS_ACLK] [get_bd_pins axis_interconnect_0/M01_AXIS_ACLK] [get_bd_pins axis_interconnect_0/M02_AXIS_ACLK] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_10/aclk] [get_bd_pins axis_register_slice_11/aclk] [get_bd_pins axis_register_slice_12/aclk] [get_bd_pins axis_register_slice_13/aclk] [get_bd_pins axis_register_slice_14/aclk] [get_bd_pins axis_register_slice_15/aclk] [get_bd_pins axis_register_slice_19/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_20/aclk] [get_bd_pins axis_register_slice_21/aclk] [get_bd_pins axis_register_slice_22/aclk] [get_bd_pins axis_register_slice_23/aclk] [get_bd_pins axis_register_slice_24/aclk] [get_bd_pins axis_register_slice_25/aclk] [get_bd_pins axis_register_slice_26/aclk] [get_bd_pins axis_register_slice_27/aclk] [get_bd_pins axis_register_slice_28/aclk] [get_bd_pins axis_register_slice_29/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins axis_register_slice_30/aclk] [get_bd_pins axis_register_slice_31/aclk] [get_bd_pins axis_register_slice_4/aclk] [get_bd_pins axis_register_slice_5/aclk] [get_bd_pins axis_register_slice_6/aclk] [get_bd_pins axis_register_slice_7/aclk] [get_bd_pins axis_register_slice_8/aclk] [get_bd_pins axis_register_slice_9/aclk] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins debug_bridge_0/clk] [get_bd_pins smartconnect_0/aclk1] [get_bd_pins smartconnect_2/aclk1] [get_bd_pins smartconnect_3/aclk1] [get_bd_pins smartconnect_4/aclk1] [get_bd_pins smartconnect_5/aclk1] [get_bd_pins smartconnect_6/aclk1] [get_bd_pins smartconnect_7/aclk1] [get_bd_pins smartconnect_8/aclk1] [get_bd_pins smartconnect_9/aclk1]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_ports s_axis_aresetn] [get_bd_pins axi4stream_vip_0/aresetn] [get_bd_pins axi4stream_vip_1/aresetn] [get_bd_pins axi4stream_vip_10/aresetn] [get_bd_pins axi4stream_vip_11/aresetn] [get_bd_pins axi4stream_vip_12/aresetn] [get_bd_pins axi4stream_vip_13/aresetn] [get_bd_pins axi4stream_vip_14/aresetn] [get_bd_pins axi4stream_vip_15/aresetn] [get_bd_pins axi4stream_vip_19/aresetn] [get_bd_pins axi4stream_vip_2/aresetn] [get_bd_pins axi4stream_vip_20/aresetn] [get_bd_pins axi4stream_vip_21/aresetn] [get_bd_pins axi4stream_vip_22/aresetn] [get_bd_pins axi4stream_vip_23/aresetn] [get_bd_pins axi4stream_vip_24/aresetn] [get_bd_pins axi4stream_vip_25/aresetn] [get_bd_pins axi4stream_vip_26/aresetn] [get_bd_pins axi4stream_vip_27/aresetn] [get_bd_pins axi4stream_vip_28/aresetn] [get_bd_pins axi4stream_vip_29/aresetn] [get_bd_pins axi4stream_vip_3/aresetn] [get_bd_pins axi4stream_vip_30/aresetn] [get_bd_pins axi4stream_vip_31/aresetn] [get_bd_pins axi4stream_vip_4/aresetn] [get_bd_pins axi4stream_vip_5/aresetn] [get_bd_pins axi4stream_vip_6/aresetn] [get_bd_pins axi4stream_vip_7/aresetn] [get_bd_pins axi4stream_vip_8/aresetn] [get_bd_pins axi4stream_vip_9/aresetn] [get_bd_pins axi_register_slice_10/aresetn] [get_bd_pins axi_register_slice_11/aresetn] [get_bd_pins axi_register_slice_12/aresetn] [get_bd_pins axi_register_slice_13/aresetn] [get_bd_pins axi_register_slice_14/aresetn] [get_bd_pins axi_register_slice_15/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins axi_register_slice_5/aresetn] [get_bd_pins axi_register_slice_6/aresetn] [get_bd_pins axi_register_slice_7/aresetn] [get_bd_pins axi_register_slice_8/aresetn] [get_bd_pins axi_register_slice_9/aresetn] [get_bd_pins axi_vip_10/aresetn] [get_bd_pins axi_vip_11/aresetn] [get_bd_pins axi_vip_12/aresetn] [get_bd_pins axi_vip_13/aresetn] [get_bd_pins axi_vip_14/aresetn] [get_bd_pins axi_vip_15/aresetn] [get_bd_pins axi_vip_4/aresetn] [get_bd_pins axi_vip_5/aresetn] [get_bd_pins axi_vip_6/aresetn] [get_bd_pins axi_vip_7/aresetn] [get_bd_pins axi_vip_8/aresetn] [get_bd_pins axi_vip_9/aresetn] [get_bd_pins axis_interconnect_0/M00_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/M01_AXIS_ARESETN] [get_bd_pins axis_interconnect_0/M02_AXIS_ARESETN] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_10/aresetn] [get_bd_pins axis_register_slice_11/aresetn] [get_bd_pins axis_register_slice_12/aresetn] [get_bd_pins axis_register_slice_13/aresetn] [get_bd_pins axis_register_slice_14/aresetn] [get_bd_pins axis_register_slice_15/aresetn] [get_bd_pins axis_register_slice_19/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_20/aresetn] [get_bd_pins axis_register_slice_21/aresetn] [get_bd_pins axis_register_slice_22/aresetn] [get_bd_pins axis_register_slice_23/aresetn] [get_bd_pins axis_register_slice_24/aresetn] [get_bd_pins axis_register_slice_25/aresetn] [get_bd_pins axis_register_slice_26/aresetn] [get_bd_pins axis_register_slice_27/aresetn] [get_bd_pins axis_register_slice_28/aresetn] [get_bd_pins axis_register_slice_29/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins axis_register_slice_30/aresetn] [get_bd_pins axis_register_slice_31/aresetn] [get_bd_pins axis_register_slice_4/aresetn] [get_bd_pins axis_register_slice_5/aresetn] [get_bd_pins axis_register_slice_6/aresetn] [get_bd_pins axis_register_slice_7/aresetn] [get_bd_pins axis_register_slice_8/aresetn] [get_bd_pins axis_register_slice_9/aresetn] [get_bd_pins clk_wiz_1/resetn] [get_bd_pins rst_clk_wiz_1_250M/ext_reset_in]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs M_AXI8_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs M_AXI8_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs M_AXI9_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_cdma_0/Data_SG] [get_bd_addr_segs M_AXI9_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs M_AXI4_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs M_AXI5_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs M_AXI6_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs M_AXI6_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs M_AXI7_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs M_AXI7_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs M_AXI0_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs M_AXI0_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_SG] [get_bd_addr_segs M_AXI1_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_MM2S] [get_bd_addr_segs M_AXI1_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs M_AXI2_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_mcdma_0/Data_S2MM] [get_bd_addr_segs M_AXI3_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Data] [get_bd_addr_segs M_AXI10_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_0/Data] [get_bd_addr_segs M_AXI11_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_1/Data] [get_bd_addr_segs M_AXI10_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_1/Data] [get_bd_addr_segs M_AXI11_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_2/Data] [get_bd_addr_segs M_AXI12_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_2/Data] [get_bd_addr_segs M_AXI13_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_3/Data] [get_bd_addr_segs M_AXI12_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_3/Data] [get_bd_addr_segs M_AXI13_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_4/Data] [get_bd_addr_segs M_AXI14_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_4/Data] [get_bd_addr_segs M_AXI15_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_5/Data] [get_bd_addr_segs M_AXI14_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_traffic_gen_5/Data] [get_bd_addr_segs M_AXI15_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs M_AXI2_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs M_AXI3_SLR23/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs M_AXI4_SLR23/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs M_AXI5_SLR23/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41E00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41E00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_mcdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_traffic_gen_0/S_AXI/Reg0] -force
  assign_bd_address -offset 0x44A30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x44A30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x76000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x76000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x76010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x76010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR23] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR23] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR23] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR23] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x41A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR23] [get_bd_addr_segs axi_timebase_wdt_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR23] [get_bd_addr_segs axi_timebase_wdt_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR23] [get_bd_addr_segs axi_timebase_wdt_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR23] [get_bd_addr_segs axi_timebase_wdt_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR23] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR23] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR23] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR23] [get_bd_addr_segs axi_timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI10_SLR23] [get_bd_addr_segs axi_vip_10/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI11_SLR23] [get_bd_addr_segs axi_vip_11/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI12_SLR23] [get_bd_addr_segs axi_vip_12/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI13_SLR23] [get_bd_addr_segs axi_vip_13/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI14_SLR23] [get_bd_addr_segs axi_vip_14/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI15_SLR23] [get_bd_addr_segs axi_vip_15/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI2_SLR23] [get_bd_addr_segs axi_vip_16/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI0_SLR23] [get_bd_addr_segs axi_vip_16/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI3_SLR23] [get_bd_addr_segs axi_vip_16/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI1_SLR23] [get_bd_addr_segs axi_vip_16/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI4_SLR23] [get_bd_addr_segs axi_vip_4/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI5_SLR23] [get_bd_addr_segs axi_vip_5/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI6_SLR23] [get_bd_addr_segs axi_vip_6/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI7_SLR23] [get_bd_addr_segs axi_vip_7/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI8_SLR23] [get_bd_addr_segs axi_vip_8/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI9_SLR23] [get_bd_addr_segs axi_vip_9/S_AXI/Reg] -force


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


