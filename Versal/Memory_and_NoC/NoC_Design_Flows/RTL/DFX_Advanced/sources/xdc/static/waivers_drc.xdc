# 
# WRITE DRC WAIVERS 
# cmd: write_waivers -type DRC -file waivers_drc.xdc
current_instance -quiet
create_waiver -type DRC -id {BOUNCE-1} -desc "by pass error for driverless D-input" ;#1

#
current_instance -quiet
