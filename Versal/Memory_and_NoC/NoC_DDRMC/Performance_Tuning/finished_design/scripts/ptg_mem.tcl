#******************************************************************************
# (c) Copyright 2019 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#******************************************************************************/
#    ____  ____
#   /   /\/   /
#  /___/  \  /    Vendor             : Xilinx
#  \   \   \/     Version            : 1.3
#   \   \         Application        : VERSAL
#   /   /         Filename           : ptg_mem.tcl
#  /___/   /\     Date Last Modified : $Date$
#  \   \  /  \    Date Created       : Thu Feb 14 2019
#   \___\/\___\
#
# Device: Versal
# Design Name: Performance TG input .csv file to .mem file creation script
# Purpose:
# Reference:
# Revision History:
#           > 1.0 : Initial version.
#                   - Single script for both AXIMM/AXIS .csv files.
#           > 1.1 : Not backward compatible with version 1.0
#                   - Input argument telling AXIMM/AXIS is required to create
#                       .mem file for AXIMM/AXIS
#           > 1.2 : Not backward compatible with version 1.1
#           > 1.3 :
#                   - Added MTG support (initial)
#                   - Added two new input arguments, TG_MODE and AXI_DW
#                   - ip_id -all will be depricated, in this version usage
#                     of this option will result in script malfunction
#                   - Added .csv file DRCs (few)
#*****************************************************************************

