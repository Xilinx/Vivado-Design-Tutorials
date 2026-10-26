#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

set origin_script [pwd]

#Create a new project, note -force is being used to simplify script flow
create_project project_github -force $origin_script/project_github -part xcvp1902-vsva6865-2MP-e-S

#Add RTL files and constraints to the project
add_files -norecurse $origin_script/Design/top_3bank_bypassfifo_vio.v
#add_files -fileset constrs_1 -norecurse $origin_script/rtl/top.xdc
add_files -fileset constrs_1 -norecurse $origin_script/Design/top.xdc
update_compile_order -fileset sources_1
set_property target_constrs_file $origin_script/Design/top.xdc [current_fileset -constrset]

#Block Design
create_bd_design "design_block"
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:ps_wizard:1.0 ps_wizard_0
endgroup
set_property -dict [list \
  CONFIG.PS_PMC_CONFIG(PMC_REF_CLK_FREQMHZ) {50.00} \
  CONFIG.PS_PMC_CONFIG(PS_SLR_ID) {0} \
] [get_bd_cells ps_wizard_0]
generate_target all [get_files  $origin_script/project_github/project_github.srcs/sources_1/bd/design_block/design_block.bd]


#Create Advanced IO Wizard
#Basic Tab (General/Clocking/Data And Control)
#  Component Name: advanced_io_single_bank
#  Application:		Source Synchronous
#  Bus Direction:	BiDir
#  BiDir Mode:		Independent WrClk RdClk
#  Interface Speed:	1800.0 Mbps
#  PLL Clock Source:	Fabric
#  PLL Input Clock:	100.00 MHz
#  Forward Clock:	90 degrees
#  Clock Data Rel:	Center DDR
#  Serialization:	8
#  3-State:			Combinatorial
#  Enable Bitslip:	No (Unchecked,not used for prbs testing)
#  Include PLL: 		yes (Check)
#
#Advanced Tab
#  Number of Banks:		1 (externally connecting banks in parallel for 3 banks)
#  Enable BLI Logic: 	No (disable and add externally if needed)
#  FIFO MODE: 			Yes (check to enable FIFO Mode Options)
#  FIFO Mode Options: 	BYPASS
#
#Pin Configuration
#Bus0 Configuration - 1st line
#  Pin Direction:	BIDIR
#  IO Type:			Single-ended
#  Signal Type:		Data
#  Strobe/RdClk IO:	Differential
#  Strobe/RdClk Name:	rxclk
#  WrClk IO:		Differential
#  WrClk Name:		wrclk
#  Signal Name:		data_pins
#  Number of data:	48

create_ip -name advanced_io_wizard -vendor xilinx.com -library ip -version 1.0 -module_name advanced_io_wizard_bidir_singlebank

set_property -dict [list \
  CONFIG.BIDIR_MODE {0} \
  CONFIG.BUS0_SIG_NAME {data_pins} \
  CONFIG.BUS0_STROBE_IO_TYPE {DIFF} \
  CONFIG.BUS0_STROBE_NAME {rxclk} \
  CONFIG.BUS0_WRCLK_IO_TYPE {DIFF} \
  CONFIG.BUS0_WRCLK_NAME {wrclk} \
  CONFIG.BUS_DIR {2} \
  CONFIG.CLK_FWD_PHASE {90} \
  CONFIG.CLK_TO_DATA_ALIGN {3} \
  CONFIG.DATA_SPEED {2600.00} \
  CONFIG.ENABLE_BLI {0} \
  CONFIG.FIFO_MODES {BYPASS} \
  CONFIG.FIFO_MODE_GUI_EN {1} \
  CONFIG.BUS0_NUM_PINS {48} \
] [get_ips advanced_io_wizard_bidir_singlebank]

