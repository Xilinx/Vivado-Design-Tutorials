#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

VIVADO                  = $(XILINX_VIVADO)/bin/vivado
CWD                     = $(shell readlink -f .)
SS_DIR                  = vivado_synth_static
SS_DCP                  = $(CWD)/$(SS_DIR)/outputs/dcps/static_synth.dcp
RM1_DIR                 = vivado_synth_rm1
RM1_DCP                 = $(CWD)/$(RM1_DIR)/outputs/dcps/rm1_synth.dcp
S_RM1_DIR               = vivado_impl_static_with_rm1
S_RM1_PDI               = $(CWD)/$(S_RM1_DIR)/outputs/rp1_rm1_partial.pdi
SHELL_DIR               = vivado_shells
SHELL_DCP               = $(CWD)/$(SHELL_DIR)/outputs/static_shell_bb.dcp
RM2_DIR                 = vivado_synth_rm2
RM2_DCP                 = $(CWD)/$(RM2_DIR)/outputs/dcps/rm2_synth.dcp
RM2_FULL_SHELL_DIR      = vivado_impl_rm2_full_shell
RM2_FULL_SHELL_PDI      = $(CWD)/$(RM2_FULL_SHELL_DIR)/outputs/rp1_rm2_partial.pdi
RM2_ABS_SHELL_DIR       = vivado_impl_rm2_abs_shell
RM2_ABS_SHELL_PDI       = $(CWD)/$(RM2_ABS_SHELL_DIR)/outputs/rp1_rm2_partial.pdi

.SILENT:
.PHONY: all 
.ONESHELL:

all: synth_static synth_rm1 impl_static_with_rm1 create_shells synth_rm2 impl_rm2_full_shell impl_rm2_abs_shell
	echo "All platform builds complete!"

fast_compile:
	make -j synth_static synth_rm1 synth_rm2
	make impl_static_with_rm1 create_shells
	make -j impl_rm2_full_shell impl_rm2_abs_shell

synth_static: $(SS_DCP)
	echo "synth_static build complete!"
$(SS_DCP):
	mkdir $(SS_DIR);cd $(SS_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/synth_static.tcl

synth_rm1: $(RM1_DCP)
	echo "synth_rm1 build complete!"
$(RM1_DCP):
	mkdir $(RM1_DIR);cd $(RM1_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/synth_rm1.tcl

impl_static_with_rm1: $(S_RM1_PDI)
	echo "impl_static_with_rm1 build complete!"
$(S_RM1_PDI):
	mkdir $(S_RM1_DIR);cd $(S_RM1_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/impl_static_with_rm1.tcl

create_shells: $(SHELL_DCP)
	echo "create_static_shell build complete!"
$(SHELL_DCP):
	mkdir $(SHELL_DIR);cd $(SHELL_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/create_static_shell.tcl

synth_rm2: $(RM2_DCP)
	echo "synth_rm2 build complete!"
$(RM2_DCP):
	mkdir $(RM2_DIR);cd $(RM2_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/synth_rm2.tcl

impl_rm2_full_shell: $(RM2_FULL_SHELL_PDI)
	echo "impl_rm2_full_shell build complete!"
$(RM2_FULL_SHELL_PDI):
	mkdir $(RM2_FULL_SHELL_DIR);cd $(RM2_FULL_SHELL_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/impl_rm2_full_shell.tcl

impl_rm2_abs_shell: $(RM2_ABS_SHELL_PDI)
	echo "impl_rm2_abs_shell build complete!"
$(RM2_ABS_SHELL_PDI):
	mkdir $(RM2_ABS_SHELL_DIR);cd $(RM2_ABS_SHELL_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/impl_rm2_abs_shell.tcl

clean: clean_synth_static clean_synth_rm1 clean_impl_static_with_rm1 clean_synth_rm2 clean_create_shells clean_impl_rm2_full_shell clean_impl_rm2_abs_shell

clean_synth_static:
	rm -rf $(SS_DIR)
	echo "synth_static build cleaned!"

clean_synth_rm1:
	rm -rf $(RM1_DIR)
	echo "synth_rm1 build cleaned!"

clean_impl_static_with_rm1:
	rm -rf $(S_RM1_DIR)
	echo "impl_static_with_rm1 build cleaned!"

clean_synth_rm2:
	rm -rf $(RM2_DIR)
	echo "synth_rm2 build cleaned!"

clean_create_shells:
	rm -rf $(SHELL_DIR)
	echo "create_static_shell build cleaned!"

clean_impl_rm2_full_shell:
	rm -rf $(RM2_FULL_SHELL_DIR)
	echo "clean_impl_rm2_full_shellbuild cleaned!"

clean_impl_rm2_abs_shell:
	rm -rf $(RM2_ABS_SHELL_DIR)
	echo "clean_impl_rm2_abs_shell build cleaned!"