# The Procs
# ==============================================================================
proc csv_template_db {glb_var} {
    upvar 1 $glb_var x

    dict set x "csv_template" AXIMM "TG_NUM" col 0
    dict set x "csv_template" AXIMM "TG_NUM" enc [list d]

    dict set x "csv_template" AXIMM "cmd" col 1
    dict set x "csv_template" AXIMM "cmd" enc [list s]
    dict set x "csv_template" AXIMM "cmd" pv 0 type lst
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "cmd" pv 0 lst [list WRRD WRRDINF WRRDSIM READ WRITE START_LOOP END_LOOP]
    } else {
        dict set x "csv_template" AXIMM "cmd" pv 0 lst [list READ WRITE WAIT START_LOOP END_LOOP PHASE_DONE]
    }
    dict set x "csv_template" AXIMM "cmd" pv 0 enc s

    dict set x "csv_template" AXIMM "txn_count" col 2
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "txn_count" enc [list d]
    } else {
        dict set x "csv_template" AXIMM "txn_count" enc [list s d]
    }
    dict set x "csv_template" AXIMM "txn_count" pv 0 type rng
    dict set x "csv_template" AXIMM "txn_count" pv 0 min 1
    dict set x "csv_template" AXIMM "txn_count" pv 0 max {[expr {(2**16)-1}]}
    dict set x "csv_template" AXIMM "txn_count" pv 0 enc d
    dict set x "csv_template" AXIMM "txn_count" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|^START_LOOP$|^WRRD$|^WRRDSIM$} "ic#cmd"]}
    dict set x "csv_template" AXIMM "txn_count" pv 1 type val
    dict set x "csv_template" AXIMM "txn_count" pv 1 val "INF"
    dict set x "csv_template" AXIMM "txn_count" pv 1 enc s
    dict set x "csv_template" AXIMM "txn_count" pv 1 dep {[regexp -nocase {^WRITE$|^READ$|^START_LOOP$|^WRRD$|^WRRDSIM$} "ic#cmd"]}
    dict set x "csv_template" AXIMM "txn_count" pv 2 type val
    dict set x "csv_template" AXIMM "txn_count" pv 2 val 1
    dict set x "csv_template" AXIMM "txn_count" pv 2 enc d
    dict set x "csv_template" AXIMM "txn_count" pv 2 dep {[regexp -nocase {^WRRDINF$} "ic#cmd"]}
    dict set x "csv_template" AXIMM "txn_count" default type "val"
    dict set x "csv_template" AXIMM "txn_count" default val 1
    dict set x "csv_template" AXIMM "txn_count" default enc d
    dict set x "csv_template" AXIMM "txn_count" other type rgex
    dict set x "csv_template" AXIMM "txn_count" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "start_delay" col 3
    dict set x "csv_template" AXIMM "start_delay" enc [list d]
    dict set x "csv_template" AXIMM "start_delay" pv 0 type rng
    dict set x "csv_template" AXIMM "start_delay" pv 0 min 0
    dict set x "csv_template" AXIMM "start_delay" pv 0 max {[expr {(2**16)-1}}
    dict set x "csv_template" AXIMM "start_delay" pv 0 enc d
    dict set x "csv_template" AXIMM "start_delay" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "start_delay" default type "val"
    dict set x "csv_template" AXIMM "start_delay" default val 0
    dict set x "csv_template" AXIMM "start_delay" default enc d
    dict set x "csv_template" AXIMM "start_delay" other type rgex
    dict set x "csv_template" AXIMM "start_delay" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "loop_incr_by" col 4
    dict set x "csv_template" AXIMM "loop_incr_by" enc [list d h]
    dict set x "csv_template" AXIMM "loop_incr_by" pv 0 type rng
    dict set x "csv_template" AXIMM "loop_incr_by" pv 0 min 0
    dict set x "csv_template" AXIMM "loop_incr_by" pv 0 max {expr {(2**16)-1}}
    dict set x "csv_template" AXIMM "loop_incr_by" pv 0 enc d
    dict set x "csv_template" AXIMM "loop_incr_by" pv 0 dep {[regexp -nocase {^START_LOOP$} "ic#cmd"]}
    dict set x "csv_template" AXIMM "loop_incr_by" pv 1 type rng
    dict set x "csv_template" AXIMM "loop_incr_by" pv 1 min "0x0000"
    dict set x "csv_template" AXIMM "loop_incr_by" pv 1 max "0xFFFF"
    dict set x "csv_template" AXIMM "loop_incr_by" pv 1 enc h
    dict set x "csv_template" AXIMM "loop_incr_by" pv 1 dep {[regexp -nocase {^START_LOOP$} "ic#cmd"]}
    dict set x "csv_template" AXIMM "loop_incr_by" default type "val"
    dict set x "csv_template" AXIMM "loop_incr_by" default val 0
    dict set x "csv_template" AXIMM "loop_incr_by" default enc d
    dict set x "csv_template" AXIMM "loop_incr_by" other type rgex
    dict set x "csv_template" AXIMM "loop_incr_by" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "wdata_pattern" col 5
    dict set x "csv_template" AXIMM "wdata_pattern" enc [list s]

    dict set x "csv_template" AXIMM "wdata_pat_value" col 6
    dict set x "csv_template" AXIMM "wdata_pat_value" enc [list h]
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 type lst
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 lst [list "0x110" "0x111" "0x112" "0x113" "0x114" "0x115"]
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 enc h
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    } else {
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 type rng
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 min "0x000"
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 max "0x1FF"
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 enc h
        dict set x "csv_template" AXIMM "wdata_pat_value" pv 0 dep {[regexp -nocase {^WRITE|READ$} "ic#cmd"]}
    }
    dict set x "csv_template" AXIMM "wdata_pat_value" default type "val"
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "wdata_pat_value" default val 6
    } else {
        dict set x "csv_template" AXIMM "wdata_pat_value" default val 0
    }
    dict set x "csv_template" AXIMM "wdata_pat_value" default enc d
    dict set x "csv_template" AXIMM "wdata_pat_value" other type rgex
    dict set x "csv_template" AXIMM "wdata_pat_value" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "data_integrity" col 7
    dict set x "csv_template" AXIMM "data_integrity" enc [list s]
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "data_integrity" pv 0 type val
        dict set x "csv_template" AXIMM "data_integrity" pv 0 val "disabled"
        dict set x "csv_template" AXIMM "data_integrity" pv 0 enc s
        dict set x "csv_template" AXIMM "data_integrity" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|^WRRDSIM$} "ic#cmd"]}
        dict set x "csv_template" AXIMM "data_integrity" pv 1 type lst
        dict set x "csv_template" AXIMM "data_integrity" pv 1 lst [list disabled enabled]
        dict set x "csv_template" AXIMM "data_integrity" pv 1 enc s
        dict set x "csv_template" AXIMM "data_integrity" pv 1 dep {[regexp -nocase {^WRRDINF$|^WRRD$} "ic#cmd"]}
    } else {
        dict set x "csv_template" AXIMM "data_integrity" pv 0 type lst
        dict set x "csv_template" AXIMM "data_integrity" pv 0 lst [list disabled enabled]
        dict set x "csv_template" AXIMM "data_integrity" pv 0 enc s
        dict set x "csv_template" AXIMM "data_integrity" pv 0 dep {[regexp -nocase {^WRITE|READ$} "ic#cmd"]}
    }
    dict set x "csv_template" AXIMM "data_integrity" default type "val"
    dict set x "csv_template" AXIMM "data_integrity" default val "disable"
    dict set x "csv_template" AXIMM "data_integrity" default enc s
    dict set x "csv_template" AXIMM "data_integrity" other type rgex
    dict set x "csv_template" AXIMM "data_integrity" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "dest_id" col 8
    dict set x "csv_template" AXIMM "dest_id" enc [list h]
    dict set x "csv_template" AXIMM "dest_id" pv 0 type rng
    dict set x "csv_template" AXIMM "dest_id" pv 0 min "0x000"
    dict set x "csv_template" AXIMM "dest_id" pv 0 max "0xFFF"
    dict set x "csv_template" AXIMM "dest_id" pv 0 enc h
    dict set x "csv_template" AXIMM "dest_id" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "dest_id" default type "val"
    dict set x "csv_template" AXIMM "dest_id" default val 0
    dict set x "csv_template" AXIMM "dest_id" default enc d
    dict set x "csv_template" AXIMM "dest_id" other type rgex
    dict set x "csv_template" AXIMM "dest_id" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "base_addr" col 9
    dict set x "csv_template" AXIMM "base_addr" enc [list h]
    dict set x "csv_template" AXIMM "base_addr" pv 0 type rng
    dict set x "csv_template" AXIMM "base_addr" pv 0 min "0x000000000000"
    dict set x "csv_template" AXIMM "base_addr" pv 0 max "0xFFFFFFFFFFFF"
    dict set x "csv_template" AXIMM "base_addr" pv 0 enc h
    dict set x "csv_template" AXIMM "base_addr" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "base_addr" other type rgex
    dict set x "csv_template" AXIMM "base_addr" other rgex {^[\s\t\n]*$}
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "base_addr" vldty type "eq"
        dict set x "csv_template" AXIMM "base_addr" vldty eq {[expr {ec#base_addr % (FA#axi_dw/8)}] == 0}
        dict set x "csv_template" AXIMM "base_addr" vldty dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
        dict set x "csv_template" AXIMM "base_addr" vldty enc d
    }

    dict set x "csv_template" AXIMM "high_addr" col 10
    dict set x "csv_template" AXIMM "high_addr" enc [list h]
    dict set x "csv_template" AXIMM "high_addr" pv 0 type rng
    dict set x "csv_template" AXIMM "high_addr" pv 0 min "0x000000000000"
    dict set x "csv_template" AXIMM "high_addr" pv 0 max "0xFFFFFFFFFFFF"
    dict set x "csv_template" AXIMM "high_addr" pv 0 enc h
    dict set x "csv_template" AXIMM "high_addr" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "high_addr" other type rgex
    dict set x "csv_template" AXIMM "high_addr" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "addr_incr_by" col 11
    dict set x "csv_template" AXIMM "addr_incr_by" enc [list s]
    dict set x "csv_template" AXIMM "addr_incr_by" pv 0 type val
    dict set x "csv_template" AXIMM "addr_incr_by" pv 0 val "auto_incr"
    dict set x "csv_template" AXIMM "addr_incr_by" pv 0 enc s
    dict set x "csv_template" AXIMM "addr_incr_by" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    if {[dict get $x file_args tg_mode] != "MTG"} {
        dict set x "csv_template" AXIMM "addr_incr_by" enc [list s h]
        dict set x "csv_template" AXIMM "addr_incr_by" pv 1 type rng
        dict set x "csv_template" AXIMM "addr_incr_by" pv 1 min "0x000000000000"
        dict set x "csv_template" AXIMM "addr_incr_by" pv 1 max "0xFFFFFFFFFFFF"
        dict set x "csv_template" AXIMM "addr_incr_by" pv 1 enc h
        dict set x "csv_template" AXIMM "addr_incr_by" pv 1 dep {[regexp -nocase {^WRITE|READ$} "ic#cmd"]}
    }
    dict set x "csv_template" AXIMM "addr_incr_by" default type "val"
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "addr_incr_by" default val "auto_incr"
        dict set x "csv_template" AXIMM "addr_incr_by" default enc s
    } else {
        dict set x "csv_template" AXIMM "addr_incr_by" default val 0
        dict set x "csv_template" AXIMM "addr_incr_by" default enc d
    }
    dict set x "csv_template" AXIMM "addr_incr_by" other type rgex
    dict set x "csv_template" AXIMM "addr_incr_by" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_addr_offset" col 12
    dict set x "csv_template" AXIMM "axi_addr_offset" enc [list h]
    dict set x "csv_template" AXIMM "axi_addr_offset" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_addr_offset" pv 0 min "0x000000000000"
    dict set x "csv_template" AXIMM "axi_addr_offset" pv 0 max "0xFFFFFFFFFFFF"
    dict set x "csv_template" AXIMM "axi_addr_offset" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_addr_offset" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    if {[dict get $x file_args tg_mode] != "MTG"} {
        dict set x "csv_template" AXIMM "axi_addr_offset" enc [list s h]
        dict set x "csv_template" AXIMM "axi_addr_offset" pv 1 type lst
        dict set x "csv_template" AXIMM "axi_addr_offset" pv 1 lst [list "random" "random_aligned"]
        dict set x "csv_template" AXIMM "axi_addr_offset" pv 1 enc s
        dict set x "csv_template" AXIMM "axi_addr_offset" pv 1 dep {[regexp -nocase {^WRITE|READ$} "ic#cmd"]}
    }
    dict set x "csv_template" AXIMM "axi_addr_offset" default type "val"
    dict set x "csv_template" AXIMM "axi_addr_offset" default val 0
    dict set x "csv_template" AXIMM "axi_addr_offset" default enc d
    dict set x "csv_template" AXIMM "axi_addr_offset" other type rgex
    dict set x "csv_template" AXIMM "axi_addr_offset" other rgex {^[\s\t\n]*$}
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "axi_addr_offset" vldty type "eq"
        dict set x "csv_template" AXIMM "axi_addr_offset" vldty eq {[expr {ec#axi_addr_offset % (FA#axi_dw/8)}] == 0}
        dict set x "csv_template" AXIMM "axi_addr_offset" vldty dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
        dict set x "csv_template" AXIMM "axi_addr_offset" vldty enc d
    }

    dict set x "csv_template" AXIMM "axi_len" col 13
    dict set x "csv_template" AXIMM "axi_len" enc [list h]
    dict set x "csv_template" AXIMM "axi_len" pv 0 enc h
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "axi_len" pv 0 type val
        dict set x "csv_template" AXIMM "axi_len" pv 0 val "0x00"
    } else {
        dict set x "csv_template" AXIMM "axi_len" pv 0 type rng
        dict set x "csv_template" AXIMM "axi_len" pv 0 min "0x00"
        dict set x "csv_template" AXIMM "axi_len" pv 0 max "0xFF"
    }
    dict set x "csv_template" AXIMM "axi_len" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_len" default type "val"
    dict set x "csv_template" AXIMM "axi_len" default val 0
    dict set x "csv_template" AXIMM "axi_len" default enc d
    dict set x "csv_template" AXIMM "axi_len" other type rgex
    dict set x "csv_template" AXIMM "axi_len" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_size" col 14
    dict set x "csv_template" AXIMM "axi_size" enc [list h]
    dict set x "csv_template" AXIMM "axi_size" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_size" pv 0 min "0x0"
    dict set x "csv_template" AXIMM "axi_size" pv 0 max "0x7"
    dict set x "csv_template" AXIMM "axi_size" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_size" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_size" default type "val"
    dict set x "csv_template" AXIMM "axi_size" default val 0
    dict set x "csv_template" AXIMM "axi_size" default enc d
    dict set x "csv_template" AXIMM "axi_size" other type rgex
    dict set x "csv_template" AXIMM "axi_size" other rgex {^[\s\t\n]*$}
    dict set x "csv_template" AXIMM "axi_size" vldty type "eq"
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "axi_size" vldty eq {ec#axi_size == [expr {int(log(FA#axi_dw/8)/log(2))}]}
    } else {
        dict set x "csv_template" AXIMM "axi_size" vldty eq {[expr {ec#high_addr - ec#base_addr + 1}] >= [expr {(ec#axi_len + 1)*(2**ec#axi_size)}]}
    }
    dict set x "csv_template" AXIMM "axi_size" vldty dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_size" vldty enc d

    dict set x "csv_template" AXIMM "axi_id" col 15
    dict set x "csv_template" AXIMM "axi_id" enc [list s h]
    dict set x "csv_template" AXIMM "axi_id" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_id" pv 0 min "0x0000"
    dict set x "csv_template" AXIMM "axi_id" pv 0 max "0xFFFF"
    dict set x "csv_template" AXIMM "axi_id" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_id" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_id" pv 1 type val
    dict set x "csv_template" AXIMM "axi_id" pv 1 val "auto_incr"
    dict set x "csv_template" AXIMM "axi_id" pv 1 enc s
    dict set x "csv_template" AXIMM "axi_id" pv 1 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_id" default type "val"
    dict set x "csv_template" AXIMM "axi_id" default val 0
    dict set x "csv_template" AXIMM "axi_id" default enc d
    dict set x "csv_template" AXIMM "axi_id" other type rgex
    dict set x "csv_template" AXIMM "axi_id" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_burst" col 16
    dict set x "csv_template" AXIMM "axi_burst" enc [list s h]
    if {[dict get $x file_args tg_mode] == "MTG"} {
        dict set x "csv_template" AXIMM "axi_burst" pv 0 type val
        dict set x "csv_template" AXIMM "axi_burst" pv 0 val "incr"
        dict set x "csv_template" AXIMM "axi_burst" pv 0 enc s
        dict set x "csv_template" AXIMM "axi_burst" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
        dict set x "csv_template" AXIMM "axi_burst" pv 1 type val
        dict set x "csv_template" AXIMM "axi_burst" pv 1 val "0x1"
        dict set x "csv_template" AXIMM "axi_burst" pv 1 enc h
        dict set x "csv_template" AXIMM "axi_burst" pv 1 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    } else {
        dict set x "csv_template" AXIMM "axi_burst" pv 0 type lst
        dict set x "csv_template" AXIMM "axi_burst" pv 0 lst [list "incr" "wrap" "fixed"]
        dict set x "csv_template" AXIMM "axi_burst" pv 0 enc s
        dict set x "csv_template" AXIMM "axi_burst" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
        dict set x "csv_template" AXIMM "axi_burst" pv 1 type lst
        dict set x "csv_template" AXIMM "axi_burst" pv 1 lst [list "0x0" "0x1" "0x2"]
        dict set x "csv_template" AXIMM "axi_burst" pv 1 enc h
        dict set x "csv_template" AXIMM "axi_burst" pv 1 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    }
    dict set x "csv_template" AXIMM "axi_burst" default type "val"
    dict set x "csv_template" AXIMM "axi_burst" default val 1
    dict set x "csv_template" AXIMM "axi_burst" default enc d
    dict set x "csv_template" AXIMM "axi_burst" other type rgex
    dict set x "csv_template" AXIMM "axi_burst" other rgex {^[\s\t\n]*$}
    dict set x "csv_template" AXIMM "axi_burst" map "fixed" 0
    dict set x "csv_template" AXIMM "axi_burst" map "incr" 1
    dict set x "csv_template" AXIMM "axi_burst" map "wrap" 2
    dict set x "csv_template" AXIMM "axi_burst" map_enc d

    dict set x "csv_template" AXIMM "axi_lock" col 17
    dict set x "csv_template" AXIMM "axi_lock" enc [list s h]
    dict set x "csv_template" AXIMM "axi_lock" pv 0 type lst
    dict set x "csv_template" AXIMM "axi_lock" pv 0 lst [list "normal" "exclusive"]
    dict set x "csv_template" AXIMM "axi_lock" pv 0 enc s
    dict set x "csv_template" AXIMM "axi_lock" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_lock" pv 1 type lst
    dict set x "csv_template" AXIMM "axi_lock" pv 1 lst [list "0x0" "0x1"]
    dict set x "csv_template" AXIMM "axi_lock" pv 1 enc h
    dict set x "csv_template" AXIMM "axi_lock" pv 1 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_lock" default type "val"
    dict set x "csv_template" AXIMM "axi_lock" default val 0
    dict set x "csv_template" AXIMM "axi_lock" default enc d
    dict set x "csv_template" AXIMM "axi_lock" other type rgex
    dict set x "csv_template" AXIMM "axi_lock" other rgex {^[\s\t\n]*$}
    dict set x "csv_template" AXIMM "axi_lock" map "normal" 0
    dict set x "csv_template" AXIMM "axi_lock" map "exclusive" 1
    dict set x "csv_template" AXIMM "axi_lock" map_enc d

    dict set x "csv_template" AXIMM "axi_cache" col 18
    dict set x "csv_template" AXIMM "axi_cache" enc [list h]
    dict set x "csv_template" AXIMM "axi_cache" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_cache" pv 0 min "0x0"
    dict set x "csv_template" AXIMM "axi_cache" pv 0 max "0xF"
    dict set x "csv_template" AXIMM "axi_cache" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_cache" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_cache" default type "val"
    dict set x "csv_template" AXIMM "axi_cache" default val 0
    dict set x "csv_template" AXIMM "axi_cache" default enc d
    dict set x "csv_template" AXIMM "axi_cache" other type rgex
    dict set x "csv_template" AXIMM "axi_cache" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_prot" col 19
    dict set x "csv_template" AXIMM "axi_prot" enc [list h]
    dict set x "csv_template" AXIMM "axi_prot" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_prot" pv 0 min "0x0"
    dict set x "csv_template" AXIMM "axi_prot" pv 0 max "0x7"
    dict set x "csv_template" AXIMM "axi_prot" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_prot" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_prot" default type "val"
    dict set x "csv_template" AXIMM "axi_prot" default val 0
    dict set x "csv_template" AXIMM "axi_prot" default enc d
    dict set x "csv_template" AXIMM "axi_prot" other type rgex
    dict set x "csv_template" AXIMM "axi_prot" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_qos" col 20
    dict set x "csv_template" AXIMM "axi_qos" enc [list h]
    dict set x "csv_template" AXIMM "axi_qos" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_qos" pv 0 min "0x0"
    dict set x "csv_template" AXIMM "axi_qos" pv 0 max "0xF"
    dict set x "csv_template" AXIMM "axi_qos" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_qos" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_qos" default type "val"
    dict set x "csv_template" AXIMM "axi_qos" default val 0
    dict set x "csv_template" AXIMM "axi_qos" default enc d
    dict set x "csv_template" AXIMM "axi_qos" other type rgex
    dict set x "csv_template" AXIMM "axi_qos" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_region" col 21
    dict set x "csv_template" AXIMM "axi_region" enc [list h]
    dict set x "csv_template" AXIMM "axi_region" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_region" pv 0 min "0x0"
    dict set x "csv_template" AXIMM "axi_region" pv 0 max "0xF"
    dict set x "csv_template" AXIMM "axi_region" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_region" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_region" default type "val"
    dict set x "csv_template" AXIMM "axi_region" default val 0
    dict set x "csv_template" AXIMM "axi_region" default enc d
    dict set x "csv_template" AXIMM "axi_region" other type rgex
    dict set x "csv_template" AXIMM "axi_region" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "axi_user" col 22
    dict set x "csv_template" AXIMM "axi_user" enc [list h]
    dict set x "csv_template" AXIMM "axi_user" pv 0 type rng
    dict set x "csv_template" AXIMM "axi_user" pv 0 min "0x000"
    dict set x "csv_template" AXIMM "axi_user" pv 0 max "0x3FF"
    dict set x "csv_template" AXIMM "axi_user" pv 0 enc h
    dict set x "csv_template" AXIMM "axi_user" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "axi_user" default type "val"
    dict set x "csv_template" AXIMM "axi_user" default val 0
    dict set x "csv_template" AXIMM "axi_user" default enc d
    dict set x "csv_template" AXIMM "axi_user" other type rgex
    dict set x "csv_template" AXIMM "axi_user" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIMM "exp_resp" col 23
    dict set x "csv_template" AXIMM "exp_resp" enc [list s h]
    dict set x "csv_template" AXIMM "exp_resp" pv 0 type lst
    dict set x "csv_template" AXIMM "exp_resp" pv 0 lst [list "okay" "exokay" "slverr" "decerr" ""]
    dict set x "csv_template" AXIMM "exp_resp" pv 0 enc s
    dict set x "csv_template" AXIMM "exp_resp" pv 0 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "exp_resp" pv 1 type lst
    dict set x "csv_template" AXIMM "exp_resp" pv 1 lst [list "0x0" "0x1" "0x2" "0x3"]
    dict set x "csv_template" AXIMM "exp_resp" pv 1 enc h
    dict set x "csv_template" AXIMM "exp_resp" pv 1 dep {[regexp -nocase {^WRITE$|^READ$|WRRD} "ic#cmd"]}
    dict set x "csv_template" AXIMM "exp_resp" map "okay" 0
    dict set x "csv_template" AXIMM "exp_resp" map "exokay" 1
    dict set x "csv_template" AXIMM "exp_resp" map "slverr" 2
    dict set x "csv_template" AXIMM "exp_resp" map "decerr" 3
    dict set x "csv_template" AXIMM "exp_resp" map "" 100
    dict set x "csv_template" AXIMM "exp_resp" map_enc d
    dict set x "csv_template" AXIMM "exp_resp" default type "val"
    dict set x "csv_template" AXIMM "exp_resp" default val 0
    dict set x "csv_template" AXIMM "exp_resp" default enc d
    dict set x "csv_template" AXIMM "exp_resp" other type rgex
    dict set x "csv_template" AXIMM "exp_resp" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "TG_NUM" col 0
    dict set x "csv_template" AXIS "TG_NUM" enc [list d]

    dict set x "csv_template" AXIS "cmd" col 1
    dict set x "csv_template" AXIS "cmd" enc [list s]
    dict set x "csv_template" AXIS "cmd" pv 0 type lst
    dict set x "csv_template" AXIS "cmd" pv 0 lst [list STREAM WAIT START_LOOP END_LOOP PHASE_DONE]
    dict set x "csv_template" AXIS "cmd" pv 0 enc s

    dict set x "csv_template" AXIS "pkt_count" col 2
    dict set x "csv_template" AXIS "pkt_count" enc [list s d]
    dict set x "csv_template" AXIS "pkt_count" pv 0 type rng
    dict set x "csv_template" AXIS "pkt_count" pv 0 min 1
    dict set x "csv_template" AXIS "pkt_count" pv 0 max {[expr {(2**16)-1}]}
    dict set x "csv_template" AXIS "pkt_count" pv 0 enc d
    dict set x "csv_template" AXIS "pkt_count" pv 0 dep {[regexp -nocase {^STREAM|START_LOOP|WAIT$} "ic#cmd"]}
    dict set x "csv_template" AXIS "pkt_count" pv 1 type val
    dict set x "csv_template" AXIS "pkt_count" pv 1 val "INF"
    dict set x "csv_template" AXIS "pkt_count" pv 1 enc s
    dict set x "csv_template" AXIS "pkt_count" pv 1 dep {[regexp -nocase {^STREAM|START_LOOP$} "ic#cmd"]}
    dict set x "csv_template" AXIS "pkt_count" default type "val"
    dict set x "csv_template" AXIS "pkt_count" default val 1
    dict set x "csv_template" AXIS "pkt_count" default enc d
    dict set x "csv_template" AXIS "pkt_count" other type rgex
    dict set x "csv_template" AXIS "pkt_count" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "inter_pkt_delay" col 3
    dict set x "csv_template" AXIS "inter_pkt_delay" enc [list d]
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 0 type rng
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 0 min 0
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 0 max {[expr {(2**16)-1}}
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 0 enc d
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    # The below pv is only to make sure that non-synth csv and synth csv work
    # value 'clk' has no value in .mem file. This is just for compatibility
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 1 type lst
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 1 lst [list "clk" ""]
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 1 enc s
    dict set x "csv_template" AXIS "inter_pkt_delay" pv 1 dep {[regexp -nocase {^WAIT$} "ic#cmd"]}
    dict set x "csv_template" AXIS "inter_pkt_delay" default type "val"
    dict set x "csv_template" AXIS "inter_pkt_delay" default val 0
    dict set x "csv_template" AXIS "inter_pkt_delay" default enc d
    dict set x "csv_template" AXIS "inter_pkt_delay" other type rgex
    dict set x "csv_template" AXIS "inter_pkt_delay" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "inter_transfer_delay" col 4
    dict set x "csv_template" AXIS "inter_transfer_delay" enc [list d h]
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 0 type rng
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 0 min 0
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 0 max {expr {(2**16)-6}}
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 0 enc d
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 1 type rng
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 1 min "0x0000"
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 1 max "0xFFFF"
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 1 enc h
    dict set x "csv_template" AXIS "inter_transfer_delay" pv 1 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "inter_transfer_delay" default type "val"
    dict set x "csv_template" AXIS "inter_transfer_delay" default val 0
    dict set x "csv_template" AXIS "inter_transfer_delay" default enc d
    dict set x "csv_template" AXIS "inter_transfer_delay" other type rgex
    dict set x "csv_template" AXIS "inter_transfer_delay" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "tdata_pattern" col 5
    dict set x "csv_template" AXIS "tdata_pattern" enc [list s]
    dict set x "csv_template" AXIS "tdata_pattern" pv 0 type lst
    dict set x "csv_template" AXIS "tdata_pattern" pv 0 lst [list random constant hammer byte_incr 16byte_incr]
    dict set x "csv_template" AXIS "tdata_pattern" pv 0 enc s
    dict set x "csv_template" AXIS "tdata_pattern" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "tdata_pattern" other type rgex
    dict set x "csv_template" AXIS "tdata_pattern" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "tdata_pat_value" col 6
    dict set x "csv_template" AXIS "tdata_pat_value" enc [list h]
    dict set x "csv_template" AXIS "tdata_pat_value" pv 0 type rng
    dict set x "csv_template" AXIS "tdata_pat_value" pv 0 min "0x00000000"
    dict set x "csv_template" AXIS "tdata_pat_value" pv 0 max "0xFFFFFFFF"
    dict set x "csv_template" AXIS "tdata_pat_value" pv 0 enc h
    dict set x "csv_template" AXIS "tdata_pat_value" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "tdata_pat_value" default type "val"
    dict set x "csv_template" AXIS "tdata_pat_value" default val 0
    dict set x "csv_template" AXIS "tdata_pat_value" default enc d
    dict set x "csv_template" AXIS "tdata_pat_value" other type rgex
    dict set x "csv_template" AXIS "tdata_pat_value" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "noc_dest_id" col 8
    dict set x "csv_template" AXIS "noc_dest_id" enc [list h s]
    dict set x "csv_template" AXIS "noc_dest_id" pv 0 type rng
    dict set x "csv_template" AXIS "noc_dest_id" pv 0 min "0x000"
    dict set x "csv_template" AXIS "noc_dest_id" pv 0 max "0xFFF"
    dict set x "csv_template" AXIS "noc_dest_id" pv 0 enc h
    dict set x "csv_template" AXIS "noc_dest_id" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "noc_dest_id" pv 1 type val
    dict set x "csv_template" AXIS "noc_dest_id" pv 1 enc s
    dict set x "csv_template" AXIS "noc_dest_id" pv 1 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "noc_dest_id" other type rgex
    dict set x "csv_template" AXIS "noc_dest_id" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "tdest_id" col 12
    dict set x "csv_template" AXIS "tdest_id" enc [list h]
    dict set x "csv_template" AXIS "tdest_id" pv 0 type rng
    dict set x "csv_template" AXIS "tdest_id" pv 0 min "0x000"
    dict set x "csv_template" AXIS "tdest_id" pv 0 max "0xFFF"
    dict set x "csv_template" AXIS "tdest_id" pv 0 enc h
    dict set x "csv_template" AXIS "tdest_id" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "tdest_id" default type "val"
    dict set x "csv_template" AXIS "tdest_id" default val 0
    dict set x "csv_template" AXIS "tdest_id" default enc d
    dict set x "csv_template" AXIS "tdest_id" other type rgex
    dict set x "csv_template" AXIS "tdest_id" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "pkt_len" col 13
    dict set x "csv_template" AXIS "pkt_len" enc [list h]
    dict set x "csv_template" AXIS "pkt_len" pv 0 type rng
    dict set x "csv_template" AXIS "pkt_len" pv 0 min "0x0000"
    dict set x "csv_template" AXIS "pkt_len" pv 0 max "0xFFFF"
    dict set x "csv_template" AXIS "pkt_len" pv 0 enc h
    dict set x "csv_template" AXIS "pkt_len" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "pkt_len" default type "val"
    dict set x "csv_template" AXIS "pkt_len" default val 0
    dict set x "csv_template" AXIS "pkt_len" default enc d
    dict set x "csv_template" AXIS "pkt_len" other type rgex
    dict set x "csv_template" AXIS "pkt_len" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "pkt_id" col 15
    dict set x "csv_template" AXIS "pkt_id" enc [list s h]
    dict set x "csv_template" AXIS "pkt_id" pv 0 type rng
    dict set x "csv_template" AXIS "pkt_id" pv 0 min "0x0000"
    dict set x "csv_template" AXIS "pkt_id" pv 0 max "0xFFFF"
    dict set x "csv_template" AXIS "pkt_id" pv 0 enc h
    dict set x "csv_template" AXIS "pkt_id" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "pkt_id" pv 1 type val
    dict set x "csv_template" AXIS "pkt_id" pv 1 val "auto_incr"
    dict set x "csv_template" AXIS "pkt_id" pv 1 enc s
    dict set x "csv_template" AXIS "pkt_id" pv 1 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "pkt_id" default type "val"
    dict set x "csv_template" AXIS "pkt_id" default val 0
    dict set x "csv_template" AXIS "pkt_id" default enc d
    dict set x "csv_template" AXIS "pkt_id" other type rgex
    dict set x "csv_template" AXIS "pkt_id" other rgex {^[\s\t\n]*$}

    dict set x "csv_template" AXIS "pkt_user" col 22
    dict set x "csv_template" AXIS "pkt_user" enc [list h]
    dict set x "csv_template" AXIS "pkt_user" pv 0 type rng
    dict set x "csv_template" AXIS "pkt_user" pv 0 min "0x0000"
    dict set x "csv_template" AXIS "pkt_user" pv 0 max "0xFFFF"
    dict set x "csv_template" AXIS "pkt_user" pv 0 enc h
    dict set x "csv_template" AXIS "pkt_user" pv 0 dep {[regexp -nocase {^STREAM$} "ic#cmd"]}
    dict set x "csv_template" AXIS "pkt_user" default type "val"
    dict set x "csv_template" AXIS "pkt_user" default val 0
    dict set x "csv_template" AXIS "pkt_user" default enc d
    dict set x "csv_template" AXIS "pkt_user" other type rgex
    dict set x "csv_template" AXIS "pkt_user" other rgex {^[\s\t\n]*$}

}

proc mem_encode_db {glb_var} {
    upvar 1 $glb_var x

    # The below code creates a dictionary which defines the encoding scheme,
    # width and equations of each placeholder

    # For Memory Mapped csv content
    set i 0
    #axi_user
    dict set x "mem_encode" AXIMM $i width 4
    dict set x "mem_encode" AXIMM $i name "axi_user"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_user" : [regexp -nocase {^PHASE_DONE$} "C#cmd"] ? 1 : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_region
    # i = 1
    dict set x "mem_encode" AXIMM $i width 4
    dict set x "mem_encode" AXIMM $i name "axi_region"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_region" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_qos
    # i = 2
    dict set x "mem_encode" AXIMM $i width 4
    dict set x "mem_encode" AXIMM $i name "axi_qos"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_qos" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_prot
    # i = 3
    dict set x "mem_encode" AXIMM $i width 3
    dict set x "mem_encode" AXIMM $i name "axi_prot"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_prot" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_cache
    # i = 4
    dict set x "mem_encode" AXIMM $i width 4
    dict set x "mem_encode" AXIMM $i name "axi_cache"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_cache" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_lock
    # i = 5
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "axi_lock"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? C#axi_lock : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_burst
    # i = 6
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "axi_burst"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? C#axi_burst: 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_size
    # i = 7
    dict set x "mem_encode" AXIMM $i width 3
    dict set x "mem_encode" AXIMM $i name "axi_size"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_size" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_len
    # i = 8
    dict set x "mem_encode" AXIMM $i width 8
    dict set x "mem_encode" AXIMM $i name "axi_len"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_len" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_id_type
    # i = 9
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "axi_id_type"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#axi_id"] ? 1 : 0) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #txn_count
    # i = 10
    dict set x "mem_encode" AXIMM $i width 16
    dict set x "mem_encode" AXIMM $i name "txn_count"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^INF$} "C#txn_count"] ? 0 : "C#txn_count") : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #cmd
    # i = 11
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "cmd"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^READ$} "C#cmd"] ? 0 : [regexp -nocase {^WRITE$} "C#cmd"] ? 1 : [regexp -nocase {^WAIT$} "C#cmd"] ? 2 : [regexp -nocase {^PHASE_DONE$} "C#cmd"] ? 2 : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #num_bytes_per_txn
    # i = 12
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "num_bytes_per_txn"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {random} "C#axi_addr_offset"] ? 0 : ([regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? (((C#axi_burst == 0) && (C#axi_lock == 0)) ? [expr (2**(M#axi_size))] : [expr {(2**(M#axi_size))*(M#axi_len+1)}]) : "C#addr_incr_by")): 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #addr_offset
    # i = 13
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "addr_offset"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? "C#axi_addr_offset" : ([regexp -nocase {random} "C#axi_addr_offset"] ? 0 : "C#axi_addr_offset")) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #high_addr
    # i = 14
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "high_addr"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#high_addr" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #base_addr
    # i = 15
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "base_addr"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#base_addr" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #seed
    # i = 16
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "seed"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {random} "C#axi_addr_offset"] ? "C#addr_incr_by" : 0) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #addr_pat
    # i = 17
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "addr_pat"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? 0 : ([regexp -nocase {^random$} "C#axi_addr_offset"] ? 2 : ([regexp -nocase {^random_aligned$} "C#axi_addr_offset"] ? 3 : 1))) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #loop_addr
    # i = 18
    dict set x "mem_encode" AXIMM $i width 9
    dict set x "mem_encode" AXIMM $i name "loop_addr"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i val 0
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #loop
    # i = 19
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "loop"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i val 0
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #last_inst
    # i = 20
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "last_inst"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i val 0
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #infi_inst
    # i = 21
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "infi_inst"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^INF$} "C#txn_count"] ? 1 : 0) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #start_delay
    # i = 22
    dict set x "mem_encode" AXIMM $i width 16
    dict set x "mem_encode" AXIMM $i name "start_delay"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #loop_cnt
    # i = 23
    dict set x "mem_encode" AXIMM $i width 16
    dict set x "mem_encode" AXIMM $i name "loop_cnt"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? "R#loop_instr,~ip_id,loop_cnt" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #loop_infi
    # i = 24
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "loop_infi"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? "R#loop_instr,~ip_id,loop_infi" : 0}
    #dict set x "mem_encode" AXIMM $i type "val"
    #dict set x "mem_encode" AXIMM $i val 0
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #loop_start
    # i = 25
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "loop_start"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i val 0
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #dest_id
    # i = 26
    dict set x "mem_encode" AXIMM $i width 12
    dict set x "mem_encode" AXIMM $i name "dest_id"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #data_integrity
    # i = 27
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "data_integrity"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^enabled$} "C#data_integrity"] ? 1 : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #wdata_pat_value
    # i = 28
    dict set x "mem_encode" AXIMM $i width 9
    dict set x "mem_encode" AXIMM $i name "wdata_pat_value"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#wdata_pat_value" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #loop_incr_by_mem
    # i = 29
    dict set x "mem_encode" AXIMM $i width 16
    dict set x "mem_encode" AXIMM $i name "loop_incr_by_mem"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? "R#loop_instr,~ip_id,loop_incr_by_mem" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #inst_id_value
    # i = 30
    dict set x "mem_encode" AXIMM $i width 16
    dict set x "mem_encode" AXIMM $i name "inst_id_value"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#axi_id"] ? 0 : "C#axi_id") : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #exp_resp
    # i = 31
    dict set x "mem_encode" AXIMM $i width 3
    dict set x "mem_encode" AXIMM $i name "exp_resp"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ((C#exp_resp == 0) ? 4 : ((C#exp_resp == 1) ? 5 : ((C#exp_resp == 2) ? 6 : ((C#exp_resp == 3) ? 7 : 0)))) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_user_10bit
    # i = 32
    dict set x "mem_encode" AXIMM $i width 10
    dict set x "mem_encode" AXIMM $i name "axi_user_10bit"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? "C#axi_user" : [regexp -nocase {^PHASE_DONE$} "C#cmd"] ? 1 : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #last_wr_rd_cmd
    # i = 33
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "last_wr_rd_cmd"
    dict set x "mem_encode" AXIMM $i type "val"
    dict set x "mem_encode" AXIMM $i val 0
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #---------------------------------------------------------------------------
    #STREAM
    set i 0
    #pkt_user
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "pkt_user"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? "C#pkt_user" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #tdest_id
    # i = 1
    dict set x "mem_encode" AXIS $i width 12
    dict set x "mem_encode" AXIS $i name "tdest_id"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? "C#tdest_id" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #pkt_id
    # i = 2
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "pkt_id"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#pkt_id"] ? 0 : "C#pkt_id") : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #id_type
    # i = 3
    dict set x "mem_encode" AXIS $i width 2
    dict set x "mem_encode" AXIS $i name "id_type"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#pkt_id"] ? 0 : 1) : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #pkt_len
    # i = 4
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "pkt_len"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? "C#pkt_len" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #pkt_count
    # i = 5
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "pkt_count"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM|WAIT|PHASE_DONE$} "C#cmd"] ? ([regexp -nocase {^INF$} "C#pkt_count"] ? ((2**16)-1) : "C#pkt_count") : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #loop_addr
    # i = 6
    dict set x "mem_encode" AXIS $i width 9
    dict set x "mem_encode" AXIS $i name "loop_addr"
    dict set x "mem_encode" AXIS $i type "val"
    dict set x "mem_encode" AXIS $i val 0
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #loop
    # i = 7
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "loop"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? 1 : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #tdata_pattern
    # i = 8
    dict set x "mem_encode" AXIS $i width 3
    dict set x "mem_encode" AXIS $i name "tdata_pattern"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ([regexp -nocase {^hammer$} "C#tdata_pattern"] ? 3 : ([regexp -nocase {^constant$} "C#tdata_pattern"] ? 2 : ([regexp -nocase {^random$} "C#tdata_pattern"] ? 1 : 0))) : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #tdata_pat_value
    # i = 9
    dict set x "mem_encode" AXIS $i width 32
    dict set x "mem_encode" AXIS $i name "tdata_pat_value"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ([regexp -nocase {^hammer$} "C#tdata_pattern"] ? 0 : ([regexp -nocase {^constant$} "C#tdata_pattern"] ? "C#tdata_pat_value" : ([regexp -nocase {^random$} "C#tdata_pattern"] ? "C#tdata_pat_value" : ([regexp -nocase {^byte_incr$} "C#tdata_pattern"] ? 1 : ([regexp -nocase {^16byte_incr$} "C#tdata_pattern"] ? 16 : 0))))) : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #inter_pkt_delay
    # i = 10
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "inter_pkt_delay"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? "C#inter_pkt_delay" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #inter_transfer_delay
    # i = 11
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "inter_transfer_delay"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? "C#inter_transfer_delay" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #infi_trans
    # i = 12
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "infi_trans"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ([regexp -nocase {^INF$} "C#pkt_count"] ? 1 : 0) : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #loop_infi
    # i = 13
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "loop_infi"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? "R#loop_instr,~ip_id,loop_infi" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #loop_start
    # i = 14
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "loop_start"
    dict set x "mem_encode" AXIS $i type "val"
    dict set x "mem_encode" AXIS $i val 0
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #end_loop
    # i = 15
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "end_loop"
    dict set x "mem_encode" AXIS $i type "val"
    dict set x "mem_encode" AXIS $i val 0
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #loop_cnt
    # i = 16
    dict set x "mem_encode" AXIS $i width 16
    dict set x "mem_encode" AXIS $i name "loop_cnt"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? "R#loop_instr,~ip_id,loop_cnt" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #wait
    # i = 17
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "wait"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^WAIT$} "C#cmd"] ? 1 : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #last_inst
    # i = 18
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "last_inst"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq 0
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #last_al0
    # i = 19
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "last_al0"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ((M#pkt_len == 0) ? 1 : 0) : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #last_al1
    # i = 20
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "last_al1"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ((M#pkt_len == 1) ? 1 : 0) : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #noc_dest_id
    # i = 21
    dict set x "mem_encode" AXIS $i width 12
    dict set x "mem_encode" AXIS $i name "noc_dest_id"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? "C#noc_dest_id" : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #PD
    # i = 22
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "PD"
    dict set x "mem_encode" AXIS $i type "eq"
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^PHASE_DONE$} "C#cmd"] ? 1 : 0}
    dict set x "mem_encode" AXIS $i enc d
    incr i

}

