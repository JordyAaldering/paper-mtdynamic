#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_matmul.out

if [ "$#" -ne 1 ]; then
    printf "Usage: %s <device>\n" "$0" >&2
    exit 1
fi

device=$1

make bin/matmul

mkdir -p res/$device

echo "size,threads,runtime,energy" > res/$device/matmul.csv

for size in 500 1000 1500; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads ./bin/matmul $size -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 >> res/$device/matmul.csv
    done
done
