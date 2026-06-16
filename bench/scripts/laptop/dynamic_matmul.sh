#!/bin/sh

make bin/ecodynamic
make bin/matmul_mtd

mkdir -p res/laptop

# TODO, for this and the other SaC cases:
# Running three separate instances is not sufficient, as the controller
# distinguishes between these seperate runs.
# Instead, a variant of matmul.sac should be made that sneakily adjusts
# input size, hidden from the controller.

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/laptop/delta_matmul.csv
./bin/ecodynamic --once -w 2.4 delta --energy-preference 1
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd 500 1000 1500 >> res/laptop/delta_matmul.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/laptop/corridor_matmul.csv
./bin/ecodynamic --once -w 2.4 corridor --energy-preference 0
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd 500 1000 1500 >> res/laptop/corridor_matmul.csv
