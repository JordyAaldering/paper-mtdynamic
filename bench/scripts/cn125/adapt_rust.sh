#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_rust.out

cargo build --release --bin dynamic


mkdir -p ../results/cn125

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > ../results/cn125/delta_rust.csv
./bin/ecodynamic --once -w 3.08 delta
taskset -c 0-15 ./target/release/dynamic 16 >> ../results/cn125/delta_rust.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > ../results/cn125/corridor_rust.csv
./bin/ecodynamic --once -w 3.08 corridor
taskset -c 0-15 ./target/release/dynamic 16 >> ../results/cn125/corridor_rust.csv
