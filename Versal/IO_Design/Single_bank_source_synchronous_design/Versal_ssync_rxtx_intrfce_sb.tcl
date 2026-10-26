#*****************************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Versal_ssync_rxtx_intrfce_sb.tcl: Tcl script for re-creating project 'Versal_ssync_rxtx_intrfce_sb'
#
# In order to re-create the project, please source this file in the Vivado Tcl Shell.
#
#*****************************************************************************************
# NOTE: In order to use this script for source control purposes, please make sure that the
#       following files are added to the source control system:-
#
# 1. This project restoration tcl script (Versal_ssync_rxtx_intrfce_sb.tcl).
#
# 2. The following source(s) files that were imported into the project.
#    (Please see the '$orig_proj_dir' and '$origin_dir' variable setting below at the start of the script)
#
#    "Prbs_Any.vhd"
#    "Prbs_RxTx.vhd"
#    "toplevel_sb.sv"
#    "toplevel_sb.xdc"
#    "toplevel_testbench_sb.sv"
#    "toplevel_sim_sb.sv"
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "Versal_ssync_rxtx_intrfce_sb"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "Versal_ssync_rxtx_intrfce_sb.tcl"

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
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xcvc1902-vsva2197-2MP-e-S

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "" -objects $obj
set_property -name "compxlib.activehdl_compiled_library_dir" -value "$proj_dir/${_xil_proj_name_}.cache/compile_simlib/activehdl" -objects $obj
set_property -name "compxlib.funcsim" -value "1" -objects $obj
set_property -name "compxlib.ies_compiled_library_dir" -value "$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies" -objects $obj
set_property -name "compxlib.modelsim_compiled_library_dir" -value "$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim" -objects $obj
set_property -name "compxlib.overwrite_libs" -value "0" -objects $obj
set_property -name "compxlib.questa_compiled_library_dir" -value "$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa" -objects $obj
set_property -name "compxlib.riviera_compiled_library_dir" -value "$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera" -objects $obj
set_property -name "compxlib.timesim" -value "1" -objects $obj
set_property -name "compxlib.vcs_compiled_library_dir" -value "$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs" -objects $obj
set_property -name "compxlib.xsim_compiled_library_dir" -value "" -objects $obj
set_property -name "corecontainer.enable" -value "0" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_optional_runs_sta" -value "0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "generate_ip_upgrade_log" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_interface_inference_priority" -value "" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "legacy_ip_repo_paths" -value "" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xcvc1902-vsva2197-2MP-e-S" -objects $obj
set_property -name "platform.default_output_type" -value "undefined" -objects $obj
set_property -name "platform.design_intent.datacenter" -value "undefined" -objects $obj
set_property -name "platform.design_intent.embedded" -value "undefined" -objects $obj
set_property -name "platform.design_intent.external_host" -value "undefined" -objects $obj
set_property -name "platform.design_intent.server_managed" -value "undefined" -objects $obj
set_property -name "platform.rom.debug_type" -value "0" -objects $obj
set_property -name "platform.rom.prom_type" -value "0" -objects $obj
set_property -name "platform.slrconstraintmode" -value "0" -objects $obj
set_property -name "preferred_sim_model" -value "rtl" -objects $obj
set_property -name "project_type" -value "Default" -objects $obj
set_property -name "pr_flow" -value "0" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "sim.use_ip_compiled_libs" -value "1" -objects $obj
set_property -name "simulator.activehdl_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.activehdl_install_dir" -value "" -objects $obj
set_property -name "simulator.ies_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.ies_install_dir" -value "" -objects $obj
set_property -name "simulator.modelsim_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.modelsim_install_dir" -value "" -objects $obj
set_property -name "simulator.questa_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.questa_install_dir" -value "" -objects $obj
set_property -name "simulator.riviera_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.riviera_install_dir" -value "" -objects $obj
set_property -name "simulator.vcs_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.vcs_install_dir" -value "" -objects $obj
set_property -name "simulator.xcelium_gcc_install_dir" -value "" -objects $obj
set_property -name "simulator.xcelium_install_dir" -value "" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "source_mgmt_mode" -value "All" -objects $obj
set_property -name "target_language" -value "Verilog" -objects $obj
set_property -name "target_simulator" -value "XSim" -objects $obj
set_property -name "tool_flow" -value "Vivado" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "7" -objects $obj
set_property -name "webtalk.ies_export_sim" -value "7" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "7" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "7" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "7" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "7" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "7" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj
set_property -name "xsim.array_display_limit" -value "1024" -objects $obj
set_property -name "xsim.radix" -value "hex" -objects $obj
set_property -name "xsim.time_unit" -value "ns" -objects $obj
set_property -name "xsim.trace_limit" -value "65536" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/Design/Prbs_Any.vhd"]\
 [file normalize "${origin_dir}/Design/Prbs_RxTx.vhd"]\
 [file normalize "${origin_dir}/Design/toplevel_sb.sv"]\
]
set imported_files [import_files -fileset sources_1 $files]

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "Design/Prbs_Any.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis simulation" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

