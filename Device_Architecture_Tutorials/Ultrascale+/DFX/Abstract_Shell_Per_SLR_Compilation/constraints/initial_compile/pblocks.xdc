create_pblock rp_slr0
add_cells_to_pblock [get_pblocks rp_slr0] [get_cells -quiet [list design_1_i/rp_slr0]]
resize_pblock [get_pblocks rp_slr0] -add {SLICE_X229Y180:SLICE_X232Y239 SLICE_X215Y180:SLICE_X226Y239 SLICE_X195Y180:SLICE_X211Y239 SLICE_X183Y180:SLICE_X191Y239 SLICE_X165Y180:SLICE_X179Y239 SLICE_X153Y180:SLICE_X161Y239 SLICE_X140Y180:SLICE_X149Y239 SLICE_X125Y180:SLICE_X136Y239 SLICE_X120Y180:SLICE_X121Y239 SLICE_X112Y180:SLICE_X116Y239 SLICE_X98Y180:SLICE_X108Y239 SLICE_X86Y180:SLICE_X94Y239 SLICE_X64Y180:SLICE_X80Y239 SLICE_X51Y180:SLICE_X60Y239 SLICE_X38Y180:SLICE_X47Y239 SLICE_X20Y180:SLICE_X34Y239 SLICE_X9Y180:SLICE_X16Y239 SLICE_X0Y180:SLICE_X5Y239}
resize_pblock [get_pblocks rp_slr0] -add {CMACE4_X0Y2:CMACE4_X0Y2}
resize_pblock [get_pblocks rp_slr0] -add {DSP48E2_X0Y72:DSP48E2_X31Y95}
resize_pblock [get_pblocks rp_slr0] -add {GTYE4_CHANNEL_X0Y12:GTYE4_CHANNEL_X1Y15}
resize_pblock [get_pblocks rp_slr0] -add {GTYE4_COMMON_X0Y3:GTYE4_COMMON_X1Y3}
resize_pblock [get_pblocks rp_slr0] -add {ILKNE4_X1Y1:ILKNE4_X1Y1}
resize_pblock [get_pblocks rp_slr0] -add {RAMB18_X0Y72:RAMB18_X13Y95}
resize_pblock [get_pblocks rp_slr0] -add {RAMB36_X0Y36:RAMB36_X13Y47}
resize_pblock [get_pblocks rp_slr0] -add {URAM288_X0Y48:URAM288_X4Y63}
resize_pblock [get_pblocks rp_slr0] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y2}
set_property SNAPPING_MODE ON [get_pblocks rp_slr0]

create_pblock rp_slr1
add_cells_to_pblock [get_pblocks rp_slr1] [get_cells -quiet [list design_1_i/rp_slr1]]
resize_pblock [get_pblocks rp_slr1] -add {SLICE_X229Y420:SLICE_X232Y479 SLICE_X216Y420:SLICE_X224Y479 SLICE_X196Y420:SLICE_X211Y479 SLICE_X184Y420:SLICE_X191Y479 SLICE_X166Y420:SLICE_X179Y479 SLICE_X154Y420:SLICE_X161Y479 SLICE_X141Y420:SLICE_X149Y479 SLICE_X126Y420:SLICE_X136Y479 SLICE_X113Y420:SLICE_X121Y479 SLICE_X99Y420:SLICE_X108Y479 SLICE_X87Y420:SLICE_X94Y479 SLICE_X65Y420:SLICE_X80Y479 SLICE_X52Y420:SLICE_X60Y479 SLICE_X39Y420:SLICE_X47Y479 SLICE_X21Y420:SLICE_X34Y479 SLICE_X10Y420:SLICE_X16Y479 SLICE_X0Y420:SLICE_X5Y479 SLICE_X229Y240:SLICE_X232Y299 SLICE_X216Y240:SLICE_X224Y299 SLICE_X196Y240:SLICE_X211Y299 SLICE_X184Y240:SLICE_X191Y299 SLICE_X166Y240:SLICE_X179Y299 SLICE_X154Y240:SLICE_X161Y299 SLICE_X141Y240:SLICE_X149Y299 SLICE_X126Y240:SLICE_X136Y299 SLICE_X120Y240:SLICE_X121Y299 SLICE_X113Y240:SLICE_X116Y299 SLICE_X99Y240:SLICE_X108Y299 SLICE_X87Y240:SLICE_X94Y299 SLICE_X65Y240:SLICE_X80Y299 SLICE_X52Y240:SLICE_X60Y299 SLICE_X39Y240:SLICE_X47Y299 SLICE_X21Y240:SLICE_X34Y299 SLICE_X10Y240:SLICE_X16Y299 SLICE_X0Y240:SLICE_X5Y299}
resize_pblock [get_pblocks rp_slr1] -add {CMACE4_X0Y5:CMACE4_X0Y5 CMACE4_X0Y3:CMACE4_X0Y3}
resize_pblock [get_pblocks rp_slr1] -add {DSP48E2_X0Y168:DSP48E2_X31Y191 DSP48E2_X0Y96:DSP48E2_X31Y119}
resize_pblock [get_pblocks rp_slr1] -add {GTYE4_CHANNEL_X0Y28:GTYE4_CHANNEL_X1Y31 GTYE4_CHANNEL_X0Y16:GTYE4_CHANNEL_X1Y19}
resize_pblock [get_pblocks rp_slr1] -add {GTYE4_COMMON_X0Y7:GTYE4_COMMON_X1Y7 GTYE4_COMMON_X0Y4:GTYE4_COMMON_X1Y4}
resize_pblock [get_pblocks rp_slr1] -add {ILKNE4_X1Y3:ILKNE4_X1Y3}
resize_pblock [get_pblocks rp_slr1] -add {IOB_X0Y364:IOB_X0Y415}
resize_pblock [get_pblocks rp_slr1] -add {PCIE40E4_X0Y1:PCIE40E4_X0Y1}
resize_pblock [get_pblocks rp_slr1] -add {RAMB18_X0Y168:RAMB18_X13Y191 RAMB18_X0Y96:RAMB18_X13Y119}
resize_pblock [get_pblocks rp_slr1] -add {RAMB36_X0Y84:RAMB36_X13Y95 RAMB36_X0Y48:RAMB36_X13Y59}
resize_pblock [get_pblocks rp_slr1] -add {URAM288_X0Y112:URAM288_X4Y127 URAM288_X0Y64:URAM288_X4Y79}
resize_pblock [get_pblocks rp_slr1] -add {CLOCKREGION_X0Y5:CLOCKREGION_X7Y6}
resize_pblock [get_pblocks rp_slr1] -remove [get_sites CONFIG_SITE*]
set_property SNAPPING_MODE ON [get_pblocks rp_slr1]

