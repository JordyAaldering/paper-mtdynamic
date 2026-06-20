#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=threads_stencil.out

printf "size,threads,runtime,runtimesd,energy,energysd\n"

for size in 10000 25000 40000; do
    sac2c -t mt_pth scripts/stencil.sac -o stencil -DP=$size

    for threads in `seq 1 16`; do
        printf "$size,$threads,"
        numactl --interleave all ./stencil -mt $threads
    done
done
