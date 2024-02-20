## ------------------------------------------------------------------------------
##   (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
## 
##   This file contains confidential and proprietary information
##   of Advanced Micro Devices, Inc. and is protected under U.S. and
##   international copyright and other intellectual property
##   laws.
## 
##   DISCLAIMER
##   This disclaimer is not a license and does not grant any
##   rights to the materials distributed herewith. Except as
##   otherwise provided in a valid license issued to you by
##   AMD, and to the maximum extent permitted by applicable
##   law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
##   WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
##   AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
##   BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
##   INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
##   (2) AMD shall not be liable (whether in contract or tort,
##   including negligence, or under any other theory of
##   liability) for any loss or damage of any kind or nature
##   related to, arising under or in connection with these
##   materials, including for any direct, or any indirect,
##   special, incidental, or consequential loss or damage
##   (including loss of data, profits, goodwill, or any type of
##   loss or damage suffered as a result of any action brought
##   by a third party) even if such damage or loss was
##   reasonably foreseeable or AMD had been advised of the
##   possibility of the same.
## 
##   CRITICAL APPLICATIONS
##   AMD products are not designed or intended to be fail-
##   safe, or for use in any application requiring fail-safe
##   performance, such as life-support or safety devices or
##   systems, Class III medical devices, nuclear facilities,
##   applications related to the deployment of airbags, or any
##   other applications that could lead to death, personal
##   injury, or severe property or environmental damage
##   (individually and collectively, \"Critical
##   Applications\"). Customer assumes the sole risk and
##   liability of any use of AMD products in Critical
##   Applications, subject only to applicable laws and
##   regulations governing limitations on product liability.
## 
##   THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
##   PART OF THIS FILE AT ALL TIMES.
##
## 
##
##       Owner:          
##       Revision:       $Id: $
##                       $Author: $
##                       $DateTime: $
##                       $Change: $
##       Description:
##
##////////////////////////////////////////////////////////////////////////////
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# DCMAC example design-level XDC file
# ----------------------------------------------------------------------------------------------------------------------

create_clock -period 6.400 -name gt0_ref_clk0_p -waveform {0.000 3.200} [get_ports gt0_ref_clk0_p]
create_clock -period 6.400 -name gt0_ref_clk1_p -waveform {0.000 3.200} [get_ports gt0_ref_clk1_p]
create_clock -period 6.400 -name gt1_ref_clk0_p -waveform {0.000 3.200} [get_ports gt1_ref_clk0_p]
create_clock -period 6.400 -name gt1_ref_clk1_p -waveform {0.000 3.200} [get_ports gt1_ref_clk1_p]

 

#set_property BEL GTM_QUAD [get_cells i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base/inst/quad_inst]
#set_property LOC GTM_QUAD_X1Y5 [get_cells i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base/inst/quad_inst]

#set_property BEL GTM_QUAD [get_cells i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base_1/inst/quad_inst]
#set_property LOC GTM_QUAD_X1Y6 [get_cells i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base_1/inst/quad_inst]
 
##### DCMAC_X1Y1 - clock region X9Y6, SLR1
# use GTM Bank 209 & Bank 210
##### GTM Bank 209 (quad X1Y7, clock region X9Y6, SLR1)
set_property PACKAGE_PIN AB49 [get_ports gt0_ref_clk0_n]
set_property PACKAGE_PIN AR60 [get_ports {gt0_rxn_in0[0]}]
##### GTM Bank 210 (quad X1Y8, clock region X9Y6, SLR1)
set_property PACKAGE_PIN AA47 [get_ports gt0_ref_clk1_n]
set_property PACKAGE_PIN AM62 [get_ports {gt0_rxn_in1[0]}]
 
##### DCMAC_X0Y6 - clock region X0Y13, SLR3
# use GTM Bank 123 & Bank 124
##### GTM Bank 123 (quad X0Y21, clock region X0Y13, SLR3)
set_property PACKAGE_PIN K28 [get_ports gt1_ref_clk0_n]
set_property PACKAGE_PIN A18 [get_ports {gt1_rxn_in0[0]}]
##### GTM Bank 124 (quad X0Y22, clock region X0Y13, SLR3)
set_property PACKAGE_PIN K30 [get_ports gt1_ref_clk1_n]
set_property PACKAGE_PIN A24 [get_ports {gt1_rxn_in1[0]}]
 
