onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_main/clk_i
add wave -noupdate /test_main/rst_ni
add wave -noupdate /test_main/TXD_i
add wave -noupdate /test_main/RXD_o
add wave -noupdate /test_main/led_dbg
add wave -noupdate /test_main/uart_wvld
add wave -noupdate /test_main/uart_wdata
add wave -noupdate /test_main/uTXD
add wave -noupdate /test_main/urdy
add wave -noupdate /test_main/urvld
add wave -noupdate /test_main/urdata
add wave -noupdate /test_main/dbld
add wave -noupdate /test_main/clk_50MHz
add wave -noupdate /test_main/Arr_wData
add wave -noupdate /test_main/small_a
add wave -noupdate /test_main/clk_i
add wave -noupdate /test_main/rst_ni
add wave -noupdate /test_main/TXD_i
add wave -noupdate /test_main/RXD_o
add wave -noupdate /test_main/led_dbg
add wave -noupdate /test_main/uart_wvld
add wave -noupdate /test_main/uart_wdata
add wave -noupdate /test_main/uTXD
add wave -noupdate /test_main/urdy
add wave -noupdate /test_main/urvld
add wave -noupdate /test_main/urdata
add wave -noupdate /test_main/dbld
add wave -noupdate /test_main/clk_50MHz
add wave -noupdate /test_main/Arr_wData
add wave -noupdate /test_main/small_a
add wave -noupdate /test_main/clk_i
add wave -noupdate /test_main/rst_ni
add wave -noupdate /test_main/TXD_i
add wave -noupdate /test_main/RXD_o
add wave -noupdate /test_main/led_dbg
add wave -noupdate /test_main/uart_wvld
add wave -noupdate /test_main/uart_wdata
add wave -noupdate /test_main/uTXD
add wave -noupdate /test_main/urdy
add wave -noupdate /test_main/urvld
add wave -noupdate /test_main/urdata
add wave -noupdate /test_main/dbld
add wave -noupdate /test_main/clk_50MHz
add wave -noupdate /test_main/Arr_wData
add wave -noupdate /test_main/small_a
add wave -noupdate -group TB /test_main/clk_i
add wave -noupdate -group TB /test_main/rst_ni
add wave -noupdate -group TB /test_main/led_dbg
add wave -noupdate -group TB /test_main/Arr_wData
add wave -noupdate -group TB /test_main/small_a
add wave -noupdate -group TB /test_main/TXD_i
add wave -noupdate -group TB /test_main/RXD_o
add wave -noupdate -group MAIN /test_main/uut/clk_i
add wave -noupdate -group MAIN /test_main/uut/rst_ni
add wave -noupdate -group MAIN /test_main/uut/RXD_o
add wave -noupdate -group MAIN /test_main/uut/TXD_i
add wave -noupdate -group MAIN /test_main/uut/led_dbg_o
add wave -noupdate -group MAIN /test_main/uut/state
add wave -noupdate -group MAIN /test_main/uut/clk_50MHz
add wave -noupdate -group MAIN /test_main/uut/rst_v
add wave -noupdate -group MAIN /test_main/uut/mem_byte_en
add wave -noupdate -group MAIN /test_main/uut/mem_wdata
add wave -noupdate -group MAIN /test_main/uut/mem_raddr
add wave -noupdate -group MAIN /test_main/uut/mem_waddr
add wave -noupdate -group MAIN /test_main/uut/mem_we
add wave -noupdate -group MAIN /test_main/uut/uart_wvld
add wave -noupdate -group MAIN /test_main/uut/uart_rvld
add wave -noupdate -group MAIN /test_main/uut/uart_rdy
add wave -noupdate -group MAIN /test_main/uut/uart_rdata
add wave -noupdate -group MAIN /test_main/uut/uart_wdata
add wave -noupdate -group MAIN /test_main/uut/vld_chunk
add wave -noupdate -group MAIN /test_main/uut/sha256_rdy
add wave -noupdate -group MAIN /test_main/uut/chunk_id
add wave -noupdate -group MAIN /test_main/uut/chunk_rdata
add wave -noupdate -group MAIN /test_main/uut/chunk_mem_addr
add wave -noupdate -group MAIN /test_main/uut/hash
add wave -noupdate -group MAIN /test_main/uut/chunk_cnt
add wave -noupdate -group MAIN /test_main/uut/wdata_arr
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/clk_i
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/rst_ni
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/TXD_o
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/RXD_i
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/wvld_i
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/rvld_o
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/rdy_o
add wave -noupdate -expand -group UART -radix hexadecimal /test_main/uut/uart_inst/data_i
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/data_o
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/dbg_led_o
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/RXD_db
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/state
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/counter
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/data_received
add wave -noupdate -expand -group UART -radix decimal /test_main/uut/uart_inst/data_to_send
add wave -noupdate -expand -group UART /test_main/uut/uart_inst/data_counter
add wave -noupdate -group MSG_PAD /test_main/uut/state
add wave -noupdate -group MSG_PAD /test_main/uut/clk_50MHz
add wave -noupdate -group MSG_PAD /test_main/uut/mem_byte_en
add wave -noupdate -group MSG_PAD -radix hexadecimal /test_main/uut/mem_wdata
add wave -noupdate -group MSG_PAD -radix decimal /test_main/uut/mem_waddr
add wave -noupdate -group MSG_PAD /test_main/uut/mem_we
add wave -noupdate -group MSG_PAD -radix hexadecimal /test_main/uut/msg_length
add wave -noupdate -group MSG_PAD /test_main/uut/chunk_cnt
add wave -noupdate -group MSG_PAD /test_main/uut/chunk_i
add wave -noupdate -group MSG_PAD -radix decimal /test_main/uut/last_waddr
add wave -noupdate -group MSG_PAD /test_main/uut/last_byte_cnt
add wave -noupdate -group MSG_PAD -radix hexadecimal /test_main/uut/wdata_arr
add wave -noupdate -group MSG_PAD -radix hexadecimal /test_main/uut/msg_len_packed
add wave -noupdate -group MSG_PAD /test_main/uut/padding_state
add wave -noupdate -group MSG_PAD /test_main/uut/low32_len
add wave -noupdate -expand -group MSG_OUT -radix hexadecimal /test_main/uut/final_hash
add wave -noupdate -expand -group MSG_OUT -radix hexadecimal -childformat {{/test_main/uut/final_hash_packed(0) -radix hexadecimal} {/test_main/uut/final_hash_packed(1) -radix hexadecimal} {/test_main/uut/final_hash_packed(2) -radix hexadecimal} {/test_main/uut/final_hash_packed(3) -radix hexadecimal} {/test_main/uut/final_hash_packed(4) -radix hexadecimal} {/test_main/uut/final_hash_packed(5) -radix hexadecimal} {/test_main/uut/final_hash_packed(6) -radix hexadecimal} {/test_main/uut/final_hash_packed(7) -radix hexadecimal} {/test_main/uut/final_hash_packed(8) -radix hexadecimal} {/test_main/uut/final_hash_packed(9) -radix hexadecimal} {/test_main/uut/final_hash_packed(10) -radix hexadecimal} {/test_main/uut/final_hash_packed(11) -radix hexadecimal} {/test_main/uut/final_hash_packed(12) -radix hexadecimal} {/test_main/uut/final_hash_packed(13) -radix hexadecimal} {/test_main/uut/final_hash_packed(14) -radix hexadecimal} {/test_main/uut/final_hash_packed(15) -radix hexadecimal} {/test_main/uut/final_hash_packed(16) -radix hexadecimal} {/test_main/uut/final_hash_packed(17) -radix hexadecimal} {/test_main/uut/final_hash_packed(18) -radix hexadecimal} {/test_main/uut/final_hash_packed(19) -radix hexadecimal} {/test_main/uut/final_hash_packed(20) -radix hexadecimal} {/test_main/uut/final_hash_packed(21) -radix hexadecimal} {/test_main/uut/final_hash_packed(22) -radix hexadecimal} {/test_main/uut/final_hash_packed(23) -radix hexadecimal} {/test_main/uut/final_hash_packed(24) -radix hexadecimal} {/test_main/uut/final_hash_packed(25) -radix hexadecimal} {/test_main/uut/final_hash_packed(26) -radix hexadecimal} {/test_main/uut/final_hash_packed(27) -radix hexadecimal} {/test_main/uut/final_hash_packed(28) -radix hexadecimal} {/test_main/uut/final_hash_packed(29) -radix hexadecimal} {/test_main/uut/final_hash_packed(30) -radix hexadecimal} {/test_main/uut/final_hash_packed(31) -radix hexadecimal}} -expand -subitemconfig {/test_main/uut/final_hash_packed(0) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(1) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(2) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(3) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(4) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(5) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(6) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(7) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(8) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(9) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(10) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(11) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(12) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(13) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(14) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(15) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(16) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(17) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(18) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(19) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(20) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(21) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(22) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(23) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(24) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(25) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(26) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(27) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(28) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(29) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(30) {-height 15 -radix hexadecimal} /test_main/uut/final_hash_packed(31) {-height 15 -radix hexadecimal}} /test_main/uut/final_hash_packed
add wave -noupdate -expand -group MSG_OUT /test_main/uut/uart_send_state
add wave -noupdate -expand -group MSG_OUT /test_main/uut/uart_i
add wave -noupdate /test_main/uut/uart_wvld
add wave -noupdate -radix hexadecimal -childformat {{/test_main/uut/uart_wdata(7) -radix hexadecimal} {/test_main/uut/uart_wdata(6) -radix hexadecimal} {/test_main/uut/uart_wdata(5) -radix hexadecimal} {/test_main/uut/uart_wdata(4) -radix hexadecimal} {/test_main/uut/uart_wdata(3) -radix hexadecimal} {/test_main/uut/uart_wdata(2) -radix hexadecimal} {/test_main/uut/uart_wdata(1) -radix hexadecimal} {/test_main/uut/uart_wdata(0) -radix hexadecimal}} -subitemconfig {/test_main/uut/uart_wdata(7) {-radix hexadecimal} /test_main/uut/uart_wdata(6) {-radix hexadecimal} /test_main/uut/uart_wdata(5) {-radix hexadecimal} /test_main/uut/uart_wdata(4) {-radix hexadecimal} /test_main/uut/uart_wdata(3) {-radix hexadecimal} /test_main/uut/uart_wdata(2) {-radix hexadecimal} /test_main/uut/uart_wdata(1) {-radix hexadecimal} /test_main/uut/uart_wdata(0) {-radix hexadecimal}} /test_main/uut/uart_wdata
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/clk_i
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/rst_ni
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/vld_chunk_i
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/rdy_o
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/chunk_id_i
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/mem_addr_o
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/mem_rdata_i
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/vld_hash_o
add wave -noupdate -group SHA256 -radix hexadecimal /test_main/uut/sha256_inst/hash_o
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/state
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/i
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/j
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/W
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/a
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/b
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/c
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/d
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/e
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/f
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/g
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h0
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h1
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h2
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h3
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h4
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h5
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h6
add wave -noupdate -group SHA256 /test_main/uut/sha256_inst/h7
add wave -noupdate -group sha256_state /test_main/uut/vld_chunk
add wave -noupdate -group sha256_state /test_main/uut/vld_hash
add wave -noupdate -group sha256_state /test_main/uut/sha256_rdy
add wave -noupdate -group sha256_state /test_main/uut/chunk_id
add wave -noupdate -group sha256_state /test_main/uut/chunk_rdata
add wave -noupdate -group sha256_state /test_main/uut/chunk_mem_addr
add wave -noupdate -group sha256_state /test_main/uut/hash
add wave -noupdate -group sha256_state /test_main/uut/msg_length
add wave -noupdate -group sha256_state /test_main/uut/chunk_cnt
add wave -noupdate -group sha256_state /test_main/uut/chunk_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6825606389 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 251
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
WaveRestoreZoom {6825592949 ps} {6825698125 ps}
