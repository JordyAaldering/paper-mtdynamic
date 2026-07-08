#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=threads_matmul.out

echo "size,threads,runtime,energy" > res/baseline_matmul.csv

for size in 500 1000 1500; do
    sac2c -t mt_pth scripts/matmul.sac -o matmul -DP=$size

    for threads in `seq 1 16`; do
        ./matmul -mt_bind env -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 -mt $threads \
            | awk -v size=$size awk -v threads=$threads '{
                printf "%f,%f,%s\n", size, threads, $0;
            }' >> res/baseline_matmul.csv
    done
done