create_pblock rp_slr2
add_cells_to_pblock [get_pblocks rp_slr2] [get_cells -quiet [list design_1_i/rp_slr2]]
resize_pblock [get_pblocks rp_slr2] -add {SLICE_X229Y660:SLICE_X232Y719 SLICE_X216Y660:SLICE_X224Y719 SLICE_X196Y660:SLICE_X211Y719 SLICE_X184Y660:SLICE_X191Y719 SLICE_X166Y660:SLICE_X179Y719 SLICE_X154Y660:SLICE_X161Y719 SLICE_X141Y660:SLICE_X149Y719 SLICE_X126Y660:SLICE_X136Y719 SLICE_X113Y660:SLICE_X121Y719 SLICE_X99Y660:SLICE_X108Y719 SLICE_X86Y660:SLICE_X94Y719 SLICE_X65Y660:SLICE_X80Y719 SLICE_X52Y660:SLICE_X60Y719 SLICE_X39Y660:SLICE_X47Y719 SLICE_X21Y660:SLICE_X34Y719 SLICE_X10Y660:SLICE_X16Y719 SLICE_X0Y660:SLICE_X5Y719 SLICE_X229Y480:SLICE_X232Y539 SLICE_X216Y480:SLICE_X224Y539 SLICE_X196Y480:SLICE_X211Y539 SLICE_X184Y480:SLICE_X191Y539 SLICE_X166Y480:SLICE_X179Y539 SLICE_X154Y480:SLICE_X161Y539 SLICE_X141Y480:SLICE_X149Y539 SLICE_X126Y480:SLICE_X136Y539 SLICE_X120Y480:SLICE_X121Y539 SLICE_X113Y480:SLICE_X116Y539 SLICE_X99Y480:SLICE_X108Y539 SLICE_X87Y480:SLICE_X94Y539 SLICE_X65Y480:SLICE_X80Y539 SLICE_X52Y480:SLICE_X60Y539 SLICE_X39Y480:SLICE_X47Y539 SLICE_X21Y480:SLICE_X34Y539 SLICE_X10Y480:SLICE_X16Y539 SLICE_X0Y480:SLICE_X5Y539}
resize_pblock [get_pblocks rp_slr2] -add {CMACE4_X0Y8:CMACE4_X0Y8 CMACE4_X0Y6:CMACE4_X0Y6}
resize_pblock [get_pblocks rp_slr2] -add {DSP48E2_X0Y264:DSP48E2_X31Y287 DSP48E2_X0Y192:DSP48E2_X31Y215}
resize_pblock [get_pblocks rp_slr2] -add {GTYE4_CHANNEL_X0Y44:GTYE4_CHANNEL_X1Y47 GTYE4_CHANNEL_X0Y32:GTYE4_CHANNEL_X1Y35}
resize_pblock [get_pblocks rp_slr2] -add {GTYE4_COMMON_X0Y11:GTYE4_COMMON_X1Y11 GTYE4_COMMON_X0Y8:GTYE4_COMMON_X1Y8}
resize_pblock [get_pblocks rp_slr2] -add {ILKNE4_X1Y5:ILKNE4_X1Y5}
resize_pblock [get_pblocks rp_slr2] -add {PCIE40E4_X0Y2:PCIE40E4_X0Y2}
resize_pblock [get_pblocks rp_slr2] -add {RAMB18_X0Y264:RAMB18_X13Y287 RAMB18_X0Y192:RAMB18_X13Y215}
resize_pblock [get_pblocks rp_slr2] -add {RAMB36_X0Y132:RAMB36_X13Y143 RAMB36_X0Y96:RAMB36_X13Y107}
resize_pblock [get_pblocks rp_slr2] -add {URAM288_X0Y176:URAM288_X4Y191 URAM288_X0Y128:URAM288_X4Y143}
resize_pblock [get_pblocks rp_slr2] -add {CLOCKREGION_X0Y9:CLOCKREGION_X7Y10}
set_property SNAPPING_MODE ON [get_pblocks rp_slr2]

create_pblock rp_slr3
add_cells_to_pblock [get_pblocks rp_slr3] [get_cells -quiet [list design_1_i/rp_slr3]]
resize_pblock [get_pblocks rp_slr3] -add {SLICE_X229Y720:SLICE_X232Y779 SLICE_X216Y720:SLICE_X224Y779 SLICE_X196Y720:SLICE_X211Y779 SLICE_X184Y720:SLICE_X191Y779 SLICE_X166Y720:SLICE_X179Y779 SLICE_X154Y720:SLICE_X161Y779 SLICE_X141Y720:SLICE_X149Y779 SLICE_X126Y720:SLICE_X136Y779 SLICE_X120Y720:SLICE_X121Y779 SLICE_X113Y720:SLICE_X116Y779 SLICE_X99Y720:SLICE_X108Y779 SLICE_X86Y720:SLICE_X94Y779 SLICE_X65Y720:SLICE_X80Y779 SLICE_X52Y720:SLICE_X60Y779 SLICE_X39Y720:SLICE_X47Y779 SLICE_X21Y720:SLICE_X34Y779 SLICE_X10Y720:SLICE_X16Y779 SLICE_X0Y720:SLICE_X5Y779}
resize_pblock [get_pblocks rp_slr3] -add {CMACE4_X0Y9:CMACE4_X0Y9}
resize_pblock [get_pblocks rp_slr3] -add {DSP48E2_X0Y288:DSP48E2_X31Y311}
resize_pblock [get_pblocks rp_slr3] -add {GTYE4_CHANNEL_X0Y48:GTYE4_CHANNEL_X1Y51}
resize_pblock [get_pblocks rp_slr3] -add {GTYE4_COMMON_X0Y12:GTYE4_COMMON_X1Y12}
resize_pblock [get_pblocks rp_slr3] -add {PCIE40E4_X0Y3:PCIE40E4_X0Y3}
resize_pblock [get_pblocks rp_slr3] -add {RAMB18_X0Y288:RAMB18_X13Y311}
resize_pblock [get_pblocks rp_slr3] -add {RAMB36_X0Y144:RAMB36_X13Y155}
resize_pblock [get_pblocks rp_slr3] -add {URAM288_X0Y192:URAM288_X4Y207}
resize_pblock [get_pblocks rp_slr3] -add {CLOCKREGION_X0Y13:CLOCKREGION_X7Y15}
set_property SNAPPING_MODE ON [get_pblocks rp_slr3]

create_pblock slr0_cross_column0
add_cells_to_pblock [get_pblocks slr0_cross_column0] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_0]
add_cells_to_pblock [get_pblocks slr0_cross_column0] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_1]
resize_pblock [get_pblocks slr0_cross_column0] -add {SLICE_X6Y180:SLICE_X9Y239}
resize_pblock [get_pblocks slr0_cross_column0] -add {LAGUNA_X0Y120:LAGUNA_X1Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column0]

