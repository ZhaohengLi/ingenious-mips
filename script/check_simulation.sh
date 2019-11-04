#!/bin/bash

# check CPU simulation

grep "\[Done\]" ingenious-mips.sim/sim_1/behav/xsim/simulate > /dev/null

if [ $? -eq 0 ]; then
    echo "CPU simulation succeeded."
else
    echo "CPU simulation failed. Please check log for more information."
    exit 1
fi