#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=threads_rust.out

cargo build --release --example matmul

echo "size,threads,runtime,energy" > res/baseline_rust.csv

for size in 500 1000 1500; do
    for threads in `seq 1 16`; do
        ./target/release/examples/matmul $size $threads \
            | awk -v size=$size awk -v threads=$threads '{
                printf "%f,%f,%s\n", size, threads, $0;
            }' >> res/baseline_rust.csv
    done
done
