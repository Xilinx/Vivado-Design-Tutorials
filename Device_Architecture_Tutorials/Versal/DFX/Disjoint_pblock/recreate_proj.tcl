#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#
# recreate_new.tcl: Tcl script for re-creating project 'project_1'
#*****************************************************************************************

# Check file required for this script exists
proc checkRequiredFiles { origin_dir} {
  set status true
  set files [list \
 "[file normalize "$origin_dir/sources/constrs_1/new/constr.xdc"]"\
 "[file normalize "$origin_dir/sources/constrs_2/new/constr_2.xdc"]"\
 "[file normalize "$origin_dir/sources/constrs_3/new/constr_3.xdc"]"\
  ]
  foreach ifile $files {
    if { ![file isfile $ifile] } {
      puts " Could not find local file $ifile "
      set status false
    }
  }

  return $status
}
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "project_1"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "recreate_new.tcl"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/project_1"]"

# Check for paths and files needed for project creation
set validate_required 0
if { $validate_required } {
  if { [checkRequiredFiles $origin_dir] } {
    puts "Tcl file $script_file is valid. All files required for project creation is accesable. "
  } else {
    puts "Tcl file $script_file is not valid. Not all files required for project creation is accesable. "
    return
  }
}

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xcvp1502-vsva2785-3HP-e-S

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_resource_estimation" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "feature_set" -value "FeatureSet_Classic" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "pr_flow" -value "1" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "sim_compile_state" -value "1" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "9" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "9" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "9" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "9" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "9" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "9" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
# Import local files from the original project

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "dataflow_viewer_settings" -value "min_width=16" -objects $obj
set_property -name "top" -value "design_1_wrapper" -objects $obj

# Create 'bramctrl_rm_inst_1' fileset (if not found)
if {[string equal [get_filesets -quiet bramctrl_rm_inst_1] ""]} {
  create_fileset -blockset bramctrl_rm_inst_1
}

# Set 'bramctrl_rm_inst_1' fileset object
set obj [get_filesets bramctrl_rm_inst_1]
# Empty (no sources present)

# Set 'bramctrl_rm_inst_1' fileset properties
set obj [get_filesets bramctrl_rm_inst_1]
set_property -name "top" -value "bramctrl_rm_inst_1" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize ${origin_dir}/sources/constrs_1/new/constr.xdc]"
set file_add [add_files -fileset constrs_1 [list $file]]
set file "new/constr.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "used_in" -value "implementation" -objects $file_obj
set_property -name "used_in_synthesis" -value "0" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "${origin_dir}/sources/constrs_1/new/constr.xdc" -objects $obj
set_property -name "target_part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "target_ucf" -value "${origin_dir}/sources/constrs_1/new/constr.xdc" -objects $obj

# Create 'constrs_2' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_2] ""]} {
  create_fileset -constrset constrs_2
}

# Set 'constrs_2' fileset object
set obj [get_filesets constrs_2]

# Add/Import constrs file and set constrs file properties
set file "[file normalize ${origin_dir}/sources/constrs_2/new/constr_2.xdc]"
set file_add [add_files -fileset constrs_2 [list $file]]
set file "new/constr_2.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_2] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "used_in" -value "implementation" -objects $file_obj
set_property -name "used_in_synthesis" -value "0" -objects $file_obj

# Set 'constrs_2' fileset properties
set obj [get_filesets constrs_2]
set_property -name "target_part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj

# Create 'constrs_3' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_3] ""]} {
  create_fileset -constrset constrs_3
}

# Set 'constrs_3' fileset object
set obj [get_filesets constrs_3]

# Add/Import constrs file and set constrs file properties
set file "[file normalize ${origin_dir}/sources/constrs_3/new/constr_3.xdc]"
set file_add [add_files -fileset constrs_3 [list $file]]
set file "new/constr_3.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_3] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "used_in" -value "implementation" -objects $file_obj
set_property -name "used_in_synthesis" -value "0" -objects $file_obj

# Set 'constrs_3' fileset properties
set obj [get_filesets constrs_3]
set_property -name "target_part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "design_1_wrapper" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# Empty (no sources present)

# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]


# Adding sources referenced in BDs, if not already added


