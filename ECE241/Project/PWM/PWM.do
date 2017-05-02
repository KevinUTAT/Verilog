vlib work

vlog PWM.v

vsim PWM

log {/*}
add wave {/*}
add wave -position end  sim:/PWM/control/current
add wave -position end  sim:/PWM/control/pulseWidth
add wave -position end  sim:/PWM/control/count


force {SW[7:0]} 8'd128
force {KEY[0]} 1 
force {CLOCK_50} 0 0ns, 1 20ns -r 40ns

run 85000000ns

force {KEY[1]} 1
run 1000000ns