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
# This is a generated script based on design: dcmac_0_exdes_support
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
# source dcmac_0_exdes_support_script.tcl

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
set design_name dcmac_0_exdes_support

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
xilinx.com:ip:dcmac:2.3\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:gt_quad_base:1.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:bufg_gt:1.0\
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


# Hierarchical cell: dcmac_0_gt_wrapper
proc create_hier_cell_dcmac_0_gt_wrapper { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dcmac_0_gt_wrapper() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX3_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX0_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX1_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX2_GT_IP_Interface

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX3_GT_IP_Interface

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX0_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX1_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX2_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_tx_interface_rtl:1.0 TX3_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX0_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX1_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX2_GT_IP_Interface1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rx_interface_rtl:1.0 RX3_GT_IP_Interface1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial_1


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk ch0_rx_usr_clk_0
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk ch0_rx_usr_clk2_0
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLR1
  create_bd_pin -dir I -from 0 -to 0 MBUFG_GT_CLRB_LEAF1
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk ch0_tx_usr_clk_0
  create_bd_pin -dir O -from 0 -to 0 -type gt_usrclk ch0_tx_usr_clk2_0
  create_bd_pin -dir I -type rst hsclk1_lcpllreset
  create_bd_pin -dir O hsclk0_lcplllock
  create_bd_pin -dir O gtpowergood_0
  create_bd_pin -dir I -type rst ch0_iloreset
  create_bd_pin -dir I -type rst ch1_iloreset
  create_bd_pin -dir I -type rst ch2_iloreset
  create_bd_pin -dir I -type rst ch3_iloreset
  create_bd_pin -dir O ch0_iloresetdone
  create_bd_pin -dir O ch1_iloresetdone
  create_bd_pin -dir O ch2_iloresetdone
  create_bd_pin -dir O ch3_iloresetdone
  create_bd_pin -dir I -from 5 -to 0 gt_txpostcursor
  create_bd_pin -dir I -from 5 -to 0 gt_txprecursor
  create_bd_pin -dir I -from 6 -to 0 gt_txmaincursor
  create_bd_pin -dir I -from 7 -to 0 ch0_txrate_0
  create_bd_pin -dir I -from 7 -to 0 ch1_txrate_0
  create_bd_pin -dir I -from 7 -to 0 ch2_txrate_0
  create_bd_pin -dir I -from 7 -to 0 ch3_txrate_0
  create_bd_pin -dir I gt_rxcdrhold
  create_bd_pin -dir I -from 7 -to 0 ch0_rxrate_0
  create_bd_pin -dir I -from 7 -to 0 ch1_rxrate_0
  create_bd_pin -dir I -from 7 -to 0 ch2_rxrate_0
  create_bd_pin -dir I -from 7 -to 0 ch3_rxrate_0
  create_bd_pin -dir I -from 2 -to 0 ch0_loopback_0
  create_bd_pin -dir I -from 2 -to 0 ch1_loopback_0
  create_bd_pin -dir I -from 2 -to 0 ch2_loopback_0
  create_bd_pin -dir I -from 2 -to 0 ch3_loopback_0
  create_bd_pin -dir O -from 31 -to 0 gpo
  create_bd_pin -dir I -type clk apb3clk_quad
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -type gt_usrclk IBUFDS_ODIV2
  create_bd_pin -dir I -type rst hsclk0_rpllreset
  create_bd_pin -dir O hsclk0_lcplllock1
  create_bd_pin -dir O gtpowergood_1
  create_bd_pin -dir I -type rst ch0_iloreset1
  create_bd_pin -dir I -type rst ch1_iloreset1
  create_bd_pin -dir I -type rst ch2_iloreset1
  create_bd_pin -dir I -type rst ch3_iloreset1
  create_bd_pin -dir O ch0_iloresetdone1
  create_bd_pin -dir O ch1_iloresetdone1
  create_bd_pin -dir O ch2_iloresetdone1
  create_bd_pin -dir O ch3_iloresetdone1
  create_bd_pin -dir I -from 7 -to 0 ch0_txrate_1
  create_bd_pin -dir I -from 7 -to 0 ch1_txrate_1
  create_bd_pin -dir I -from 7 -to 0 ch2_txrate_1
  create_bd_pin -dir I -from 7 -to 0 ch3_txrate_1
  create_bd_pin -dir I -from 7 -to 0 ch0_rxrate_1
  create_bd_pin -dir I -from 7 -to 0 ch1_rxrate_1
  create_bd_pin -dir I -from 7 -to 0 ch2_rxrate_1
  create_bd_pin -dir I -from 7 -to 0 ch3_rxrate_1
  create_bd_pin -dir I -from 2 -to 0 ch0_loopback_1
  create_bd_pin -dir I -from 2 -to 0 ch1_loopback_1
  create_bd_pin -dir I -from 2 -to 0 ch2_loopback_1
  create_bd_pin -dir I -from 2 -to 0 ch3_loopback_1

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDS_GTME5} $util_ds_buf_0


  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDS_GTME5} $util_ds_buf_1


  # Create instance: gt_quad_base, and set properties
  set gt_quad_base [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {200.0} \
    CONFIG.CHANNEL_ORDERING {/dcmac_0_gt_wrapper/gt_quad_base/TX0_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_0.0 /dcmac_0_gt_wrapper/gt_quad_base/TX1_GT_IP_Interface\
dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_1.1 /dcmac_0_gt_wrapper/gt_quad_base/TX2_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_2.2\
/dcmac_0_gt_wrapper/gt_quad_base/TX3_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_3.3 /dcmac_0_gt_wrapper/gt_quad_base/RX0_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_0.0\
/dcmac_0_gt_wrapper/gt_quad_base/RX1_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_1.1 /dcmac_0_gt_wrapper/gt_quad_base/RX2_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_2.2\
/dcmac_0_gt_wrapper/gt_quad_base/RX3_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_3.3} \
    CONFIG.GT_TYPE {GTM} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTM REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL PAM4 TX_HD_EN 0 TX_GRAY_BYP false TX_GRAY_LITTLEENDIAN false TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 53.125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH\
160 TX_INT_DATA_WIDTH 128 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 664.062\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET GTM-PAM4_Ethernet_53G\
RX_PAM_SEL PAM4 RX_HD_EN 0 RX_GRAY_BYP false RX_GRAY_LITTLEENDIAN false RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET PAM4_Ethernet_53G RX_LINE_RATE 53.125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY\
156.25 RX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 160 RX_INT_DATA_WIDTH 128\
RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 664.062 RXRECCLK_FREQ_ENABLE false RXRECCLK_FREQ_VAL 0 INS_LOSS_NYQ 20 RX_EQ_MODE\
AUTO RX_COUPLING AC RX_TERMINATION VCOM_VREF RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 200 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CB_K 00000000 RX_CB_DISP 00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1\
false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0\
0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2\
false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT\
0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0\
false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3\
false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000\
RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTM} \
    CONFIG.PROT0_LR10_SETTINGS {NA NA} \
    CONFIG.PROT0_LR11_SETTINGS {NA NA} \
    CONFIG.PROT0_LR12_SETTINGS {NA NA} \
    CONFIG.PROT0_LR13_SETTINGS {NA NA} \
    CONFIG.PROT0_LR14_SETTINGS {NA NA} \
    CONFIG.PROT0_LR15_SETTINGS {NA NA} \
    CONFIG.PROT0_LR1_SETTINGS {NA NA} \
    CONFIG.PROT0_LR2_SETTINGS {NA NA} \
    CONFIG.PROT0_LR3_SETTINGS {NA NA} \
    CONFIG.PROT0_LR4_SETTINGS {NA NA} \
    CONFIG.PROT0_LR5_SETTINGS {NA NA} \
    CONFIG.PROT0_LR6_SETTINGS {NA NA} \
    CONFIG.PROT0_LR7_SETTINGS {NA NA} \
    CONFIG.PROT0_LR8_SETTINGS {NA NA} \
    CONFIG.PROT0_LR9_SETTINGS {NA NA} \
    CONFIG.PROT0_NO_OF_LANES {4} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_0_/dcmac_0_gt_wrapper/gt_quad_base {/dcmac_0_gt_wrapper/gt_quad_base dcmac_0_exdes_support_dcmac_0_core_0.IP_CH0,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH1,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH2,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1} TXQuad_1_/dcmac_0_gt_wrapper/gt_quad_base_1 {/dcmac_0_gt_wrapper/gt_quad_base_1 dcmac_0_exdes_support_dcmac_0_core_0.IP_CH4,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH5,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH6,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH7\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 0}} RX_QUAD_CH {RXQuad_0_/dcmac_0_gt_wrapper/gt_quad_base {/dcmac_0_gt_wrapper/gt_quad_base dcmac_0_exdes_support_dcmac_0_core_0.IP_CH0,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH1,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH2,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1} RXQuad_1_/dcmac_0_gt_wrapper/gt_quad_base_1 {/dcmac_0_gt_wrapper/gt_quad_base_1 dcmac_0_exdes_support_dcmac_0_core_0.IP_CH4,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH5,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH6,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH7\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 0}}} \
    CONFIG.REFCLK_LIST {{/CLK_IN_D_0_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT0} \
    CONFIG.RX2_LANE_SEL {PROT0} \
    CONFIG.RX3_LANE_SEL {PROT0} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT0} \
    CONFIG.TX2_LANE_SEL {PROT0} \
    CONFIG.TX3_LANE_SEL {PROT0} \
  ] $gt_quad_base

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.GT_TYPE.VALUE_MODE {auto} \
    CONFIG.PROT0_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT0_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT0_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.QUAD_USAGE.VALUE_MODE {auto} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {auto} \
  ] $gt_quad_base


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {1} \
    CONFIG.CONST_WIDTH {1} \
  ] $xlconstant_0


  # Create instance: bufg_gt_odiv2, and set properties
  set bufg_gt_odiv2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:bufg_gt:1.0 bufg_gt_odiv2 ]

  # Create instance: util_ds_buf_mbufg_rx_0, and set properties
  set util_ds_buf_mbufg_rx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_mbufg_rx_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $util_ds_buf_mbufg_rx_0


  # Create instance: util_ds_buf_mbufg_tx_0, and set properties
  set util_ds_buf_mbufg_tx_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_mbufg_tx_0 ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {MBUFG_GT} \
  ] $util_ds_buf_mbufg_tx_0


  # Create instance: gt_quad_base_1, and set properties
  set gt_quad_base_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_base_1 ]
  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY {200.0} \
    CONFIG.CHANNEL_ORDERING {/dcmac_0_gt_wrapper/gt_quad_base_1/TX0_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_4.4 /dcmac_0_gt_wrapper/gt_quad_base_1/TX1_GT_IP_Interface\
dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_5.5 /dcmac_0_gt_wrapper/gt_quad_base_1/TX2_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_6.6\
/dcmac_0_gt_wrapper/gt_quad_base_1/TX3_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_tx_serdes_interface_7.7 /dcmac_0_gt_wrapper/gt_quad_base_1/RX0_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_4.4\
/dcmac_0_gt_wrapper/gt_quad_base_1/RX1_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_5.5 /dcmac_0_gt_wrapper/gt_quad_base_1/RX2_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_6.6\
/dcmac_0_gt_wrapper/gt_quad_base_1/RX3_GT_IP_Interface dcmac_0_exdes_support_dcmac_0_core_0./dcmac_0_core/gtm_rx_serdes_interface_7.7} \
    CONFIG.GT_TYPE {GTM} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTM REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.PROT0_ENABLE {true} \
    CONFIG.PROT0_GT_DIRECTION {DUPLEX} \
    CONFIG.PROT0_LR0_SETTINGS {GT_DIRECTION DUPLEX TX_PAM_SEL PAM4 TX_HD_EN 0 TX_GRAY_BYP false TX_GRAY_LITTLEENDIAN false TX_PRECODE_BYP true TX_PRECODE_LITTLEENDIAN false TX_LINE_RATE 53.125 TX_PLL_TYPE\
LCPLL TX_REFCLK_FREQUENCY 156.25 TX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 TX_FRACN_ENABLED false TX_FRACN_OVRD false TX_FRACN_NUMERATOR 0 TX_REFCLK_SOURCE R0 TX_DATA_ENCODING RAW TX_USER_DATA_WIDTH\
160 TX_INT_DATA_WIDTH 128 TX_BUFFER_MODE 1 TX_BUFFER_BYPASS_MODE Fast_Sync TX_PIPM_ENABLE false TX_OUTCLK_SOURCE TXPROGDIVCLK TXPROGDIV_FREQ_ENABLE true TXPROGDIV_FREQ_SOURCE LCPLL TXPROGDIV_FREQ_VAL 664.062\
TX_DIFF_SWING_EMPH_MODE CUSTOM TX_64B66B_SCRAMBLER false TX_64B66B_ENCODER false TX_64B66B_CRC false TX_RATE_GROUP A TX_LANE_DESKEW_HDMI_ENABLE false TX_BUFFER_RESET_ON_RATE_CHANGE ENABLE PRESET GTM-PAM4_Ethernet_53G\
RX_PAM_SEL PAM4 RX_HD_EN 0 RX_GRAY_BYP false RX_GRAY_LITTLEENDIAN false RX_PRECODE_BYP true RX_PRECODE_LITTLEENDIAN false INTERNAL_PRESET PAM4_Ethernet_53G RX_LINE_RATE 53.125 RX_PLL_TYPE LCPLL RX_REFCLK_FREQUENCY\
156.25 RX_ACTUAL_REFCLK_FREQUENCY 156.250000000000 RX_FRACN_ENABLED false RX_FRACN_OVRD false RX_FRACN_NUMERATOR 0 RX_REFCLK_SOURCE R0 RX_DATA_DECODING RAW RX_USER_DATA_WIDTH 160 RX_INT_DATA_WIDTH 128\
RX_BUFFER_MODE 1 RX_OUTCLK_SOURCE RXPROGDIVCLK RXPROGDIV_FREQ_ENABLE true RXPROGDIV_FREQ_SOURCE LCPLL RXPROGDIV_FREQ_VAL 664.062 RXRECCLK_FREQ_ENABLE false RXRECCLK_FREQ_VAL 0 INS_LOSS_NYQ 20 RX_EQ_MODE\
AUTO RX_COUPLING AC RX_TERMINATION VCOM_VREF RX_RATE_GROUP A RX_TERMINATION_PROG_VALUE 800 RX_PPM_OFFSET 200 RX_64B66B_DESCRAMBLER false RX_64B66B_DECODER false RX_64B66B_CRC false OOB_ENABLE false RX_COMMA_ALIGN_WORD\
1 RX_COMMA_SHOW_REALIGN_ENABLE true PCIE_ENABLE false RX_COMMA_P_ENABLE false RX_COMMA_M_ENABLE false RX_COMMA_DOUBLE_ENABLE false RX_COMMA_P_VAL 0101111100 RX_COMMA_M_VAL 1010000011 RX_COMMA_MASK 0000000000\
RX_SLIDE_MODE OFF RX_SSC_PPM 0 RX_CB_NUM_SEQ 0 RX_CB_LEN_SEQ 1 RX_CB_MAX_SKEW 1 RX_CB_MAX_LEVEL 1 RX_CB_MASK 00000000 RX_CB_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000\
RX_CB_K 00000000 RX_CB_DISP 00000000 RX_CB_MASK_0_0 false RX_CB_VAL_0_0 0000000000 RX_CB_K_0_0 false RX_CB_DISP_0_0 false RX_CB_MASK_0_1 false RX_CB_VAL_0_1 0000000000 RX_CB_K_0_1 false RX_CB_DISP_0_1\
false RX_CB_MASK_0_2 false RX_CB_VAL_0_2 0000000000 RX_CB_K_0_2 false RX_CB_DISP_0_2 false RX_CB_MASK_0_3 false RX_CB_VAL_0_3 0000000000 RX_CB_K_0_3 false RX_CB_DISP_0_3 false RX_CB_MASK_1_0 false RX_CB_VAL_1_0\
0000000000 RX_CB_K_1_0 false RX_CB_DISP_1_0 false RX_CB_MASK_1_1 false RX_CB_VAL_1_1 0000000000 RX_CB_K_1_1 false RX_CB_DISP_1_1 false RX_CB_MASK_1_2 false RX_CB_VAL_1_2 0000000000 RX_CB_K_1_2 false RX_CB_DISP_1_2\
false RX_CB_MASK_1_3 false RX_CB_VAL_1_3 0000000000 RX_CB_K_1_3 false RX_CB_DISP_1_3 false RX_CC_NUM_SEQ 0 RX_CC_LEN_SEQ 1 RX_CC_PERIODICITY 5000 RX_CC_KEEP_IDLE DISABLE RX_CC_PRECEDENCE ENABLE RX_CC_REPEAT_WAIT\
0 RX_CC_MASK 00000000 RX_CC_VAL 00000000000000000000000000000000000000000000000000000000000000000000000000000000 RX_CC_K 00000000 RX_CC_DISP 00000000 RX_CC_MASK_0_0 false RX_CC_VAL_0_0 0000000000 RX_CC_K_0_0\
false RX_CC_DISP_0_0 false RX_CC_MASK_0_1 false RX_CC_VAL_0_1 0000000000 RX_CC_K_0_1 false RX_CC_DISP_0_1 false RX_CC_MASK_0_2 false RX_CC_VAL_0_2 0000000000 RX_CC_K_0_2 false RX_CC_DISP_0_2 false RX_CC_MASK_0_3\
false RX_CC_VAL_0_3 0000000000 RX_CC_K_0_3 false RX_CC_DISP_0_3 false RX_CC_MASK_1_0 false RX_CC_VAL_1_0 0000000000 RX_CC_K_1_0 false RX_CC_DISP_1_0 false RX_CC_MASK_1_1 false RX_CC_VAL_1_1 0000000000\
RX_CC_K_1_1 false RX_CC_DISP_1_1 false RX_CC_MASK_1_2 false RX_CC_VAL_1_2 0000000000 RX_CC_K_1_2 false RX_CC_DISP_1_2 false RX_CC_MASK_1_3 false RX_CC_VAL_1_3 0000000000 RX_CC_K_1_3 false RX_CC_DISP_1_3\
false PCIE_USERCLK2_FREQ 250 PCIE_USERCLK_FREQ 250 RX_JTOL_FC 10 RX_JTOL_LF_SLOPE -20 RX_BUFFER_BYPASS_MODE Fast_Sync RX_BUFFER_BYPASS_MODE_LANE MULTI RX_BUFFER_RESET_ON_CB_CHANGE ENABLE RX_BUFFER_RESET_ON_COMMAALIGN\
DISABLE RX_BUFFER_RESET_ON_RATE_CHANGE ENABLE RESET_SEQUENCE_INTERVAL 0 RX_COMMA_PRESET NONE RX_COMMA_VALID_ONLY 0 GT_TYPE GTM} \
    CONFIG.PROT0_LR10_SETTINGS {NA NA} \
    CONFIG.PROT0_LR11_SETTINGS {NA NA} \
    CONFIG.PROT0_LR12_SETTINGS {NA NA} \
    CONFIG.PROT0_LR13_SETTINGS {NA NA} \
    CONFIG.PROT0_LR14_SETTINGS {NA NA} \
    CONFIG.PROT0_LR15_SETTINGS {NA NA} \
    CONFIG.PROT0_LR1_SETTINGS {NA NA} \
    CONFIG.PROT0_LR2_SETTINGS {NA NA} \
    CONFIG.PROT0_LR3_SETTINGS {NA NA} \
    CONFIG.PROT0_LR4_SETTINGS {NA NA} \
    CONFIG.PROT0_LR5_SETTINGS {NA NA} \
    CONFIG.PROT0_LR6_SETTINGS {NA NA} \
    CONFIG.PROT0_LR7_SETTINGS {NA NA} \
    CONFIG.PROT0_LR8_SETTINGS {NA NA} \
    CONFIG.PROT0_LR9_SETTINGS {NA NA} \
    CONFIG.PROT0_NO_OF_LANES {4} \
    CONFIG.PROT0_RX_MASTERCLK_SRC {RX0} \
    CONFIG.PROT0_TX_MASTERCLK_SRC {TX0} \
    CONFIG.QUAD_USAGE {TX_QUAD_CH {TXQuad_-1_/dcmac_0_gt_wrapper/gt_quad_base {/dcmac_0_gt_wrapper/gt_quad_base dcmac_0_exdes_support_dcmac_0_core_0.IP_CH0,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH1,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH2,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 0} TXQuad_0_/dcmac_0_gt_wrapper/gt_quad_base_1 {/dcmac_0_gt_wrapper/gt_quad_base_1 dcmac_0_exdes_support_dcmac_0_core_0.IP_CH4,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH5,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH6,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH7\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}} RX_QUAD_CH {RXQuad_-1_/dcmac_0_gt_wrapper/gt_quad_base {/dcmac_0_gt_wrapper/gt_quad_base dcmac_0_exdes_support_dcmac_0_core_0.IP_CH0,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH1,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH2,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH3\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 0} RXQuad_0_/dcmac_0_gt_wrapper/gt_quad_base_1 {/dcmac_0_gt_wrapper/gt_quad_base_1 dcmac_0_exdes_support_dcmac_0_core_0.IP_CH4,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH5,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH6,dcmac_0_exdes_support_dcmac_0_core_0.IP_CH7\
MSTRCLK 1,0,0,0 IS_CURRENT_QUAD 1}}} \
    CONFIG.REFCLK_LIST {{/CLK_IN_D_1_clk_p[0]}} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    CONFIG.RX0_LANE_SEL {PROT0} \
    CONFIG.RX1_LANE_SEL {PROT0} \
    CONFIG.RX2_LANE_SEL {PROT0} \
    CONFIG.RX3_LANE_SEL {PROT0} \
    CONFIG.TX0_LANE_SEL {PROT0} \
    CONFIG.TX1_LANE_SEL {PROT0} \
    CONFIG.TX2_LANE_SEL {PROT0} \
    CONFIG.TX3_LANE_SEL {PROT0} \
  ] $gt_quad_base_1

  set_property -dict [list \
    CONFIG.APB3_CLK_FREQUENCY.VALUE_MODE {auto} \
    CONFIG.CHANNEL_ORDERING.VALUE_MODE {auto} \
    CONFIG.GT_TYPE.VALUE_MODE {auto} \
    CONFIG.PROT0_ENABLE.VALUE_MODE {auto} \
    CONFIG.PROT0_GT_DIRECTION.VALUE_MODE {auto} \
    CONFIG.PROT0_LR0_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR10_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR11_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR12_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR13_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR14_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR15_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR1_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR2_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR3_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR4_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR5_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR6_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR7_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR8_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_LR9_SETTINGS.VALUE_MODE {auto} \
    CONFIG.PROT0_NO_OF_LANES.VALUE_MODE {auto} \
    CONFIG.PROT0_RX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.PROT0_TX_MASTERCLK_SRC.VALUE_MODE {auto} \
    CONFIG.QUAD_USAGE.VALUE_MODE {auto} \
    CONFIG.RX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.RX3_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX0_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX1_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX2_LANE_SEL.VALUE_MODE {auto} \
    CONFIG.TX3_LANE_SEL.VALUE_MODE {auto} \
  ] $gt_quad_base_1


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_pins CLK_IN_D_0] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D1]
  connect_bd_intf_net -intf_net CLK_IN_D_1_1 [get_bd_intf_pins CLK_IN_D_1] [get_bd_intf_pins util_ds_buf_1/CLK_IN_D1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_0 [get_bd_intf_pins RX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_1 [get_bd_intf_pins RX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_2 [get_bd_intf_pins RX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_3 [get_bd_intf_pins RX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_4 [get_bd_intf_pins RX0_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_5 [get_bd_intf_pins RX1_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_6 [get_bd_intf_pins RX2_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_7 [get_bd_intf_pins RX3_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_0 [get_bd_intf_pins TX0_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_1 [get_bd_intf_pins TX1_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_2 [get_bd_intf_pins TX2_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_3 [get_bd_intf_pins TX3_GT_IP_Interface] [get_bd_intf_pins gt_quad_base/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_4 [get_bd_intf_pins TX0_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_5 [get_bd_intf_pins TX1_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_6 [get_bd_intf_pins TX2_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_7 [get_bd_intf_pins TX3_GT_IP_Interface1] [get_bd_intf_pins gt_quad_base_1/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net gt_quad_base_1_GT_NORTHIN_SOUTHOUT [get_bd_intf_pins gt_quad_base/GT_NORTHOUT_SOUTHIN] [get_bd_intf_pins gt_quad_base_1/GT_NORTHIN_SOUTHOUT]
  connect_bd_intf_net -intf_net gt_quad_base_1_GT_Serial [get_bd_intf_pins GT_Serial_1] [get_bd_intf_pins gt_quad_base_1/GT_Serial]
  connect_bd_intf_net -intf_net gt_quad_base_GT_Serial [get_bd_intf_pins GT_Serial] [get_bd_intf_pins gt_quad_base/GT_Serial]

  # Create port connections
  connect_bd_net -net apb3clk_quad_1 [get_bd_pins apb3clk_quad] [get_bd_pins gt_quad_base_1/apb3clk] [get_bd_pins gt_quad_base/apb3clk]
  connect_bd_net -net bufg_gt_odiv2_usrclk [get_bd_pins bufg_gt_odiv2/usrclk] [get_bd_pins IBUFDS_ODIV2]
  connect_bd_net -net ch0_loopback_0_1 [get_bd_pins ch0_loopback_0] [get_bd_pins gt_quad_base/ch0_loopback]
  connect_bd_net -net ch0_loopback_1_1 [get_bd_pins ch0_loopback_1] [get_bd_pins gt_quad_base_1/ch0_loopback]
  connect_bd_net -net ch0_rxrate_0_1 [get_bd_pins ch0_rxrate_0] [get_bd_pins gt_quad_base/ch0_rxrate]
  connect_bd_net -net ch0_rxrate_1_1 [get_bd_pins ch0_rxrate_1] [get_bd_pins gt_quad_base_1/ch0_rxrate]
  connect_bd_net -net ch0_txrate_0_1 [get_bd_pins ch0_txrate_0] [get_bd_pins gt_quad_base/ch0_txrate]
  connect_bd_net -net ch0_txrate_1_1 [get_bd_pins ch0_txrate_1] [get_bd_pins gt_quad_base_1/ch0_txrate]
  connect_bd_net -net ch1_loopback_0_1 [get_bd_pins ch1_loopback_0] [get_bd_pins gt_quad_base/ch1_loopback]
  connect_bd_net -net ch1_loopback_1_1 [get_bd_pins ch1_loopback_1] [get_bd_pins gt_quad_base_1/ch1_loopback]
  connect_bd_net -net ch1_rxrate_0_1 [get_bd_pins ch1_rxrate_0] [get_bd_pins gt_quad_base/ch1_rxrate]
  connect_bd_net -net ch1_rxrate_1_1 [get_bd_pins ch1_rxrate_1] [get_bd_pins gt_quad_base_1/ch1_rxrate]
  connect_bd_net -net ch1_txrate_0_1 [get_bd_pins ch1_txrate_0] [get_bd_pins gt_quad_base/ch1_txrate]
  connect_bd_net -net ch1_txrate_1_1 [get_bd_pins ch1_txrate_1] [get_bd_pins gt_quad_base_1/ch1_txrate]
  connect_bd_net -net ch2_loopback_0_1 [get_bd_pins ch2_loopback_0] [get_bd_pins gt_quad_base/ch2_loopback]
  connect_bd_net -net ch2_loopback_1_1 [get_bd_pins ch2_loopback_1] [get_bd_pins gt_quad_base_1/ch2_loopback]
  connect_bd_net -net ch2_rxrate_0_1 [get_bd_pins ch2_rxrate_0] [get_bd_pins gt_quad_base/ch2_rxrate]
  connect_bd_net -net ch2_rxrate_1_1 [get_bd_pins ch2_rxrate_1] [get_bd_pins gt_quad_base_1/ch2_rxrate]
  connect_bd_net -net ch2_txrate_0_1 [get_bd_pins ch2_txrate_0] [get_bd_pins gt_quad_base/ch2_txrate]
  connect_bd_net -net ch2_txrate_1_1 [get_bd_pins ch2_txrate_1] [get_bd_pins gt_quad_base_1/ch2_txrate]
  connect_bd_net -net ch3_loopback_0_1 [get_bd_pins ch3_loopback_0] [get_bd_pins gt_quad_base/ch3_loopback]
  connect_bd_net -net ch3_loopback_1_1 [get_bd_pins ch3_loopback_1] [get_bd_pins gt_quad_base_1/ch3_loopback]
  connect_bd_net -net ch3_rxrate_0_1 [get_bd_pins ch3_rxrate_0] [get_bd_pins gt_quad_base/ch3_rxrate]
  connect_bd_net -net ch3_rxrate_1_1 [get_bd_pins ch3_rxrate_1] [get_bd_pins gt_quad_base_1/ch3_rxrate]
  connect_bd_net -net ch3_txrate_0_1 [get_bd_pins ch3_txrate_0] [get_bd_pins gt_quad_base/ch3_txrate]
  connect_bd_net -net ch3_txrate_1_1 [get_bd_pins ch3_txrate_1] [get_bd_pins gt_quad_base_1/ch3_txrate]
  connect_bd_net -net dcmac_0_core_iloreset_out_0 [get_bd_pins ch0_iloreset] [get_bd_pins gt_quad_base/ch0_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_1 [get_bd_pins ch1_iloreset] [get_bd_pins gt_quad_base/ch1_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_2 [get_bd_pins ch2_iloreset] [get_bd_pins gt_quad_base/ch2_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_3 [get_bd_pins ch3_iloreset] [get_bd_pins gt_quad_base/ch3_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_4 [get_bd_pins ch0_iloreset1] [get_bd_pins gt_quad_base_1/ch0_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_5 [get_bd_pins ch1_iloreset1] [get_bd_pins gt_quad_base_1/ch1_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_6 [get_bd_pins ch2_iloreset1] [get_bd_pins gt_quad_base_1/ch2_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_7 [get_bd_pins ch3_iloreset1] [get_bd_pins gt_quad_base_1/ch3_iloreset]
  connect_bd_net -net dcmac_0_core_pllreset_out_0 [get_bd_pins hsclk1_lcpllreset] [get_bd_pins gt_quad_base/hsclk1_lcpllreset] [get_bd_pins gt_quad_base/hsclk0_rpllreset] [get_bd_pins gt_quad_base/hsclk1_rpllreset] [get_bd_pins gt_quad_base/hsclk0_lcpllreset]
  connect_bd_net -net dcmac_0_core_pllreset_out_1 [get_bd_pins hsclk0_rpllreset] [get_bd_pins gt_quad_base_1/hsclk0_rpllreset] [get_bd_pins gt_quad_base_1/hsclk1_lcpllreset] [get_bd_pins gt_quad_base_1/hsclk1_rpllreset] [get_bd_pins gt_quad_base_1/hsclk0_lcpllreset]
  connect_bd_net -net dcmac_0_core_rx_clr_out_0 [get_bd_pins MBUFG_GT_CLR] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_CLR]
  connect_bd_net -net dcmac_0_core_rx_clrb_leaf_out_0 [get_bd_pins MBUFG_GT_CLRB_LEAF] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net dcmac_0_core_tx_clr_out_0 [get_bd_pins MBUFG_GT_CLR1] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_CLR]
  connect_bd_net -net dcmac_0_core_tx_clrb_leaf_out_0 [get_bd_pins MBUFG_GT_CLRB_LEAF1] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net gt_quad_base_1_ch0_iloresetdone [get_bd_pins gt_quad_base_1/ch0_iloresetdone] [get_bd_pins ch0_iloresetdone1]
  connect_bd_net -net gt_quad_base_1_ch1_iloresetdone [get_bd_pins gt_quad_base_1/ch1_iloresetdone] [get_bd_pins ch1_iloresetdone1]
  connect_bd_net -net gt_quad_base_1_ch2_iloresetdone [get_bd_pins gt_quad_base_1/ch2_iloresetdone] [get_bd_pins ch2_iloresetdone1]
  connect_bd_net -net gt_quad_base_1_ch3_iloresetdone [get_bd_pins gt_quad_base_1/ch3_iloresetdone] [get_bd_pins ch3_iloresetdone1]
  connect_bd_net -net gt_quad_base_1_gtpowergood [get_bd_pins gt_quad_base_1/gtpowergood] [get_bd_pins gtpowergood_1]
  connect_bd_net -net gt_quad_base_1_hsclk0_lcplllock [get_bd_pins gt_quad_base_1/hsclk0_lcplllock] [get_bd_pins hsclk0_lcplllock1]
  connect_bd_net -net gt_quad_base_ch0_iloresetdone [get_bd_pins gt_quad_base/ch0_iloresetdone] [get_bd_pins ch0_iloresetdone]
  connect_bd_net -net gt_quad_base_ch0_rxoutclk [get_bd_pins gt_quad_base/ch0_rxoutclk] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch0_txoutclk [get_bd_pins gt_quad_base/ch0_txoutclk] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_I]
  connect_bd_net -net gt_quad_base_ch1_iloresetdone [get_bd_pins gt_quad_base/ch1_iloresetdone] [get_bd_pins ch1_iloresetdone]
  connect_bd_net -net gt_quad_base_ch2_iloresetdone [get_bd_pins gt_quad_base/ch2_iloresetdone] [get_bd_pins ch2_iloresetdone]
  connect_bd_net -net gt_quad_base_ch3_iloresetdone [get_bd_pins gt_quad_base/ch3_iloresetdone] [get_bd_pins ch3_iloresetdone]
  connect_bd_net -net gt_quad_base_gpo [get_bd_pins gt_quad_base/gpo] [get_bd_pins gpo]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins gt_quad_base/gtpowergood] [get_bd_pins gtpowergood_0]
  connect_bd_net -net gt_quad_base_hsclk0_lcplllock [get_bd_pins gt_quad_base/hsclk0_lcplllock] [get_bd_pins hsclk0_lcplllock]
  connect_bd_net -net gt_rxcdrhold_1 [get_bd_pins gt_rxcdrhold] [get_bd_pins gt_quad_base/ch1_rxcdrhold] [get_bd_pins gt_quad_base/ch2_rxcdrhold] [get_bd_pins gt_quad_base/ch3_rxcdrhold] [get_bd_pins gt_quad_base_1/ch0_rxcdrhold] [get_bd_pins gt_quad_base_1/ch1_rxcdrhold] [get_bd_pins gt_quad_base_1/ch2_rxcdrhold] [get_bd_pins gt_quad_base_1/ch3_rxcdrhold] [get_bd_pins gt_quad_base/ch0_rxcdrhold]
  connect_bd_net -net gt_txmaincursor_1 [get_bd_pins gt_txmaincursor] [get_bd_pins gt_quad_base/ch1_txmaincursor] [get_bd_pins gt_quad_base/ch2_txmaincursor] [get_bd_pins gt_quad_base/ch3_txmaincursor] [get_bd_pins gt_quad_base_1/ch0_txmaincursor] [get_bd_pins gt_quad_base_1/ch1_txmaincursor] [get_bd_pins gt_quad_base_1/ch2_txmaincursor] [get_bd_pins gt_quad_base_1/ch3_txmaincursor] [get_bd_pins gt_quad_base/ch0_txmaincursor]
  connect_bd_net -net gt_txpostcursor_1 [get_bd_pins gt_txpostcursor] [get_bd_pins gt_quad_base/ch1_txpostcursor] [get_bd_pins gt_quad_base/ch2_txpostcursor] [get_bd_pins gt_quad_base/ch3_txpostcursor] [get_bd_pins gt_quad_base_1/ch0_txpostcursor] [get_bd_pins gt_quad_base_1/ch1_txpostcursor] [get_bd_pins gt_quad_base_1/ch2_txpostcursor] [get_bd_pins gt_quad_base_1/ch3_txpostcursor] [get_bd_pins gt_quad_base/ch0_txpostcursor]
  connect_bd_net -net gt_txprecursor_1 [get_bd_pins gt_txprecursor] [get_bd_pins gt_quad_base/ch1_txprecursor] [get_bd_pins gt_quad_base/ch2_txprecursor] [get_bd_pins gt_quad_base/ch3_txprecursor] [get_bd_pins gt_quad_base_1/ch0_txprecursor] [get_bd_pins gt_quad_base_1/ch1_txprecursor] [get_bd_pins gt_quad_base_1/ch2_txprecursor] [get_bd_pins gt_quad_base_1/ch3_txprecursor] [get_bd_pins gt_quad_base/ch0_txprecursor]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins gt_quad_base_1/apb3presetn] [get_bd_pins gt_quad_base/apb3presetn]
  connect_bd_net -net util_ds_buf_0_IBUFDS_GTME5_O [get_bd_pins util_ds_buf_0/IBUFDS_GTME5_O] [get_bd_pins gt_quad_base/GT_REFCLK0]
  connect_bd_net -net util_ds_buf_0_IBUFDS_GTME5_ODIV2 [get_bd_pins util_ds_buf_0/IBUFDS_GTME5_ODIV2] [get_bd_pins bufg_gt_odiv2/outclk]
  connect_bd_net -net util_ds_buf_1_IBUFDS_GTME5_O [get_bd_pins util_ds_buf_1/IBUFDS_GTME5_O] [get_bd_pins gt_quad_base_1/GT_REFCLK0]
  connect_bd_net -net util_ds_buf_mbufg_rx_0_MBUFG_GT_O1 [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_O1] [get_bd_pins ch0_rx_usr_clk_0]
  connect_bd_net -net util_ds_buf_mbufg_rx_0_MBUFG_GT_O2 [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_O2] [get_bd_pins ch0_rx_usr_clk2_0] [get_bd_pins gt_quad_base/ch0_rxusrclk] [get_bd_pins gt_quad_base/ch1_rxusrclk] [get_bd_pins gt_quad_base/ch2_rxusrclk] [get_bd_pins gt_quad_base/ch3_rxusrclk] [get_bd_pins gt_quad_base_1/ch0_rxusrclk] [get_bd_pins gt_quad_base_1/ch1_rxusrclk] [get_bd_pins gt_quad_base_1/ch2_rxusrclk] [get_bd_pins gt_quad_base_1/ch3_rxusrclk]
  connect_bd_net -net util_ds_buf_mbufg_tx_0_MBUFG_GT_O1 [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_O1] [get_bd_pins ch0_tx_usr_clk_0]
  connect_bd_net -net util_ds_buf_mbufg_tx_0_MBUFG_GT_O2 [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_O2] [get_bd_pins ch0_tx_usr_clk2_0] [get_bd_pins gt_quad_base/ch0_txusrclk] [get_bd_pins gt_quad_base/ch1_txusrclk] [get_bd_pins gt_quad_base/ch2_txusrclk] [get_bd_pins gt_quad_base/ch3_txusrclk] [get_bd_pins gt_quad_base_1/ch0_txusrclk] [get_bd_pins gt_quad_base_1/ch1_txusrclk] [get_bd_pins gt_quad_base_1/ch2_txusrclk] [get_bd_pins gt_quad_base_1/ch3_txusrclk]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins util_ds_buf_mbufg_tx_0/MBUFG_GT_CE] [get_bd_pins util_ds_buf_mbufg_rx_0/MBUFG_GT_CE]

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
  set GT_Serial [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial ]

  set GT_Serial_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 GT_Serial_1 ]

  set CLK_IN_D_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $CLK_IN_D_0

  set CLK_IN_D_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $CLK_IN_D_1

  set s_axi [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $s_axi

  set ctl_txrx_port0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_txrx_port0 ]

  set ctl_txrx_port1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_txrx_port1 ]

  set ctl_txrx_port2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_txrx_port2 ]

  set ctl_txrx_port3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_txrx_port3 ]

  set ctl_txrx_port4 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_txrx_port4 ]

  set ctl_txrx_port5 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_txrx_port5 ]

  set ctl_port [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_dcmac:dcmac_ctrl_ports:2.0 ctl_port ]


  # Create ports
  set apb3clk_quad [ create_bd_port -dir I -type clk -freq_hz 200000000 apb3clk_quad ]
  set tx_axi_clk [ create_bd_port -dir I -type clk -freq_hz 390625000 tx_axi_clk ]
  set rx_axi_clk [ create_bd_port -dir I -type clk -freq_hz 390625000 rx_axi_clk ]
  set tx_core_reset [ create_bd_port -dir I -type rst tx_core_reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $tx_core_reset
  set rx_core_reset [ create_bd_port -dir I -type rst rx_core_reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $rx_core_reset
  set tx_serdes_reset [ create_bd_port -dir I -from 5 -to 0 -type rst tx_serdes_reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $tx_serdes_reset
  set rx_serdes_reset [ create_bd_port -dir I -from 5 -to 0 -type rst rx_serdes_reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $rx_serdes_reset
  set rx_macif_clk [ create_bd_port -dir I -type clk rx_macif_clk ]
  set tx_macif_clk [ create_bd_port -dir I -type clk tx_macif_clk ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]
  set IBUFDS_ODIV2 [ create_bd_port -dir O -type gt_usrclk IBUFDS_ODIV2 ]
  set gt_rxcdrhold [ create_bd_port -dir I gt_rxcdrhold ]
  set gt_txprecursor [ create_bd_port -dir I -from 5 -to 0 gt_txprecursor ]
  set gt_txpostcursor [ create_bd_port -dir I -from 5 -to 0 gt_txpostcursor ]
  set gt_txmaincursor [ create_bd_port -dir I -from 6 -to 0 gt_txmaincursor ]
  set ch0_tx_usr_clk_0 [ create_bd_port -dir O -from 0 -to 0 -type gt_usrclk ch0_tx_usr_clk_0 ]
  set ch0_tx_usr_clk2_0 [ create_bd_port -dir O -from 0 -to 0 -type gt_usrclk ch0_tx_usr_clk2_0 ]
  set ch0_rx_usr_clk_0 [ create_bd_port -dir O -from 0 -to 0 -type gt_usrclk ch0_rx_usr_clk_0 ]
  set ch0_rx_usr_clk2_0 [ create_bd_port -dir O -from 0 -to 0 -type gt_usrclk ch0_rx_usr_clk2_0 ]
  set gtpowergood_0 [ create_bd_port -dir O gtpowergood_0 ]
  set ch0_txrate_0 [ create_bd_port -dir I -from 7 -to 0 ch0_txrate_0 ]
  set ch0_rxrate_0 [ create_bd_port -dir I -from 7 -to 0 ch0_rxrate_0 ]
  set ch1_txrate_0 [ create_bd_port -dir I -from 7 -to 0 ch1_txrate_0 ]
  set ch1_rxrate_0 [ create_bd_port -dir I -from 7 -to 0 ch1_rxrate_0 ]
  set ch2_txrate_0 [ create_bd_port -dir I -from 7 -to 0 ch2_txrate_0 ]
  set ch2_rxrate_0 [ create_bd_port -dir I -from 7 -to 0 ch2_rxrate_0 ]
  set ch3_txrate_0 [ create_bd_port -dir I -from 7 -to 0 ch3_txrate_0 ]
  set ch3_rxrate_0 [ create_bd_port -dir I -from 7 -to 0 ch3_rxrate_0 ]
  set ch0_loopback_0 [ create_bd_port -dir I -from 2 -to 0 ch0_loopback_0 ]
  set ch1_loopback_0 [ create_bd_port -dir I -from 2 -to 0 ch1_loopback_0 ]
  set ch2_loopback_0 [ create_bd_port -dir I -from 2 -to 0 ch2_loopback_0 ]
  set ch3_loopback_0 [ create_bd_port -dir I -from 2 -to 0 ch3_loopback_0 ]
  set gtpowergood_1 [ create_bd_port -dir O gtpowergood_1 ]
  set ch0_txrate_1 [ create_bd_port -dir I -from 7 -to 0 ch0_txrate_1 ]
  set ch0_rxrate_1 [ create_bd_port -dir I -from 7 -to 0 ch0_rxrate_1 ]
  set ch1_txrate_1 [ create_bd_port -dir I -from 7 -to 0 ch1_txrate_1 ]
  set ch1_rxrate_1 [ create_bd_port -dir I -from 7 -to 0 ch1_rxrate_1 ]
  set ch2_txrate_1 [ create_bd_port -dir I -from 7 -to 0 ch2_txrate_1 ]
  set ch2_rxrate_1 [ create_bd_port -dir I -from 7 -to 0 ch2_rxrate_1 ]
  set ch3_txrate_1 [ create_bd_port -dir I -from 7 -to 0 ch3_txrate_1 ]
  set ch3_rxrate_1 [ create_bd_port -dir I -from 7 -to 0 ch3_rxrate_1 ]
  set ch0_loopback_1 [ create_bd_port -dir I -from 2 -to 0 ch0_loopback_1 ]
  set ch1_loopback_1 [ create_bd_port -dir I -from 2 -to 0 ch1_loopback_1 ]
  set ch2_loopback_1 [ create_bd_port -dir I -from 2 -to 0 ch2_loopback_1 ]
  set ch3_loopback_1 [ create_bd_port -dir I -from 2 -to 0 ch3_loopback_1 ]
  set gpo [ create_bd_port -dir O -from 31 -to 0 gpo ]
  set tx_axis_tdata0 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata0 ]
  set tx_axis_tdata1 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata1 ]
  set tx_axis_tdata2 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata2 ]
  set tx_axis_tdata3 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata3 ]
  set tx_axis_tdata4 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata4 ]
  set tx_axis_tdata5 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata5 ]
  set tx_axis_tdata6 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata6 ]
  set tx_axis_tdata7 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata7 ]
  set tx_axis_tdata8 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata8 ]
  set tx_axis_tdata9 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata9 ]
  set tx_axis_tdata10 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata10 ]
  set tx_axis_tdata11 [ create_bd_port -dir I -from 127 -to 0 tx_axis_tdata11 ]
  set tx_axis_tid [ create_bd_port -dir I -from 5 -to 0 tx_axis_tid ]
  set tx_axis_tuser_ena0 [ create_bd_port -dir I tx_axis_tuser_ena0 ]
  set tx_axis_tuser_ena1 [ create_bd_port -dir I tx_axis_tuser_ena1 ]
  set tx_axis_tuser_ena2 [ create_bd_port -dir I tx_axis_tuser_ena2 ]
  set tx_axis_tuser_ena3 [ create_bd_port -dir I tx_axis_tuser_ena3 ]
  set tx_axis_tuser_ena4 [ create_bd_port -dir I tx_axis_tuser_ena4 ]
  set tx_axis_tuser_ena5 [ create_bd_port -dir I tx_axis_tuser_ena5 ]
  set tx_axis_tuser_ena6 [ create_bd_port -dir I tx_axis_tuser_ena6 ]
  set tx_axis_tuser_ena7 [ create_bd_port -dir I tx_axis_tuser_ena7 ]
  set tx_axis_tuser_ena8 [ create_bd_port -dir I tx_axis_tuser_ena8 ]
  set tx_axis_tuser_ena9 [ create_bd_port -dir I tx_axis_tuser_ena9 ]
  set tx_axis_tuser_ena10 [ create_bd_port -dir I tx_axis_tuser_ena10 ]
  set tx_axis_tuser_ena11 [ create_bd_port -dir I tx_axis_tuser_ena11 ]
  set tx_axis_tuser_eop0 [ create_bd_port -dir I tx_axis_tuser_eop0 ]
  set tx_axis_tuser_eop1 [ create_bd_port -dir I tx_axis_tuser_eop1 ]
  set tx_axis_tuser_eop2 [ create_bd_port -dir I tx_axis_tuser_eop2 ]
  set tx_axis_tuser_eop3 [ create_bd_port -dir I tx_axis_tuser_eop3 ]
  set tx_axis_tuser_eop4 [ create_bd_port -dir I tx_axis_tuser_eop4 ]
  set tx_axis_tuser_eop5 [ create_bd_port -dir I tx_axis_tuser_eop5 ]
  set tx_axis_tuser_eop6 [ create_bd_port -dir I tx_axis_tuser_eop6 ]
  set tx_axis_tuser_eop7 [ create_bd_port -dir I tx_axis_tuser_eop7 ]
  set tx_axis_tuser_eop8 [ create_bd_port -dir I tx_axis_tuser_eop8 ]
  set tx_axis_tuser_eop9 [ create_bd_port -dir I tx_axis_tuser_eop9 ]
  set tx_axis_tuser_eop10 [ create_bd_port -dir I tx_axis_tuser_eop10 ]
  set tx_axis_tuser_eop11 [ create_bd_port -dir I tx_axis_tuser_eop11 ]
  set tx_axis_tuser_err0 [ create_bd_port -dir I tx_axis_tuser_err0 ]
  set tx_axis_tuser_err1 [ create_bd_port -dir I tx_axis_tuser_err1 ]
  set tx_axis_tuser_err2 [ create_bd_port -dir I tx_axis_tuser_err2 ]
  set tx_axis_tuser_err3 [ create_bd_port -dir I tx_axis_tuser_err3 ]
  set tx_axis_tuser_err4 [ create_bd_port -dir I tx_axis_tuser_err4 ]
  set tx_axis_tuser_err5 [ create_bd_port -dir I tx_axis_tuser_err5 ]
  set tx_axis_tuser_err6 [ create_bd_port -dir I tx_axis_tuser_err6 ]
  set tx_axis_tuser_err7 [ create_bd_port -dir I tx_axis_tuser_err7 ]
  set tx_axis_tuser_err8 [ create_bd_port -dir I tx_axis_tuser_err8 ]
  set tx_axis_tuser_err9 [ create_bd_port -dir I tx_axis_tuser_err9 ]
  set tx_axis_tuser_err10 [ create_bd_port -dir I tx_axis_tuser_err10 ]
  set tx_axis_tuser_err11 [ create_bd_port -dir I tx_axis_tuser_err11 ]
  set tx_axis_tuser_mty0 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty0 ]
  set tx_axis_tuser_mty1 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty1 ]
  set tx_axis_tuser_mty2 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty2 ]
  set tx_axis_tuser_mty3 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty3 ]
  set tx_axis_tuser_mty4 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty4 ]
  set tx_axis_tuser_mty5 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty5 ]
  set tx_axis_tuser_mty6 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty6 ]
  set tx_axis_tuser_mty7 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty7 ]
  set tx_axis_tuser_mty8 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty8 ]
  set tx_axis_tuser_mty9 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty9 ]
  set tx_axis_tuser_mty10 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty10 ]
  set tx_axis_tuser_mty11 [ create_bd_port -dir I -from 3 -to 0 tx_axis_tuser_mty11 ]
  set tx_axis_tuser_skip_response [ create_bd_port -dir I tx_axis_tuser_skip_response ]
  set tx_axis_tuser_sop0 [ create_bd_port -dir I tx_axis_tuser_sop0 ]
  set tx_axis_tuser_sop1 [ create_bd_port -dir I tx_axis_tuser_sop1 ]
  set tx_axis_tuser_sop2 [ create_bd_port -dir I tx_axis_tuser_sop2 ]
  set tx_axis_tuser_sop3 [ create_bd_port -dir I tx_axis_tuser_sop3 ]
  set tx_axis_tuser_sop4 [ create_bd_port -dir I tx_axis_tuser_sop4 ]
  set tx_axis_tuser_sop5 [ create_bd_port -dir I tx_axis_tuser_sop5 ]
  set tx_axis_tuser_sop6 [ create_bd_port -dir I tx_axis_tuser_sop6 ]
  set tx_axis_tuser_sop7 [ create_bd_port -dir I tx_axis_tuser_sop7 ]
  set tx_axis_tuser_sop8 [ create_bd_port -dir I tx_axis_tuser_sop8 ]
  set tx_axis_tuser_sop9 [ create_bd_port -dir I tx_axis_tuser_sop9 ]
  set tx_axis_tuser_sop10 [ create_bd_port -dir I tx_axis_tuser_sop10 ]
  set tx_axis_tuser_sop11 [ create_bd_port -dir I tx_axis_tuser_sop11 ]
  set tx_axis_tvalid_0 [ create_bd_port -dir I tx_axis_tvalid_0 ]
  set tx_axis_tvalid_1 [ create_bd_port -dir I tx_axis_tvalid_1 ]
  set tx_axis_tvalid_2 [ create_bd_port -dir I tx_axis_tvalid_2 ]
  set tx_axis_tvalid_3 [ create_bd_port -dir I tx_axis_tvalid_3 ]
  set tx_axis_tvalid_4 [ create_bd_port -dir I tx_axis_tvalid_4 ]
  set tx_axis_tvalid_5 [ create_bd_port -dir I tx_axis_tvalid_5 ]
  set tx_preamblein_0 [ create_bd_port -dir I -from 55 -to 0 tx_preamblein_0 ]
  set tx_preamblein_1 [ create_bd_port -dir I -from 55 -to 0 tx_preamblein_1 ]
  set tx_preamblein_2 [ create_bd_port -dir I -from 55 -to 0 tx_preamblein_2 ]
  set tx_preamblein_3 [ create_bd_port -dir I -from 55 -to 0 tx_preamblein_3 ]
  set tx_preamblein_4 [ create_bd_port -dir I -from 55 -to 0 tx_preamblein_4 ]
  set tx_preamblein_5 [ create_bd_port -dir I -from 55 -to 0 tx_preamblein_5 ]
  set gt_reset_all_in [ create_bd_port -dir I gt_reset_all_in ]
  set gtpowergood_in [ create_bd_port -dir I gtpowergood_in ]
  set rx_axis_tdata0 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata0 ]
  set rx_axis_tdata1 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata1 ]
  set rx_axis_tdata2 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata2 ]
  set rx_axis_tdata3 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata3 ]
  set rx_axis_tdata4 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata4 ]
  set rx_axis_tdata5 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata5 ]
  set rx_axis_tdata6 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata6 ]
  set rx_axis_tdata7 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata7 ]
  set rx_axis_tdata8 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata8 ]
  set rx_axis_tdata9 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata9 ]
  set rx_axis_tdata10 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata10 ]
  set rx_axis_tdata11 [ create_bd_port -dir O -from 127 -to 0 rx_axis_tdata11 ]
  set rx_axis_tid [ create_bd_port -dir O -from 5 -to 0 rx_axis_tid ]
  set rx_axis_tuser_ena0 [ create_bd_port -dir O rx_axis_tuser_ena0 ]
  set rx_axis_tuser_ena1 [ create_bd_port -dir O rx_axis_tuser_ena1 ]
  set rx_axis_tuser_ena2 [ create_bd_port -dir O rx_axis_tuser_ena2 ]
  set rx_axis_tuser_ena3 [ create_bd_port -dir O rx_axis_tuser_ena3 ]
  set rx_axis_tuser_ena4 [ create_bd_port -dir O rx_axis_tuser_ena4 ]
  set rx_axis_tuser_ena5 [ create_bd_port -dir O rx_axis_tuser_ena5 ]
  set rx_axis_tuser_ena6 [ create_bd_port -dir O rx_axis_tuser_ena6 ]
  set rx_axis_tuser_ena7 [ create_bd_port -dir O rx_axis_tuser_ena7 ]
  set rx_axis_tuser_ena8 [ create_bd_port -dir O rx_axis_tuser_ena8 ]
  set rx_axis_tuser_ena9 [ create_bd_port -dir O rx_axis_tuser_ena9 ]
  set rx_axis_tuser_ena10 [ create_bd_port -dir O rx_axis_tuser_ena10 ]
  set rx_axis_tuser_ena11 [ create_bd_port -dir O rx_axis_tuser_ena11 ]
  set rx_axis_tuser_eop0 [ create_bd_port -dir O rx_axis_tuser_eop0 ]
  set rx_axis_tuser_eop1 [ create_bd_port -dir O rx_axis_tuser_eop1 ]
  set rx_axis_tuser_eop2 [ create_bd_port -dir O rx_axis_tuser_eop2 ]
  set rx_axis_tuser_eop3 [ create_bd_port -dir O rx_axis_tuser_eop3 ]
  set rx_axis_tuser_eop4 [ create_bd_port -dir O rx_axis_tuser_eop4 ]
  set rx_axis_tuser_eop5 [ create_bd_port -dir O rx_axis_tuser_eop5 ]
  set rx_axis_tuser_eop6 [ create_bd_port -dir O rx_axis_tuser_eop6 ]
  set rx_axis_tuser_eop7 [ create_bd_port -dir O rx_axis_tuser_eop7 ]
  set rx_axis_tuser_eop8 [ create_bd_port -dir O rx_axis_tuser_eop8 ]
  set rx_axis_tuser_eop9 [ create_bd_port -dir O rx_axis_tuser_eop9 ]
  set rx_axis_tuser_eop10 [ create_bd_port -dir O rx_axis_tuser_eop10 ]
  set rx_axis_tuser_eop11 [ create_bd_port -dir O rx_axis_tuser_eop11 ]
  set rx_axis_tuser_err0 [ create_bd_port -dir O rx_axis_tuser_err0 ]
  set rx_axis_tuser_err1 [ create_bd_port -dir O rx_axis_tuser_err1 ]
  set rx_axis_tuser_err2 [ create_bd_port -dir O rx_axis_tuser_err2 ]
  set rx_axis_tuser_err3 [ create_bd_port -dir O rx_axis_tuser_err3 ]
  set rx_axis_tuser_err4 [ create_bd_port -dir O rx_axis_tuser_err4 ]
  set rx_axis_tuser_err5 [ create_bd_port -dir O rx_axis_tuser_err5 ]
  set rx_axis_tuser_err6 [ create_bd_port -dir O rx_axis_tuser_err6 ]
  set rx_axis_tuser_err7 [ create_bd_port -dir O rx_axis_tuser_err7 ]
  set rx_axis_tuser_err8 [ create_bd_port -dir O rx_axis_tuser_err8 ]
  set rx_axis_tuser_err9 [ create_bd_port -dir O rx_axis_tuser_err9 ]
  set rx_axis_tuser_err10 [ create_bd_port -dir O rx_axis_tuser_err10 ]
  set rx_axis_tuser_err11 [ create_bd_port -dir O rx_axis_tuser_err11 ]
  set rx_axis_tuser_mty0 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty0 ]
  set rx_axis_tuser_mty1 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty1 ]
  set rx_axis_tuser_mty2 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty2 ]
  set rx_axis_tuser_mty3 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty3 ]
  set rx_axis_tuser_mty4 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty4 ]
  set rx_axis_tuser_mty5 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty5 ]
  set rx_axis_tuser_mty6 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty6 ]
  set rx_axis_tuser_mty7 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty7 ]
  set rx_axis_tuser_mty8 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty8 ]
  set rx_axis_tuser_mty9 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty9 ]
  set rx_axis_tuser_mty10 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty10 ]
  set rx_axis_tuser_mty11 [ create_bd_port -dir O -from 3 -to 0 rx_axis_tuser_mty11 ]
  set rx_axis_tuser_sop0 [ create_bd_port -dir O rx_axis_tuser_sop0 ]
  set rx_axis_tuser_sop1 [ create_bd_port -dir O rx_axis_tuser_sop1 ]
  set rx_axis_tuser_sop2 [ create_bd_port -dir O rx_axis_tuser_sop2 ]
  set rx_axis_tuser_sop3 [ create_bd_port -dir O rx_axis_tuser_sop3 ]
  set rx_axis_tuser_sop4 [ create_bd_port -dir O rx_axis_tuser_sop4 ]
  set rx_axis_tuser_sop5 [ create_bd_port -dir O rx_axis_tuser_sop5 ]
  set rx_axis_tuser_sop6 [ create_bd_port -dir O rx_axis_tuser_sop6 ]
  set rx_axis_tuser_sop7 [ create_bd_port -dir O rx_axis_tuser_sop7 ]
  set rx_axis_tuser_sop8 [ create_bd_port -dir O rx_axis_tuser_sop8 ]
  set rx_axis_tuser_sop9 [ create_bd_port -dir O rx_axis_tuser_sop9 ]
  set rx_axis_tuser_sop10 [ create_bd_port -dir O rx_axis_tuser_sop10 ]
  set rx_axis_tuser_sop11 [ create_bd_port -dir O rx_axis_tuser_sop11 ]
  set rx_axis_tvalid_0 [ create_bd_port -dir O rx_axis_tvalid_0 ]
  set rx_axis_tvalid_1 [ create_bd_port -dir O rx_axis_tvalid_1 ]
  set rx_axis_tvalid_2 [ create_bd_port -dir O rx_axis_tvalid_2 ]
  set rx_axis_tvalid_3 [ create_bd_port -dir O rx_axis_tvalid_3 ]
  set rx_axis_tvalid_4 [ create_bd_port -dir O rx_axis_tvalid_4 ]
  set rx_axis_tvalid_5 [ create_bd_port -dir O rx_axis_tvalid_5 ]
  set tx_axis_id_req [ create_bd_port -dir O -from 5 -to 0 tx_axis_id_req ]
  set tx_axis_id_req_vld [ create_bd_port -dir O tx_axis_id_req_vld ]
  set tx_axis_ch_status_vld [ create_bd_port -dir O tx_axis_ch_status_vld ]
  set tx_axis_ch_status_skip_req [ create_bd_port -dir O tx_axis_ch_status_skip_req ]
  set tx_axis_ch_status_id [ create_bd_port -dir O -from 5 -to 0 tx_axis_ch_status_id ]
  set tx_axis_taf_0 [ create_bd_port -dir O tx_axis_taf_0 ]
  set tx_axis_taf_1 [ create_bd_port -dir O tx_axis_taf_1 ]
  set tx_axis_taf_2 [ create_bd_port -dir O tx_axis_taf_2 ]
  set tx_axis_taf_3 [ create_bd_port -dir O tx_axis_taf_3 ]
  set tx_axis_taf_4 [ create_bd_port -dir O tx_axis_taf_4 ]
  set tx_axis_taf_5 [ create_bd_port -dir O tx_axis_taf_5 ]
  set tx_axis_tready_0 [ create_bd_port -dir O tx_axis_tready_0 ]
  set tx_axis_tready_1 [ create_bd_port -dir O tx_axis_tready_1 ]
  set tx_axis_tready_2 [ create_bd_port -dir O tx_axis_tready_2 ]
  set tx_axis_tready_3 [ create_bd_port -dir O tx_axis_tready_3 ]
  set tx_axis_tready_4 [ create_bd_port -dir O tx_axis_tready_4 ]
  set tx_axis_tready_5 [ create_bd_port -dir O tx_axis_tready_5 ]
  set ctl_rsvd_in [ create_bd_port -dir I -from 119 -to 0 ctl_rsvd_in ]
  set rsvd_in_rx_mac [ create_bd_port -dir I -from 7 -to 0 rsvd_in_rx_mac ]
  set rsvd_in_rx_phy [ create_bd_port -dir I -from 7 -to 0 rsvd_in_rx_phy ]
  set rx_all_channel_mac_pm_tick [ create_bd_port -dir I rx_all_channel_mac_pm_tick ]
  set rx_channel_flush [ create_bd_port -dir I -from 5 -to 0 rx_channel_flush ]
  set rx_serdes_fifo_flagin_0 [ create_bd_port -dir I rx_serdes_fifo_flagin_0 ]
  set rx_serdes_fifo_flagin_1 [ create_bd_port -dir I rx_serdes_fifo_flagin_1 ]
  set rx_serdes_fifo_flagin_2 [ create_bd_port -dir I rx_serdes_fifo_flagin_2 ]
  set rx_serdes_fifo_flagin_3 [ create_bd_port -dir I rx_serdes_fifo_flagin_3 ]
  set rx_serdes_fifo_flagin_4 [ create_bd_port -dir I rx_serdes_fifo_flagin_4 ]
  set rx_serdes_fifo_flagin_5 [ create_bd_port -dir I rx_serdes_fifo_flagin_5 ]
  set tx_all_channel_mac_pm_tick [ create_bd_port -dir I tx_all_channel_mac_pm_tick ]
  set tx_channel_flush [ create_bd_port -dir I -from 5 -to 0 tx_channel_flush ]
  set rx_lane_aligner_fill [ create_bd_port -dir O -from 6 -to 0 rx_lane_aligner_fill ]
  set rx_lane_aligner_fill_start [ create_bd_port -dir O rx_lane_aligner_fill_start ]
  set rx_lane_aligner_fill_valid [ create_bd_port -dir O rx_lane_aligner_fill_valid ]
  set rx_pcs_tdm_stats_data [ create_bd_port -dir O -from 43 -to 0 rx_pcs_tdm_stats_data ]
  set rx_pcs_tdm_stats_start [ create_bd_port -dir O rx_pcs_tdm_stats_start ]
  set rx_pcs_tdm_stats_valid [ create_bd_port -dir O rx_pcs_tdm_stats_valid ]
  set rx_port_pm_rdy [ create_bd_port -dir O -from 5 -to 0 rx_port_pm_rdy ]
  set rx_preambleout_0 [ create_bd_port -dir O -from 55 -to 0 rx_preambleout_0 ]
  set rx_preambleout_1 [ create_bd_port -dir O -from 55 -to 0 rx_preambleout_1 ]
  set rx_preambleout_2 [ create_bd_port -dir O -from 55 -to 0 rx_preambleout_2 ]
  set rx_preambleout_3 [ create_bd_port -dir O -from 55 -to 0 rx_preambleout_3 ]
  set rx_preambleout_4 [ create_bd_port -dir O -from 55 -to 0 rx_preambleout_4 ]
  set rx_preambleout_5 [ create_bd_port -dir O -from 55 -to 0 rx_preambleout_5 ]
  set rx_serdes_albuf_restart_0 [ create_bd_port -dir O rx_serdes_albuf_restart_0 ]
  set rx_serdes_albuf_restart_1 [ create_bd_port -dir O rx_serdes_albuf_restart_1 ]
  set rx_serdes_albuf_restart_2 [ create_bd_port -dir O rx_serdes_albuf_restart_2 ]
  set rx_serdes_albuf_restart_3 [ create_bd_port -dir O rx_serdes_albuf_restart_3 ]
  set rx_serdes_albuf_restart_4 [ create_bd_port -dir O rx_serdes_albuf_restart_4 ]
  set rx_serdes_albuf_restart_5 [ create_bd_port -dir O rx_serdes_albuf_restart_5 ]
  set rx_serdes_albuf_slip_0 [ create_bd_port -dir O rx_serdes_albuf_slip_0 ]
  set rx_serdes_albuf_slip_1 [ create_bd_port -dir O rx_serdes_albuf_slip_1 ]
  set rx_serdes_albuf_slip_2 [ create_bd_port -dir O rx_serdes_albuf_slip_2 ]
  set rx_serdes_albuf_slip_3 [ create_bd_port -dir O rx_serdes_albuf_slip_3 ]
  set rx_serdes_albuf_slip_4 [ create_bd_port -dir O rx_serdes_albuf_slip_4 ]
  set rx_serdes_albuf_slip_5 [ create_bd_port -dir O rx_serdes_albuf_slip_5 ]
  set rx_serdes_albuf_slip_6 [ create_bd_port -dir O rx_serdes_albuf_slip_6 ]
  set rx_serdes_albuf_slip_7 [ create_bd_port -dir O rx_serdes_albuf_slip_7 ]
  set rx_serdes_albuf_slip_8 [ create_bd_port -dir O rx_serdes_albuf_slip_8 ]
  set rx_serdes_albuf_slip_9 [ create_bd_port -dir O rx_serdes_albuf_slip_9 ]
  set rx_serdes_albuf_slip_10 [ create_bd_port -dir O rx_serdes_albuf_slip_10 ]
  set rx_serdes_albuf_slip_11 [ create_bd_port -dir O rx_serdes_albuf_slip_11 ]
  set rx_serdes_albuf_slip_12 [ create_bd_port -dir O rx_serdes_albuf_slip_12 ]
  set rx_serdes_albuf_slip_13 [ create_bd_port -dir O rx_serdes_albuf_slip_13 ]
  set rx_serdes_albuf_slip_14 [ create_bd_port -dir O rx_serdes_albuf_slip_14 ]
  set rx_serdes_albuf_slip_15 [ create_bd_port -dir O rx_serdes_albuf_slip_15 ]
  set rx_serdes_albuf_slip_16 [ create_bd_port -dir O rx_serdes_albuf_slip_16 ]
  set rx_serdes_albuf_slip_17 [ create_bd_port -dir O rx_serdes_albuf_slip_17 ]
  set rx_serdes_albuf_slip_18 [ create_bd_port -dir O rx_serdes_albuf_slip_18 ]
  set rx_serdes_albuf_slip_19 [ create_bd_port -dir O rx_serdes_albuf_slip_19 ]
  set rx_serdes_albuf_slip_20 [ create_bd_port -dir O rx_serdes_albuf_slip_20 ]
  set rx_serdes_albuf_slip_21 [ create_bd_port -dir O rx_serdes_albuf_slip_21 ]
  set rx_serdes_albuf_slip_22 [ create_bd_port -dir O rx_serdes_albuf_slip_22 ]
  set rx_serdes_albuf_slip_23 [ create_bd_port -dir O rx_serdes_albuf_slip_23 ]
  set rx_serdes_fifo_flagout_0 [ create_bd_port -dir O rx_serdes_fifo_flagout_0 ]
  set rx_serdes_fifo_flagout_1 [ create_bd_port -dir O rx_serdes_fifo_flagout_1 ]
  set rx_serdes_fifo_flagout_2 [ create_bd_port -dir O rx_serdes_fifo_flagout_2 ]
  set rx_serdes_fifo_flagout_3 [ create_bd_port -dir O rx_serdes_fifo_flagout_3 ]
  set rx_serdes_fifo_flagout_4 [ create_bd_port -dir O rx_serdes_fifo_flagout_4 ]
  set rx_serdes_fifo_flagout_5 [ create_bd_port -dir O rx_serdes_fifo_flagout_5 ]
  set rx_tsmac_tdm_stats_data [ create_bd_port -dir O -from 78 -to 0 rx_tsmac_tdm_stats_data ]
  set rx_tsmac_tdm_stats_id [ create_bd_port -dir O -from 5 -to 0 rx_tsmac_tdm_stats_id ]
  set rx_tsmac_tdm_stats_valid [ create_bd_port -dir O rx_tsmac_tdm_stats_valid ]
  set c0_stat_rx_corrected_lane_delay_0 [ create_bd_port -dir O -from 15 -to 0 c0_stat_rx_corrected_lane_delay_0 ]
  set c0_stat_rx_corrected_lane_delay_1 [ create_bd_port -dir O -from 15 -to 0 c0_stat_rx_corrected_lane_delay_1 ]
  set c0_stat_rx_corrected_lane_delay_2 [ create_bd_port -dir O -from 15 -to 0 c0_stat_rx_corrected_lane_delay_2 ]
  set c0_stat_rx_corrected_lane_delay_3 [ create_bd_port -dir O -from 15 -to 0 c0_stat_rx_corrected_lane_delay_3 ]
  set c0_stat_rx_corrected_lane_delay_valid [ create_bd_port -dir O c0_stat_rx_corrected_lane_delay_valid ]
  set c1_stat_rx_corrected_lane_delay_0 [ create_bd_port -dir O -from 15 -to 0 c1_stat_rx_corrected_lane_delay_0 ]
  set c1_stat_rx_corrected_lane_delay_1 [ create_bd_port -dir O -from 15 -to 0 c1_stat_rx_corrected_lane_delay_1 ]
  set c1_stat_rx_corrected_lane_delay_2 [ create_bd_port -dir O -from 15 -to 0 c1_stat_rx_corrected_lane_delay_2 ]
  set c1_stat_rx_corrected_lane_delay_3 [ create_bd_port -dir O -from 15 -to 0 c1_stat_rx_corrected_lane_delay_3 ]
  set c1_stat_rx_corrected_lane_delay_valid [ create_bd_port -dir O c1_stat_rx_corrected_lane_delay_valid ]
  set c2_stat_rx_corrected_lane_delay_0 [ create_bd_port -dir O -from 15 -to 0 c2_stat_rx_corrected_lane_delay_0 ]
  set c2_stat_rx_corrected_lane_delay_1 [ create_bd_port -dir O -from 15 -to 0 c2_stat_rx_corrected_lane_delay_1 ]
  set c2_stat_rx_corrected_lane_delay_2 [ create_bd_port -dir O -from 15 -to 0 c2_stat_rx_corrected_lane_delay_2 ]
  set c2_stat_rx_corrected_lane_delay_3 [ create_bd_port -dir O -from 15 -to 0 c2_stat_rx_corrected_lane_delay_3 ]
  set c2_stat_rx_corrected_lane_delay_valid [ create_bd_port -dir O c2_stat_rx_corrected_lane_delay_valid ]
  set c3_stat_rx_corrected_lane_delay_0 [ create_bd_port -dir O -from 15 -to 0 c3_stat_rx_corrected_lane_delay_0 ]
  set c3_stat_rx_corrected_lane_delay_1 [ create_bd_port -dir O -from 15 -to 0 c3_stat_rx_corrected_lane_delay_1 ]
  set c3_stat_rx_corrected_lane_delay_2 [ create_bd_port -dir O -from 15 -to 0 c3_stat_rx_corrected_lane_delay_2 ]
  set c3_stat_rx_corrected_lane_delay_3 [ create_bd_port -dir O -from 15 -to 0 c3_stat_rx_corrected_lane_delay_3 ]
  set c3_stat_rx_corrected_lane_delay_valid [ create_bd_port -dir O c3_stat_rx_corrected_lane_delay_valid ]
  set c4_stat_rx_corrected_lane_delay_0 [ create_bd_port -dir O -from 15 -to 0 c4_stat_rx_corrected_lane_delay_0 ]
  set c4_stat_rx_corrected_lane_delay_1 [ create_bd_port -dir O -from 15 -to 0 c4_stat_rx_corrected_lane_delay_1 ]
  set c4_stat_rx_corrected_lane_delay_2 [ create_bd_port -dir O -from 15 -to 0 c4_stat_rx_corrected_lane_delay_2 ]
  set c4_stat_rx_corrected_lane_delay_3 [ create_bd_port -dir O -from 15 -to 0 c4_stat_rx_corrected_lane_delay_3 ]
  set c4_stat_rx_corrected_lane_delay_valid [ create_bd_port -dir O c4_stat_rx_corrected_lane_delay_valid ]
  set c5_stat_rx_corrected_lane_delay_0 [ create_bd_port -dir O -from 15 -to 0 c5_stat_rx_corrected_lane_delay_0 ]
  set c5_stat_rx_corrected_lane_delay_1 [ create_bd_port -dir O -from 15 -to 0 c5_stat_rx_corrected_lane_delay_1 ]
  set c5_stat_rx_corrected_lane_delay_2 [ create_bd_port -dir O -from 15 -to 0 c5_stat_rx_corrected_lane_delay_2 ]
  set c5_stat_rx_corrected_lane_delay_3 [ create_bd_port -dir O -from 15 -to 0 c5_stat_rx_corrected_lane_delay_3 ]
  set c5_stat_rx_corrected_lane_delay_valid [ create_bd_port -dir O c5_stat_rx_corrected_lane_delay_valid ]
  set tx_all_channel_mac_pm_rdy [ create_bd_port -dir O tx_all_channel_mac_pm_rdy ]
  set tx_pcs_tdm_stats_data [ create_bd_port -dir O -from 21 -to 0 tx_pcs_tdm_stats_data ]
  set tx_pcs_tdm_stats_start [ create_bd_port -dir O tx_pcs_tdm_stats_start ]
  set tx_pcs_tdm_stats_valid [ create_bd_port -dir O tx_pcs_tdm_stats_valid ]
  set tx_port_pm_rdy [ create_bd_port -dir O -from 5 -to 0 tx_port_pm_rdy ]
  set tx_serdes_is_am_0 [ create_bd_port -dir O tx_serdes_is_am_0 ]
  set tx_serdes_is_am_1 [ create_bd_port -dir O tx_serdes_is_am_1 ]
  set tx_serdes_is_am_2 [ create_bd_port -dir O tx_serdes_is_am_2 ]
  set tx_serdes_is_am_3 [ create_bd_port -dir O tx_serdes_is_am_3 ]
  set tx_serdes_is_am_4 [ create_bd_port -dir O tx_serdes_is_am_4 ]
  set tx_serdes_is_am_5 [ create_bd_port -dir O tx_serdes_is_am_5 ]
  set tx_serdes_is_am_prefifo_0 [ create_bd_port -dir O tx_serdes_is_am_prefifo_0 ]
  set tx_serdes_is_am_prefifo_1 [ create_bd_port -dir O tx_serdes_is_am_prefifo_1 ]
  set tx_serdes_is_am_prefifo_2 [ create_bd_port -dir O tx_serdes_is_am_prefifo_2 ]
  set tx_serdes_is_am_prefifo_3 [ create_bd_port -dir O tx_serdes_is_am_prefifo_3 ]
  set tx_serdes_is_am_prefifo_4 [ create_bd_port -dir O tx_serdes_is_am_prefifo_4 ]
  set tx_serdes_is_am_prefifo_5 [ create_bd_port -dir O tx_serdes_is_am_prefifo_5 ]
  set tx_tsmac_tdm_stats_data [ create_bd_port -dir O -from 55 -to 0 tx_tsmac_tdm_stats_data ]
  set tx_tsmac_tdm_stats_id [ create_bd_port -dir O -from 5 -to 0 tx_tsmac_tdm_stats_id ]
  set tx_tsmac_tdm_stats_valid [ create_bd_port -dir O tx_tsmac_tdm_stats_valid ]
  set gt_reset_tx_datapath_in_0 [ create_bd_port -dir I gt_reset_tx_datapath_in_0 ]
  set gt_reset_rx_datapath_in_0 [ create_bd_port -dir I gt_reset_rx_datapath_in_0 ]
  set gt_tx_reset_done_out_0 [ create_bd_port -dir O gt_tx_reset_done_out_0 ]
  set gt_rx_reset_done_out_0 [ create_bd_port -dir O gt_rx_reset_done_out_0 ]
  set gt_reset_tx_datapath_in_1 [ create_bd_port -dir I gt_reset_tx_datapath_in_1 ]
  set gt_reset_rx_datapath_in_1 [ create_bd_port -dir I gt_reset_rx_datapath_in_1 ]
  set gt_tx_reset_done_out_1 [ create_bd_port -dir O gt_tx_reset_done_out_1 ]
  set gt_rx_reset_done_out_1 [ create_bd_port -dir O gt_rx_reset_done_out_1 ]
  set gt_reset_tx_datapath_in_2 [ create_bd_port -dir I gt_reset_tx_datapath_in_2 ]
  set gt_reset_rx_datapath_in_2 [ create_bd_port -dir I gt_reset_rx_datapath_in_2 ]
  set gt_tx_reset_done_out_2 [ create_bd_port -dir O gt_tx_reset_done_out_2 ]
  set gt_rx_reset_done_out_2 [ create_bd_port -dir O gt_rx_reset_done_out_2 ]
  set gt_reset_tx_datapath_in_3 [ create_bd_port -dir I gt_reset_tx_datapath_in_3 ]
  set gt_reset_rx_datapath_in_3 [ create_bd_port -dir I gt_reset_rx_datapath_in_3 ]
  set gt_tx_reset_done_out_3 [ create_bd_port -dir O gt_tx_reset_done_out_3 ]
  set gt_rx_reset_done_out_3 [ create_bd_port -dir O gt_rx_reset_done_out_3 ]
  set gt_reset_tx_datapath_in_4 [ create_bd_port -dir I gt_reset_tx_datapath_in_4 ]
  set gt_reset_rx_datapath_in_4 [ create_bd_port -dir I gt_reset_rx_datapath_in_4 ]
  set gt_tx_reset_done_out_4 [ create_bd_port -dir O gt_tx_reset_done_out_4 ]
  set gt_rx_reset_done_out_4 [ create_bd_port -dir O gt_rx_reset_done_out_4 ]
  set gt_reset_tx_datapath_in_5 [ create_bd_port -dir I gt_reset_tx_datapath_in_5 ]
  set gt_reset_rx_datapath_in_5 [ create_bd_port -dir I gt_reset_rx_datapath_in_5 ]
  set gt_tx_reset_done_out_5 [ create_bd_port -dir O gt_tx_reset_done_out_5 ]
  set gt_rx_reset_done_out_5 [ create_bd_port -dir O gt_rx_reset_done_out_5 ]
  set gt_reset_tx_datapath_in_6 [ create_bd_port -dir I gt_reset_tx_datapath_in_6 ]
  set gt_reset_rx_datapath_in_6 [ create_bd_port -dir I gt_reset_rx_datapath_in_6 ]
  set gt_tx_reset_done_out_6 [ create_bd_port -dir O gt_tx_reset_done_out_6 ]
  set gt_rx_reset_done_out_6 [ create_bd_port -dir O gt_rx_reset_done_out_6 ]
  set gt_reset_tx_datapath_in_7 [ create_bd_port -dir I gt_reset_tx_datapath_in_7 ]
  set gt_reset_rx_datapath_in_7 [ create_bd_port -dir I gt_reset_rx_datapath_in_7 ]
  set gt_tx_reset_done_out_7 [ create_bd_port -dir O gt_tx_reset_done_out_7 ]
  set gt_rx_reset_done_out_7 [ create_bd_port -dir O gt_rx_reset_done_out_7 ]
  set tx_core_clk [ create_bd_port -dir I -type clk -freq_hz 781250000 tx_core_clk ]
  set rx_core_clk [ create_bd_port -dir I -type clk -freq_hz 781250000 rx_core_clk ]
  set tx_serdes_clk [ create_bd_port -dir I -from 5 -to 0 -type gt_usrclk tx_serdes_clk ]
  set rx_serdes_clk [ create_bd_port -dir I -from 5 -to 0 -type gt_usrclk rx_serdes_clk ]
  set tx_alt_serdes_clk [ create_bd_port -dir I -from 5 -to 0 -type gt_usrclk tx_alt_serdes_clk ]
  set rx_alt_serdes_clk [ create_bd_port -dir I -from 5 -to 0 -type gt_usrclk rx_alt_serdes_clk ]
  set tx_flexif_clk [ create_bd_port -dir I -from 5 -to 0 -type clk tx_flexif_clk ]
  set rx_flexif_clk [ create_bd_port -dir I -from 5 -to 0 -type clk rx_flexif_clk ]
  set ts_clk [ create_bd_port -dir I -from 5 -to 0 -type clk ts_clk ]
  set tx_port_pm_tick [ create_bd_port -dir I -from 5 -to 0 tx_port_pm_tick ]
  set rx_port_pm_tick [ create_bd_port -dir I -from 5 -to 0 rx_port_pm_tick ]

  # Create instance: dcmac_0_core, and set properties
  set dcmac_0_core [ create_bd_cell -type ip -vlnv xilinx.com:ip:dcmac:2.3 dcmac_0_core ]
  set_property -dict [list \
    CONFIG.DCMAC_CONFIGURATION_TYPE {Static Configuration} \
    CONFIG.DCMAC_DATA_PATH_INTERFACE_C0 {391MHz Upto 6 Ports} \
    CONFIG.DCMAC_LOCATION_C0 {DCMAC_X1Y1} \
    CONFIG.DCMAC_MODE_C0 {Coupled MAC+PCS} \
    CONFIG.FAST_SIM_MODE {0} \
    CONFIG.FEC_SLICE0_CFG_C0 {RS(544) CL119} \
    CONFIG.FEC_SLICE4_CFG_C0 {FEC Disabled} \
    CONFIG.FEC_SLICE5_CFG_C0 {FEC Disabled} \
    CONFIG.GT_PIPELINE_STAGES {0} \
    CONFIG.GT_REF_CLK_FREQ_C0 {156.25} \
    CONFIG.GT_TYPE_C0 {GTM} \
    CONFIG.MAC_PORT0_CONFIG_C0 {400GAUI-8} \
    CONFIG.MAC_PORT0_ENABLE_C0 {1} \
    CONFIG.MAC_PORT0_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT0_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT0_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT0_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT0_TX_INSERT_C0 {1} \
    CONFIG.MAC_PORT1_ENABLE_C0 {1} \
    CONFIG.MAC_PORT1_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT1_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT1_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT1_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT1_TX_INSERT_C0 {1} \
    CONFIG.MAC_PORT2_ENABLE_C0 {1} \
    CONFIG.MAC_PORT2_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT2_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT2_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT2_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT2_TX_INSERT_C0 {1} \
    CONFIG.MAC_PORT3_ENABLE_C0 {1} \
    CONFIG.MAC_PORT3_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT3_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT3_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT3_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT3_TX_INSERT_C0 {1} \
    CONFIG.MAC_PORT4_CONFIG_C0 {Disabled} \
    CONFIG.MAC_PORT4_ENABLE_C0 {1} \
    CONFIG.MAC_PORT4_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT4_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT4_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT4_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT4_TX_INSERT_C0 {1} \
    CONFIG.MAC_PORT5_CONFIG_C0 {Disabled} \
    CONFIG.MAC_PORT5_ENABLE_C0 {1} \
    CONFIG.MAC_PORT5_ENABLE_TIME_STAMPING_C0 {0} \
    CONFIG.MAC_PORT5_RX_FLOW_C0 {0} \
    CONFIG.MAC_PORT5_RX_STRIP_C0 {0} \
    CONFIG.MAC_PORT5_TX_FLOW_C0 {0} \
    CONFIG.MAC_PORT5_TX_INSERT_C0 {1} \
    CONFIG.NUM_GT_CHANNELS {8} \
    CONFIG.PHY_OPERATING_MODE_C0 {N/A} \
    CONFIG.PORT0_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT0_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT1_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT1_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT2_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT2_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT3_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT3_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT4_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT4_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.PORT5_1588v2_Clocking_C0 {Ordinary/Boundary Clock} \
    CONFIG.PORT5_1588v2_Operation_MODE_C0 {No operation} \
    CONFIG.TIMESTAMP_CLK_PERIOD_NS {4.0000} \
  ] $dcmac_0_core


  # Create instance: dcmac_0_gt_wrapper
  create_hier_cell_dcmac_0_gt_wrapper [current_bd_instance .] dcmac_0_gt_wrapper

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports CLK_IN_D_0] [get_bd_intf_pins dcmac_0_gt_wrapper/CLK_IN_D_0]
  connect_bd_intf_net -intf_net CLK_IN_D_1_1 [get_bd_intf_ports CLK_IN_D_1] [get_bd_intf_pins dcmac_0_gt_wrapper/CLK_IN_D_1]
  connect_bd_intf_net -intf_net ctl_port_1 [get_bd_intf_ports ctl_port] [get_bd_intf_pins dcmac_0_core/ctl_port]
  connect_bd_intf_net -intf_net ctl_txrx_port0_1 [get_bd_intf_ports ctl_txrx_port0] [get_bd_intf_pins dcmac_0_core/ctl_txrx_port0]
  connect_bd_intf_net -intf_net ctl_txrx_port1_1 [get_bd_intf_ports ctl_txrx_port1] [get_bd_intf_pins dcmac_0_core/ctl_txrx_port1]
  connect_bd_intf_net -intf_net ctl_txrx_port2_1 [get_bd_intf_ports ctl_txrx_port2] [get_bd_intf_pins dcmac_0_core/ctl_txrx_port2]
  connect_bd_intf_net -intf_net ctl_txrx_port3_1 [get_bd_intf_ports ctl_txrx_port3] [get_bd_intf_pins dcmac_0_core/ctl_txrx_port3]
  connect_bd_intf_net -intf_net ctl_txrx_port4_1 [get_bd_intf_ports ctl_txrx_port4] [get_bd_intf_pins dcmac_0_core/ctl_txrx_port4]
  connect_bd_intf_net -intf_net ctl_txrx_port5_1 [get_bd_intf_ports ctl_txrx_port5] [get_bd_intf_pins dcmac_0_core/ctl_txrx_port5]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_0 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_0] [get_bd_intf_pins dcmac_0_gt_wrapper/RX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_1 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_1] [get_bd_intf_pins dcmac_0_gt_wrapper/RX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_2 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_2] [get_bd_intf_pins dcmac_0_gt_wrapper/RX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_3 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_3] [get_bd_intf_pins dcmac_0_gt_wrapper/RX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_4 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_4] [get_bd_intf_pins dcmac_0_gt_wrapper/RX0_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_5 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_5] [get_bd_intf_pins dcmac_0_gt_wrapper/RX1_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_6 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_6] [get_bd_intf_pins dcmac_0_gt_wrapper/RX2_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_rx_serdes_interface_7 [get_bd_intf_pins dcmac_0_core/gtm_rx_serdes_interface_7] [get_bd_intf_pins dcmac_0_gt_wrapper/RX3_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_0 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_0] [get_bd_intf_pins dcmac_0_gt_wrapper/TX0_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_1 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_1] [get_bd_intf_pins dcmac_0_gt_wrapper/TX1_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_2 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_2] [get_bd_intf_pins dcmac_0_gt_wrapper/TX2_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_3 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_3] [get_bd_intf_pins dcmac_0_gt_wrapper/TX3_GT_IP_Interface]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_4 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_4] [get_bd_intf_pins dcmac_0_gt_wrapper/TX0_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_5 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_5] [get_bd_intf_pins dcmac_0_gt_wrapper/TX1_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_6 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_6] [get_bd_intf_pins dcmac_0_gt_wrapper/TX2_GT_IP_Interface1]
  connect_bd_intf_net -intf_net dcmac_0_core_gtm_tx_serdes_interface_7 [get_bd_intf_pins dcmac_0_core/gtm_tx_serdes_interface_7] [get_bd_intf_pins dcmac_0_gt_wrapper/TX3_GT_IP_Interface1]
  connect_bd_intf_net -intf_net gt_quad_base_1_GT_Serial [get_bd_intf_pins dcmac_0_gt_wrapper/GT_Serial_1] [get_bd_intf_ports GT_Serial_1]
  connect_bd_intf_net -intf_net gt_quad_base_GT_Serial [get_bd_intf_pins dcmac_0_gt_wrapper/GT_Serial] [get_bd_intf_ports GT_Serial]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_ports s_axi] [get_bd_intf_pins dcmac_0_core/s_axi]

  # Create port connections
  connect_bd_net -net apb3clk_quad_1 [get_bd_ports apb3clk_quad] [get_bd_pins dcmac_0_gt_wrapper/apb3clk_quad]
  connect_bd_net -net bufg_gt_odiv2_usrclk [get_bd_pins dcmac_0_gt_wrapper/IBUFDS_ODIV2] [get_bd_ports IBUFDS_ODIV2]
  connect_bd_net -net ch0_loopback_0_1 [get_bd_ports ch0_loopback_0] [get_bd_pins dcmac_0_gt_wrapper/ch0_loopback_0]
  connect_bd_net -net ch0_loopback_1_1 [get_bd_ports ch0_loopback_1] [get_bd_pins dcmac_0_gt_wrapper/ch0_loopback_1]
  connect_bd_net -net ch0_rxrate_0_1 [get_bd_ports ch0_rxrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch0_rxrate_0]
  connect_bd_net -net ch0_rxrate_1_1 [get_bd_ports ch0_rxrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch0_rxrate_1]
  connect_bd_net -net ch0_txrate_0_1 [get_bd_ports ch0_txrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch0_txrate_0]
  connect_bd_net -net ch0_txrate_1_1 [get_bd_ports ch0_txrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch0_txrate_1]
  connect_bd_net -net ch1_loopback_0_1 [get_bd_ports ch1_loopback_0] [get_bd_pins dcmac_0_gt_wrapper/ch1_loopback_0]
  connect_bd_net -net ch1_loopback_1_1 [get_bd_ports ch1_loopback_1] [get_bd_pins dcmac_0_gt_wrapper/ch1_loopback_1]
  connect_bd_net -net ch1_rxrate_0_1 [get_bd_ports ch1_rxrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch1_rxrate_0]
  connect_bd_net -net ch1_rxrate_1_1 [get_bd_ports ch1_rxrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch1_rxrate_1]
  connect_bd_net -net ch1_txrate_0_1 [get_bd_ports ch1_txrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch1_txrate_0]
  connect_bd_net -net ch1_txrate_1_1 [get_bd_ports ch1_txrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch1_txrate_1]
  connect_bd_net -net ch2_loopback_0_1 [get_bd_ports ch2_loopback_0] [get_bd_pins dcmac_0_gt_wrapper/ch2_loopback_0]
  connect_bd_net -net ch2_loopback_1_1 [get_bd_ports ch2_loopback_1] [get_bd_pins dcmac_0_gt_wrapper/ch2_loopback_1]
  connect_bd_net -net ch2_rxrate_0_1 [get_bd_ports ch2_rxrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch2_rxrate_0]
  connect_bd_net -net ch2_rxrate_1_1 [get_bd_ports ch2_rxrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch2_rxrate_1]
  connect_bd_net -net ch2_txrate_0_1 [get_bd_ports ch2_txrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch2_txrate_0]
  connect_bd_net -net ch2_txrate_1_1 [get_bd_ports ch2_txrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch2_txrate_1]
  connect_bd_net -net ch3_loopback_0_1 [get_bd_ports ch3_loopback_0] [get_bd_pins dcmac_0_gt_wrapper/ch3_loopback_0]
  connect_bd_net -net ch3_loopback_1_1 [get_bd_ports ch3_loopback_1] [get_bd_pins dcmac_0_gt_wrapper/ch3_loopback_1]
  connect_bd_net -net ch3_rxrate_0_1 [get_bd_ports ch3_rxrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch3_rxrate_0]
  connect_bd_net -net ch3_rxrate_1_1 [get_bd_ports ch3_rxrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch3_rxrate_1]
  connect_bd_net -net ch3_txrate_0_1 [get_bd_ports ch3_txrate_0] [get_bd_pins dcmac_0_gt_wrapper/ch3_txrate_0]
  connect_bd_net -net ch3_txrate_1_1 [get_bd_ports ch3_txrate_1] [get_bd_pins dcmac_0_gt_wrapper/ch3_txrate_1]
  connect_bd_net -net ctl_rsvd_in_1 [get_bd_ports ctl_rsvd_in] [get_bd_pins dcmac_0_core/ctl_rsvd_in]
  connect_bd_net -net dcmac_0_core_c0_stat_rx_corrected_lane_delay_0 [get_bd_pins dcmac_0_core/c0_stat_rx_corrected_lane_delay_0] [get_bd_ports c0_stat_rx_corrected_lane_delay_0]
  connect_bd_net -net dcmac_0_core_c0_stat_rx_corrected_lane_delay_1 [get_bd_pins dcmac_0_core/c0_stat_rx_corrected_lane_delay_1] [get_bd_ports c0_stat_rx_corrected_lane_delay_1]
  connect_bd_net -net dcmac_0_core_c0_stat_rx_corrected_lane_delay_2 [get_bd_pins dcmac_0_core/c0_stat_rx_corrected_lane_delay_2] [get_bd_ports c0_stat_rx_corrected_lane_delay_2]
  connect_bd_net -net dcmac_0_core_c0_stat_rx_corrected_lane_delay_3 [get_bd_pins dcmac_0_core/c0_stat_rx_corrected_lane_delay_3] [get_bd_ports c0_stat_rx_corrected_lane_delay_3]
  connect_bd_net -net dcmac_0_core_c0_stat_rx_corrected_lane_delay_valid [get_bd_pins dcmac_0_core/c0_stat_rx_corrected_lane_delay_valid] [get_bd_ports c0_stat_rx_corrected_lane_delay_valid]
  connect_bd_net -net dcmac_0_core_c1_stat_rx_corrected_lane_delay_0 [get_bd_pins dcmac_0_core/c1_stat_rx_corrected_lane_delay_0] [get_bd_ports c1_stat_rx_corrected_lane_delay_0]
  connect_bd_net -net dcmac_0_core_c1_stat_rx_corrected_lane_delay_1 [get_bd_pins dcmac_0_core/c1_stat_rx_corrected_lane_delay_1] [get_bd_ports c1_stat_rx_corrected_lane_delay_1]
  connect_bd_net -net dcmac_0_core_c1_stat_rx_corrected_lane_delay_2 [get_bd_pins dcmac_0_core/c1_stat_rx_corrected_lane_delay_2] [get_bd_ports c1_stat_rx_corrected_lane_delay_2]
  connect_bd_net -net dcmac_0_core_c1_stat_rx_corrected_lane_delay_3 [get_bd_pins dcmac_0_core/c1_stat_rx_corrected_lane_delay_3] [get_bd_ports c1_stat_rx_corrected_lane_delay_3]
  connect_bd_net -net dcmac_0_core_c1_stat_rx_corrected_lane_delay_valid [get_bd_pins dcmac_0_core/c1_stat_rx_corrected_lane_delay_valid] [get_bd_ports c1_stat_rx_corrected_lane_delay_valid]
  connect_bd_net -net dcmac_0_core_c2_stat_rx_corrected_lane_delay_0 [get_bd_pins dcmac_0_core/c2_stat_rx_corrected_lane_delay_0] [get_bd_ports c2_stat_rx_corrected_lane_delay_0]
  connect_bd_net -net dcmac_0_core_c2_stat_rx_corrected_lane_delay_1 [get_bd_pins dcmac_0_core/c2_stat_rx_corrected_lane_delay_1] [get_bd_ports c2_stat_rx_corrected_lane_delay_1]
  connect_bd_net -net dcmac_0_core_c2_stat_rx_corrected_lane_delay_2 [get_bd_pins dcmac_0_core/c2_stat_rx_corrected_lane_delay_2] [get_bd_ports c2_stat_rx_corrected_lane_delay_2]
  connect_bd_net -net dcmac_0_core_c2_stat_rx_corrected_lane_delay_3 [get_bd_pins dcmac_0_core/c2_stat_rx_corrected_lane_delay_3] [get_bd_ports c2_stat_rx_corrected_lane_delay_3]
  connect_bd_net -net dcmac_0_core_c2_stat_rx_corrected_lane_delay_valid [get_bd_pins dcmac_0_core/c2_stat_rx_corrected_lane_delay_valid] [get_bd_ports c2_stat_rx_corrected_lane_delay_valid]
  connect_bd_net -net dcmac_0_core_c3_stat_rx_corrected_lane_delay_0 [get_bd_pins dcmac_0_core/c3_stat_rx_corrected_lane_delay_0] [get_bd_ports c3_stat_rx_corrected_lane_delay_0]
  connect_bd_net -net dcmac_0_core_c3_stat_rx_corrected_lane_delay_1 [get_bd_pins dcmac_0_core/c3_stat_rx_corrected_lane_delay_1] [get_bd_ports c3_stat_rx_corrected_lane_delay_1]
  connect_bd_net -net dcmac_0_core_c3_stat_rx_corrected_lane_delay_2 [get_bd_pins dcmac_0_core/c3_stat_rx_corrected_lane_delay_2] [get_bd_ports c3_stat_rx_corrected_lane_delay_2]
  connect_bd_net -net dcmac_0_core_c3_stat_rx_corrected_lane_delay_3 [get_bd_pins dcmac_0_core/c3_stat_rx_corrected_lane_delay_3] [get_bd_ports c3_stat_rx_corrected_lane_delay_3]
  connect_bd_net -net dcmac_0_core_c3_stat_rx_corrected_lane_delay_valid [get_bd_pins dcmac_0_core/c3_stat_rx_corrected_lane_delay_valid] [get_bd_ports c3_stat_rx_corrected_lane_delay_valid]
  connect_bd_net -net dcmac_0_core_c4_stat_rx_corrected_lane_delay_0 [get_bd_pins dcmac_0_core/c4_stat_rx_corrected_lane_delay_0] [get_bd_ports c4_stat_rx_corrected_lane_delay_0]
  connect_bd_net -net dcmac_0_core_c4_stat_rx_corrected_lane_delay_1 [get_bd_pins dcmac_0_core/c4_stat_rx_corrected_lane_delay_1] [get_bd_ports c4_stat_rx_corrected_lane_delay_1]
  connect_bd_net -net dcmac_0_core_c4_stat_rx_corrected_lane_delay_2 [get_bd_pins dcmac_0_core/c4_stat_rx_corrected_lane_delay_2] [get_bd_ports c4_stat_rx_corrected_lane_delay_2]
  connect_bd_net -net dcmac_0_core_c4_stat_rx_corrected_lane_delay_3 [get_bd_pins dcmac_0_core/c4_stat_rx_corrected_lane_delay_3] [get_bd_ports c4_stat_rx_corrected_lane_delay_3]
  connect_bd_net -net dcmac_0_core_c4_stat_rx_corrected_lane_delay_valid [get_bd_pins dcmac_0_core/c4_stat_rx_corrected_lane_delay_valid] [get_bd_ports c4_stat_rx_corrected_lane_delay_valid]
  connect_bd_net -net dcmac_0_core_c5_stat_rx_corrected_lane_delay_0 [get_bd_pins dcmac_0_core/c5_stat_rx_corrected_lane_delay_0] [get_bd_ports c5_stat_rx_corrected_lane_delay_0]
  connect_bd_net -net dcmac_0_core_c5_stat_rx_corrected_lane_delay_1 [get_bd_pins dcmac_0_core/c5_stat_rx_corrected_lane_delay_1] [get_bd_ports c5_stat_rx_corrected_lane_delay_1]
  connect_bd_net -net dcmac_0_core_c5_stat_rx_corrected_lane_delay_2 [get_bd_pins dcmac_0_core/c5_stat_rx_corrected_lane_delay_2] [get_bd_ports c5_stat_rx_corrected_lane_delay_2]
  connect_bd_net -net dcmac_0_core_c5_stat_rx_corrected_lane_delay_3 [get_bd_pins dcmac_0_core/c5_stat_rx_corrected_lane_delay_3] [get_bd_ports c5_stat_rx_corrected_lane_delay_3]
  connect_bd_net -net dcmac_0_core_c5_stat_rx_corrected_lane_delay_valid [get_bd_pins dcmac_0_core/c5_stat_rx_corrected_lane_delay_valid] [get_bd_ports c5_stat_rx_corrected_lane_delay_valid]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_0 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_0] [get_bd_ports gt_rx_reset_done_out_0]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_1 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_1] [get_bd_ports gt_rx_reset_done_out_1]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_2 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_2] [get_bd_ports gt_rx_reset_done_out_2]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_3 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_3] [get_bd_ports gt_rx_reset_done_out_3]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_4 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_4] [get_bd_ports gt_rx_reset_done_out_4]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_5 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_5] [get_bd_ports gt_rx_reset_done_out_5]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_6 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_6] [get_bd_ports gt_rx_reset_done_out_6]
  connect_bd_net -net dcmac_0_core_gt_rx_reset_done_out_7 [get_bd_pins dcmac_0_core/gt_rx_reset_done_out_7] [get_bd_ports gt_rx_reset_done_out_7]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_0 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_0] [get_bd_ports gt_tx_reset_done_out_0]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_1 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_1] [get_bd_ports gt_tx_reset_done_out_1]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_2 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_2] [get_bd_ports gt_tx_reset_done_out_2]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_3 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_3] [get_bd_ports gt_tx_reset_done_out_3]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_4 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_4] [get_bd_ports gt_tx_reset_done_out_4]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_5 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_5] [get_bd_ports gt_tx_reset_done_out_5]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_6 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_6] [get_bd_ports gt_tx_reset_done_out_6]
  connect_bd_net -net dcmac_0_core_gt_tx_reset_done_out_7 [get_bd_pins dcmac_0_core/gt_tx_reset_done_out_7] [get_bd_ports gt_tx_reset_done_out_7]
  connect_bd_net -net dcmac_0_core_iloreset_out_0 [get_bd_pins dcmac_0_core/iloreset_out_0] [get_bd_pins dcmac_0_gt_wrapper/ch0_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_1 [get_bd_pins dcmac_0_core/iloreset_out_1] [get_bd_pins dcmac_0_gt_wrapper/ch1_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_2 [get_bd_pins dcmac_0_core/iloreset_out_2] [get_bd_pins dcmac_0_gt_wrapper/ch2_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_3 [get_bd_pins dcmac_0_core/iloreset_out_3] [get_bd_pins dcmac_0_gt_wrapper/ch3_iloreset]
  connect_bd_net -net dcmac_0_core_iloreset_out_4 [get_bd_pins dcmac_0_core/iloreset_out_4] [get_bd_pins dcmac_0_gt_wrapper/ch0_iloreset1]
  connect_bd_net -net dcmac_0_core_iloreset_out_5 [get_bd_pins dcmac_0_core/iloreset_out_5] [get_bd_pins dcmac_0_gt_wrapper/ch1_iloreset1]
  connect_bd_net -net dcmac_0_core_iloreset_out_6 [get_bd_pins dcmac_0_core/iloreset_out_6] [get_bd_pins dcmac_0_gt_wrapper/ch2_iloreset1]
  connect_bd_net -net dcmac_0_core_iloreset_out_7 [get_bd_pins dcmac_0_core/iloreset_out_7] [get_bd_pins dcmac_0_gt_wrapper/ch3_iloreset1]
  connect_bd_net -net dcmac_0_core_pllreset_out_0 [get_bd_pins dcmac_0_core/pllreset_out_0] [get_bd_pins dcmac_0_gt_wrapper/hsclk1_lcpllreset]
  connect_bd_net -net dcmac_0_core_pllreset_out_1 [get_bd_pins dcmac_0_core/pllreset_out_1] [get_bd_pins dcmac_0_gt_wrapper/hsclk0_rpllreset]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata0 [get_bd_pins dcmac_0_core/rx_axis_tdata0] [get_bd_ports rx_axis_tdata0]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata1 [get_bd_pins dcmac_0_core/rx_axis_tdata1] [get_bd_ports rx_axis_tdata1]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata2 [get_bd_pins dcmac_0_core/rx_axis_tdata2] [get_bd_ports rx_axis_tdata2]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata3 [get_bd_pins dcmac_0_core/rx_axis_tdata3] [get_bd_ports rx_axis_tdata3]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata4 [get_bd_pins dcmac_0_core/rx_axis_tdata4] [get_bd_ports rx_axis_tdata4]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata5 [get_bd_pins dcmac_0_core/rx_axis_tdata5] [get_bd_ports rx_axis_tdata5]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata6 [get_bd_pins dcmac_0_core/rx_axis_tdata6] [get_bd_ports rx_axis_tdata6]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata7 [get_bd_pins dcmac_0_core/rx_axis_tdata7] [get_bd_ports rx_axis_tdata7]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata8 [get_bd_pins dcmac_0_core/rx_axis_tdata8] [get_bd_ports rx_axis_tdata8]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata9 [get_bd_pins dcmac_0_core/rx_axis_tdata9] [get_bd_ports rx_axis_tdata9]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata10 [get_bd_pins dcmac_0_core/rx_axis_tdata10] [get_bd_ports rx_axis_tdata10]
  connect_bd_net -net dcmac_0_core_rx_axis_tdata11 [get_bd_pins dcmac_0_core/rx_axis_tdata11] [get_bd_ports rx_axis_tdata11]
  connect_bd_net -net dcmac_0_core_rx_axis_tid [get_bd_pins dcmac_0_core/rx_axis_tid] [get_bd_ports rx_axis_tid]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena0 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena0] [get_bd_ports rx_axis_tuser_ena0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena1 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena1] [get_bd_ports rx_axis_tuser_ena1]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena2 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena2] [get_bd_ports rx_axis_tuser_ena2]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena3 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena3] [get_bd_ports rx_axis_tuser_ena3]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena4 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena4] [get_bd_ports rx_axis_tuser_ena4]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena5 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena5] [get_bd_ports rx_axis_tuser_ena5]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena6 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena6] [get_bd_ports rx_axis_tuser_ena6]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena7 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena7] [get_bd_ports rx_axis_tuser_ena7]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena8 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena8] [get_bd_ports rx_axis_tuser_ena8]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena9 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena9] [get_bd_ports rx_axis_tuser_ena9]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena10 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena10] [get_bd_ports rx_axis_tuser_ena10]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_ena11 [get_bd_pins dcmac_0_core/rx_axis_tuser_ena11] [get_bd_ports rx_axis_tuser_ena11]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop0 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop0] [get_bd_ports rx_axis_tuser_eop0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop1 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop1] [get_bd_ports rx_axis_tuser_eop1]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop2 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop2] [get_bd_ports rx_axis_tuser_eop2]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop3 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop3] [get_bd_ports rx_axis_tuser_eop3]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop4 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop4] [get_bd_ports rx_axis_tuser_eop4]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop5 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop5] [get_bd_ports rx_axis_tuser_eop5]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop6 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop6] [get_bd_ports rx_axis_tuser_eop6]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop7 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop7] [get_bd_ports rx_axis_tuser_eop7]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop8 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop8] [get_bd_ports rx_axis_tuser_eop8]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop9 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop9] [get_bd_ports rx_axis_tuser_eop9]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop10 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop10] [get_bd_ports rx_axis_tuser_eop10]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_eop11 [get_bd_pins dcmac_0_core/rx_axis_tuser_eop11] [get_bd_ports rx_axis_tuser_eop11]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err0 [get_bd_pins dcmac_0_core/rx_axis_tuser_err0] [get_bd_ports rx_axis_tuser_err0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err1 [get_bd_pins dcmac_0_core/rx_axis_tuser_err1] [get_bd_ports rx_axis_tuser_err1]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err2 [get_bd_pins dcmac_0_core/rx_axis_tuser_err2] [get_bd_ports rx_axis_tuser_err2]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err3 [get_bd_pins dcmac_0_core/rx_axis_tuser_err3] [get_bd_ports rx_axis_tuser_err3]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err4 [get_bd_pins dcmac_0_core/rx_axis_tuser_err4] [get_bd_ports rx_axis_tuser_err4]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err5 [get_bd_pins dcmac_0_core/rx_axis_tuser_err5] [get_bd_ports rx_axis_tuser_err5]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err6 [get_bd_pins dcmac_0_core/rx_axis_tuser_err6] [get_bd_ports rx_axis_tuser_err6]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err7 [get_bd_pins dcmac_0_core/rx_axis_tuser_err7] [get_bd_ports rx_axis_tuser_err7]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err8 [get_bd_pins dcmac_0_core/rx_axis_tuser_err8] [get_bd_ports rx_axis_tuser_err8]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err9 [get_bd_pins dcmac_0_core/rx_axis_tuser_err9] [get_bd_ports rx_axis_tuser_err9]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err10 [get_bd_pins dcmac_0_core/rx_axis_tuser_err10] [get_bd_ports rx_axis_tuser_err10]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_err11 [get_bd_pins dcmac_0_core/rx_axis_tuser_err11] [get_bd_ports rx_axis_tuser_err11]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty0 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty0] [get_bd_ports rx_axis_tuser_mty0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty1 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty1] [get_bd_ports rx_axis_tuser_mty1]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty2 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty2] [get_bd_ports rx_axis_tuser_mty2]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty3 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty3] [get_bd_ports rx_axis_tuser_mty3]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty4 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty4] [get_bd_ports rx_axis_tuser_mty4]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty5 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty5] [get_bd_ports rx_axis_tuser_mty5]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty6 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty6] [get_bd_ports rx_axis_tuser_mty6]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty7 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty7] [get_bd_ports rx_axis_tuser_mty7]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty8 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty8] [get_bd_ports rx_axis_tuser_mty8]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty9 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty9] [get_bd_ports rx_axis_tuser_mty9]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty10 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty10] [get_bd_ports rx_axis_tuser_mty10]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_mty11 [get_bd_pins dcmac_0_core/rx_axis_tuser_mty11] [get_bd_ports rx_axis_tuser_mty11]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop0 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop0] [get_bd_ports rx_axis_tuser_sop0]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop1 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop1] [get_bd_ports rx_axis_tuser_sop1]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop2 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop2] [get_bd_ports rx_axis_tuser_sop2]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop3 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop3] [get_bd_ports rx_axis_tuser_sop3]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop4 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop4] [get_bd_ports rx_axis_tuser_sop4]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop5 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop5] [get_bd_ports rx_axis_tuser_sop5]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop6 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop6] [get_bd_ports rx_axis_tuser_sop6]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop7 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop7] [get_bd_ports rx_axis_tuser_sop7]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop8 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop8] [get_bd_ports rx_axis_tuser_sop8]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop9 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop9] [get_bd_ports rx_axis_tuser_sop9]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop10 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop10] [get_bd_ports rx_axis_tuser_sop10]
  connect_bd_net -net dcmac_0_core_rx_axis_tuser_sop11 [get_bd_pins dcmac_0_core/rx_axis_tuser_sop11] [get_bd_ports rx_axis_tuser_sop11]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_0 [get_bd_pins dcmac_0_core/rx_axis_tvalid_0] [get_bd_ports rx_axis_tvalid_0]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_1 [get_bd_pins dcmac_0_core/rx_axis_tvalid_1] [get_bd_ports rx_axis_tvalid_1]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_2 [get_bd_pins dcmac_0_core/rx_axis_tvalid_2] [get_bd_ports rx_axis_tvalid_2]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_3 [get_bd_pins dcmac_0_core/rx_axis_tvalid_3] [get_bd_ports rx_axis_tvalid_3]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_4 [get_bd_pins dcmac_0_core/rx_axis_tvalid_4] [get_bd_ports rx_axis_tvalid_4]
  connect_bd_net -net dcmac_0_core_rx_axis_tvalid_5 [get_bd_pins dcmac_0_core/rx_axis_tvalid_5] [get_bd_ports rx_axis_tvalid_5]
  connect_bd_net -net dcmac_0_core_rx_clr_out_0 [get_bd_pins dcmac_0_core/rx_clr_out_0] [get_bd_pins dcmac_0_gt_wrapper/MBUFG_GT_CLR]
  connect_bd_net -net dcmac_0_core_rx_clrb_leaf_out_0 [get_bd_pins dcmac_0_core/rx_clrb_leaf_out_0] [get_bd_pins dcmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF]
  connect_bd_net -net dcmac_0_core_rx_lane_aligner_fill [get_bd_pins dcmac_0_core/rx_lane_aligner_fill] [get_bd_ports rx_lane_aligner_fill]
  connect_bd_net -net dcmac_0_core_rx_lane_aligner_fill_start [get_bd_pins dcmac_0_core/rx_lane_aligner_fill_start] [get_bd_ports rx_lane_aligner_fill_start]
  connect_bd_net -net dcmac_0_core_rx_lane_aligner_fill_valid [get_bd_pins dcmac_0_core/rx_lane_aligner_fill_valid] [get_bd_ports rx_lane_aligner_fill_valid]
  connect_bd_net -net dcmac_0_core_rx_pcs_tdm_stats_data [get_bd_pins dcmac_0_core/rx_pcs_tdm_stats_data] [get_bd_ports rx_pcs_tdm_stats_data]
  connect_bd_net -net dcmac_0_core_rx_pcs_tdm_stats_start [get_bd_pins dcmac_0_core/rx_pcs_tdm_stats_start] [get_bd_ports rx_pcs_tdm_stats_start]
  connect_bd_net -net dcmac_0_core_rx_pcs_tdm_stats_valid [get_bd_pins dcmac_0_core/rx_pcs_tdm_stats_valid] [get_bd_ports rx_pcs_tdm_stats_valid]
  connect_bd_net -net dcmac_0_core_rx_port_pm_rdy [get_bd_pins dcmac_0_core/rx_port_pm_rdy] [get_bd_ports rx_port_pm_rdy]
  connect_bd_net -net dcmac_0_core_rx_preambleout_0 [get_bd_pins dcmac_0_core/rx_preambleout_0] [get_bd_ports rx_preambleout_0]
  connect_bd_net -net dcmac_0_core_rx_preambleout_1 [get_bd_pins dcmac_0_core/rx_preambleout_1] [get_bd_ports rx_preambleout_1]
  connect_bd_net -net dcmac_0_core_rx_preambleout_2 [get_bd_pins dcmac_0_core/rx_preambleout_2] [get_bd_ports rx_preambleout_2]
  connect_bd_net -net dcmac_0_core_rx_preambleout_3 [get_bd_pins dcmac_0_core/rx_preambleout_3] [get_bd_ports rx_preambleout_3]
  connect_bd_net -net dcmac_0_core_rx_preambleout_4 [get_bd_pins dcmac_0_core/rx_preambleout_4] [get_bd_ports rx_preambleout_4]
  connect_bd_net -net dcmac_0_core_rx_preambleout_5 [get_bd_pins dcmac_0_core/rx_preambleout_5] [get_bd_ports rx_preambleout_5]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_restart_0 [get_bd_pins dcmac_0_core/rx_serdes_albuf_restart_0] [get_bd_ports rx_serdes_albuf_restart_0]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_restart_1 [get_bd_pins dcmac_0_core/rx_serdes_albuf_restart_1] [get_bd_ports rx_serdes_albuf_restart_1]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_restart_2 [get_bd_pins dcmac_0_core/rx_serdes_albuf_restart_2] [get_bd_ports rx_serdes_albuf_restart_2]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_restart_3 [get_bd_pins dcmac_0_core/rx_serdes_albuf_restart_3] [get_bd_ports rx_serdes_albuf_restart_3]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_restart_4 [get_bd_pins dcmac_0_core/rx_serdes_albuf_restart_4] [get_bd_ports rx_serdes_albuf_restart_4]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_restart_5 [get_bd_pins dcmac_0_core/rx_serdes_albuf_restart_5] [get_bd_ports rx_serdes_albuf_restart_5]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_0 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_0] [get_bd_ports rx_serdes_albuf_slip_0]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_1 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_1] [get_bd_ports rx_serdes_albuf_slip_1]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_2 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_2] [get_bd_ports rx_serdes_albuf_slip_2]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_3 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_3] [get_bd_ports rx_serdes_albuf_slip_3]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_4 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_4] [get_bd_ports rx_serdes_albuf_slip_4]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_5 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_5] [get_bd_ports rx_serdes_albuf_slip_5]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_6 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_6] [get_bd_ports rx_serdes_albuf_slip_6]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_7 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_7] [get_bd_ports rx_serdes_albuf_slip_7]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_8 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_8] [get_bd_ports rx_serdes_albuf_slip_8]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_9 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_9] [get_bd_ports rx_serdes_albuf_slip_9]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_10 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_10] [get_bd_ports rx_serdes_albuf_slip_10]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_11 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_11] [get_bd_ports rx_serdes_albuf_slip_11]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_12 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_12] [get_bd_ports rx_serdes_albuf_slip_12]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_13 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_13] [get_bd_ports rx_serdes_albuf_slip_13]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_14 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_14] [get_bd_ports rx_serdes_albuf_slip_14]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_15 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_15] [get_bd_ports rx_serdes_albuf_slip_15]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_16 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_16] [get_bd_ports rx_serdes_albuf_slip_16]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_17 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_17] [get_bd_ports rx_serdes_albuf_slip_17]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_18 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_18] [get_bd_ports rx_serdes_albuf_slip_18]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_19 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_19] [get_bd_ports rx_serdes_albuf_slip_19]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_20 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_20] [get_bd_ports rx_serdes_albuf_slip_20]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_21 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_21] [get_bd_ports rx_serdes_albuf_slip_21]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_22 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_22] [get_bd_ports rx_serdes_albuf_slip_22]
  connect_bd_net -net dcmac_0_core_rx_serdes_albuf_slip_23 [get_bd_pins dcmac_0_core/rx_serdes_albuf_slip_23] [get_bd_ports rx_serdes_albuf_slip_23]
  connect_bd_net -net dcmac_0_core_rx_serdes_fifo_flagout_0 [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagout_0] [get_bd_ports rx_serdes_fifo_flagout_0]
  connect_bd_net -net dcmac_0_core_rx_serdes_fifo_flagout_1 [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagout_1] [get_bd_ports rx_serdes_fifo_flagout_1]
  connect_bd_net -net dcmac_0_core_rx_serdes_fifo_flagout_2 [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagout_2] [get_bd_ports rx_serdes_fifo_flagout_2]
  connect_bd_net -net dcmac_0_core_rx_serdes_fifo_flagout_3 [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagout_3] [get_bd_ports rx_serdes_fifo_flagout_3]
  connect_bd_net -net dcmac_0_core_rx_serdes_fifo_flagout_4 [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagout_4] [get_bd_ports rx_serdes_fifo_flagout_4]
  connect_bd_net -net dcmac_0_core_rx_serdes_fifo_flagout_5 [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagout_5] [get_bd_ports rx_serdes_fifo_flagout_5]
  connect_bd_net -net dcmac_0_core_rx_tsmac_tdm_stats_data [get_bd_pins dcmac_0_core/rx_tsmac_tdm_stats_data] [get_bd_ports rx_tsmac_tdm_stats_data]
  connect_bd_net -net dcmac_0_core_rx_tsmac_tdm_stats_id [get_bd_pins dcmac_0_core/rx_tsmac_tdm_stats_id] [get_bd_ports rx_tsmac_tdm_stats_id]
  connect_bd_net -net dcmac_0_core_rx_tsmac_tdm_stats_valid [get_bd_pins dcmac_0_core/rx_tsmac_tdm_stats_valid] [get_bd_ports rx_tsmac_tdm_stats_valid]
  connect_bd_net -net dcmac_0_core_tx_all_channel_mac_pm_rdy [get_bd_pins dcmac_0_core/tx_all_channel_mac_pm_rdy] [get_bd_ports tx_all_channel_mac_pm_rdy]
  connect_bd_net -net dcmac_0_core_tx_axis_ch_status_id [get_bd_pins dcmac_0_core/tx_axis_ch_status_id] [get_bd_ports tx_axis_ch_status_id]
  connect_bd_net -net dcmac_0_core_tx_axis_ch_status_skip_req [get_bd_pins dcmac_0_core/tx_axis_ch_status_skip_req] [get_bd_ports tx_axis_ch_status_skip_req]
  connect_bd_net -net dcmac_0_core_tx_axis_ch_status_vld [get_bd_pins dcmac_0_core/tx_axis_ch_status_vld] [get_bd_ports tx_axis_ch_status_vld]
  connect_bd_net -net dcmac_0_core_tx_axis_id_req [get_bd_pins dcmac_0_core/tx_axis_id_req] [get_bd_ports tx_axis_id_req]
  connect_bd_net -net dcmac_0_core_tx_axis_id_req_vld [get_bd_pins dcmac_0_core/tx_axis_id_req_vld] [get_bd_ports tx_axis_id_req_vld]
  connect_bd_net -net dcmac_0_core_tx_axis_taf_0 [get_bd_pins dcmac_0_core/tx_axis_taf_0] [get_bd_ports tx_axis_taf_0]
  connect_bd_net -net dcmac_0_core_tx_axis_taf_1 [get_bd_pins dcmac_0_core/tx_axis_taf_1] [get_bd_ports tx_axis_taf_1]
  connect_bd_net -net dcmac_0_core_tx_axis_taf_2 [get_bd_pins dcmac_0_core/tx_axis_taf_2] [get_bd_ports tx_axis_taf_2]
  connect_bd_net -net dcmac_0_core_tx_axis_taf_3 [get_bd_pins dcmac_0_core/tx_axis_taf_3] [get_bd_ports tx_axis_taf_3]
  connect_bd_net -net dcmac_0_core_tx_axis_taf_4 [get_bd_pins dcmac_0_core/tx_axis_taf_4] [get_bd_ports tx_axis_taf_4]
  connect_bd_net -net dcmac_0_core_tx_axis_taf_5 [get_bd_pins dcmac_0_core/tx_axis_taf_5] [get_bd_ports tx_axis_taf_5]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_0 [get_bd_pins dcmac_0_core/tx_axis_tready_0] [get_bd_ports tx_axis_tready_0]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_1 [get_bd_pins dcmac_0_core/tx_axis_tready_1] [get_bd_ports tx_axis_tready_1]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_2 [get_bd_pins dcmac_0_core/tx_axis_tready_2] [get_bd_ports tx_axis_tready_2]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_3 [get_bd_pins dcmac_0_core/tx_axis_tready_3] [get_bd_ports tx_axis_tready_3]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_4 [get_bd_pins dcmac_0_core/tx_axis_tready_4] [get_bd_ports tx_axis_tready_4]
  connect_bd_net -net dcmac_0_core_tx_axis_tready_5 [get_bd_pins dcmac_0_core/tx_axis_tready_5] [get_bd_ports tx_axis_tready_5]
  connect_bd_net -net dcmac_0_core_tx_clr_out_0 [get_bd_pins dcmac_0_core/tx_clr_out_0] [get_bd_pins dcmac_0_gt_wrapper/MBUFG_GT_CLR1]
  connect_bd_net -net dcmac_0_core_tx_clrb_leaf_out_0 [get_bd_pins dcmac_0_core/tx_clrb_leaf_out_0] [get_bd_pins dcmac_0_gt_wrapper/MBUFG_GT_CLRB_LEAF1]
  connect_bd_net -net dcmac_0_core_tx_pcs_tdm_stats_data [get_bd_pins dcmac_0_core/tx_pcs_tdm_stats_data] [get_bd_ports tx_pcs_tdm_stats_data]
  connect_bd_net -net dcmac_0_core_tx_pcs_tdm_stats_start [get_bd_pins dcmac_0_core/tx_pcs_tdm_stats_start] [get_bd_ports tx_pcs_tdm_stats_start]
  connect_bd_net -net dcmac_0_core_tx_pcs_tdm_stats_valid [get_bd_pins dcmac_0_core/tx_pcs_tdm_stats_valid] [get_bd_ports tx_pcs_tdm_stats_valid]
  connect_bd_net -net dcmac_0_core_tx_port_pm_rdy [get_bd_pins dcmac_0_core/tx_port_pm_rdy] [get_bd_ports tx_port_pm_rdy]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_0 [get_bd_pins dcmac_0_core/tx_serdes_is_am_0] [get_bd_ports tx_serdes_is_am_0]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_1 [get_bd_pins dcmac_0_core/tx_serdes_is_am_1] [get_bd_ports tx_serdes_is_am_1]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_2 [get_bd_pins dcmac_0_core/tx_serdes_is_am_2] [get_bd_ports tx_serdes_is_am_2]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_3 [get_bd_pins dcmac_0_core/tx_serdes_is_am_3] [get_bd_ports tx_serdes_is_am_3]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_4 [get_bd_pins dcmac_0_core/tx_serdes_is_am_4] [get_bd_ports tx_serdes_is_am_4]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_5 [get_bd_pins dcmac_0_core/tx_serdes_is_am_5] [get_bd_ports tx_serdes_is_am_5]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_prefifo_0 [get_bd_pins dcmac_0_core/tx_serdes_is_am_prefifo_0] [get_bd_ports tx_serdes_is_am_prefifo_0]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_prefifo_1 [get_bd_pins dcmac_0_core/tx_serdes_is_am_prefifo_1] [get_bd_ports tx_serdes_is_am_prefifo_1]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_prefifo_2 [get_bd_pins dcmac_0_core/tx_serdes_is_am_prefifo_2] [get_bd_ports tx_serdes_is_am_prefifo_2]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_prefifo_3 [get_bd_pins dcmac_0_core/tx_serdes_is_am_prefifo_3] [get_bd_ports tx_serdes_is_am_prefifo_3]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_prefifo_4 [get_bd_pins dcmac_0_core/tx_serdes_is_am_prefifo_4] [get_bd_ports tx_serdes_is_am_prefifo_4]
  connect_bd_net -net dcmac_0_core_tx_serdes_is_am_prefifo_5 [get_bd_pins dcmac_0_core/tx_serdes_is_am_prefifo_5] [get_bd_ports tx_serdes_is_am_prefifo_5]
  connect_bd_net -net dcmac_0_core_tx_tsmac_tdm_stats_data [get_bd_pins dcmac_0_core/tx_tsmac_tdm_stats_data] [get_bd_ports tx_tsmac_tdm_stats_data]
  connect_bd_net -net dcmac_0_core_tx_tsmac_tdm_stats_id [get_bd_pins dcmac_0_core/tx_tsmac_tdm_stats_id] [get_bd_ports tx_tsmac_tdm_stats_id]
  connect_bd_net -net dcmac_0_core_tx_tsmac_tdm_stats_valid [get_bd_pins dcmac_0_core/tx_tsmac_tdm_stats_valid] [get_bd_ports tx_tsmac_tdm_stats_valid]
  connect_bd_net -net gt_quad_base_1_ch0_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch0_iloresetdone1] [get_bd_pins dcmac_0_core/ilo_reset_done_4]
  connect_bd_net -net gt_quad_base_1_ch1_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch1_iloresetdone1] [get_bd_pins dcmac_0_core/ilo_reset_done_5]
  connect_bd_net -net gt_quad_base_1_ch2_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch2_iloresetdone1] [get_bd_pins dcmac_0_core/ilo_reset_done_6]
  connect_bd_net -net gt_quad_base_1_ch3_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch3_iloresetdone1] [get_bd_pins dcmac_0_core/ilo_reset_done_7]
  connect_bd_net -net gt_quad_base_1_gtpowergood [get_bd_pins dcmac_0_gt_wrapper/gtpowergood_1] [get_bd_ports gtpowergood_1]
  connect_bd_net -net gt_quad_base_1_hsclk0_lcplllock [get_bd_pins dcmac_0_gt_wrapper/hsclk0_lcplllock1] [get_bd_pins dcmac_0_core/plllock_in_1]
  connect_bd_net -net gt_quad_base_ch0_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch0_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_0]
  connect_bd_net -net gt_quad_base_ch1_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch1_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_1]
  connect_bd_net -net gt_quad_base_ch2_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch2_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_2]
  connect_bd_net -net gt_quad_base_ch3_iloresetdone [get_bd_pins dcmac_0_gt_wrapper/ch3_iloresetdone] [get_bd_pins dcmac_0_core/ilo_reset_done_3]
  connect_bd_net -net gt_quad_base_gpo [get_bd_pins dcmac_0_gt_wrapper/gpo] [get_bd_ports gpo]
  connect_bd_net -net gt_quad_base_gtpowergood [get_bd_pins dcmac_0_gt_wrapper/gtpowergood_0] [get_bd_ports gtpowergood_0]
  connect_bd_net -net gt_quad_base_hsclk0_lcplllock [get_bd_pins dcmac_0_gt_wrapper/hsclk0_lcplllock] [get_bd_pins dcmac_0_core/plllock_in_0]
  connect_bd_net -net gt_reset_all_in_1 [get_bd_ports gt_reset_all_in] [get_bd_pins dcmac_0_core/gt_reset_all_in]
  connect_bd_net -net gt_reset_rx_datapath_in_0_1 [get_bd_ports gt_reset_rx_datapath_in_0] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_0]
  connect_bd_net -net gt_reset_rx_datapath_in_1_1 [get_bd_ports gt_reset_rx_datapath_in_1] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_1]
  connect_bd_net -net gt_reset_rx_datapath_in_2_1 [get_bd_ports gt_reset_rx_datapath_in_2] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_2]
  connect_bd_net -net gt_reset_rx_datapath_in_3_1 [get_bd_ports gt_reset_rx_datapath_in_3] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_3]
  connect_bd_net -net gt_reset_rx_datapath_in_4_1 [get_bd_ports gt_reset_rx_datapath_in_4] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_4]
  connect_bd_net -net gt_reset_rx_datapath_in_5_1 [get_bd_ports gt_reset_rx_datapath_in_5] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_5]
  connect_bd_net -net gt_reset_rx_datapath_in_6_1 [get_bd_ports gt_reset_rx_datapath_in_6] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_6]
  connect_bd_net -net gt_reset_rx_datapath_in_7_1 [get_bd_ports gt_reset_rx_datapath_in_7] [get_bd_pins dcmac_0_core/gt_reset_rx_datapath_in_7]
  connect_bd_net -net gt_reset_tx_datapath_in_0_1 [get_bd_ports gt_reset_tx_datapath_in_0] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_0]
  connect_bd_net -net gt_reset_tx_datapath_in_1_1 [get_bd_ports gt_reset_tx_datapath_in_1] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_1]
  connect_bd_net -net gt_reset_tx_datapath_in_2_1 [get_bd_ports gt_reset_tx_datapath_in_2] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_2]
  connect_bd_net -net gt_reset_tx_datapath_in_3_1 [get_bd_ports gt_reset_tx_datapath_in_3] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_3]
  connect_bd_net -net gt_reset_tx_datapath_in_4_1 [get_bd_ports gt_reset_tx_datapath_in_4] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_4]
  connect_bd_net -net gt_reset_tx_datapath_in_5_1 [get_bd_ports gt_reset_tx_datapath_in_5] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_5]
  connect_bd_net -net gt_reset_tx_datapath_in_6_1 [get_bd_ports gt_reset_tx_datapath_in_6] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_6]
  connect_bd_net -net gt_reset_tx_datapath_in_7_1 [get_bd_ports gt_reset_tx_datapath_in_7] [get_bd_pins dcmac_0_core/gt_reset_tx_datapath_in_7]
  connect_bd_net -net gt_rxcdrhold_1 [get_bd_ports gt_rxcdrhold] [get_bd_pins dcmac_0_gt_wrapper/gt_rxcdrhold]
  connect_bd_net -net gt_txmaincursor_1 [get_bd_ports gt_txmaincursor] [get_bd_pins dcmac_0_gt_wrapper/gt_txmaincursor]
  connect_bd_net -net gt_txpostcursor_1 [get_bd_ports gt_txpostcursor] [get_bd_pins dcmac_0_gt_wrapper/gt_txpostcursor]
  connect_bd_net -net gt_txprecursor_1 [get_bd_ports gt_txprecursor] [get_bd_pins dcmac_0_gt_wrapper/gt_txprecursor]
  connect_bd_net -net gtpowergood_in_1 [get_bd_ports gtpowergood_in] [get_bd_pins dcmac_0_core/gtpowergood_in]
  connect_bd_net -net rsvd_in_rx_mac_1 [get_bd_ports rsvd_in_rx_mac] [get_bd_pins dcmac_0_core/rsvd_in_rx_mac]
  connect_bd_net -net rsvd_in_rx_phy_1 [get_bd_ports rsvd_in_rx_phy] [get_bd_pins dcmac_0_core/rsvd_in_rx_phy]
  connect_bd_net -net rx_all_channel_mac_pm_tick_1 [get_bd_ports rx_all_channel_mac_pm_tick] [get_bd_pins dcmac_0_core/rx_all_channel_mac_pm_tick]
  connect_bd_net -net rx_alt_serdes_clk_1 [get_bd_ports rx_alt_serdes_clk] [get_bd_pins dcmac_0_core/rx_alt_serdes_clk]
  connect_bd_net -net rx_axi_clk_1 [get_bd_ports rx_axi_clk] [get_bd_pins dcmac_0_core/rx_axi_clk]
  connect_bd_net -net rx_channel_flush_1 [get_bd_ports rx_channel_flush] [get_bd_pins dcmac_0_core/rx_channel_flush]
  connect_bd_net -net rx_core_clk_1 [get_bd_ports rx_core_clk] [get_bd_pins dcmac_0_core/rx_core_clk]
  connect_bd_net -net rx_core_reset_1 [get_bd_ports rx_core_reset] [get_bd_pins dcmac_0_core/rx_core_reset]
  connect_bd_net -net rx_flexif_clk_1 [get_bd_ports rx_flexif_clk] [get_bd_pins dcmac_0_core/rx_flexif_clk]
  connect_bd_net -net rx_macif_clk_1 [get_bd_ports rx_macif_clk] [get_bd_pins dcmac_0_core/rx_macif_clk]
  connect_bd_net -net rx_port_pm_tick_1 [get_bd_ports rx_port_pm_tick] [get_bd_pins dcmac_0_core/rx_port_pm_tick]
  connect_bd_net -net rx_serdes_clk_1 [get_bd_ports rx_serdes_clk] [get_bd_pins dcmac_0_core/rx_serdes_clk]
  connect_bd_net -net rx_serdes_fifo_flagin_0_1 [get_bd_ports rx_serdes_fifo_flagin_0] [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagin_0]
  connect_bd_net -net rx_serdes_fifo_flagin_1_1 [get_bd_ports rx_serdes_fifo_flagin_1] [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagin_1]
  connect_bd_net -net rx_serdes_fifo_flagin_2_1 [get_bd_ports rx_serdes_fifo_flagin_2] [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagin_2]
  connect_bd_net -net rx_serdes_fifo_flagin_3_1 [get_bd_ports rx_serdes_fifo_flagin_3] [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagin_3]
  connect_bd_net -net rx_serdes_fifo_flagin_4_1 [get_bd_ports rx_serdes_fifo_flagin_4] [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagin_4]
  connect_bd_net -net rx_serdes_fifo_flagin_5_1 [get_bd_ports rx_serdes_fifo_flagin_5] [get_bd_pins dcmac_0_core/rx_serdes_fifo_flagin_5]
  connect_bd_net -net rx_serdes_reset_1 [get_bd_ports rx_serdes_reset] [get_bd_pins dcmac_0_core/rx_serdes_reset]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins dcmac_0_core/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_ports s_axi_aresetn] [get_bd_pins dcmac_0_core/s_axi_aresetn] [get_bd_pins dcmac_0_gt_wrapper/s_axi_aresetn]
  connect_bd_net -net ts_clk_1 [get_bd_ports ts_clk] [get_bd_pins dcmac_0_core/ts_clk]
  connect_bd_net -net tx_all_channel_mac_pm_tick_1 [get_bd_ports tx_all_channel_mac_pm_tick] [get_bd_pins dcmac_0_core/tx_all_channel_mac_pm_tick]
  connect_bd_net -net tx_alt_serdes_clk_1 [get_bd_ports tx_alt_serdes_clk] [get_bd_pins dcmac_0_core/tx_alt_serdes_clk]
  connect_bd_net -net tx_axi_clk_1 [get_bd_ports tx_axi_clk] [get_bd_pins dcmac_0_core/tx_axi_clk]
  connect_bd_net -net tx_axis_tdata0_1 [get_bd_ports tx_axis_tdata0] [get_bd_pins dcmac_0_core/tx_axis_tdata0]
  connect_bd_net -net tx_axis_tdata10_1 [get_bd_ports tx_axis_tdata10] [get_bd_pins dcmac_0_core/tx_axis_tdata10]
  connect_bd_net -net tx_axis_tdata11_1 [get_bd_ports tx_axis_tdata11] [get_bd_pins dcmac_0_core/tx_axis_tdata11]
  connect_bd_net -net tx_axis_tdata1_1 [get_bd_ports tx_axis_tdata1] [get_bd_pins dcmac_0_core/tx_axis_tdata1]
  connect_bd_net -net tx_axis_tdata2_1 [get_bd_ports tx_axis_tdata2] [get_bd_pins dcmac_0_core/tx_axis_tdata2]
  connect_bd_net -net tx_axis_tdata3_1 [get_bd_ports tx_axis_tdata3] [get_bd_pins dcmac_0_core/tx_axis_tdata3]
  connect_bd_net -net tx_axis_tdata4_1 [get_bd_ports tx_axis_tdata4] [get_bd_pins dcmac_0_core/tx_axis_tdata4]
  connect_bd_net -net tx_axis_tdata5_1 [get_bd_ports tx_axis_tdata5] [get_bd_pins dcmac_0_core/tx_axis_tdata5]
  connect_bd_net -net tx_axis_tdata6_1 [get_bd_ports tx_axis_tdata6] [get_bd_pins dcmac_0_core/tx_axis_tdata6]
  connect_bd_net -net tx_axis_tdata7_1 [get_bd_ports tx_axis_tdata7] [get_bd_pins dcmac_0_core/tx_axis_tdata7]
  connect_bd_net -net tx_axis_tdata8_1 [get_bd_ports tx_axis_tdata8] [get_bd_pins dcmac_0_core/tx_axis_tdata8]
  connect_bd_net -net tx_axis_tdata9_1 [get_bd_ports tx_axis_tdata9] [get_bd_pins dcmac_0_core/tx_axis_tdata9]
  connect_bd_net -net tx_axis_tid_1 [get_bd_ports tx_axis_tid] [get_bd_pins dcmac_0_core/tx_axis_tid]
  connect_bd_net -net tx_axis_tuser_ena0_1 [get_bd_ports tx_axis_tuser_ena0] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena0]
  connect_bd_net -net tx_axis_tuser_ena10_1 [get_bd_ports tx_axis_tuser_ena10] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena10]
  connect_bd_net -net tx_axis_tuser_ena11_1 [get_bd_ports tx_axis_tuser_ena11] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena11]
  connect_bd_net -net tx_axis_tuser_ena1_1 [get_bd_ports tx_axis_tuser_ena1] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena1]
  connect_bd_net -net tx_axis_tuser_ena2_1 [get_bd_ports tx_axis_tuser_ena2] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena2]
  connect_bd_net -net tx_axis_tuser_ena3_1 [get_bd_ports tx_axis_tuser_ena3] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena3]
  connect_bd_net -net tx_axis_tuser_ena4_1 [get_bd_ports tx_axis_tuser_ena4] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena4]
  connect_bd_net -net tx_axis_tuser_ena5_1 [get_bd_ports tx_axis_tuser_ena5] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena5]
  connect_bd_net -net tx_axis_tuser_ena6_1 [get_bd_ports tx_axis_tuser_ena6] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena6]
  connect_bd_net -net tx_axis_tuser_ena7_1 [get_bd_ports tx_axis_tuser_ena7] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena7]
  connect_bd_net -net tx_axis_tuser_ena8_1 [get_bd_ports tx_axis_tuser_ena8] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena8]
  connect_bd_net -net tx_axis_tuser_ena9_1 [get_bd_ports tx_axis_tuser_ena9] [get_bd_pins dcmac_0_core/tx_axis_tuser_ena9]
  connect_bd_net -net tx_axis_tuser_eop0_1 [get_bd_ports tx_axis_tuser_eop0] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop0]
  connect_bd_net -net tx_axis_tuser_eop10_1 [get_bd_ports tx_axis_tuser_eop10] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop10]
  connect_bd_net -net tx_axis_tuser_eop11_1 [get_bd_ports tx_axis_tuser_eop11] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop11]
  connect_bd_net -net tx_axis_tuser_eop1_1 [get_bd_ports tx_axis_tuser_eop1] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop1]
  connect_bd_net -net tx_axis_tuser_eop2_1 [get_bd_ports tx_axis_tuser_eop2] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop2]
  connect_bd_net -net tx_axis_tuser_eop3_1 [get_bd_ports tx_axis_tuser_eop3] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop3]
  connect_bd_net -net tx_axis_tuser_eop4_1 [get_bd_ports tx_axis_tuser_eop4] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop4]
  connect_bd_net -net tx_axis_tuser_eop5_1 [get_bd_ports tx_axis_tuser_eop5] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop5]
  connect_bd_net -net tx_axis_tuser_eop6_1 [get_bd_ports tx_axis_tuser_eop6] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop6]
  connect_bd_net -net tx_axis_tuser_eop7_1 [get_bd_ports tx_axis_tuser_eop7] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop7]
  connect_bd_net -net tx_axis_tuser_eop8_1 [get_bd_ports tx_axis_tuser_eop8] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop8]
  connect_bd_net -net tx_axis_tuser_eop9_1 [get_bd_ports tx_axis_tuser_eop9] [get_bd_pins dcmac_0_core/tx_axis_tuser_eop9]
  connect_bd_net -net tx_axis_tuser_err0_1 [get_bd_ports tx_axis_tuser_err0] [get_bd_pins dcmac_0_core/tx_axis_tuser_err0]
  connect_bd_net -net tx_axis_tuser_err10_1 [get_bd_ports tx_axis_tuser_err10] [get_bd_pins dcmac_0_core/tx_axis_tuser_err10]
  connect_bd_net -net tx_axis_tuser_err11_1 [get_bd_ports tx_axis_tuser_err11] [get_bd_pins dcmac_0_core/tx_axis_tuser_err11]
  connect_bd_net -net tx_axis_tuser_err1_1 [get_bd_ports tx_axis_tuser_err1] [get_bd_pins dcmac_0_core/tx_axis_tuser_err1]
  connect_bd_net -net tx_axis_tuser_err2_1 [get_bd_ports tx_axis_tuser_err2] [get_bd_pins dcmac_0_core/tx_axis_tuser_err2]
  connect_bd_net -net tx_axis_tuser_err3_1 [get_bd_ports tx_axis_tuser_err3] [get_bd_pins dcmac_0_core/tx_axis_tuser_err3]
  connect_bd_net -net tx_axis_tuser_err4_1 [get_bd_ports tx_axis_tuser_err4] [get_bd_pins dcmac_0_core/tx_axis_tuser_err4]
  connect_bd_net -net tx_axis_tuser_err5_1 [get_bd_ports tx_axis_tuser_err5] [get_bd_pins dcmac_0_core/tx_axis_tuser_err5]
  connect_bd_net -net tx_axis_tuser_err6_1 [get_bd_ports tx_axis_tuser_err6] [get_bd_pins dcmac_0_core/tx_axis_tuser_err6]
  connect_bd_net -net tx_axis_tuser_err7_1 [get_bd_ports tx_axis_tuser_err7] [get_bd_pins dcmac_0_core/tx_axis_tuser_err7]
  connect_bd_net -net tx_axis_tuser_err8_1 [get_bd_ports tx_axis_tuser_err8] [get_bd_pins dcmac_0_core/tx_axis_tuser_err8]
  connect_bd_net -net tx_axis_tuser_err9_1 [get_bd_ports tx_axis_tuser_err9] [get_bd_pins dcmac_0_core/tx_axis_tuser_err9]
  connect_bd_net -net tx_axis_tuser_mty0_1 [get_bd_ports tx_axis_tuser_mty0] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty0]
  connect_bd_net -net tx_axis_tuser_mty10_1 [get_bd_ports tx_axis_tuser_mty10] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty10]
  connect_bd_net -net tx_axis_tuser_mty11_1 [get_bd_ports tx_axis_tuser_mty11] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty11]
  connect_bd_net -net tx_axis_tuser_mty1_1 [get_bd_ports tx_axis_tuser_mty1] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty1]
  connect_bd_net -net tx_axis_tuser_mty2_1 [get_bd_ports tx_axis_tuser_mty2] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty2]
  connect_bd_net -net tx_axis_tuser_mty3_1 [get_bd_ports tx_axis_tuser_mty3] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty3]
  connect_bd_net -net tx_axis_tuser_mty4_1 [get_bd_ports tx_axis_tuser_mty4] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty4]
  connect_bd_net -net tx_axis_tuser_mty5_1 [get_bd_ports tx_axis_tuser_mty5] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty5]
  connect_bd_net -net tx_axis_tuser_mty6_1 [get_bd_ports tx_axis_tuser_mty6] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty6]
  connect_bd_net -net tx_axis_tuser_mty7_1 [get_bd_ports tx_axis_tuser_mty7] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty7]
  connect_bd_net -net tx_axis_tuser_mty8_1 [get_bd_ports tx_axis_tuser_mty8] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty8]
  connect_bd_net -net tx_axis_tuser_mty9_1 [get_bd_ports tx_axis_tuser_mty9] [get_bd_pins dcmac_0_core/tx_axis_tuser_mty9]
  connect_bd_net -net tx_axis_tuser_skip_response_1 [get_bd_ports tx_axis_tuser_skip_response] [get_bd_pins dcmac_0_core/tx_axis_tuser_skip_response]
  connect_bd_net -net tx_axis_tuser_sop0_1 [get_bd_ports tx_axis_tuser_sop0] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop0]
  connect_bd_net -net tx_axis_tuser_sop10_1 [get_bd_ports tx_axis_tuser_sop10] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop10]
  connect_bd_net -net tx_axis_tuser_sop11_1 [get_bd_ports tx_axis_tuser_sop11] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop11]
  connect_bd_net -net tx_axis_tuser_sop1_1 [get_bd_ports tx_axis_tuser_sop1] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop1]
  connect_bd_net -net tx_axis_tuser_sop2_1 [get_bd_ports tx_axis_tuser_sop2] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop2]
  connect_bd_net -net tx_axis_tuser_sop3_1 [get_bd_ports tx_axis_tuser_sop3] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop3]
  connect_bd_net -net tx_axis_tuser_sop4_1 [get_bd_ports tx_axis_tuser_sop4] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop4]
  connect_bd_net -net tx_axis_tuser_sop5_1 [get_bd_ports tx_axis_tuser_sop5] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop5]
  connect_bd_net -net tx_axis_tuser_sop6_1 [get_bd_ports tx_axis_tuser_sop6] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop6]
  connect_bd_net -net tx_axis_tuser_sop7_1 [get_bd_ports tx_axis_tuser_sop7] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop7]
  connect_bd_net -net tx_axis_tuser_sop8_1 [get_bd_ports tx_axis_tuser_sop8] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop8]
  connect_bd_net -net tx_axis_tuser_sop9_1 [get_bd_ports tx_axis_tuser_sop9] [get_bd_pins dcmac_0_core/tx_axis_tuser_sop9]
  connect_bd_net -net tx_axis_tvalid_0_1 [get_bd_ports tx_axis_tvalid_0] [get_bd_pins dcmac_0_core/tx_axis_tvalid_0]
  connect_bd_net -net tx_axis_tvalid_1_1 [get_bd_ports tx_axis_tvalid_1] [get_bd_pins dcmac_0_core/tx_axis_tvalid_1]
  connect_bd_net -net tx_axis_tvalid_2_1 [get_bd_ports tx_axis_tvalid_2] [get_bd_pins dcmac_0_core/tx_axis_tvalid_2]
  connect_bd_net -net tx_axis_tvalid_3_1 [get_bd_ports tx_axis_tvalid_3] [get_bd_pins dcmac_0_core/tx_axis_tvalid_3]
  connect_bd_net -net tx_axis_tvalid_4_1 [get_bd_ports tx_axis_tvalid_4] [get_bd_pins dcmac_0_core/tx_axis_tvalid_4]
  connect_bd_net -net tx_axis_tvalid_5_1 [get_bd_ports tx_axis_tvalid_5] [get_bd_pins dcmac_0_core/tx_axis_tvalid_5]
  connect_bd_net -net tx_channel_flush_1 [get_bd_ports tx_channel_flush] [get_bd_pins dcmac_0_core/tx_channel_flush]
  connect_bd_net -net tx_core_clk_1 [get_bd_ports tx_core_clk] [get_bd_pins dcmac_0_core/tx_core_clk]
  connect_bd_net -net tx_core_reset_1 [get_bd_ports tx_core_reset] [get_bd_pins dcmac_0_core/tx_core_reset]
  connect_bd_net -net tx_flexif_clk_1 [get_bd_ports tx_flexif_clk] [get_bd_pins dcmac_0_core/tx_flexif_clk]
  connect_bd_net -net tx_macif_clk_1 [get_bd_ports tx_macif_clk] [get_bd_pins dcmac_0_core/tx_macif_clk]
  connect_bd_net -net tx_port_pm_tick_1 [get_bd_ports tx_port_pm_tick] [get_bd_pins dcmac_0_core/tx_port_pm_tick]
  connect_bd_net -net tx_preamblein_0_1 [get_bd_ports tx_preamblein_0] [get_bd_pins dcmac_0_core/tx_preamblein_0]
  connect_bd_net -net tx_preamblein_1_1 [get_bd_ports tx_preamblein_1] [get_bd_pins dcmac_0_core/tx_preamblein_1]
  connect_bd_net -net tx_preamblein_2_1 [get_bd_ports tx_preamblein_2] [get_bd_pins dcmac_0_core/tx_preamblein_2]
  connect_bd_net -net tx_preamblein_3_1 [get_bd_ports tx_preamblein_3] [get_bd_pins dcmac_0_core/tx_preamblein_3]
  connect_bd_net -net tx_preamblein_4_1 [get_bd_ports tx_preamblein_4] [get_bd_pins dcmac_0_core/tx_preamblein_4]
  connect_bd_net -net tx_preamblein_5_1 [get_bd_ports tx_preamblein_5] [get_bd_pins dcmac_0_core/tx_preamblein_5]
  connect_bd_net -net tx_serdes_clk_1 [get_bd_ports tx_serdes_clk] [get_bd_pins dcmac_0_core/tx_serdes_clk]
  connect_bd_net -net tx_serdes_reset_1 [get_bd_ports tx_serdes_reset] [get_bd_pins dcmac_0_core/tx_serdes_reset]
  connect_bd_net -net util_ds_buf_mbufg_rx_0_MBUFG_GT_O1 [get_bd_pins dcmac_0_gt_wrapper/ch0_rx_usr_clk_0] [get_bd_ports ch0_rx_usr_clk_0]
  connect_bd_net -net util_ds_buf_mbufg_rx_0_MBUFG_GT_O2 [get_bd_pins dcmac_0_gt_wrapper/ch0_rx_usr_clk2_0] [get_bd_ports ch0_rx_usr_clk2_0]
  connect_bd_net -net util_ds_buf_mbufg_tx_0_MBUFG_GT_O1 [get_bd_pins dcmac_0_gt_wrapper/ch0_tx_usr_clk_0] [get_bd_ports ch0_tx_usr_clk_0]
  connect_bd_net -net util_ds_buf_mbufg_tx_0_MBUFG_GT_O2 [get_bd_pins dcmac_0_gt_wrapper/ch0_tx_usr_clk2_0] [get_bd_ports ch0_tx_usr_clk2_0]

  # Create address segments
  assign_bd_address -offset 0xA4000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces s_axi] [get_bd_addr_segs dcmac_0_core/s_axi/Reg] -force


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


