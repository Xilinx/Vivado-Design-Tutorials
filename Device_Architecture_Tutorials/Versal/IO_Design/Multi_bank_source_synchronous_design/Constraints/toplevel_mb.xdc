
###########################################################
# Clocks
###########################################################

# IO-Bank 705
set_property PACKAGE_PIN AW27 [get_ports CLKIN_p]
set_property PACKAGE_PIN AY27 [get_ports CLKIN_n]
set_property DATA_RATE DDR [get_ports CLKIN_p]
set_property IOSTANDARD LVDS15 [get_ports CLKIN_p]
set_property DC_BIAS DC_BIAS_0 [get_ports CLKIN_p]
set_property EQUALIZATION EQ_NONE [get_ports CLKIN_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports CLKIN_p]
set_property DATA_RATE DDR [get_ports CLKIN_n]
set_property IOSTANDARD LVDS15 [get_ports CLKIN_n]
set_property DC_BIAS DC_BIAS_0 [get_ports CLKIN_n]
set_property EQUALIZATION EQ_NONE [get_ports CLKIN_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports CLKIN_n]
create_clock -period 5.000 [get_ports CLKIN_p]

# IO-Bank 711
set_property PACKAGE_PIN AK8 [get_ports chipscope_clk_in_p_pin]
set_property PACKAGE_PIN AK7 [get_ports chipscope_clk_in_n_pin]
set_property IOSTANDARD LVDS15 [get_ports chipscope_clk_in_p_pin]
set_property DC_BIAS DC_BIAS_0 [get_ports chipscope_clk_in_p_pin]
set_property DIFF_TERM_ADV TERM_100 [get_ports chipscope_clk_in_p_pin]
set_property EQUALIZATION EQ_NONE [get_ports chipscope_clk_in_n_pin]
set_property IOSTANDARD LVDS15 [get_ports chipscope_clk_in_n_pin]
set_property DC_BIAS DC_BIAS_0 [get_ports chipscope_clk_in_n_pin]
set_property DIFF_TERM_ADV TERM_100 [get_ports chipscope_clk_in_n_pin]
set_property EQUALIZATION EQ_NONE [get_ports chipscope_clk_in_n_pin]
create_clock -period 5.000 [get_ports chipscope_clk_in_p_pin]

set_property CLOCK_DEDICATED_ROUTE ANY_CMT_REGION [get_nets int_clkin_rx_bufg]


#########################################################
#########       Placement   Constraints          ########
#########################################################

#####################
#### TX bank 706 ####
#####################
#LA_02
set_property PACKAGE_PIN AW24 [get_ports Tx_data_n0_bs0_p_b0]
set_property PACKAGE_PIN AY25 [get_ports Tx_data_n0_bs1_n_b0]
#LA_03
set_property PACKAGE_PIN AV22 [get_ports Tx_data_n0_bs2_p_b0]
set_property PACKAGE_PIN AW21 [get_ports Tx_data_n0_bs3_n_b0]
#LA_12
set_property PACKAGE_PIN BG21 [get_ports Tx_data_n0_bs4_p_b0]
set_property PACKAGE_PIN BF22 [get_ports Tx_data_n0_bs5_n_b0]
#LA_14
set_property PACKAGE_PIN AU24 [get_ports Tx_data_n1_bs0_p_b0]
set_property PACKAGE_PIN AU23 [get_ports Tx_data_n1_bs1_n_b0]
#LA_00
set_property PACKAGE_PIN BD23 [get_ports Tx_data_n2_bs0_p_b0]
set_property PACKAGE_PIN BD24 [get_ports Tx_data_n2_bs1_n_b0]

############################
#### TX bank 707 Bank 1 ####
############################
#LA_23
set_property PACKAGE_PIN BB20 [get_ports Tx_data_n0_bs0_p_b1]
set_property PACKAGE_PIN BB19 [get_ports Tx_data_n0_bs1_n_b1]
#LA_24
set_property PACKAGE_PIN BA20 [get_ports Tx_data_n0_bs2_p_b1]
set_property PACKAGE_PIN BA19 [get_ports Tx_data_n0_bs3_n_b1]
#LA_18
set_property PACKAGE_PIN BE17 [get_ports Tx_data_n2_bs0_p_b1]
set_property PACKAGE_PIN BD17 [get_ports Tx_data_n2_bs1_n_b1]

