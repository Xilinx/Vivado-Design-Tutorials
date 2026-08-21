# Copyright (C) 2021-2022, Xilinx, Inc.
# Copyright (C) 2022-2026, Advanced Micro Devices, Inc.
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

"""
NoC PerfMon Tutorial Script
============================
Modified from the ChipScoPy noc_perfmon.py example to support:
  - Command-line arguments for PDI/LTX paths and programming control
  - Running without an LTX file (not required for NoC PerfMon)
  - Automatic discovery of all active NoC and MC nodes

Usage:
  # Use default CED design, program the device (localhost):
  python noc_perfmon_tutorial.py

  # Connect to a remote board:
  python noc_perfmon_tutorial.py --host myserver

  # Use a custom design, program the device:
  python noc_perfmon_tutorial.py --host myserver --pdi path/to/design.pdi --ltx path/to/design.ltx

  # Use a custom PDI without LTX:
  python noc_perfmon_tutorial.py --host myserver --pdi path/to/design.pdi

  # Skip programming (device already loaded):
  python noc_perfmon_tutorial.py --host myserver --no-program

  # Second-generation Versal segmented config (boot PDI + PLD PDI):
  python noc_perfmon_tutorial.py --host myserver --pdi boot.pdi --pld-pdi pld.pdi
"""

import os
import argparse
from time import sleep

import matplotlib
from chipscopy.api.noc import (
    TC_BEW,
    TC_BER,
    NoCPerfMonNodeListener,
)
from chipscopy.api.noc.plotting_utils import MeasurementPlot
from chipscopy import create_session, report_versions
from chipscopy import get_design_files

# ──────────────────────────────────────────────────────────────────────
# 1. Parse command-line arguments
# ──────────────────────────────────────────────────────────────────────
parser = argparse.ArgumentParser(
    description="NoC PerfMon tutorial — measure NoC and memory controller performance with ChipScoPy"
)
parser.add_argument(
    "--pdi", type=str, default=None,
    help="Path to a custom PDI programming file. If omitted, the default CED design is used.",
)
parser.add_argument(
    "--ltx", type=str, default=None,
    help="Path to a custom LTX probes file. Optional — NoC PerfMon works without one.",
)
parser.add_argument(
    "--pld-pdi", type=str, default=None,
    help="Path to a PLD PDI for Versal Gen 2 segmented config. Program boot PDI (--pdi) first, then PLD PDI.",
)
parser.add_argument(
    "--no-program", action="store_true",
    help="Skip device programming (use when the device is already loaded).",
)
parser.add_argument(
    "--host", type=str, default="localhost",
    help="Hostname where hw_server and cs_server are running (default: localhost).",
)
args = parser.parse_args()

# ──────────────────────────────────────────────────────────────────────
# 2. Resolve server URLs and design files
# ──────────────────────────────────────────────────────────────────────
CS_URL = f"TCP:{args.host}:3042"
HW_URL = f"TCP:{args.host}:3121"
HW_PLATFORM = os.getenv("HW_PLATFORM", "vck190")

PROG_DEVICE = not args.no_program
PLD_PDI = os.path.abspath(args.pld_pdi) if args.pld_pdi else None

# Determine PDI and LTX paths
if args.pdi:
    PROGRAMMING_FILE = os.path.abspath(args.pdi)
else:
    design_files = get_design_files(f"{HW_PLATFORM}/production/chipscopy_ced")
    PROGRAMMING_FILE = design_files.programming_file

if args.ltx:
    PROBES_FILE = os.path.abspath(args.ltx)
else:
    if args.pdi:
        # Custom PDI without explicit LTX — run without probes
        PROBES_FILE = None
    else:
        design_files = get_design_files(f"{HW_PLATFORM}/production/chipscopy_ced")
        PROBES_FILE = design_files.probes_file

print(f"HW_URL: {HW_URL}")
print(f"CS_URL: {CS_URL}")
print(f"PROGRAMMING_FILE: {PROGRAMMING_FILE}")
print(f"PROBES_FILE: {PROBES_FILE}")
print(f"PLD_PDI: {PLD_PDI}")
print(f"PROG_DEVICE: {PROG_DEVICE}")

# ──────────────────────────────────────────────────────────────────────
# 3. Create session and connect to servers
# ──────────────────────────────────────────────────────────────────────
session = create_session(cs_server_url=CS_URL, hw_server_url=HW_URL)
report_versions(session)

# ──────────────────────────────────────────────────────────────────────
# 4. Program the device (optional)
# ──────────────────────────────────────────────────────────────────────
versal_device = session.devices.filter_by(family="versal").get()
if PROG_DEVICE:
    print(f"Programming device with {PROGRAMMING_FILE} ...")
    versal_device.program(PROGRAMMING_FILE)
    print("Boot PDI programming complete.")
    if PLD_PDI:
        print(f"Programming PLD PDI: {PLD_PDI} ...")
        versal_device.program(PLD_PDI, skip_reset=True)
        print("PLD PDI programming complete.")
else:
    print("Skipping programming.")

# ──────────────────────────────────────────────────────────────────────
# 5. Discover debug cores
# ──────────────────────────────────────────────────────────────────────
if PROBES_FILE:
    versal_device.discover_and_setup_cores(noc_scan=True, ltx_file=PROBES_FILE)
