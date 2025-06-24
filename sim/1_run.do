if {![file exists modelsim.ini]} {vmap -c }

rm -rf work

vlog  ../hdl/tb/file_read_simple.sv     -sv -work work
#vlog  ../hdl/tb/file_read.sv            -sv -work work
vlog  ../hdl/tb/file_read_tb.sv  -sv -work work

vsim  -vopt work.file_read_tb -voptargs=+acc -t ns

# ps resolution
#vsim  -vopt work.file_read_tb -voptargs=+acc -t ps
#vsim  -vopt work.file_read_tb -voptargs=+acc -t fs

log -r /*

if {[file exists wave.do]} {do wave.do}

run 5us

