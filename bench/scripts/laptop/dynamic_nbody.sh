#!/bin/sh

make bin/nbody_mtd

mkdir -p ../results/laptop

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > ../results/laptop/delta_nbody.csv
./bin/ecodynamic --once -w 3.08 delta
SAC_PARALLEL=16 taskset -c 0-15 ./bin/nbody_mtd 10000 25000 40000 >> ../results/laptop/delta_nbody.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > ../results/laptop/corridor_nbody.csv
./bin/ecodynamic --once -w 3.08 corridor
SAC_PARALLEL=16 taskset -c 0-15 ./bin/nbody_mtd 10000 25000 40000 >> ../results/laptop/corridor_nbody.csv
