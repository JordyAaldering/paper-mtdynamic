#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn128
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=threads_nbody.out

printf "size,threads,runtime,runtimesd,energy,energysd\n"

for size in 10000 25000 40000; do
    ../sac2c/build_r/sac2c_p -t mt_pth scripts/nbody.sac -o nbody -DP=$size

    for threads in `seq 1 16`; do
        printf "$size,$threads,"
        numactl --interleave all ./nbody -mt $threads
    done
done

rm nbody
rm nbody.c
rm nbody.i
rm nbody.o
