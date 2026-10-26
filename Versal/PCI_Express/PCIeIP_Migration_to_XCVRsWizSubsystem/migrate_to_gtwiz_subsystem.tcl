##-----------------------------------------------------------------------------
##
## Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
## SPDX-License-Identifier: MIT
##
##--------------------------------------------------------------------------------------
## Summary:
##   The Versal Adaptive SoC Transceivers Wizard IP, which is quad-based,
##   is used in the block design-based IP Integrator (IPI) flow. The new Versal 
##   Adaptive SoC Transceivers Wizard *Subsystem* IP is suitable for use in 
##   both IPI and RTL design flows and should be used moving forward for 
##   new designs.  This script provides assistance with migrating existing IPI 
##   designs to use the new Versal Adaptive SoC Transceivers Wizard 
##   *Subsystem* IP. The script imports the required properties and 
##   establishes the necessary connections to PCI Express peer parent IP 
##   cores. For more details on the usage of this script, please visit 
##   https://adaptivesupport.amd.com/s/article/000037037?language=en_US
##--------------------------------------------------------------------------------------
## Usage details:
##   auto mode:
##     Supports only one instance of pcie_phy IP in the BD. 
##     Run below cmd in tcl console of vivado to use auto mode 
##     step 1: source migrate_to_gtwiz_subsystem.tcl 
##     step 2: migrate_to_gtwiz_subsystem auto
##
##   manual mode:
##     This mode should be used in the BD which has one or more 
##     instances of pcie_phy IP.
##     Run below cmd in tcl console of vivado to use manual mode 
##     step 1: source migrate_to_gtwiz_subsystem.tcl 
##     step 2: migrate_to_gtwiz_subsystem manual <pcie_phy_cell_path>
##       example: migrate_to_gtwiz_subsystem manual /xdma_0_support/pcie_phy
##
##--------------------------------------------------------------------------------------
##


