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

###############################################################################
# Versal VCK190 ES1 device selected
###############################################################################

set device xcvc1902-vsva2197-2MP-e-S-es1

###############################################################################
# Script called by run.tcl to generate reference design
###############################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source run.tcl which calls JTAG_gen_refdesign.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project -name project_1 -dir "$proj_dir" -part $device
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES:
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\
xilinx.com:ip:axi_gpio:*\
xilinx.com:ip:c_counter_binary:*\
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:smartconnect:*\
xilinx.com:ip:versal_cips:*\
xilinx.com:ip:xlconcat:*\
xilinx.com:ip:xlconstant:*\
xilinx.com:ip:xlslice:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set dip_sw_0 [ create_bd_port -dir I -from 0 -to 0 dip_sw_0 ]
  set dip_sw_1 [ create_bd_port -dir I -from 0 -to 0 dip_sw_1 ]
  set dip_sw_2 [ create_bd_port -dir I -from 0 -to 0 dip_sw_2 ]
  set dip_sw_3 [ create_bd_port -dir I -from 0 -to 0 dip_sw_3 ]
  set led_0 [ create_bd_port -dir O -from 0 -to 0 led_0 ]
  set led_1 [ create_bd_port -dir O -from 0 -to 0 led_1 ]
  set led_2 [ create_bd_port -dir O -from 0 -to 0 led_2 ]
  set led_3 [ create_bd_port -dir O -from 0 -to 0 led_3 ]
  set push_button_0 [ create_bd_port -dir I -from 0 -to 0 push_button_0 ]
  set push_button_1 [ create_bd_port -dir I -from 0 -to 0 push_button_1 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $axi_gpio_0

  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary c_counter_binary_0 ]
  set_property -dict [ list \
   CONFIG.Output_Width {27} \
 ] $c_counter_binary_0

  # Create instance: c_counter_binary_1, and set properties
  set c_counter_binary_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary c_counter_binary_1 ]
  set_property -dict [ list \
   CONFIG.Output_Width {27} \
 ] $c_counter_binary_1

  # Create instance: c_counter_binary_2, and set properties
  set c_counter_binary_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary c_counter_binary_2 ]
  set_property -dict [ list \
   CONFIG.Output_Width {27} \
 ] $c_counter_binary_2

  # Create instance: c_counter_binary_3, and set properties
  set c_counter_binary_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary c_counter_binary_3 ]
  set_property -dict [ list \
   CONFIG.Output_Width {27} \
 ] $c_counter_binary_3

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]

  # Create instance: smartconnect_15, and set properties
  set smartconnect_15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_15 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_15

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips versal_cips_0 ]
  set_property -dict [ list \
   CONFIG.PMC_EXTERNAL_TAMPER_IO {NONE} \
   CONFIG.PMC_GPIO1_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_HSM0_CLOCK_ENABLE {0} \
   CONFIG.PMC_I2CPMC_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_I2CPMC_PERIPHERAL_IO {PMC_MIO 46 .. 47} \
   CONFIG.PMC_MIO_0_AUX_IO {0} \
   CONFIG.PMC_MIO_0_DIRECTION {in} \
   CONFIG.PMC_MIO_0_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_0_PULL {pullup} \
   CONFIG.PMC_MIO_0_SCHMITT {0} \
   CONFIG.PMC_MIO_0_SLEW {slow} \
   CONFIG.PMC_MIO_10_AUX_IO {0} \
   CONFIG.PMC_MIO_10_DIRECTION {in} \
   CONFIG.PMC_MIO_10_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_10_PULL {pullup} \
   CONFIG.PMC_MIO_10_SCHMITT {0} \
   CONFIG.PMC_MIO_10_SLEW {slow} \
   CONFIG.PMC_MIO_11_AUX_IO {0} \
   CONFIG.PMC_MIO_11_DIRECTION {in} \
   CONFIG.PMC_MIO_11_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_11_PULL {pullup} \
   CONFIG.PMC_MIO_11_SCHMITT {0} \
   CONFIG.PMC_MIO_11_SLEW {slow} \
   CONFIG.PMC_MIO_12_AUX_IO {0} \
   CONFIG.PMC_MIO_12_DIRECTION {in} \
   CONFIG.PMC_MIO_12_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_12_PULL {pullup} \
   CONFIG.PMC_MIO_12_SCHMITT {0} \
   CONFIG.PMC_MIO_12_SLEW {slow} \
   CONFIG.PMC_MIO_13_AUX_IO {0} \
   CONFIG.PMC_MIO_13_DIRECTION {out} \
   CONFIG.PMC_MIO_13_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_13_PULL {pullup} \
   CONFIG.PMC_MIO_13_SCHMITT {1} \
   CONFIG.PMC_MIO_13_SLEW {slow} \
   CONFIG.PMC_MIO_14_AUX_IO {0} \
   CONFIG.PMC_MIO_14_DIRECTION {inout} \
   CONFIG.PMC_MIO_14_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_14_PULL {pullup} \
   CONFIG.PMC_MIO_14_SCHMITT {0} \
   CONFIG.PMC_MIO_14_SLEW {slow} \
   CONFIG.PMC_MIO_15_AUX_IO {0} \
   CONFIG.PMC_MIO_15_DIRECTION {inout} \
   CONFIG.PMC_MIO_15_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_15_PULL {pullup} \
   CONFIG.PMC_MIO_15_SCHMITT {0} \
   CONFIG.PMC_MIO_15_SLEW {slow} \
   CONFIG.PMC_MIO_16_AUX_IO {0} \
   CONFIG.PMC_MIO_16_DIRECTION {inout} \
   CONFIG.PMC_MIO_16_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_16_PULL {pullup} \
   CONFIG.PMC_MIO_16_SCHMITT {0} \
   CONFIG.PMC_MIO_16_SLEW {slow} \
   CONFIG.PMC_MIO_17_AUX_IO {0} \
   CONFIG.PMC_MIO_17_DIRECTION {inout} \
   CONFIG.PMC_MIO_17_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_17_PULL {pullup} \
   CONFIG.PMC_MIO_17_SCHMITT {0} \
   CONFIG.PMC_MIO_17_SLEW {slow} \
   CONFIG.PMC_MIO_18_AUX_IO {0} \
   CONFIG.PMC_MIO_18_DIRECTION {in} \
   CONFIG.PMC_MIO_18_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_18_PULL {pullup} \
   CONFIG.PMC_MIO_18_SCHMITT {0} \
   CONFIG.PMC_MIO_18_SLEW {slow} \
   CONFIG.PMC_MIO_19_AUX_IO {0} \
   CONFIG.PMC_MIO_19_DIRECTION {inout} \
   CONFIG.PMC_MIO_19_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_19_PULL {pullup} \
   CONFIG.PMC_MIO_19_SCHMITT {0} \
   CONFIG.PMC_MIO_19_SLEW {slow} \
   CONFIG.PMC_MIO_1_AUX_IO {0} \
   CONFIG.PMC_MIO_1_DIRECTION {in} \
   CONFIG.PMC_MIO_1_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_1_PULL {pullup} \
   CONFIG.PMC_MIO_1_SCHMITT {0} \
   CONFIG.PMC_MIO_1_SLEW {slow} \
   CONFIG.PMC_MIO_20_AUX_IO {0} \
   CONFIG.PMC_MIO_20_DIRECTION {inout} \
   CONFIG.PMC_MIO_20_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_20_PULL {pullup} \
   CONFIG.PMC_MIO_20_SCHMITT {0} \
   CONFIG.PMC_MIO_20_SLEW {slow} \
   CONFIG.PMC_MIO_21_AUX_IO {0} \
   CONFIG.PMC_MIO_21_DIRECTION {inout} \
   CONFIG.PMC_MIO_21_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_21_PULL {pullup} \
   CONFIG.PMC_MIO_21_SCHMITT {0} \
   CONFIG.PMC_MIO_21_SLEW {slow} \
   CONFIG.PMC_MIO_22_AUX_IO {0} \
   CONFIG.PMC_MIO_22_DIRECTION {inout} \
   CONFIG.PMC_MIO_22_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_22_PULL {pullup} \
   CONFIG.PMC_MIO_22_SCHMITT {0} \
   CONFIG.PMC_MIO_22_SLEW {slow} \
   CONFIG.PMC_MIO_23_AUX_IO {0} \
   CONFIG.PMC_MIO_23_DIRECTION {in} \
   CONFIG.PMC_MIO_23_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_23_PULL {pullup} \
   CONFIG.PMC_MIO_23_SCHMITT {0} \
   CONFIG.PMC_MIO_23_SLEW {slow} \
   CONFIG.PMC_MIO_24_AUX_IO {0} \
   CONFIG.PMC_MIO_24_DIRECTION {out} \
   CONFIG.PMC_MIO_24_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_24_PULL {pullup} \
   CONFIG.PMC_MIO_24_SCHMITT {1} \
   CONFIG.PMC_MIO_24_SLEW {slow} \
   CONFIG.PMC_MIO_25_AUX_IO {0} \
   CONFIG.PMC_MIO_25_DIRECTION {in} \
   CONFIG.PMC_MIO_25_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_25_PULL {pullup} \
   CONFIG.PMC_MIO_25_SCHMITT {0} \
   CONFIG.PMC_MIO_25_SLEW {slow} \
   CONFIG.PMC_MIO_26_AUX_IO {0} \
   CONFIG.PMC_MIO_26_DIRECTION {in} \
   CONFIG.PMC_MIO_26_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_26_PULL {pullup} \
   CONFIG.PMC_MIO_26_SCHMITT {0} \
   CONFIG.PMC_MIO_26_SLEW {slow} \
   CONFIG.PMC_MIO_27_AUX_IO {0} \
   CONFIG.PMC_MIO_27_DIRECTION {in} \
   CONFIG.PMC_MIO_27_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_27_PULL {pullup} \
   CONFIG.PMC_MIO_27_SCHMITT {0} \
   CONFIG.PMC_MIO_27_SLEW {slow} \
   CONFIG.PMC_MIO_28_AUX_IO {0} \
   CONFIG.PMC_MIO_28_DIRECTION {in} \
   CONFIG.PMC_MIO_28_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_28_PULL {pullup} \
   CONFIG.PMC_MIO_28_SCHMITT {0} \
   CONFIG.PMC_MIO_28_SLEW {slow} \
   CONFIG.PMC_MIO_29_AUX_IO {0} \
   CONFIG.PMC_MIO_29_DIRECTION {in} \
   CONFIG.PMC_MIO_29_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_29_PULL {pullup} \
   CONFIG.PMC_MIO_29_SCHMITT {0} \
   CONFIG.PMC_MIO_29_SLEW {slow} \
   CONFIG.PMC_MIO_2_AUX_IO {0} \
   CONFIG.PMC_MIO_2_DIRECTION {in} \
   CONFIG.PMC_MIO_2_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_2_PULL {pullup} \
   CONFIG.PMC_MIO_2_SCHMITT {0} \
   CONFIG.PMC_MIO_2_SLEW {slow} \
   CONFIG.PMC_MIO_30_AUX_IO {0} \
   CONFIG.PMC_MIO_30_DIRECTION {in} \
   CONFIG.PMC_MIO_30_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_30_PULL {pullup} \
   CONFIG.PMC_MIO_30_SCHMITT {0} \
   CONFIG.PMC_MIO_30_SLEW {slow} \
   CONFIG.PMC_MIO_31_AUX_IO {0} \
   CONFIG.PMC_MIO_31_DIRECTION {in} \
   CONFIG.PMC_MIO_31_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_31_PULL {pullup} \
   CONFIG.PMC_MIO_31_SCHMITT {0} \
   CONFIG.PMC_MIO_31_SLEW {slow} \
   CONFIG.PMC_MIO_32_AUX_IO {0} \
   CONFIG.PMC_MIO_32_DIRECTION {in} \
   CONFIG.PMC_MIO_32_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_32_PULL {pullup} \
   CONFIG.PMC_MIO_32_SCHMITT {0} \
   CONFIG.PMC_MIO_32_SLEW {slow} \
   CONFIG.PMC_MIO_33_AUX_IO {0} \
   CONFIG.PMC_MIO_33_DIRECTION {in} \
   CONFIG.PMC_MIO_33_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_33_PULL {pullup} \
   CONFIG.PMC_MIO_33_SCHMITT {0} \
   CONFIG.PMC_MIO_33_SLEW {slow} \
   CONFIG.PMC_MIO_34_AUX_IO {0} \
   CONFIG.PMC_MIO_34_DIRECTION {in} \
   CONFIG.PMC_MIO_34_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_34_PULL {pullup} \
   CONFIG.PMC_MIO_34_SCHMITT {0} \
   CONFIG.PMC_MIO_34_SLEW {slow} \
   CONFIG.PMC_MIO_35_AUX_IO {0} \
   CONFIG.PMC_MIO_35_DIRECTION {in} \
   CONFIG.PMC_MIO_35_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_35_PULL {pullup} \
   CONFIG.PMC_MIO_35_SCHMITT {0} \
   CONFIG.PMC_MIO_35_SLEW {slow} \
   CONFIG.PMC_MIO_36_AUX_IO {0} \
   CONFIG.PMC_MIO_36_DIRECTION {in} \
   CONFIG.PMC_MIO_36_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_36_PULL {pullup} \
   CONFIG.PMC_MIO_36_SCHMITT {0} \
   CONFIG.PMC_MIO_36_SLEW {slow} \
   CONFIG.PMC_MIO_37_DIRECTION {out} \
   CONFIG.PMC_MIO_37_OUTPUT_DATA {high} \
   CONFIG.PMC_MIO_37_USAGE {GPIO} \
   CONFIG.PMC_MIO_38_AUX_IO {0} \
   CONFIG.PMC_MIO_38_DIRECTION {in} \
   CONFIG.PMC_MIO_38_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_38_PULL {pullup} \
   CONFIG.PMC_MIO_38_SCHMITT {0} \
   CONFIG.PMC_MIO_38_SLEW {slow} \
   CONFIG.PMC_MIO_38_USAGE {GPIO} \
   CONFIG.PMC_MIO_39_AUX_IO {0} \
   CONFIG.PMC_MIO_39_DIRECTION {in} \
   CONFIG.PMC_MIO_39_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_39_PULL {pullup} \
   CONFIG.PMC_MIO_39_SCHMITT {0} \
   CONFIG.PMC_MIO_39_SLEW {slow} \
   CONFIG.PMC_MIO_3_AUX_IO {0} \
   CONFIG.PMC_MIO_3_DIRECTION {in} \
   CONFIG.PMC_MIO_3_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_3_PULL {pullup} \
   CONFIG.PMC_MIO_3_SCHMITT {0} \
   CONFIG.PMC_MIO_3_SLEW {slow} \
   CONFIG.PMC_MIO_40_AUX_IO {0} \
   CONFIG.PMC_MIO_40_DIRECTION {out} \
   CONFIG.PMC_MIO_40_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_40_PULL {pullup} \
   CONFIG.PMC_MIO_40_SCHMITT {1} \
   CONFIG.PMC_MIO_40_SLEW {slow} \
   CONFIG.PMC_MIO_41_AUX_IO {0} \
   CONFIG.PMC_MIO_41_DIRECTION {in} \
   CONFIG.PMC_MIO_41_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_41_PULL {pullup} \
   CONFIG.PMC_MIO_41_SCHMITT {0} \
   CONFIG.PMC_MIO_41_SLEW {slow} \
   CONFIG.PMC_MIO_42_AUX_IO {0} \
   CONFIG.PMC_MIO_42_DIRECTION {in} \
   CONFIG.PMC_MIO_42_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_42_PULL {pullup} \
   CONFIG.PMC_MIO_42_SCHMITT {0} \
   CONFIG.PMC_MIO_42_SLEW {slow} \
   CONFIG.PMC_MIO_43_AUX_IO {0} \
   CONFIG.PMC_MIO_43_DIRECTION {out} \
   CONFIG.PMC_MIO_43_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_43_PULL {pullup} \
   CONFIG.PMC_MIO_43_SCHMITT {1} \
   CONFIG.PMC_MIO_43_SLEW {slow} \
   CONFIG.PMC_MIO_44_AUX_IO {0} \
   CONFIG.PMC_MIO_44_DIRECTION {inout} \
   CONFIG.PMC_MIO_44_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_44_PULL {pullup} \
   CONFIG.PMC_MIO_44_SCHMITT {0} \
   CONFIG.PMC_MIO_44_SLEW {slow} \
   CONFIG.PMC_MIO_45_AUX_IO {0} \
   CONFIG.PMC_MIO_45_DIRECTION {inout} \
   CONFIG.PMC_MIO_45_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_45_PULL {pullup} \
   CONFIG.PMC_MIO_45_SCHMITT {0} \
   CONFIG.PMC_MIO_45_SLEW {slow} \
   CONFIG.PMC_MIO_46_AUX_IO {0} \
   CONFIG.PMC_MIO_46_DIRECTION {inout} \
   CONFIG.PMC_MIO_46_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_46_PULL {pullup} \
   CONFIG.PMC_MIO_46_SCHMITT {0} \
   CONFIG.PMC_MIO_46_SLEW {slow} \
   CONFIG.PMC_MIO_47_AUX_IO {0} \
   CONFIG.PMC_MIO_47_DIRECTION {inout} \
   CONFIG.PMC_MIO_47_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_47_PULL {pullup} \
   CONFIG.PMC_MIO_47_SCHMITT {0} \
   CONFIG.PMC_MIO_47_SLEW {slow} \
   CONFIG.PMC_MIO_4_AUX_IO {0} \
   CONFIG.PMC_MIO_4_DIRECTION {in} \
   CONFIG.PMC_MIO_4_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_4_PULL {pullup} \
   CONFIG.PMC_MIO_4_SCHMITT {0} \
   CONFIG.PMC_MIO_4_SLEW {slow} \
   CONFIG.PMC_MIO_50_AUX_IO {0} \
   CONFIG.PMC_MIO_50_DIRECTION {in} \
   CONFIG.PMC_MIO_50_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_50_PULL {pullup} \
   CONFIG.PMC_MIO_50_SCHMITT {0} \
   CONFIG.PMC_MIO_50_SLEW {slow} \
   CONFIG.PMC_MIO_51_AUX_IO {0} \
   CONFIG.PMC_MIO_51_DIRECTION {in} \
   CONFIG.PMC_MIO_51_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_51_PULL {pullup} \
   CONFIG.PMC_MIO_51_SCHMITT {0} \
   CONFIG.PMC_MIO_51_SLEW {slow} \
   CONFIG.PMC_MIO_5_AUX_IO {0} \
   CONFIG.PMC_MIO_5_DIRECTION {in} \
   CONFIG.PMC_MIO_5_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_5_PULL {pullup} \
   CONFIG.PMC_MIO_5_SCHMITT {0} \
   CONFIG.PMC_MIO_5_SLEW {slow} \
   CONFIG.PMC_MIO_6_AUX_IO {0} \
   CONFIG.PMC_MIO_6_DIRECTION {in} \
   CONFIG.PMC_MIO_6_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_6_PULL {pullup} \
   CONFIG.PMC_MIO_6_SCHMITT {0} \
   CONFIG.PMC_MIO_6_SLEW {slow} \
   CONFIG.PMC_MIO_7_AUX_IO {0} \
   CONFIG.PMC_MIO_7_DIRECTION {in} \
   CONFIG.PMC_MIO_7_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_7_PULL {pullup} \
   CONFIG.PMC_MIO_7_SCHMITT {0} \
   CONFIG.PMC_MIO_7_SLEW {slow} \
   CONFIG.PMC_MIO_8_AUX_IO {0} \
   CONFIG.PMC_MIO_8_DIRECTION {in} \
   CONFIG.PMC_MIO_8_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_8_PULL {pullup} \
   CONFIG.PMC_MIO_8_SCHMITT {0} \
   CONFIG.PMC_MIO_8_SLEW {slow} \
   CONFIG.PMC_MIO_9_AUX_IO {0} \
   CONFIG.PMC_MIO_9_DIRECTION {in} \
   CONFIG.PMC_MIO_9_DRIVE_STRENGTH {8mA} \
   CONFIG.PMC_MIO_9_PULL {pullup} \
   CONFIG.PMC_MIO_9_SCHMITT {0} \
   CONFIG.PMC_MIO_9_SLEW {slow} \
   CONFIG.PMC_MIO_TREE_PERIPHERALS { \
     #############USB 0#USB \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#UART 0#I2C \
     0#USB 0############GPIO \
     0#USB 0############GPIO \
     0#USB 0############GPIO \
     0#USB 0############GPIO \
     0#USB 0############GPIO \
     0#USB 0############GPIO \
     1#CAN 1#UART \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#GPIO 1##CAN \
     1#I2C 1#i2c_pmc#i2c_pmc#####Enet \
   } \
   CONFIG.PMC_MIO_TREE_SIGNALS {#############usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt############gpio_1_pin[37]#gpio_1_pin[38]##phy_tx#phy_rx#rxd#txd#scl#sda#scl#sda#####rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio} \
   CONFIG.PMC_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PMC_QSPI_GRP_FBCLK_IO {PMC_MIO 6} \
   CONFIG.PMC_QSPI_PERIPHERAL_DATA_MODE {x1} \
   CONFIG.PMC_QSPI_PERIPHERAL_ENABLE {0} \
   CONFIG.PMC_QSPI_PERIPHERAL_MODE {Single} \
   CONFIG.PMC_SD0_GRP_CD_ENABLE {0} \
   CONFIG.PMC_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PMC_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PMC_SD0_PERIPHERAL_ENABLE {0} \
   CONFIG.PMC_SD0_PERIPHERAL_IO {PMC_MIO 13 .. 25} \
   CONFIG.PMC_SD0_SLOT_TYPE {SD 2.0} \
   CONFIG.PMC_SD1_COHERENCY {0} \
   CONFIG.PMC_SD1_DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PMC_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PMC_SD1_GRP_CD_IO {PMC_MIO 2} \
   CONFIG.PMC_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PMC_SD1_GRP_POW_IO {PMC_MIO 12} \
   CONFIG.PMC_SD1_GRP_RESET_ENABLE {0} \
   CONFIG.PMC_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PMC_SD1_GRP_WP_IO {PMC_MIO 1} \
   CONFIG.PMC_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PMC_SD1_PERIPHERAL_IO {PMC_MIO 0 .. 11} \
   CONFIG.PMC_SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PMC_SD1_SLOT_TYPE {SD 2.0} \
   CONFIG.PMC_SD1_SPEED_MODE {default speed} \
   CONFIG.PMC_USE_NOC_PMC_AXI0 {0} \
   CONFIG.PMC_USE_PMC_NOC_AXI0 {0} \
   CONFIG.PS_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PS_CAN0_PERIPHERAL_IO {PMC_MIO 8 .. 9} \
   CONFIG.PS_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PS_CAN1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_CAN1_PERIPHERAL_IO {PMC_MIO 40 .. 41} \
   CONFIG.PS_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PS_ENET0_GRP_MDIO_IO {PS_MIO 24 .. 25} \
   CONFIG.PS_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET0_PERIPHERAL_IO {PS_MIO 0 .. 11} \
   CONFIG.PS_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PS_ENET1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET1_PERIPHERAL_IO {PS_MIO 12 .. 23} \
   CONFIG.PS_GEM0_COHERENCY {0} \
   CONFIG.PS_GEM0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PS_GEN_IPI_0_ENABLE {1} \
   CONFIG.PS_GEN_IPI_1_ENABLE {1} \
   CONFIG.PS_GEN_IPI_2_ENABLE {1} \
   CONFIG.PS_GEN_IPI_3_ENABLE {1} \
   CONFIG.PS_GEN_IPI_4_ENABLE {1} \
   CONFIG.PS_GEN_IPI_5_ENABLE {1} \
   CONFIG.PS_GEN_IPI_6_ENABLE {1} \
   CONFIG.PS_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PS_I2C0_PERIPHERAL_IO {PS_MIO 2 .. 3} \
   CONFIG.PS_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C1_PERIPHERAL_IO {PMC_MIO 44 .. 45} \
   CONFIG.PS_MIO_0_AUX_IO {0} \
   CONFIG.PS_MIO_0_DIRECTION {out} \
   CONFIG.PS_MIO_0_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_0_PULL {pullup} \
   CONFIG.PS_MIO_0_SCHMITT {1} \
   CONFIG.PS_MIO_0_SLEW {slow} \
   CONFIG.PS_MIO_10_AUX_IO {0} \
   CONFIG.PS_MIO_10_DIRECTION {in} \
   CONFIG.PS_MIO_10_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_10_PULL {pullup} \
   CONFIG.PS_MIO_10_SCHMITT {0} \
   CONFIG.PS_MIO_10_SLEW {slow} \
   CONFIG.PS_MIO_11_AUX_IO {0} \
   CONFIG.PS_MIO_11_DIRECTION {in} \
   CONFIG.PS_MIO_11_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_11_PULL {pullup} \
   CONFIG.PS_MIO_11_SCHMITT {0} \
   CONFIG.PS_MIO_11_SLEW {slow} \
   CONFIG.PS_MIO_12_AUX_IO {0} \
   CONFIG.PS_MIO_12_DIRECTION {out} \
   CONFIG.PS_MIO_12_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_12_PULL {pullup} \
   CONFIG.PS_MIO_12_SCHMITT {1} \
   CONFIG.PS_MIO_12_SLEW {slow} \
   CONFIG.PS_MIO_13_AUX_IO {0} \
   CONFIG.PS_MIO_13_DIRECTION {out} \
   CONFIG.PS_MIO_13_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_13_PULL {pullup} \
   CONFIG.PS_MIO_13_SCHMITT {1} \
   CONFIG.PS_MIO_13_SLEW {slow} \
   CONFIG.PS_MIO_14_AUX_IO {0} \
   CONFIG.PS_MIO_14_DIRECTION {out} \
   CONFIG.PS_MIO_14_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_14_PULL {pullup} \
   CONFIG.PS_MIO_14_SCHMITT {1} \
   CONFIG.PS_MIO_14_SLEW {slow} \
   CONFIG.PS_MIO_15_AUX_IO {0} \
   CONFIG.PS_MIO_15_DIRECTION {out} \
   CONFIG.PS_MIO_15_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_15_PULL {pullup} \
   CONFIG.PS_MIO_15_SCHMITT {1} \
   CONFIG.PS_MIO_15_SLEW {slow} \
   CONFIG.PS_MIO_16_AUX_IO {0} \
   CONFIG.PS_MIO_16_DIRECTION {out} \
   CONFIG.PS_MIO_16_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_16_PULL {pullup} \
   CONFIG.PS_MIO_16_SCHMITT {1} \
   CONFIG.PS_MIO_16_SLEW {slow} \
   CONFIG.PS_MIO_17_AUX_IO {0} \
   CONFIG.PS_MIO_17_DIRECTION {out} \
   CONFIG.PS_MIO_17_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_17_PULL {pullup} \
   CONFIG.PS_MIO_17_SCHMITT {1} \
   CONFIG.PS_MIO_17_SLEW {slow} \
   CONFIG.PS_MIO_18_AUX_IO {0} \
   CONFIG.PS_MIO_18_DIRECTION {in} \
   CONFIG.PS_MIO_18_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_18_PULL {pullup} \
   CONFIG.PS_MIO_18_SCHMITT {0} \
   CONFIG.PS_MIO_18_SLEW {slow} \
   CONFIG.PS_MIO_19_AUX_IO {0} \
   CONFIG.PS_MIO_19_DIRECTION {in} \
   CONFIG.PS_MIO_19_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_19_PULL {pullup} \
   CONFIG.PS_MIO_19_SCHMITT {0} \
   CONFIG.PS_MIO_19_SLEW {slow} \
   CONFIG.PS_MIO_1_AUX_IO {0} \
   CONFIG.PS_MIO_1_DIRECTION {out} \
   CONFIG.PS_MIO_1_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_1_PULL {pullup} \
   CONFIG.PS_MIO_1_SCHMITT {1} \
   CONFIG.PS_MIO_1_SLEW {slow} \
   CONFIG.PS_MIO_20_AUX_IO {0} \
   CONFIG.PS_MIO_20_DIRECTION {in} \
   CONFIG.PS_MIO_20_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_20_PULL {pullup} \
   CONFIG.PS_MIO_20_SCHMITT {1} \
   CONFIG.PS_MIO_20_SLEW {slow} \
   CONFIG.PS_MIO_21_AUX_IO {0} \
   CONFIG.PS_MIO_21_DIRECTION {in} \
   CONFIG.PS_MIO_21_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_21_PULL {pullup} \
   CONFIG.PS_MIO_21_SCHMITT {0} \
   CONFIG.PS_MIO_21_SLEW {slow} \
   CONFIG.PS_MIO_22_AUX_IO {0} \
   CONFIG.PS_MIO_22_DIRECTION {in} \
   CONFIG.PS_MIO_22_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_22_PULL {pullup} \
   CONFIG.PS_MIO_22_SCHMITT {0} \
   CONFIG.PS_MIO_22_SLEW {slow} \
   CONFIG.PS_MIO_23_AUX_IO {0} \
   CONFIG.PS_MIO_23_DIRECTION {in} \
   CONFIG.PS_MIO_23_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_23_PULL {pullup} \
   CONFIG.PS_MIO_23_SCHMITT {0} \
   CONFIG.PS_MIO_23_SLEW {slow} \
   CONFIG.PS_MIO_24_AUX_IO {0} \
   CONFIG.PS_MIO_24_DIRECTION {out} \
   CONFIG.PS_MIO_24_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_24_PULL {pullup} \
   CONFIG.PS_MIO_24_SCHMITT {1} \
   CONFIG.PS_MIO_24_SLEW {slow} \
   CONFIG.PS_MIO_25_AUX_IO {0} \
   CONFIG.PS_MIO_25_DIRECTION {inout} \
   CONFIG.PS_MIO_25_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_25_PULL {pullup} \
   CONFIG.PS_MIO_25_SCHMITT {0} \
   CONFIG.PS_MIO_25_SLEW {slow} \
   CONFIG.PS_MIO_2_AUX_IO {0} \
   CONFIG.PS_MIO_2_DIRECTION {out} \
   CONFIG.PS_MIO_2_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_2_PULL {pullup} \
   CONFIG.PS_MIO_2_SCHMITT {1} \
   CONFIG.PS_MIO_2_SLEW {slow} \
   CONFIG.PS_MIO_3_AUX_IO {0} \
   CONFIG.PS_MIO_3_DIRECTION {out} \
   CONFIG.PS_MIO_3_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_3_PULL {pullup} \
   CONFIG.PS_MIO_3_SCHMITT {1} \
   CONFIG.PS_MIO_3_SLEW {slow} \
   CONFIG.PS_MIO_4_AUX_IO {0} \
   CONFIG.PS_MIO_4_DIRECTION {out} \
   CONFIG.PS_MIO_4_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_4_PULL {pullup} \
   CONFIG.PS_MIO_4_SCHMITT {1} \
   CONFIG.PS_MIO_4_SLEW {slow} \
   CONFIG.PS_MIO_5_AUX_IO {0} \
   CONFIG.PS_MIO_5_DIRECTION {out} \
   CONFIG.PS_MIO_5_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_5_PULL {pullup} \
   CONFIG.PS_MIO_5_SCHMITT {1} \
   CONFIG.PS_MIO_5_SLEW {slow} \
   CONFIG.PS_MIO_6_AUX_IO {0} \
   CONFIG.PS_MIO_6_DIRECTION {in} \
   CONFIG.PS_MIO_6_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_6_PULL {pullup} \
   CONFIG.PS_MIO_6_SCHMITT {0} \
   CONFIG.PS_MIO_6_SLEW {slow} \
   CONFIG.PS_MIO_7_AUX_IO {0} \
   CONFIG.PS_MIO_7_DIRECTION {in} \
   CONFIG.PS_MIO_7_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_7_PULL {pullup} \
   CONFIG.PS_MIO_7_SCHMITT {1} \
   CONFIG.PS_MIO_7_SLEW {slow} \
   CONFIG.PS_MIO_8_AUX_IO {0} \
   CONFIG.PS_MIO_8_DIRECTION {in} \
   CONFIG.PS_MIO_8_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_8_PULL {pullup} \
   CONFIG.PS_MIO_8_SCHMITT {1} \
   CONFIG.PS_MIO_8_SLEW {slow} \
   CONFIG.PS_MIO_9_AUX_IO {0} \
   CONFIG.PS_MIO_9_DIRECTION {in} \
   CONFIG.PS_MIO_9_DRIVE_STRENGTH {8mA} \
   CONFIG.PS_MIO_9_PULL {pullup} \
   CONFIG.PS_MIO_9_SCHMITT {0} \
   CONFIG.PS_MIO_9_SLEW {slow} \
   CONFIG.PS_M_AXI_GP0_DATA_WIDTH {128} \
   CONFIG.PS_M_AXI_GP2_DATA_WIDTH {128} \
   CONFIG.PS_NUM_FABRIC_RESETS {1} \
   CONFIG.PS_PCIE_EP_RESET1_IO {PS_MIO 18} \
   CONFIG.PS_PCIE_EP_RESET2_IO {PS_MIO 19} \
   CONFIG.PS_PCIE_RESET_ENABLE {1} \
   CONFIG.PS_PCIE_RESET_IO {PS_MIO 18 .. 19} \
   CONFIG.PS_RPU_COHERENCY {0} \
   CONFIG.PS_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PS_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PS_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PS_SPI0_PERIPHERAL_IO {PMC_MIO 12 .. 17} \
   CONFIG.PS_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PS_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PS_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PS_S_AXI_GP0_DATA_WIDTH {128} \
   CONFIG.PS_S_AXI_GP2_DATA_WIDTH {128} \
   CONFIG.PS_S_AXI_GP4_DATA_WIDTH {128} \
   CONFIG.PS_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART0_PERIPHERAL_IO {PMC_MIO 42 .. 43} \
   CONFIG.PS_UART0_RTS_CTS_ENABLE {0} \
   CONFIG.PS_UART1_PERIPHERAL_ENABLE {0} \
   CONFIG.PS_UART1_PERIPHERAL_IO {PMC_MIO 4 .. 5} \
   CONFIG.PS_USB3_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_USB3_PERIPHERAL_IO {PMC_MIO 13 .. 25} \
   CONFIG.PS_USB_COHERENCY {0} \
   CONFIG.PS_USB_ROUTE_THROUGH_FPD {0} \
   CONFIG.PS_USE_BSCAN1 {0} \
   CONFIG.PS_USE_IRQ_0 {0} \
   CONFIG.PS_USE_IRQ_1 {0} \
   CONFIG.PS_USE_IRQ_2 {0} \
   CONFIG.PS_USE_IRQ_3 {0} \
   CONFIG.PS_USE_IRQ_4 {0} \
   CONFIG.PS_USE_IRQ_5 {0} \
   CONFIG.PS_USE_IRQ_6 {0} \
   CONFIG.PS_USE_IRQ_7 {0} \
   CONFIG.PS_USE_IRQ_8 {0} \
   CONFIG.PS_USE_IRQ_9 {0} \
   CONFIG.PS_USE_IRQ_10 {0} \
   CONFIG.PS_USE_IRQ_11 {0} \
   CONFIG.PS_USE_IRQ_12 {0} \
   CONFIG.PS_USE_IRQ_13 {0} \
   CONFIG.PS_USE_IRQ_14 {0} \
   CONFIG.PS_USE_IRQ_15 {0} \
   CONFIG.PS_USE_M_AXI_GP0 {1} \
   CONFIG.PS_USE_M_AXI_GP2 {0} \
   CONFIG.PS_USE_NOC_PS_CCI_0 {0} \
   CONFIG.PS_USE_NOC_PS_CCI_1 {0} \
   CONFIG.PS_USE_NOC_PS_NCI_0 {0} \
   CONFIG.PS_USE_NOC_PS_NCI_1 {0} \
   CONFIG.PS_USE_PMCPL_CLK0 {1} \
   CONFIG.PS_USE_PMCPL_CLK1 {1} \
   CONFIG.PS_USE_PMCPL_CLK2 {1} \
   CONFIG.PS_USE_PMCPL_CLK3 {1} \
   CONFIG.PS_USE_PS_NOC_CCI {0} \
   CONFIG.PS_USE_PS_NOC_NCI_0 {0} \
   CONFIG.PS_USE_PS_NOC_NCI_1 {0} \
   CONFIG.PS_USE_PS_NOC_RPU_0 {0} \
   CONFIG.PS_USE_S_AXI_ACE {0} \
   CONFIG.PS_USE_S_AXI_ACP {0} \
   CONFIG.PS_USE_S_AXI_GP0 {0} \
   CONFIG.PS_USE_S_AXI_GP2 {0} \
   CONFIG.PS_USE_S_AXI_GP4 {0} \
   CONFIG.SMON_ALARMS {Set_Alarms_On} \
   CONFIG.SMON_MEAS37_ENABLE {1} \
   CONFIG.SMON_MEAS40_ENABLE {1} \
   CONFIG.SMON_MEAS41_ENABLE {1} \
   CONFIG.SMON_MEAS42_ENABLE {1} \
   CONFIG.SMON_MEAS45_ENABLE {1} \
   CONFIG.SMON_MEAS48_ENABLE {1} \
   CONFIG.SMON_MEAS50_ENABLE {1} \
   CONFIG.SMON_MEAS61_ENABLE {1} \
   CONFIG.SMON_MEAS62_ENABLE {1} \
   CONFIG.SMON_MEAS63_ENABLE {1} \
   CONFIG.SMON_MEAS64_ENABLE {1} \
   CONFIG.SMON_MEAS65_ENABLE {1} \
   CONFIG.SMON_MEAS66_ENABLE {1} \
   CONFIG.SMON_MEAS80_ENABLE {1} \
   CONFIG.SMON_MEAS81_ENABLE {1} \
   CONFIG.SMON_MEAS82_ENABLE {1} \
   CONFIG.SMON_MEAS83_ENABLE {1} \
   CONFIG.SMON_MEAS84_ENABLE {1} \
   CONFIG.SMON_OT_THRESHOLD_LOWER {-55} \
   CONFIG.SMON_OT_THRESHOLD_UPPER {125} \
   CONFIG.SMON_USER_TEMP_THRESHOLD_LOWER {-55} \
   CONFIG.SMON_USER_TEMP_THRESHOLD_UPPER {125} \
   CONFIG.USE_UART0_IN_DEVICE_BOOT {0} \
 ] $versal_cips_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_1 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DIN_WIDTH {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DIN_WIDTH {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DIN_WIDTH {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DIN_WIDTH {27} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create interface connections
  connect_bd_intf_net -intf_net smartconnect_15_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_15/M00_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins smartconnect_15/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]

  # Create port connections
  connect_bd_net -net In0_0_1 [get_bd_ports push_button_0] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net In1_0_1 [get_bd_ports push_button_1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net In2_0_1 [get_bd_ports dip_sw_0] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net In3_0_1 [get_bd_ports dip_sw_1] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net In4_0_1 [get_bd_ports dip_sw_2] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net In5_0_1 [get_bd_ports dip_sw_3] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins c_counter_binary_0/Q] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net c_counter_binary_1_Q [get_bd_pins c_counter_binary_1/Q] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net c_counter_binary_2_Q [get_bd_pins c_counter_binary_2/Q] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net c_counter_binary_3_Q [get_bd_pins c_counter_binary_3/Q] [get_bd_pins xlslice_3/Din]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_15/aresetn]
  connect_bd_net -net util_ds_buf_0_BUFG_O [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_15/aclk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk] [get_bd_pins versal_cips_0/pl0_ref_clk]
  connect_bd_net -net versal_cips_0_pl1_ref_clk [get_bd_pins c_counter_binary_1/CLK] [get_bd_pins versal_cips_0/pl1_ref_clk]
  connect_bd_net -net versal_cips_0_pl2_ref_clk [get_bd_pins c_counter_binary_2/CLK] [get_bd_pins versal_cips_0/pl2_ref_clk]
  connect_bd_net -net versal_cips_0_pl3_ref_clk [get_bd_pins c_counter_binary_3/CLK] [get_bd_pins versal_cips_0/pl3_ref_clk]
  connect_bd_net -net versal_cips_1_pl0_resetn [get_bd_pins proc_sys_reset_0/aux_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins versal_cips_0/pl0_resetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports led_0] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_ports led_1] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_ports led_2] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_ports led_3] [get_bd_pins xlslice_3/Dout]

  # Create address segments
  assign_bd_address -offset 0xA7000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""
