#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

export VER      	= 2023.2
export CWD             	= $(shell readlink -f .)

VIVADO = $(XILINX_VIVADO)/bin/vivado
PETALINUX_SETTINGS = $(PETALINUX)/settings.sh

RUN_ALL=$(CWD)/scripts/run_all.tcl
RUN_IMPL=$(CWD)/scripts/run_impl.tcl
CREATE_TOP_BD=$(CWD)/scripts/create_top_bd.tcl
CREATE_RP1RM1=$(CWD)/scripts/create_rp1rm1.tcl
CREATE_RP1RM2=$(CWD)/scripts/create_rp1rm2.tcl
CREATE_RP1RM3=$(CWD)/scripts/create_rp1rm3.tcl
DESIGN_XSA=$(CWD)/xsa/design.xsa
RP1RM1_XSA=$(CWD)/xsa/rp1rm1.xsa
RP1RM2_XSA=$(CWD)/xsa/rp1rm2.xsa
RP1RM3_XSA=$(CWD)/xsa/rp1rm3.xsa
PETALINUX_SCRIPT=$(CWD)/scripts/petalinux.sh
LIBDFX=$(CWD)/code/libdfx


.SILENT:


all: vivado_prj versal_dfx


vivado_prj: $(RUN_ALL) $(RUN_IMPL) $(CREATE_RP1RM1) $(CREATE_RP1RM2) $(CREATE_RP1RM3) $(CREATE_TOP_BD)
	$(VIVADO) -mode batch -notrace -source ./scripts/run_all.tcl
	echo "vivado_prj build complete!"


versal_dfx: $(PETALINUX_SCRIPT) $(PETALINUX_SETTINGS) $(DESIGN_XSA) $(RP1RM1_XSA) $(RP1RM2_XSA) $(RP1RM3_XSA) $(PETALINUX_CONF) $(LIBDFX)
	bash $(PETALINUX_SETTINGS)
	bash $(PETALINUX_SCRIPT)
	echo "petalinx build complete!"


clean: clean_vivado_prj clean_versal_dfx


clean_vivado_prj:
	rm -rf $(CWD)/myproj
	rm -rf $(CWD)/xsa
	rm -rf $(CWD)/hd_visual
	rm -rf $(CWD)/.Xil
	rm -rf $(CWD)/*.log
	rm -rf $(CWD)/*.jou
	rm -rf $(CWD)/*.str
	echo "vivado_prj cleaned!"


clean_versal_dfx:
	rm -rf $(CWD)/versal-dfx
	rm -rf $(CWD)/sdcard
	echo "versal_dfx cleaned!"
