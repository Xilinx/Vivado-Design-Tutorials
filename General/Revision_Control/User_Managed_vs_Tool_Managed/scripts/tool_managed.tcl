#
# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

#Opening the user created project to demonstrate write_project_tcl
open_project ../vivado_prj_user_managed/vivado_prj_from_tcl.xpr
#Write the TCL file for the whole project using write_project_tcl
write_project_tcl prj.tcl
close_project

#Recreate the project again by sourcing TCL generated from write_project_tcl
source prj.tcl

#User must launch synthesis and Implementation. This is still user responsibility
#write_project_tcl only recreates the project and establishes the project ready for synthesis and implementation
# Please note that generated prj.tcl has pointers to .xci and the relative location need to be followed.
# Please do write_project_tcl -help in Vivado to see other options in write_project_tcl

