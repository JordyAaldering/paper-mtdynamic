#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_matmul.out

make bin/matmul

mkdir -p ../results/cn125

echo "size,threads,runtime,energy" > ../results/cn125/matmul.csv

for size in 500 1000 1500; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./bin/matmul $size >> ../results/cn125/matmul.csv
    done
done
