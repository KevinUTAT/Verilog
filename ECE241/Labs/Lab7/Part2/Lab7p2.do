vlib work
vlib altera_mf_ver
vlib lpm_ver

vmap altera_mf_ver work
vmap lpm_ver work

vlog Lab7p2.v

vsim -L altera_mf_ver lpm_ver Lab7p2

log {/*}
add wave {/*}


force {CLOCK_50} 0 0ns, 1 10ns -r 20ns

force {KEY[3]} 0 0ns, 1 30ns -r 60ns
force {KEY[0]} 0 0ns, 1 40ns -r 80ns

force {SW[6:0]} 7'd2;
force {SW[9:7]} 3'b111;
run 800ns


