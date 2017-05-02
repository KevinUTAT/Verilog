vlib work

vlog Labp2.v

vsim Labp2

log {/*}
add wave {/*}

force {KEY[0]} 0 0ns, 1{7ns} -r 14ns
run 1400ns

force {KEY[1]} 0 0ns, 1{5ns} -r 10ns
run 1400ns

force {KEY[2]} 0 0ns, 1{10ns} -r 20ns
run 1400ns

force {KEY[3]} 0 0ns, 1{20ns} -r 40ns
run 1400ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
run 200ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
run 200ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0
run 200ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
run 200ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
run 200ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
run 200ns

force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 1
run 200ns