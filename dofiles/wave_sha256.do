onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_sha256/clk_i
add wave -noupdate /test_sha256/rst_ni
add wave -noupdate /test_sha256/chunk_id
add wave -noupdate /test_sha256/vld_chunk
add wave -noupdate /test_sha256/rdata
add wave -noupdate /test_sha256/rdy
add wave -noupdate /test_sha256/raddr
add wave -noupdate -radix hexadecimal /test_sha256/hash
add wave -noupdate /test_sha256/vld_hash
add wave -noupdate -childformat {{/test_sha256/Mem(0) -radix hexadecimal} {/test_sha256/Mem(1) -radix hexadecimal} {/test_sha256/Mem(2) -radix hexadecimal} {/test_sha256/Mem(3) -radix hexadecimal} {/test_sha256/Mem(4) -radix hexadecimal} {/test_sha256/Mem(5) -radix hexadecimal} {/test_sha256/Mem(6) -radix hexadecimal} {/test_sha256/Mem(7) -radix hexadecimal} {/test_sha256/Mem(8) -radix hexadecimal} {/test_sha256/Mem(9) -radix hexadecimal} {/test_sha256/Mem(10) -radix hexadecimal} {/test_sha256/Mem(11) -radix hexadecimal} {/test_sha256/Mem(12) -radix hexadecimal} {/test_sha256/Mem(13) -radix hexadecimal} {/test_sha256/Mem(14) -radix hexadecimal} {/test_sha256/Mem(15) -radix hexadecimal}} -subitemconfig {/test_sha256/Mem(0) {-height 15 -radix hexadecimal} /test_sha256/Mem(1) {-height 15 -radix hexadecimal} /test_sha256/Mem(2) {-height 15 -radix hexadecimal} /test_sha256/Mem(3) {-height 15 -radix hexadecimal} /test_sha256/Mem(4) {-height 15 -radix hexadecimal} /test_sha256/Mem(5) {-height 15 -radix hexadecimal} /test_sha256/Mem(6) {-height 15 -radix hexadecimal} /test_sha256/Mem(7) {-height 15 -radix hexadecimal} /test_sha256/Mem(8) {-height 15 -radix hexadecimal} /test_sha256/Mem(9) {-height 15 -radix hexadecimal} /test_sha256/Mem(10) {-height 15 -radix hexadecimal} /test_sha256/Mem(11) {-height 15 -radix hexadecimal} /test_sha256/Mem(12) {-height 15 -radix hexadecimal} /test_sha256/Mem(13) {-height 15 -radix hexadecimal} /test_sha256/Mem(14) {-height 15 -radix hexadecimal} /test_sha256/Mem(15) {-height 15 -radix hexadecimal}} /test_sha256/Mem
add wave -noupdate /test_sha256/start_proc
add wave -noupdate /test_sha256/finished
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/a
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/b
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/c
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/d
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/e
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/f
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/g
add wave -noupdate -expand -group work_variables -radix hexadecimal /test_sha256/uut/h
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h0
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h1
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h2
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h3
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h4
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h5
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h6
add wave -noupdate -expand -group final_hashes -radix hexadecimal /test_sha256/uut/h7
add wave -noupdate -radix hexadecimal /test_sha256/uut/state
add wave -noupdate -radix decimal /test_sha256/uut/i
add wave -noupdate -radix decimal /test_sha256/uut/id1
add wave -noupdate -radix decimal /test_sha256/uut/id2
add wave -noupdate -radix decimal /test_sha256/uut/j
add wave -noupdate -radix hexadecimal /test_sha256/uut/k
add wave -noupdate -childformat {{/test_sha256/uut/W(0) -radix hexadecimal} {/test_sha256/uut/W(1) -radix hexadecimal} {/test_sha256/uut/W(2) -radix hexadecimal} {/test_sha256/uut/W(3) -radix hexadecimal} {/test_sha256/uut/W(4) -radix hexadecimal} {/test_sha256/uut/W(5) -radix hexadecimal} {/test_sha256/uut/W(6) -radix hexadecimal} {/test_sha256/uut/W(7) -radix hexadecimal} {/test_sha256/uut/W(8) -radix hexadecimal} {/test_sha256/uut/W(9) -radix hexadecimal} {/test_sha256/uut/W(10) -radix hexadecimal} {/test_sha256/uut/W(11) -radix hexadecimal} {/test_sha256/uut/W(12) -radix hexadecimal} {/test_sha256/uut/W(13) -radix hexadecimal} {/test_sha256/uut/W(14) -radix hexadecimal} {/test_sha256/uut/W(15) -radix hexadecimal} {/test_sha256/uut/W(16) -radix hexadecimal} {/test_sha256/uut/W(17) -radix hexadecimal} {/test_sha256/uut/W(18) -radix hexadecimal} {/test_sha256/uut/W(19) -radix hexadecimal} {/test_sha256/uut/W(20) -radix hexadecimal} {/test_sha256/uut/W(21) -radix hexadecimal} {/test_sha256/uut/W(22) -radix hexadecimal} {/test_sha256/uut/W(23) -radix hexadecimal} {/test_sha256/uut/W(24) -radix hexadecimal} {/test_sha256/uut/W(25) -radix hexadecimal} {/test_sha256/uut/W(26) -radix hexadecimal} {/test_sha256/uut/W(27) -radix hexadecimal} {/test_sha256/uut/W(28) -radix hexadecimal} {/test_sha256/uut/W(29) -radix hexadecimal} {/test_sha256/uut/W(30) -radix hexadecimal} {/test_sha256/uut/W(31) -radix hexadecimal} {/test_sha256/uut/W(32) -radix hexadecimal} {/test_sha256/uut/W(33) -radix hexadecimal} {/test_sha256/uut/W(34) -radix hexadecimal} {/test_sha256/uut/W(35) -radix hexadecimal} {/test_sha256/uut/W(36) -radix hexadecimal} {/test_sha256/uut/W(37) -radix hexadecimal} {/test_sha256/uut/W(38) -radix hexadecimal} {/test_sha256/uut/W(39) -radix hexadecimal} {/test_sha256/uut/W(40) -radix hexadecimal} {/test_sha256/uut/W(41) -radix hexadecimal} {/test_sha256/uut/W(42) -radix hexadecimal} {/test_sha256/uut/W(43) -radix hexadecimal} {/test_sha256/uut/W(44) -radix hexadecimal} {/test_sha256/uut/W(45) -radix hexadecimal} {/test_sha256/uut/W(46) -radix hexadecimal} {/test_sha256/uut/W(47) -radix hexadecimal} {/test_sha256/uut/W(48) -radix hexadecimal} {/test_sha256/uut/W(49) -radix hexadecimal} {/test_sha256/uut/W(50) -radix hexadecimal} {/test_sha256/uut/W(51) -radix hexadecimal} {/test_sha256/uut/W(52) -radix hexadecimal} {/test_sha256/uut/W(53) -radix hexadecimal} {/test_sha256/uut/W(54) -radix hexadecimal} {/test_sha256/uut/W(55) -radix hexadecimal} {/test_sha256/uut/W(56) -radix hexadecimal} {/test_sha256/uut/W(57) -radix hexadecimal} {/test_sha256/uut/W(58) -radix hexadecimal} {/test_sha256/uut/W(59) -radix hexadecimal} {/test_sha256/uut/W(60) -radix hexadecimal} {/test_sha256/uut/W(61) -radix hexadecimal} {/test_sha256/uut/W(62) -radix hexadecimal} {/test_sha256/uut/W(63) -radix hexadecimal}} -expand -subitemconfig {/test_sha256/uut/W(0) {-height 15 -radix hexadecimal} /test_sha256/uut/W(1) {-height 15 -radix hexadecimal} /test_sha256/uut/W(2) {-height 15 -radix hexadecimal} /test_sha256/uut/W(3) {-height 15 -radix hexadecimal} /test_sha256/uut/W(4) {-height 15 -radix hexadecimal} /test_sha256/uut/W(5) {-height 15 -radix hexadecimal} /test_sha256/uut/W(6) {-height 15 -radix hexadecimal} /test_sha256/uut/W(7) {-height 15 -radix hexadecimal} /test_sha256/uut/W(8) {-height 15 -radix hexadecimal} /test_sha256/uut/W(9) {-height 15 -radix hexadecimal} /test_sha256/uut/W(10) {-height 15 -radix hexadecimal} /test_sha256/uut/W(11) {-height 15 -radix hexadecimal} /test_sha256/uut/W(12) {-height 15 -radix hexadecimal} /test_sha256/uut/W(13) {-height 15 -radix hexadecimal} /test_sha256/uut/W(14) {-height 15 -radix hexadecimal} /test_sha256/uut/W(15) {-height 15 -radix hexadecimal} /test_sha256/uut/W(16) {-height 15 -radix hexadecimal} /test_sha256/uut/W(17) {-height 15 -radix hexadecimal} /test_sha256/uut/W(18) {-height 15 -radix hexadecimal} /test_sha256/uut/W(19) {-height 15 -radix hexadecimal} /test_sha256/uut/W(20) {-height 15 -radix hexadecimal} /test_sha256/uut/W(21) {-height 15 -radix hexadecimal} /test_sha256/uut/W(22) {-height 15 -radix hexadecimal} /test_sha256/uut/W(23) {-height 15 -radix hexadecimal} /test_sha256/uut/W(24) {-height 15 -radix hexadecimal} /test_sha256/uut/W(25) {-height 15 -radix hexadecimal} /test_sha256/uut/W(26) {-height 15 -radix hexadecimal} /test_sha256/uut/W(27) {-height 15 -radix hexadecimal} /test_sha256/uut/W(28) {-height 15 -radix hexadecimal} /test_sha256/uut/W(29) {-height 15 -radix hexadecimal} /test_sha256/uut/W(30) {-height 15 -radix hexadecimal} /test_sha256/uut/W(31) {-height 15 -radix hexadecimal} /test_sha256/uut/W(32) {-height 15 -radix hexadecimal} /test_sha256/uut/W(33) {-height 15 -radix hexadecimal} /test_sha256/uut/W(34) {-height 15 -radix hexadecimal} /test_sha256/uut/W(35) {-height 15 -radix hexadecimal} /test_sha256/uut/W(36) {-height 15 -radix hexadecimal} /test_sha256/uut/W(37) {-height 15 -radix hexadecimal} /test_sha256/uut/W(38) {-height 15 -radix hexadecimal} /test_sha256/uut/W(39) {-height 15 -radix hexadecimal} /test_sha256/uut/W(40) {-height 15 -radix hexadecimal} /test_sha256/uut/W(41) {-height 15 -radix hexadecimal} /test_sha256/uut/W(42) {-height 15 -radix hexadecimal} /test_sha256/uut/W(43) {-height 15 -radix hexadecimal} /test_sha256/uut/W(44) {-height 15 -radix hexadecimal} /test_sha256/uut/W(45) {-height 15 -radix hexadecimal} /test_sha256/uut/W(46) {-height 15 -radix hexadecimal} /test_sha256/uut/W(47) {-height 15 -radix hexadecimal} /test_sha256/uut/W(48) {-height 15 -radix hexadecimal} /test_sha256/uut/W(49) {-height 15 -radix hexadecimal} /test_sha256/uut/W(50) {-height 15 -radix hexadecimal} /test_sha256/uut/W(51) {-height 15 -radix hexadecimal} /test_sha256/uut/W(52) {-height 15 -radix hexadecimal} /test_sha256/uut/W(53) {-height 15 -radix hexadecimal} /test_sha256/uut/W(54) {-height 15 -radix hexadecimal} /test_sha256/uut/W(55) {-height 15 -radix hexadecimal} /test_sha256/uut/W(56) {-height 15 -radix hexadecimal} /test_sha256/uut/W(57) {-height 15 -radix hexadecimal} /test_sha256/uut/W(58) {-height 15 -radix hexadecimal} /test_sha256/uut/W(59) {-height 15 -radix hexadecimal} /test_sha256/uut/W(60) {-height 15 -radix hexadecimal} /test_sha256/uut/W(61) {-height 15 -radix hexadecimal} /test_sha256/uut/W(62) {-height 15 -radix hexadecimal} /test_sha256/uut/W(63) {-height 15 -radix hexadecimal}} /test_sha256/uut/W
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {16596883 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {16562819 ps} {16630947 ps}
