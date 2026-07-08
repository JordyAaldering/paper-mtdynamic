#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_rust.out

CPU_STRING="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"

cargo build --release --example matmul

echo "size,threads,runtime,energy" > res/baseline_rust.csv

for size in 500 1000 1500; do
    for threads in $(seq 1 16); do
        cpus=$(echo "$CPU_STRING" | tr ',' '\n' | head -n "$threads" | paste -sd,)
        echo "Running with $threads threads on cores: $cpus"

        RAYON_NUM_THREADS=$threads taskset -c 0-$(($threads-1)) ./target/release/examples/matmul $size \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_rust.csv
    done
done
