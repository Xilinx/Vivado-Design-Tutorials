#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#
# Description: Create a guided floorplan for Versal DFX floorplan with disjoint fsr and hsr components
# Methodology:
#   The user is expected to create rm child pblocks after created guided floorplan
#   The existing user defined child pblocks will be automatically moved to new guided child pbock
 
package require Tcl 8.0
package require struct::set
 
namespace eval dfx_utils {
    namespace eval guided_floorplan {
         
        # Data structures to store sites/cells for user defined pblocks
        variable rm_cell
        variable rp_pblock
        variable guided_child_name
        variable user_child_pblock_sites
        variable user_child_pblock_cells
        variable guided_child_pblock
 
        array set user_child_pblock_sites {}
        array set user_child_pblock_cells {}
 
        # initialize data structures
        proc initialize { rm_name } {
            puts "::dfx_utils::guided_floorplan Info: initialize data structures"
            variable rm_cell
            variable user_child_pblock_sites
            variable user_child_pblock_cells
 
            array unset user_child_pblock_sites
            array unset user_child_pblock_cells
 
            array set user_child_pblock_sites {}
            array set user_child_pblock_cells {}
 
            set rm_cell [get_cells $rm_name]
        }
 
        # Print info from user child pblocks
        proc print_user_child_pblocks {} {
            puts "::dfx_utils::guided_floorplan Info: print user child pblocks"
            variable user_child_pblock_sites
            variable user_child_pblock_cells
 
            parray user_child_pblock_sites
            parray user_child_pblock_cells
        }
 
        proc get_topmost_pblock { child_pblock } {
 
            set current_pblock $child_pblock
            set topmost_pblock $current_pblock
            while {$current_pblock != ""} {
                set parent_name [get_property PARENT $current_pblock]
                set parent_pblock [get_pblocks -filter "NAME==$parent_name"]
                 
                if {$parent_pblock == ""} {
                    # can't go higher
                    break;
                }
                 
                set topmost_pblock $parent_pblock
                set current_pblock $parent_pblock
            }
             
            return $topmost_pblock
        }
 
        proc get_unique_guided_child_pblock_name { rp_user_child_pblocks guided_child_name} {
            set unique_guided_child_name $guided_child_name
            set counter 0
 
            while {! [lsearch -exact $rp_user_child_pblocks $unique_guided_child_name]} {
                incr counter
                set unique_guided_child_name "${guided_child_name}_${counter}"
            }
 
            return $unique_guided_child_name
        }
 
        # backup sites / cells for user child pblocks
        proc backup_user_child_pblocks {} {
            puts "::dfx_utils::guided_floorplan Info: back up user child pblocks..."
            variable rm_cell
            variable rp_pblock
            variable guided_child_name
            variable user_child_pblock_sites
            variable user_child_pblock_cells
 
            set is_rm [get_property HD.RECONFIGURABLE $rm_cell]
            if {!$is_rm} { error "dfx_utils::guided_floorplan: Error: $rm_cell is not Reconfigurable" }
 
            set rp_user_child_pblocks [list]
            set rp_user_child_pblocks [get_pblocks -of [get_cells -leaf $rm_cell] -filter {PARENT!=ROOT}]
            puts $rp_user_child_pblocks
            foreach user_child_pblock $rp_user_child_pblocks {
                set user_child_name [get_property NAME $user_child_pblock]
                set user_child_pblock_sites($user_child_name) [get_sites -of $user_child_pblock]
                set user_child_pblock_cells($user_child_name) [get_cells -of $user_child_pblock]
            }
 
            # deletion of child p-block is too slow, and unneeded, so this function is disabled
            # delete_pblock $rp_user_child_pblocks
             
            if {[llength $rp_user_child_pblocks] != 0} {
                set rp_pblock [get_topmost_pblock [lindex $rp_user_child_pblocks 0]]
            } else {
                set rp_pblock [get_pblocks -of $rm_cell]
            }
 
            set guided_child_name [get_unique_guided_child_pblock_name $rp_user_child_pblocks "${rp_pblock}_guided_floorplan_child"]
        }
 
