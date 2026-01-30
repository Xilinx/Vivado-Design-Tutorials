#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

# Top-Level Makefile for managing tutorial projects

# List of tutorial directories
TUTORIAL_DIRS := Foundational \
                 Check_In_Generated_Outputs \
                 IP_Cache_Compile_Time_Speedup \
                 Package_IP_Outputs_in_One_File \
                 Manage_IP \
                 User_Managed_vs_Tool_Managed

# Default target to run all makefiles for "all"
.PHONY: all clean $(TUTORIAL_DIRS)

all: $(TUTORIAL_DIRS)

# Generic rule to run make in each tutorial directory
$(TUTORIAL_DIRS):
	@echo "Running make all in $@..."
	@$(MAKE) -C $@ all

# Target to clean all outputs
clean:
	@echo "Cleaning all outputs..."
	@for dir in $(TUTORIAL_DIRS); do \
		echo "Running make clean in $$dir..."; \
		$(MAKE) -C $$dir clean; \
	done

