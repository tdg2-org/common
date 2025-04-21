if {![file exists modelsim.ini]} {vmap -c }

rm -rf work

#vcom  ../hdl/common/2008/led_cnt_vhd08.vhd  -2008 -work work
#vlog  ../hdl/common/led_cnt.sv  -sv -work work
#vlog  ../hdl/tb/led_cnt_tb.sv   -sv -work work

set hdlDir "../../hdl"
set tbDir  "../../tb"
set mainHdlDir "../../../../hdl"

vlog  $hdlDir/i2c_sink.sv -sv -work work
#vlog  $hdlDir/OFF/i2c/i2c_top.sv  -sv -work work
vlog  $mainHdlDir/RM0/i2c_top.sv  -sv -work work
vlog  $tbDir/serial_data_gen_i2c_master_sim.sv -sv -work work
vlog  $tbDir/i2c/i2c_top_tb.sv  -sv -work work


vsim  -vopt work.i2c_top_tb -voptargs=+acc -t ns

# ps resolution
#vsim  -vopt work.msk_tb -voptargs=+acc -t ps
#vsim  -vopt work.msk_tb -voptargs=+acc -t fs

log -r /*

if {[file exists wave.do]} {do wave.do}

run 5us