create_pblock slr0_cross_column1
add_cells_to_pblock [get_pblocks slr0_cross_column1] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_2]
add_cells_to_pblock [get_pblocks slr0_cross_column1] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_3]
resize_pblock [get_pblocks slr0_cross_column1] -add {SLICE_X17Y180:SLICE_X20Y239}
resize_pblock [get_pblocks slr0_cross_column1] -add {LAGUNA_X2Y120:LAGUNA_X3Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column1]
create_pblock slr0_cross_column2
add_cells_to_pblock [get_pblocks slr0_cross_column2] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_4]
add_cells_to_pblock [get_pblocks slr0_cross_column2] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_5]
resize_pblock [get_pblocks slr0_cross_column2] -add {SLICE_X35Y180:SLICE_X38Y239}
resize_pblock [get_pblocks slr0_cross_column2] -add {LAGUNA_X4Y120:LAGUNA_X5Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column2]
create_pblock slr0_cross_column3
add_cells_to_pblock [get_pblocks slr0_cross_column3] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_6]
add_cells_to_pblock [get_pblocks slr0_cross_column3] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_7]
resize_pblock [get_pblocks slr0_cross_column3] -add {SLICE_X48Y180:SLICE_X51Y239}
resize_pblock [get_pblocks slr0_cross_column3] -add {LAGUNA_X6Y120:LAGUNA_X7Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column3]
create_pblock slr0_cross_column4
add_cells_to_pblock [get_pblocks slr0_cross_column4] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_8]
add_cells_to_pblock [get_pblocks slr0_cross_column4] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_9]
resize_pblock [get_pblocks slr0_cross_column4] -add {SLICE_X61Y180:SLICE_X64Y239}
resize_pblock [get_pblocks slr0_cross_column4] -add {LAGUNA_X8Y120:LAGUNA_X9Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column4]
create_pblock slr0_cross_column5
add_cells_to_pblock [get_pblocks slr0_cross_column5] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_10]
add_cells_to_pblock [get_pblocks slr0_cross_column5] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_11]
resize_pblock [get_pblocks slr0_cross_column5] -add {SLICE_X81Y180:SLICE_X86Y239}
resize_pblock [get_pblocks slr0_cross_column5] -add {LAGUNA_X10Y120:LAGUNA_X11Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column5]
create_pblock slr0_cross_column6
add_cells_to_pblock [get_pblocks slr0_cross_column6] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_12]
add_cells_to_pblock [get_pblocks slr0_cross_column6] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_13]
resize_pblock [get_pblocks slr0_cross_column6] -add {SLICE_X95Y180:SLICE_X98Y239}
resize_pblock [get_pblocks slr0_cross_column6] -add {LAGUNA_X12Y120:LAGUNA_X13Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column6]
create_pblock slr0_cross_column7
add_cells_to_pblock [get_pblocks slr0_cross_column7] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_14]
add_cells_to_pblock [get_pblocks slr0_cross_column7] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_15]
resize_pblock [get_pblocks slr0_cross_column7] -add {SLICE_X109Y180:SLICE_X112Y239}
resize_pblock [get_pblocks slr0_cross_column7] -add {LAGUNA_X14Y120:LAGUNA_X15Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column7]
create_pblock slr0_cross_column8
add_cells_to_pblock [get_pblocks slr0_cross_column8] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_16]
add_cells_to_pblock [get_pblocks slr0_cross_column8] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_17]
resize_pblock [get_pblocks slr0_cross_column8] -add {SLICE_X122Y180:SLICE_X125Y239}
resize_pblock [get_pblocks slr0_cross_column8] -add {LAGUNA_X16Y120:LAGUNA_X17Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column8]
create_pblock slr0_cross_column9
add_cells_to_pblock [get_pblocks slr0_cross_column9] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_18]
add_cells_to_pblock [get_pblocks slr0_cross_column9] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_19]
resize_pblock [get_pblocks slr0_cross_column9] -add {SLICE_X137Y180:SLICE_X140Y239}
resize_pblock [get_pblocks slr0_cross_column9] -add {LAGUNA_X18Y120:LAGUNA_X19Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column9]
create_pblock slr0_cross_column10
add_cells_to_pblock [get_pblocks slr0_cross_column10] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_20]
add_cells_to_pblock [get_pblocks slr0_cross_column10] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_21]
resize_pblock [get_pblocks slr0_cross_column10] -add {SLICE_X150Y180:SLICE_X153Y239}
resize_pblock [get_pblocks slr0_cross_column10] -add {LAGUNA_X20Y120:LAGUNA_X21Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column10]
create_pblock slr0_cross_column11
add_cells_to_pblock [get_pblocks slr0_cross_column11] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_22]
add_cells_to_pblock [get_pblocks slr0_cross_column11] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_23]
resize_pblock [get_pblocks slr0_cross_column11] -add {SLICE_X162Y180:SLICE_X165Y239}
resize_pblock [get_pblocks slr0_cross_column11] -add {LAGUNA_X22Y120:LAGUNA_X23Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column11]
create_pblock slr0_cross_column12
add_cells_to_pblock [get_pblocks slr0_cross_column12] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_24]
add_cells_to_pblock [get_pblocks slr0_cross_column12] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_25]
resize_pblock [get_pblocks slr0_cross_column12] -add {SLICE_X180Y180:SLICE_X183Y239}
resize_pblock [get_pblocks slr0_cross_column12] -add {LAGUNA_X24Y120:LAGUNA_X25Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column12]
create_pblock slr0_cross_column13
add_cells_to_pblock [get_pblocks slr0_cross_column13] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_26]
add_cells_to_pblock [get_pblocks slr0_cross_column13] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_27]
resize_pblock [get_pblocks slr0_cross_column13] -add {SLICE_X192Y180:SLICE_X195Y239}
resize_pblock [get_pblocks slr0_cross_column13] -add {LAGUNA_X26Y120:LAGUNA_X27Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column13]
create_pblock slr0_cross_column14
add_cells_to_pblock [get_pblocks slr0_cross_column14] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_28]
add_cells_to_pblock [get_pblocks slr0_cross_column14] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_29]
resize_pblock [get_pblocks slr0_cross_column14] -add {SLICE_X212Y180:SLICE_X215Y239}
resize_pblock [get_pblocks slr0_cross_column14] -add {LAGUNA_X28Y120:LAGUNA_X29Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column14]
create_pblock slr0_cross_column15
add_cells_to_pblock [get_pblocks slr0_cross_column15] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_30]
add_cells_to_pblock [get_pblocks slr0_cross_column15] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_31]
resize_pblock [get_pblocks slr0_cross_column15] -add {SLICE_X226Y180:SLICE_X228Y239}
resize_pblock [get_pblocks slr0_cross_column15] -add {LAGUNA_X30Y120:LAGUNA_X31Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column15]



