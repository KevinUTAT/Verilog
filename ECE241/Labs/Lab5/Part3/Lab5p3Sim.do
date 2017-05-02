vlib work

vlog Lab5p3.v

vsim Lab5p3

log {/*}
add wave {/*}

force {KEY[1]} 0 0ns, 1 {5ns} -r 10ns

force {CLOCK_50} 0 0ns, 1 {10ns} -r 20ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
run 200ns