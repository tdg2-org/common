set tbFile test_tb

#vcom  ../hdl/common/2008/led_cnt_vhd08.vhd  -2008 -work work
#vlog   $comDir/$x -sv -work work
#--------------------------------------------------------------------------------------------------
# common
#--------------------------------------------------------------------------------------------------
set comDir ../../hdl
#set comFiles {\
#  tb/axis_stim_syn_tb.sv \
#  axis_stim_syn.sv \
#}

set comFiles_vhd19 {\
  2019/test.vhd \
}


#foreach x $comFiles {
#  vlog $comDir/$x -sv -work work
#}

foreach x $comFiles_vhd19 {
  vcom $comDir/$x -2008 -work work
}

#--------------------------------------------------------------------------------------------------
# tb
#--------------------------------------------------------------------------------------------------

# system verilog
#vlog $comDir/tb/$tbFile.sv   -sv -work work

# vhdl 2019
vcom $comDir/tb/2019/$tbFile.vhd   -2008 -work work