proc dict_to_json {d str} {
    upvar $str s
    set keys [dict keys $d]
    for {set i 0} {$i < [llength $keys]} {incr i} {
        set key [lindex $keys $i]
        if {[regexp {csv_template|mem_encode} $key]} {
            continue
        }
        append s "\"$key\":"
        if {[catch {llength [dict keys [dict get $d $key]]}]} {
            if {[llength [dict get $d $key]] > 1} {
                if {[expr {([llength [dict get $d $key]] % 2) == 0}]} {
                    append s "\{"
                    set ikeys [dict keys [dict get $d $key]]
                    for {set j 0} {$j < [llength $ikeys]} {incr j} {
                        set ikey [lindex $ikeys $j]
                        append s "\"$ikey\":\"[dict get $d $key $ikey]\""
                        if {$j != [expr {[llength $ikeys]-1}]} {
                            append s","
                        }
                    }
                    append s "\}"
                } else {
                    append s "\[[dict get $d $key]\]"
                }
            } else {
                append s "\"[dict get $d $key]\""
            }
        } else {
            append s "\{"
            dict_to_json [dict get $d $key] s
            append s "\}"
        }
        if {$i != [expr {[llength $keys]-1}]} {
            append s ","
        }
    }
}

proc write_file {write_type mem file ext type} {
    if {$write_type == "local"} {
        if {[catch {open "$file\.$ext" w} fileId]} {
            puts stderr "Cannot open $file\.$ext : $fileId"
        } else {
            if {$type == "S"} {
                puts $fileId $mem
            } else {
                foreach line $mem {
                    puts $fileId $line
                }
            }
        }
        close $fileId
    } else {
        set fh [add_ipfile "$file\.$ext" -fileType "verilogSource"]
        if {$type == "S"} {
            puts_ipfile $fh $mem
        } else {
            foreach line $mem {
                puts_ipfile $fh $line
            }
        }
        close_ipfile $fh
    }
}

