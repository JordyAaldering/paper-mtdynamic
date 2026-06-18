#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=$device
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_matmul.out

if [ "$#" -ne 2 ]; then
    printf "Usage: %s <device> <max threads>\n" "$0" >&2
    exit 1
fi

device=$1
max_threads=$2

make bin/matmul

mkdir -p res/$device

echo "size,threads,runtime,energy" > res/$device/matmul.csv

for size in 500 1000 1500; do
    for threads in $(seq 1 $max_threads); do
        SAC_PARALLEL=$threads ./bin/matmul $size >> res/$device/matmul.csv
    done
done
