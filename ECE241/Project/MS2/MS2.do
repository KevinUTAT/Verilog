vlib work

vlog MS2.v

vsim MS2

log {/*}
add wave {/*}
add wave -position 41  sim:/MS2/read/clkwidth
add wave -position end  sim:/MS2/read/count

force {KEY[0]} 1
force {CLOCK_50} 0 0ns, 1 20ns -r 40ns
force {GPIO_0[32]} 0 0ns, 1 18500000ns -r 20000000ns

run 800000000ns

