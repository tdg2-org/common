rm -rf work

vlog  ../hdl/fifo.sv    -sv -work work
vlog  ../tb/fifo_tb.sv  -sv -work work

restart

log -r *

run 1us