# Proc to create BD rp2rm1
proc cr_bd_rp2rm1 { parentCell } {

  # CHANGE DESIGN NAME HERE
  set design_name rp2rm1

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

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

  variable script_folder

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
  set S00_INI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S00_INI ]
  set_property -dict [ list \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {load} \
   ] $S00_INI
  set_property APERTURES {{0x201_8000_0000 16K}} [get_bd_intf_ports S00_INI]


  # Create ports
  set aclk0 [ create_bd_port -dir I -type clk -freq_hz 99999900 aclk0 ]
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]

  # Create instance: axi_bram_ctrl_1, and set properties
  set axi_bram_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_1 ]
  set_property CONFIG.DATA_WIDTH {64} $axi_bram_ctrl_1


  # Create instance: axi_bram_ctrl_1_bram, and set properties
  set axi_bram_ctrl_1_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 axi_bram_ctrl_1_bram ]
  set_property -dict [list \
    CONFIG.ADDR_WIDTH_A {13} \
    CONFIG.ADDR_WIDTH_B {13} \
    CONFIG.MEMORY_PRIMITIVE {BRAM} \
    CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
    CONFIG.USE_MEMORY_BLOCK {Memory_Controller} \
  ] $axi_bram_ctrl_1_bram


  # Create instance: axi_noc_2, and set properties
  set axi_noc_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_2 ]
  set_property -dict [list \
    CONFIG.HBM_CHNL0_CONFIG {HBM_PC0_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC1_PRE_DEFINED_ADDRESS_MAP ROW_BANK_COLUMN HBM_PC0_USER_DEFINED_ADDRESS_MAP NONE HBM_PC1_USER_DEFINED_ADDRESS_MAP NONE\
HBM_WRITE_BACK_CORRECTED_DATA TRUE} \
    CONFIG.MC_NETLIST_SIMULATION {true} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
  ] $axi_noc_2


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.APERTURES {{0x201_8000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_2/M00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /axi_noc_2/S00_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /axi_noc_2/aclk0]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_1_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_1_bram/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_noc_0_M01_INI [get_bd_intf_ports S00_INI] [get_bd_intf_pins axi_noc_2/S00_INI]
  connect_bd_intf_net -intf_net axi_noc_2_M00_AXI [get_bd_intf_pins axi_bram_ctrl_1/S_AXI] [get_bd_intf_pins axi_noc_2/M00_AXI]

  # Create port connections
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_ports aclk0] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk] [get_bd_pins axi_noc_2/aclk0]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_ports s_axi_aresetn] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn]

  # Create address segments
  assign_bd_address -offset 0x020180000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S00_INI] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_rp2rm1()

cr_bd_rp2rm1 ""
set_property REGISTERED_WITH_MANAGER "1" [get_files rp2rm1.bd ] 
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files rp2rm1.bd ] 



# Proc to create BD rp1rm1
proc cr_bd_rp1rm1 { parentCell } {

  # CHANGE DESIGN NAME HERE
  set design_name rp1rm1

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:axi_bram_ctrl:4.1\
  xilinx.com:ip:axi_noc:1.0\
  xilinx.com:ip:clk_wizard:1.0\
  xilinx.com:ip:emb_mem_gen:1.0\
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

  variable script_folder

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
  set S00_INI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S00_INI ]
  set_property -dict [ list \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {load} \
   ] $S00_INI


  # Create ports
  set clk_in1_0 [ create_bd_port -dir I -type clk clk_in1_0 ]
  set clkout_bramctrl [ create_bd_port -dir O -from 0 -to 0 clkout_bramctrl ]
  set ext_reset_in_1 [ create_bd_port -dir I -type rst ext_reset_in_1 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $ext_reset_in_1
  set regcea_0 [ create_bd_port -dir I regcea_0 ]
  set resetn_0 [ create_bd_port -dir I -type rst resetn_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $resetn_0

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1 ]
  set_property -dict [list \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
  ] $axi_noc_1


  set_property -dict [ list \
   CONFIG.APERTURES {{0x201_0000_0000 1G}} \
   CONFIG.CATEGORY {pl} \
 ] [get_bd_intf_pins /axi_noc_1/M00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /axi_noc_1/S00_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk0]

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFGCE,BUFGCE,BUFGCE,BUFGCE,BUFGCE,BUFGCE,BUFGCE} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {200.000,100.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,true,false,false,false,false,false} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.RESET_TYPE {ACTIVE_HIGH} \
    CONFIG.USE_SAFE_CLOCK_STARTUP {true} \
  ] $clk_wizard_0


  # Create instance: emb_mem_gen_0, and set properties
  set emb_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 emb_mem_gen_0 ]
  set_property CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} $emb_mem_gen_0


  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_noc_1/S00_INI] [get_bd_intf_ports S00_INI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins emb_mem_gen_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins emb_mem_gen_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_noc_1_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_noc_1/M00_AXI]

  # Create port connections
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_ports clkout_bramctrl] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_noc_1/aclk0]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net ext_reset_in_1_1 [get_bd_ports ext_reset_in_1] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
  connect_bd_net -net regcea_0_1 [get_bd_ports regcea_0] [get_bd_pins emb_mem_gen_0/regcea]
  connect_bd_net -net resetn_0_1 [get_bd_ports resetn_0] [get_bd_pins clk_wizard_0/reset]

  # Create address segments
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces S00_INI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_rp1rm1()

