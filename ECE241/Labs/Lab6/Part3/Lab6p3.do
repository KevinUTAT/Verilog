vlib work

vlog Lab6p3.v

vsim Lab6p3

log {/*}
add wave {/*}
add wave -position end  sim:/Lab6p3/control/current
add wave -position end  sim:/Lab6p3/control/next
add wave -position end  sim:/Lab6p3/term/counter

force {CLOCK_50} 0 0ns, 1 10ns -r 20ns

force {SW[7:4]} 4'd7
force {SW[3:0]} 4'd4
force {KEY[2:0]} 2'b10

run 20ns

force {KEY[2:0]} 2'b11
run 20ns

force {KEY[2:0]} 2'b01
run 20ns

force {KEY[2:0]} 2'b11
run 600ns