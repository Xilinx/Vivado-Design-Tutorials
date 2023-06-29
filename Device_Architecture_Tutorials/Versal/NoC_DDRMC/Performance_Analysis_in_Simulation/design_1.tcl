
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
set scripts_vivado_version 2022.2
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

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
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
xilinx.com:ip:axi_noc:1.0\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:clk_gen_sim:1.0\
xilinx.com:ip:sim_trig:1.0\
xilinx.com:ip:perf_axi_tg:1.0\
xilinx.com:ip:axi_pmon:1.0\
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
  set ddr4_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_0 ]

  set ddr4_rtl_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_1 ]

  set ddr4_rtl_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_2 ]

  set ddr4_rtl_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_rtl_3 ]

  set diff_clock_rtl_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $diff_clock_rtl_0

  set diff_clock_rtl_1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl_1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $diff_clock_rtl_1

  set diff_clock_rtl_2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl_2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $diff_clock_rtl_2

  set diff_clock_rtl_3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl_3 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $diff_clock_rtl_3


  # Create ports
  set clk_100MHz [ create_bd_port -dir I -type clk -freq_hz 100000000 clk_100MHz ]
  set reset_rtl_0 [ create_bd_port -dir I -type rst reset_rtl_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CONTROLLERTYPE {DDR4_SDRAM} \
    CONFIG.MC_CHAN_REGION0 {DDR_CH1} \
    CONFIG.MC_EN_INTR_RESP {TRUE} \
    CONFIG.MC_F1_LPDDR4_MR1 {0x0000} \
    CONFIG.MC_F1_LPDDR4_MR2 {0x0000} \
    CONFIG.MC_INPUTCLK0_PERIOD {5000} \
    CONFIG.MC_INTERLEAVE_SIZE {256} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {USER_DEFINED_ADDRESS_MAP} \
    CONFIG.MC_USER_DEFINED_ADDRESS_MAP {2RA-2BA-2BG-14RA-10CA} \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MC {4} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {6} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X1Y0} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {8000} write_bw {8000} read_avg_burst {100} write_avg_burst {100}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X2Y0} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {8000} write_bw {8000} read_avg_burst {100} write_avg_burst {100}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X1Y1} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {8000} write_bw {8000} read_avg_burst {100} write_avg_burst {100}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X2Y1} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {8000} write_bw {8000} read_avg_burst {100} write_avg_burst {100}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X3Y1} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {8000} write_bw {8000} read_avg_burst {100} write_avg_burst {100}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.PHYSICAL_LOC {NOC_NMU512_X3Y0} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {8000} write_bw {8000} read_avg_burst {100} write_avg_burst {100}} } \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI:S03_AXI:S04_AXI:S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wiz ]
  set_property -dict [list \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_RESET {true} \
  ] $clk_wiz


  # Create instance: noc_clk_gen, and set properties
  set noc_clk_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen_sim:1.0 noc_clk_gen ]
  set_property -dict [list \
    CONFIG.USER_AXI_CLK_0_FREQ {250.000} \
    CONFIG.USER_NUM_OF_SYS_CLK {4} \
    CONFIG.USER_SYS_CLK0_FREQ {200.000} \
    CONFIG.USER_SYS_CLK1_FREQ {200.000} \
    CONFIG.USER_SYS_CLK2_FREQ {200.000} \
    CONFIG.USER_SYS_CLK3_FREQ {200.000} \
  ] $noc_clk_gen


  # Create instance: noc_sim_trig, and set properties
  set noc_sim_trig [ create_bd_cell -type ip -vlnv xilinx.com:ip:sim_trig:1.0 noc_sim_trig ]
  set_property CONFIG.USER_NUM_AXI_TG {6} $noc_sim_trig


  # Create instance: noc_tg, and set properties
  set noc_tg [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 noc_tg ]
  set_property -dict [list \
    CONFIG.AXUSER_WIDTH_CSV {11} \
    CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_READ_SIZE {1} \
    CONFIG.USER_C_AXI_WDATA_VALUE { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_WRITE_SIZE {1} \
    CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
    CONFIG.USER_MEM_LINEAR_DATA_SEED { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {/home/tvura/Documents/tg0_num_m.csv} \
    CONFIG.USER_SYN_ID_WIDTH {16} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $noc_tg


  # Create instance: noc_tg_1, and set properties
  set noc_tg_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 noc_tg_1 ]
  set_property -dict [list \
    CONFIG.AXUSER_WIDTH_CSV {11} \
    CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_READ_SIZE {1} \
    CONFIG.USER_C_AXI_WDATA_VALUE { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_WRITE_SIZE {1} \
    CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
    CONFIG.USER_MEM_LINEAR_DATA_SEED { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {/home/tvura/Documents/tg1_num_m.csv} \
    CONFIG.USER_SYN_ID_WIDTH {16} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $noc_tg_1


  # Create instance: noc_tg_2, and set properties
  set noc_tg_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 noc_tg_2 ]
  set_property -dict [list \
    CONFIG.AXUSER_WIDTH_CSV {11} \
    CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_READ_SIZE {1} \
    CONFIG.USER_C_AXI_WDATA_VALUE { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_WRITE_SIZE {1} \
    CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
    CONFIG.USER_MEM_LINEAR_DATA_SEED { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {/home/tvura/Documents/tg2_num_m.csv} \
    CONFIG.USER_SYN_ID_WIDTH {16} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $noc_tg_2


  # Create instance: noc_tg_3, and set properties
  set noc_tg_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 noc_tg_3 ]
  set_property -dict [list \
    CONFIG.AXUSER_WIDTH_CSV {11} \
    CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_READ_SIZE {1} \
    CONFIG.USER_C_AXI_WDATA_VALUE { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_WRITE_SIZE {1} \
    CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
    CONFIG.USER_MEM_LINEAR_DATA_SEED { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {/home/tvura/Documents/tg3_num_m.csv} \
    CONFIG.USER_SYN_ID_WIDTH {16} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $noc_tg_3


  # Create instance: noc_tg_4, and set properties
  set noc_tg_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 noc_tg_4 ]
  set_property -dict [list \
    CONFIG.AXUSER_WIDTH_CSV {11} \
    CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_READ_SIZE {1} \
    CONFIG.USER_C_AXI_WDATA_VALUE { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_WRITE_SIZE {1} \
    CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
    CONFIG.USER_MEM_LINEAR_DATA_SEED { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {/home/tvura/Documents/tg4_num.csv} \
    CONFIG.USER_SYN_ID_WIDTH {16} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $noc_tg_4


  # Create instance: noc_tg_5, and set properties
  set noc_tg_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 noc_tg_5 ]
  set_property -dict [list \
    CONFIG.AXUSER_WIDTH_CSV {11} \
    CONFIG.USER_C_AXI_RDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_READ_SIZE {1} \
    CONFIG.USER_C_AXI_WDATA_VALUE { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_C_AXI_WDATA_WIDTH {512} \
    CONFIG.USER_C_AXI_WRITE_SIZE {1} \
    CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} \
    CONFIG.USER_MEM_LINEAR_DATA_SEED { 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000} \
    CONFIG.USER_PERF_TG {SYNTHESIZABLE} \
    CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {/home/tvura/Documents/tg5_num_m.csv} \
    CONFIG.USER_SYN_ID_WIDTH {16} \
    CONFIG.USER_TRAFFIC_SHAPING_EN {FALSE} \
  ] $noc_tg_5


  # Create instance: noc_tg_pmon, and set properties
  set noc_tg_pmon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pmon:1.0 noc_tg_pmon ]
  set_property CONFIG.USER_PARAM_AXI_TG_ID {0} $noc_tg_pmon


  # Create instance: noc_tg_pmon_1, and set properties
  set noc_tg_pmon_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pmon:1.0 noc_tg_pmon_1 ]
  set_property CONFIG.USER_PARAM_AXI_TG_ID {1} $noc_tg_pmon_1


  # Create instance: noc_tg_pmon_2, and set properties
  set noc_tg_pmon_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pmon:1.0 noc_tg_pmon_2 ]
  set_property CONFIG.USER_PARAM_AXI_TG_ID {2} $noc_tg_pmon_2


  # Create instance: noc_tg_pmon_3, and set properties
  set noc_tg_pmon_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pmon:1.0 noc_tg_pmon_3 ]
  set_property CONFIG.USER_PARAM_AXI_TG_ID {3} $noc_tg_pmon_3


  # Create instance: noc_tg_pmon_4, and set properties
  set noc_tg_pmon_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pmon:1.0 noc_tg_pmon_4 ]
  set_property CONFIG.USER_PARAM_AXI_TG_ID {4} $noc_tg_pmon_4


  # Create instance: noc_tg_pmon_5, and set properties
  set noc_tg_pmon_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pmon:1.0 noc_tg_pmon_5 ]
  set_property CONFIG.USER_PARAM_AXI_TG_ID {5} $noc_tg_pmon_5


  # Create instance: rst_clk_wiz_100M, and set properties
  set rst_clk_wiz_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_0 [get_bd_intf_ports ddr4_rtl_0] [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_1 [get_bd_intf_ports ddr4_rtl_1] [get_bd_intf_pins axi_noc_0/CH0_DDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_2 [get_bd_intf_ports ddr4_rtl_2] [get_bd_intf_pins axi_noc_0/CH0_DDR4_2]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_3 [get_bd_intf_ports ddr4_rtl_3] [get_bd_intf_pins axi_noc_0/CH0_DDR4_3]
  connect_bd_intf_net -intf_net diff_clock_rtl_0_1 [get_bd_intf_ports diff_clock_rtl_0] [get_bd_intf_pins noc_clk_gen/SYS_CLK0_IN]
  connect_bd_intf_net -intf_net diff_clock_rtl_1_1 [get_bd_intf_ports diff_clock_rtl_1] [get_bd_intf_pins noc_clk_gen/SYS_CLK1_IN]
  connect_bd_intf_net -intf_net diff_clock_rtl_2_1 [get_bd_intf_ports diff_clock_rtl_2] [get_bd_intf_pins noc_clk_gen/SYS_CLK2_IN]
  connect_bd_intf_net -intf_net diff_clock_rtl_3_1 [get_bd_intf_ports diff_clock_rtl_3] [get_bd_intf_pins noc_clk_gen/SYS_CLK3_IN]
  connect_bd_intf_net -intf_net noc_clk_gen_SYS_CLK0 [get_bd_intf_pins axi_noc_0/sys_clk0] [get_bd_intf_pins noc_clk_gen/SYS_CLK0]
  connect_bd_intf_net -intf_net noc_clk_gen_SYS_CLK1 [get_bd_intf_pins axi_noc_0/sys_clk1] [get_bd_intf_pins noc_clk_gen/SYS_CLK1]
  connect_bd_intf_net -intf_net noc_clk_gen_SYS_CLK2 [get_bd_intf_pins axi_noc_0/sys_clk2] [get_bd_intf_pins noc_clk_gen/SYS_CLK2]
  connect_bd_intf_net -intf_net noc_clk_gen_SYS_CLK3 [get_bd_intf_pins axi_noc_0/sys_clk3] [get_bd_intf_pins noc_clk_gen/SYS_CLK3]
  connect_bd_intf_net -intf_net noc_tg_1_M_AXI [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins noc_tg_1/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets noc_tg_1_M_AXI] [get_bd_intf_pins noc_tg_1/M_AXI] [get_bd_intf_pins noc_tg_pmon_1/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /noc_tg_1_M_AXI]
  connect_bd_intf_net -intf_net noc_tg_2_M_AXI [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins noc_tg_2/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets noc_tg_2_M_AXI] [get_bd_intf_pins noc_tg_2/M_AXI] [get_bd_intf_pins noc_tg_pmon_2/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /noc_tg_2_M_AXI]
  connect_bd_intf_net -intf_net noc_tg_3_M_AXI [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins noc_tg_3/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets noc_tg_3_M_AXI] [get_bd_intf_pins noc_tg_3/M_AXI] [get_bd_intf_pins noc_tg_pmon_3/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /noc_tg_3_M_AXI]
  connect_bd_intf_net -intf_net noc_tg_4_M_AXI [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins noc_tg_4/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets noc_tg_4_M_AXI] [get_bd_intf_pins noc_tg_4/M_AXI] [get_bd_intf_pins noc_tg_pmon_4/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /noc_tg_4_M_AXI]
  connect_bd_intf_net -intf_net noc_tg_5_M_AXI [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins noc_tg_5/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets noc_tg_5_M_AXI] [get_bd_intf_pins noc_tg_5/M_AXI] [get_bd_intf_pins noc_tg_pmon_5/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /noc_tg_5_M_AXI]
  connect_bd_intf_net -intf_net noc_tg_M_AXI [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins noc_tg/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets noc_tg_M_AXI] [get_bd_intf_pins noc_tg/M_AXI] [get_bd_intf_pins noc_tg_pmon/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /noc_tg_M_AXI]

  # Create port connections
  connect_bd_net -net clk_100MHz_1 [get_bd_ports clk_100MHz] [get_bd_pins clk_wiz/clk_in1]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins noc_clk_gen/axi_clk_in_0] [get_bd_pins rst_clk_wiz_100M/slowest_sync_clk]
  connect_bd_net -net clk_wiz_locked [get_bd_pins clk_wiz/locked] [get_bd_pins rst_clk_wiz_100M/dcm_locked]
  connect_bd_net -net noc_clk_gen_axi_clk_0 [get_bd_pins axi_noc_0/aclk0] [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_sim_trig/pclk] [get_bd_pins noc_tg/clk] [get_bd_pins noc_tg_1/clk] [get_bd_pins noc_tg_2/clk] [get_bd_pins noc_tg_3/clk] [get_bd_pins noc_tg_4/clk] [get_bd_pins noc_tg_5/clk] [get_bd_pins noc_tg_pmon/axi_aclk] [get_bd_pins noc_tg_pmon_1/axi_aclk] [get_bd_pins noc_tg_pmon_2/axi_aclk] [get_bd_pins noc_tg_pmon_3/axi_aclk] [get_bd_pins noc_tg_pmon_4/axi_aclk] [get_bd_pins noc_tg_pmon_5/axi_aclk]
  connect_bd_net -net noc_clk_gen_axi_rst_0_n [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_sim_trig/rst_n] [get_bd_pins noc_tg/tg_rst_n] [get_bd_pins noc_tg_1/tg_rst_n] [get_bd_pins noc_tg_2/tg_rst_n] [get_bd_pins noc_tg_3/tg_rst_n] [get_bd_pins noc_tg_4/tg_rst_n] [get_bd_pins noc_tg_5/tg_rst_n] [get_bd_pins noc_tg_pmon/axi_arst_n] [get_bd_pins noc_tg_pmon_1/axi_arst_n] [get_bd_pins noc_tg_pmon_2/axi_arst_n] [get_bd_pins noc_tg_pmon_3/axi_arst_n] [get_bd_pins noc_tg_pmon_4/axi_arst_n] [get_bd_pins noc_tg_pmon_5/axi_arst_n] [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
  connect_bd_net -net noc_sim_trig_trig_00 [get_bd_pins noc_sim_trig/trig_00] [get_bd_pins noc_tg/axi_tg_start]
  connect_bd_net -net noc_sim_trig_trig_01 [get_bd_pins noc_sim_trig/trig_01] [get_bd_pins noc_tg_1/axi_tg_start]
  connect_bd_net -net noc_sim_trig_trig_02 [get_bd_pins noc_sim_trig/trig_02] [get_bd_pins noc_tg_2/axi_tg_start]
  connect_bd_net -net noc_sim_trig_trig_03 [get_bd_pins noc_sim_trig/trig_03] [get_bd_pins noc_tg_3/axi_tg_start]
  connect_bd_net -net noc_sim_trig_trig_04 [get_bd_pins noc_sim_trig/trig_04] [get_bd_pins noc_tg_4/axi_tg_start]
  connect_bd_net -net noc_sim_trig_trig_05 [get_bd_pins noc_sim_trig/trig_05] [get_bd_pins noc_tg_5/axi_tg_start]
  connect_bd_net -net noc_tg_1_axi_tg_done [get_bd_pins noc_sim_trig/all_done_01] [get_bd_pins noc_tg_1/axi_tg_done]
  connect_bd_net -net noc_tg_2_axi_tg_done [get_bd_pins noc_sim_trig/all_done_02] [get_bd_pins noc_tg_2/axi_tg_done]
  connect_bd_net -net noc_tg_3_axi_tg_done [get_bd_pins noc_sim_trig/all_done_03] [get_bd_pins noc_tg_3/axi_tg_done]
  connect_bd_net -net noc_tg_4_axi_tg_done [get_bd_pins noc_sim_trig/all_done_04] [get_bd_pins noc_tg_4/axi_tg_done]
  connect_bd_net -net noc_tg_5_axi_tg_done [get_bd_pins noc_sim_trig/all_done_05] [get_bd_pins noc_tg_5/axi_tg_done]
  connect_bd_net -net noc_tg_axi_tg_done [get_bd_pins noc_sim_trig/all_done_00] [get_bd_pins noc_tg/axi_tg_done]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl_0] [get_bd_pins clk_wiz/reset]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins noc_clk_gen/axi_rst_in_0_n] [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn]

  # Create address segments
  assign_bd_address -offset 0x050000000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces noc_tg/Data] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_CH1x4] -force
  assign_bd_address -offset 0x050000000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces noc_tg_1/Data] [get_bd_addr_segs axi_noc_0/S01_AXI/C1_DDR_CH1x4] -force
  assign_bd_address -offset 0x050000000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces noc_tg_2/Data] [get_bd_addr_segs axi_noc_0/S02_AXI/C2_DDR_CH1x4] -force
  assign_bd_address -offset 0x050000000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces noc_tg_3/Data] [get_bd_addr_segs axi_noc_0/S03_AXI/C2_DDR_CH1x4] -force
  assign_bd_address -offset 0x050000000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces noc_tg_4/Data] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_CH1x4] -force
  assign_bd_address -offset 0x050000000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces noc_tg_5/Data] [get_bd_addr_segs axi_noc_0/S05_AXI/C1_DDR_CH1x4] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################


common::send_gid_msg -ssname BD::TCL -id 2052 -severity "CRITICAL WARNING" "This Tcl script was generated from a block design that is out-of-date/locked. It is possible that design <$design_name> may result in errors during construction."

create_root_design ""


