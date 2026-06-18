#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=$device
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_nbody.out

if [ "$#" -ne 1 ]; then
    printf "Usage: %s <device>\n" "$0" >&2
    exit 1
fi

device=$1

make bin/nbody

mkdir -p res/$device

echo "size,threads,runtime,energy" > res/$device/nbody.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads ./bin/nbody $size -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 >> res/$device/nbody.csv
    done
done
