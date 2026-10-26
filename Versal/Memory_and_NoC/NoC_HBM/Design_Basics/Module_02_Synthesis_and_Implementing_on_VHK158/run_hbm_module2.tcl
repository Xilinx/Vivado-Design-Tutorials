set myPath [exec pwd]

create_project hbm_module_2 ${myPath}/hbm_module_2 -part xcvh1582-vsva3697-2MP-e-S
create_bd_design "design_1"

open_bd_design {${myPath}/hbm_module_2.srcs/sources_1/bd/design_1/design_1.bd}
update_compile_order -fileset sources_1

# NoC
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc axi_noc_0
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config { hbm_density {2} hbm_nmu {4} mc_type {HBM} noc_clk {New/Reuse Simulation Clock And Reset Generator} num_axi_bram {None} num_axi_tg {None} num_aximm_ext {None} num_mc_ddr {None} num_mc_lpddr {None} pl2noc_apm {1} pl2noc_cips {0}}  [get_bd_cells axi_noc_0]

regenerate_bd_layout
set_property CONFIG.HBM_REF_CLK_SELECTION {Internal} [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {HBM0_PORT0 {read_bw {12800} write_bw {12800} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/HBM00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {HBM0_PORT1 {read_bw {12800} write_bw {12800} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/HBM01_AXI]
set_property -dict [list CONFIG.CONNECTIONS {HBM0_PORT2 {read_bw {12800} write_bw {12800} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/HBM02_AXI]
set_property -dict [list CONFIG.CONNECTIONS {HBM0_PORT3 {read_bw {12800} write_bw {12800} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/HBM03_AXI]
delete_bd_objs [get_bd_intf_nets noc_clk_gen_SYS_CLK0]

# Simulation Clock and Reset Generator
set_property -dict [list CONFIG.USER_NUM_OF_SYS_CLK {0} CONFIG.USER_NUM_OF_AXI_CLK {1} CONFIG.USER_AXI_CLK_0_FREQ {300.000} ] [get_bd_cells noc_clk_gen]
regenerate_bd_layout

# AXI TG
set_property -dict [list CONFIG.USER_C_AXI_TEST_SELECT {user_defined_pattern} CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} CONFIG.USER_USR_DEFINED_PATTERN_CSV {../../../../../../../tg_sim_wr_followed_by_rd_0.csv} CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../tg_synth_wr_followed_by_rd_0.csv}] [get_bd_cells noc_tg]
set_property -dict [list CONFIG.USER_C_AXI_TEST_SELECT {user_defined_pattern} CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} CONFIG.USER_USR_DEFINED_PATTERN_CSV {../../../../../../../tg_sim_wr_followed_by_rd_1.csv} CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../tg_synth_wr_followed_by_rd_1.csv}] [get_bd_cells noc_tg_1]
set_property -dict [list CONFIG.USER_C_AXI_TEST_SELECT {user_defined_pattern} CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} CONFIG.USER_USR_DEFINED_PATTERN_CSV {../../../../../../../tg_sim_wr_followed_by_rd_2.csv} CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../tg_synth_wr_followed_by_rd_2.csv}] [get_bd_cells noc_tg_2]
set_property -dict [list CONFIG.USER_C_AXI_TEST_SELECT {user_defined_pattern} CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} CONFIG.USER_USR_DEFINED_PATTERN_CSV {../../../../../../../tg_sim_wr_followed_by_rd_3.csv} CONFIG.USER_SYNTH_DEFINED_PATTERN_CSV {../../../../../../../tg_synth_wr_followed_by_rd_3.csv}] [get_bd_cells noc_tg_3]

# CIPS
create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips versal_cips_0
set_property -dict [list CONFIG.CLOCK_MODE {Custom} CONFIG.PS_PMC_CONFIG { CLOCK_MODE {Custom} PMC_CRP_HSM0_REF_CTRL_FREQMHZ {33.333} PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} PS_NUM_FABRIC_RESETS {1} PS_USE_PMCPL_CLK0 {1} SMON_ALARMS {Set_Alarms_On} SMON_ENABLE_TEMP_AVERAGING {0} SMON_TEMP_AVERAGING_SAMPLES {0} } ] [get_bd_cells versal_cips_0]

# Processor System and Reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0

# Clocking Wizard
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard clk_wizard_0
set_property -dict [list CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {300,100.000,100.000,100.000,100.000,100.000,100.000} CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} ] [get_bd_cells clk_wizard_0]

