#!/bin/bash
# Clean up
rm -rf obj_dir *.vcd

# Compile with Verilator
verilator -Wall --cc --trace \
    f1_top.sv f1_fsm.sv clktick.sv delay.sv lfsr_7.sv \
    --exe f1_tb.cpp

# Build executable
make -j -C obj_dir/ -f Vf1_top.mk Vf1_top

# Run simulation
./obj_dir/Vf1_top
