#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Makefile for running TCL scripts in project and non-project modes

# Variables for scripts and output directories
SCRIPTS_DIR := scripts
PRJ_SCRIPT := build_design_from_tcl.tcl
NON_PRJ_SCRIPT := build_design_non_prj_from_tcl.tcl
PRJ_OUTPUT := vivado_prj_from_tcl
NON_PRJ_OUTPUT := vivado_non_prj_from_tcl

# Target to run both project and non-project modes
all: project_mode non_project_mode
	@echo "Completed all builds: project and non-project modes."

# Target for project mode
project_mode: ./vivado_prj_from_tcl/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp
./vivado_prj_from_tcl/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp:
	@mkdir -p $(PRJ_OUTPUT)
	@echo "Running in project mode..."
	@echo "Output directory created: $(PRJ_OUTPUT)"
	@cd $(PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(PRJ_SCRIPT) -tclargs .

# Target for non-project mode
non_project_mode: ./vivado_non_prj_from_tcl/outputs/dcps/post_synth.dcp
./vivado_non_prj_from_tcl/outputs/dcps/post_synth.dcp:
	@mkdir -p $(NON_PRJ_OUTPUT)
	@echo "Running in non-project mode..."
	@echo "Output directory created: $(NON_PRJ_OUTPUT)"
	@cd $(NON_PRJ_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(NON_PRJ_SCRIPT) -tclargs .

# Clean target to remove generated directories (optional)
clean:
	@rm -rf $(PRJ_OUTPUT) $(NON_PRJ_OUTPUT)
	@echo "Cleaned output directories: $(PRJ_OUTPUT), $(NON_PRJ_OUTPUT)"