# NOC will connect NMUs X2Y9/X2Y10/X1Y9/X1Y10    (X5Y6 & X3Y6 clock regions)
#               to NSUs X2Y21/X2Y22/X1Y21/X1Y22  (X5Y12 & X3Y12 clock regions)
 

 

#set_property USER_CLOCK_ROOT {X7Y1} [get_nets i_*exdes/i_*clk_wiz_0/inst/clock_primitive_inst/clkfbin_primitive] -quiet


## User can update the GT_QUAD location based on the DCMAC hard IP location with appropriate GT mapping to avoid implementation failures
## DCMAC hard IP LOC constraint is available in core xdc
## The design must meet the following rules when connecting the Versal ACAP DCMAC Hard IP core to the transceivers. 
##-     GT Quads have to be contiguous based on the DCMAC configuration.


## Additional constraints
##set_clock_groups -name pl0_ref_clk_0 -asynchronous -group [get_clocks -of_objects [get_pins i_dcmac_0_cips_wrapper/dcmac_0_cips_i/pl0_ref_clk_0]]

set_false_path -to [get_pins -of [get_cells -hierarchical -filter {NAME =~ *dcmac_0_core_*_top*}] -filter {REF_PIN_NAME =~ RX_CORE_RESET}]
set_false_path -to [get_pins -of [get_cells -hierarchical -filter {NAME =~ *dcmac_0_core_*_top*}] -filter {REF_PIN_NAME =~ TX_CORE_RESET}]

#### Waivers ####
create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This tx_pkt_gen_max_len register drives the pkt_len_r register and registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_max_len_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_axis_pkt_gen_ts/*ctrl_gen/pkt_len_r_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-10} -user "dcmac" -desc "This tx_pkt_gen_max_len register drives the pkt_len_r register and registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_max_len_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_axis_pkt_gen_ts/*ctrl_gen/pkt_len_r_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_max_len_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*_axis_pkt_gen_ts/*ctrl_gen/pkt_len_r_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This scratch register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [list [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/FSM_onehot_state_reg*}] -filter { name =~ *CE } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_axis_pkt_mon_reg*}] -filter { name =~ *D } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_axis_pkt_mon_reg*}] -filter { name =~ *R } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_gearbox_valid_reg*}] -filter { name =~ *S } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_gearbox_slice_reg*}] -filter { name =~ *D } ]]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/memcel_apb3_reset_d_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/cal_cnt_reg*}] -filter { name =~ *R } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This fixe_calender register drives fixe_calender_axi and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/fixe_calender_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/fixe_calender_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This fixe_calender register drives fixe_calender_axi and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/fixe_calender_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/fixe_calender_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-10} -user "dcmac" -desc "This data rate register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*sniffer_*/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "This data rate register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*sniffer_*/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This data rate register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*sniffer_*/client_data_rate_apb3_reg**}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*sniffer_*/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This independent mode register drives multiple destination path and all are registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/o_independent_mode_reg*}] -filter { name =~ *C } ]\
-to [list [get_pins -of [get_cells -hier -filter {name =~ */*emu_gearbox_tx_*/rst_mask_reg*}] -filter { name =~ *D } ]\
[get_pins -of [get_cells -hier -filter {name =~ */rx_gearbox_slice_reg*}] -filter { name =~ *D } ] ]

create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This multi bit clear counter registered with destination clock not needed syncer" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/clear_*x_counters_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_*_ts/*_pkt_cnt_*_inst/clear_rx_counters_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-10} -user "dcmac" -desc "This scratch register drives the rx_gearbox_slice_reg and registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter { name =~ */rx_gearbox_slice_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "The CDC-13 warning is waived, this is a level signal and it is getting changed when pm_tick is applied. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_mon_ts/rx_id_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-11} -user "dcmac" -desc "Fan-out is expected on this data rate reg path as this drives to multiple destination" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter { name =~ */*_sniffer/client_data_rate_apb3_reg*}] -filter { name =~ *C } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/scratch_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*rx_gearbox_slice_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-2} -user "dcmac" -desc "The destination paths are already have the syncers and ASYNC_REG property is not needed for those syncers" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/port*_apb3_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*sniffer_*/port*_axi_reg*}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "The CDC-1 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer_*/o_emu_*x_rst_reg*}] -filter { name =~ *C}]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*emu_gearbox_tx_*/rst_mask_reg*}] -filter { name =~ *D}]