cr_bd_rp1rm1 ""
set_property REGISTERED_WITH_MANAGER "1" [get_files rp1rm1.bd ] 
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files rp1rm1.bd ] 



# Proc to create BD design_1
proc cr_bd_design_1 { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# block design container source references:
# rp1rm1, rp2rm1



  # CHANGE DESIGN NAME HERE
  set design_name design_1

  common::send_gid_msg -ssname BD::TCL -id 2010 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:util_vector_logic:2.0\
  xilinx.com:ip:xlconstant:1.1\
  xilinx.com:ip:versal_cips:3.4\
  xilinx.com:ip:proc_sys_reset:5.0\
  xilinx.com:ip:c_counter_binary:12.0\
  xilinx.com:ip:xpm_cdc_gen:1.0\
  xilinx.com:ip:axi_noc:1.0\
  xilinx.com:ip:util_reduced_logic:2.0\
  xilinx.com:ip:clk_wizard:1.0\
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
  set list_bdc_active "rp1rm1, rp2rm1"

  array set map_bdc_missing {}
  set map_bdc_missing(ACTIVE) ""
  set map_bdc_missing(BDC) ""

  if { $bCheckSources == 1 } {
     set list_check_srcs "\ 
  rp1rm1 \
  rp2rm1 \
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk0_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 CH0_DDR4_0_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M00_INI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M01_INI_0


  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in_0
  create_bd_pin -dir I -type ce CE_0
  create_bd_pin -dir I -type rst reset_0
  create_bd_pin -dir I -type clk clk_in1_0
  create_bd_pin -dir O -from 0 -to 0 Res_0
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn_0
  create_bd_pin -dir I -type clk dest_clk_0
  create_bd_pin -dir O -type clk clk_out1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.4 versal_cips_0 ]
  set_property -dict [list \
    CONFIG.BOOT_MODE {Custom} \
    CONFIG.DDR_MEMORY_MODE {Custom} \
    CONFIG.DESIGN_MODE {0} \
    CONFIG.PS_PMC_CONFIG { \
      DDR_MEMORY_MODE {Custom} \
      DESIGN_MODE {0} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_BOARD_INTERFACE {Custom} \
      PS_NUM_FABRIC_RESETS {0} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {0} \
      PS_USE_PMCPL_CLK1 {0} \
      PS_USE_PMCPL_CLK2 {0} \
      PS_USE_PMCPL_CLK3 {0} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
  ] $versal_cips_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [list \
    CONFIG.CE {true} \
    CONFIG.Output_Width {64} \
    CONFIG.Sync_Threshold_Output {true} \
    CONFIG.Threshold_Value {1FFFF} \
  ] $c_counter_binary_0


  # Create instance: xpm_cdc_gen_0, and set properties
  set xpm_cdc_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 xpm_cdc_gen_0 ]
  set_property -dict [list \
    CONFIG.CDC_TYPE {xpm_cdc_handshake} \
    CONFIG.WIDTH {64} \
  ] $xpm_cdc_gen_0


  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CONTROLLERTYPE {DDR4_SDRAM} \
    CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
    CONFIG.NUM_CLKS {6} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {2} \
    CONFIG.NUM_NSI {0} \
    CONFIG.NUM_SI {6} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M00_INI {read_bw {500} write_bw {500}} MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /static_region/axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /static_region/axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /static_region/axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /static_region/axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /static_region/axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /static_region/axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /static_region/axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /static_region/axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /static_region/axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /static_region/axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /static_region/axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /static_region/axi_noc_0/aclk5]

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {xor} \
    CONFIG.C_SIZE {32} \
  ] $util_reduced_logic_0


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_RESET {true} \
  ] $clk_wizard_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_noc_0/M00_INI] [get_bd_intf_pins M00_INI_0]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_noc_0/M01_INI] [get_bd_intf_pins M01_INI_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_0 [get_bd_intf_pins CH0_DDR4_0_0] [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net sys_clk0_0_1 [get_bd_intf_pins sys_clk0_0] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S01_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S02_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S03_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S04_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S05_AXI]

  # Create port connections
  connect_bd_net -net CE_0_1 [get_bd_pins CE_0] [get_bd_pins c_counter_binary_0/CE]
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins c_counter_binary_0/Q] [get_bd_pins xpm_cdc_gen_0/src_in]
  connect_bd_net -net c_counter_binary_0_THRESH0 [get_bd_pins c_counter_binary_0/THRESH0] [get_bd_pins xpm_cdc_gen_0/src_send]
  connect_bd_net -net clk_in1_0_1 [get_bd_pins clk_in1_0] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins xpm_cdc_gen_0/src_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins clk_out1]
  connect_bd_net -net dest_clk_0_1 [get_bd_pins dest_clk_0] [get_bd_pins xpm_cdc_gen_0/dest_clk]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_pins ext_reset_in_0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins peripheral_aresetn_0]
  connect_bd_net -net reset_0_1 [get_bd_pins reset_0] [get_bd_pins clk_wizard_0/reset]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins Res_0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins versal_cips_0/lpd_axi_noc_clk] [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins xpm_cdc_gen_0/dest_ack]
  connect_bd_net -net xpm_cdc_gen_0_dest_out [get_bd_pins xpm_cdc_gen_0/dest_out] [get_bd_pins util_reduced_logic_0/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}
  variable script_folder

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
  set sys_clk0_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk0_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {400000000} \
   ] $sys_clk0_0

  set CH0_DDR4_0_0_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 CH0_DDR4_0_0_0 ]


  # Create ports
  set CE_0 [ create_bd_port -dir I -type ce CE_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $CE_0
  set clk_in1_0 [ create_bd_port -dir I -type clk clk_in1_0 ]
  set reset_0 [ create_bd_port -dir I -type rst reset_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_0
  set ext_reset_in_0 [ create_bd_port -dir I -type rst ext_reset_in_0 ]
  set clk_in1_0_0 [ create_bd_port -dir I -type clk clk_in1_0_0 ]

  # Create instance: static_region
  create_hier_cell_static_region [current_bd_instance .] static_region

  # Create instance: rp1rm1_0, and set properties
  set rp1rm1_0 [ create_bd_cell -type container -reference rp1rm1 rp1rm1_0 ]
  set_property -dict [list \
    CONFIG.ACTIVE_SIM_BD {rp1rm1.bd} \
    CONFIG.ACTIVE_SYNTH_BD {rp1rm1.bd} \
    CONFIG.ENABLE_DFX {true} \
    CONFIG.LIST_SIM_BD {rp1rm1.bd} \
    CONFIG.LIST_SYNTH_BD {rp1rm1.bd} \
    CONFIG.LOCK_PROPAGATE {0} \
  ] $rp1rm1_0


  # Create instance: rp2rm1_0, and set properties
  set rp2rm1_0 [ create_bd_cell -type container -reference rp2rm1 rp2rm1_0 ]
  set_property -dict [list \
    CONFIG.ACTIVE_SIM_BD {rp2rm1.bd} \
    CONFIG.ACTIVE_SYNTH_BD {rp2rm1.bd} \
    CONFIG.ENABLE_DFX {true} \
    CONFIG.LIST_SIM_BD {rp2rm1.bd} \
    CONFIG.LIST_SYNTH_BD {rp2rm1.bd} \
    CONFIG.LOCK_PROPAGATE {0} \
  ] $rp2rm1_0


  # Create interface connections
  connect_bd_intf_net -intf_net S00_INI_1 [get_bd_intf_pins rp2rm1_0/S00_INI] [get_bd_intf_pins static_region/M01_INI_0]
  connect_bd_intf_net -intf_net static_region_CH0_DDR4_0_0 [get_bd_intf_ports CH0_DDR4_0_0_0] [get_bd_intf_pins static_region/CH0_DDR4_0_0]
  connect_bd_intf_net -intf_net static_region_M00_INI_0 [get_bd_intf_pins static_region/M00_INI_0] [get_bd_intf_pins rp1rm1_0/S00_INI]
  connect_bd_intf_net -intf_net sys_clk0_0_1 [get_bd_intf_ports sys_clk0_0] [get_bd_intf_pins static_region/sys_clk0_0]

  # Create port connections
  connect_bd_net -net CE_0_1 [get_bd_ports CE_0] [get_bd_pins static_region/CE_0]
  connect_bd_net -net aclk0_1 [get_bd_pins static_region/clk_out1] [get_bd_pins rp2rm1_0/aclk0]
  connect_bd_net -net clk_in1_0_0_1 [get_bd_ports clk_in1_0_0] [get_bd_pins rp1rm1_0/clk_in1_0]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins static_region/clk_in1_0]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_ports ext_reset_in_0] [get_bd_pins static_region/ext_reset_in_0]
  connect_bd_net -net reset_0_1 [get_bd_ports reset_0] [get_bd_pins static_region/reset_0]
  connect_bd_net -net rp1rm1_0_clkout_bramctrl [get_bd_pins rp1rm1_0/clkout_bramctrl] [get_bd_pins static_region/dest_clk_0]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins static_region/peripheral_aresetn] [get_bd_pins rp2rm1_0/s_axi_aresetn]
  connect_bd_net -net static_region_Res_0 [get_bd_pins static_region/Res_0] [get_bd_pins rp1rm1_0/regcea_0]
  connect_bd_net -net static_region_peripheral_aresetn_0 [get_bd_pins static_region/peripheral_aresetn_0] [get_bd_pins rp1rm1_0/ext_reset_in_1] [get_bd_pins rp1rm1_0/resetn_0]

  # Create address segments
  assign_bd_address -offset 0x020100000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs rp1rm1_0/axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs static_region/axi_noc_0/S00_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs static_region/axi_noc_0/S00_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs static_region/axi_noc_0/S01_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs static_region/axi_noc_0/S01_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs static_region/axi_noc_0/S02_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs static_region/axi_noc_0/S02_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs static_region/axi_noc_0/S03_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs static_region/axi_noc_0/S03_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs static_region/axi_noc_0/S04_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs static_region/axi_noc_0/S04_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs static_region/axi_noc_0/S05_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces static_region/versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs static_region/axi_noc_0/S05_AXI/C2_DDR_LOW1] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_design_1()

