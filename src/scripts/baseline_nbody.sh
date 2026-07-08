#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=threads_nbody.out

echo "size,threads,runtime,energy" > res/baseline_nbody.csv

for size in 10000 25000 40000; do
    sac2c -t mt_pth scripts/nbody.sac -o nbody -DP=$size

    for threads in `seq 1 16`; do
        numactl --interleave all ./nbody -mt $threads \
            | awk -v size=$size awk -v threads=$threads '{
                printf "%f,%f,%s\n", size, threads, $0;
            }' >> res/baseline_nbody.csv
    done
done
