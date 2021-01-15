# © Copyright 2019 – 2020 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#******************************************************************************/
#    ____  ____
#   /   /\/   /
#  /___/  \  /    Vendor             : Xilinx
#  \   \   \/     Version            : 1.1
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
#*****************************************************************************

# The Procs
# ==============================================================================
proc csv_encode_db {glb_var} {
    upvar 1 $glb_var x

    dict set x "csv_encode" AXIMM "cmd" enc s
    dict set x "csv_encode" AXIMM "cmd" col 1

    dict set x "csv_encode" AXIMM "txn_count" enc d
    dict set x "csv_encode" AXIMM "txn_count" col 2

    dict set x "csv_encode" AXIMM "start_delay" enc d
    dict set x "csv_encode" AXIMM "start_delay" col 3

    dict set x "csv_encode" AXIMM "inter_beat_delay" enc d
    dict set x "csv_encode" AXIMM "inter_beat_delay" col 4

    dict set x "csv_encode" AXIMM "wdata_pattern" enc s
    dict set x "csv_encode" AXIMM "wdata_pattern" col 5

    dict set x "csv_encode" AXIMM "wdata_pat_value" enc h
    dict set x "csv_encode" AXIMM "wdata_pat_value" col 6

    dict set x "csv_encode" AXIMM "data_integrity" enc s
    dict set x "csv_encode" AXIMM "data_integrity" col 7

    dict set x "csv_encode" AXIMM "dest_id" enc h
    dict set x "csv_encode" AXIMM "dest_id" col 8

    dict set x "csv_encode" AXIMM "base_addr" enc h
    dict set x "csv_encode" AXIMM "base_addr" col 9

    dict set x "csv_encode" AXIMM "high_addr" enc h
    dict set x "csv_encode" AXIMM "high_addr" col 10

    dict set x "csv_encode" AXIMM "addr_incr_by" enc s
    dict set x "csv_encode" AXIMM "addr_incr_by" col 11

    dict set x "csv_encode" AXIMM "axi_addr" enc s
    dict set x "csv_encode" AXIMM "axi_addr" col 12

    dict set x "csv_encode" AXIMM "axi_len" enc h
    dict set x "csv_encode" AXIMM "axi_len" col 13

    dict set x "csv_encode" AXIMM "axi_size" enc h
    dict set x "csv_encode" AXIMM "axi_size" col 14

    dict set x "csv_encode" AXIMM "axi_id" enc s
    dict set x "csv_encode" AXIMM "axi_id" col 15

    dict set x "csv_encode" AXIMM "axi_burst" enc s
    dict set x "csv_encode" AXIMM "axi_burst" col 16

    dict set x "csv_encode" AXIMM "axi_lock" enc s
    dict set x "csv_encode" AXIMM "axi_lock" col 17

    dict set x "csv_encode" AXIMM "axi_cache" enc h
    dict set x "csv_encode" AXIMM "axi_cache" col 18

    dict set x "csv_encode" AXIMM "axi_prot" enc h
    dict set x "csv_encode" AXIMM "axi_prot" col 19

    dict set x "csv_encode" AXIMM "axi_qos" enc h
    dict set x "csv_encode" AXIMM "axi_qos" col 20

    dict set x "csv_encode" AXIMM "axi_region" enc h
    dict set x "csv_encode" AXIMM "axi_region" col 21

    dict set x "csv_encode" AXIMM "axi_user" enc h
    dict set x "csv_encode" AXIMM "axi_user" col 22

    dict set x "csv_encode" AXIS "cmd" enc s
    dict set x "csv_encode" AXIS "cmd" col 1

    dict set x "csv_encode" AXIS "pkt_count" enc d
    dict set x "csv_encode" AXIS "pkt_count" col 2

    dict set x "csv_encode" AXIS "inter_pkt_delay" enc d
    dict set x "csv_encode" AXIS "inter_pkt_delay" col 3

    dict set x "csv_encode" AXIS "inter_transfer_delay" enc d
    dict set x "csv_encode" AXIS "inter_transfer_delay" col 4

    dict set x "csv_encode" AXIS "tdata_pattern" enc s
    dict set x "csv_encode" AXIS "tdata_pattern" col 5

    dict set x "csv_encode" AXIS "tdata_pat_value" enc h
    dict set x "csv_encode" AXIS "tdata_pat_value" col 6

    dict set x "csv_encode" AXIS "noc_dest_id" enc h
    dict set x "csv_encode" AXIS "noc_dest_id" col 8

    dict set x "csv_encode" AXIS "tdest_id" enc h
    dict set x "csv_encode" AXIS "tdest_id" col 12

    dict set x "csv_encode" AXIS "pkt_len" enc h
    dict set x "csv_encode" AXIS "pkt_len" col 13

    dict set x "csv_encode" AXIS "pkt_id" enc s
    dict set x "csv_encode" AXIS "pkt_id" col 15

    dict set x "csv_encode" AXIS "pkt_user" enc h
    dict set x "csv_encode" AXIS "pkt_user" col 22

}

