source ./vck190_4tg_lin_mc1_3tg_rnd_mc3.tcl
set script_path [ file dirname [ file normalize [ info script ] ] ]
set hw_target [lindex $argv 0]

puts "HW_TARGET ${hw_target}"

open_hw_manager
connect_hw_server -url ${hw_target}:3121 -allow_non_jtag
set cur_targ [get_hw_targets]
current_hw_target ${cur_targ}
set_property PARAM.FREQUENCY 15000000 ${cur_targ}

open_hw_target
current_hw_device [get_hw_devices xcvc1902_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvc1902_1] 0]

set_property PROBES.FILE ${script_path}/myproj/project_1.runs/impl_1/design_1_wrapper.ltx [get_hw_devices xcvc1902_1]
set_property FULL_PROBES.FILE ${script_path}/myproj/project_1.runs/impl_1/design_1_wrapper.ltx [get_hw_devices xcvc1902_1]
set_property PROGRAM.FILE ${script_path}/myproj/project_1.runs/impl_1/design_1_wrapper.pdi [get_hw_devices xcvc1902_1]
program_hw_devices [get_hw_devices xcvc1902_1]
refresh_hw_device [lindex [get_hw_devices xcvc1902_1] 0]

set parent_dir [ file dirname ${script_path} ] 

 
cd ${parent_dir}/scripts
source ./total_flow_7tg_inf.tcl 

#comparing performance metrics

package require csv
package require struct::matrix

::struct::matrix data
set fh [open ./RESULT.csv r]
csv::read2matrix $fh data , auto
close $fh
set read_bw_spec [list 0 ${lin_rd_trgt} ${lin_rd_trgt} ${lin_rd_trgt} ${lin_rd_trgt} 1.1125 3.9125 3.85]
set read_bw_actual [data get column 4]
set readpass 1
foreach read_bw_a $read_bw_actual read_bw_s $read_bw_spec {
if { $read_bw_a < $read_bw_s } {set readpass 0}
}

set write_bw_spec [list 0 1.5625 1.5625 3.125 3.125 2.2375 0 0]
set write_bw_actual [data get column 5]
set writepass 1
foreach write_bw_a $write_bw_actual write_bw_s $write_bw_spec {
if { $write_bw_a < $write_bw_s } {set writepass 0}
}

if {$readpass && $writepass} {puts "TEST PASSED"} else {puts "ERROR: TEST FAILED"}
close_hw_target
close_hw_manager

close_project
