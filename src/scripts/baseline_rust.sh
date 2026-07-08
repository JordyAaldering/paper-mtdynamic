#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_rust.out

cargo build --release --example matmul

echo "size,threads,runtime,energy" > res/baseline_rust.csv

for size in 500 1000 1500; do
    for threads in $(seq 1 16); do
        echo "Running with $threads threads"

        RAYON_NUM_THREADS=$threads taskset -c 0-$(($threads-1)) ./target/release/examples/matmul $size \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_rust.csv
    done
done
