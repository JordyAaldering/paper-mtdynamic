#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_rust.out

make bin/ecodynamic
cargo build --release --bin dynamic

mkdir -p res/cn125

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/cn125/delta_rust.csv
./bin/ecodynamic --once -w 3.08 delta
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> res/cn125/delta_rust.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/cn125/corridor_rust.csv
./bin/ecodynamic --once -w 3.08 corridor
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> res/cn125/corridor_rust.csv
