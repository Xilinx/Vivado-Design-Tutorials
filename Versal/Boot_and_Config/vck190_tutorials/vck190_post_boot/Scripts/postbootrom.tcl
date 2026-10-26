# Copyright 2020 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

proc readreg {addr} {
    set val_str [string trim [mrd $addr] \n]
    return "0x[lindex [split $val_str] end]"
}
 
# Script Command line Usage
set usage ": versalboot \[options] value ...\noptions:"
set options {
    {url.arg "xiribaie31" "hw_server URL"}
    {bootmode.arg "qspi32" "boot mode"}
}
 
# Parse arguments
array set arg [cmdline::getoptions argv $options $usage]
 
# Print info
puts "Versal PostBootROM Register Status"
 
# Connect to hw_server
puts "HW Server URL:  $arg(url)"
if {[catch {connect -url $arg(url):3121 -symbol} fid]} {
  puts stderr "Could not connect to $arg(url)"
  exit 1
}
 
# Select Versal DAP target
puts "Boot mode: $arg(bootmode)"
if {[catch {target -set -filter {name =~ "Versal*"}} fid]} {
    puts "Cannot select Versal target"
    disconnect
    exit 1
}
 
# Issue POR to start from known state
rst -por

# Add wait
after 5000
 
# Select boot mode
switch -exact $arg(bootmode) {
jtag    {mwr 0xF1260200 0x0100}
qspi32  {mwr 0xF1260200 0x2100}
sd1_ls  {mwr 0xF1260200 0xE100}
default {
    puts "Not Supported"
    disconnect
    exit 1
    }
}


 
# Issue system reset to start user boot mode
rst -system
 
# Select PPU Target
if {[catch {target -set -filter {name =~ "MicroBlaze PPU"}} fid]} {
    puts "Error selecting PPU target"
    disconnect
    exit 1
}
 
# Get the Program Counter to ensure that is stopping on the custom PLM
stop
set pc [rrd pc]
puts "Microblaze PPU, $pc"
 
 
# Remove isolation blocks to be able to reach out RPU and APU PLL and clock registers.
# It is not expected to those registers to be modified by ROM so that's why
# these steps are OPTIONAL and just used to be able to read the following registers:
# - APLL_CTRL
# - RPLL_CTRL
# - ACPU_CTRL
# - CPU_R5_CTRL
 
# Release PS
mwr 0xf126031c 0x0
 
# Release isolation between domains
mwr 0xF1120000 0x0
 
# Add wait
after 1000

# Release LPD and FPD reset signals
mwr 0xFF5E0300 0x0
mwr 0xFF5E0360 0x0


 
# Release LPD to FPD isolation from PSM
target -set -filter {name =~ "MicroBlaze PSM"}
mwr 0xFFC880F0 0x0
target -set -filter {name =~ "MicroBlaze PPU"}

# Add wait
after 1000
 
# Get PLL clock registers
set plls(PMCPLL_CTRL)   [readreg 0xF1260040]
set plls(NOCPLL_CTRL)   [readreg 0xF1260050]
set plls(APLL_CTRL) [readreg 0xFD1A0040]
set plls(RPLL_CTRL) [readreg 0xFF5E0040]
set plls(CPLL_CTRL) [readreg 0xF1260040]
 
puts "\n*** PLL Clock Registers"
foreach register [array names plls] {
    puts "$register is $plls($register)"
}
puts ""
 
# Get Processor clock registers
set processors(ACPU_CTRL)   [readreg 0xFD1A010C]
set processors(CPU_R5_CTRL) [readreg 0xFF5E010C]
 
puts "*** Processor Clock Registers"
foreach register [array names processors] {
    puts "$register is $processors($register)"
}
puts ""
 
# Get Peripheral clock registers
set peripherals(QSPI_REF_CTRL)  [readreg 0xF1260118]
set peripherals(OSPI_REF_CTRL)  [readreg 0xF1260120]
set peripherals(SDIO0_REF_CTRL) [readreg 0xF1260124]
set peripherals(SDIO1_REF_CTRL) [readreg 0xF1260128]
set peripherals(SDDLL_REF_CTRL) [readreg 0xF1260160]
set peripherals(I2C_REF_CTRL)   [readreg 0xF1260130]
set peripherals(CFU_REF_CTRL)   [readreg 0xF1260108]
set peripherals(NPI_REF_CTRL)   [readreg 0xF1260114]
 
puts "*** Peripheral Clock Registers"
foreach register [array names peripherals] {
    puts "$register is $peripherals($register)"
}
puts ""
 
# Get MIO pin configuration
puts "*** MIO Registers"
for {set idx 0xf1060000} {$idx < 0xf10600D0} {incr idx 4} {
    set val [readreg [format "0x%X" [expr $idx]]]
    if {$val != 0x0} {
        puts "[format "0x%X" [expr $idx]]: $val"
    }
}
 
 
disconnect
exit