proc mem_encode_db {glb_var} {
    upvar 1 $glb_var x

    # The below code creates a dictionary which defines the encoding scheme and
    # width of each placeholder

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
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^NORMAL$} "C#axi_lock"] ? 0 : [regexp -nocase {^EXCLUSIVE$} "C#axi_lock"] ? 1 : [regexp -nocase {^LOCKED$} "C#axi_lock"] ? 2 : "C#axi_lock") : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #axi_burst
    # i = 6
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "axi_burst"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^fixed$} "C#axi_burst"] ? 0 : [regexp -nocase {^incr$} "C#axi_burst"] ? 1 : [regexp -nocase {^wrap$} "C#axi_burst"] ? 2 : [regexp -nocase {^reserved$} "C#axi_burst"] ? 3 : 1) : 0}
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

    #axi_id
    # i = 9
    dict set x "mem_encode" AXIMM $i width 1
    dict set x "mem_encode" AXIMM $i name "axi_id"
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

    #num_byter_per_txn
    # i = 12
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "num_byter_per_txn"
    dict set x "mem_encode" AXIMM $i type "eq"
    #dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^fixed$} "C#axi_burst"] ? (2**M#axi_size) : [regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? ((2**M#axi_size)*(M#axi_len+1)) : [regexp -nocase {^random$} "C#axi_addr"] ? 0 : [regexp {^0[xX]} "C#addr_incr_by"] ? "C#addr_incr_by" : "0xC#addr_incr_by") : 0}
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^fixed$} "C#axi_burst"] ? (2**M#axi_size) : ([regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? ((2**M#axi_size)*(M#axi_len+1)) : ([regexp -nocase {random} "C#axi_addr"] ? 0 : "C#addr_incr_by"))) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #addr_offset
    # i = 13
    dict set x "mem_encode" AXIMM $i width 48
    dict set x "mem_encode" AXIMM $i name "addr_offset"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? "C#axi_addr" : ([regexp -nocase {random} "C#axi_addr"] ? 0 : "C#axi_addr")) : 0}
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
    #dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^random$} "C#axi_addr"] ? ([regexp {^0[xX]} "C#addr_incr_by"] ? "C#addr_incr_by" : "0xC#addr_incr_by") : 0) : 0}
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {random} "C#axi_addr"] ? "C#addr_incr_by" : 0) : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #addr_pat
    # i = 17
    dict set x "mem_encode" AXIMM $i width 2
    dict set x "mem_encode" AXIMM $i name "addr_pat"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#addr_incr_by"] ? 0 : ([regexp -nocase {^random$} "C#axi_addr"] ? 2 : ([regexp -nocase {^random_aligned$} "C#axi_addr"] ? 3 : 1))) : 0}
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
    #dict set x "mem_encode" AXIMM $i type "eq"
    #dict set x "mem_encode" AXIMM $i eq {("R#loop_instr,~ip_id,loop_en" == "1") && ("R#loop_instr,~ip_id,loop_cmd_cnt" > "1") ? 1 : 0}
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

    #loop_incr_by
    # i = 28
    dict set x "mem_encode" AXIMM $i width 16
    dict set x "mem_encode" AXIMM $i name "loop_incr_by"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {("R#loop_instr,~ip_id,loop_en" == "1") ? "C#inter_beat_delay" : 0}
    dict set x "mem_encode" AXIMM $i enc d
    incr i

    #inst_id_value
    # i = 29
    dict set x "mem_encode" AXIMM $i width 4
    dict set x "mem_encode" AXIMM $i name "inst_id_value"
    dict set x "mem_encode" AXIMM $i type "eq"
    dict set x "mem_encode" AXIMM $i eq {[regexp -nocase {^WRITE|READ$} "C#cmd"] ? ([regexp -nocase {^auto_incr$} "C#axi_id"] ? 0 : "C#axi_id") : 0}
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
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM|WAIT|PHASE_DONE$} "C#cmd"] ? ([regexp -nocase {^INF$} "C#pkt_count"] ? "M#pkt_len" : "C#pkt_count") : 0}
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
    #dict set x "mem_encode" AXIS $i type "val"
    #dict set x "mem_encode" AXIS $i val 0
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
    dict set x "mem_encode" AXIS $i eq {[regexp -nocase {^STREAM$} "C#cmd"] ? ([regexp -nocase {^hammer$} "C#tdata_pattern"] ? 0 : ([regexp -nocase {^constant$} "C#tdata_pattern"] ? "C#tdata_pat_value" : ([regexp -nocase {^random$} "C#tdata_pattern"] ? "C#tdata_pat_value" : 0))) : 0}
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
    #dict set x "mem_encode" AXIS $i type "val"
    #dict set x "mem_encode" AXIS $i val 0
    dict set x "mem_encode" AXIS $i enc d
    incr i

    #loop_start
    # i = 14
    dict set x "mem_encode" AXIS $i width 1
    dict set x "mem_encode" AXIS $i name "loop_start"
    #dict set x "mem_encode" AXIS $i type "eq"
    #dict set x "mem_encode" AXIS $i eq {("R#loop_instr,~ip_id,start_loop" == "1") ? 1 : 0}
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
    #dict set x "mem_encode" AXIS $i type "val"
    #dict set x "mem_encode" AXIS $i val 0
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
    while { [llength $csv_lines] > 0 } {
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
        dict set x "csv_lines" $i $csv_col
        incr i
    }
}

