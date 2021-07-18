cd ./scripts/initial_compile
vivado -mode tcl -source run_all.tcl
cd ../slr0_compile
vivado -mode tcl -source slr0_compile.tcl
cd ../slr1_ompile
vivado -mode tcl -source slr1_compile.tcl
cd ../slr2_compile
vivado -mode tcl -source slr2_compile.tcl
cd ../slr3_compile
vivado -mode tcl -source slr3_compile.tcl
cd ../link_final_dcp
vivado -mode tcl -source link_dcps.tcl