generate_target {instantiation_template} [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/advanced_io_single_bank/advanced_io_wizard_bidir_singlebank.xci]
generate_target all [get_files  $origin_script/project_github/project_github.srcs/sources_1/ip/advanced_io_wizard_bidir_singlebank/advanced_io_wizard_bidir_singlebank.xci]
catch { config_ip_cache -export [get_ips -all advanced_io_wizard_bidir_singlebank] }
export_ip_user_files -of_objects [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/advanced_io_wizard_bidir_singlebank/advanced_io_wizard_bidir_singlebank.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $origin_script/project_github/project_github.srcs/sources_1/ip/advanced_io_wizard_bidir_singlebank/advanced_io_wizard_bidir_singlebank.xci]


# Create IP for VIO for bank reset controls
create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_vio_bank_reset_controls
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {0} \
  CONFIG.C_NUM_PROBE_OUT {6} \
] [get_ips axis_vio_bank_reset_controls]
generate_target {instantiation_template} [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_bank_reset_controls/axis_vio_bank_reset_controls.xci]
generate_target all [get_files  $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_bank_reset_controls/axis_vio_bank_reset_controls.xci]

catch { config_ip_cache -export [get_ips -all axis_vio_bank_reset_controls] }

export_ip_user_files -of_objects [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_bank_reset_controls/axis_vio_bank_reset_controls.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_bank_reset_controls/axis_vio_bank_reset_controls.xci]
launch_runs axis_vio_bank_reset_controls_synth_1 -jobs 2
export_simulation -of_objects [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_bank_reset_controls/axis_vio_bank_reset_controls.xci] -directory $origin_script/project_github/project_github.ip_user_files/sim_scripts -ip_user_files_dir $origin_script/project_github/project_github.ip_user_files -ipstatic_source_dir $origin_script/project_github/project_github.ip_user_files/ipstatic -lib_map_path [list {modelsim=$origin_script/project_github/project_github.cache/compile_simlib/modelsim} {questa=$origin_script/project_github/project_github.cache/compile_simlib/questa} {xcelium=$origin_script/project_github/project_github.cache/compile_simlib/xcelium} {vcs=$origin_script/project_github/project_github.cache/compile_simlib/vcs} {riviera=$origin_script/project_github/project_github.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet



# Create single bank ip
create_ip -name axis_vio -vendor xilinx.com -library ip -version 1.0 -module_name axis_vio_singlebank
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {1} \
  CONFIG.C_NUM_PROBE_OUT {3} \
  CONFIG.C_PROBE_IN0_WIDTH {64} \
  CONFIG.C_PROBE_OUT2_INIT_VAL {0x1} \
] [get_ips axis_vio_singlebank]
generate_target {instantiation_template} [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_singlebank/axis_vio_singlebank.xci]

catch { config_ip_cache -export [get_ips -all axis_vio_singlebank] }
export_ip_user_files -of_objects [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_singlebank/axis_vio_singlebank.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_singlebank/axis_vio_singlebank.xci]
export_simulation -of_objects [get_files $origin_script/project_github/project_github.srcs/sources_1/ip/axis_vio_singlebank/axis_vio_singlebank.xci] -directory $origin_script/project_github/project_github.ip_user_files/sim_scripts -ip_user_files_dir $origin_script/project_github/project_github.ip_user_files -ipstatic_source_dir $origin_script/project_github/project_github.ip_user_files/ipstatic -lib_map_path [list {modelsim=$origin_script/project_github/project_github.cache/compile_simlib/modelsim} {questa=$origin_script/project_github/project_github.cache/compile_simlib/questa} {xcelium=$origin_script/project_github/project_github.cache/compile_simlib/xcelium} {vcs=$origin_script/project_github/project_github.cache/compile_simlib/vcs} {riviera=$origin_script/project_github/project_github.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet



#Add simulation testbench if needed

set_property SOURCE_SET sources_1 [get_filesets sim_1]
#add_files -fileset sim_1 -norecurse $origin_script/rtl/tb_func_synth.wcfg
#add_files -fileset sim_1 -norecurse $origin_script/rtl/tb.sv
add_files -fileset sim_1 -norecurse $origin_script/Sim/tb_func_synth.wcfg
add_files -fileset sim_1 -norecurse $origin_script/Sim/tb.sv
update_compile_order -fileset sim_1

close_bd_design [current_bd_design]