proc eval_runtime_opts {glb_var} {
    upvar 1 $glb_var x

    set no_id_line_cnt 0

    set ip_list [list]
    if {[dict exists $x csv_lines]} {
    } else {
        set msg "The input csv file [dict get $x file_args csv_file] is empty. Creating .mem file with single 'PHASE_DONE' command info!."
        if {[dict exists $x file_args local_run]} {
            puts "CRITICAL WARNING: $msg"
        } else {
            send_msg_id {CSVCW-2} {CRITICAL WARNING} $msg
        }
        dict set x runtime_opts ip_id_list [list]
        dict set x "runtime_opts" "apply_to_all_ip_id" 0
        return
    }
    foreach key [dict keys [dict get $x csv_lines]] {
        set assert_err 0
        set msg ""
        if {([regexp {WRITE|READ} [lindex [dict get $x csv_lines $key] 1]]) && ([dict get $x file_args prot] == "AXIS")} {
            set assert_err 1
            set msg "[dict get $x file_args csv_file] has AXIMM commands where as the script is instructed to create [dict get $x file_args ip_inst].mem with AXIS commands. This is is illegal. Please correct the CSV.!"
        } elseif {([regexp {STREAM} [lindex [dict get $x csv_lines $key] 1]]) && ([dict get $x file_args prot] == "AXIMM")} {
            set assert_err 1
            set msg "[dict get $x file_args csv_file] has AXIS commands where as the script is instructed to create [dict get $x file_args ip_inst].mem with AXIMM commands. This is is illegal. Please correct the CSV.!"
        }
        if {([regexp {PHASE_DONE} [lindex [dict get $x csv_lines $key] 1]]) && ([lindex [dict get $x "csv_lines" $key] 0] != "")} {
            set msg "The command line 'PHASE_DONE' should not be associcated with any TG_NUM (Source ID). But it is associated with TG_NUM [lindex [dict get $x "csv_lines" $key] 0] in the input csv file [dict get $x file_args csv_file]. Removing the TG_NUM association with 'PHASE_DONE' command!."
            if {[dict exists $x file_args local_run]} {
                puts "CRITICAL WARNING: $msg"
            } else {
                send_msg_id {CSVCW-3} {CRITICAL WARNING} $msg
            }
            dict set x csv_lines $key [lreplace [dict get $x "csv_lines" $key] 0 0 ""]
        }
        #puts "ERR:$assert_err"
        if {$assert_err == 1} {
            if {[dict exists $x file_args local_run]} {
                puts "Error: $msg"
                exit
            } else {
                send_msg_id {CSVLDERR-2} "ERROR" $msg
            }
        }
        if {[lindex [dict get $x "csv_lines" $key] 0] == ""} {
            incr no_id_line_cnt
        } elseif {[string is integer [lindex [dict get $x csv_lines $key] 0]]} {
            set ip_id [lindex [dict get $x csv_lines $key] 0]
            if {[lsearch -exact $ip_list $ip_id] == -1} {
                lappend ip_list $ip_id
            }
        }
    }
    dict set x runtime_opts ip_id_list $ip_list

    if {$no_id_line_cnt == [llength [dict keys [dict get $x csv_lines]]]} {
        dict set x "runtime_opts" "apply_to_all_ip_id" 1
        dict set x csv_lines_per_id "NA" [dict get $x csv_lines]
    } else {
        dict set x "runtime_opts" "apply_to_all_ip_id" 0
        foreach line [dict keys [dict get $x csv_lines]] {
            if {[lindex [dict get $x "csv_lines" $line] 0] == ""} {
                foreach ip_id $ip_list {
                    set csv_line [lreplace [dict get $x csv_lines $line] 0 0 $ip_id]
                    if {[dict exists $x csv_lines_per_id $ip_id]} {
                        dict set x csv_lines_per_id $ip_id [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]] $csv_line
                    } else {
                        dict set x csv_lines_per_id $ip_id 0 $csv_line
                    }
                }
            } else {
                set ip_id [lindex [dict get $x "csv_lines" $line] 0]
                if {[dict exists $x csv_lines_per_id $ip_id]} {
                    dict set x "csv_lines_per_id" $ip_id [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]] [dict get $x csv_lines $line]
                } else {
                    dict set x "csv_lines_per_id" $ip_id 0 [dict get $x csv_lines $line]
                }
            }
        }
    }
    # add PHASE_DONE command to the last line of each IP_ID, if there no such command
    set pd_cmd 0
    foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
        if {[regexp -nocase {PHASE_DONE} [lindex [dict get $x csv_lines_per_id $ip_id [expr {[llength [dict keys [dict get $x csv_lines_per_id $ip_id]]]-1}]] 1]]} {
        } else {
            set pd_cmd 1
        }
    }
    if {$pd_cmd == 1} {
        foreach ip_id [dict keys [dict get $x csv_lines_per_id]] {
            set pd_cmd_line [list]
            if {$ip_id == "NA"} {
                lappend pd_cmd_line ""
            } else {
                lappend pd_cmd_line $ip_id
            }
            lappend pd_cmd_line "PHASE_DONE"
            for {set i 0} {$i < 21} {incr i} {
                lappend pd_cmd_line 0
            }
            dict set x csv_lines_per_id $ip_id [llength [dict keys [dict get $x csv_lines_per_id $ip_id]]] $pd_cmd_line
        }
    }
}