proc migrate_to_gtwiz_subsystem {args} {

  #INFO:  manual or auto mode selection
  set mode [lindex $args 0]  
  if { $mode eq "manual" } {  
      puts "Mode: $mode"  
      set phy_cell  [get_bd_cells [lindex $args 1] ] 
      puts "PCIe_PHY cell path: $phy_cell"
  } elseif { $mode eq "auto" } {  
      puts "Mode: $mode"  
      set phy_cell [get_bd_cells -hierarchical -filter {NAME=~"*phy*"}]
      puts "PCIe_PHY cell path: $phy_cell"
  } else {
      puts "NOT an expected command. Try  \"migrate_to_gtwiz_subsystem auto or migrate_to_gtwiz_subsystem manual pcie_phy_cell_path \""  
      return
  }
  
  #INFO:  getting list of gt_quad cells connected to respective pcie_phy ip 
  set phy_gt_cell_list [get_bd_cells -of_objects [get_bd_pins -of [get_bd_nets -of [get_bd_pins $phy_cell/gt_pcieltssm]]]]
  set index [lsearch $phy_gt_cell_list $phy_cell]  
  if {$index >= 0} {  
      set gt_cell_list [lreplace $phy_gt_cell_list $index $index]  
  } 
 
  set gt_quad_path [lindex $gt_cell_list 0]
  set const_out    [lindex [get_bd_pins -of [get_bd_nets -of [get_bd_pins $gt_quad_path/apb3clk]]] 0 ]

  #INFO:  create_bd_cell gtwiz_versal_0  
  set gtwiz_path     [string range $gt_quad_path 0 [string last "/" $gt_quad_path ]]
  set gtwiz_versal_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:gtwiz_versal:1.0 $gtwiz_path/gtwiz_versal_0 ]
  connect_bd_net     [get_bd_pins $gtwiz_versal_0/gtwiz_freerun_clk] [get_bd_pins $const_out]

  #INFO:  delete gt_quad cells in BD
  delete_bd_objs $gt_cell_list
  
  #INFO:  choosing gtwizard subsystem in pcie_phy ip
  set_property CONFIG.enable_gtwizard true  $phy_cell
  #NOTE:  If design has pcie_versal, xdma, qdma IPs, the user should choose gtwiz subsystem in the respective GUI.

  #INFO:  property query on pcie_phy ip
  set lane_reversal false
  set lane_order Bottom
  if { [list_property $phy_cell CONFIG.lane_reversal] != "" } {
    set lane_reversal [get_property CONFIG.lane_reversal $phy_cell]
  }
  if { [list_property $phy_cell CONFIG.lane_order] != "" } {
    set lane_order [get_property CONFIG.lane_order $phy_cell]
  }
  
  set link_width_int [string range [get_property CONFIG.pl_link_cap_max_link_width $phy_cell] 1 end]
  set no_of_gt_quads [expr ($link_width_int+3)/4]
  
  set sim_model_int  [get_property CONFIG.sim_model $phy_cell]
  if { $sim_model_int == "YES" } {
    set_property CONFIG.PCIE_NO_OF_QUADS_BYPASS {true} $gtwiz_versal_0
  }
  
  #INFO:  configuring gtwiz_versal cell to make it compatible with pcie_phy ip
  set_property CONFIG.GT_TYPE  [get_property CONFIG.GT_SETTINGS(GT_TYPE) $phy_cell] $gtwiz_versal_0
  set mstclk  0
  
  if {$link_width_int == "1" } {
     if {$lane_order == "Top" } {
     set_property -dict [list \
       CONFIG.INTF0_NO_OF_LANES {1} \
       CONFIG.QUAD0_PROT0_LANES {1} \
       CONFIG.QUAD0_PROT0_RX0_EN {false} \
       CONFIG.QUAD0_PROT0_RX1_EN {false} \
       CONFIG.QUAD0_PROT0_RX2_EN {false} \
       CONFIG.QUAD0_PROT0_RX3_EN {true} \
       CONFIG.QUAD0_PROT0_TX0_EN {false} \
       CONFIG.QUAD0_PROT0_TX1_EN {false} \
       CONFIG.QUAD0_PROT0_TX2_EN {false} \
       CONFIG.QUAD0_PROT0_TX3_EN {true} \
       CONFIG.QUAD0_PROT0_TXMSTCLK {TX3} \
       CONFIG.QUAD0_PROT0_RXMSTCLK {RX3} \
     ] $gtwiz_versal_0
     set mstclk 3
     } else {
     set_property -dict [list \
       CONFIG.INTF0_NO_OF_LANES {1} \
       CONFIG.QUAD0_PROT0_LANES {1} \
       CONFIG.QUAD0_PROT0_RX1_EN {false} \
       CONFIG.QUAD0_PROT0_RX2_EN {false} \
       CONFIG.QUAD0_PROT0_RX3_EN {false} \
       CONFIG.QUAD0_PROT0_TX1_EN {false} \
       CONFIG.QUAD0_PROT0_TX2_EN {false} \
       CONFIG.QUAD0_PROT0_TX3_EN {false} \
       CONFIG.QUAD0_PROT0_TXMSTCLK {TX0} \
       CONFIG.QUAD0_PROT0_RXMSTCLK {RX0} \
     ] $gtwiz_versal_0
     set mstclk  0
     }
  } elseif {$link_width_int == "2" } {
     if {$lane_order == "Top" } {
     set_property -dict [list \
       CONFIG.INTF0_NO_OF_LANES {2} \
       CONFIG.QUAD0_PROT0_LANES {2} \
       CONFIG.QUAD0_PROT0_RX0_EN {false} \
       CONFIG.QUAD0_PROT0_RX1_EN {false} \
       CONFIG.QUAD0_PROT0_TX0_EN {false} \
       CONFIG.QUAD0_PROT0_TX1_EN {false} \
       CONFIG.QUAD0_PROT0_RX2_EN {true} \
       CONFIG.QUAD0_PROT0_RX3_EN {true} \
       CONFIG.QUAD0_PROT0_TX2_EN {true} \
       CONFIG.QUAD0_PROT0_TX3_EN {true} \
       CONFIG.QUAD0_PROT0_TXMSTCLK {TX3} \
       CONFIG.QUAD0_PROT0_RXMSTCLK {RX3} \
     ] $gtwiz_versal_0
     set mstclk  3
     } else {
     set_property -dict [list \
       CONFIG.INTF0_NO_OF_LANES {2} \
       CONFIG.QUAD0_PROT0_LANES {2} \
       CONFIG.QUAD0_PROT0_RX0_EN {true} \
       CONFIG.QUAD0_PROT0_RX1_EN {true} \
       CONFIG.QUAD0_PROT0_TX0_EN {true} \
       CONFIG.QUAD0_PROT0_TX1_EN {true} \
       CONFIG.QUAD0_PROT0_RX2_EN {false} \
       CONFIG.QUAD0_PROT0_RX3_EN {false} \
       CONFIG.QUAD0_PROT0_TX2_EN {false} \
       CONFIG.QUAD0_PROT0_TX3_EN {false} \
       CONFIG.QUAD0_PROT0_TXMSTCLK {TX0} \
       CONFIG.QUAD0_PROT0_RXMSTCLK {RX0} \
     ] $gtwiz_versal_0
     set mstclk  0
     }
  } elseif {$link_width_int == "8" } {
     set_property -dict [list CONFIG.INTF0_NO_OF_LANES ${link_width_int} CONFIG.NO_OF_QUADS ${no_of_gt_quads} CONFIG.QUAD0_PROT0_LANES {4} CONFIG.QUAD1_PROT0_LANES {4} ] $gtwiz_versal_0
  } elseif {$link_width_int == "16" } {
     set_property -dict [list CONFIG.INTF0_NO_OF_LANES ${link_width_int} CONFIG.NO_OF_QUADS ${no_of_gt_quads} CONFIG.QUAD0_PROT0_LANES {4} CONFIG.QUAD1_PROT0_LANES {4} CONFIG.QUAD2_PROT0_LANES {4} CONFIG.QUAD3_PROT0_LANES {4}] $gtwiz_versal_0
  }
  set_property CONFIG.INTF0_PCIE_ENABLE {true} $gtwiz_versal_0
  
  
  #INFO:  connecting ports/interfaces b/w gtwiz_versal and pcie_phy ip
  if {$lane_order == "Top" } {
    set gt_lane_end   [expr $no_of_gt_quads * 4 - 1]
    set gt_lane_start [expr $no_of_gt_quads * 4 - $link_width_int]
  } else {
    set gt_lane_start 0
    set gt_lane_end   [expr $link_width_int-1]
  }
  if {$lane_reversal} {
    set temp $gt_lane_end
    set gt_lane_end $gt_lane_start
    set gt_lane_start $temp
  }
  set clk_src_quad [expr $gt_lane_start / 4]
  set clk_src_lane [expr $gt_lane_start % 4]
  set gt_lane $gt_lane_start
  for {set i 0} {$i < $link_width_int} {incr i} {
    set quad [expr $gt_lane / 4]
    set lane [expr $gt_lane % 4]
    connect_bd_net  [get_bd_pins $gtwiz_versal_0/QUAD${quad}_ch${lane}_phyready]  [get_bd_pins $phy_cell/ch${i}_phyready]
    connect_bd_net  [get_bd_pins $gtwiz_versal_0/QUAD${quad}_ch${lane}_phystatus] [get_bd_pins $phy_cell/ch${i}_phystatus]
    connect_bd_intf_net [get_bd_intf_pins $phy_cell/GT_RX$i] [get_bd_intf_pins $gtwiz_versal_0/INTF0_RX${i}_GT_IP_Interface]
    connect_bd_intf_net [get_bd_intf_pins $phy_cell/GT_TX$i] [get_bd_intf_pins $gtwiz_versal_0/INTF0_TX${i}_GT_IP_Interface]
    connect_bd_net  [get_bd_pins $phy_cell/pcierstb] [get_bd_pins $gtwiz_versal_0/QUAD${quad}_ch${lane}_pcierstb]
    connect_bd_net  [get_bd_pins $phy_cell/phy_pclk] [get_bd_pins $gtwiz_versal_0/QUAD${quad}_TX${lane}_usrclk] [get_bd_pins $gtwiz_versal_0/QUAD${quad}_RX${lane}_usrclk]
    incr gt_lane [expr $lane_reversal ? -1 : 1]
  }
  for {set quad 0} {$quad < $no_of_gt_quads} {incr quad} {
    connect_bd_intf_net [get_bd_intf_pins $phy_cell/GT${quad}_Serial]     [get_bd_intf_pins $gtwiz_versal_0/Quad${quad}_GT_Serial ]
    connect_bd_intf_net [get_bd_intf_pins $phy_cell/gt_rxmargin_q${quad}] [get_bd_intf_pins $gtwiz_versal_0/QUAD${quad}_GT_RXMARGIN_INTF]
    connect_bd_net      [get_bd_pins $phy_cell/gtrefclk]     [get_bd_pins $gtwiz_versal_0/QUAD${quad}_GTREFCLK0]
    connect_bd_net      [get_bd_pins $phy_cell/gt_pcieltssm] [get_bd_pins $gtwiz_versal_0/QUAD${quad}_pcieltssm]
  }
  connect_bd_intf_net [get_bd_intf_pins $phy_cell/GT_BUFGT] [get_bd_intf_pins $gtwiz_versal_0/Quad${clk_src_quad}_GT${clk_src_lane}_BUFGT]
  connect_bd_net      [get_bd_pins $gtwiz_versal_0/QUAD${clk_src_quad}_TX${mstclk}_outclk] [get_bd_pins $phy_cell/gt_txoutclk]
  connect_bd_net      [get_bd_pins $gtwiz_versal_0/QUAD${clk_src_quad}_RX${mstclk}_outclk] [get_bd_pins $phy_cell/gt_rxoutclk]
  
  #INFO:  importing LR settings from pcie_phy ip
  set_property   CONFIG.INTF0_GT_SETTINGS(GT_DIRECTION) [get_property CONFIG.GT_SETTINGS(GT_DIRECTION) $phy_cell]  [get_bd_cells $gtwiz_versal_0]
  set_property   CONFIG.INTF0_GT_SETTINGS(GT_TYPE)      [get_property CONFIG.GT_SETTINGS(GT_TYPE) $phy_cell]       [get_bd_cells $gtwiz_versal_0]
  set speed  [get_property CONFIG.PL_LINK_CAP_MAX_LINK_SPEED $phy_cell]
  set gen [expr { $speed eq "32.0_GT/s" ? 5 : ($speed eq "16.0_GT/s" ? 4 : ($speed eq "8.0_GT/s" ? 3 : ( $speed eq "5.0_GT/s" ? 2 : 1 )))}]
  for {set i 0} {$i < $gen} {incr i} {
    set_property   CONFIG.INTF0_GT_SETTINGS(LR${i}_SETTINGS) [get_property CONFIG.GT_SETTINGS(LR${i}_SETTINGS) $phy_cell]  [get_bd_cells $gtwiz_versal_0]
  }

  validate_bd_design
  save_bd_design
} 

