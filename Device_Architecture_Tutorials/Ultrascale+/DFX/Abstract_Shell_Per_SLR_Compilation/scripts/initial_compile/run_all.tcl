
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 ../../output/initial_compile -part xcvu13p-fhga2104-3-e -force
}

source create_ipi.tcl
source run_impl.tcl
