vlib work

vlog I2C.v

vsim I2C

log {/*}
add wave {/*}

force {CLOCK_50} 0 0ns, 1 20ns -r 40ns
force {KEY[0]} 1 
#force {GPIO_0[34]} 0 154000ns, 1 155000ns
force {KEY[1]} 0 500000ns, 1 900000ns 
run 50000000ns