if {![file exists modelsim.ini]} {vmap -c }

rm -rf work

#vcom  ../hdl/common/2008/led_cnt_vhd08.vhd  -2008 -work work

vlog  ../hdl/fifo.sv    -sv -work work
vlog  ../tb/fifo_tb.sv  -sv -work work

vsim  -vopt work.fifo_tb2 -voptargs=+acc -t ns

# ps resolution
#vsim  -vopt work.msk_tb -voptargs=+acc -t ps
#vsim  -vopt work.msk_tb -voptargs=+acc -t fs

log -r /*

if {[file exists wave.do]} {do wave.do}

run 5us