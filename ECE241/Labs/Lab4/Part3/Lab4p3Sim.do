vlib work

vlog Lab4p3.v

vsim Lab4p3

log {/*}
add wave {/*}

force {KEY[0]} 0 0ns, 1{70ns} -r 140ns
run 1400ns

force {KEY[1]} 0 0ns, 1{200ns} -r 400ns
run 1400ns

force {KEY[2]} 0 0ns, 1{100ns} -r 200ns
run 1400ns

force {KEY[3]} 0 0ns, 1{700ns} -r 200ns
run 1400ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1
run 350ns

force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
run 350ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
run 350ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
run 350ns