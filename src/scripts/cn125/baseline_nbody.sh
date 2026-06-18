#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_nbody.out

make bin/nbody

mkdir -p res/cn125

echo "size,threads,runtime,energy" > res/cn125/nbody.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads ./bin/nbody $size >> res/cn125/nbody.csv
    done
done
