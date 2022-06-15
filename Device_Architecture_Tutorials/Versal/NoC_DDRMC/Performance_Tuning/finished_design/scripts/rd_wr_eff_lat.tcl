# © Copyright 2019 – 2021 Xilinx, Inc.
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
#Read beat counter
set rbtaddr  2014 
#read bandwidth counter
set rbwaddr  2020
#write beat counter
set wbtaddr  203C
#write bandwidth counter
set wbwaddr  2040
#read minimum latency
set rminlat  2028
#read total latency can be used to calculate the average latency
set ravglat  202c
#read max latency
set rmaxlat  2024
#write min latency
set wminlat  2048
#write total latency can be used to calculate the average latency
set wavglat  204c
#write max latency
set wmaxlat  2044
#read request counter
set rreqaddr 2018 
#write rewuest counter
set wreqaddr 2030     
#Total bandwidth in GB/s.  Assumes 512-bit AXI at 250MHz
set tbw      16
#AXI Clock period in ns
set tclk      4
#write beats captured in window
set wrreqcap  22DC
#read beats captured in window
set rdreqcap  22E0
#write requests captured in window
set wrreq     22E4
#read requests captured in window
set rdreq     22E8

#set window_size 2000000



#set num_tg 2
set num_tg [lindex $argv 0]  
#set tc  VNOC_RO_LIN_MID_128B_INCR_M1
set tc [lindex $argv 1]  
set fe  [open RESULT.csv a]


set tgr 0
#while {$tgr < $num_tg} {
set tgr $num_tg
set tgrinhex [format %x $tgr]

set raddr_bt     [concat 000$tgrinhex$rbtaddr]
set raddr_bw     [concat 000$tgrinhex$rbwaddr]
set waddr_bt     [concat 000$tgrinhex$wbtaddr]
set waddr_bw     [concat 000$tgrinhex$wbwaddr]
set raddr_minlat [concat 000$tgrinhex$rminlat]
set raddr_avglat [concat 000$tgrinhex$ravglat]
set raddr_maxlat [concat 000$tgrinhex$rmaxlat]
set waddr_minlat [concat 000$tgrinhex$wminlat]
set waddr_avglat [concat 000$tgrinhex$wavglat]
set waddr_maxlat [concat 000$tgrinhex$wmaxlat]
set raddr_req    [concat 000$tgrinhex$rreqaddr]
set waddr_req    [concat 000$tgrinhex$wreqaddr]
set wrreqcapt    [concat 000$tgrinhex$wrreqcap]
set rdreqcapt    [concat 000$tgrinhex$rdreqcap]
set wrreqt       [concat 000$tgrinhex$wrreq]
set rdreqt       [concat 000$tgrinhex$rdreq]





set rb [read_reg $raddr_bt] 
set rb [read_reg $raddr_bt] 
set rbw [read_reg $raddr_bw] 
set rbw [read_reg $raddr_bw] 
set wb [read_reg $waddr_bt] 
set wb [read_reg $waddr_bt] 
set wbw [read_reg $waddr_bw] 
set wbw [read_reg $waddr_bw] 
set wrc [read_reg $wrreqcapt] 
set wrc [read_reg $wrreqcapt] 
set rdc [read_reg $rdreqcapt] 
set rdc [read_reg $rdreqcapt] 
set awrc [read_reg $wrreqt] 
set awrc [read_reg $wrreqt] 
set ardc [read_reg $rdreqt] 
set ardc [read_reg $rdreqt] 


set rmnl_i [read_reg $raddr_minlat] 
set rmnl_i [read_reg $raddr_minlat] 
set rmxl_i [read_reg $raddr_maxlat] 
set rmxl_i [read_reg $raddr_maxlat] 
set ravl   [read_reg $raddr_avglat] 
set ravl   [read_reg $raddr_avglat] 

set wmnl_i [read_reg $waddr_minlat] 
set wmnl_i [read_reg $waddr_minlat] 
set wmxl_i [read_reg $waddr_maxlat] 
set wmxl_i [read_reg $waddr_maxlat] 
set wavl   [read_reg $waddr_avglat] 
set wavl   [read_reg $waddr_avglat] 

set rrq  [read_reg $raddr_req] 
set rrq  [read_reg $raddr_req] 
set wrq  [read_reg $waddr_req] 
set wrq  [read_reg $waddr_req] 

if {$rrq != 0} {
set ravgl [expr double ($ravl)/$rrq * $tclk ]
} else {
set ravgl 0 
}

if {$wrq != 0} {
set wavgl [expr double ($wavl)/$wrq * $tclk ]
} else {
set wavgl 0 
}


set rmnl_i2 [expr double ($rmnl_i) * $tclk ]
set rmxl_i2 [expr double ($rmxl_i) * $tclk ]

set wmnl_i2 [expr double ($wmnl_i) * $tclk ]
set wmxl_i2 [expr double ($wmxl_i) * $tclk ]







if {$rdc != 0} {
set ref [expr double ($rdc)/$window_size * 100 ]
} else {
set ref 0 
}

if {$wrc != 0} {
set wef [expr double ($wrc)/$window_size * 100 ]
} else {
set wef 0 
}

if {$rrq != 0} {
set rmnl $rmnl_i2
} else {
set rmnl 0 
}


if {$rrq != 0} {
set rmxl $rmxl_i2
} else {
set rmxl 0 
}


if {$wrq != 0} {
set wmnl $wmnl_i2
} else {
set wmnl 0 
}


if {$wrq != 0} {
set wmxl $wmxl_i2
} else {
set wmxl 0 
}


set rbw [expr double ($ref * $tbw) / 100]
set wbw [expr double ($wef * $tbw) / 100]




puts "READ  EFFICIENCY TG: $tgrinhex : $ref  %"
puts "WRITE EFFICIENCY TG: $tgrinhex : $wef  %"

puts "READ MIN LATENCY TG: $tgrinhex : $rmnl "
#puts "READ AVG LATENCY TG: $tgrinhex : $ravgl"
puts "READ MAX LATENCY TG: $tgrinhex : $rmxl "

puts "WRITE MIN LATENCY TG:$tgrinhex : $wmnl "
#puts "WRITE AVG LATENCY TG:$tgrinhex : $wavgl"
puts "WRITE MAX LATENCY TG:$tgrinhex : $wmxl "


puts "READ BANDWIDTH TG  :$tgrinhex : $rbw"
puts "WRITE BANDWIDTH TG :$tgrinhex : $wbw"


puts "READ BEATS CAPTURED TG  :$tgrinhex : $rdc"
puts "WRITE BEATS CAPTURED TG :$tgrinhex : $wrc"

#puts $fe $tgr,$tc,$ref,$wef,$rbw,$wbw,$rmnl,$ravgl,$rmxl,$wmnl,$wavgl,$wmxl,$rdc,$wrc,$ardc,$awrc
puts $fe $tgr,$tc,$ref,$wef,$rbw,$wbw,$rmnl,$rmxl,$wmnl,$wmxl,$rdc,$wrc,$ardc,$awrc

#set tgr [expr $tgr + 1]

#}
close $fe
