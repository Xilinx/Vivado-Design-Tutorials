#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

VIVADO                  = vivado
CWD                     = $(shell readlink -f .)
PRJ_DIR                 = vivado_prj
PRJ_DIR_WALK            = vivado_prj_walk
NON_PRJ_DIR             = vivado_non_prj
SIM_DIR                 = vivado_sim
SIM_DIR_WALK            = vivado_sim_walk
DESIGN_PDI              = $(CWD)/$(PRJ_DIR)/project_1.runs/impl_1/design_1_wrapper.pdi
DESIGN_PDI_WALK         = $(CWD)/$(PRJ_DIR_WALK)/project_1.runs/impl_1/design_1_wrapper.pdi
NON_PRJ_PDI             = $(CWD)/$(NON_PRJ_DIR)/outputs/design_1_wrapper.pdi
DESIGN_SIM              = $(CWD)/$(SIM_DIR)/project_1.sim/sim_1/behav/xsim/simulate.log
DESIGN_SIM_WALK         = $(CWD)/$(SIM_DIR_WALK)/project_1.sim/sim_1/behav/xsim/simulate.log

.SILENT:
.PHONY: all 
.ONESHELL:

all: bld_DESIGN non_prj_DESIGN sim_DESIGN 
#all: bld_DESIGN sim_DESIGN 
	echo "All platform builds complete!"

bld_DESIGN: $(DESIGN_PDI)
	echo "bld_DESIGN build complete!"
$(DESIGN_PDI):
	mkdir $(PRJ_DIR);cd $(PRJ_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/build_design.tcl

bld_DESIGN_WALKTHROUGH: $(DESIGN_PDI_WALK)
	echo "bld_DESIGN_WALKTHROUGH build complete!"
$(DESIGN_PDI_WALK):
	mkdir $(PRJ_DIR_WALK);cd $(PRJ_DIR_WALK)
	$(VIVADO) -mode batch -notrace -source ../scripts/build_design_walkthrough.tcl

non_prj_DESIGN: $(NON_PRJ_PDI)
	echo "non_prj_DESIGN build complete!"
$(NON_PRJ_PDI):
	mkdir $(NON_PRJ_DIR);cd $(NON_PRJ_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/build_design_non_prj.tcl

sim_DESIGN: $(DESIGN_SIM)
	echo "sim_DESIGN simulation complete!"
$(DESIGN_SIM):
	mkdir $(SIM_DIR);cd $(SIM_DIR)
	$(VIVADO) -mode batch -notrace -source ../scripts/sim_design.tcl

sim_DESIGN_WALKTHROUGH: $(DESIGN_SIM_WALK)
	echo "sim_DESIGN_WALKTHROUGH simulation complete!"
$(DESIGN_SIM_WALK):
	mkdir $(SIM_DIR_WALK);cd $(SIM_DIR_WALK)
	$(VIVADO) -mode batch -notrace -source ../scripts/sim_design_walkthrough.tcl

clean: clean_prj clean_prj_walk clean_non_prj clean_sim clean_sim_walk
#clean: clean_prj clean_sim 

clean_non_prj:
	rm -rf $(NON_PRJ_DIR)
	echo "non_prj_DESIGN build cleaned!"

clean_prj:
	rm -rf $(PRJ_DIR)
	echo "bld_DESIGN build cleaned!"

clean_prj_walk:
	rm -rf $(PRJ_DIR_WALK)
	echo "bld_DESIGN_WALKTHROUGH build cleaned!"

clean_sim:
	rm -rf $(SIM_DIR)
	echo "sim_DESIGN simulation cleaned!"

clean_sim_walk:
	rm -rf $(SIM_DIR_WALK)
	echo "sim_DESIGN_WALKTHROUGH simulation cleaned!"