set file "Design/Prbs_RxTx.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis simulation" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

set file "Design/toplevel_sb.sv"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_simulation" -value "0" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "design_mode" -value "RTL" -objects $obj
set_property -name "edif_extra_search_paths" -value "" -objects $obj
set_property -name "elab_link_dcps" -value "1" -objects $obj
set_property -name "elab_load_timing_constraints" -value "1" -objects $obj
set_property -name "generic" -value "" -objects $obj
set_property -name "include_dirs" -value "" -objects $obj
set_property -name "lib_map_file" -value "" -objects $obj
set_property -name "loop_count" -value "1000" -objects $obj
set_property -name "name" -value "sources_1" -objects $obj
set_property -name "top" -value "toplevel_sb" -objects $obj
set_property -name "verilog_define" -value "" -objects $obj
set_property -name "verilog_uppercase" -value "0" -objects $obj
set_property -name "verilog_version" -value "verilog_2001" -objects $obj
set_property -name "vhdl_version" -value "vhdl_2k" -objects $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize ${origin_dir}/Constraints/toplevel_sb.xdc]"
set file_imported [import_files -fileset constrs_1 [list $file]]
set file "Constraints/toplevel_sb.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "processing_order" -value "NORMAL" -objects $file_obj
set_property -name "scoped_to_cells" -value "" -objects $file_obj
set_property -name "scoped_to_ref" -value "" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "constrs_type" -value "XDC" -objects $obj
set_property -name "name" -value "constrs_1" -objects $obj
set_property -name "target_constrs_file" -value "" -objects $obj
set_property -name "target_part" -value "xcvc1902-vsva2197-2MP-e-S" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/Simulation/toplevel_testbench_sb.sv"]\
 [file normalize "${origin_dir}/Simulation/toplevel_sim_sb.sv"]\
]
set imported_files [import_files -fileset sim_1 $files]

# Set 'sim_1' fileset file properties for remote files
# None

# Set 'sim_1' fileset file properties for local files
set file "Simulation/toplevel_testbench_sb.sv"
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

set file "Simulation/toplevel_sim_sb.sv"
set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj


# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "32bit" -value "0" -objects $obj
set_property -name "force_compile_glbl" -value "0" -objects $obj
set_property -name "generate_scripts_only" -value "0" -objects $obj
set_property -name "generic" -value "" -objects $obj
set_property -name "hbs.configure_design_for_hier_access" -value "1" -objects $obj
set_property -name "include_dirs" -value "" -objects $obj
set_property -name "incremental" -value "1" -objects $obj
set_property -name "name" -value "sim_1" -objects $obj
set_property -name "nl.cell" -value "" -objects $obj
set_property -name "nl.incl_unisim_models" -value "0" -objects $obj
set_property -name "nl.process_corner" -value "slow" -objects $obj
set_property -name "nl.rename_top" -value "" -objects $obj
set_property -name "nl.sdf_anno" -value "1" -objects $obj
set_property -name "nl.write_all_overrides" -value "0" -objects $obj
set_property -name "source_set" -value "sources_1" -objects $obj
set_property -name "systemc_include_dirs" -value "" -objects $obj
set_property -name "top" -value "toplevel_testbench_sb" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj
set_property -name "transport_int_delay" -value "0" -objects $obj
set_property -name "transport_path_delay" -value "0" -objects $obj
set_property -name "unifast" -value "0" -objects $obj
set_property -name "verilog_define" -value "" -objects $obj
set_property -name "verilog_uppercase" -value "0" -objects $obj
set_property -name "xelab.dll" -value "0" -objects $obj
set_property -name "xsim.compile.tcl.pre" -value "" -objects $obj
set_property -name "xsim.compile.xsc.more_options" -value "" -objects $obj
set_property -name "xsim.compile.xvhdl.more_options" -value "" -objects $obj
set_property -name "xsim.compile.xvhdl.nosort" -value "1" -objects $obj
set_property -name "xsim.compile.xvhdl.relax" -value "1" -objects $obj
set_property -name "xsim.compile.xvlog.more_options" -value "" -objects $obj
set_property -name "xsim.compile.xvlog.nosort" -value "1" -objects $obj
set_property -name "xsim.compile.xvlog.relax" -value "1" -objects $obj
set_property -name "xsim.elaborate.debug_level" -value "typical" -objects $obj
set_property -name "xsim.elaborate.load_glbl" -value "1" -objects $obj
set_property -name "xsim.elaborate.mt_level" -value "auto" -objects $obj
set_property -name "xsim.elaborate.rangecheck" -value "0" -objects $obj
set_property -name "xsim.elaborate.relax" -value "1" -objects $obj
set_property -name "xsim.elaborate.sdf_delay" -value "sdfmax" -objects $obj
set_property -name "xsim.elaborate.snapshot" -value "" -objects $obj
set_property -name "xsim.elaborate.xelab.more_options" -value "" -objects $obj
set_property -name "xsim.elaborate.xsc.more_options" -value "" -objects $obj
set_property -name "xsim.simulate.add_positional" -value "0" -objects $obj
set_property -name "xsim.simulate.custom_tcl" -value "" -objects $obj
set_property -name "xsim.simulate.log_all_signals" -value "0" -objects $obj
set_property -name "xsim.simulate.no_quit" -value "0" -objects $obj
set_property -name "xsim.simulate.runtime" -value "1000ns" -objects $obj
set_property -name "xsim.simulate.saif" -value "" -objects $obj
set_property -name "xsim.simulate.saif_all_signals" -value "0" -objects $obj
set_property -name "xsim.simulate.saif_scope" -value "" -objects $obj
set_property -name "xsim.simulate.tcl.post" -value "" -objects $obj
set_property -name "xsim.simulate.wdb" -value "" -objects $obj
set_property -name "xsim.simulate.xsim.more_options" -value "" -objects $obj


########################
###    clk_source    ###
########################

