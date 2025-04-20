rm -rf work

set hdlDir "../../hdl"
set tbDir  "../../tb"

vlog  $hdlDir/i2c_sink.sv -sv -work work
vlog  $hdlDir/OFF/i2c/i2c_top.sv  -sv -work work
vlog  $tbDir/serial_data_gen_i2c_master_sim.sv -sv -work work
vlog  $tbDir/i2c/i2c_top_tb.sv  -sv -work work

restart

log -r *

run 10000ns