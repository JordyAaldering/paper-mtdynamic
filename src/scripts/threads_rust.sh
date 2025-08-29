#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn128
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=threads_rust.out

cargo build --release --example matmul

printf "size,threads,runtime,runtimesd,energy,energysd\n"

for size in 500 1000 1500; do
    for threads in `seq 1 16`; do
        printf "$size,$threads,"
        ./target/release/examples/matmul $size $threads
    done
done