        # check if footprint is disjoint with hsr and fsr components
        proc check_disjoint_footprint {} {
            puts "::dfx_utils::guided_floorplan Info: check supported floorplan..."
            variable rm_cell
            variable rp_pblock
            variable guided_child_name
 
            if {$rp_pblock == ""} {
                error "dfx_utils::guided_floorplan: Error: $rm_cell does not have Pblock"
            }
 
            set is_disjoint_1_hsr_1_fsr [get_dfx_footprint -of $rm_cell -is_disjoint -disjoint_type 1_hsr_1_fsr]
            if {!$is_disjoint_1_hsr_1_fsr} {
                error "dfx_utils::guided_floorplan: Error: RM floorplan is not disjoint with 1 hsr component and 1 fsr component"
            }
 
        }
         
        proc get_minimal_non_clock_cells { rm_cell } {
             
            set minimal_non_clock_cells {}
            set non_clock_cells [lsort -unique [get_dfx_footprint -of $rm_cell -cell_type non_clock]]
            set primitive_cells [get_cells -hierarchical -filter { IS_PRIMITIVE == "TRUE"}]
             
            set pending_cells {}
            lappend pending_cells $rm_cell
             
            while {[llength $pending_cells] > 0} {
                # dequeue the pending_cells
                set current_cell [lindex $pending_cells 0]
                set pending_cells [lrange $pending_cells 1 end]
                 
                if {[lsearch -exact $primitive_cells $current_cell] >= 0} {
                    # this is a leaf cell
                    if {[lsearch -exact $non_clock_cells $current_cell] >= 0} {
                        lappend minimal_non_clock_cells $current_cell
                    }
                } else {
                    # scope to current cell
                    current_instance $current_cell
                     
                    set all_child_cells [lsort -unique [get_cells -hierarchical -filter {IS_PRIMITIVE == "TRUE" && (PRIMITIVE_TYPE != "others.others.gnd" && PRIMITIVE_TYPE != "others.others.vcc") && PRIMITIVE_LEVEL != "INTERNAL"}]]
                    if {[llength $all_child_cells] == 0} {
                        # ignore (blackbox)
                    } elseif {[struct::set subsetof $all_child_cells $non_clock_cells] && $rm_cell != $current_cell} {
                        lappend minimal_non_clock_cells $current_cell
                        # update the non_clock_cells
                        set non_clock_cells [struct::set difference $non_clock_cells $all_child_cells]
                    } else {
                        # add the immediate children to pending_cells
                        set immediate_child_cell [get_cells]
                        foreach cell $immediate_child_cell {
                            lappend pending_cells $cell
                        }
                    }
                    # reset current instance to top
                    current_instance
                }
            }  
            return $minimal_non_clock_cells
        }
 
        # create guided child pblock for rp
        proc create_guided_child_pblock {} {
            puts "::dfx_utils::guided_floorplan Info: create guided child pblock... "
            variable rm_cell
            variable guided_child_name
            check_disjoint_footprint
 
            create_pblock $guided_child_name
            set guided_child_pblock [get_pblocks $guided_child_name]
 
            set fsr_tiles [get_dfx_footprint -of $rm_cell -site_type fsr]
            set minimal_non_clock_cells [get_minimal_non_clock_cells $rm_cell]
            resize_pblock $guided_child_pblock -add $fsr_tiles
            add_cells_to_pblock $guided_child_pblock $minimal_non_clock_cells -clear_locs
        }
 
        proc restore_user_child_pblocks_internal {} {
            puts "::dfx_utils::guided_floorplan Info: restore user child pblocks internal"
            variable user_child_pblock_sites
            variable user_child_pblock_cells
            foreach user_child [array names user_child_pblock_sites] {
                create_pblock $user_child
                set user_child_pblock [get_pblocks $user_child]      
                resize_pblock $user_child_pblock -add $user_child_pblock_sites($user_child)
                add_cells_to_pblock $user_child_pblock $user_child_pblock_cells($user_child)
            }
        }
 