create_pblock slr1_cross_bottom_column15
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column15] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_31]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column15] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_30]
resize_pblock [get_pblocks slr1_cross_bottom_column15] -add {SLICE_X226Y240:SLICE_X228Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column15] -add {LAGUNA_X30Y240:LAGUNA_X31Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column15]
create_pblock slr1_cross_bottom_column14
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column14] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_29]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column14] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_28]
resize_pblock [get_pblocks slr1_cross_bottom_column14] -add {SLICE_X212Y240:SLICE_X215Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column14] -add {LAGUNA_X28Y240:LAGUNA_X29Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column14]
create_pblock slr1_cross_bottom_column13
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column13] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_27]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column13] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_26]
resize_pblock [get_pblocks slr1_cross_bottom_column13] -add {SLICE_X192Y240:SLICE_X195Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column13] -add {LAGUNA_X26Y240:LAGUNA_X27Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column13]
create_pblock slr1_cross_bottom_column12
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column12] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_25]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column12] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_24]
resize_pblock [get_pblocks slr1_cross_bottom_column12] -add {SLICE_X180Y240:SLICE_X183Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column12] -add {LAGUNA_X24Y240:LAGUNA_X25Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column12]
create_pblock slr1_cross_bottom_column11
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column11] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_23]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column11] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_22]
resize_pblock [get_pblocks slr1_cross_bottom_column11] -add {SLICE_X162Y240:SLICE_X165Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column11] -add {LAGUNA_X22Y240:LAGUNA_X23Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column11]
create_pblock slr1_cross_bottom_column10
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column10] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_21]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column10] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_20]
resize_pblock [get_pblocks slr1_cross_bottom_column10] -add {SLICE_X150Y240:SLICE_X153Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column10] -add {LAGUNA_X20Y240:LAGUNA_X21Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column10]
create_pblock slr1_cross_bottom_column9
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column9] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_19]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column9] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_18]
resize_pblock [get_pblocks slr1_cross_bottom_column9] -add {SLICE_X137Y240:SLICE_X140Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column9] -add {LAGUNA_X18Y240:LAGUNA_X19Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column9]
create_pblock slr1_cross_bottom_column8
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column8] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_17]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column8] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_16]
resize_pblock [get_pblocks slr1_cross_bottom_column8] -add {SLICE_X122Y240:SLICE_X125Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column8] -add {LAGUNA_X16Y240:LAGUNA_X17Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column8]
create_pblock slr1_cross_bottom_column7
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column7] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_15]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column7] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_14]
resize_pblock [get_pblocks slr1_cross_bottom_column7] -add {SLICE_X109Y240:SLICE_X112Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column7] -add {LAGUNA_X14Y240:LAGUNA_X15Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column7]
create_pblock slr1_cross_bottom_column6
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column6] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_13]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column6] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_12]
resize_pblock [get_pblocks slr1_cross_bottom_column6] -add {SLICE_X95Y240:SLICE_X98Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column6] -add {LAGUNA_X12Y240:LAGUNA_X13Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column6]
create_pblock slr1_cross_bottom_column5
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column5] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_11]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column5] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_10]
resize_pblock [get_pblocks slr1_cross_bottom_column5] -add {SLICE_X81Y240:SLICE_X86Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column5] -add {LAGUNA_X10Y240:LAGUNA_X11Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column5]
create_pblock slr1_cross_bottom_column4
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column4] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_9]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column4] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_8]
resize_pblock [get_pblocks slr1_cross_bottom_column4] -add {SLICE_X61Y240:SLICE_X64Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column4] -add {LAGUNA_X8Y240:LAGUNA_X9Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column4]
create_pblock slr1_cross_bottom_column3
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column3] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_7]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column3] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_6]
resize_pblock [get_pblocks slr1_cross_bottom_column3] -add {SLICE_X48Y240:SLICE_X51Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column3] -add {LAGUNA_X6Y240:LAGUNA_X7Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column3]
create_pblock slr1_cross_bottom_column2
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column2] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_5]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column2] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_4]
resize_pblock [get_pblocks slr1_cross_bottom_column2] -add {SLICE_X35Y240:SLICE_X38Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column2] -add {LAGUNA_X4Y240:LAGUNA_X5Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column2]
create_pblock slr1_cross_bottom_column1
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column1] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_3]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column1] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_2]
resize_pblock [get_pblocks slr1_cross_bottom_column1] -add {SLICE_X17Y240:SLICE_X20Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column1] -add {LAGUNA_X2Y240:LAGUNA_X3Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column1]
create_pblock slr1_cross_bottom_column0
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column0] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_1]
add_cells_to_pblock [get_pblocks slr1_cross_bottom_column0] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_0]
resize_pblock [get_pblocks slr1_cross_bottom_column0] -add {SLICE_X6Y240:SLICE_X9Y299}
resize_pblock [get_pblocks slr1_cross_bottom_column0] -add {LAGUNA_X0Y240:LAGUNA_X1Y359}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_bottom_column0]