else:
    versal_device.discover_and_setup_cores(noc_scan=True)
print("Debug cores setup and ready for use.")

# ──────────────────────────────────────────────────────────────────────
# 6. Auto-discover active NoC and DDRMC/HBMMC nodes
# ──────────────────────────────────────────────────────────────────────
# Some devices (e.g., HBM Versal) have multiple NoC cores. Use the first one.
noc_cores = versal_device.noc_core
if len(noc_cores) == 1:
    noc = noc_cores.get()
else:
    print(f"\nDevice has {len(noc_cores)} NoC cores. Using the first one.")
    noc = noc_cores[0]

# Scan the device to find all activated NoC elements.
# Returns a dict with 'enabled', 'disabled', and 'invalid' keys.
scan_result = noc.discover_noc_elements()
enabled_nodes = scan_result.get("enabled", []) if isinstance(scan_result, dict) else scan_result

if not enabled_nodes:
    print("ERROR: No active NoC nodes found. Is the device programmed with a design that uses the NoC?")
    exit(1)

print(f"\nDiscovered {len(enabled_nodes)} active NoC nodes:")
for node in sorted(enabled_nodes):
    print(f"  {node}")

# Enumerate the discovered nodes to set them up for monitoring.
enable_list = noc.enumerate_noc_elements(enabled_nodes)

if not enable_list:
    print("ERROR: No endpoint nodes could be enumerated for monitoring.")
    exit(1)

print(f"\nEnumerated {len(enable_list)} nodes for monitoring:")
for node in enable_list:
    print(f"  {node}")

# ──────────────────────────────────────────────────────────────────────
# 7. Configure sampling periods
# ──────────────────────────────────────────────────────────────────────
# Build a dict of MC frequencies for any DDRMC nodes discovered.
mc_freqs = {}
for node in enable_list:
    if node.startswith("DDRMC5"):
        mc_freqs[node] = 1066.0  # Default DDRMC5 freq; adjust to match your design
    elif node.startswith("DDRMC"):
        mc_freqs[node] = 800.0  # Default DDR4/LPDDR4 MC freq; adjust to match your design
    elif node.startswith("HBM_MC") or node.startswith("HBMMC"):
        mc_freqs[node] = 1600.0  # Default HBM MC freq; adjust to match your design

supported_periods = noc.get_supported_sampling_periods(100 / 3, mc_freqs)
print("\nSupported sampling periods:")
for domain, periods in supported_periods.items():
    print(f"  {domain}:")
    for p in periods:
        print(f"    {p:.0f}ms", end="")
    print()

desired_period = 500  # ms
sampling_intervals = {}

for domain in supported_periods.keys():
    sampling_intervals[domain] = 0
    for sp in supported_periods[domain]:
        if sp > desired_period:
            sampling_intervals[domain] = sp
            break
    if sampling_intervals[domain] == 0:
        print(
            f"Warning: desired period {desired_period}ms is slower than "
            f"longest supported period {supported_periods[domain][-1]}ms [{domain} domain]. "
            f"Defaulting to longest."
        )
        sampling_intervals[domain] = supported_periods[domain][-1]

print(f"\nSampling period selection:")
for domain, freq in sampling_intervals.items():
    print(f"  {domain}: {freq:.0f}ms")

# ──────────────────────────────────────────────────────────────────────
# 8. Configure monitors
# ──────────────────────────────────────────────────────────────────────
num_samples = -1  # continuous mode

print("\nSetting up monitors for:")
for node in enable_list:
    print(f"  {node}")

# extended_monitor_config can be used to adjust tslide for NMU/NSU nodes
# to avoid counter overflow at high bandwidth. Set to None if not needed.
extended_monitor_config = None
noc.configure_monitors(
    enable_list, sampling_intervals, (TC_BEW | TC_BER), num_samples,
    None, extended_monitor_config,
)

# ──────────────────────────────────────────────────────────────────────
# 9. Create plotter and listener, launch GUI
# ──────────────────────────────────────────────────────────────────────
record_to_file = False
node_listener = NoCPerfMonNodeListener(
    sampling_intervals,
    num_samples,
    enable_list,
    record_to_file,
    extended_monitor_config=extended_monitor_config,
)
session.chipscope_view.add_node_listener(node_listener)

plotter = MeasurementPlot(enable_list, mock=False, figsize=(10, 7.5))
node_listener.link_plotter(plotter)

matplotlib.use("Qt5Agg")
plotter.build_graphs()

# ──────────────────────────────────────────────────────────────────────
# 10. Main event loop — close the plot window to exit
# ──────────────────────────────────────────────────────────────────────
print("\nMonitoring... close the plot window to stop.")
while True:
    try:
        session.chipscope_view.run_events()
    except Exception as e:
        # Workaround: ChipScoPy 2025.2 client may fail to resolve debug core
        # contexts from a 2026.1 server for non-NoC nodes. Ignore and continue.
        if "Could not find context" in str(e):
            pass
        else:
            raise
    sleep(0.1)
    plotter.fig.canvas.draw()
    plotter.fig.canvas.flush_events()
    if not plotter.alive:
        break

print("Done.")