        proc is_similar_to_guided_child {user_child} {
            puts "::dfx_utils::guided_floorplan Info: is similar to guided child pblock: $user_child"
            variable guided_child_name
            variable user_child_pblock_sites
            variable user_child_pblock_cells
 
            set guided_child_pblock_sites [get_sites -of [get_pblocks $guided_child_name]]
            set guided_child_pblock_cells [get_cells -of [get_pblocks $guided_child_name]]
 
            set is_same_sites [struct::set equal $user_child_pblock_sites($user_child) $guided_child_pblock_sites]
            set is_same_cells [struct::set equal $user_child_pblock_cells($user_child) $guided_child_pblock_cells]
            if {$is_same_sites} {
                if {$is_same_cells} {
                    puts "::dfx_utils::guided_floorplan Info: $user_child is same as $guided_child_name"
                } else {
                    puts "::dfx_utils::guided_floorplan Info: $user_child replaced by $guided_child_name with cells"
                }
                return 1
            }
 
            set non_fsr_sites [struct::set difference $user_child_pblock_sites($user_child) $guided_child_pblock_sites]
            if {[llength $non_fsr_sites] == 0} {
                puts "::dfx_utils::guided_floorplan Info: $user_child has only fsr sites and added to $guided_child_name"
            } elseif {[llength $non_fsr_sites] == [llength $user_child_pblock_sites($user_child)]} {
                puts "::dfx_utils::guided_floorplan Info: $user_child has only hsr sites and added to $rp_pblock"
            } else {
                error "::dfx_utils::guided_floorplan Error: $user_child has both fsr and hsr sites, cannot be handled"
            }
            return 0
        }
 
        # restore user child pblocks
        proc restore_user_child_pblocks {} {
            puts "::dfx_utils::guided_floorplan Info: restore user child pblocks"
            variable rm_cell
            variable rp_pblock
            variable guided_child_name
            variable user_child_pblock_sites
            variable user_child_pblock_cells
             
            foreach user_child [array names user_child_pblock_sites] {
                if {[is_similar_to_guided_child $user_child]} { continue }
 
                # already exist, skip the creation
                # create_pblock $user_child
                set user_child_pblock [get_pblocks $user_child]      
                resize_pblock $user_child_pblock -add $user_child_pblock_sites($user_child)
                add_cells_to_pblock $user_child_pblock $user_child_pblock_cells($user_child)
 
            }
        }
 
        proc cleanup_user_child_pblocks {} {
            puts "::dfx_utils::guided_floorplan Info: cleanup user child pblocks"
            variable rm_cell
            variable user_child_pblock_sites
 
            foreach user_child [array names user_child_pblock_sites] {
                set user_child_pblock [get_pblocks $user_child]
                set user_child_pblock_all_cells [get_cells -of $user_child_pblock]
                if {$user_child_pblock_all_cells == ""} {
                    delete_pblocks $user_child_pblock
                }
            }
        }
 
        # External proc to create guided floorplan for an rm
        proc create_guided_rm_floorplan {rm_name debugTiming} {
            set create_guided_rm_start_time [clock seconds]
 
            puts "dfx_utils::guided_floorplan: Info: create_guided_floorplan {$rm_name}"
            initialize $rm_name
            if {$debugTiming} { puts "$rm_name initialize time: [expr {[clock seconds] - $create_guided_rm_start_time}] seconds" }
            backup_user_child_pblocks
            if {$debugTiming} { puts "$rm_name backup time: [expr {[clock seconds] - $create_guided_rm_start_time}] seconds" }
            create_guided_child_pblock
            if {$debugTiming} { puts "$rm_name creation time: [expr {[clock seconds] - $create_guided_rm_start_time}] seconds" }
            restore_user_child_pblocks
            if {$debugTiming} { puts "$rm_name restore time: [expr {[clock seconds] - $create_guided_rm_start_time}] seconds" }
            cleanup_user_child_pblocks
            if {$debugTiming} { puts "$rm_name cleanup time: [expr {[clock seconds] - $create_guided_rm_start_time}] seconds" }
            print_user_child_pblocks
            puts "dfx_utils::guided_floorplan: Info: Added fsr sites and non-clock cells to guided child pblock"
            if {$debugTiming} { puts "$rm_name processing time: [expr {[clock seconds] - $create_guided_rm_start_time}] seconds" }
        }
 
        # Create Guided floor plan for all RMs
        proc create_guided_floorplan { {debugTiming false} } {
            set rm_cells [get_cells -hierarchical -filter {HD.RECONFIGURABLE == TRUE}]
            foreach rm_cell $rm_cells {
                set is_disjoint_1_hsr_1_fsr [get_dfx_footprint -of $rm_cell -is_disjoint -disjoint_type 1_hsr_1_fsr]
                if {$is_disjoint_1_hsr_1_fsr} {
                    puts "Info: RP PBlock for $rm_cell has 1 hsr component and 1 fsr component in routing footprint"
                    create_guided_rm_floorplan $rm_cell $debugTiming
                }  
           }
        }
    }
}