create_pblock slr1_cross_top_column0
add_cells_to_pblock [get_pblocks slr1_cross_top_column0] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_0]
add_cells_to_pblock [get_pblocks slr1_cross_top_column0] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_1]
resize_pblock [get_pblocks slr1_cross_top_column0] -add {SLICE_X6Y420:SLICE_X9Y479}
resize_pblock [get_pblocks slr1_cross_top_column0] -add {LAGUNA_X0Y360:LAGUNA_X1Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column0]
create_pblock slr1_cross_top_column1
add_cells_to_pblock [get_pblocks slr1_cross_top_column1] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_2]
add_cells_to_pblock [get_pblocks slr1_cross_top_column1] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_3]
resize_pblock [get_pblocks slr1_cross_top_column1] -add {SLICE_X17Y420:SLICE_X20Y479}
resize_pblock [get_pblocks slr1_cross_top_column1] -add {LAGUNA_X2Y360:LAGUNA_X3Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column1]
create_pblock slr1_cross_top_column2
add_cells_to_pblock [get_pblocks slr1_cross_top_column2] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_4]
add_cells_to_pblock [get_pblocks slr1_cross_top_column2] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_5]
resize_pblock [get_pblocks slr1_cross_top_column2] -add {SLICE_X35Y420:SLICE_X38Y479}
resize_pblock [get_pblocks slr1_cross_top_column2] -add {LAGUNA_X4Y360:LAGUNA_X5Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column2]
create_pblock slr1_cross_top_column3
add_cells_to_pblock [get_pblocks slr1_cross_top_column3] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_6]
add_cells_to_pblock [get_pblocks slr1_cross_top_column3] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_7]
resize_pblock [get_pblocks slr1_cross_top_column3] -add {SLICE_X48Y420:SLICE_X51Y479}
resize_pblock [get_pblocks slr1_cross_top_column3] -add {LAGUNA_X6Y360:LAGUNA_X7Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column3]
create_pblock slr1_cross_top_column4
add_cells_to_pblock [get_pblocks slr1_cross_top_column4] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_8]
add_cells_to_pblock [get_pblocks slr1_cross_top_column4] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_9]
resize_pblock [get_pblocks slr1_cross_top_column4] -add {SLICE_X61Y420:SLICE_X64Y479}
resize_pblock [get_pblocks slr1_cross_top_column4] -add {LAGUNA_X8Y360:LAGUNA_X9Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column4]
create_pblock slr1_cross_top_column5
add_cells_to_pblock [get_pblocks slr1_cross_top_column5] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_10]
add_cells_to_pblock [get_pblocks slr1_cross_top_column5] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_11]
resize_pblock [get_pblocks slr1_cross_top_column5] -add {SLICE_X81Y420:SLICE_X86Y479}
resize_pblock [get_pblocks slr1_cross_top_column5] -add {LAGUNA_X10Y360:LAGUNA_X11Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column5]
create_pblock slr1_cross_top_column6
add_cells_to_pblock [get_pblocks slr1_cross_top_column6] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_12]
add_cells_to_pblock [get_pblocks slr1_cross_top_column6] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_13]
resize_pblock [get_pblocks slr1_cross_top_column6] -add {SLICE_X95Y420:SLICE_X98Y479}
resize_pblock [get_pblocks slr1_cross_top_column6] -add {LAGUNA_X12Y360:LAGUNA_X13Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column6]
create_pblock slr1_cross_top_column7
add_cells_to_pblock [get_pblocks slr1_cross_top_column7] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_14]
add_cells_to_pblock [get_pblocks slr1_cross_top_column7] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_15]
resize_pblock [get_pblocks slr1_cross_top_column7] -add {SLICE_X109Y420:SLICE_X112Y479}
resize_pblock [get_pblocks slr1_cross_top_column7] -add {LAGUNA_X14Y360:LAGUNA_X15Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column7]
create_pblock slr1_cross_top_column8
add_cells_to_pblock [get_pblocks slr1_cross_top_column8] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_16]
add_cells_to_pblock [get_pblocks slr1_cross_top_column8] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_17]
resize_pblock [get_pblocks slr1_cross_top_column8] -add {SLICE_X122Y420:SLICE_X125Y479}
resize_pblock [get_pblocks slr1_cross_top_column8] -add {LAGUNA_X16Y360:LAGUNA_X17Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column8]
create_pblock slr1_cross_top_column9
add_cells_to_pblock [get_pblocks slr1_cross_top_column9] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_18]
add_cells_to_pblock [get_pblocks slr1_cross_top_column9] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_19]
resize_pblock [get_pblocks slr1_cross_top_column9] -add {SLICE_X137Y420:SLICE_X140Y479}
resize_pblock [get_pblocks slr1_cross_top_column9] -add {LAGUNA_X18Y360:LAGUNA_X19Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column9]
create_pblock slr1_cross_top_column10
add_cells_to_pblock [get_pblocks slr1_cross_top_column10] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_20]
add_cells_to_pblock [get_pblocks slr1_cross_top_column10] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_21]
resize_pblock [get_pblocks slr1_cross_top_column10] -add {SLICE_X150Y420:SLICE_X153Y479}
resize_pblock [get_pblocks slr1_cross_top_column10] -add {LAGUNA_X20Y360:LAGUNA_X21Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column10]
create_pblock slr1_cross_top_column11
add_cells_to_pblock [get_pblocks slr1_cross_top_column11] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_22]
add_cells_to_pblock [get_pblocks slr1_cross_top_column11] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_23]
resize_pblock [get_pblocks slr1_cross_top_column11] -add {SLICE_X162Y420:SLICE_X165Y479}
resize_pblock [get_pblocks slr1_cross_top_column11] -add {LAGUNA_X22Y360:LAGUNA_X23Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column11]
create_pblock slr1_cross_top_column12
add_cells_to_pblock [get_pblocks slr1_cross_top_column12] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_24]
add_cells_to_pblock [get_pblocks slr1_cross_top_column12] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_25]
resize_pblock [get_pblocks slr1_cross_top_column12] -add {SLICE_X180Y420:SLICE_X183Y479}
resize_pblock [get_pblocks slr1_cross_top_column12] -add {LAGUNA_X24Y360:LAGUNA_X25Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column12]
create_pblock slr1_cross_top_column13
add_cells_to_pblock [get_pblocks slr1_cross_top_column13] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_26]
add_cells_to_pblock [get_pblocks slr1_cross_top_column13] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_27]
resize_pblock [get_pblocks slr1_cross_top_column13] -add {SLICE_X192Y420:SLICE_X195Y479}
resize_pblock [get_pblocks slr1_cross_top_column13] -add {LAGUNA_X26Y360:LAGUNA_X27Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column13]
create_pblock slr1_cross_top_column14
add_cells_to_pblock [get_pblocks slr1_cross_top_column14] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_28]
add_cells_to_pblock [get_pblocks slr1_cross_top_column14] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_29]
resize_pblock [get_pblocks slr1_cross_top_column14] -add {SLICE_X212Y420:SLICE_X215Y479}
resize_pblock [get_pblocks slr1_cross_top_column14] -add {LAGUNA_X28Y360:LAGUNA_X29Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column14]
create_pblock slr1_cross_top_column15
add_cells_to_pblock [get_pblocks slr1_cross_top_column15] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_30]
add_cells_to_pblock [get_pblocks slr1_cross_top_column15] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_31]
resize_pblock [get_pblocks slr1_cross_top_column15] -add {SLICE_X226Y420:SLICE_X228Y479}
resize_pblock [get_pblocks slr1_cross_top_column15] -add {LAGUNA_X30Y360:LAGUNA_X31Y479}
set_property IS_SOFT FALSE [get_pblocks slr1_cross_top_column15]

create_pblock slr2_cross_bottom_column0
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column0] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_1]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column0] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_0]
resize_pblock [get_pblocks slr2_cross_bottom_column0] -add {SLICE_X6Y480:SLICE_X9Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column0] -add {LAGUNA_X0Y480:LAGUNA_X1Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column0]
create_pblock slr2_cross_bottom_column1
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column1] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_3]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column1] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_2]
resize_pblock [get_pblocks slr2_cross_bottom_column1] -add {SLICE_X17Y480:SLICE_X20Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column1] -add {LAGUNA_X2Y480:LAGUNA_X3Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column1]
create_pblock slr2_cross_bottom_column2
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column2] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_5]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column2] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_4]
resize_pblock [get_pblocks slr2_cross_bottom_column2] -add {SLICE_X35Y480:SLICE_X38Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column2] -add {LAGUNA_X4Y480:LAGUNA_X5Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column2]