cr_bd_design_1 ""
set_property REGISTERED_WITH_MANAGER "1" [get_files design_1.bd ] 
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files design_1.bd ] 

#call make_wrapper to create wrapper files
if { [get_property IS_LOCKED [ get_files -norecurse [list design_1.bd]] ] == 1  } {
  import_files -fileset sources_1 [file normalize "${origin_dir}/sources/design_1_wrapper.v" ]
} else {
  set wrapper_path [make_wrapper -fileset sources_1 -files [ get_files -norecurse [list design_1.bd]] -top]
  add_files -norecurse -fileset sources_1 $wrapper_path
}


generate_target all [get_files design_1.bd]

# Empty (no sources present)

# Empty (no sources present)

# Create 'config_1' pr configurations
create_pr_configuration -name config_1 -partitions [list design_1_i/rp1rm1_0:rp1rm1_inst_0 design_1_i/rp2rm1_0:rp2rm1_inst_0 ]
set obj [get_pr_configurations config_1]
set_property -name "auto_import" -value "1" -objects $obj
set_property -name "partition_cell_rms" -value "design_1_i/rp1rm1_0:rp1rm1_inst_0 design_1_i/rp2rm1_0:rp2rm1_inst_0" -objects $obj
set_property -name "use_blackbox" -value "1" -objects $obj


# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Synthesis 2023} -strategy "Vivado Synthesis Defaults" -report_strategy {Vivado Synthesis Default Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2023" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# Create 'rp1rm1_inst_0_synth_1' run (if not found)
if {[string equal [get_runs -quiet rp1rm1_inst_0_synth_1] ""]} {
    create_run -name rp1rm1_inst_0_synth_1 -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Synthesis 2023} -strategy "Vivado Synthesis Defaults" -report_strategy {Vivado Synthesis Default Reports} -constrset rp1rm1_inst_0
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs rp1rm1_inst_0_synth_1]
  set_property flow "Vivado Synthesis 2023" [get_runs rp1rm1_inst_0_synth_1]
}
set obj [get_runs rp1rm1_inst_0_synth_1]
set_property -name "constrset" -value "rp1rm1_inst_0" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# Create 'rp2rm1_inst_0_synth_1' run (if not found)
if {[string equal [get_runs -quiet rp2rm1_inst_0_synth_1] ""]} {
    create_run -name rp2rm1_inst_0_synth_1 -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Synthesis 2023} -strategy "Vivado Synthesis Defaults" -report_strategy {Vivado Synthesis Default Reports} -constrset rp2rm1_inst_0
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs rp2rm1_inst_0_synth_1]
  set_property flow "Vivado Synthesis 2023" [get_runs rp2rm1_inst_0_synth_1]
}
set obj [get_runs rp2rm1_inst_0_synth_1]
set_property -name "constrset" -value "rp2rm1_inst_0" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_BLI_ERROR' run (if not found)
if {[string equal [get_runs -quiet impl_BLI_ERROR] ""]} {
    create_run -name impl_BLI_ERROR -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Implementation 2023} -strategy "Vivado Implementation Defaults" -report_strategy {Vivado Implementation Default Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_BLI_ERROR]
  set_property flow "Vivado Implementation 2023" [get_runs impl_BLI_ERROR]
}
set_property pr_configuration config_1 [get_runs impl_BLI_ERROR]
delete_runs "impl_1"

