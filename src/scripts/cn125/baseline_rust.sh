#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_rust.out

cargo build --release --bin baseline

mkdir -p ../res/cn125

echo "size,threads,runtime,energy" > ../res/cn125/rust.csv

for size in 500 1000 1500; do
    for threads in $(seq 16); do
        RAYON_NUM_THREADS=$threads taskset -c 0-$(($threads-1)) ./target/release/baseline $size >> ../res/cn125/rust.csv
    done
done
