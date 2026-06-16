#!/bin/sh

make bin/matmul_mtd

mkdir -p ../results/laptop

# TODO, for this and the other SaC cases:
# Running three separate instances is not sufficient, as the controller
# distinguishes between these seperate runs.
# Instead, a variant of matmul.sac should be made that sneakily adjusts
# input size, hidden from the controller.

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > ../results/laptop/delta_matmul.csv
./bin/ecodynamic --once -w 3.08 delta
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd 500 1000 1500 >> ../results/laptop/delta_matmul.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > ../results/laptop/corridor_matmul.csv
./bin/ecodynamic --once -w 3.08 corridor
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd 500 1000 1500 >> ../results/laptop/corridor_matmul.csv
