#!/bin/sh

make bin/stencil_mtd

mkdir -p res/laptop

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/laptop/delta_stencil.csv
./bin/ecodynamic --once -w 3.08 delta
SAC_PARALLEL=16 taskset -c 0-15 ./bin/stencil_mtd 10000 25000 40000 >> res/laptop/delta_stencil.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/laptop/corridor_stencil.csv
./bin/ecodynamic --once -w 3.08 corridor
SAC_PARALLEL=16 taskset -c 0-15 ./bin/stencil_mtd 10000 25000 40000 >> res/laptop/corridor_stencil.csv
