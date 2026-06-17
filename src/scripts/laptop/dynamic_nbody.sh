#!/bin/sh

make bin/ecodynamic
make bin/nbody_mtd

mkdir -p res/laptop

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/laptop/delta_nbody.csv
./bin/ecodynamic --once -w 2.4 delta --energy-preference 1
SAC_PARALLEL=16 taskset -c 0-15 ./bin/nbody_mtd 10000 25000 40000 >> res/laptop/delta_nbody.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/laptop/corridor_nbody.csv
./bin/ecodynamic --once -w 2.4 corridor --energy-preference 0
SAC_PARALLEL=16 taskset -c 0-15 ./bin/nbody_mtd 10000 25000 40000 >> res/laptop/corridor_nbody.csv
