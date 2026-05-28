#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Makefile for running TCL scripts for Check_In_Generated_Outputs tutorial

# Variables for scripts and output directories
SCRIPTS_DIR := scripts
TOP_PRJ_SCRIPT := build_top_prj_mode.tcl
TOP_NON_PRJ_SCRIPT := build_top_non_prj_mode.tcl
IP_BD_DIR := sources/ip_bd
BD_XCI_PRJ := vivado_prj_xci_bd

# Targeted directories for various build outputs
BD_XCI_PRJ_RUNS := $(IP_BD_DIR)/$(BD_XCI_PRJ)/$(BD_XCI_PRJ).runs
BD_XCI_PRJ_CACHE := $(IP_BD_DIR)/$(BD_XCI_PRJ)/$(BD_XCI_PRJ).cache
BD_XCI_PRJ_HW := $(IP_BD_DIR)/$(BD_XCI_PRJ)/$(BD_XCI_PRJ).hw
BD_XCI_PRJ_SIM := $(IP_BD_DIR)/$(BD_XCI_PRJ)/$(BD_XCI_PRJ).sim
BD_XCI_PRJ_IP_USER_FILES := $(IP_BD_DIR)/$(BD_XCI_PRJ)/$(BD_XCI_PRJ).ip_user_files

# Output directories for project modes
TOP_PRJ_OUTPUT := vivado_prj_top
TOP_NON_PRJ_OUTPUT := vivado_non_prj_top

.SILENT:
.PHONY: all clean_ip_bd_project
.ONESHELL:

# Target to run all modes
all: stage_ip_bd_for_revision_control top_prj top_non_prj
	@echo "Completed all builds: assembly of top in project and non-project modes."

# Prepare IP and BD IP for revision control. Final result of this directory can be checked into revision control.
stage_ip_bd_for_revision_control: $(IP_BD_DIR)/$(BD_XCI_PRJ)/vivado_prj_xci_bd.gen/sources_1/bd/design_1/ip/design_1_axi_noc_0_0/design_1_axi_noc_0_0.dcp clean_ip_bd_project
	@echo "Assembly of IP and Block Design to stage for revision control is complete"
$(IP_BD_DIR)/$(BD_XCI_PRJ)/vivado_prj_xci_bd.gen/sources_1/bd/design_1/ip/design_1_axi_noc_0_0/design_1_axi_noc_0_0.dcp:
	@echo "Running assembly of IP and Block Design to stage for revision control..."
	cd $(IP_BD_DIR)/$(BD_XCI_PRJ)/ && vivado -mode batch -source build_bd_xci_prj.tcl 
clean_ip_bd_project:
	@rm -rf $(BD_XCI_PRJ_RUNS) $(BD_XCI_PRJ_CACHE) $(BD_XCI_PRJ_HW) $(BD_XCI_PRJ_SIM) $(BD_XCI_PRJ_IP_USER_FILES) $(IP_BD_DIR)/$(BD_XCI_PRJ)/*.log $(IP_BD_DIR)/$(BD_XCI_PRJ)/*.jou

# Target for assembling top in project mode
top_prj: $(TOP_PRJ_OUTPUT)/project_1.runs/synth_1/design_1_wrapper.dcp
	@echo "top_prj build is complete!"
$(TOP_PRJ_OUTPUT)/project_1.runs/synth_1/design_1_wrapper.dcp: 
	@mkdir -p $(TOP_PRJ_OUTPUT)
	@echo "Running assembly of top in project mode..."
	@echo "Output directory created: $(TOP_PRJ_OUTPUT)"
	cd $(TOP_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOP_PRJ_SCRIPT) -tclargs . -work $(TOP_PRJ_OUTPUT)

# Target for assembling top in non-project mode
top_non_prj: $(TOP_NON_PRJ_OUTPUT)/outputs/dcps/post_synth.dcp
	@echo "top_non_prj build is complete!"
$(TOP_NON_PRJ_OUTPUT)/outputs/dcps/post_synth.dcp:
	@mkdir -p $(TOP_NON_PRJ_OUTPUT)
	@echo "Running assembly of top in non-project mode..."
	@echo "Output directory created: $(TOP_NON_PRJ_OUTPUT)"
	cd $(TOP_NON_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOP_NON_PRJ_SCRIPT) -tclargs . -work $(TOP_NON_PRJ_OUTPUT)

# Clean target to remove generated directories and files
clean:
	@rm -rf $(TOP_PRJ_OUTPUT) $(TOP_NON_PRJ_OUTPUT) 
	@echo "Cleaned output directories: $(TOP_PRJ_OUTPUT), $(TOP_NON_PRJ_OUTPUT)"

