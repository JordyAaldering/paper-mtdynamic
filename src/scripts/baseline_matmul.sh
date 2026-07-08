#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_matmul.out

echo "size,threads,runtime,energy" > res/baseline_matmul.csv

for size in 500 1000 1500; do
    sac2c -t mt_pth scripts/matmul.sac -o matmul -DP=$size

    for threads in $(seq 1 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./matmul \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_matmul.csv
    done
done
