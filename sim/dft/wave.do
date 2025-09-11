onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dft_tb/dft_mdl_i/clk
add wave -noupdate /dft_tb/dft_mdl_i/rst
add wave -noupdate /dft_tb/dft_mdl_i/theta
add wave -noupdate -format Analog-Step -height 84 -max 30272.999999999996 -min -32768.0 -radix decimal /dft_tb/dft_mdl_i/sin_o
add wave -noupdate -format Analog-Step -height 84 -max 32767.0 -min -32767.0 -radix decimal /dft_tb/dft_mdl_i/cos_o
add wave -noupdate -format Analog-Step -height 84 -max 31945.0 -min -31945.0 -radix decimal /dft_tb/dft_mdl_i/x
add wave -noupdate -format Analog-Step -height 84 -max 2142372073.0000005 -min -2145312359.0 -radix decimal /dft_tb/dft_mdl_i/acc_I
add wave -noupdate -format Analog-Step -height 84 -max 2130152408.0 -min -2145161658.0 -radix decimal /dft_tb/dft_mdl_i/acc_Q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14792 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 156
configure wave -valuecolwidth 153
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {83390 ps}
