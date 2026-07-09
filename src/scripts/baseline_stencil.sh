#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_stencil.out

echo "size,threads,runtime,energy" > res/baseline_stencil.csv

for size in 10000 25000 40000; do
    make bin/stencil_$size

    for threads in $(seq 16); do
        cpus=$(seq 0 $(($threads-1)) | awk -v n=8 '{printf "%s%d", NR>1?",":"", int($1/2) + ($1%2)*n}')

        SAC_PARALLEL=$threads taskset -c $cpus ./bin/stencil_$size \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_stencil.csv
    done
done
