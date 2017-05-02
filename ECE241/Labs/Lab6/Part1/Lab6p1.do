vlib work

vlog Lab6p1.v

vsim Lab6p1

log {/*}
add wave {/*}

force {KEY[0]} 0 0ns, 1 {20ns} -r 40ns

force {SW[0]} 0
force {SW[1]} 1
run 100ns

#this is 11111
force {SW[0]} 1
force {SW[1]} 1
run 200ns

# this is 1101
force {SW[0]} 1
force {SW[1]} 1
run 80ns
force {SW[0]} 1
force {SW[1]} 0
run 40ns
force {SW[0]} 1
force {SW[1]} 1
run 40ns