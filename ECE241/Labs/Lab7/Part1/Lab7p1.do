vlib work

vlog Lab7p1.v

vsim Lab7p1

log {/*}
add wave {/*}

force {KEY[0]} 0 0ns, 1 10ns -r 20ns

force {SW[8:4]} 5'b00000
force {SW[3:0]} 4'b0101
force {SW[9]} 0
run 40ns

force {SW[8:4]} 5'b00000
force {SW[3:0]} 4'b0001
force {SW[9]} 1
run 40ns
