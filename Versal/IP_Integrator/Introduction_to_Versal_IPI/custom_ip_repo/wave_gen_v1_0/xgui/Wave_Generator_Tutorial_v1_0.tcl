# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BAUD_RATE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLOCK_RATE_RX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLOCK_RATE_TX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NSAMP_WID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PW" -parent ${Page_0}


}

proc update_PARAM_VALUE.BAUD_RATE { PARAM_VALUE.BAUD_RATE } {
	# Procedure called to update BAUD_RATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUD_RATE { PARAM_VALUE.BAUD_RATE } {
	# Procedure called to validate BAUD_RATE
	return true
}

proc update_PARAM_VALUE.CLOCK_RATE_RX { PARAM_VALUE.CLOCK_RATE_RX } {
	# Procedure called to update CLOCK_RATE_RX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_RATE_RX { PARAM_VALUE.CLOCK_RATE_RX } {
	# Procedure called to validate CLOCK_RATE_RX
	return true
}

proc update_PARAM_VALUE.CLOCK_RATE_TX { PARAM_VALUE.CLOCK_RATE_TX } {
	# Procedure called to update CLOCK_RATE_TX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_RATE_TX { PARAM_VALUE.CLOCK_RATE_TX } {
	# Procedure called to validate CLOCK_RATE_TX
	return true
}

proc update_PARAM_VALUE.NSAMP_WID { PARAM_VALUE.NSAMP_WID } {
	# Procedure called to update NSAMP_WID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NSAMP_WID { PARAM_VALUE.NSAMP_WID } {
	# Procedure called to validate NSAMP_WID
	return true
}

proc update_PARAM_VALUE.PW { PARAM_VALUE.PW } {
	# Procedure called to update PW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PW { PARAM_VALUE.PW } {
	# Procedure called to validate PW
	return true
}


proc update_MODELPARAM_VALUE.BAUD_RATE { MODELPARAM_VALUE.BAUD_RATE PARAM_VALUE.BAUD_RATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAUD_RATE}] ${MODELPARAM_VALUE.BAUD_RATE}
}

proc update_MODELPARAM_VALUE.CLOCK_RATE_RX { MODELPARAM_VALUE.CLOCK_RATE_RX PARAM_VALUE.CLOCK_RATE_RX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_RATE_RX}] ${MODELPARAM_VALUE.CLOCK_RATE_RX}
}

proc update_MODELPARAM_VALUE.CLOCK_RATE_TX { MODELPARAM_VALUE.CLOCK_RATE_TX PARAM_VALUE.CLOCK_RATE_TX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_RATE_TX}] ${MODELPARAM_VALUE.CLOCK_RATE_TX}
}

proc update_MODELPARAM_VALUE.PW { MODELPARAM_VALUE.PW PARAM_VALUE.PW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PW}] ${MODELPARAM_VALUE.PW}
}

proc update_MODELPARAM_VALUE.NSAMP_WID { MODELPARAM_VALUE.NSAMP_WID PARAM_VALUE.NSAMP_WID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NSAMP_WID}] ${MODELPARAM_VALUE.NSAMP_WID}
}

