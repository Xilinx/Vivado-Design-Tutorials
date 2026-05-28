#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Makefile for running TCL scripts for Core Container Flow

# Variables for scripts and output directories
SCRIPTS_DIR := scripts
MANAGE_IP_XCIX_PRJ := manage_ip_xcix_prj
TOP_PRJ_SCRIPT := build_top_prj_mode.tcl
TOP_NON_PRJ_SCRIPT := build_top_non_prj_mode.tcl
SOURCES_DIR := sources
MANAGE_IP_XCIX_PRJ_OUTPUT := $(SOURCES_DIR)/$(MANAGE_IP_XCIX_PRJ)
TOP_PRJ_OUTPUT := vivado_prj_top
TOP_NON_PRJ_OUTPUT := vivado_non_prj_top


# Target to run all modes
all: top_prj top_non_prj
	@echo "Completed all builds: assembly of managed XCI  in top, in project and non-project modes."

# Target for assembling top in project mode
top_prj: ./vivado_prj_top/project_1.runs/synth_1/design_1_wrapper.dcp
./vivado_prj_top/project_1.runs/synth_1/design_1_wrapper.dcp:
	@mkdir -p $(TOP_PRJ_OUTPUT)
	@echo "Running assembly of top in project mode..."
	@echo "Output directory created: $(TOP_PRJ_OUTPUT)"
	@cd $(TOP_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOP_PRJ_SCRIPT) -tclargs .

# Target for assembling top in non-project mode
top_non_prj: ./vivado_non_prj_top/outputs/dcps/post_synth.dcp
./vivado_non_prj_top/outputs/dcps/post_synth.dcp:
	@mkdir -p $(TOP_NON_PRJ_OUTPUT)
	@echo "Running assembly of top in non-project mode..."
	@echo "Output directory created: $(TOP_NON_PRJ_OUTPUT)"
	@cd $(TOP_NON_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOP_NON_PRJ_SCRIPT) -tclargs .

# Clean target to remove generated directories and files
clean:
	@rm -rf $(TOP_PRJ_OUTPUT) $(TOP_NON_PRJ_OUTPUT) \
	$(MANAGE_IP_XCIX_PRJ_OUTPUT)/*.cache \
	$(MANAGE_IP_XCIX_PRJ_OUTPUT)/*.hw \
	$(MANAGE_IP_XCIX_PRJ_OUTPUT)/*.runs \
	$(MANAGE_IP_XCIX_PRJ_OUTPUT)/*.log \
	$(MANAGE_IP_XCIX_PRJ_OUTPUT)/*.jou
	@echo "Cleaned output directories: $(TOP_PRJ_OUTPUT), $(TOP_NON_PRJ_OUTPUT), files in $(MANAGE_IP_XCIX_PRJ_OUTPUT)"

