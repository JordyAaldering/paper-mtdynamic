#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=compare_rust.out

cargo build --release --example compare

printf "threads,size,pin,runtime,energy\n"

for size in 500 1000 1500; do
    taskset -c 0-15 ./target/release/examples/compare $size 1  s
    taskset -c 0-15 ./target/release/examples/compare $size 8  s
    taskset -c 0-15 ./target/release/examples/compare $size 12 s
    taskset -c 0-15 ./target/release/examples/compare $size 16 s
    taskset -c 0-15 ./target/release/examples/compare $size 16 e
    taskset -c 0-15 ./target/release/examples/compare $size 16 r
done
