#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_nbody.out

echo "size,threads,runtime,energy" > res/baseline_nbody.csv

for size in 10000 25000 40000; do
    make bin/nbody_$size

    for threads in $(seq 16); do
        cpus=$(seq 0 $(($threads-1)) | awk -v n="$ncores" 'NR>1 {printf ","} {printf "%d", int($1/2)+($1%2)*n}')

        SAC_PARALLEL=$threads taskset -c $cpus ./bin/nbody_$size \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_nbody.csv
    done
done