#create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "This txdata register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
#-from [get_pins {i_*_exdes/i_*_support_wrapper/*_support_i/*_core/inst/i_*_exdes_support_*_core_0_top/obsabqrqac5cbvet/TX_ALT_SERDES_CLK[*]}]\
#-to [get_pins {i_*_exdes/i_*_exdes_support_wrapper/*_exdes_support_i/*_gt_wrapper/gt_quad_base*/inst/quad_inst/CH*_TXDATA[*]}]
####

## Additional false path constraints within the Gen/Mon
#set_false_path -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */i_*_clk_wiz*/inst/clock_primitive_inst/MMCME5_inst}] -filter {name =~ *CLKOUT*}]] -through [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer/*}]]
#set_false_path -from [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */i_*_clk_wiz*/inst/clock_primitive_inst/MMCME5_inst}] -filter {name =~ *CLKOUT*}]] -to [get_clocks clk_pl_0] -through [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer/*}]]
set_false_path -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */i_*_clk_wiz*/inst/clock_primitive_inst/MMCME5_inst}] -filter {name =~ *CLKOUT*}]]
set_false_path -from [get_clocks -of_objects [get_pins -of [get_cells -hier -filter {name =~ */i_*_clk_wiz*/inst/clock_primitive_inst/MMCME5_inst}] -filter {name =~ *CLKOUT*}]] -to [get_clocks clk_pl_0]





create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This tx_pkt_gen_min_len_reg register drives pkt_len_r_reg and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */tx_pkt_gen_min_len_reg[*]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*ctrl_gen/pkt_len_r_reg[*][*]}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-4} -user "dcmac" -desc "This o_emu_rx_rst_reg register drives o_prbs_locked_reg and registered on the destination clock" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer_*/o_emu_rx_rst_reg[*]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_mon_ts/o_prbs_locked_reg[*]}] -filter { name =~ *D } ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This o_independent_mode ignal is levle signale and it is driving to reset of rx_gearbox_slice_reg,so this is safe to ignore " -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*core_sniffer_*/o_independent_mode_reg*}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ *_exdes/rx_gearbox_slice_reg[*][ena][*]}] -filter { name =~ *R } ]


create_waiver -quiet -type CDC -id {CDC-13} -user "dcmac" -desc "The CDC-13 warning is waived as it is a level signal in reset path. This is safe to ignore" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */gpio_core_*/Not_Dual.gpio_Data_Out_reg[*]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */i_*_exdes_support_*_core_*_top/obsabqrqac5cbvet*}] -filter { name =~ *X_CORE_RESET} ]

create_waiver -quiet -type CDC -id {CDC-1} -user "dcmac" -desc "This pkt_gen_min_len register drives multiple destination path and all are registered on the destination clocks" -tags "1103070"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_min_len_reg[15]}] -filter { name =~ *C } ]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_gen_ts/*_ctrl_gen/pkt_len_r_reg[*][*]}] -filter { name =~ *D }]  


create_waiver -quiet -type CDC -id {CDC-5} -user "dcmac" -desc "The path is registered and it does not require ASYNC_REG" -tags "1169576"\
-from [get_pins -of [get_cells -hier -filter {name =~ */*emu_register/tx_pkt_gen_ena*}] -filter {name =~ *C}]\
-to [get_pins -of [get_cells -hier -filter {name =~ */*axis_pkt_gen_ts/*_ctrl_gen/pkt_ena*}] -filter {name =~ *D}]

create_waiver -quiet -type DRC -id {REQP-2057} -user "dcmac" -desc "REQP-2057 is waived as the MBUFG_GT CLR and CLRBLEAF pins are connected with the GT Reset IP" -tags "1138767" -objects [get_cells -hier -filter {REF_NAME==MBUFG_GT && NAME=~ */*_exdes_support*/*gt_wrapper*/*}]


