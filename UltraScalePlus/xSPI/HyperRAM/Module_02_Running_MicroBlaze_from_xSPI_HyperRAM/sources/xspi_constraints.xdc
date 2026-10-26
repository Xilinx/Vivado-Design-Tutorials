#
# Copyright (C) 2026, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#

set_property PACKAGE_PIN B23  [get_ports {XSPI_0_0_cs[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {XSPI_0_0_cs[0]}]
set_property PACKAGE_PIN C22  [get_ports XSPI_0_0_ds]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_ds]
set_property PACKAGE_PIN C20 [get_ports XSPI_0_0_io0]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io0]
set_property PACKAGE_PIN B20 [get_ports XSPI_0_0_io1]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io1]
set_property PACKAGE_PIN A23 [get_ports XSPI_0_0_io2]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io2] 
set_property PACKAGE_PIN A24 [get_ports XSPI_0_0_io3]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io3]
set_property PACKAGE_PIN A20 [get_ports XSPI_0_0_io4]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io4]
set_property PACKAGE_PIN A21 [get_ports XSPI_0_0_io5]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io5]
set_property PACKAGE_PIN B21 [get_ports XSPI_0_0_io6]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io6]
set_property PACKAGE_PIN B22 [get_ports XSPI_0_0_io7]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_io7]
set_property PACKAGE_PIN E21 [get_ports XSPI_0_0_resetn]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_resetn]
set_property PACKAGE_PIN B24 [get_ports XSPI_0_0_sck_p]
set_property IOSTANDARD LVCMOS18 [get_ports XSPI_0_0_sck_p]


set_property DRIVE 12 [get_ports XSPI_0_0_ds]
set_property DRIVE 12 [get_ports XSPI_0_0_sck_p]
set_property DRIVE 12 [get_ports XSPI_0_0_resetn]
set_property DRIVE 12 [get_ports XSPI_0_0_io6]
set_property DRIVE 12 [get_ports XSPI_0_0_io5]
set_property DRIVE 12 [get_ports XSPI_0_0_io4]
set_property DRIVE 12 [get_ports XSPI_0_0_io2]
set_property SLEW FAST [get_ports XSPI_0_0_ds]
set_property SLEW FAST [get_ports XSPI_0_0_io0]
set_property SLEW FAST [get_ports XSPI_0_0_io1]
set_property SLEW FAST [get_ports XSPI_0_0_io2]
set_property SLEW FAST [get_ports XSPI_0_0_io3]
set_property SLEW FAST [get_ports XSPI_0_0_io4]
set_property SLEW FAST [get_ports XSPI_0_0_io5]
set_property SLEW FAST [get_ports XSPI_0_0_io6]
set_property SLEW FAST [get_ports XSPI_0_0_io7]

# Set input false path. DQ[*] and RWDS are supposed to
# be fully asynchronous for the data recovery logic
set_false_path -from [get_ports XSPI_0_0_ds]
set_false_path -from [get_ports XSPI_0_0_io*]

# Set output false path, timings are met by design
set_false_path -to [get_ports XSPI_0_0_ds]
set_false_path -to [get_ports XSPI_0_0_io*]

set_property DATA_RATE DDR [get_ports XSPI_0_0_ds]
set_property DATA_RATE DDR [get_ports XSPI_0_0_io*]