proc print_msg {glb_var msg severity code} {
    upvar 1 $glb_var x
    if {[dict exists $x file_args local_run]} {
        puts "$severity: $code: $msg"
        if {$severity == "ERROR"} {
            exit
        }
    } else {
        send_msg_id $code $severity $msg
    }
}

proc get_param_val {param_dict param glb_var ip_id line enc} {
    upvar 1 $glb_var x
    set val_found 0

    if {$param_dict == "ic"} {
        return [list 1 [dict get $x csv_encode $line $param val]]
    }
    if {$param_dict == "ec"} {
        set val [dict get $x csv_encode $line $param val]
        set val_enc [dict get $x csv_encode $line $param enc]
		#puts "$param:$val:$val_enc"
        if {$enc == "d"} {
            if {$val_enc == "d"} {
                return [list 1 $val]
            } elseif {$val_enc == "h"} {
                set val [string map {\_ ""} $val]
                if {[regexp {^0[xX]} $val]} {
					#puts "Yahoo!"
                } else {
                    set val "0x$val"
                }
				#puts [expr $val]
                return [list 1 [expr $val]]
            }
        }
    }
    if {$param_dict == "R"} {
        set d [dict get $x runtime_opts]
        set params [split $param ',']
        while {[llength $params] > 0} {
            set p [lindex $params 0]
            set params [lreplace $params 0 0]
            if {[regexp {~} $p]} {
                set p [expr [string map {~ \$} $p]]
            }
            if {[llength $params] == 0} {
                if {[dict exists $d $p]} {
                    return [list 1 [dict get $d $p]]
                } else {
                    return [list 0 '']
                }
            } else {
                if {[dict exists $d $p]} {
                    set d [dict get $d $p]
                } else {
                    return [list 0 '']
                }
            }
        }
    }
    if {$param_dict == "M"} {
        if {[dict exists $x mem_lines $ip_id [dict get $x file_args prot] $line]} {
            foreach key [dict keys [dict get $x mem_lines $ip_id [dict get $x file_args prot] $line]] {
                if {[dict get $x mem_lines $ip_id [dict get $x file_args prot] $line $key "name"] == $param} {
                    if {[dict exists $x mem_lines $ip_id [dict get $x file_args prot] $line $key "val"]} {
                        return [list 1 [dict get $x mem_lines $ip_id [dict get $x file_args prot] $line $key "val"]]
                    }
                }
            }
        }
    }
    if {$param_dict == "C"} {
        if {$val_found == 0} {
            set val [dict get $x csv_lines_per_id $ip_id $line $param val]
            if {$val == ""} {
                set val 0
                return [list 1 $val]
            }
            if {[dict get $x csv_lines_per_id $ip_id $line $param enc] == "h"} {
                set val [string map {\_ ""} $val]
                if {[regexp {^0[xX]} $val]} {
                } else {
                    set val "0x$val"
                }
                #set val [format %d $val]
                set val [expr $val]
            }
            if {[dict get $x csv_lines_per_id $ip_id $line $param enc] == "s"} {
                if {[regexp {^0?[xX]?[A-Fa-f0-9\_]+$} $val]} {
                    set val [string map {\_ ""} $val]
                    if {[regexp {^0[xX]} $val]} {
                    } else {
                        set val "0x$val"
                    }
                    #set val [format %d $val]
                    set val [expr $val]
                }
            }
            return [list 1 $val]
        }
    }
    if {$param_dict == "FA"} {
        set val [dict get $x file_args $param]
        return [list 1 $val]
    }

    if {$val_found == 0} {
        return [list 0 '']
    }
}