# Create 'rp1rm1_inst_0_impl_1' run (if not found)
if {[string equal [get_runs -quiet rp1rm1_inst_0_impl_1] ""]} {
    create_run -name rp1rm1_inst_0_impl_1 -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Implementation 2023} -strategy "Vivado Implementation Defaults" -report_strategy {Vivado Implementation Default Reports} -constrset rp1rm1_inst_0 -parent_run rp1rm1_inst_0_synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs rp1rm1_inst_0_impl_1]
  set_property flow "Vivado Implementation 2023" [get_runs rp1rm1_inst_0_impl_1]
}

set obj [get_runs rp1rm1_inst_0_impl_1]
set_property -name "constrset" -value "rp1rm1_inst_0" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "include_in_archive" -value "0" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_device_image.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_device_image.args.verbose" -value "0" -objects $obj

# Create 'rp2rm1_inst_0_impl_1' run (if not found)
if {[string equal [get_runs -quiet rp2rm1_inst_0_impl_1] ""]} {
    create_run -name rp2rm1_inst_0_impl_1 -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Implementation 2023} -strategy "Vivado Implementation Defaults" -report_strategy {Vivado Implementation Default Reports} -constrset rp2rm1_inst_0 -parent_run rp2rm1_inst_0_synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs rp2rm1_inst_0_impl_1]
  set_property flow "Vivado Implementation 2023" [get_runs rp2rm1_inst_0_impl_1]
}

set obj [get_runs rp2rm1_inst_0_impl_1]
set_property -name "constrset" -value "rp2rm1_inst_0" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "include_in_archive" -value "0" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_device_image.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_device_image.args.verbose" -value "0" -objects $obj

# Create 'impl_SLL_ERROR' run (if not found)
if {[string equal [get_runs -quiet impl_SLL_ERROR] ""]} {
    create_run -name impl_SLL_ERROR -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Implementation 2023} -strategy "Vivado Implementation Defaults" -report_strategy {Vivado Implementation Default Reports} -constrset constrs_2 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_SLL_ERROR]
  set_property flow "Vivado Implementation 2023" [get_runs impl_SLL_ERROR]
}
set_property pr_configuration config_1 [get_runs impl_SLL_ERROR]