create_pblock slr2_cross_bottom_column3
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column3] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_7]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column3] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_6]
resize_pblock [get_pblocks slr2_cross_bottom_column3] -add {SLICE_X48Y480:SLICE_X51Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column3] -add {LAGUNA_X6Y480:LAGUNA_X7Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column3]

create_pblock slr2_cross_bottom_column4
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column4] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_9]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column4] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_8]
resize_pblock [get_pblocks slr2_cross_bottom_column4] -add {SLICE_X61Y480:SLICE_X64Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column4] -add {LAGUNA_X8Y480:LAGUNA_X9Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column4]

create_pblock slr2_cross_bottom_column5
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column5] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_11]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column5] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_10]
resize_pblock [get_pblocks slr2_cross_bottom_column5] -add {SLICE_X81Y480:SLICE_X86Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column5] -add {LAGUNA_X10Y480:LAGUNA_X11Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column5]

create_pblock slr2_cross_bottom_column6
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column6] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_13]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column6] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_12]
resize_pblock [get_pblocks slr2_cross_bottom_column6] -add {SLICE_X95Y480:SLICE_X98Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column6] -add {LAGUNA_X12Y480:LAGUNA_X13Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column6]

create_pblock slr2_cross_bottom_column7
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column7] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_15]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column7] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_14]
resize_pblock [get_pblocks slr2_cross_bottom_column7] -add {SLICE_X109Y480:SLICE_X112Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column7] -add {LAGUNA_X14Y480:LAGUNA_X15Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column7]

create_pblock slr2_cross_bottom_column8
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column8] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_17]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column8] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_16]
resize_pblock [get_pblocks slr2_cross_bottom_column8] -add {SLICE_X122Y480:SLICE_X125Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column8] -add {LAGUNA_X16Y480:LAGUNA_X17Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column8]

create_pblock slr2_cross_bottom_column9
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column9] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_19]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column9] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_18]
resize_pblock [get_pblocks slr2_cross_bottom_column9] -add {SLICE_X137Y480:SLICE_X140Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column9] -add {LAGUNA_X18Y480:LAGUNA_X19Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column9]

create_pblock slr2_cross_bottom_column10
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column10] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_21]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column10] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_20]
resize_pblock [get_pblocks slr2_cross_bottom_column10] -add {SLICE_X150Y480:SLICE_X153Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column10] -add {LAGUNA_X20Y480:LAGUNA_X21Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column10]

create_pblock slr2_cross_bottom_column11
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column11] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_23]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column11] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_22]
resize_pblock [get_pblocks slr2_cross_bottom_column11] -add {SLICE_X162Y480:SLICE_X165Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column11] -add {LAGUNA_X22Y480:LAGUNA_X23Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column11]

create_pblock slr2_cross_bottom_column12
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column12] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_25]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column12] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_24]
resize_pblock [get_pblocks slr2_cross_bottom_column12] -add {SLICE_X180Y480:SLICE_X183Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column12] -add {LAGUNA_X24Y480:LAGUNA_X25Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column12]

create_pblock slr2_cross_bottom_column13
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column13] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_27]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column13] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_26]
resize_pblock [get_pblocks slr2_cross_bottom_column13] -add {SLICE_X192Y480:SLICE_X195Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column13] -add {LAGUNA_X26Y480:LAGUNA_X27Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column13]

create_pblock slr2_cross_bottom_column14
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column14] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_29]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column14] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_28]
resize_pblock [get_pblocks slr2_cross_bottom_column14] -add {SLICE_X212Y480:SLICE_X215Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column14] -add {LAGUNA_X28Y480:LAGUNA_X29Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column14]

