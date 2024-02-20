#--------------------------------------------------------------------------------------
#
# Copyright(C) 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# This document contains proprietary, confidential information that
# may be used, copied and/or disclosed only as authorized by a
# valid licensing agreement with Advanced Micro Devices, Inc. This copyright
# notice must be retained on all authorized copies.
#
# This code is provided "as is". Advanced Micro Devices, Inc. makes, and
# the end user receives, no warranties or conditions, express,
# implied, statutory or otherwise, and Advanced Micro Devices, Inc.
# specifically disclaims any implied warranties of merchantability,
# non-infringement, or fitness for a particular purpose.
#
#--------------------------------------------------------------------------------------

################################################################
# This is a generated script based on design: bd_noc
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
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bd_noc_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axis_8x128seg_to_4x256axis, axis_4x256axis_to_8x128seg

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvp1802-lsvc4072-2MP-e-S
   set_property BOARD_PART xilinx.com:vpk180:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd_noc

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
xilinx.com:ip:axis_noc:1.0\
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
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axis_8x128seg_to_4x256axis\
axis_4x256axis_to_8x128seg\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
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
  set axiseg_s1 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s1 ]

  set axiseg_s5 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s5 ]

  set axiseg_s2 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s2 ]

  set axiseg_s3 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s3 ]

  set axiseg_s6 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s6 ]

  set axiseg_s7 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s7 ]

  set axiseg_s4 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s4 ]

  set axiseg_s0 [ create_bd_intf_port -mode Slave -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_s0 ]

  set axiseg_m1 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m1 ]

  set axiseg_m7 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m7 ]

  set axiseg_m5 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m5 ]

  set axiseg_m4 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m4 ]

  set axiseg_m2 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m2 ]

  set axiseg_m6 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m6 ]

  set axiseg_m3 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m3 ]

  set axiseg_m0 [ create_bd_intf_port -mode Master -vlnv Fidus:user:axiseg_rtl:1.0 axiseg_m0 ]


  # Create ports
  set s_aclk [ create_bd_port -dir I -type clk s_aclk ]
  set arstn [ create_bd_port -dir I arstn ]
  set axiseg_valid_in [ create_bd_port -dir I axiseg_valid_in ]
  set err_overflow_ing [ create_bd_port -dir O -from 3 -to 0 err_overflow_ing ]
  set err_alignment_egr [ create_bd_port -dir O err_alignment_egr ]
  set axiseg_tid_in [ create_bd_port -dir I -from 2 -to 0 axiseg_tid_in ]
  set axiseg_tid_out [ create_bd_port -dir O -from 2 -to 0 axiseg_tid_out ]
  set m_aclk [ create_bd_port -dir I -type clk m_aclk ]
  set axiseg_ready_out [ create_bd_port -dir I -from 3 -to 0 axiseg_ready_out ]
  set axiseg_valid_out [ create_bd_port -dir O -from 3 -to 0 axiseg_valid_out ]

  # Create instance: axis_noc, and set properties
  set axis_noc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_noc:1.0 axis_noc ]
  set_property -dict [list \
    CONFIG.MI_TDEST_VALS {,,,} \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {4} \
    CONFIG.TDEST_WIDTH {7} \
    CONFIG.TID_WIDTH {6} \
  ] $axis_noc


  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NSU512_X2Y21} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/M00_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NSU512_X2Y22} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/M01_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NSU512_X1Y21} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/M02_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NSU512_X1Y22} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/M03_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X2Y9} \
   CONFIG.CONNECTIONS {M00_AXIS { write_bw {16000} write_avg_burst {4} excl_group {1}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/S00_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X2Y10} \
   CONFIG.CONNECTIONS {M01_AXIS { write_bw {16000} write_avg_burst {4} excl_group {2}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/S01_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X1Y9} \
   CONFIG.CONNECTIONS {M02_AXIS { write_bw {16000} write_avg_burst {4} excl_group {3}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/S02_AXIS]

  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {32} \
   CONFIG.TDEST_WIDTH {7} \
   CONFIG.TID_WIDTH {6} \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X1Y10} \
   CONFIG.CONNECTIONS {M03_AXIS { write_bw {16000} write_avg_burst {4} excl_group {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axis_noc/S03_AXIS]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXIS:S01_AXIS:S02_AXIS:S03_AXIS} \
 ] [get_bd_pins /axis_noc/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXIS:M01_AXIS:M02_AXIS:M03_AXIS} \
 ] [get_bd_pins /axis_noc/aclk1]

  # Create instance: axis_seg_to_unseg, and set properties
  set block_name axis_8x128seg_to_4x256axis
  set block_cell_name axis_seg_to_unseg
  if { [catch {set axis_seg_to_unseg [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_seg_to_unseg eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_unseg_to_seg, and set properties
  set block_name axis_4x256axis_to_8x128seg
  set block_cell_name axis_unseg_to_seg
  if { [catch {set axis_unseg_to_seg [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_unseg_to_seg eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net axis_8x128seg_to_4x2_0_axis_m0 [get_bd_intf_pins axis_seg_to_unseg/axis_m0] [get_bd_intf_pins axis_noc/S00_AXIS]
  connect_bd_intf_net -intf_net axis_8x128seg_to_4x2_0_axis_m1 [get_bd_intf_pins axis_seg_to_unseg/axis_m1] [get_bd_intf_pins axis_noc/S01_AXIS]
  connect_bd_intf_net -intf_net axis_8x128seg_to_4x2_0_axis_m2 [get_bd_intf_pins axis_seg_to_unseg/axis_m2] [get_bd_intf_pins axis_noc/S02_AXIS]
  connect_bd_intf_net -intf_net axis_8x128seg_to_4x2_0_axis_m3 [get_bd_intf_pins axis_seg_to_unseg/axis_m3] [get_bd_intf_pins axis_noc/S03_AXIS]
  connect_bd_intf_net -intf_net axis_noc_M00_AXIS [get_bd_intf_pins axis_unseg_to_seg/axis_s0] [get_bd_intf_pins axis_noc/M00_AXIS]
  connect_bd_intf_net -intf_net axis_noc_M01_AXIS [get_bd_intf_pins axis_unseg_to_seg/axis_s1] [get_bd_intf_pins axis_noc/M01_AXIS]
  connect_bd_intf_net -intf_net axis_noc_M02_AXIS [get_bd_intf_pins axis_unseg_to_seg/axis_s2] [get_bd_intf_pins axis_noc/M02_AXIS]
  connect_bd_intf_net -intf_net axis_noc_M03_AXIS [get_bd_intf_pins axis_unseg_to_seg/axis_s3] [get_bd_intf_pins axis_noc/M03_AXIS]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m0 [get_bd_intf_ports axiseg_m0] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m0]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m1 [get_bd_intf_ports axiseg_m1] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m1]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m2 [get_bd_intf_ports axiseg_m2] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m2]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m3 [get_bd_intf_ports axiseg_m3] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m3]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m4 [get_bd_intf_ports axiseg_m4] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m4]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m5 [get_bd_intf_ports axiseg_m5] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m5]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m6 [get_bd_intf_ports axiseg_m6] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m6]
  connect_bd_intf_net -intf_net axis_unseg_to_seg_axiseg_m7 [get_bd_intf_ports axiseg_m7] [get_bd_intf_pins axis_unseg_to_seg/axiseg_m7]
  connect_bd_intf_net -intf_net axiseg_s0_0_1 [get_bd_intf_ports axiseg_s0] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s0]
  connect_bd_intf_net -intf_net axiseg_s1_0_1 [get_bd_intf_ports axiseg_s1] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s1]
  connect_bd_intf_net -intf_net axiseg_s2_0_1 [get_bd_intf_ports axiseg_s2] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s2]
  connect_bd_intf_net -intf_net axiseg_s3_0_1 [get_bd_intf_ports axiseg_s3] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s3]
  connect_bd_intf_net -intf_net axiseg_s4_0_1 [get_bd_intf_ports axiseg_s4] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s4]
  connect_bd_intf_net -intf_net axiseg_s5_0_1 [get_bd_intf_ports axiseg_s5] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s5]
  connect_bd_intf_net -intf_net axiseg_s6_0_1 [get_bd_intf_ports axiseg_s6] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s6]
  connect_bd_intf_net -intf_net axiseg_s7_0_1 [get_bd_intf_ports axiseg_s7] [get_bd_intf_pins axis_seg_to_unseg/axiseg_s7]

  # Create port connections
  connect_bd_net -net aclk0_0_1 [get_bd_ports s_aclk] [get_bd_pins axis_noc/aclk0] [get_bd_pins axis_seg_to_unseg/aclk]
  connect_bd_net -net aclk_0_1 [get_bd_ports m_aclk] [get_bd_pins axis_noc/aclk1] [get_bd_pins axis_unseg_to_seg/aclk]
  connect_bd_net -net arstn_1 [get_bd_ports arstn] [get_bd_pins axis_seg_to_unseg/arstn] [get_bd_pins axis_unseg_to_seg/arstn]
  connect_bd_net -net axis_seg_to_unseg_err_ch_overflow [get_bd_pins axis_seg_to_unseg/err_ch_overflow] [get_bd_ports err_overflow_ing]
  connect_bd_net -net axis_unseg_to_seg_axiseg_tid [get_bd_pins axis_unseg_to_seg/axiseg_tid] [get_bd_ports axiseg_tid_out]
  connect_bd_net -net axis_unseg_to_seg_axiseg_valid [get_bd_pins axis_unseg_to_seg/axiseg_valid] [get_bd_ports axiseg_valid_out]
  connect_bd_net -net axis_unseg_to_seg_err_alignment [get_bd_pins axis_unseg_to_seg/err_alignment] [get_bd_ports err_alignment_egr]
  connect_bd_net -net axiseg_ready_0_1 [get_bd_ports axiseg_ready_out] [get_bd_pins axis_unseg_to_seg/axiseg_ready]
  connect_bd_net -net axiseg_tid_0_1 [get_bd_ports axiseg_tid_in] [get_bd_pins axis_seg_to_unseg/axiseg_tid]
  connect_bd_net -net axiseg_valid_0_1 [get_bd_ports axiseg_valid_in] [get_bd_pins axis_seg_to_unseg/axiseg_valid]

  # Create address segments


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


