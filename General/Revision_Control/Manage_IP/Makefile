#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Makefile for running TCL scripts for Check_In_Generated_Outputs tutorial

# Variables for scripts and output directories
SCRIPTS_DIR := scripts
TOP_PRJ_SCRIPT := build_top_prj_mode.tcl
TOP_NON_PRJ_SCRIPT := build_top_non_prj_mode.tcl
MANAGE_IP_PRJ_OUTPUT := sources/ip/manage_ip_prj

# Output directories for project modes
TOP_PRJ_OUTPUT := vivado_prj_top
TOP_NON_PRJ_OUTPUT := vivado_non_prj_top

.SILENT:
.PHONY: all 
.ONESHELL:

# Target to run all modes
all: stage_managed_ip_prj_for_revision_control top_prj top_non_prj
	@echo "Completed all builds: assembly of top in project and non-project modes."

# Prepare IP and BD IP for revision control. Final result of this directory can be checked into revision control.
stage_managed_ip_prj_for_revision_control: ./sources/ip/manage_ip_prj/axis_MxN_vio/axis_MxN_vio.dcp clean_managed_ip_prj
	@echo "Assembly of Vivado IP managed project to stage for revision control is complete"
./sources/ip/manage_ip_prj/axis_MxN_vio/axis_MxN_vio.dcp:
	@echo "Running assembly of Vivado IP managed project to stage for revision control..."
	cd $(MANAGE_IP_PRJ_OUTPUT)/ && vivado -mode batch -source build_manage_ip_prj.tcl -tclargs . -work $(MANAGE_IP_PRJ_OUTPUT)
clean_managed_ip_prj:
	rm -rf $(MANAGE_IP_PRJ_OUTPUT)/*.hw $(MANAGE_IP_PRJ_OUTPUT)/*.sim $(MANAGE_IP_PRJ_OUTPUT)/*.cache $(MANAGE_IP_PRJ_OUTPUT)/vivado.* $(MANAGE_IP_PRJ_OUTPUT)/*.runs


# Target for assembling top in project mode
top_prj: ./vivado_prj_top/project_1.runs/synth_1/design_1_wrapper.dcp
	@echo "top_prj build is complete!"
./vivado_prj_top/project_1.runs/synth_1/design_1_wrapper.dcp:
	@mkdir -p $(TOP_PRJ_OUTPUT)
	@echo "Running assembly of top in project mode..."
	@echo "Output directory created: $(TOP_PRJ_OUTPUT)"
	cd $(TOP_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOP_PRJ_SCRIPT) -tclargs . -work $(TOP_PRJ_OUTPUT)

# Target for assembling top in non-project mode
top_non_prj: ./vivado_non_prj_top/outputs/dcps/post_synth.dcp
	@echo "top_non_prj build is complete!"
./vivado_non_prj_top/outputs/dcps/post_synth.dcp:
	@mkdir -p $(TOP_NON_PRJ_OUTPUT)
	@echo "Running assembly of top in non-project mode..."
	@echo "Output directory created: $(TOP_NON_PRJ_OUTPUT)"
	cd $(TOP_NON_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOP_NON_PRJ_SCRIPT) -tclargs . -work $(TOP_NON_PRJ_OUTPUT)

# Clean target to remove generated directories and files
clean:
	@rm -rf $(TOP_PRJ_OUTPUT) $(TOP_NON_PRJ_OUTPUT) 
	@echo "Cleaned output directories: $(TOP_PRJ_OUTPUT), $(TOP_NON_PRJ_OUTPUT)"

