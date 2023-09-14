
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
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# rtl_block

# Please add the sources of those modules before sourcing this Tcl script.

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
xilinx.com:ip:dds_compiler:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:emb_mem_gen:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axis_ila:1.2\
xilinx.com:ip:axis_vio:1.0\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:clk_wizard:1.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:versal_cips:3.4\
xilinx.com:ip:xlconstant:1.1\
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
rtl_block\
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

  # Create ports

  # Create instance: dds_compiler_0, and set properties
  set dds_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler_0 ]
  set_property -dict [list \
    CONFIG.DATA_Has_TLAST {Not_Required} \
    CONFIG.Has_Phase_Out {false} \
    CONFIG.Latency {6} \
    CONFIG.M_DATA_Has_TUSER {Not_Required} \
    CONFIG.Noise_Shaping {None} \
    CONFIG.Output_Frequency1 {0} \
    CONFIG.Output_Width {16} \
    CONFIG.PINC1 {0} \
    CONFIG.Parameter_Entry {Hardware_Parameters} \
    CONFIG.PartsPresent {SIN_COS_LUT_only} \
    CONFIG.Phase_Width {16} \
    CONFIG.S_PHASE_Has_TUSER {Not_Required} \
  ] $dds_compiler_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {15} \
    CONFIG.DOUT_WIDTH {16} \
  ] $xlslice_0


  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 axi_bram_ctrl_0_bram ]
  set_property CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} $axi_bram_ctrl_0_bram


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_0


  # Create instance: axis_ila_0, and set properties
  set axis_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.2 axis_ila_0 ]
  set_property -dict [list \
    CONFIG.C_ADV_TRIGGER {true} \
    CONFIG.C_INPUT_PIPE_STAGES {3} \
    CONFIG.C_MON_TYPE {Mixed} \
    CONFIG.C_NUM_OF_PROBES {3} \
    CONFIG.C_PROBE0_TYPE {0} \
    CONFIG.C_PROBE0_WIDTH {32} \
    CONFIG.C_PROBE1_TYPE {0} \
    CONFIG.C_PROBE1_WIDTH {32} \
    CONFIG.C_PROBE2_TYPE {0} \
    CONFIG.C_PROBE2_WIDTH {32} \
    CONFIG.C_SLOT_0_APC_EN {1} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {1} \
  ] $axis_ila_0


  # Create instance: axis_vio_0, and set properties
  set axis_vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_vio:1.0 axis_vio_0 ]
  set_property -dict [list \
    CONFIG.C_NUM_PROBE_OUT {5} \
    CONFIG.C_PROBE_IN0_WIDTH {32} \
    CONFIG.C_PROBE_OUT0_INIT_VAL {0x1} \
    CONFIG.C_PROBE_OUT2_INIT_VAL {0x1} \
    CONFIG.C_PROBE_OUT4_WIDTH {32} \
  ] $axis_vio_0


  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [list \
    CONFIG.CE {true} \
    CONFIG.Count_Mode {UPDOWN} \
    CONFIG.Load {true} \
    CONFIG.Output_Width {32} \
    CONFIG.SCLR {true} \
  ] $c_counter_binary_0


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.CPM_CONFIG { \
      CPM_PCIE0_MODES {None} \
    } \
    CONFIG.DDR_MEMORY_MODE {Custom} \
    CONFIG.DEBUG_MODE {JTAG} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      AURORA_LINE_RATE_GPBS {12.5} \
      BOOT_MODE {Custom} \
      BOOT_SECONDARY_PCIE_ENABLE {0} \
      CLOCK_MODE {Custom} \
      COHERENCY_MODE {Custom} \
      CPM_PCIE0_MODES {None} \
      CPM_PCIE0_PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
      CPM_PCIE0_TANDEM {None} \
      CPM_PCIE1_MODES {None} \
      CPM_PCIE1_PL_LINK_CAP_MAX_LINK_WIDTH {X4} \
      DDR_MEMORY_MODE {Custom} \
      DEBUG_MODE {JTAG} \
      DESIGN_MODE {1} \
      DEVICE_INTEGRITY_MODE {Custom} \
      DIS_AUTO_POL_CHECK {0} \
      GT_REFCLK_MHZ {156.25} \
      INIT_CLK_MHZ {125} \
      INV_POLARITY {0} \
      IO_CONFIG_MODE {Custom} \
      JTAG_USERCODE {0x0} \
      OT_EAM_RESP {SRST} \
      PCIE_APERTURES_DUAL_ENABLE {0} \
      PCIE_APERTURES_SINGLE_ENABLE {0} \
      PERFORMANCE_MODE {Custom} \
      PL_SEM_GPIO_ENABLE {0} \
      PMC_ALT_REF_CLK_FREQMHZ {33.333} \
      PMC_BANK_0_IO_STANDARD {LVCMOS1.8} \
      PMC_BANK_1_IO_STANDARD {LVCMOS1.8} \
      PMC_CIPS_MODE {ADVANCE} \
      PMC_CLKMON0_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON0_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON0_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON0_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON1_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON2_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON3_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON4_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON5_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON6_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG_1 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG_2 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CLKMON7_CONFIG_3 {{BASE 10000} {BASE_CLK_SRC REF_CLK} {CLKA_FREQ 1000} {CLKA_SEL REF_CLK} {ENABLE 0} {INTR 0} {THRESHOLD_L 0} {THRESHOLD_U 0}} \
      PMC_CORE_SUBSYSTEM_LOAD {10} \
      PMC_CRP_CFU_REF_CTRL_ACT_FREQMHZ {394.444061} \
      PMC_CRP_CFU_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_CFU_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_CFU_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_DFT_OSC_REF_CTRL_ACT_FREQMHZ {400} \
      PMC_CRP_DFT_OSC_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_DFT_OSC_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_DFT_OSC_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_EFUSE_REF_CTRL_ACT_FREQMHZ {100.000000} \
      PMC_CRP_EFUSE_REF_CTRL_FREQMHZ {100.000000} \
      PMC_CRP_EFUSE_REF_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {32.870338} \
      PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {36} \
      PMC_CRP_HSM0_REF_CTRL_FREQMHZ {33.333} \
      PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {131.481354} \
      PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {9} \
      PMC_CRP_HSM1_REF_CTRL_FREQMHZ {133.333} \
      PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_I2C_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_I2C_REF_CTRL_DIVISOR0 {12} \
      PMC_CRP_I2C_REF_CTRL_FREQMHZ {100} \
      PMC_CRP_I2C_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_LSBUS_REF_CTRL_ACT_FREQMHZ {147.916519} \
      PMC_CRP_LSBUS_REF_CTRL_DIVISOR0 {8} \
      PMC_CRP_LSBUS_REF_CTRL_FREQMHZ {150} \
      PMC_CRP_LSBUS_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_NOC_REF_CTRL_ACT_FREQMHZ {999.999023} \
      PMC_CRP_NOC_REF_CTRL_FREQMHZ {1000} \
      PMC_CRP_NOC_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_NPI_REF_CTRL_ACT_FREQMHZ {295.833038} \
      PMC_CRP_NPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_NPI_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_NPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_NPLL_CTRL_CLKOUTDIV {4} \
      PMC_CRP_NPLL_CTRL_FBDIV {120} \
      PMC_CRP_NPLL_CTRL_SRCSEL {REF_CLK} \
      PMC_CRP_NPLL_TO_XPD_CTRL_DIVISOR0 {2} \
      PMC_CRP_OSPI_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_OSPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_OSPI_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_OSPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ {333.333008} \
      PMC_CRP_PL0_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {350} \
      PMC_CRP_PL0_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL1_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL1_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL1_REF_CTRL_FREQMHZ {334} \
      PMC_CRP_PL1_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL2_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL2_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL2_REF_CTRL_FREQMHZ {334} \
      PMC_CRP_PL2_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL3_REF_CTRL_ACT_FREQMHZ {100} \
      PMC_CRP_PL3_REF_CTRL_DIVISOR0 {3} \
      PMC_CRP_PL3_REF_CTRL_FREQMHZ {334} \
      PMC_CRP_PL3_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_PL5_REF_CTRL_FREQMHZ {400} \
      PMC_CRP_PPLL_CTRL_CLKOUTDIV {2} \
      PMC_CRP_PPLL_CTRL_FBDIV {71} \
      PMC_CRP_PPLL_CTRL_SRCSEL {REF_CLK} \
      PMC_CRP_PPLL_TO_XPD_CTRL_DIVISOR0 {1} \
      PMC_CRP_QSPI_REF_CTRL_ACT_FREQMHZ {295.833038} \
      PMC_CRP_QSPI_REF_CTRL_DIVISOR0 {4} \
      PMC_CRP_QSPI_REF_CTRL_FREQMHZ {300} \
      PMC_CRP_QSPI_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SDIO0_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_SDIO0_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_SDIO0_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_SDIO0_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SDIO1_REF_CTRL_ACT_FREQMHZ {199.999802} \
      PMC_CRP_SDIO1_REF_CTRL_DIVISOR0 {5} \
      PMC_CRP_SDIO1_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_SDIO1_REF_CTRL_SRCSEL {NPLL} \
      PMC_CRP_SD_DLL_REF_CTRL_ACT_FREQMHZ {1183.332153} \
      PMC_CRP_SD_DLL_REF_CTRL_DIVISOR0 {1} \
      PMC_CRP_SD_DLL_REF_CTRL_FREQMHZ {1200} \
      PMC_CRP_SD_DLL_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_ACT_FREQMHZ {1.000000} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_DIVISOR0 {100} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_FREQMHZ {1} \
      PMC_CRP_SWITCH_TIMEOUT_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_CRP_SYSMON_REF_CTRL_ACT_FREQMHZ {295.833038} \
      PMC_CRP_SYSMON_REF_CTRL_FREQMHZ {295.833038} \
      PMC_CRP_SYSMON_REF_CTRL_SRCSEL {NPI_REF_CLK} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_ACT_FREQMHZ {200} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_DIVISOR0 {6} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_TEST_PATTERN_REF_CTRL_SRCSEL {PPLL} \
      PMC_CRP_USB_SUSPEND_CTRL_ACT_FREQMHZ {0.200000} \
      PMC_CRP_USB_SUSPEND_CTRL_DIVISOR0 {500} \
      PMC_CRP_USB_SUSPEND_CTRL_FREQMHZ {0.2} \
      PMC_CRP_USB_SUSPEND_CTRL_SRCSEL {IRO_CLK/4} \
      PMC_EXTERNAL_TAMPER {{ENABLE 0} {IO NONE}} \
      PMC_EXTERNAL_TAMPER_1 {{ENABLE 0} {IO None}} \
      PMC_EXTERNAL_TAMPER_2 {{ENABLE 0} {IO None}} \
      PMC_EXTERNAL_TAMPER_3 {{ENABLE 0} {IO None}} \
      PMC_GLITCH_CONFIG {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GLITCH_CONFIG_1 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GLITCH_CONFIG_2 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GLITCH_CONFIG_3 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE EFUSE} {VCC_PMC_VALUE 0.80}} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
      PMC_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PMC_GPIO_EMIO_WIDTH {64} \
      PMC_GPIO_EMIO_WIDTH_HDL {64} \
      PMC_GPI_ENABLE {0} \
      PMC_GPI_WIDTH {32} \
      PMC_GPO_ENABLE {0} \
      PMC_GPO_WIDTH {32} \
      PMC_HSM0_CLK_ENABLE {1} \
      PMC_HSM0_CLK_OUT_ENABLE {0} \
      PMC_HSM1_CLK_ENABLE {1} \
      PMC_HSM1_CLK_OUT_ENABLE {0} \
      PMC_I2CPMC_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 2 .. 3}}} \
      PMC_MIO0 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO1 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO10 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO11 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO14 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO15 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO16 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO17 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO18 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO19 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO2 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO20 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO21 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO22 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO23 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO25 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO26 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO27 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO28 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO29 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO3 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO30 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO31 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO32 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO33 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO34 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO35 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO36 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO38 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO39 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO4 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO40 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO41 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO42 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO43 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO44 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO45 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO46 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO47 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO48 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO49 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO5 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO50 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Unassigned}} \
      PMC_MIO51 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO6 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO7 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO8 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO9 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 12mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW fast} {USAGE Reserved}} \
      PMC_MIO_EN_FOR_PL_PCIE {0} \
      PMC_MIO_TREE_PERIPHERALS {QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#Loopback Clk#QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB 2.0#USB\
2.0#SD1/eMMC1#SD1/eMMC1#SD1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#GPIO 1###CANFD1#CANFD1#UART 0#UART 0#LPD_I2C1#LPD_I2C1#LPD_I2C0#LPD_I2C0####SD1/eMMC1#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem0#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem1#Gem0#Gem0}\
\
      PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b#qspi_lpbk#qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]#detect#cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]#gpio_1_pin[37]###phy_tx#phy_rx#rxd#txd#scl#sda#scl#sda####buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio}\
\
      PMC_NOC_PMC_ADDR_WIDTH {64} \
      PMC_NOC_PMC_DATA_WIDTH {128} \
      PMC_OSPI_COHERENCY {0} \
      PMC_OSPI_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
      PMC_OSPI_ROUTE_THROUGH_FPD {0} \
      PMC_OT_CHECK {{DELAY 0} {ENABLE 1}} \
      PMC_PL_ALT_REF_CLK_FREQMHZ {33.333} \
      PMC_PMC_NOC_ADDR_WIDTH {64} \
      PMC_PMC_NOC_DATA_WIDTH {128} \
      PMC_QSPI_COHERENCY {0} \
      PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_QSPI_ROUTE_THROUGH_FPD {0} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_ACT_FREQMHZ {100} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_DIVISOR0 {3} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_FREQMHZ {300} \
      PMC_RAM_CFU_REF_CTRL_CSCAN_SRCSEL {PPLL} \
      PMC_REF_CLK_FREQMHZ {33.3333} \
      PMC_SD0 {{CD_ENABLE 0} {CD_IO {PMC_MIO 24}} {POW_ENABLE 0} {POW_IO {PMC_MIO 17}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 17}} {WP_ENABLE 0} {WP_IO {PMC_MIO 25}}} \
      PMC_SD0_COHERENCY {0} \
      PMC_SD0_DATA_TRANSFER_MODE {4Bit} \
      PMC_SD0_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x00} {CLK_50_DDR_ITAP_DLY 0x00} {CLK_50_DDR_OTAP_DLY 0x00} {CLK_50_SDR_ITAP_DLY 0x00} {CLK_50_SDR_OTAP_DLY 0x00} {ENABLE 0}\
{IO {PMC_MIO 13 .. 25}}} \
      PMC_SD0_ROUTE_THROUGH_FPD {0} \
      PMC_SD0_SLOT_TYPE {SD 2.0} \
      PMC_SD0_SPEED_MODE {default speed} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_COHERENCY {0} \
      PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x36} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_ROUTE_THROUGH_FPD {0} \
      PMC_SD1_SLOT_TYPE {SD 3.0} \
      PMC_SD1_SPEED_MODE {high speed} \
      PMC_SHOW_CCI_SMMU_SETTINGS {0} \
      PMC_SMAP_PERIPHERAL {{ENABLE 0} {IO {32 Bit}}} \
      PMC_TAMPER_EXTMIO_ENABLE {0} \
      PMC_TAMPER_EXTMIO_ERASE_BBRAM {0} \
      PMC_TAMPER_EXTMIO_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_ENABLE {0} \
      PMC_TAMPER_GLITCHDETECT_ENABLE_1 {0} \
      PMC_TAMPER_GLITCHDETECT_ENABLE_2 {0} \
      PMC_TAMPER_GLITCHDETECT_ENABLE_3 {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_GLITCHDETECT_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_GLITCHDETECT_RESPONSE_3 {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_ENABLE {0} \
      PMC_TAMPER_JTAGDETECT_ENABLE_1 {0} \
      PMC_TAMPER_JTAGDETECT_ENABLE_2 {0} \
      PMC_TAMPER_JTAGDETECT_ENABLE_3 {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_JTAGDETECT_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_JTAGDETECT_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_JTAGDETECT_RESPONSE_3 {SYS INTERRUPT} \
      PMC_TAMPER_SUP0 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP0_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP0_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP0_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 0} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP10_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 10} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP11_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 11} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP12_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 12} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP13_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 13} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP14_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 14} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP15_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 15} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP16_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 16} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP17_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 17} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP18_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 18} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP19_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 19} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP1_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 1} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP20_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 20} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP21_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 21} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP22_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 22} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP23_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 23} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP24_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 24} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP25_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 25} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP26_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 26} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP27_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 27} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP28_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 28} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP29_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 29} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP2_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 2} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP30_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 30} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP31_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 31} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP3_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 3} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP4_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 4} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP5_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 5} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP6_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 6} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP7_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 7} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP8_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 8} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {IO_N none} {IO_P none} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9_1 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9_2 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP9_3 {{ADC_MODE none} {AVG_ENABLE 0} {ENABLE 0} {SUPPLY_NUM 9} {TH_HIGH 0} {TH_LOW 0} {TH_MAX 0} {TH_MIN 0} {VOLTAGE none}} \
      PMC_TAMPER_SUP_0_31_ENABLE {0} \
      PMC_TAMPER_SUP_0_31_ENABLE_1 {0} \
      PMC_TAMPER_SUP_0_31_ENABLE_2 {0} \
      PMC_TAMPER_SUP_0_31_ENABLE_3 {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_SUP_0_31_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_SUP_0_31_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_SUP_0_31_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_SUP_0_31_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_SUP_0_31_RESPONSE_3 {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_ENABLE {0} \
      PMC_TAMPER_TEMPERATURE_ENABLE_1 {0} \
      PMC_TAMPER_TEMPERATURE_ENABLE_2 {0} \
      PMC_TAMPER_TEMPERATURE_ENABLE_3 {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM_1 {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM_2 {0} \
      PMC_TAMPER_TEMPERATURE_ERASE_BBRAM_3 {0} \
      PMC_TAMPER_TEMPERATURE_RESPONSE {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_RESPONSE_1 {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_RESPONSE_2 {SYS INTERRUPT} \
      PMC_TAMPER_TEMPERATURE_RESPONSE_3 {SYS INTERRUPT} \
      PMC_USE_CFU_SEU {0} \
      PMC_USE_NOC_PMC_AXI0 {0} \
      PMC_USE_NOC_PMC_AXI1 {0} \
      PMC_USE_NOC_PMC_AXI2 {0} \
      PMC_USE_NOC_PMC_AXI3 {0} \
      PMC_USE_PL_PMC_AUX_REF_CLK {0} \
      PMC_USE_PMC_NOC_AXI0 {0} \
      PMC_USE_PMC_NOC_AXI1 {0} \
      PMC_USE_PMC_NOC_AXI2 {0} \
      PMC_USE_PMC_NOC_AXI3 {0} \
      PMC_WDT_PERIOD {100} \
      PMC_WDT_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0}}} \
      POWER_REPORTING_MODE {Custom} \
      PSPMC_MANUAL_CLK_ENABLE {0} \
      PS_A72_ACTIVE_BLOCKS {2} \
      PS_A72_LOAD {90} \
      PS_BANK_2_IO_STANDARD {LVCMOS1.8} \
      PS_BANK_3_IO_STANDARD {LVCMOS1.8} \
      PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
      PS_CAN0_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_CAN0_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 8 .. 9}}} \
      PS_CAN1_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 40 .. 41}}} \
      PS_CRF_ACPU_CTRL_ACT_FREQMHZ {1399.998657} \
      PS_CRF_ACPU_CTRL_DIVISOR0 {1} \
      PS_CRF_ACPU_CTRL_FREQMHZ {1400} \
      PS_CRF_ACPU_CTRL_SRCSEL {APLL} \
      PS_CRF_APLL_CTRL_CLKOUTDIV {2} \
      PS_CRF_APLL_CTRL_FBDIV {84} \
      PS_CRF_APLL_CTRL_SRCSEL {REF_CLK} \
      PS_CRF_APLL_TO_XPD_CTRL_DIVISOR0 {4} \
      PS_CRF_DBG_FPD_CTRL_ACT_FREQMHZ {394.444061} \
      PS_CRF_DBG_FPD_CTRL_DIVISOR0 {3} \
      PS_CRF_DBG_FPD_CTRL_FREQMHZ {400} \
      PS_CRF_DBG_FPD_CTRL_SRCSEL {PPLL} \
      PS_CRF_DBG_TRACE_CTRL_ACT_FREQMHZ {300} \
      PS_CRF_DBG_TRACE_CTRL_DIVISOR0 {3} \
      PS_CRF_DBG_TRACE_CTRL_FREQMHZ {300} \
      PS_CRF_DBG_TRACE_CTRL_SRCSEL {PPLL} \
      PS_CRF_FPD_LSBUS_CTRL_ACT_FREQMHZ {147.916519} \
      PS_CRF_FPD_LSBUS_CTRL_DIVISOR0 {8} \
      PS_CRF_FPD_LSBUS_CTRL_FREQMHZ {150} \
      PS_CRF_FPD_LSBUS_CTRL_SRCSEL {PPLL} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {824.999207} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_DIVISOR0 {1} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_FREQMHZ {825} \
      PS_CRF_FPD_TOP_SWITCH_CTRL_SRCSEL {RPLL} \
      PS_CRL_CAN0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_CAN0_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_CAN0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_CAN0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_CAN1_REF_CTRL_ACT_FREQMHZ {99.999901} \
      PS_CRL_CAN1_REF_CTRL_DIVISOR0 {5} \
      PS_CRL_CAN1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_CAN1_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_CPM_TOPSW_REF_CTRL_ACT_FREQMHZ {824.999207} \
      PS_CRL_CPM_TOPSW_REF_CTRL_DIVISOR0 {2} \
      PS_CRL_CPM_TOPSW_REF_CTRL_FREQMHZ {825} \
      PS_CRL_CPM_TOPSW_REF_CTRL_SRCSEL {RPLL} \
      PS_CRL_CPU_R5_CTRL_ACT_FREQMHZ {591.666077} \
      PS_CRL_CPU_R5_CTRL_DIVISOR0 {2} \
      PS_CRL_CPU_R5_CTRL_FREQMHZ {600} \
      PS_CRL_CPU_R5_CTRL_SRCSEL {PPLL} \
      PS_CRL_DBG_LPD_CTRL_ACT_FREQMHZ {394.444061} \
      PS_CRL_DBG_LPD_CTRL_DIVISOR0 {3} \
      PS_CRL_DBG_LPD_CTRL_FREQMHZ {400} \
      PS_CRL_DBG_LPD_CTRL_SRCSEL {PPLL} \
      PS_CRL_DBG_TSTMP_CTRL_ACT_FREQMHZ {394.444061} \
      PS_CRL_DBG_TSTMP_CTRL_DIVISOR0 {3} \
      PS_CRL_DBG_TSTMP_CTRL_FREQMHZ {400} \
      PS_CRL_DBG_TSTMP_CTRL_SRCSEL {PPLL} \
      PS_CRL_GEM0_REF_CTRL_ACT_FREQMHZ {124.999878} \
      PS_CRL_GEM0_REF_CTRL_DIVISOR0 {4} \
      PS_CRL_GEM0_REF_CTRL_FREQMHZ {125} \
      PS_CRL_GEM0_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_GEM1_REF_CTRL_ACT_FREQMHZ {124.999878} \
      PS_CRL_GEM1_REF_CTRL_DIVISOR0 {4} \
      PS_CRL_GEM1_REF_CTRL_FREQMHZ {125} \
      PS_CRL_GEM1_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_GEM_TSU_REF_CTRL_ACT_FREQMHZ {249.999756} \
      PS_CRL_GEM_TSU_REF_CTRL_DIVISOR0 {2} \
      PS_CRL_GEM_TSU_REF_CTRL_FREQMHZ {250} \
      PS_CRL_GEM_TSU_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_I2C0_REF_CTRL_ACT_FREQMHZ {99.999901} \
      PS_CRL_I2C0_REF_CTRL_DIVISOR0 {5} \
      PS_CRL_I2C0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_I2C0_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_I2C1_REF_CTRL_ACT_FREQMHZ {99.999901} \
      PS_CRL_I2C1_REF_CTRL_DIVISOR0 {5} \
      PS_CRL_I2C1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_I2C1_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_IOU_SWITCH_CTRL_ACT_FREQMHZ {249.999756} \
      PS_CRL_IOU_SWITCH_CTRL_DIVISOR0 {2} \
      PS_CRL_IOU_SWITCH_CTRL_FREQMHZ {250} \
      PS_CRL_IOU_SWITCH_CTRL_SRCSEL {NPLL} \
      PS_CRL_LPD_LSBUS_CTRL_ACT_FREQMHZ {149.999863} \
      PS_CRL_LPD_LSBUS_CTRL_DIVISOR0 {11} \
      PS_CRL_LPD_LSBUS_CTRL_FREQMHZ {150} \
      PS_CRL_LPD_LSBUS_CTRL_SRCSEL {RPLL} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {591.666077} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_FREQMHZ {600} \
      PS_CRL_LPD_TOP_SWITCH_CTRL_SRCSEL {PPLL} \
      PS_CRL_PSM_REF_CTRL_ACT_FREQMHZ {394.444061} \
      PS_CRL_PSM_REF_CTRL_DIVISOR0 {3} \
      PS_CRL_PSM_REF_CTRL_FREQMHZ {400} \
      PS_CRL_PSM_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_RPLL_CTRL_CLKOUTDIV {2} \
      PS_CRL_RPLL_CTRL_FBDIV {99} \
      PS_CRL_RPLL_CTRL_SRCSEL {REF_CLK} \
      PS_CRL_RPLL_TO_XPD_CTRL_DIVISOR0 {2} \
      PS_CRL_SPI0_REF_CTRL_ACT_FREQMHZ {200} \
      PS_CRL_SPI0_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_SPI0_REF_CTRL_FREQMHZ {200} \
      PS_CRL_SPI0_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_SPI1_REF_CTRL_ACT_FREQMHZ {200} \
      PS_CRL_SPI1_REF_CTRL_DIVISOR0 {6} \
      PS_CRL_SPI1_REF_CTRL_FREQMHZ {200} \
      PS_CRL_SPI1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_TIMESTAMP_REF_CTRL_ACT_FREQMHZ {99.999901} \
      PS_CRL_TIMESTAMP_REF_CTRL_DIVISOR0 {5} \
      PS_CRL_TIMESTAMP_REF_CTRL_FREQMHZ {100} \
      PS_CRL_TIMESTAMP_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ {99.999901} \
      PS_CRL_UART0_REF_CTRL_DIVISOR0 {5} \
      PS_CRL_UART0_REF_CTRL_FREQMHZ {100} \
      PS_CRL_UART0_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_UART1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_CRL_UART1_REF_CTRL_DIVISOR0 {12} \
      PS_CRL_UART1_REF_CTRL_FREQMHZ {100} \
      PS_CRL_UART1_REF_CTRL_SRCSEL {PPLL} \
      PS_CRL_USB0_BUS_REF_CTRL_ACT_FREQMHZ {19.999981} \
      PS_CRL_USB0_BUS_REF_CTRL_DIVISOR0 {25} \
      PS_CRL_USB0_BUS_REF_CTRL_FREQMHZ {20} \
      PS_CRL_USB0_BUS_REF_CTRL_SRCSEL {NPLL} \
      PS_CRL_USB3_DUAL_REF_CTRL_ACT_FREQMHZ {20} \
      PS_CRL_USB3_DUAL_REF_CTRL_DIVISOR0 {60} \
      PS_CRL_USB3_DUAL_REF_CTRL_FREQMHZ {10} \
      PS_CRL_USB3_DUAL_REF_CTRL_SRCSEL {PPLL} \
      PS_DDRC_ENABLE {1} \
      PS_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
      PS_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_ENET1_MDIO {{ENABLE 0} {IO {PMC_MIO 50 .. 51}}} \
      PS_ENET1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 12 .. 23}}} \
      PS_EN_AXI_STATUS_PORTS {0} \
      PS_EN_PORTS_CONTROLLER_BASED {0} \
      PS_EXPAND_CORESIGHT {0} \
      PS_EXPAND_FPD_SLAVES {0} \
      PS_EXPAND_GIC {0} \
      PS_EXPAND_LPD_SLAVES {0} \
      PS_FPD_INTERCONNECT_LOAD {90} \
      PS_FTM_CTI_IN0 {0} \
      PS_FTM_CTI_IN1 {0} \
      PS_FTM_CTI_IN2 {0} \
      PS_FTM_CTI_IN3 {0} \
      PS_FTM_CTI_OUT0 {0} \
      PS_FTM_CTI_OUT1 {0} \
      PS_FTM_CTI_OUT2 {0} \
      PS_FTM_CTI_OUT3 {0} \
      PS_GEM0_COHERENCY {0} \
      PS_GEM0_ROUTE_THROUGH_FPD {0} \
      PS_GEM0_TSU_INC_CTRL {3} \
      PS_GEM1_COHERENCY {0} \
      PS_GEM1_ROUTE_THROUGH_FPD {0} \
      PS_GEM_TSU {{ENABLE 0} {IO {PS_MIO 24}}} \
      PS_GEM_TSU_CLK_PORT_PAIR {0} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI0_MASTER {A72} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI1_MASTER {A72} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI2_MASTER {A72} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI3_MASTER {A72} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI4_MASTER {A72} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI5_MASTER {A72} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_GEN_IPI6_MASTER {A72} \
      PS_GEN_IPI_PMCNOBUF_ENABLE {1} \
      PS_GEN_IPI_PMCNOBUF_MASTER {PMC} \
      PS_GEN_IPI_PMC_ENABLE {1} \
      PS_GEN_IPI_PMC_MASTER {PMC} \
      PS_GEN_IPI_PSM_ENABLE {1} \
      PS_GEN_IPI_PSM_MASTER {PSM} \
      PS_GPIO2_MIO_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 0 .. 25}}} \
      PS_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PS_GPIO_EMIO_WIDTH {32} \
      PS_HSDP0_REFCLK {0} \
      PS_HSDP1_REFCLK {0} \
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {NONE} \
      PS_HSDP_SAME_EGRESS_AS_INGRESS_TRAFFIC {1} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PS_MIO 23 .. 24}}} \
      PS_IRQ_USAGE {{CH0 0} {CH1 0} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0} {CH8 0} {CH9 0}} \
      PS_KAT_ENABLE {1} \
      PS_KAT_ENABLE_1 {1} \
      PS_KAT_ENABLE_2 {1} \
      PS_KAT_ENABLE_3 {1} \
      PS_LPDMA0_COHERENCY {0} \
      PS_LPDMA0_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA1_COHERENCY {0} \
      PS_LPDMA1_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA2_COHERENCY {0} \
      PS_LPDMA2_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA3_COHERENCY {0} \
      PS_LPDMA3_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA4_COHERENCY {0} \
      PS_LPDMA4_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA5_COHERENCY {0} \
      PS_LPDMA5_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA6_COHERENCY {0} \
      PS_LPDMA6_ROUTE_THROUGH_FPD {0} \
      PS_LPDMA7_COHERENCY {0} \
      PS_LPDMA7_ROUTE_THROUGH_FPD {0} \
      PS_LPD_DMA_CHANNEL_ENABLE {{CH0 0} {CH1 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0}} \
      PS_LPD_DMA_CH_TZ {{CH0 NonSecure} {CH1 NonSecure} {CH2 NonSecure} {CH3 NonSecure} {CH4 NonSecure} {CH5 NonSecure} {CH6 NonSecure} {CH7 NonSecure}} \
      PS_LPD_DMA_ENABLE {0} \
      PS_LPD_INTERCONNECT_LOAD {90} \
      PS_MIO0 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO1 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO10 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO11 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO14 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO15 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO16 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO17 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO18 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO2 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO20 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO21 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO22 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO23 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO25 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO3 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO4 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO5 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_MIO6 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO8 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_M_AXI_FPD_DATA_WIDTH {128} \
      PS_M_AXI_GP4_DATA_WIDTH {128} \
      PS_M_AXI_LPD_DATA_WIDTH {128} \
      PS_NOC_PS_CCI_DATA_WIDTH {128} \
      PS_NOC_PS_NCI_DATA_WIDTH {128} \
      PS_NOC_PS_PCI_DATA_WIDTH {128} \
      PS_NOC_PS_PMC_DATA_WIDTH {128} \
      PS_NUM_F2P0_INTR_INPUTS {1} \
      PS_NUM_F2P1_INTR_INPUTS {1} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_OCM_ACTIVE_BLOCKS {1} \
      PS_PCIE1_PERIPHERAL_ENABLE {0} \
      PS_PCIE2_PERIPHERAL_ENABLE {0} \
      PS_PCIE_EP_RESET1_IO {None} \
      PS_PCIE_EP_RESET2_IO {None} \
      PS_PCIE_PERIPHERAL_ENABLE {0} \
      PS_PCIE_RESET {{ENABLE 1}} \
      PS_PCIE_ROOT_RESET1_IO {None} \
      PS_PCIE_ROOT_RESET1_IO_DIR {output} \
      PS_PCIE_ROOT_RESET1_POLARITY {Active Low} \
      PS_PCIE_ROOT_RESET2_IO {None} \
      PS_PCIE_ROOT_RESET2_IO_DIR {output} \
      PS_PCIE_ROOT_RESET2_POLARITY {Active Low} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_PL_DONE {0} \
      PS_PL_PASS_AXPROT_VALUE {0} \
      PS_PMCPL_CLK0_BUF {1} \
      PS_PMCPL_CLK1_BUF {1} \
      PS_PMCPL_CLK2_BUF {1} \
      PS_PMCPL_CLK3_BUF {1} \
      PS_PMCPL_IRO_CLK_BUF {1} \
      PS_PMU_PERIPHERAL_ENABLE {0} \
      PS_PS_ENABLE {0} \
      PS_PS_NOC_CCI_DATA_WIDTH {128} \
      PS_PS_NOC_NCI_DATA_WIDTH {128} \
      PS_PS_NOC_PCI_DATA_WIDTH {128} \
      PS_PS_NOC_PMC_DATA_WIDTH {128} \
      PS_PS_NOC_RPU_DATA_WIDTH {128} \
      PS_R5_ACTIVE_BLOCKS {2} \
      PS_R5_LOAD {90} \
      PS_RPU_COHERENCY {0} \
      PS_SLR_TYPE {master} \
      PS_SMON_PL_PORTS_ENABLE {0} \
      PS_SPI0 {{GRP_SS0_ENABLE 0} {GRP_SS0_IO {PMC_MIO 15}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PMC_MIO 14}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PMC_MIO 13}} {PERIPHERAL_ENABLE 0} {PERIPHERAL_IO {PMC_MIO 12 ..\
17}}} \
      PS_SPI1 {{GRP_SS0_ENABLE 0} {GRP_SS0_IO {PS_MIO 9}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PS_MIO 8}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PS_MIO 7}} {PERIPHERAL_ENABLE 0} {PERIPHERAL_IO {PS_MIO 6 .. 11}}} \
      PS_S_AXI_ACE_DATA_WIDTH {128} \
      PS_S_AXI_ACP_DATA_WIDTH {128} \
      PS_S_AXI_FPD_DATA_WIDTH {128} \
      PS_S_AXI_GP2_DATA_WIDTH {128} \
      PS_S_AXI_LPD_DATA_WIDTH {128} \
      PS_TCM_ACTIVE_BLOCKS {2} \
      PS_TIE_MJTAG_TCK_TO_GND {1} \
      PS_TRACE_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 30 .. 47}}} \
      PS_TRACE_WIDTH {2Bit} \
      PS_TRISTATE_INVERTED {1} \
      PS_TTC0_CLK {{ENABLE 0} {IO {PS_MIO 6}}} \
      PS_TTC0_PERIPHERAL_ENABLE {0} \
      PS_TTC0_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC0_REF_CTRL_FREQMHZ {50} \
      PS_TTC0_WAVEOUT {{ENABLE 0} {IO {PS_MIO 7}}} \
      PS_TTC1_CLK {{ENABLE 0} {IO {PS_MIO 12}}} \
      PS_TTC1_PERIPHERAL_ENABLE {0} \
      PS_TTC1_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC1_REF_CTRL_FREQMHZ {50} \
      PS_TTC1_WAVEOUT {{ENABLE 0} {IO {PS_MIO 13}}} \
      PS_TTC2_CLK {{ENABLE 0} {IO {PS_MIO 2}}} \
      PS_TTC2_PERIPHERAL_ENABLE {0} \
      PS_TTC2_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC2_REF_CTRL_FREQMHZ {50} \
      PS_TTC2_WAVEOUT {{ENABLE 0} {IO {PS_MIO 3}}} \
      PS_TTC3_CLK {{ENABLE 0} {IO {PS_MIO 16}}} \
      PS_TTC3_PERIPHERAL_ENABLE {0} \
      PS_TTC3_REF_CTRL_ACT_FREQMHZ {50} \
      PS_TTC3_REF_CTRL_FREQMHZ {50} \
      PS_TTC3_WAVEOUT {{ENABLE 0} {IO {PS_MIO 17}}} \
      PS_TTC_APB_CLK_TTC0_SEL {APB} \
      PS_TTC_APB_CLK_TTC1_SEL {APB} \
      PS_TTC_APB_CLK_TTC2_SEL {APB} \
      PS_TTC_APB_CLK_TTC3_SEL {APB} \
      PS_UART0_BAUD_RATE {115200} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_UART0_RTS_CTS {{ENABLE 0} {IO {PS_MIO 2 .. 3}}} \
      PS_UART1_BAUD_RATE {115200} \
      PS_UART1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 4 .. 5}}} \
      PS_UART1_RTS_CTS {{ENABLE 0} {IO {PMC_MIO 6 .. 7}}} \
      PS_UNITS_MODE {Custom} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USB_COHERENCY {0} \
      PS_USB_ROUTE_THROUGH_FPD {0} \
      PS_USE_ACE_LITE {0} \
      PS_USE_APU_EVENT_BUS {0} \
      PS_USE_APU_INTERRUPT {0} \
      PS_USE_AXI4_EXT_USER_BITS {0} \
      PS_USE_BSCAN_USER1 {0} \
      PS_USE_BSCAN_USER2 {0} \
      PS_USE_BSCAN_USER3 {0} \
      PS_USE_BSCAN_USER4 {0} \
      PS_USE_CAPTURE {0} \
      PS_USE_CLK {0} \
      PS_USE_DEBUG_TEST {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_FPD {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_GP2 {0} \
      PS_USE_DIFF_RW_CLK_S_AXI_LPD {0} \
      PS_USE_ENET0_PTP {0} \
      PS_USE_ENET1_PTP {0} \
      PS_USE_FIFO_ENET0 {0} \
      PS_USE_FIFO_ENET1 {0} \
      PS_USE_FIXED_IO {0} \
      PS_USE_FPD_AXI_NOC0 {0} \
      PS_USE_FPD_AXI_NOC1 {0} \
      PS_USE_FPD_CCI_NOC {0} \
      PS_USE_FPD_CCI_NOC0 {0} \
      PS_USE_FPD_CCI_NOC1 {0} \
      PS_USE_FPD_CCI_NOC2 {0} \
      PS_USE_FPD_CCI_NOC3 {0} \
      PS_USE_FTM_GPI {0} \
      PS_USE_FTM_GPO {0} \
      PS_USE_HSDP_PL {0} \
      PS_USE_MJTAG_TCK_TIE_OFF {0} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_M_AXI_LPD {0} \
      PS_USE_NOC_FPD_AXI0 {0} \
      PS_USE_NOC_FPD_AXI1 {0} \
      PS_USE_NOC_FPD_CCI0 {0} \
      PS_USE_NOC_FPD_CCI1 {0} \
      PS_USE_NOC_LPD_AXI0 {0} \
      PS_USE_NOC_PS_PCI_0 {0} \
      PS_USE_NOC_PS_PMC_0 {0} \
      PS_USE_NPI_CLK {0} \
      PS_USE_NPI_RST {0} \
      PS_USE_PL_FPD_AUX_REF_CLK {0} \
      PS_USE_PL_LPD_AUX_REF_CLK {0} \
      PS_USE_PMC {0} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {0} \
      PS_USE_PMCPL_CLK2 {0} \
      PS_USE_PMCPL_CLK3 {0} \
      PS_USE_PMCPL_IRO_CLK {0} \
      PS_USE_PSPL_IRQ_FPD {0} \
      PS_USE_PSPL_IRQ_LPD {0} \
      PS_USE_PSPL_IRQ_PMC {0} \
      PS_USE_PS_NOC_PCI_0 {0} \
      PS_USE_PS_NOC_PCI_1 {0} \
      PS_USE_PS_NOC_PMC_0 {0} \
      PS_USE_PS_NOC_PMC_1 {0} \
      PS_USE_RPU_EVENT {0} \
      PS_USE_RPU_INTERRUPT {0} \
      PS_USE_RTC {0} \
      PS_USE_SMMU {0} \
      PS_USE_STARTUP {0} \
      PS_USE_STM {0} \
      PS_USE_S_ACP_FPD {0} \
      PS_USE_S_AXI_ACE {0} \
      PS_USE_S_AXI_FPD {0} \
      PS_USE_S_AXI_GP2 {0} \
      PS_USE_S_AXI_LPD {0} \
      PS_USE_TRACE_ATB {0} \
      PS_WDT0_REF_CTRL_ACT_FREQMHZ {100} \
      PS_WDT0_REF_CTRL_FREQMHZ {100} \
      PS_WDT0_REF_CTRL_SEL {NONE} \
      PS_WDT1_REF_CTRL_ACT_FREQMHZ {100} \
      PS_WDT1_REF_CTRL_FREQMHZ {100} \
      PS_WDT1_REF_CTRL_SEL {NONE} \
      PS_WWDT0_CLK {{ENABLE 0} {IO {PMC_MIO 0}}} \
      PS_WWDT0_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 0 .. 5}}} \
      PS_WWDT1_CLK {{ENABLE 0} {IO {PMC_MIO 6}}} \
      PS_WWDT1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 6 .. 11}}} \
      SEM_ERROR_HANDLE_OPTIONS {Detect & Correct} \
      SEM_EVENT_LOG_OPTIONS {Log & Notify} \
      SEM_MEM_BUILT_IN_SELF_TEST {0} \
      SEM_MEM_ENABLE_ALL_TEST_FEATURE {0} \
      SEM_MEM_ENABLE_SCAN_AFTER {Immediate Start} \
      SEM_MEM_GOLDEN_ECC {0} \
      SEM_MEM_GOLDEN_ECC_SW {0} \
      SEM_MEM_SCAN {0} \
      SEM_NPI_BUILT_IN_SELF_TEST {0} \
      SEM_NPI_ENABLE_ALL_TEST_FEATURE {0} \
      SEM_NPI_ENABLE_SCAN_AFTER {Immediate Start} \
      SEM_NPI_GOLDEN_CHECKSUM_SW {0} \
      SEM_NPI_SCAN {0} \
      SEM_TIME_INTERVAL_BETWEEN_SCANS {80} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {99.999} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {12} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_FREQMHZ {100} \
      SLR1_PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {33.33} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {36} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_FREQMHZ {33.333} \
      SLR1_PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      SLR1_PMC_HSM0_CLK_ENABLE {1} \
      SLR1_PMC_HSM0_CLK_OUT_ENABLE {0} \
      SLR1_PMC_HSM1_CLK_ENABLE {1} \
      SLR1_PMC_HSM1_CLK_OUT_ENABLE {0} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {99.999} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {12} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_FREQMHZ {100} \
      SLR2_PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {33.33} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {36} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_FREQMHZ {33.333} \
      SLR2_PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      SLR2_PMC_HSM0_CLK_ENABLE {1} \
      SLR2_PMC_HSM0_CLK_OUT_ENABLE {0} \
      SLR2_PMC_HSM1_CLK_ENABLE {1} \
      SLR2_PMC_HSM1_CLK_OUT_ENABLE {0} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {99.999} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {12} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_FREQMHZ {100} \
      SLR3_PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {33.33} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {36} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_FREQMHZ {33.333} \
      SLR3_PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
      SLR3_PMC_HSM0_CLK_ENABLE {1} \
      SLR3_PMC_HSM0_CLK_OUT_ENABLE {0} \
      SLR3_PMC_HSM1_CLK_ENABLE {1} \
      SLR3_PMC_HSM1_CLK_OUT_ENABLE {0} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_INT_VOLTAGE_MONITORING {0} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_HI_PERF_MODE {1} \
      SMON_INTERFACE_TO_USE {None} \
      SMON_INT_MEASUREMENT_ALARM_ENABLE {0} \
      SMON_INT_MEASUREMENT_AVG_ENABLE {0} \
      SMON_INT_MEASUREMENT_ENABLE {0} \
      SMON_INT_MEASUREMENT_MODE {0} \
      SMON_INT_MEASUREMENT_TH_HIGH {0} \
      SMON_INT_MEASUREMENT_TH_LOW {0} \
      SMON_MEAS0 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_103} {SUPPLY_NUM 0}} \
      SMON_MEAS1 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_104} {SUPPLY_NUM 0}} \
      SMON_MEAS10 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_206} {SUPPLY_NUM 0}} \
      SMON_MEAS100 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS101 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS102 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS103 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS104 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS105 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS106 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS107 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS108 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS109 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS11 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_103} {SUPPLY_NUM 0}} \
      SMON_MEAS110 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS111 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS112 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS113 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS114 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS115 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS116 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS117 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS118 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS119 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS12 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_104} {SUPPLY_NUM 0}} \
      SMON_MEAS120 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS121 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS122 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS123 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS124 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS125 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS126 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS127 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS128 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS129 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS13 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_105} {SUPPLY_NUM 0}} \
      SMON_MEAS130 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS131 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS132 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS133 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS134 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS135 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS136 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS137 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS138 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS139 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS14 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_106} {SUPPLY_NUM 0}} \
      SMON_MEAS140 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS141 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS142 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS143 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS144 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS145 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS146 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS147 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS148 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS149 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS15 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_200} {SUPPLY_NUM 0}} \
      SMON_MEAS150 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS151 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS152 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS153 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS154 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS155 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS156 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS157 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS158 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS159 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS16 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_201} {SUPPLY_NUM 0}} \
      SMON_MEAS160 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS161 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS162 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCINT}} \
      SMON_MEAS163 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX}} \
      SMON_MEAS164 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_RAM}} \
      SMON_MEAS165 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC}} \
      SMON_MEAS166 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP}} \
      SMON_MEAS167 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP}} \
      SMON_MEAS168 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC}} \
      SMON_MEAS169 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC}} \
      SMON_MEAS17 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_202} {SUPPLY_NUM 0}} \
      SMON_MEAS170 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS171 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS172 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS173 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS174 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS175 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103}} \
      SMON_MEAS18 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_203} {SUPPLY_NUM 0}} \
      SMON_MEAS19 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_204} {SUPPLY_NUM 0}} \
      SMON_MEAS2 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_105} {SUPPLY_NUM 0}} \
      SMON_MEAS20 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_205} {SUPPLY_NUM 0}} \
      SMON_MEAS21 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCC_206} {SUPPLY_NUM 0}} \
      SMON_MEAS22 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_103} {SUPPLY_NUM 0}} \
      SMON_MEAS23 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_104} {SUPPLY_NUM 0}} \
      SMON_MEAS24 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_105} {SUPPLY_NUM 0}} \
      SMON_MEAS25 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_106} {SUPPLY_NUM 0}} \
      SMON_MEAS26 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_200} {SUPPLY_NUM 0}} \
      SMON_MEAS27 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_201} {SUPPLY_NUM 0}} \
      SMON_MEAS28 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_202} {SUPPLY_NUM 0}} \
      SMON_MEAS29 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_203} {SUPPLY_NUM 0}} \
      SMON_MEAS3 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_106} {SUPPLY_NUM 0}} \
      SMON_MEAS30 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_204} {SUPPLY_NUM 0}} \
      SMON_MEAS31 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_205} {SUPPLY_NUM 0}} \
      SMON_MEAS32 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVTT_206} {SUPPLY_NUM 0}} \
      SMON_MEAS33 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX} {SUPPLY_NUM 0}} \
      SMON_MEAS34 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS35 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCAUX_SMON} {SUPPLY_NUM 0}} \
      SMON_MEAS36 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCINT} {SUPPLY_NUM 0}} \
      SMON_MEAS37 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_306} {SUPPLY_NUM 0}} \
      SMON_MEAS38 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_406} {SUPPLY_NUM 0}} \
      SMON_MEAS39 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_500} {SUPPLY_NUM 0}} \
      SMON_MEAS4 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_200} {SUPPLY_NUM 0}} \
      SMON_MEAS40 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_501} {SUPPLY_NUM 0}} \
      SMON_MEAS41 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_502} {SUPPLY_NUM 0}} \
      SMON_MEAS42 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {4 V unipolar}} {NAME VCCO_503} {SUPPLY_NUM 0}} \
      SMON_MEAS43 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_700} {SUPPLY_NUM 0}} \
      SMON_MEAS44 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_701} {SUPPLY_NUM 0}} \
      SMON_MEAS45 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_702} {SUPPLY_NUM 0}} \
      SMON_MEAS46 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_703} {SUPPLY_NUM 0}} \
      SMON_MEAS47 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_704} {SUPPLY_NUM 0}} \
      SMON_MEAS48 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_705} {SUPPLY_NUM 0}} \
      SMON_MEAS49 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_706} {SUPPLY_NUM 0}} \
      SMON_MEAS5 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_201} {SUPPLY_NUM 0}} \
      SMON_MEAS50 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_707} {SUPPLY_NUM 0}} \
      SMON_MEAS51 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_708} {SUPPLY_NUM 0}} \
      SMON_MEAS52 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_709} {SUPPLY_NUM 0}} \
      SMON_MEAS53 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_710} {SUPPLY_NUM 0}} \
      SMON_MEAS54 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCCO_711} {SUPPLY_NUM 0}} \
      SMON_MEAS55 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_BATT} {SUPPLY_NUM 0}} \
      SMON_MEAS56 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS57 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSFP} {SUPPLY_NUM 0}} \
      SMON_MEAS58 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_PSLP} {SUPPLY_NUM 0}} \
      SMON_MEAS59 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_RAM} {SUPPLY_NUM 0}} \
      SMON_MEAS6 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_202} {SUPPLY_NUM 0}} \
      SMON_MEAS60 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME VCC_SOC} {SUPPLY_NUM 0}} \
      SMON_MEAS61 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 1.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {1 V unipolar}} {NAME VP_VN} {SUPPLY_NUM 0}} \
      SMON_MEAS62 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS63 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS64 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS65 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS66 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS67 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS68 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS69 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS7 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_203} {SUPPLY_NUM 0}} \
      SMON_MEAS70 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS71 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS72 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS73 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS74 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS75 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS76 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS77 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS78 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS79 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS8 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_204} {SUPPLY_NUM 0}} \
      SMON_MEAS80 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS81 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS82 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS83 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS84 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS85 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS86 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS87 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS88 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS89 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS9 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE {2 V unipolar}} {NAME GTY_AVCCAUX_205} {SUPPLY_NUM 0}} \
      SMON_MEAS90 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS91 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS92 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS93 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS94 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS95 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS96 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS97 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS98 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEAS99 {{ALARM_ENABLE 0} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 0} {MODE None} {NAME GT_AVAUX_PKG_103} {SUPPLY_NUM 0}} \
      SMON_MEASUREMENT_COUNT {62} \
      SMON_MEASUREMENT_LIST {BANK_VOLTAGE:GTY_AVTT-GTY_AVTT_103,GTY_AVTT_104,GTY_AVTT_105,GTY_AVTT_106,GTY_AVTT_200,GTY_AVTT_201,GTY_AVTT_202,GTY_AVTT_203,GTY_AVTT_204,GTY_AVTT_205,GTY_AVTT_206#VCC-GTY_AVCC_103,GTY_AVCC_104,GTY_AVCC_105,GTY_AVCC_106,GTY_AVCC_200,GTY_AVCC_201,GTY_AVCC_202,GTY_AVCC_203,GTY_AVCC_204,GTY_AVCC_205,GTY_AVCC_206#VCCAUX-GTY_AVCCAUX_103,GTY_AVCCAUX_104,GTY_AVCCAUX_105,GTY_AVCCAUX_106,GTY_AVCCAUX_200,GTY_AVCCAUX_201,GTY_AVCCAUX_202,GTY_AVCCAUX_203,GTY_AVCCAUX_204,GTY_AVCCAUX_205,GTY_AVCCAUX_206#VCCO-VCCO_306,VCCO_406,VCCO_500,VCCO_501,VCCO_502,VCCO_503,VCCO_700,VCCO_701,VCCO_702,VCCO_703,VCCO_704,VCCO_705,VCCO_706,VCCO_707,VCCO_708,VCCO_709,VCCO_710,VCCO_711|DEDICATED_PAD:VP-VP_VN|SUPPLY_VOLTAGE:VCC-VCC_BATT,VCC_PMC,VCC_PSFP,VCC_PSLP,VCC_RAM,VCC_SOC#VCCAUX-VCCAUX,VCCAUX_PMC,VCCAUX_SMON#VCCINT-VCCINT}\
\
      SMON_OT {{THRESHOLD_LOWER 70} {THRESHOLD_UPPER 125}} \
      SMON_PMBUS_ADDRESS {0x0} \
      SMON_PMBUS_UNRESTRICTED {0} \
      SMON_REFERENCE_SOURCE {Internal} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
      SMON_TEMP_THRESHOLD {0} \
      SMON_USER_TEMP {{THRESHOLD_LOWER 70} {THRESHOLD_UPPER 125} {USER_ALARM_TYPE hysteresis}} \
      SMON_VAUX_CH0 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH0} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH1 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH1} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH10 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH10} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH11 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH11} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH12 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH12} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH13 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH13} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH14 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH14} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH15 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH15} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH2 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH2} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH3 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH3} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH4 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH4} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH5 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH5} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH6 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH6} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH7 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH7} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH8 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH8} {SUPPLY_NUM 0}} \
      SMON_VAUX_CH9 {{ALARM_ENABLE 0} {ALARM_LOWER 0} {ALARM_UPPER 1} {AVERAGE_EN 0} {ENABLE 0} {IO_N PMC_MIO1_500} {IO_P PMC_MIO0_500} {MODE {1 V unipolar}} {NAME VAUX_CH9} {SUPPLY_NUM 0}} \
      SMON_VAUX_IO_BANK {MIO_BANK0} \
      SMON_VOLTAGE_AVERAGING_SAMPLES {None} \
      SPP_PSPMC_FROM_CORE_WIDTH {12000} \
      SPP_PSPMC_TO_CORE_WIDTH {12000} \
      SUBPRESET1 {Custom} \
      USE_UART0_IN_DEVICE_BOOT {0} \
      preset {None} \
    } \
    CONFIG.PS_PMC_CONFIG_APPLIED {1} \
  ] $versal_cips_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: rtl_block_0, and set properties
  set block_name rtl_block
  set block_cell_name rtl_block_0
  if { [catch {set rtl_block_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rtl_block_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets smartconnect_0_M00_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axis_ila_0/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets smartconnect_0_M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]

  # Create port connections
  connect_bd_net -net Binary_Counter_CE [get_bd_pins axis_vio_0/probe_out0] [get_bd_pins c_counter_binary_0/CE]
  connect_bd_net -net Binary_Counter_L [get_bd_pins axis_vio_0/probe_out4] [get_bd_pins c_counter_binary_0/L]
  connect_bd_net -net Binary_Counter_LOAD [get_bd_pins axis_vio_0/probe_out3] [get_bd_pins c_counter_binary_0/LOAD]
  connect_bd_net -net Binary_Counter_SCLR [get_bd_pins axis_vio_0/probe_out1] [get_bd_pins c_counter_binary_0/SCLR]
  connect_bd_net -net Binary_Counter_UP [get_bd_pins axis_vio_0/probe_out2] [get_bd_pins c_counter_binary_0/UP]
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins c_counter_binary_0/Q] [get_bd_pins axis_ila_0/probe0] [get_bd_pins axis_vio_0/probe_in0] [get_bd_pins xlslice_0/Din]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets c_counter_binary_0_Q]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axis_ila_0/clk] [get_bd_pins axis_vio_0/clk] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins dds_compiler_0/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk] [get_bd_pins rtl_block_0/clk]
  connect_bd_net -net dds_compiler_0_m_axis_data_tdata [get_bd_pins dds_compiler_0/m_axis_data_tdata] [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins axis_ila_0/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets dds_compiler_0_m_axis_data_tdata]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axis_ila_0/resetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net rtlcounter_0_Q [get_bd_pins rtl_block_0/Q] [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins axis_ila_0/probe2]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets rtlcounter_0_Q]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins dds_compiler_0/s_axis_phase_tvalid]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins xlslice_0/Dout] [get_bd_pins dds_compiler_0/s_axis_phase_tdata]

  # Create address segments
  assign_bd_address -offset 0xA4000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force


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


