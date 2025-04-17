onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/DATA_WIDTH
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/DATA_VALUE
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/ser_clk
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/ser_data
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/I2C_SM
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/start_tx
add wave -noupdate -radix unsigned /i2c_top_tb/serial_data_gen_inst/bit_index
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/ser_data_tri
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/CLK_SM
add wave -noupdate /i2c_top_tb/serial_data_gen_inst/DAT_SM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {920 ns} 1} {{Cursor 2} {1820 ns} 1} {{Cursor 3} {1042 ns} 0}
quietly wave cursor active 3
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
WaveRestoreZoom {0 ns} {8400 ns}
