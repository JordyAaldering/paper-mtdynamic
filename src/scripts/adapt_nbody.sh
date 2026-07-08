#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_nbody.out

CPU_STRING="0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15"

echo "size,threads,runtime,energy" > res/adapt_nbody.csv

# Static approaches
for size in 10000 25000 40000; do
    sac2c -t mt_pth scripts/nbody.sac -o nbody -DP=$size

    for threads in 1 8 12 14 16; do
        cpus=$(echo "$CPU_STRING" | tr ',' '\n' | head -n "$threads" | paste -sd,)
        SAC_PARALLEL=$threads taskset -c $cpus ./nbody \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/adapt_nbody.csv
    done
done

# Energy-based approach
for size in 10000 25000 40000; do
    sac2c -t mt_pth_rt scripts/nbody.sac -o nbody -DP=$size

    SAC_PARALLEL=16 taskset -c $CPU_STRING ./nbody \
        | awk -v size=$size '{
            printf "%d,mt,%s\n", size, $0;
        }' >> res/adapt_nbody.csv
done

# Runtime-based approach
for size in 10000 25000 40000; do
    sac2c -t mt_pth_rt -domtdrt scripts/nbody.sac -o nbody -DP=$size

    SAC_PARALLEL=16 taskset -c $CPU_STRING ./nbody \
        | awk -v size=$size '{
            printf "%d,rt,%s\n", size, $0;
        }' >> res/adapt_nbody.csv
done
