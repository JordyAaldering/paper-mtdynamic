#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=$device
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_rust.out

if [ "$#" -ne 2 ]; then
    printf "Usage: %s <device> <max threads>\n" "$0" >&2
    exit 1
fi

device=$1
max_threads=$2

cargo build --release --bin baseline

mkdir -p res/$device

echo "size,threads,runtime,energy" > res/$device/rust.csv

for size in 500 1000 1500; do
    for threads in $(seq 1 $max_threads); do
        RAYON_NUM_THREADS=$threads taskset -c 0-$(($threads-1)) ./target/release/baseline $size >> res/$device/rust.csv
    done
done