create_pblock slr2_cross_bottom_column15
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column15] [get_cells -quiet design_1_i/slr1_to_2_crossing/*_register_slice_31]
add_cells_to_pblock [get_pblocks slr2_cross_bottom_column15] [get_cells -quiet design_1_i/slr2_to_1_crossing/*_register_slice_30]
resize_pblock [get_pblocks slr2_cross_bottom_column15] -add {SLICE_X226Y480:SLICE_X228Y539}
resize_pblock [get_pblocks slr2_cross_bottom_column15] -add {LAGUNA_X30Y480:LAGUNA_X31Y599}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_bottom_column15]


create_pblock slr2_cross_top_column0
add_cells_to_pblock [get_pblocks slr2_cross_top_column0] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_0]
add_cells_to_pblock [get_pblocks slr2_cross_top_column0] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_1]
resize_pblock [get_pblocks slr2_cross_top_column0] -add {SLICE_X6Y660:SLICE_X9Y719}
resize_pblock [get_pblocks slr2_cross_top_column0] -add {LAGUNA_X0Y600:LAGUNA_X1Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column0]
create_pblock slr2_cross_top_column1
add_cells_to_pblock [get_pblocks slr2_cross_top_column1] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_2]
add_cells_to_pblock [get_pblocks slr2_cross_top_column1] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_3]
resize_pblock [get_pblocks slr2_cross_top_column1] -add {SLICE_X17Y660:SLICE_X20Y719}
resize_pblock [get_pblocks slr2_cross_top_column1] -add {LAGUNA_X2Y600:LAGUNA_X3Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column1]
create_pblock slr2_cross_top_column2
add_cells_to_pblock [get_pblocks slr2_cross_top_column2] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_4]
add_cells_to_pblock [get_pblocks slr2_cross_top_column2] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_5]
resize_pblock [get_pblocks slr2_cross_top_column2] -add {SLICE_X35Y660:SLICE_X38Y719}
resize_pblock [get_pblocks slr2_cross_top_column2] -add {LAGUNA_X4Y600:LAGUNA_X5Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column2]
create_pblock slr2_cross_top_column3
add_cells_to_pblock [get_pblocks slr2_cross_top_column3] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_6]
add_cells_to_pblock [get_pblocks slr2_cross_top_column3] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_7]
resize_pblock [get_pblocks slr2_cross_top_column3] -add {SLICE_X48Y660:SLICE_X51Y719}
resize_pblock [get_pblocks slr2_cross_top_column3] -add {LAGUNA_X6Y600:LAGUNA_X7Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column3]
create_pblock slr2_cross_top_column4
add_cells_to_pblock [get_pblocks slr2_cross_top_column4] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_8]
add_cells_to_pblock [get_pblocks slr2_cross_top_column4] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_9]
resize_pblock [get_pblocks slr2_cross_top_column4] -add {SLICE_X61Y660:SLICE_X64Y719}
resize_pblock [get_pblocks slr2_cross_top_column4] -add {LAGUNA_X8Y600:LAGUNA_X9Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column4]
create_pblock slr2_cross_top_column5
add_cells_to_pblock [get_pblocks slr2_cross_top_column5] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_10]
add_cells_to_pblock [get_pblocks slr2_cross_top_column5] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_11]
resize_pblock [get_pblocks slr2_cross_top_column5] -add {SLICE_X81Y660:SLICE_X84Y719}
resize_pblock [get_pblocks slr2_cross_top_column5] -add {LAGUNA_X10Y600:LAGUNA_X11Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column5]
create_pblock slr2_cross_top_column6
add_cells_to_pblock [get_pblocks slr2_cross_top_column6] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_12]
add_cells_to_pblock [get_pblocks slr2_cross_top_column6] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_13]
resize_pblock [get_pblocks slr2_cross_top_column6] -add {SLICE_X95Y660:SLICE_X98Y719}
resize_pblock [get_pblocks slr2_cross_top_column6] -add {LAGUNA_X12Y600:LAGUNA_X13Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column6]
create_pblock slr2_cross_top_column7
add_cells_to_pblock [get_pblocks slr2_cross_top_column7] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_14]
add_cells_to_pblock [get_pblocks slr2_cross_top_column7] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_15]
resize_pblock [get_pblocks slr2_cross_top_column7] -add {SLICE_X109Y660:SLICE_X112Y719}
resize_pblock [get_pblocks slr2_cross_top_column7] -add {LAGUNA_X14Y600:LAGUNA_X15Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column7]
create_pblock slr2_cross_top_column8
add_cells_to_pblock [get_pblocks slr2_cross_top_column8] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_16]
add_cells_to_pblock [get_pblocks slr2_cross_top_column8] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_17]
resize_pblock [get_pblocks slr2_cross_top_column8] -add {SLICE_X122Y660:SLICE_X125Y719}
resize_pblock [get_pblocks slr2_cross_top_column8] -add {LAGUNA_X16Y600:LAGUNA_X17Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column8]
create_pblock slr2_cross_top_column9
add_cells_to_pblock [get_pblocks slr2_cross_top_column9] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_18]
add_cells_to_pblock [get_pblocks slr2_cross_top_column9] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_19]
resize_pblock [get_pblocks slr2_cross_top_column9] -add {SLICE_X137Y660:SLICE_X140Y719}
resize_pblock [get_pblocks slr2_cross_top_column9] -add {LAGUNA_X18Y600:LAGUNA_X19Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column9]
create_pblock slr2_cross_top_column10
add_cells_to_pblock [get_pblocks slr2_cross_top_column10] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_20]
add_cells_to_pblock [get_pblocks slr2_cross_top_column10] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_21]
resize_pblock [get_pblocks slr2_cross_top_column10] -add {SLICE_X150Y660:SLICE_X153Y719}
resize_pblock [get_pblocks slr2_cross_top_column10] -add {LAGUNA_X20Y600:LAGUNA_X21Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column10]
create_pblock slr2_cross_top_column11
add_cells_to_pblock [get_pblocks slr2_cross_top_column11] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_22]
add_cells_to_pblock [get_pblocks slr2_cross_top_column11] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_23]
resize_pblock [get_pblocks slr2_cross_top_column11] -add {SLICE_X162Y660:SLICE_X165Y719}
resize_pblock [get_pblocks slr2_cross_top_column11] -add {LAGUNA_X22Y600:LAGUNA_X23Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column11]
create_pblock slr2_cross_top_column12
add_cells_to_pblock [get_pblocks slr2_cross_top_column12] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_24]
add_cells_to_pblock [get_pblocks slr2_cross_top_column12] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_25]
resize_pblock [get_pblocks slr2_cross_top_column12] -add {SLICE_X180Y660:SLICE_X183Y719}
resize_pblock [get_pblocks slr2_cross_top_column12] -add {LAGUNA_X24Y600:LAGUNA_X25Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column12]
create_pblock slr2_cross_top_column13
add_cells_to_pblock [get_pblocks slr2_cross_top_column13] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_26]
add_cells_to_pblock [get_pblocks slr2_cross_top_column13] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_27]
resize_pblock [get_pblocks slr2_cross_top_column13] -add {SLICE_X192Y660:SLICE_X195Y719}
resize_pblock [get_pblocks slr2_cross_top_column13] -add {LAGUNA_X26Y600:LAGUNA_X27Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column13]
create_pblock slr2_cross_top_column14
add_cells_to_pblock [get_pblocks slr2_cross_top_column14] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_28]
add_cells_to_pblock [get_pblocks slr2_cross_top_column14] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_29]
resize_pblock [get_pblocks slr2_cross_top_column14] -add {SLICE_X212Y660:SLICE_X215Y719}
resize_pblock [get_pblocks slr2_cross_top_column14] -add {LAGUNA_X28Y600:LAGUNA_X29Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column14]
create_pblock slr2_cross_top_column15
add_cells_to_pblock [get_pblocks slr2_cross_top_column15] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_30]
add_cells_to_pblock [get_pblocks slr2_cross_top_column15] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_31]
resize_pblock [get_pblocks slr2_cross_top_column15] -add {SLICE_X226Y660:SLICE_X228Y719}
resize_pblock [get_pblocks slr2_cross_top_column15] -add {LAGUNA_X30Y600:LAGUNA_X31Y719}
set_property IS_SOFT FALSE [get_pblocks slr2_cross_top_column15]

create_pblock slr3_cross_bottom_column0
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column0] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_1]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column0] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_0]
resize_pblock [get_pblocks slr3_cross_bottom_column0] -add {SLICE_X6Y720:SLICE_X9Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column0] -add {LAGUNA_X0Y720:LAGUNA_X1Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column0]
create_pblock slr3_cross_bottom_column1
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column1] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_3]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column1] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_2]
resize_pblock [get_pblocks slr3_cross_bottom_column1] -add {SLICE_X17Y720:SLICE_X20Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column1] -add {LAGUNA_X2Y720:LAGUNA_X3Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column1]
create_pblock slr3_cross_bottom_column2
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column2] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_5]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column2] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_4]
resize_pblock [get_pblocks slr3_cross_bottom_column2] -add {SLICE_X35Y720:SLICE_X38Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column2] -add {LAGUNA_X4Y720:LAGUNA_X5Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column2]
create_pblock slr3_cross_bottom_column3
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column3] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_7]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column3] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_6]
resize_pblock [get_pblocks slr3_cross_bottom_column3] -add {SLICE_X48Y720:SLICE_X51Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column3] -add {LAGUNA_X6Y720:LAGUNA_X7Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column3]
create_pblock slr3_cross_bottom_column4
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column4] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_9]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column4] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_8]
resize_pblock [get_pblocks slr3_cross_bottom_column4] -add {SLICE_X61Y720:SLICE_X64Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column4] -add {LAGUNA_X8Y720:LAGUNA_X9Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column4]
create_pblock slr3_cross_bottom_column5
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column5] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_11]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column5] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_10]
resize_pblock [get_pblocks slr3_cross_bottom_column5] -add {SLICE_X81Y720:SLICE_X84Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column5] -add {LAGUNA_X10Y720:LAGUNA_X11Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column5]
create_pblock slr3_cross_bottom_column6
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column6] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_13]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column6] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_12]
resize_pblock [get_pblocks slr3_cross_bottom_column6] -add {SLICE_X95Y720:SLICE_X98Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column6] -add {LAGUNA_X12Y720:LAGUNA_X13Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column6]
create_pblock slr3_cross_bottom_column7
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column7] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_15]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column7] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_14]
resize_pblock [get_pblocks slr3_cross_bottom_column7] -add {SLICE_X109Y720:SLICE_X112Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column7] -add {LAGUNA_X14Y720:LAGUNA_X15Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column7]
create_pblock slr3_cross_bottom_column8
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column8] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_17]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column8] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_16]
resize_pblock [get_pblocks slr3_cross_bottom_column8] -add {SLICE_X122Y720:SLICE_X125Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column8] -add {LAGUNA_X16Y720:LAGUNA_X17Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column8]
create_pblock slr3_cross_bottom_column9
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column9] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_19]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column9] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_18]
resize_pblock [get_pblocks slr3_cross_bottom_column9] -add {SLICE_X137Y720:SLICE_X140Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column9] -add {LAGUNA_X18Y720:LAGUNA_X19Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column9]
create_pblock slr3_cross_bottom_column10
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column10] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_21]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column10] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_20]
resize_pblock [get_pblocks slr3_cross_bottom_column10] -add {SLICE_X150Y720:SLICE_X153Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column10] -add {LAGUNA_X20Y720:LAGUNA_X21Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column10]
create_pblock slr3_cross_bottom_column11
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column11] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_23]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column11] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_22]
resize_pblock [get_pblocks slr3_cross_bottom_column11] -add {SLICE_X162Y720:SLICE_X165Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column11] -add {LAGUNA_X22Y720:LAGUNA_X23Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column11]
create_pblock slr3_cross_bottom_column12
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column12] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_25]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column12] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_24]
resize_pblock [get_pblocks slr3_cross_bottom_column12] -add {SLICE_X180Y720:SLICE_X183Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column12] -add {LAGUNA_X24Y720:LAGUNA_X25Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column12]
create_pblock slr3_cross_bottom_column13
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column13] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_27]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column13] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_26]
resize_pblock [get_pblocks slr3_cross_bottom_column13] -add {SLICE_X192Y720:SLICE_X195Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column13] -add {LAGUNA_X26Y720:LAGUNA_X27Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column13]
create_pblock slr3_cross_bottom_column14
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column14] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_29]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column14] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_28]
resize_pblock [get_pblocks slr3_cross_bottom_column14] -add {SLICE_X212Y720:SLICE_X215Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column14] -add {LAGUNA_X28Y720:LAGUNA_X29Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column14]
create_pblock slr3_cross_bottom_column15
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column15] [get_cells -quiet design_1_i/slr2_to_3_crossing/*_register_slice_31]
add_cells_to_pblock [get_pblocks slr3_cross_bottom_column15] [get_cells -quiet design_1_i/slr3_to_2_crossing/*_register_slice_30]
resize_pblock [get_pblocks slr3_cross_bottom_column15] -add {SLICE_X226Y720:SLICE_X228Y779}
resize_pblock [get_pblocks slr3_cross_bottom_column15] -add {LAGUNA_X30Y720:LAGUNA_X31Y839}
set_property IS_SOFT FALSE [get_pblocks slr3_cross_bottom_column15]

create_pblock slr0_static_region
add_cells_to_pblock [get_pblocks slr0_static_region] [get_cells -quiet [list design_1_i/static_region/proc_sys_reset_0]]
resize_pblock [get_pblocks slr0_static_region] -add {SLICE_X117Y180:SLICE_X119Y239}
create_pblock slr1_static_region
add_cells_to_pblock [get_pblocks slr1_static_region] [get_cells -quiet [list design_1_i/static_region/proc_sys_reset_1]]
resize_pblock [get_pblocks slr1_static_region] -add {SLICE_X117Y240:SLICE_X119Y299}
resize_pblock [get_pblocks slr1_static_region] -add {BIAS_X0Y8:BIAS_X0Y9}
resize_pblock [get_pblocks slr1_static_region] -add {BITSLICE_CONTROL_X0Y32:BITSLICE_CONTROL_X0Y39}
resize_pblock [get_pblocks slr1_static_region] -add {BITSLICE_RX_TX_X0Y208:BITSLICE_RX_TX_X0Y259}
resize_pblock [get_pblocks slr1_static_region] -add {BITSLICE_TX_X0Y32:BITSLICE_TX_X0Y39}
resize_pblock [get_pblocks slr1_static_region] -add {HPIOBDIFFINBUF_X0Y96:HPIOBDIFFINBUF_X0Y119}
resize_pblock [get_pblocks slr1_static_region] -add {HPIOBDIFFOUTBUF_X0Y96:HPIOBDIFFOUTBUF_X0Y119}
resize_pblock [get_pblocks slr1_static_region] -add {HPIO_VREF_SITE_X0Y8:HPIO_VREF_SITE_X0Y9}
resize_pblock [get_pblocks slr1_static_region] -add {IOB_X0Y208:IOB_X0Y259}
resize_pblock [get_pblocks slr1_static_region] -add {PLL_SELECT_SITE_X0Y32:PLL_SELECT_SITE_X0Y39}
resize_pblock [get_pblocks slr1_static_region] -add {RIU_OR_X0Y16:RIU_OR_X0Y19}
resize_pblock [get_pblocks slr1_static_region] -add {XIPHY_FEEDTHROUGH_X0Y16:XIPHY_FEEDTHROUGH_X0Y19}
create_pblock slr2_static_region
add_cells_to_pblock [get_pblocks slr2_static_region] [get_cells -quiet [list design_1_i/static_region/proc_sys_reset_2]]
resize_pblock [get_pblocks slr2_static_region] -add {SLICE_X117Y480:SLICE_X119Y539}
resize_pblock [get_pblocks slr2_static_region] -add {IOB_X0Y416:IOB_X0Y467}
create_pblock slr3_static_region
add_cells_to_pblock [get_pblocks slr3_static_region] [get_cells -quiet [list design_1_i/static_region/proc_sys_reset_3]]
resize_pblock [get_pblocks slr3_static_region] -add {SLICE_X117Y720:SLICE_X119Y779}


