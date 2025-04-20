onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/DATA_WIDTH
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/DATA_VALUE
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/ser_clk
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/ser_data
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/I2C_SM
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/start_tx
add wave -noupdate -group gen -radix unsigned /i2c_top_tb/serial_data_gen_inst/bit_index
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/ser_data_tri
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/CLK_SM
add wave -noupdate -group gen /i2c_top_tb/serial_data_gen_inst/DAT_SM
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_i
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_o
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_t
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_i
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_t
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_o
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/I2C_SM
add wave -noupdate -expand -group rsp -radix unsigned /i2c_top_tb/i2c_top_inst/i2c_sink_inst/cnt
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_re
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/dev_addr
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/mem_addr
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data1
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/ack
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/ack_sync
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_fe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {920 ns} 1} {{Cursor 2} {1820 ns} 1} {{Cursor 3} {2720 ns} 1} {{Cursor 4} {2820 ns} 1} {{Cursor 5} {1920 ns} 1} {{Cursor 6} {1020 ns} 1} {{Cursor 7} {4970 ns} 1} {{Cursor 8} {5070 ns} 1} {{Cursor 9} {5870 ns} 1} {{Cursor 10} {5970 ns} 1} {{Cursor 11} {6770 ns} 1} {{Cursor 12} {6870 ns} 1} {{Cursor 13} {589 ns} 0}
quietly wave cursor active 13
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