update_compile_order -fileset sources_1
create_ip -name clk_wizard -vendor xilinx.com -library ip -version 1.0 -module_name clock_gen
set_property -dict [list CONFIG.Component_Name {clock_gen} CONFIG.PRIM_IN_FREQ {200} CONFIG.SECONDARY_IN_FREQ {144.000} CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {200,100.000,100.000,100.000,100.000,100.000,100.000} CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} CONFIG.CLKFBOUT_MULT {15.000000} CONFIG.DIVCLK_DIVIDE {1} CONFIG.CLKOUT1_DIVIDE {15.000000}] [get_ips clock_gen]
generate_target {instantiation_template} [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/clock_gen/clock_gen.xci]
update_compile_order -fileset sources_1
generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/clock_gen/clock_gen.xci]
catch { config_ip_cache -export [get_ips -all clock_gen] }
export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/clock_gen/clock_gen.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/clock_gen/clock_gen.xci]
launch_runs clock_gen_synth_1 -jobs 8
export_simulation -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/clock_gen/clock_gen.xci] -directory $proj_dir/${_xil_proj_name_}.ip_user_files/sim_scripts -ip_user_files_dir $proj_dir/${_xil_proj_name_}.ip_user_files -ipstatic_source_dir $proj_dir/${_xil_proj_name_}.ip_user_files/ipstatic -lib_map_path [list {modelsim=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim} {questa=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa} {ies=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies} {xcelium=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/xcelium} {vcs=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs} {riviera=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


########################
###    clk_source    ###
########################

##update_compile_order -fileset sources_1
##create_ip -name advanced_io_wizard -vendor xilinx.com -library ip -version 1.0 -module_name bank_705_clock_source
##set_property -dict [list CONFIG.Component_Name {bank_705_clock_source} CONFIG.DIFF_IO_T {DIFF_TERM_ADV} CONFIG.DIFFERENTIAL_IO_TERMINATION {TERM_100} CONFIG.DATA_SPEED {1800} CONFIG.PLL_CLK_SOURCE {IBUF_TO_PLL} CONFIG.INPUT_CLK_FREQ {200.000} CONFIG.ENABLE_PLLOUT1 {1} CONFIG.PLL0_PLLOUTCLK1 {225.000} CONFIG.REDUCE_CONTROL_SIG_EN {1} CONFIG.BIT_PERIOD {556} CONFIG.PLL_CLK {32.04891673562574} CONFIG.TX_WINDOW_VAL {556} CONFIG.RX_WINDOW_VAL {440} CONFIG.BUS0_IO_TYPE {DIFF} CONFIG.BUS0_STROBE_NAME {dummy_strobe} CONFIG.BUS0_STROBE_IO_TYPE {DIFF} CONFIG.BUS0_SIG_NAME {dummy_data} CONFIG.BUS1_DIR {RX} CONFIG.BUS1_IO_TYPE {DIFF} CONFIG.BUS1_SIG_TYPE {Input Clock} CONFIG.BUS1_STROBE_EN {0} CONFIG.BUS1_SIG_NAME {clk_705} CONFIG.BUS12_WRCLK_EN {0} CONFIG.DIFF_IO_STD {LVDS15}] [get_ips bank_705_clock_source]
##generate_target {instantiation_template} [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/bank_705_clock_source/bank_705_clock_source.xci]
##update_compile_order -fileset sources_1
##generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/bank_705_clock_source/bank_705_clock_source.xci]
##catch { config_ip_cache -export [get_ips -all bank_705_clock_source] }
##export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/bank_705_clock_source/bank_705_clock_source.xci] -no_script -sync -force -quiet
##create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/bank_705_clock_source/bank_705_clock_source.xci]
##launch_runs bank_705_clock_source_synth_1 -jobs 8
##export_simulation -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/bank_705_clock_source/bank_705_clock_source.xci] -directory $proj_dir/${_xil_proj_name_}.ip_user_files/sim_scripts -ip_user_files_dir $proj_dir/${_xil_proj_name_}.ip_user_files -ipstatic_source_dir $proj_dir/${_xil_proj_name_}.ip_user_files/ipstatic -lib_map_path [list {modelsim=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim} {questa=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa} {ies=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies} {xcelium=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/xcelium} {vcs=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs} {riviera=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


################
###    RX    ###
################

update_compile_order -fileset sources_1
create_ip -name advanced_io_wizard -vendor xilinx.com -library ip -version 1.0 -module_name Rx_1bank_ssync_intrfce
set_property -dict [list CONFIG.Component_Name {Rx_1bank_ssync_intrfce} CONFIG.DIFF_IO_T {DIFF_TERM_ADV} CONFIG.DIFFERENTIAL_IO_TERMINATION {TERM_100} CONFIG.CLK_TO_DATA_ALIGN {3} CONFIG.DATA_SPEED {1800} CONFIG.INPUT_CLK_FREQ {225.000} CONFIG.REDUCE_CONTROL_SIG_EN {1} CONFIG.BIT_PERIOD {556} CONFIG.PLL_CLK {32.04891673562574} CONFIG.TX_WINDOW_VAL {556} CONFIG.RX_WINDOW_VAL {440} CONFIG.BUS0_IO_TYPE {DIFF} CONFIG.BUS0_NUM_PINS {16} CONFIG.BUS0_STROBE_NAME {strobe} CONFIG.BUS0_STROBE_IO_TYPE {DIFF} CONFIG.BUS0_SIG_NAME {Rx_data_pins} CONFIG.BUS12_WRCLK_EN {0} CONFIG.DIFF_IO_STD {LVDS15}] [get_ips Rx_1bank_ssync_intrfce]
generate_target {instantiation_template} [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Rx_1bank_ssync_intrfce/Rx_1bank_ssync_intrfce.xci]
update_compile_order -fileset sources_1
generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Rx_1bank_ssync_intrfce/Rx_1bank_ssync_intrfce.xci]
catch { config_ip_cache -export [get_ips -all Rx_1bank_ssync_intrfce] }
export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Rx_1bank_ssync_intrfce/Rx_1bank_ssync_intrfce.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Rx_1bank_ssync_intrfce/Rx_1bank_ssync_intrfce.xci]
launch_runs Rx_1bank_ssync_intrfce_synth_1 -jobs 8
export_simulation -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Rx_1bank_ssync_intrfce/Rx_1bank_ssync_intrfce.xci] -directory $proj_dir/${_xil_proj_name_}.ip_user_files/sim_scripts -ip_user_files_dir $proj_dir/${_xil_proj_name_}.ip_user_files -ipstatic_source_dir $proj_dir/${_xil_proj_name_}.ip_user_files/ipstatic -lib_map_path [list {modelsim=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim} {questa=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa} {ies=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies} {xcelium=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/xcelium} {vcs=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs} {riviera=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet



################
###    TX    ###
################

update_compile_order -fileset sources_1
create_ip -name advanced_io_wizard -vendor xilinx.com -library ip -version 1.0 -module_name Tx_1bank_ssync_intrfce
set_property -dict [list CONFIG.Component_Name {Tx_1bank_ssync_intrfce} CONFIG.BUS_DIR {0} CONFIG.DATA_SPEED {1800} CONFIG.INPUT_CLK_FREQ {225.000} CONFIG.CLK_FWD_PHASE {90} CONFIG.REDUCE_CONTROL_SIG_EN {1} CONFIG.BIT_PERIOD {556} CONFIG.PLL_CLK {27.910135557902247} CONFIG.TX_IOB {74} CONFIG.RX_IOB {0.00} CONFIG.RX_PHY {0.00} CONFIG.TX_PHY {73} CONFIG.TX_WINDOW_VAL {409} CONFIG.RX_WINDOW_VAL {556} CONFIG.BUS0_DIR {TX} CONFIG.BUS0_IO_TYPE {DIFF} CONFIG.BUS0_STROBE_EN {0} CONFIG.BUS0_NUM_PINS {16} CONFIG.BUS0_SIG_NAME {Tx_data} CONFIG.BUS1_DIR {TX} CONFIG.BUS1_IO_TYPE {DIFF} CONFIG.BUS1_SIG_TYPE {Clk Fwd} CONFIG.BUS1_SIG_NAME {Clk_fwd} CONFIG.BUS12_WRCLK_EN {0} CONFIG.DIFF_IO_STD {LVDS15}] [get_ips Tx_1bank_ssync_intrfce]
generate_target {instantiation_template} [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Tx_1bank_ssync_intrfce/Tx_1bank_ssync_intrfce.xci]
update_compile_order -fileset sources_1
generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Tx_1bank_ssync_intrfce/Tx_1bank_ssync_intrfce.xci]
catch { config_ip_cache -export [get_ips -all Tx_1bank_ssync_intrfce] }
export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Tx_1bank_ssync_intrfce/Tx_1bank_ssync_intrfce.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Tx_1bank_ssync_intrfce/Tx_1bank_ssync_intrfce.xci]
launch_runs Tx_1bank_ssync_intrfce_synth_1 -jobs 8
export_simulation -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/Tx_1bank_ssync_intrfce/Tx_1bank_ssync_intrfce.xci] -directory $proj_dir/${_xil_proj_name_}.ip_user_files/sim_scripts -ip_user_files_dir $proj_dir/${_xil_proj_name_}.ip_user_files -ipstatic_source_dir $proj_dir/${_xil_proj_name_}.ip_user_files/ipstatic -lib_map_path [list {modelsim=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim} {questa=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa} {ies=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies} {xcelium=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/xcelium} {vcs=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs} {riviera=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


#################
###    VIO    ###
#################

update_compile_order -fileset sources_1
create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name vio_0
set_property -dict [list CONFIG.C_NUM_PROBE_OUT {7} CONFIG.C_NUM_PROBE_IN {8} CONFIG.Component_Name {vio_0}] [get_ips vio_0]
generate_target {instantiation_template} [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/vio_0/vio_0.xci]
update_compile_order -fileset sources_1
generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/vio_0/vio_0.xci]
catch { config_ip_cache -export [get_ips -all vio_0] }
export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/vio_0/vio_0.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/vio_0/vio_0.xci]
launch_runs vio_0_synth_1 -jobs 8


