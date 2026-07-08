#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_nbody.out

make bin/nbody_mt

CPU_STRING="0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15"

echo "size,threads,runtime,energy" > res/baseline_nbody.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        cpus=$(echo "$CPU_STRING" | tr ',' '\n' | head -n "$threads" | paste -sd,)
        SAC_PARALLEL=$threads taskset -c $cpus ./bin/nbody_mt $size \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_nbody.csv
    done
done
