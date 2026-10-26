#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Makefile for running TCL scripts for the current tutorial

# Variables for scripts and output directories
SCRIPTS_DIR := scripts
USER_MANAGED_SCRIPT := user_managed.tcl
TOOL_MANAGED_SCRIPT := tool_managed.tcl

USER_MANAGED_OUTPUT := vivado_prj_user_managed
TOOL_MANAGED_OUTPUT := vivado_prj_tool_managed

# Target to run both management modes
all: user_managed tool_managed
	@echo "Completed all builds: user-managed and tool-managed modes."

# Target for executing user-managed script
user_managed: ./vivado_prj_user_managed/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp
./vivado_prj_user_managed/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp:
	@mkdir -p $(USER_MANAGED_OUTPUT)
	@echo "Running user-managed TCL script..."
	@echo "Output directory created: $(USER_MANAGED_OUTPUT)"
	@cd $(USER_MANAGED_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(USER_MANAGED_SCRIPT) -tclargs .

# Target for executing tool-managed script
tool_managed: ./vivado_prj_tool_managed/prj.tcl
./vivado_prj_tool_managed/prj.tcl:
	@mkdir -p $(TOOL_MANAGED_OUTPUT)
	@echo "Running tool-managed TCL script..."
	@echo "Output directory created: $(TOOL_MANAGED_OUTPUT)"
	@cd $(TOOL_MANAGED_OUTPUT) && vivado -mode batch -source ../$(SCRIPTS_DIR)/$(TOOL_MANAGED_SCRIPT) -tclargs .

# Clean target to remove generated directories (optional)
clean:
	@rm -rf $(USER_MANAGED_OUTPUT) $(TOOL_MANAGED_OUTPUT)
	@echo "Cleaned output directories: $(USER_MANAGED_OUTPUT), $(TOOL_MANAGED_OUTPUT)"