# ILA
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila axis_ila_0
set_property CONFIG.C_MON_TYPE {Interface_Monitor} [get_bd_cells axis_ila_0]
regenerate_bd_layout

# Connections
connect_bd_net [get_bd_pins versal_cips_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
connect_bd_net [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins noc_clk_gen/axi_rst_in_0_n]
connect_bd_net [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins noc_clk_gen/axi_clk_in_0]
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_sim_trig/rst_n]
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg/tg_rst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_1/tg_rst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_2/tg_rst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_3/tg_rst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_pmon/axi_arst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_pmon_1/axi_arst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_pmon_2/axi_arst_n] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins noc_tg_pmon_3/axi_arst_n]
connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins axis_ila_0/resetn]
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_sim_trig/pclk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg/clk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_1/clk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_2/clk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_3/clk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_pmon/axi_aclk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_pmon_1/axi_aclk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_pmon_2/axi_aclk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins noc_tg_pmon_3/axi_aclk] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins axi_noc_0/aclk0] 
connect_bd_net [get_bd_pins noc_clk_gen/axi_clk_0] [get_bd_pins axis_ila_0/clk]
connect_bd_intf_net [get_bd_intf_pins noc_tg/M_AXI] [get_bd_intf_pins axis_ila_0/SLOT_0_AXI]

regenerate_bd_layout

# Assign Address
after 5000
assign_bd_address
after 5000

# Validate BD
validate_bd_design 
after 5000

# Create HDL Wrapper
make_wrapper -files [get_files ${myPath}/hbm_module_2/hbm_module_2.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${myPath}/hbm_module_2/hbm_module_2.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
after 5000

# Synthesis, Implement and Generate Device Image
launch_runs impl_1 -to_step write_device_image


# Simulation
generate_target Simulation [get_files ${myPath}/hbm_module_2/hbm_module_2.srcs/sources_1/bd/design_1/design_1.bd]
after 5000

export_ip_user_files -of_objects [get_files ${myPath}/hbm_module_2/hbm_module_2.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
after 5000

export_simulation -of_objects [get_files ${myPath}/hbm_module_2/hbm_module_2.srcs/sources_1/bd/design_1/design_1.bd] -directory ${myPath}/hbm_module_2/hbm_module_2.ip_user_files/sim_scripts -ip_user_files_dir ${myPath}/hbm_module_2/hbm_module_2.ip_user_files -ipstatic_source_dir ${myPath}/hbm_module_2/hbm_module_2.ip_user_files/ipstatic -lib_map_path [list {modelsim=${myPath}/hbm_module_2/hbm_module_2.cache/compile_simlib/modelsim} {questa=${myPath}/hbm_module_2/hbm_module_2.cache/compile_simlib/questa} {xcelium=${myPath}/hbm_module_2/hbm_module_2.cache/compile_simlib/xcelium} {vcs=${myPath}/hbm_module_2/hbm_module_2.cache/compile_simlib/vcs} {riviera=${myPath}/hbm_module_2/hbm_module_2.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
after 5000

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
set_property -name {xsim.simulate.runtime} -value {150000ns} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

launch_simulation

add_wave {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awaddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_wdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_wstrb}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_wlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_wvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_wready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_bresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_bvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_bready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_araddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_rdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_rresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_rlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_rvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_rready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_arid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_aruser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_awuser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_bid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_buser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI_rid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM00_AXI}} 

add_wave {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awaddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_wdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_wstrb}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_wlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_wvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_wready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_bresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_bvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_bready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_araddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_rdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_rresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_rlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_rvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_rready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_arid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_aruser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_awuser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_bid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_buser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI_rid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM01_AXI}} 

add_wave {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awaddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_wdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_wstrb}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_wlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_wvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_wready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_bresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_bvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_bready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_araddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_rdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_rresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_rlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_rvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_rready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_arid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_aruser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_awuser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_bid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_buser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI_rid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM02_AXI}} 

add_wave {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awaddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_wdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_wstrb}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_wlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_wvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_wready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_bresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_bvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_bready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_araddr}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arlen}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arsize}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arburst}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arlock}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arcache}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arprot}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_rdata}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_rresp}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_rlast}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_rvalid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_rready}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/aclk0}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_arid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_aruser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_awuser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_bid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_buser}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI_rid}} {{/design_1_wrapper_sim_wrapper/design_1_wrapper_i/design_1_i/axi_noc_0/HBM03_AXI}} 

                                              
# Copyright (C) 2023, Advanced Micro Devices, Inc.
