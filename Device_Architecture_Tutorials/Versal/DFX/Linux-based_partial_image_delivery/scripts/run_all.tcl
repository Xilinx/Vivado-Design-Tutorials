#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


#Source this script to compile the full Versal DFX tutorial design in Vivado 2022.2
#Source individual steps to work more interactively with the tools / flow

set WORKING_DIR [pwd]

cd $WORKING_DIR

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project axi_gpio_in_rp_versal ../vivado_prj -part xcvc1902-vsva2197-2MP-e-S -force
   set_property BOARD_PART xilinx.com:vck190:part0:2.2 [current_project]
}


# Create the RM1 variant of RP1
source ./create_rp1rm1.tcl

# Create the RM2 variant of RP1
source ./create_rp1rm2.tcl

# Create the RM3 variant of RP1
source ./create_rp1rm3.tcl

# Create the top BD with RP1 (DFX enabled)
source ./create_top_bd.tcl

# Create an HDL Wrapper, set up the DFX Wizard, then run the implementation flow through programming image generation and XSA export
source ./run_impl.tcl