proc elab_eval_in_csv {glb_var} {
    upvar 1 $glb_var x

    #initial sanity check
    if {[dict exists $x csv_encode]} {
        set cmd ""
        set cmd_cnt 0
        for {set i 0} {$i < [llength [dict keys [dict get $x csv_encode]]]} {incr i} {
            if {([dict get $x "csv_encode" $i TG_NUM val] == "") || ([dict get $x "csv_encode" $i TG_NUM val] == [dict get $x file_args ip_id])} {
                if {([regexp -nocase {WRITE|READ} [dict get $x "csv_encode" $i cmd val]]) && ([dict get $x file_args prot] == "AXIS")} {
                    print_msg x "[dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst] has AXIMM commands where as the script is instructed to create [dict get $x file_args ip_inst].mem with AXIS commands. This is is illegal. Please correct the CSV (at line [dict get $x csv_encode $i cmd csv_line]).!" "ERROR" "CSV-E-1"
                }
                if {([regexp -nocase {STREAM} [dict get $x "csv_encode" $i cmd val]]) && ([dict get $x file_args prot] == "AXIMM")} {
                    print_msg x "[dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst] has AXIS commands where as the script is instructed to create [dict get $x file_args ip_inst].mem with AXIMM commands. This is is illegal. Please correct the CSV (at line [dict get $x csv_encode $i cmd csv_line]).!" "ERROR" "CSV-E-1"
                }
                if {[dict get $x file_args tg_mode] == "MTG"} {
                    if {([regexp -nocase {WRRD} [dict get $x "csv_encode" $i cmd val]]) && ([dict get $x file_args prot] == "AXIS")} {
                        print_msg x "[dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst] has AXIMM commands where as the script is instructed to create [dict get $x file_args ip_inst].mem with AXIS commands. This is is illegal. Please correct the CSV (at line [dict get $x csv_encode $i cmd csv_line]).!" "ERROR" "CSV-E-1"
                    }
                    if (!([regexp -nocase {LOOP} [dict get $x "csv_encode" $i cmd val]])) {
                        incr cmd_cnt
                    }
                    if {($cmd != [dict get $x "csv_encode" $i cmd val]) && ($cmd != "") && (!([regexp -nocase {LOOP} [dict get $x "csv_encode" $i cmd val]]))} {
                        print_msg x "[dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst] has incompatible sequence of commands. In MEM TG mode, different commands are not allowed. This is is illegal. Please correct the CSV (at line [dict get $x csv_encode $i cmd csv_line]).!" "ERROR" "CSV-E-1"
                    }
                    if {$cmd == "WRRDINF"} {
                        if {$cmd_cnt > 1} {
                            print_msg x "[dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst] has incompatible sequence of commands. In MEM TG mode, WRRDINF command is allowed only once per IP. This is is illegal. Please correct the CSV (at line [dict get $x csv_encode $i cmd csv_line]).!" "ERROR" "CSV-E-1"
                        }
                    }
                    if {(($cmd_cnt > 127) && ([regexp -nocase {WRRD} $cmd])) || (($cmd_cnt > 511) && ([regexp -nocase {READ|WRITE} $cmd]))} {
                        print_msg x "[dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst] has incompatible sequence of commands. In MEM TG mode, total number of commands allowed per IP exceeds 127. This is is illegal. Please correct the CSV (at line [dict get $x csv_encode $i cmd csv_line]).!" "ERROR" "CSV-E-1"
                    }
                    if {($cmd == "") && (!([regexp -nocase {LOOP} [dict get $x "csv_encode" $i cmd val]]))} {
                        set cmd [dict get $x "csv_encode" $i cmd val]
                    }
                }
            }
        }
    }

    set ip_list [list]
    set no_id_line_cnt 0
    if {[dict exists $x csv_encode]} {
        set alter_csv_encode [dict create]
        set acc 0
        set val ""
        set enc ""
        for {set i 0} {$i < [llength [dict keys [dict get $x csv_encode]]]} {incr i} {
            foreach cell [dict keys [dict get $x csv_template [dict get $x file_args prot]]] {
                set cell_val [dict get $x "csv_encode" $i $cell val]
                if {$cell == "TG_NUM"} {
                    if {([regexp -nocase {PHASE_DONE} [dict get $x csv_encode $i "cmd" val]]) && ($cell_val != "")} {
                        print_msg x "The command line 'PHASE_DONE' should not be associcated with any TG_NUM (Source ID). But it is associated with TG_NUM $cell_val in the input csv file [dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst]. Removing the TG_NUM association with 'PHASE_DONE' command!." "WARNING" "CSV-W-1"
                        dict set $x csv_encode $i "TG_NUM" val ""
                    }
                    if {[dict get $x csv_encode $i $cell val] == ""} {
                        incr no_id_line_cnt
                    } else {
                        if {[lsearch -exact $ip_list [dict get $x csv_encode $i $cell val]] == -1} {
                            lappend ip_list [dict get $x csv_encode $i $cell val]
                        }
                    }
                }
                set eval_pv 0
                set dep_mat 0
                set cell_enc ""
                if {[dict exists $x csv_template [dict get $x file_args prot] $cell pv]} {
                    foreach pv_idx [dict keys [dict get $x csv_template [dict get $x file_args prot] $cell pv]] {
                        set dep 1
                        if {[dict exists $x csv_template [dict get $x file_args prot] $cell pv $pv_idx dep]} {
                            set dep_val [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx dep]
                            while {[regexp {\#} $dep_val]} {
                                regexp {([a-zA-Z]+)#([a-zA-z0-9_,~]+)} $dep_val match pd param
                                set p_l [get_param_val $pd $param x "" $i ""]
                                if {[lindex $p_l 0] == 1} {
                                    regsub -all "$pd\#$param" $dep_val [lindex $p_l 1] dep_val
                                } elseif {[lindex $p_l 0] == 0} {
                                    break
                                }
                            }
                            set dep [expr $dep_val]
                        }
                        if {$dep == 1} {
                            set dep_mat 1
                            set type [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx type]
                            if {[dict exists $x csv_template [dict get $x file_args prot] $cell pv $pv_idx enc]} {
                                set enc [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx enc]
                                if {($enc == "s") && (([regexp -nocase {[\w]+} $cell_val]) || ($cell_val == ""))} {
                                    if {$type == "lst"} {
                                        if {[lsearch -nocase -exact [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type] $cell_val] > -1} {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    } elseif {$type == "val"} {
                                        if {[dict exists $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type]} {
                                            if {[string compare -nocase $cell_val [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type]] == 0} {
                                                set eval_pv 1
                                                set cell_enc $enc
                                                break
                                            }
                                        } else {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    }
                                } elseif {($enc == "h") && ([regexp -nocase {^0[xX]} $cell_val])} {
                                    set cell_val [string map {\_ ""} $cell_val]
                                    if {$type == "rng"} {
                                        set min [expr [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx min]]
                                        set max [expr [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx max]]
                                        if {([expr $cell_val] >= $min) && ([expr $cell_val] <= $max)} {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    } elseif {$type == "lst"} {
                                        foreach val [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type] {
                                            if {[expr $cell_val] == [expr $val]} {
                                                set eval_pv 1
                                                set cell_enc $enc
                                                break
                                            }
                                        }
                                        if {$eval_pv == 1} {
                                            break
                                        }
                                    } elseif {$type == "val"} {
                                        if {[expr $cell_val] == [expr {[dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type]}]} {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    }
                                } elseif {($enc == "d") && ([regexp -nocase {^\d+$} $cell_val])} {
                                    if {$type == "rng"} {
                                        set min [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx min]
                                        set max [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx max]
                                        if {($cell_val >= $min) && ($cell_val <= $max)} {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    } elseif {$type == "lst"} {
                                        if {[lsearch -nocase -exact [dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type] $cell_val] > -1} {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    } elseif {$type == "val"} {
                                        if {[dict get $x csv_template [dict get $x file_args prot] $cell pv $pv_idx $type] == $cell_val} {
                                            set eval_pv 1
                                            set cell_enc $enc
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    set eval_pv 1
                    set dep_mat 1
                    set cell_enc [lindex [dict get $x csv_template [dict get $x file_args prot] $cell enc] 0]
                }
                if {($eval_pv == 0) && ($dep_mat == 1)} {
                    if {[dict exists $x csv_template [dict get $x file_args prot] $cell default]} {
                        set type [dict get $x csv_template [dict get $x file_args prot] $cell default type]
                        if {$type == "val"} {
                            if {$cell_val == ""} {
                                dict set x "csv_encode" $i $cell val [dict get $x csv_template [dict get $x file_args prot] $cell default $type]
                                dict set x "csv_encode" $i $cell enc [dict get $x csv_template [dict get $x file_args prot] $cell default enc]
                                print_msg x "At line [dict get $x csv_encode $i $cell csv_line] of the input file [dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst], the Cell value for $cell is empty. Considering the default value [dict get $x "csv_encode" $i $cell val]" "CRITICAL WARNING" "CSV-CW-6"
                            } else {
                                print_msg x "At line [dict get $x csv_encode $i $cell csv_line] of the input file [dict get $x file_args csv_file] of IP [dict get $x file_args ip_inst], the Cell value for $cell is incompatible." "ERROR" "CSV-E-2"
                            }
                        }
                    } else {
                        print_msg x "At line [dict get $x csv_encode $i $cell csv_line] of the input file [dict get $x file_args csv_file] the Cell value for $cell is incompatible." "ERROR" "CSV-E-2"
                    }
                } elseif {$dep_mat == 0} {
                    if {[dict exists $x csv_template [dict get $x file_args prot] $cell other]} {
                        set type [dict get $x csv_template [dict get $x file_args prot] $cell other type]
                        if {$type == "rgex"} {
                            if {[regexp [dict get $x csv_template [dict get $x file_args prot] $cell other $type] $cell_val]} {
                            } else {
                                dict set x "csv_encode" $i $cell val 0
                                dict set x "csv_encode" $i $cell enc "d"
                                #print_msg x "At line [dict get $x csv_encode $i $cell csv_line] of the input file [dict get $x file_args csv_file] the Cell value for $cell is not the supported value. Considering the default value of '0'" "WARNING" "CSV-W-2"
                            }
                        }
                    }
                } else {
                    dict set x "csv_encode" $i $cell enc $cell_enc
                    if {[dict exists $x csv_template [dict get $x file_args prot] $cell vldty]} {
                        set dep 1
                        if {[dict exists $x csv_template [dict get $x file_args prot] $cell vldty dep]} {
                            if {[dict exists $x csv_template [dict get $x file_args prot] $cell vldty dep]} {
                                set dep_val [dict get $x csv_template [dict get $x file_args prot] $cell vldty dep]
                                while {[regexp {\#} $dep_val]} {
                                    regexp {([a-zA-Z]+)#([a-zA-z0-9_,~]+)} $dep_val match pd param
                                    set p_l [get_param_val $pd $param x "" $i ""]
                                    if {[lindex $p_l 0] == 1} {
                                        regsub -all "$pd\#$param" $dep_val [lindex $p_l 1] dep_val
                                    } elseif {[lindex $p_l 0] == 0} {
                                        break
                                    }
                                }
                                set dep [expr $dep_val]
                            }
                        }
                        if {$dep == 1} {
                            set type [dict get $x csv_template [dict get $x file_args prot] $cell vldty type]
                            set val [dict get $x csv_template [dict get $x file_args prot] $cell vldty $type]
                            if {$type == "eq"} {
                                while {[regexp {\#} $val]} {
                                    regexp {([a-zA-Z]+)#([a-zA-z0-9_,~]+)} $val match pd param
                                    set p_l [get_param_val $pd $param x "" $i [dict get $x csv_template [dict get $x file_args prot] $cell vldty enc]]
									#puts "param: $param; $p_l"
                                    if {[lindex $p_l 0] == 1} {
                                        regsub -all "$pd\#$param" $val [lindex $p_l 1] val
                                    } elseif {[lindex $p_l 0] == 0} {
                                        break
                                    }
                                }
                                if {[expr $val]} {
                                } else {
                                    set val [dict get $x csv_template [dict get $x file_args prot] $cell vldty $type]
                                    regsub -all {[a-zA-Z]+#|expr} $val "" val
                                    print_msg x "At line [dict get $x csv_encode $i $cell csv_line] of the input file [dict get $x file_args csv_file] the Cell value for $cell is incompatible with the equation \"$val\"." "ERROR" "CSV-E-3"
                                }
                            }
                        }
                    }
                    if {[dict exists $x csv_template [dict get $x file_args prot] $cell map]} {
                        foreach map_name [dict keys [dict get $x csv_template [dict get $x file_args prot] $cell map]] {
                            if {[regexp -nocase "^$map_name$" $cell_val]} {
                                dict set x "csv_encode" $i $cell val [dict get $x csv_template [dict get $x file_args prot] $cell map $map_name]
                                dict set x "csv_encode" $i $cell enc [dict get $x csv_template [dict get $x file_args prot] $cell map_enc]
                            }
                        }
                    }
                }
            }
            # MEM_TG commands elaboration in to usable commands
            if {[regexp -nocase {WRRD} [dict get $x csv_encode $i cmd val]]} {
                set cmd_seq []
                if {[dict get $x csv_encode $i cmd val] == "WRRD"} {
                        set cmd_seq [list WRITE WAIT READ WAIT]
                } elseif {[dict get $x csv_encode $i cmd val] == "WRRDSIM"} {
                        set cmd_seq [list WRITE READ]
                } elseif {[dict get $x csv_encode $i cmd val] == "WRRDINF"} {
                    set cmd_seq [list WRITE WAIT START_LOOP READ END_LOOP]
                }
                if {[dict get $x csv_encode $i TG_NUM val] == ""} {
                    incr no_id_line_cnt [expr {[llength $cmd_seq] - 1}]
                }
                for {set cs 0} {$cs < [llength $cmd_seq]} {incr cs} {
                    foreach cell [dict keys [dict get $x csv_template [dict get $x file_args prot]]] {
                        dict set alter_csv_encode $acc $cell [dict get $x csv_encode $i $cell]
                        if {$cell == "cmd"} {
                            dict set alter_csv_encode $acc $cell val [lindex $cmd_seq $cs]
                        }
                        if {[lindex $cmd_seq $cs] == "WAIT"} {
                            if {($cell == "cmd") || ($cell == "TG_NUM")} {
                            } else {
                                dict set alter_csv_encode $acc $cell val ""
                            }
                        }
                        if {[lindex $cmd_seq $cs] == "START_LOOP"} {
                            if {($cell == "cmd") || ($cell == "TG_NUM") || ($cell == "loop_incr_by")} {
                            } elseif {$cell == "txn_count"} {
                                dict set alter_csv_encode $acc $cell val "INF"
                                dict set alter_csv_encode $acc $cell enc "s"
                            } else {
                                dict set alter_csv_encode $acc $cell val ""
                            }
                        }
                        if {[lindex $cmd_seq $cs] == "END_LOOP"} {
                            if {($cell == "cmd") || ($cell == "TG_NUM")} {
                            } else {
                                dict set alter_csv_encode $acc $cell val ""
                            }
                        }
                    }
                    incr acc
                }
            } else {
                dict set alter_csv_encode $acc [dict get $x csv_encode $i]
                incr acc
            }
        }
        dict unset x "csv_encode"
        dict set x "csv_encode" [dict get $alter_csv_encode]
    } else {
        set sev "CRITICAL WARNING"
        set msg_code "CSV-CW-2"
        if {![dict exists $x file_args local_run]} {
            if {[get_parameter_property DG_SCR_SEV]} {
                set sev "WARNING"
                set msg_code "CSV-W-4"
            }
        }
        print_msg x "The input csv file [dict get $x file_args csv_file] is empty. Creating .mem file with single 'PHASE_DONE' command info!." $sev $msg_code
        foreach cell [dict keys [dict get $x csv_template [dict get $x file_args prot]]] {
            set cell_col [dict get $x csv_template [dict get $x file_args prot] $cell col]
            set cell_enc "d"
            if {$cell == "cmd"} {
                set cell_val "PHASE_DONE"
                set cell_enc "s"
            } elseif {$cell == "TG_NUM"} {
                set cell_val ""
            } else {
                set cell_val 0
            }
            dict set x csv_encode "0" $cell val $cell_val
            dict set x csv_encode "0" $cell enc $cell_val
        }
        incr no_id_line_cnt
    }
    dict set x runtime_opts ip_id_list $ip_list
    dict set x runtime_opts no_id_line_cnt $no_id_line_cnt
}

proc csv_to_dict {glb_var} {
    upvar 1 $glb_var x
    set csv_lines [list]
    if {[dict exists $x file_args local_run]} {
        if {[catch {open [dict get $x file_args csv_file] r} fileId]} {
            puts stderr "csv_file: $fileId"
        } else {
            set csv_file [read $fileId]
        }
        set csv_lines [split $csv_file '\n']
    } else {
        set csv_file [dict get $x file_args csv_file]
        while { [ gets_ipfile [dict get $x file_args csv_file] csv_line ] > 0} {
            set csv_line [string trimright $csv_line]
            lappend csv_lines $csv_line
        }
        close_ipfile [dict get $x file_args csv_file]
    }
    set i 0
    set csv_line_cnt 0
    while { [llength $csv_lines] > 0 } {
        incr csv_line_cnt
        set csv_line [lindex $csv_lines 0]
        set csv_lines [lreplace $csv_lines 0 0]
        # Empty line
        if {$csv_line == ""} {
            continue
        }
        if {[regexp {^[\s\t\r\n\,]+$} $csv_line]} {
            continue
        }
        # A comment line or Header line
        if {[regexp {^[\"\#\s\ta-zA-Z]+} $csv_line]} {
            continue
        }
        set csv_col [split $csv_line ,]
        foreach cell [dict keys [dict get $x csv_template [dict get $x file_args prot]]] {
            set cell_col [dict get $x csv_template [dict get $x file_args prot] $cell col]
            set cell_val [lindex $csv_col $cell_col]
            regsub -all {[\s\t\n]*} $cell_val "" cell_val
            dict set x csv_encode $i $cell val $cell_val
            dict set x csv_encode $i $cell csv_line $csv_line_cnt
        }
        incr i
    }
    elab_eval_in_csv x
}

proc eval_runtime_opts {glb_var} {
    upvar 1 $glb_var x

    if {[dict get $x runtime_opts no_id_line_cnt] == [llength [dict keys [dict get $x csv_encode]]]} {
        dict set x runtime_opts "apply_to_all_ip_id" 1
        dict set x csv_lines_per_id "NA" [dict get $x csv_encode]
    } else {
        dict set x runtime_opts "apply_to_all_ip_id" 0
        foreach line [dict keys [dict get $x csv_encode]] {
            if {([dict get $x "csv_encode" $line "TG_NUM" val] == "") || ([regexp -nocase {PHASE_DONE} [dict get $x "csv_encode" $line cmd val]])} {
                foreach ip_id [dict get $x runtime_opts ip_id_list] {
                    set line_cnt 0
                    if {[dict exists $x csv_lines_per_id $ip_id]} {
                        set line_cnt [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]]
                    }
                    dict set x csv_lines_per_id $ip_id $line_cnt [dict get $x csv_encode $line]
                    dict set x csv_lines_per_id $ip_id $line_cnt "TG_NUM" val $ip_id
                }
            } else {
                set ip_id [dict get $x "csv_encode" $line TG_NUM val]
                set line_cnt 0
                if {[dict exists $x csv_lines_per_id $ip_id]} {
                    set line_cnt [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]]
                }
                dict set x csv_lines_per_id $ip_id $line_cnt [dict get $x csv_encode $line]
            }
        }
    }
    #add PHASE_DONE command to the last line of each IP_ID, if there no such command
    set pd_add_ids []
    set pd_cmd 0
    foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
        if {[regexp -nocase {PHASE_DONE} [dict get $x csv_lines_per_id $ip_id [expr {[llength [dict keys [dict get $x csv_lines_per_id $ip_id]]]-1}] "cmd" val]]} {
        } else {
            set pd_cmd 1
            lappend pd_add_ids $ip_id
        }
    }

    if {$pd_cmd == 1} {
        print_msg x "The Source ids: [join $pd_add_ids ,] do not have the last command as 'PHASE_DONE', hence adding 'PHASE_DONE' command as last command to all the TG ids in the input csv file : [dict get $x file_args csv_file]!." "WARNING" "CSV-W-5"
        foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
            set line_cnt [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]]
            foreach cell [dict keys [dict get $x csv_template [dict get $x file_args prot]]] {
                set enc [lindex [dict get $x csv_template [dict get $x file_args prot] $cell enc] 0]
                if {$cell == "TG_NUM"} {
                    if {$ip_id == "NA"} {
                        dict set x csv_lines_per_id $ip_id $line_cnt $cell val ""
                    } else {
                        dict set x csv_lines_per_id $ip_id $line_cnt $cell val $ip_id
                    }
                } elseif {$cell == "cmd"} {
                    dict set x csv_lines_per_id $ip_id $line_cnt $cell val "PHASE_DONE"
                } else {
                    dict set x csv_lines_per_id $ip_id $line_cnt $cell val 0
                }
                dict set x csv_lines_per_id $ip_id $line_cnt $cell enc $enc
            }
        }
    }
    if {[dict exists $x file_args local_run]} {
    } else {
        if {[dict get $x file_args prot] == "AXIS"} {
            foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
                if {[dict get $x file_args ip_id] == $ip_id} {
                    foreach csv_line [dict keys [dict get $x csv_lines_per_id $ip_id]] {
                        if {[dict get $x csv_lines_per_id $ip_id $csv_line cmd val] == "STREAM"} {
                            set ip_inst [current_inst]
                            if {[regexp -nocase {^0x|^[0-9a-f\_]*$} [dict get $x csv_lines_per_id $ip_id $csv_line noc_dest_id val]]} {
                                print_msg x "noc_dest_id value \[[dict get $x csv_lines_per_id $ip_id $csv_line noc_dest_id val]\] already exists in the input csv file : [dict get $x file_args csv_file]. Please check if the value is corret. If you are unsure, remove the value, and let the IP calculate the value as per the design" "WARNING" "CSV-W-3"
                            } else {
                                set sDEST_IDs [get_parameter_property USER_SLAVE_DST_ID]
                                if  {[string equal $sDEST_IDs ""]}  {
                                    print_msg x "No info regarding the Dest IDs available for IP $ip_inst!" "ERROR" "CSV-E-4"
                                }
                                foreach Did [split $sDEST_IDs ','] {
                                    set dDEST_IDs [regsub -all ":" $Did " "]
                                    dict for {NSU DID} $dDEST_IDs {
                                        if {[dict get $x csv_lines_per_id $ip_id $csv_line noc_dest_id val] == $NSU} {
                                            if {[regexp -nocase {^0[xX]} $DID]} {
                                            } else {
                                                set DID "0x$DID"
                                            }
                                            dict set x csv_lines_per_id $ip_id $csv_line noc_dest_id val $DID
                                            dict set x csv_lines_per_id $ip_id $csv_line noc_dest_id enc h
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

proc get_mem_ph {glb_var param type} {
    upvar 1 $glb_var x

    foreach idx [dict keys [dict get $x mem_encode $type]] {
        if {[dict get $x mem_encode $type $idx name] == $param} {
            return $idx
        }
    }
    return -1
}

proc mem_format {mem_dict format} {
    set mem_file [list]
    foreach mem_line [dict keys $mem_dict] {
        set mem_cmd_line ""
        for {set i [expr [llength [dict keys [dict get $mem_dict $mem_line]]] -1]} {$i >= 0} {incr i -1} {
            binary scan [binary format W* [dict get $mem_dict $mem_line $i val]] B* raw_bin
            set fw_bin [string range $raw_bin [expr [string length $raw_bin] - [dict get $mem_dict $mem_line $i width]] [string length $raw_bin]]
            append mem_cmd_line $fw_bin
        }
        if {$format == "h"} {
            set bl_len [string length $mem_cmd_line]
            set len_c 0
            set hl ""
            while {1} {
            if {[expr ($bl_len - $len_c)] == 0} {
                break
            }
            if {[expr ($bl_len - $len_c - 4)] < 0} {
                set n [string range $mem_cmd_line 0 [expr ($bl_len - $len_c - 1)]]
                for {set i 0} {$i < [expr (4 - ($bl_len - $len_c))]} {incr i} {
                    set n "0$n"
                }
                set b $n
                binary scan [binary format B4 $n] H n
                append hl $n
                break
            } else {
                set n [string range $mem_cmd_line [expr ($bl_len - $len_c - 4)] [expr ($bl_len - $len_c - 1)]]
            }
            set b $n
            binary scan [binary format B4 $n] H n
            append hl $n
            incr len_c 4
            }
            lappend mem_file [string reverse $hl]
        } else {
            lappend mem_file $mem_cmd_line
        }
    }
    return $mem_file
}

proc csv_encode {glb_var ri ip_id} {
    upvar 1 $glb_var x

    set cmd [dict get $x csv_lines_per_id $ip_id $ri cmd val]
    # The below command updates the runtime opts for LOOP commands
    if {$cmd == "START_LOOP"} {
        dict set x runtime_opts loop_instr $ip_id loop_en 1
        dict set x runtime_opts loop_instr $ip_id start_loop 1
        dict set x runtime_opts loop_instr $ip_id loop_cmd_cnt 0
        if {[dict get $x file_args prot] == "AXIMM"} {
            if {[dict get $x csv_lines_per_id $ip_id $ri loop_incr_by val] == ""} {
                dict set x runtime_opts loop_instr $ip_id loop_incr_by_mem 0
            } else {
                dict set x runtime_opts loop_instr $ip_id loop_incr_by_mem [dict get $x csv_lines_per_id $ip_id $ri loop_incr_by val]
            }
            if {[dict get $x csv_lines_per_id $ip_id $ri txn_count val] == "INF"} {
                dict set x runtime_opts loop_instr $ip_id loop_cnt 0
                dict set x runtime_opts loop_instr $ip_id loop_infi 1
            } else {
                set val [dict get $x csv_lines_per_id $ip_id $ri txn_count val]
                dict set x runtime_opts loop_instr $ip_id loop_cnt $val
                dict set x runtime_opts loop_instr $ip_id loop_infi 0
            }
        } else {
            if {[dict get $x csv_lines_per_id $ip_id $ri inter_transfer_delay val] == ""} {
                dict set x runtime_opts loop_instr $ip_id loop_incr_by_mem 0
            } else {
                dict set x runtime_opts loop_instr $ip_id loop_incr_by_mem [dict get $x csv_lines_per_id $ip_id $ri inter_transfer_delay val]
            }
            if {[dict get $x csv_lines_per_id $ip_id $ri pkt_count val] == "INF"} {
                dict set x runtime_opts loop_instr $ip_id loop_cnt 0
                dict set x runtime_opts loop_instr $ip_id loop_infi 1
            } else {
                set val [dict get $x csv_lines_per_id $ip_id $ri pkt_count val]
                dict set x runtime_opts loop_instr $ip_id loop_cnt $val
                dict set x runtime_opts loop_instr $ip_id loop_infi 0
            }
        }
        return
    } elseif {$cmd == "END_LOOP"} {
        dict set x runtime_opts loop_instr $ip_id loop_en 0
        foreach id [dict keys [dict get $x runtime_opts loop_instr]] {
            set loop_addr_idx [get_mem_ph x "loop_addr" [dict get $x file_args prot]]
            if {$loop_addr_idx > -1} {
                dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id last_cmd_line] $loop_addr_idx val [dict get $x runtime_opts loop_instr $id loop_en_line]
            }
            if {[dict get $x file_args prot] == "AXIMM"} {
                set loop_idx [get_mem_ph x "loop" [dict get $x file_args prot]]
                if {$loop_idx > -1} {
                    dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id last_cmd_line] $loop_idx val 1
                }
            }
            set end_loop_idx [get_mem_ph x "end_loop" [dict get $x file_args prot]]
            if {$end_loop_idx > -1} {
                dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id last_cmd_line] $end_loop_idx val 1
            }
            set loop_start_idx [get_mem_ph x "loop_start" [dict get $x file_args prot]]
            if {$loop_start_idx > -1} {
                if {[dict get $x file_args prot] == "AXIMM"} {
                    # JCD
                    if {[dict exists $x runtime_opts loop_instr $id loop_cmd_line]} {
                        foreach c [dict keys [dict get $x runtime_opts loop_instr $id loop_cmd_line]] {
                            dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id loop_cmd_line $c] $loop_start_idx val 1
                        }
                    }
                } else {
                    dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id loop_en_line] $loop_start_idx val 1
                }
            }
            # Delete reusable commands
            dict unset x runtime_opts loop_instr $id loop_cmd_line
        }
        return
    }

    set mem_line 0
    if {[dict exists $x mem_lines $ip_id [dict get $x file_args prot]]} {
        set mem_line [llength [dict keys [dict get $x mem_lines $ip_id [dict get $x file_args prot]]]]
    }

    if {[regexp {WAIT|PHASE_DONE|WRITE|READ|STREAM} $cmd]} {
        dict set x runtime_opts "last_cmd_line" $ip_id $mem_line
        if {$cmd == "READ"} {
            dict set x runtime_opts "last_rd_cmd_line" $ip_id $mem_line
        }
        if {$cmd == "WRITE"} {
            dict set x runtime_opts "last_wr_cmd_line" $ip_id $mem_line
        }
    }

    set cnt 0
    foreach ci [dict keys [dict get $x mem_encode [dict get $x file_args prot]]] {
        if {[dict exists $x mem_encode [dict get $x file_args prot] $ci val]} {
            dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci val [dict get $x mem_encode [dict get $x file_args prot] $ci val]
        } elseif {[dict get $x mem_encode [dict get $x file_args prot] $ci type] == "val"} {
            set name [dict get $x mem_encode [dict get $x file_args prot] $ci name]
            set val [dict get $x csv_lines_per_id $ip_id $ri $name val]
            if {$val == ""} {
                set val 0
            } else {
                if {[dict get $x csv_lines_per_id $ip_id $ri $name enc] == "h"} {
                    set val [string map {"_" ""} $val]
                    if {[regexp {^0[xX]} $val]} {
                    } else {
                        set val "0x$val"
                    }
                    #set val [format %u $val]
                    set val [expr $val]
                }
            }
            dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci val $val
        } elseif {[dict get $x mem_encode [dict get $x file_args prot] $ci type] == "eq"} {
            set eq [dict get $x mem_encode [dict get $x file_args prot] $ci eq]
            while {[regexp {\#} $eq]} {
                regexp {([A-Z])#([a-zA-z0-9_,~]+)} $eq match pd param
                set line $ri
                if {$pd == "M"} {
                    set line [expr {[llength [dict keys [dict get $x mem_lines $ip_id [dict get $x file_args prot]]]] -1}]
                }
                set p_l [get_param_val $pd $param x $ip_id $line ""]
                if {[lindex $p_l 0] == 1} {
                    regsub -all "$pd\#$param" $eq [lindex $p_l 1] eq
                } elseif {[lindex $p_l 0] == 0} {
                    break
                }
            }
            dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci val [expr $eq]
        }
        dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci width [dict get $x mem_encode [dict get $x file_args prot] $ci width]
        dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci name [dict get $x mem_encode [dict get $x file_args prot] $ci name]
        set bit_rng "$cnt:"
        set cnt [expr ($cnt+[dict get $x mem_encode [dict get $x file_args prot] $ci width])]
        append bit_rng [expr ($cnt -1)]
        dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci bit_rng $bit_rng
    }

    if {[dict exists $x runtime_opts loop_instr $ip_id loop_en]} {
        if {[dict get $x runtime_opts loop_instr $ip_id loop_en] == 1} {
            dict set x runtime_opts loop_instr $ip_id start_loop 0
            if {[dict get $x runtime_opts loop_instr $ip_id loop_cmd_cnt] == 0} {
                dict set x runtime_opts loop_instr $ip_id loop_en_line $mem_line
            }
            if {[dict exists $x runtime_opts loop_instr $ip_id loop_cmd_line $cmd]} {
            } else {
                dict set x runtime_opts loop_instr $ip_id loop_cmd_line $cmd $mem_line
            }
            dict set x runtime_opts loop_instr $ip_id last_cmd_line $mem_line
            dict set x runtime_opts loop_instr $ip_id loop_cmd_cnt [expr ([dict get $x runtime_opts loop_instr $ip_id loop_cmd_cnt] + 1)]
        }
    }
}

proc create_mem {glb_var} {
    upvar 1 $glb_var x
    eval_runtime_opts x

    if {([dict get $x file_args ip_id] == "all") || ([lsearch -exact [dict get $x runtime_opts ip_id_list] [dict get $x file_args ip_id]] != -1) || ([dict get $x runtime_opts apply_to_all_ip_id] == 1)} {
        foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
            set create_mem 0
            if {[dict get $x runtime_opts apply_to_all_ip_id] == 1} {
                set create_mem 1
            } else {
                if {[dict get $x file_args ip_id] == "all"} {
                    set create_mem 1
                } else {
                    if {$ip_id == [dict get $x file_args ip_id]} {
                        set create_mem 1
                    }
                }
            }
            if {$create_mem == 1} {
                foreach ri [dict keys [dict get $x csv_lines_per_id $ip_id]] {
                    csv_encode x $ri $ip_id
                }
            }
        }
    } else {
        print_msg x "There are no commands belonging to Source ID : [dict get $x file_args ip_id] in the input csv file : [dict get $x file_args csv_file]. Hence creating .mem file with 'PHASE_DONE' command(s) info!." "CRITICAL WARNING" "CSV-CW-4"
        foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
            set line_cnt [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]]
            foreach cell [dict keys [dict get $x csv_template [dict get $x file_args prot]]] {
                set enc [lindex [dict get $x csv_template [dict get $x file_args prot] $cell enc] 0]
                if {$cell == "TG_NUM"} {
                    dict set x csv_lines_per_id $ip_id $line_cnt $cell val $ip_id
                } elseif {$cell == "cmd"} {
                    dict set x csv_lines_per_id $ip_id $line_cnt $cell val "PHASE_DONE"
                } else {
                    dict set x csv_lines_per_id $ip_id $line_cnt $cell val 0
                }
                dict set x csv_lines_per_id $ip_id $line_cnt $cell enc $enc
            }
        }
        set some_ip_id [lindex [dict keys [dict get $x csv_lines_per_id]] 0]
        set line_cnt 0
        foreach ri [dict keys [dict get $x csv_lines_per_id $some_ip_id]] {
            if {[regexp -nocase {PHASE_DONE} [dict get $x csv_lines_per_id $some_ip_id $ri cmd val]]} {
                dict set x csv_lines_per_id [dict get $x file_args ip_id] $line_cnt [dict get $x csv_lines_per_id $some_ip_id [expr {[llength [dict keys [dict get $x csv_lines_per_id $some_ip_id]]]-1}]]
                dict set x csv_lines_per_id [dict get $x file_args ip_id] $line_cnt TG_NUM [dict get $x file_args ip_id]
                incr line_cnt
            }
        }
        foreach ri [dict keys [dict get $x csv_lines_per_id [dict get $x file_args ip_id]]] {
            csv_encode x $ri [dict get $x file_args ip_id]
        }
    }

    # Check for mem file content
    if {[dict exists $x mem_lines]} {
    } else {
        print_msg x "[dict get $x file_args ip_inst].mem file cannot be created as none of the csv lines have the TG_NUM cell value matching with that of the [dict get $x file_args ip_inst] IP source ID information!." "ERROR" "CSV-E-5"
    }

    # Post Processing
    foreach id [dict keys [dict get $x runtime_opts last_cmd_line]] {
        set last_inst_idx [get_mem_ph x "last_inst" [dict get $x file_args prot]]
        if {$last_inst_idx > -1} {
            dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts last_cmd_line $id] $last_inst_idx val 1
        }
    }

    if {[dict exists $x runtime_opts last_wr_cmd_line]} {
        foreach id [dict keys [dict get $x runtime_opts last_wr_cmd_line]] {
            set last_wr_rd_cmd_idx [get_mem_ph x "last_wr_rd_cmd" [dict get $x file_args prot]]
            if {$last_wr_rd_cmd_idx > -1} {
                dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts last_wr_cmd_line $id] $last_wr_rd_cmd_idx val 2
            }
        }
    }

    if {[dict exists $x runtime_opts last_rd_cmd_line]} {
        foreach id [dict keys [dict get $x runtime_opts last_rd_cmd_line]] {
            set last_wr_rd_cmd_idx [get_mem_ph x "last_wr_rd_cmd" [dict get $x file_args prot]]
            if {$last_wr_rd_cmd_idx > -1} {
                dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts last_rd_cmd_line $id] $last_wr_rd_cmd_idx val 1
            }
        }
    }

    # Saving the mem content to a file
    set type "vivado"
    if {[dict exists $x file_args local_run]} {
        set type "local"
    }
    if {[dict get $x file_args ip_id] == "all"} {
        foreach id [dict keys [dict get $x mem_lines]] {
            write_file $type [mem_format [dict get $x mem_lines $id [dict get $x file_args prot]] [dict get $x file_args mem_file_enc]] [concat [dict get $x file_args op_path]/[dict get $x file_args ip_inst]_$id] "mem" A
        }
    } else {
        set ipid ""
        if {[dict get $x runtime_opts apply_to_all_ip_id] == 1} {
            set ipid "NA"
        } else {
            set ipid [dict get $x file_args ip_id]
        }
        write_file $type [mem_format [dict get $x mem_lines $ipid [dict get $x file_args prot]] [dict get $x file_args mem_file_enc]] [concat [dict get $x file_args op_path]/[dict get $x file_args ip_inst]] "mem" A
    }
}

# The Main Code
set ptg_glb_var [dict create]
set i 0
dict set ptg_glb_var file_args mem_file_enc "h"
if {[llength $argv] == 0} {puts "\nError: No arguments to file.\nPlease provide appropriate Arguments.\n"}
while {$i < [llength $argv]} {
    set iarg [lindex $argv $i]
    if { $iarg == "-csv" } {
        incr i
        dict set ptg_glb_var file_args csv_file [lindex $argv $i]
    }
    if { $iarg == "-ip_id" } {
        incr i
        dict set ptg_glb_var file_args ip_id [lindex $argv $i]
    }
    if { $iarg == "-ip_inst" } {
        incr i
        dict set ptg_glb_var file_args ip_inst [lindex $argv $i]
    }
    if { $iarg == "-op_path" } {
        incr i
        dict set ptg_glb_var file_args op_path [lindex $argv $i]
    }
    if { $iarg == "-mem_file_enc" } {
        incr i
        dict set ptg_glb_var file_args mem_file_enc [lindex $argv $i]
    }
    if { $iarg == "-local_run" } {
        dict set ptg_glb_var file_args local_run 1
    }
    if { $iarg == "-debug_data" } {
        dict set ptg_glb_var file_args debug_data 1
    }
    if { $iarg == "-prot" } {
        incr i
        dict set ptg_glb_var file_args prot [lindex $argv $i]
    }
    if { $iarg == "-tg_mode" } {
        incr i
        dict set ptg_glb_var file_args tg_mode [lindex $argv $i]
    }
    if { $iarg == "-axi_dw" } {
        incr i
        dict set ptg_glb_var file_args axi_dw [lindex $argv $i]
    }
    incr i
}

print_msg ptg_glb_var "CSV to MEM file convertion flow initiated for IP [dict get $ptg_glb_var file_args ip_inst]" "INFO" "CSV-I-1"
csv_template_db ptg_glb_var
mem_encode_db ptg_glb_var

print_msg ptg_glb_var "Parsing the file [dict get $ptg_glb_var file_args csv_file] for IP [dict get $ptg_glb_var file_args ip_inst]" "INFO" "CSV-I-2"
csv_to_dict ptg_glb_var
print_msg ptg_glb_var "Converting the file [dict get $ptg_glb_var file_args csv_file] to MEM file for IP [dict get $ptg_glb_var file_args ip_inst]" "INFO" "CSV-I-3"
create_mem ptg_glb_var
print_msg ptg_glb_var "CSV to MEM file convertion flow Completed for IP [dict get $ptg_glb_var file_args ip_inst]" "INFO" "CSV-I-4"

if {[dict exists $ptg_glb_var file_args debug_data]} {
    set type "vivado"
    if {[dict exists $ptg_glb_var file_args local_run]} {
        set type "local"
    }
    write_file $type $ptg_glb_var [concat [dict get $ptg_glb_var file_args op_path]/[dict get $ptg_glb_var file_args ip_inst]\_debug] "dict" S
}
