# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog Lab5p2.v

#load simulation using mux as the top level simulation module
vsim Lab5p2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
#force -deposit /KEY[0] 1 0, 0 {10 ns} -repeat 20

force {CLOCK_50} 0 0ns , 1 10ns -r 20ns
run 2500ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
run 500ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
run 500ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
run 500ns

force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
run 500ns

force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
run 500ns