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
////////////////////////////////////////////////////////////////////////////

################################################################
# This is a generated script based on design: design_GT
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
set scripts_vivado_version [version -short]
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
# source design_GT_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vck190:part0:3.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_GT

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
xilinx.com:ip:bufg_gt:1.0\
xilinx.com:ip:gt_bridge_ip:1.1\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:util_reduced_logic:2.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:xlconcat:2.1\
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
  set GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial ]

  set gt_bridge_ip_0_diff_gt_ref_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_bridge_ip_0_diff_gt_ref_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $gt_bridge_ip_0_diff_gt_ref_clock


  # Create ports
  set apb3clk_gt_bridge_ip_0 [ create_bd_port -dir I -type clk -freq_hz 200000000 apb3clk_gt_bridge_ip_0 ]
  set apb3clk_quad [ create_bd_port -dir I -type clk -freq_hz 200000000 apb3clk_quad ]
  set gt_reset_gt_bridge_ip_0 [ create_bd_port -dir I gt_reset_gt_bridge_ip_0 ]
  set lcpll_lock_gt_bridge_ip_0 [ create_bd_port -dir O lcpll_lock_gt_bridge_ip_0 ]
  set link_status_gt_bridge_ip_0 [ create_bd_port -dir O link_status_gt_bridge_ip_0 ]
  set rate_sel_gt_bridge_ip_0 [ create_bd_port -dir I -from 3 -to 0 rate_sel_gt_bridge_ip_0 ]
  set rpll_lock_gt_bridge_ip_0 [ create_bd_port -dir O rpll_lock_gt_bridge_ip_0 ]
  set rx_resetdone_out_gt_bridge_ip_0 [ create_bd_port -dir O rx_resetdone_out_gt_bridge_ip_0 ]
  set rxusrclk_gt_bridge_ip_0 [ create_bd_port -dir O rxusrclk_gt_bridge_ip_0 ]
  set tx_resetdone_out_gt_bridge_ip_0 [ create_bd_port -dir O tx_resetdone_out_gt_bridge_ip_0 ]
  set txusrclk_gt_bridge_ip_0 [ create_bd_port -dir O txusrclk_gt_bridge_ip_0 ]

  # Create instance: bufg_gt, and set properties
  set bufg_gt [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bufg_gt ]

  # Create instance: bufg_gt_1, and set properties
  set bufg_gt_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bufg_gt_1 ]

  # Create instance: gt_bridge_ip_0, and set properties
  set gt_bridge_ip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_bridge_ip:1.1 gt_bridge_ip_0 ]

  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [ list \
   CONFIG.PORTS_INFO_DICT {\
     LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}}\
     GT_TYPE {GTY}\
     REG_CONF_INTF {APB3_INTF}\
     BOARD_PARAMETER {}\
   } \
   CONFIG.QUAD_USAGE {\
     TX_QUAD_CH {TXQuad_0_/gt_quad_base {/gt_quad_base\
design_GT_gt_bridge_ip_0_0.IP_CH0,design_GT_gt_bridge_ip_0_0.IP_CH1,design_GT_gt_bridge_ip_0_0.IP_CH2,design_GT_gt_bridge_ip_0_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}\
     RX_QUAD_CH {RXQuad_0_/gt_quad_base {/gt_quad_base\
design_GT_gt_bridge_ip_0_0.IP_CH0,design_GT_gt_bridge_ip_0_0.IP_CH1,design_GT_gt_bridge_ip_0_0.IP_CH2,design_GT_gt_bridge_ip_0_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}\
   } \
   CONFIG.REFCLK_STRING {\
HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1 HSCLK1_LCPLLGTREFCLK0\
refclk_PROT0_R0_156.25_MHz_unique1} \
 ] $gt_quad_base

  # Create instance: urlp, and set properties
  set urlp [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 urlp ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $urlp

  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf

  # Create instance: xlcp, and set properties
  set xlcp [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlcp ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlcp

  # Create interface connections
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_RX0 [get_bd_intf_pins gt_bridge_ip_0/GT_RX0] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_RX1 [get_bd_intf_pins gt_bridge_ip_0/GT_RX1] [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_RX2 [get_bd_intf_pins gt_bridge_ip_0/GT_RX2] [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_RX3 [get_bd_intf_pins gt_bridge_ip_0/GT_RX3] [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_TX0 [get_bd_intf_pins gt_bridge_ip_0/GT_TX0] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_TX1 [get_bd_intf_pins gt_bridge_ip_0/GT_TX1] [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_TX2 [get_bd_intf_pins gt_bridge_ip_0/GT_TX2] [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_GT_TX3 [get_bd_intf_pins gt_bridge_ip_0/GT_TX3] [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_bridge_ip_0_diff_gt_ref_clock_1 [get_bd_intf_ports gt_bridge_ip_0_diff_gt_ref_clock] [get_bd_intf_pins util_ds_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net gt_quad_base_GT_Serial [get_bd_intf_ports GT_Serial] [get_bd_intf_pins gt_quad_base/GT_Serial]

  # Create port connections
  connect_bd_net -net apb3clk_gt_bridge_ip_0_1 [get_bd_ports apb3clk_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/apb3clk]
  connect_bd_net -net apb3clk_quad_1 [get_bd_ports apb3clk_quad] [get_bd_pins gt_quad_base/apb3clk]
  connect_bd_net -net bufg_gt_1_usrclk [get_bd_pins bufg_gt_1/usrclk] [get_bd_pins gt_bridge_ip_0/gt_txusrclk] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins gt_quad_base/ch1_txusrclk] [get_bd_pins gt_quad_base/ch2_txusrclk] [get_bd_pins gt_quad_base/ch3_txusrclk]
  connect_bd_net -net bufg_gt_usrclk [get_bd_pins bufg_gt/usrclk] [get_bd_pins gt_bridge_ip_0/gt_rxusrclk] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins gt_quad_base/ch1_rxusrclk] [get_bd_pins gt_quad_base/ch2_rxusrclk] [get_bd_pins gt_quad_base/ch3_rxusrclk]
  connect_bd_net -net gt_bridge_ip_0_lcpll_lock_out [get_bd_ports lcpll_lock_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/lcpll_lock_out]
  connect_bd_net -net gt_bridge_ip_0_link_status_out [get_bd_ports link_status_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/link_status_out]
  connect_bd_net -net gt_bridge_ip_0_rpll_lock_out [get_bd_ports rpll_lock_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/rpll_lock_out]
  connect_bd_net -net gt_bridge_ip_0_rx_resetdone_out [get_bd_ports rx_resetdone_out_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/rx_resetdone_out]
  connect_bd_net -net gt_bridge_ip_0_rxusrclk_out [get_bd_ports rxusrclk_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/rxusrclk_out]
  connect_bd_net -net gt_bridge_ip_0_tx_resetdone_out [get_bd_ports tx_resetdone_out_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/tx_resetdone_out]
  connect_bd_net -net gt_bridge_ip_0_txusrclk_out [get_bd_ports txusrclk_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/txusrclk_out]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk [get_bd_pins bufg_gt/outclk] [get_bd_pins gt_quad_base/ch0_rxoutclk]
  connect_bd_net -net gt_quad_base_ch0_txoutclk [get_bd_pins bufg_gt_1/outclk] [get_bd_pins gt_quad_base/ch0_txoutclk]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins gt_quad_base/gtpowergood] [get_bd_pins xlcp/In0]
  connect_bd_net -net gt_reset_gt_bridge_ip_0_1 [get_bd_ports gt_reset_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/gtreset_in]
  connect_bd_net -net rate_sel_gt_bridge_ip_0_1 [get_bd_ports rate_sel_gt_bridge_ip_0] [get_bd_pins gt_bridge_ip_0/rate_sel]
  connect_bd_net -net urlp_Res [get_bd_pins gt_bridge_ip_0/gtpowergood] [get_bd_pins urlp/Res]
  connect_bd_net -net util_ds_buf_IBUF_OUT [get_bd_pins gt_quad_base/GT_REFCLK0] [get_bd_pins util_ds_buf/IBUF_OUT]
  connect_bd_net -net xlcp_dout [get_bd_pins urlp/Op1] [get_bd_pins xlcp/dout]

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



