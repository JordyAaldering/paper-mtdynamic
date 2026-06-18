#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_stencil.out

make bin/stencil

mkdir -p res/cn125

echo "size,threads,runtime,energy" > res/cn125/stencil.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c $(seq -s, 0 2 $threads) ./bin/stencil $size >> res/cn125/stencil.csv
    done
done
