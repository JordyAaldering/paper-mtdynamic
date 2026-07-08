#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn128
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_nbody.out

MAX_THREADS=16

# Build CPU ordering: evens first, then odds.
CPU_STRING=$(
    {
        for ((i=0; i<$MAX_THREADS; i+=2)); do echo "$i"; done
        for ((i=1; i<$MAX_THREADS; i+=2)); do echo "$i"; done
    } | paste -sd,
)

echo "size,threads,runtime,energy" > res/baseline_nbody.csv

for size in 10000 25000 40000; do
    sac2c -t mt_pth scripts/nbody.sac -o nbody -DP=$size

    for threads in $(seq 1 $MAX_THREADS); do
        cpus=$(echo "$CPU_STRING" | tr ',' '\n' | head -n "$threads" | paste -sd,)
        echo "Running with $threads threads on cores: $cpus"

        numactl -C $cpus ./nbody -mt $threads \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_nbody.csv
    done
done
