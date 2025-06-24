rm -rf work

vlog  ../hdl/tb/file_read_simple.sv     -sv -work work
#vlog  ../hdl/tb/file_read.sv            -sv -work work
vlog  ../hdl/tb/file_read_tb.sv   -sv -work work

restart

log -r *

run 10us