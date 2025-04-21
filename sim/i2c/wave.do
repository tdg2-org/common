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
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/ack_sync
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_t
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_i
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_t
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_o
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/I2C_SM
add wave -noupdate -expand -group rsp -radix unsigned /i2c_top_tb/i2c_top_inst/i2c_sink_inst/cnt
add wave -noupdate -expand -group rsp /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_re
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/dev_addr
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/rw
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/rw_align_fe
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/dev_valid
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/mem_addr
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/mem_valid
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data_in
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/scl_fe
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/sda_send
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/send_byte
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data_send
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data_valid
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data_save
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data_send_en_i
add wave -noupdate /i2c_top_tb/i2c_top_inst/i2c_sink_inst/data_send_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 17} {1572 ns} 0}
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
WaveRestoreZoom {0 ns} {10500 ns}