proc get_param_val {param_dict param glb_var ip_id mem_line csv_list} {
    upvar 1 $glb_var x
    set val_found 0

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
        if {[dict exists $x mem_lines $ip_id [dict get $x file_args prot] $mem_line]} {
            foreach key [dict keys [dict get $x mem_lines $ip_id [dict get $x file_args prot] $mem_line]] {
                if {[dict get $x mem_lines $ip_id [dict get $x file_args prot] $mem_line $key "name"] == $param} {
                    if {[dict exists $x mem_lines $ip_id [dict get $x file_args prot] $mem_line $key "val"]} {
                        return [list 1 [dict get $x mem_lines $ip_id [dict get $x file_args prot] $mem_line $key "val"]]
                    }
                }
            }
        }
    }
    if {$param_dict == "C"} {
        if {$val_found == 0} {
            set val [lindex $csv_list [dict get $x csv_encode [dict get $x file_args prot] $param col]]
            if {$val == ""} {
                set val 0
            }
            if {[dict get $x csv_encode [dict get $x file_args prot] $param enc] == "h"} {
                set val [string map {\_ ""} $val]
                if {[regexp {^0[xX]} $val]} {
                } else {
                    set val "0x$val"
                }
                set val [format %d $val]
            }
            if {[dict get $x csv_encode [dict get $x file_args prot] $param enc] == "s"} {
                if {[regexp {^0?[xX]?[A-Fa-f0-9\_]+$} $val]} {
                    set val [string map {\_ ""} $val]
                    if {[regexp {^0[xX]} $val]} {
                    } else {
                        set val "0x$val"
                    }
                    set val [format %d $val]
                }
            }
            return [list 1 $val]
        }
    }
    if {$val_found == 0} {
        return [list 0 '']
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

proc csv_encode {glb_var csv_list ip_id} {
    upvar 1 $glb_var x
    set cmd [lindex $csv_list 1]
    regsub -all {\s*} $cmd "" cmd

    #if {[regexp {WRITE|READ} $cmd]} {
    #    dict set x runtime_opts cmd_type $ip_id "AXIMM"
    #} elseif {[regexp {STREAM} $cmd]} {
    #    dict set x runtime_opts cmd_type $ip_id "AXIS"
    #} else {
    #    if {[dict exists $x runtime_opts cmd_type $ip_id]} {
    #    } else {
    #        dict set x runtime_opts cmd_type $ip_id "AXIMM"
    #    }
    #}
    # The below command updates the runtime opts for LOOP commands
    if {$cmd == "START_LOOP"} {
        dict set x runtime_opts loop_instr $ip_id loop_en 1
        dict set x runtime_opts loop_instr $ip_id start_loop 1
        dict set x runtime_opts loop_instr $ip_id loop_cmd_cnt 0
        if {[lindex $csv_list 2] == "INF"} {
            dict set x runtime_opts loop_instr $ip_id loop_cnt 0
            dict set x runtime_opts loop_instr $ip_id loop_infi 1
        } else {
            set val [lindex $csv_list 2]
            dict set x runtime_opts loop_instr $ip_id loop_cnt $val
            dict set x runtime_opts loop_instr $ip_id loop_infi 0
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
            #set start_loop [get_mem_ph x "start_loop" [dict get $x file_args prot]]
            #if {$start_loop > -1} {
            #   dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id last_cmd_line] $start_loop val 1
            #}
            set end_loop_idx [get_mem_ph x "end_loop" [dict get $x file_args prot]]
            #puts "END LOOP: $end_loop_idx"
            if {$end_loop_idx > -1} {
                dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id last_cmd_line] $end_loop_idx val 1
            }
            set loop_start_idx [get_mem_ph x "loop_start" [dict get $x file_args prot]]
            if {$loop_start_idx > -1} {
                if {[dict get $x file_args prot] == "AXIMM"} {
                    foreach c [dict keys [dict get $x runtime_opts loop_instr $id loop_cmd_line]] {
                        dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts loop_instr $id loop_cmd_line $c] $loop_start_idx val 1
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
    }

    set cnt 0
    foreach ci [dict keys [dict get $x mem_encode [dict get $x file_args prot]]] {
        if {[dict exists $x mem_encode [dict get $x file_args prot] $ci val]} {
            dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci val [dict get $x mem_encode [dict get $x file_args prot] $ci val]
        } elseif {[dict get $x mem_encode [dict get $x file_args prot] $ci type] == "val"} {
            set name [dict get $x mem_encode [dict get $x file_args prot] $ci name]
            set val [lindex $csv_list [dict get $x csv_encode [dict get $x file_args prot] $name col]]
            if {$val == ""} {
                set val 0
            }
            if {[dict get $x csv_encode [dict get $x file_args prot] $name enc] == "h"} {
                set val [string map {"_" ""} $val]
                if {[regexp {^0[xX]} $val]} {
                } else {
                    set val "0x$val"
                }
                set val [format %u $val]
            }
            dict set x mem_lines $ip_id [dict get $x file_args prot] $mem_line $ci val $val
        } elseif {[dict get $x mem_encode [dict get $x file_args prot] $ci type] == "eq"} {
            set eq [dict get $x mem_encode [dict get $x file_args prot] $ci eq]
            while {[regexp {\#} $eq]} {
                regexp {([A-Z])#([a-zA-z0-9_,~]+)} $eq match pd param
                set p_l [get_param_val $pd $param x $ip_id $mem_line $csv_list]
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

proc mem_format {mem_dict format} {
    set mem_file [list]
    foreach mem_line [dict keys $mem_dict] {
        set mem_cmd_line ""
        for {set i [expr [llength [dict keys [dict get $mem_dict $mem_line]]] -1]} {$i >= 0} {incr i -1} {
            binary scan [binary format W* [dict get $mem_dict $mem_line $i val]] B* raw_bin
            set fw_bin [string range $raw_bin [expr [string length $raw_bin] - [dict get $mem_dict $mem_line $i width]] [string length $raw_bin]]
            append mem_cmd_line $fw_bin
            #puts "Mem Line: $mem_line; Mem Col: $i; Name: [dict get $mem_dict $mem_line $i name]; Val: [dict get $mem_dict $mem_line $i val]; Width: [dict get $mem_dict $mem_line $i width]; RawBin: $raw_bin; FwBin: $fw_bin"
            #puts "Bin Line: $mem_cmd_line"
        }
        #puts "Mem Line: $mem_cmd_line"
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
                    #set b $n
                    binary scan [binary format B4 $n] H n
                    append hl $n
                    #puts "Mem Line: $mem_line; Bin: $b; Hex: $n; Hex String: [string reverse $hl]"
                    break
                } else {
                    set n [string range $mem_cmd_line [expr ($bl_len - $len_c - 4)] [expr ($bl_len - $len_c - 1)]]
                }
                #set b $n
                binary scan [binary format B4 $n] H n
                append hl $n
                incr len_c 4
                #puts "Mem Line: $mem_line; Bin: $b; Hex: $n; Hex String: [string reverse $hl]"
            }
            #append mem_file [string reverse $hl]
            lappend mem_file [string reverse $hl]
        } else {
            #append mem_file $mem_cmd_line
            lappend mem_file $mem_cmd_line
        }
        #append mem_file "\n"
    }
    return $mem_file
}

proc write_file {write_type mem file type} {
    if {$write_type == "local"} {
        if {[catch {open $file w} fileId]} {
            puts stderr "Cannot open $file : $fileId"
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
        set fh [add_ipfile "$file" -fileType "verilogSource"]
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

proc create_mem {glb_var} {
    upvar 1 $glb_var x
    eval_runtime_opts x
    #write_file local $x [concat [dict get $x file_args op_path]/debug.dict] S

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
                    csv_encode x [dict get $x csv_lines_per_id $ip_id $ri] $ip_id
                }
            }
        }
    } else {
        set msg "There are no commands belonging to Source ID : [dict get $x file_args ip_id] in the input csv file : [dict get $x file_args csv_file]. Hence creating .mem file with 'PHASE_DONE' command(s) info!."
        if {[dict exists $x file_args local_run]} {
            puts "CRITICAL WARNING: $msg"
        } else {
            send_msg_id {CSVCW-4} {CRITICAL WARNING} $msg
        }
        set pd_cmd_line [list ""]
        lappend pd_cmd_line "PHASE_DONE"
        for {set i 0} {$i < 21} {incr i} {
            lappend pd_cmd_line 0
        }
        if {[dict exists $x csv_lines_per_id]} {
            set ip_id [lindex [dict keys [dict get $x csv_lines_per_id]] 0]
            foreach ri [dict keys [dict get $x csv_lines_per_id $ip_id]] {
                if {[regexp -nocase {PHASE_DONE} [lindex [dict get $x csv_lines_per_id $ip_id $ri] 1]]} {
                    csv_encode x $pd_cmd_line [dict get $x file_args ip_id]
                }
            }
        } else {
            csv_encode x $pd_cmd_line [dict get $x file_args ip_id]
        }
    }

    # Check for mem file content
    if {[dict exists $x mem_lines]} {
    } else {
        set msg "[dict get $x file_args ip_inst].mem file cannot be created as none of the csv lines have the TG_NUM cell value matching with that of the [dict get $x file_args ip_inst] IP source ID information!."
        if {[dict exists $x file_args local_run]} {
            puts "Error: $msg"
            exit
        } else {
            send_msg_id {CSVLDERR-2} "ERROR" $msg
        }
    }

    # Post Processing
    foreach id [dict keys [dict get $x runtime_opts last_cmd_line]] {
        set last_inst_idx [get_mem_ph x "last_inst" [dict get $x file_args prot]]
        if {$last_inst_idx > -1} {
            dict set x mem_lines $id [dict get $x file_args prot] [dict get $x runtime_opts last_cmd_line $id] $last_inst_idx val 1
        }
    }

    # Saving the mem content to a file
    set type "vivado"
    if {[dict exists $x file_args local_run]} {
        set type "local"
    }
    if {[dict get $x file_args ip_id] == "all"} {
        foreach id [dict keys [dict get $x mem_lines]] {
            write_file $type [mem_format [dict get $x mem_lines $id [dict get $x file_args prot]] [dict get $x file_args mem_file_enc]] [concat [dict get $x file_args op_path]/[dict get $x file_args ip_inst]_$id\.mem] A
        }
    } else {
        set ipid ""
        if {[dict get $x runtime_opts apply_to_all_ip_id] == 1} {
            set ipid "NA"
        } else {
            set ipid [dict get $x file_args ip_id]
        }
        write_file $type [mem_format [dict get $x mem_lines $ipid [dict get $x file_args prot]] [dict get $x file_args mem_file_enc]] [concat [dict get $x file_args op_path]/[dict get $x file_args ip_inst]\.mem] A
    }
}

# ------------------------------------------------------------------------------

# The Main Code
set ptg_glb_var [dict create]
set i 0
dict set ptg_glb_var file_args mem_file_enc "h"
#puts $argv
#if {$argc == 0} {puts "\nError: No arguments to $argv0.\nPlease provide appropriate Arguments.\n"}
if {[llength $argv] == 0} {puts "\nError: No arguments to file.\nPlease provide appropriate Arguments.\n"}
#puts $argc
#while {$i < $argc} {}
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
    incr i
}

csv_encode_db ptg_glb_var
mem_encode_db ptg_glb_var

csv_to_dict ptg_glb_var
create_mem ptg_glb_var

if {[dict exists $ptg_glb_var file_args debug_data]} {
    set type "vivado"
    if {[dict exists $ptg_glb_var file_args local_run]} {
        set type "local"
    }
    write_file $type $ptg_glb_var [concat [dict get $ptg_glb_var file_args op_path]/debug.dict] S
}