set obj [get_runs impl_SLL_ERROR]
set_property -name "constrset" -value "constrs_2" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_device_image.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_device_image.args.verbose" -value "0" -objects $obj

# Create 'impl_GUIDE_FIX' run (if not found)
if {[string equal [get_runs -quiet impl_GUIDE_FIX] ""]} {
    create_run -name impl_GUIDE_FIX -part xcvp1502-vsva2785-3HP-e-S -flow {Vivado Implementation 2023} -strategy "Performance_Auto_1" -report_strategy {Vivado Implementation Default Reports} -constrset constrs_3 -parent_run synth_1
} else {
  set_property strategy "Performance_Auto_1" [get_runs impl_GUIDE_FIX]
  set_property flow "Vivado Implementation 2023" [get_runs impl_GUIDE_FIX]
}
set_property pr_configuration config_1 [get_runs impl_GUIDE_FIX]

set obj [get_runs impl_GUIDE_FIX]
set_property -name "constrset" -value "constrs_3" -objects $obj
set_property -name "part" -value "xcvp1502-vsva2785-3HP-e-S" -objects $obj
set_property -name "strategy" -value "Performance_Auto_1" -objects $obj
set_property -name "steps.opt_design.args.directive" -value "Explore" -objects $obj
set_property -name "steps.place_design.args.directive" -value "Auto_1" -objects $obj
set_property -name "steps.phys_opt_design.args.directive" -value "AggressiveExplore" -objects $obj
set_property -name "steps.route_design.args.directive" -value "NoTimingRelaxation" -objects $obj
set_property -name "steps.write_device_image.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_device_image.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_BLI_ERROR]
catch {
 if { $idrFlowPropertiesConstraints != {} } {
   set_param runs.disableIDRFlowPropertyConstraints $idrFlowPropertiesConstraints
 }
}

puts "INFO: Project created:${_xil_proj_name_}"
# Create 'drc_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "drc_1" ] ] ""]} {
create_dashboard_gadget -name {drc_1} -type drc
}
set obj [get_dashboard_gadgets [ list "drc_1" ] ]
set_property -name "reports" -value "impl_BLI_ERROR#impl_BLI_ERROR_route_report_drc_0" -objects $obj

# Create 'methodology_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "methodology_1" ] ] ""]} {
create_dashboard_gadget -name {methodology_1} -type methodology
}
set obj [get_dashboard_gadgets [ list "methodology_1" ] ]
set_property -name "reports" -value "impl_BLI_ERROR#impl_BLI_ERROR_route_report_methodology_0" -objects $obj

# Create 'power_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "power_1" ] ] ""]} {
create_dashboard_gadget -name {power_1} -type power
}
set obj [get_dashboard_gadgets [ list "power_1" ] ]
set_property -name "reports" -value "impl_BLI_ERROR#impl_BLI_ERROR_route_report_power_0" -objects $obj

# Create 'timing_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "timing_1" ] ] ""]} {
create_dashboard_gadget -name {timing_1} -type timing
}
set obj [get_dashboard_gadgets [ list "timing_1" ] ]
set_property -name "reports" -value "impl_BLI_ERROR#impl_BLI_ERROR_route_report_timing_summary_0" -objects $obj

# Create 'utilization_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_1" ] ] ""]} {
create_dashboard_gadget -name {utilization_1} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_1" ] ]
set_property -name "reports" -value "synth_1#synth_1_synth_report_utilization_0" -objects $obj
set_property -name "run.step" -value "synth_design" -objects $obj
set_property -name "run.type" -value "synthesis" -objects $obj

# Create 'utilization_2' gadget (if not found)
if {[string equal [get_dashboard_gadgets  [ list "utilization_2" ] ] ""]} {
create_dashboard_gadget -name {utilization_2} -type utilization
}
set obj [get_dashboard_gadgets [ list "utilization_2" ] ]
set_property -name "reports" -value "impl_BLI_ERROR#impl_BLI_ERROR_place_report_utilization_0" -objects $obj

update_compile_order -fileset sources_1
#launch_runs synth_1 