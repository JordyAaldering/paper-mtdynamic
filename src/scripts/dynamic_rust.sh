#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=$device
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_rust.out

if [ "$#" -ne 2 ]; then
    printf "Usage: %s <device> <idle>\n" "$0" >&2
    exit 1
fi

device=$1
idle=$2

make bin/ecodynamic
cargo build --release --bin dynamic

mkdir -p res/$device

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/$device/delta_rust.csv
./bin/ecodynamic --once -w $idle delta --energy-preference 1 &
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> res/$device/delta_rust.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/$device/corridor_rust.csv
./bin/ecodynamic --once -w $idle corridor --energy-preference 0 &
RAYON_NUM_THREADS=16 taskset -c 0-15 ./target/release/dynamic 500 1000 1500 >> res/$device/corridor_rust.csv
