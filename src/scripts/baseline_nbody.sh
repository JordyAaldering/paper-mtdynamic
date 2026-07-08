#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn128
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_nbody.out

CPU_STRING="0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15"

echo "size,threads,runtime,energy" > res/baseline_nbody.csv

for size in 10000 25000 40000; do
    sac2c -t mt_pth scripts/nbody.sac -o nbody -DP=$size

    for threads in $(seq 1 16); do
        cpus=$(echo "$CPU_STRING" | tr ',' '\n' | head -n "$threads" | paste -sd,)
        echo "Running with $threads threads on cores: $cpus"

        numactl -C $cpus ./nbody -mt $threads \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_nbody.csv

        exit
    done
done
