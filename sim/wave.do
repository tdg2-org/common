onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_tb/clk
add wave -noupdate /fifo_tb/wr
add wave -noupdate /fifo_tb/rst
add wave -noupdate /fifo_tb/data
add wave -noupdate /fifo_tb/rd
add wave -noupdate -divider <NULL>
add wave -noupdate /fifo_tb/fifo_inst/data_mem
add wave -noupdate /fifo_tb/fifo_inst/data_o
add wave -noupdate -radix unsigned /fifo_tb/fifo_inst/rd_idx
add wave -noupdate -radix unsigned /fifo_tb/fifo_inst/wr_idx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {922 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {4200 ns}
