onerror {resume}
quietly virtual signal -install /axis_stim_syn_tb/axis_stim_syn { /axis_stim_syn_tb/axis_stim_syn/M_AXIS_tdata[31:0]} tdata32
quietly WaveActivateNextPane {} 0
add wave -noupdate /axis_stim_syn_tb/rst
add wave -noupdate /axis_stim_syn_tb/clk
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/en
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/en_re
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/clr
add wave -noupdate /axis_stim_syn_tb/cont
add wave -noupdate /axis_stim_syn_tb/cyc
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/en_sr
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/en_stb
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/pkt_en
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/frame_len
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/tready
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/cntr
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/cnt_max
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/tvalid
add wave -noupdate /axis_stim_syn_tb/axis_stim_syn/hiCnt
add wave -noupdate -expand -group {New Group} -radix hexadecimal /axis_stim_syn_tb/axis_stim_syn/tdata32
add wave -noupdate -expand -group {New Group} /axis_stim_syn_tb/axis_stim_syn/M_AXIS_tvalid
add wave -noupdate -expand -group {New Group} /axis_stim_syn_tb/axis_stim_syn/M_AXIS_tdest
add wave -noupdate -expand -group {New Group} /axis_stim_syn_tb/axis_stim_syn/M_AXIS_tlast
add wave -noupdate -expand -group {New Group} /axis_stim_syn_tb/axis_stim_syn/M_AXIS_tready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10025000 ps} 1} {{Cursor 3} {58953057 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 191
configure wave -valuecolwidth 156
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
