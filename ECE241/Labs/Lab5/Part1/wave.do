
vlib work


vlog Lab5p1.v


vsim Lab5p1


log {/*}

add wave {/*}


force {KEY[0]} 0 0ns , 1 {5ns}  -r 10ns 

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
run 50ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
run 50ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
run 50ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
run 50ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
run 50ns