#################
###    ILA    ###
#################

update_compile_order -fileset sources_1
create_ip -name axis_ila -vendor xilinx.com -library ip -version 1.1 -module_name ila_0
set_property -dict [list CONFIG.C_BRAM_CNT {1.5} CONFIG.C_PROBE15_WIDTH {8} CONFIG.C_PROBE14_WIDTH {8} CONFIG.C_PROBE13_WIDTH {8} CONFIG.C_PROBE12_WIDTH {8} CONFIG.C_NUM_OF_PROBES {16} CONFIG.Component_Name {ila_0}] [get_ips ila_0]
generate_target {instantiation_template} [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/ila_0/ila_0.xci]
update_compile_order -fileset sources_1
generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/ila_0/ila_0.xci]
catch { config_ip_cache -export [get_ips -all ila_0] }
export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/ila_0/ila_0.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/ila_0/ila_0.xci]
launch_runs ila_0_synth_1 -jobs 8
export_simulation -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/ip/ila_0/ila_0.xci] -directory $proj_dir/${_xil_proj_name_}.ip_user_files/sim_scripts -ip_user_files_dir $proj_dir/${_xil_proj_name_}.ip_user_files -ipstatic_source_dir $proj_dir/${_xil_proj_name_}.ip_user_files/ipstatic -lib_map_path [list {modelsim=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim} {questa=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa} {ies=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies} {xcelium=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/xcelium} {vcs=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs} {riviera=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


################
###    BD    ###
################

update_compile_order -fileset sources_1
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:2.1 versal_cips_0
endgroup
set_property -dict [list CONFIG.PS_USE_PMCPL_CLK0 {1} CONFIG.PS_NUM_FABRIC_RESETS {1} CONFIG.PMC_USE_PMC_NOC_AXI0 {1}] [get_bd_cells versal_cips_0]
set_property location {0.5 -212 -163} [get_bd_cells versal_cips_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0
endgroup
set_property location {0.5 -1059 -262} [get_bd_cells versal_cips_0]
set_property location {1.5 -636 -89} [get_bd_cells clk_wizard_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
endgroup
startgroup
set_property -dict [list CONFIG.NUM_CLKS {2}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CATEGORY {ps_pmc}] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S00_AXI}] [get_bd_pins /axi_noc_0/aclk0]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {M00_AXI}] [get_bd_pins /axi_noc_0/aclk1]
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dbg_hub:2.0 axi_dbg_hub_0
endgroup
connect_bd_net [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
connect_bd_net [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
connect_bd_net [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins axi_noc_0/aclk1] [get_bd_pins clk_wizard_0/clk_out1]
connect_bd_net [get_bd_pins axi_dbg_hub_0/aclk] [get_bd_pins clk_wizard_0/clk_out1]
connect_bd_intf_net [get_bd_intf_pins axi_noc_0/M00_AXI] [get_bd_intf_pins axi_dbg_hub_0/S_AXI]
connect_bd_net [get_bd_pins axi_dbg_hub_0/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
validate_bd_design
assign_bd_address -target_address_space /versal_cips_0/DATA_PMC [get_bd_addr_segs axi_dbg_hub_0/S_AXI_DBG_HUB/Mem0] -force
save_bd_design
close_bd_design [get_bd_designs design_1]

set_property synth_checkpoint_mode Singular [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/design_1/design_1.bd]
generate_target all [get_files  $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/design_1/design_1.bd]
export_ip_user_files -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/design_1/design_1.bd]
launch_runs design_1_synth_1 -jobs 8
export_simulation -of_objects [get_files $proj_dir/${_xil_proj_name_}.srcs/sources_1/bd/design_1/design_1.bd] -directory $proj_dir/${_xil_proj_name_}.ip_user_files/sim_scripts -ip_user_files_dir $proj_dir/${_xil_proj_name_}.ip_user_files -ipstatic_source_dir $proj_dir/${_xil_proj_name_}.ip_user_files/ipstatic -lib_map_path [list {modelsim=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/modelsim} {questa=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/questa} {ies=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/ies} {xcelium=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/xcelium} {vcs=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/vcs} {riviera=$proj_dir/${_xil_proj_name_}.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet



########################
###    Launch Run    ###
########################

reset_run synth_1
launch_runs impl_1 -to_step write_device_image -jobs 8
