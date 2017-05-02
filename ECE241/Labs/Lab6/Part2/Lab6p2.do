vlib work

vlog Lab6p2.v

vsim Lab6p2

log {/*}
add wave {/*}


force {CLOCK_50} 0 0ns, 1 10ns -r 20ns

force {SW[7:0]} 8'd1;
force {KEY[1:0]} 2'b10
run 40ns

force {SW[7:0]} 8'd2;
force {KEY[1:0]} 2'b10
run 40ns

force {SW[7:0]} 8'd3;
force {KEY[1:0]} 2'b10
run 40ns

force {SW[7:0]} 8'd4;
force {KEY[1:0]} 2'b10
run 40ns

force {SW[7:0]} 8'd5;
force {KEY[1:0]} 2'b10
run 40ns
