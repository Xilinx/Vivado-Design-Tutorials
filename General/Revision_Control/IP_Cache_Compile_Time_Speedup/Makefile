#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Makefile for demonstrating IP cache mechanism tutorial

# Variables for script and run directories
SCRIPTS_DIR := scripts
DESIGN_SCRIPT := build_design_prj_mode.tcl
IP_GEN_SCRIPT := create_ip_bd_prj_mode.tcl
NON_PRJ_SCRIPT := build_design_non_prj_mode.tcl

PRJ_DIR := prj_flow
NON_PRJ_DIR := non_prj_flow
INITIAL_RUN_DIR := initial_run
RERUN_DIR := rerun
NON_PRJ_BUILD := top_build

# Cache repository expected parallel to initial_run directory
CACHE_REPO_DIR := cache_repo

.PHONY: all 

all: project_mode non_project_mode
	@echo "Completed both project mode and non-project mode runs"

project_mode: initial_run rerun
	@echo "Project mode complete"

non_project_mode: initial_ip_gen_run ip_gen_rerun non_prj_build
	@echo "Non-project mode complete"

# Project mode: Target for initial run
initial_run: ./prj_flow/initial_run/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp
./prj_flow/initial_run/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp:
	@mkdir -p $(PRJ_DIR); cd $(PRJ_DIR); mkdir -p $(INITIAL_RUN_DIR) $(CACHE_REPO_DIR)
	@echo "Running initial script execution..."
	@echo "Output directory created: $(INITIAL_RUN_DIR)"
	@echo "Cache repository initialized: $(CACHE_REPO_DIR)"
	@cd $(PRJ_DIR)/$(INITIAL_RUN_DIR) && vivado -mode batch -source ../../$(SCRIPTS_DIR)/$(DESIGN_SCRIPT) -tclargs $(CACHE_REPO_DIR)

# Project mode: Target for rerun utilizing cache
rerun: ./prj_flow/rerun/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp
./prj_flow/rerun/vivado_prj_from_tcl.runs/synth_1/design_1_wrapper.dcp:
	@cd $(PRJ_DIR); mkdir -p $(RERUN_DIR)
	@echo "Running script execution for rerun with cache reuse..."
	@echo "Output directory created: $(RERUN_DIR)"
	@cd $(PRJ_DIR)/$(RERUN_DIR) && vivado -mode batch -source ../../$(SCRIPTS_DIR)/$(DESIGN_SCRIPT) -tclargs $(CACHE_REPO_DIR)

# Non-Project mode: Target for initial IP generation run
initial_ip_gen_run: ./non_prj_flow/initial_run/vivado_prj_from_tcl.runs/axis_MxN_vio_synth_1/axis_MxN_vio.dcp
./non_prj_flow/initial_run/vivado_prj_from_tcl.runs/axis_MxN_vio_synth_1/axis_MxN_vio.dcp:
	@mkdir -p $(NON_PRJ_DIR); cd $(NON_PRJ_DIR); mkdir -p $(INITIAL_RUN_DIR) $(CACHE_REPO_DIR)
	@echo "Running initial script execution..."
	@echo "Output directory created: $(INITIAL_RUN_DIR)"
	@echo "Cache repository initialized: $(CACHE_REPO_DIR)"
	@cd $(NON_PRJ_DIR)/$(INITIAL_RUN_DIR) && vivado -mode batch -source ../../$(SCRIPTS_DIR)/$(IP_GEN_SCRIPT) -tclargs $(CACHE_REPO_DIR)

# Non-Project mode: Target for rerun of IP generation utilizing cache
ip_gen_rerun: ./non_prj_flow/rerun/vivado_prj_from_tcl.runs/axis_MxN_vio_synth_1/axis_MxN_vio.dcp
./non_prj_flow/rerun/vivado_prj_from_tcl.runs/axis_MxN_vio_synth_1/axis_MxN_vio.dcp:
	@cd $(NON_PRJ_DIR); mkdir -p $(RERUN_DIR)
	@echo "Running script execution for rerun with cache reuse..."
	@echo "Output directory created: $(NON_PRJ_DIR)/$(RERUN_DIR)"
	@cd $(NON_PRJ_DIR)/$(RERUN_DIR) && vivado -mode batch -source ../../$(SCRIPTS_DIR)/$(IP_GEN_SCRIPT) -tclargs $(CACHE_REPO_DIR)
# Target to run both initial and cached run

# Non-Project mode: Build top level design pointing to generated IP
non_prj_build: ./non_prj_flow/top_build/outputs/dcps/post_synth.dcp
./non_prj_flow/top_build/outputs/dcps/post_synth.dcp:
	@cd $(NON_PRJ_DIR); mkdir -p $(NON_PRJ_BUILD)
	@echo "Running top level non-project build"
	@echo "Output directory created: $(SCRIPTS_DIR)/$(NON_PRJ_SCRIPT))"
	@cd $(NON_PRJ_DIR)/$(NON_PRJ_BUILD) && vivado -mode batch -source ../../$(SCRIPTS_DIR)/$(NON_PRJ_SCRIPT) -tclargs $(CACHE_REPO_DIR)

# Clean target to remove generated directories (optional)
clean:
	@rm -rf $(NON_PRJ_DIR) $(PRJ_DIR)
	@echo "Cleaned output directories and cache repository: $(NON_PRJ_DIR), $(PRJ_DIR)"