#######################
####  Rx bank 707  ####
#######################
#LA_19
set_property PACKAGE_PIN BA17 [get_ports Rx_data_n0_bs0_p_b0]
set_property PACKAGE_PIN BA16 [get_ports Rx_data_n0_bs1_n_b0]
#LA_20
set_property PACKAGE_PIN BE16 [get_ports Rx_data_n0_bs2_p_b0]
set_property PACKAGE_PIN BF17 [get_ports Rx_data_n0_bs3_n_b0]
#LA_29
set_property PACKAGE_PIN AM21 [get_ports Rx_data_n0_bs4_p_b0]
set_property PACKAGE_PIN AM20 [get_ports Rx_data_n0_bs5_n_b0]
#LA_31
set_property PACKAGE_PIN AR18 [get_ports Rx_data_n1_bs0_p_b0]
set_property PACKAGE_PIN AT19 [get_ports Rx_data_n1_bs1_n_b0]
#LA_17
set_property PACKAGE_PIN BB16 [get_ports strobe_p_b0]
set_property PACKAGE_PIN BC16 [get_ports strobe_n_b0]

#############################
####  Rx bank 706 Bank 1 ####
#############################
#LA_06
set_property PACKAGE_PIN BC20 [get_ports Rx_data_n0_bs0_p_b1]
set_property PACKAGE_PIN BD20 [get_ports Rx_data_n0_bs1_n_b1]
#LA_07
set_property PACKAGE_PIN BC25 [get_ports Rx_data_n0_bs2_p_b1]
set_property PACKAGE_PIN BD25 [get_ports Rx_data_n0_bs3_n_b1]
#LA_01
set_property PACKAGE_PIN BC23 [get_ports strobe_p_b1]
set_property PACKAGE_PIN BD22 [get_ports strobe_n_b1]


#########################################################
#########       IOSTANDARD Settings              ########
#########################################################

#######################
#####  Tx IO STD  #####
#######################

set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs0_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs1_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs2_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs3_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs4_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs5_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n1_bs0_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n1_bs1_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n2_bs0_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n2_bs1_n_b0]

set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs0_p_b1]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs1_n_b1]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs2_p_b1]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n0_bs3_n_b1]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n2_bs0_p_b1]
set_property IOSTANDARD LVDS15 [get_ports Tx_data_n2_bs1_n_b1]

#######################
#####  Rx IO STD  #####
#######################

set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs0_p_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs1_n_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs2_p_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs3_n_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs4_p_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs5_n_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n1_bs1_n_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n1_bs0_p_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports strobe_n_b0]
set_property DIFF_TERM_ADV TERM_100 [get_ports strobe_p_b0]

set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs0_p_b1]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs1_n_b1]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs2_p_b1]
set_property DIFF_TERM_ADV TERM_100 [get_ports Rx_data_n0_bs3_n_b1]
set_property DIFF_TERM_ADV TERM_100 [get_ports strobe_n_b1]
set_property DIFF_TERM_ADV TERM_100 [get_ports strobe_p_b1]


set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs0_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs1_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs2_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs3_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs4_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs5_n_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n1_bs0_p_b0]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n1_bs1_n_b0]
set_property IOSTANDARD LVDS15 [get_ports strobe_n_b0]
set_property IOSTANDARD LVDS15 [get_ports strobe_p_b0]

set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs0_p_b1]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs1_n_b1]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs2_p_b1]
set_property IOSTANDARD LVDS15 [get_ports Rx_data_n0_bs3_n_b1]
set_property IOSTANDARD LVDS15 [get_ports strobe_n_b1]
set_property IOSTANDARD LVDS15 [get_ports strobe_p_b1]


set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs0_p_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs1_n_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs2_p_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs3_n_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs4_p_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs5_n_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n1_bs0_p_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n1_bs1_n_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports strobe_n_b0]
set_property DC_BIAS DC_BIAS_0 [get_ports strobe_p_b0]

set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs0_p_b1]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs1_n_b1]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs2_p_b1]
set_property DC_BIAS DC_BIAS_0 [get_ports Rx_data_n0_bs3_n_b1]
set_property DC_BIAS DC_BIAS_0 [get_ports strobe_n_b1]
set_property DC_BIAS DC_BIAS_0 [get_ports strobe_p_b1]


set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs0_p_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs1_n_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs2_p_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs3_n_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs4_p_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs5_n_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n1_bs0_p_b0]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n1_bs1_n_b0]
set_property EQUALIZATION EQ_NONE [get_ports strobe_n_b0]
set_property EQUALIZATION EQ_NONE [get_ports strobe_p_b0]

set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs0_p_b1]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs1_n_b1]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs2_p_b1]
set_property EQUALIZATION EQ_NONE [get_ports Rx_data_n0_bs3_n_b1]
set_property EQUALIZATION EQ_NONE [get_ports strobe_n_b1]
set_property EQUALIZATION EQ_NONE [get_ports strobe_p_b1]
