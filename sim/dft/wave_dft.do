onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dft_tb/dft_mdl_i/clk
add wave -noupdate /dft_tb/dft_mdl_i/rst
add wave -noupdate /dft_tb/dft_bin_real_mdl_inst/sample_valid
add wave -noupdate -format Analog-Step -height 84 -max 31945.0 -min -31945.0 -radix decimal /dft_tb/dft_bin_real_mdl_inst/x
add wave -noupdate /dft_tb/dft_bin_real_mdl_inst/X_im
add wave -noupdate /dft_tb/dft_bin_real_mdl_inst/X_re
add wave -noupdate /dft_tb/dft_bin_real_mdl_inst/bin_done
add wave -noupdate -radix decimal /dft_tb/dft_bin_real_mdl_inst/acc_im
add wave -noupdate -radix decimal /dft_tb/dft_bin_real_mdl_inst/acc_re
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61542416 ps} 0}
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
WaveRestoreZoom {0 ps} {315 us}
