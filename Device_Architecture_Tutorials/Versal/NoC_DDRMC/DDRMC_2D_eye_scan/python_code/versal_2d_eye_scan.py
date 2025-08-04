# Copyright 2021 Xilinx, Inc.
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

### Setting up Environment

import sys
import os
import pprint

#Windows
CSPY_SRC = r"C:\Users\ayang\venvs\chipscopy\Lib\site-packages"

#Linux
#HOME = os.environ['HOME']
#CSPY_SRC = f'{HOME}/.local/lib/python3.8/site-packages'
#sys.path.append(CSPY_SRC)

# import chipscopy modules
from chipscopy import create_session, null_callback
from chipscopy import report_versions
from scan_util import convert_vref_pct_to_code
from scan_util import get_write_vref_range

# set up CS server URL
CS_URL = "TCP:cs_server_name:3042"
# set up HW server URL
HW_URL = "TCP:hw_server_name:3121"
# set up path to PDI file
PDI_FILE = f"c:/design_files/versal_ddr.pdi"
# Which ACAP device in the debug chain
ACAP_INDEX = 0
# Which DDRMC target (0..3) for given ACAP
DDR_INDEX = 1
# Which Rank of the memory interface
RANK = 0
# Read or Write Margin : "READ" "WRITE"
MARGIN_MODE = "READ"
# Data pattern used for margin check : "SIMPLE" "COMPLEX"
DATA_PATTERN = "COMPLEX"
# VREF Percentage Minimum (reccommended: Read :DDR4 25, LP4 5 , Write : DDR4 60  , LP4 10)
VREF_PCT_MIN = 10
# VREF Percentage Maximum (reccommended: Read:DDR4 50 , LP4 35 , Write : DDR4 90  , LP4 30)
VREF_PCT_MAX = 30
# Steps to show in the 2D eye scan  ( 1 step takes ~1 second to capture)
STEPS = 15
# Which nibble (read mode) or byte lane (write) to display
DISPLAY_INDEX = 1

## Establish Hardware Session

session = create_session(cs_server_url=CS_URL, hw_server_url=HW_URL, bypass_version_check=True)
report_versions(session)

## Find the Versal device

if len(session.devices) == 0:
    print('\nNo devices detected')
else:
    versal_device = session.devices[ACAP_INDEX]
    print(f"Versal device found at device index number {ACAP_INDEX}")
	
## Program the device

print(f"Programming {PDI_FILE}...")
versal_device.program(PDI_FILE)

## Setup Debug Cores

print(f"Discovering debug cores...")
versal_device.discover_and_setup_cores()
print('DONE')

## Get a list of the integrated DDR Memory Controllers

ddr_list = versal_device.ddrs
print(f"{len(ddr_list)} integrated DDRMC cores exist on this device.")
ddr_index=0
for ddr in ddr_list:
    if ddr.is_enabled:
      print(f" DDRMC instance {ddr_index} is enabled" )
    else : 
      print(f" DDRMC instance {ddr_index} is disabled")
    ddr_index += 1

## Select a target DDR by index, and display calibration status

ddr = ddr_list[DDR_INDEX]
try: 
    props = ddr.ddr_node.get_property(['cal_status'])
    print(f"Calibration status of DDRMC instance {DDR_INDEX} is {props['cal_status']}")
except: 
    print(f"The DDR controller at index {DDR_INDEX} is not in use")    

## Initialize the Margin Check feature in the DDRMC
## These following 4 commands are obsolete in 2021.2 and later

ddr.ddr_node.set_property({'mgchk_enable': 1})
ddr.ddr_node.commit_property_group([])
ddr.ddr_node.set_property({'mgchk_enable': 0})
ddr.ddr_node.commit_property_group([])

## Applying 2D eye scan settings

## Setting the 2D eye scan read or write mode

if  MARGIN_MODE == "READ" :
    print('Setting 2D eye for READ margin')
    ddr.set_eye_scan_read_mode()
elif MARGIN_MODE == "WRITE" :
    print('Setting 2D eye for WRITE margin')
    ddr.set_eye_scan_write_mode()
else :
    print(f" ERROR: MARGIN_MODE is set to {MARGIN_MODE} which is an illegal value, only READ or WRITE is allowed")
 
 
## Setting the 2D eye scan data pattern mode

if  DATA_PATTERN == "SIMPLE" :
    print('Setting 2D eye for SIMPLE data pattern')
    ddr.set_eye_scan_simple_pattern()
elif DATA_PATTERN == "COMPLEX" :
    print('Setting 2D eye for COMPLEX data pattern')
    ddr.set_eye_scan_complex_pattern()
else :
    print(f" ERROR: DATA_PATTERN is set to {DATA_PATTERN} which is an illegal value, only SIMPLE or COMPLEX is allowed")
 
 
##Setting the Vref sample min/max range

print('Vref Min setting...')
vref_min_code = convert_vref_pct_to_code(ddr, MARGIN_MODE, VREF_PCT_MIN)
print('Vref Max setting...')
vref_max_code = convert_vref_pct_to_code(ddr, MARGIN_MODE, VREF_PCT_MAX)

ddr.set_eye_scan_vref_min(vref_min_code)
ddr.set_eye_scan_vref_max(vref_max_code)
ddr.set_eye_scan_vref_steps(STEPS)
print(f"Dividing the Vref range into {STEPS} steps")

## Run 2D Margin Scan 

ddr.run_eye_scan()

## Display Scan Plots by a given Unit (nibble/byte) index

ddr.display_eye_scan(DISPLAY_INDEX)

## Optionally save the figures as a list for later operations

figs = ddr.display_eye_scan(DISPLAY_INDEX, True)

# The following demonstrates that you can display the graphs from a list created previously

# for fig in figs:
#    fig.show()

## Save the Eye Scan Data from the latest run_eye_scan

ddr.save_eye_scan_data('myoutput.csv')

## Load Eye Scan Data from a given data file

# ddr.load_eye_scan_data('myoutput.csv')

## Review overall Scan status and control settings from latest run

# props = ddr.ddr_node.get_property_group(['eye_scan_stat'])
# print(pprint.pformat(props, indent=2))
# props = ddr.ddr_node.get_property_group(['eye_scan_ctrl'])
# print(pprint.pformat(props, indent=2))

## Run a report to see configuration and calibration/margin information

# ddr.report

## When done with testing, close the cs_server connection
# session.cs_server.close()