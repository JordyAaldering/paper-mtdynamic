#!/bin/sh

make bin/ecodynamic
make bin/stencil_mtd

mkdir -p res/laptop

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/laptop/delta_stencil.csv
./bin/ecodynamic --once -w 2.4 delta --energy-preference 1 &
SAC_PARALLEL=16 ./bin/stencil_mtd 10000 25000 40000 >> res/laptop/delta_stencil.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/laptop/corridor_stencil.csv
./bin/ecodynamic --once -w 2.4 corridor --energy-preference 0 &
SAC_PARALLEL=16 ./bin/stencil_mtd 10000 25000 40000 >> res/laptop/corridor_stencil.csv
