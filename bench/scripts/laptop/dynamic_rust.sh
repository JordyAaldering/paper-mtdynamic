#!/bin/sh

make bin/ecodynamic
cargo build --release --bin dynamic

mkdir -p res/laptop

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/laptop/delta_rust.csv
./bin/ecodynamic --once -w 3.08 delta
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> res/laptop/delta_rust.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/laptop/corridor_rust.csv
./bin/ecodynamic --once -w 3.08 corridor
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> res/laptop/corridor_rust.csv
