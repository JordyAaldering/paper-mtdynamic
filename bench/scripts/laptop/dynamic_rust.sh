#!/bin/sh

cargo build --release --bin dynamic

mkdir -p ../results/laptop

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > ../results/laptop/delta_rust.csv
./bin/ecodynamic --once -w 3.08 delta
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> ../results/laptop/delta_rust.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > ../results/laptop/corridor_rust.csv
./bin/ecodynamic --once -w 3.08 corridor
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> ../results/laptop/corridor_rust.csv
