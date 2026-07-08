#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=baseline_matmul.out

# Original: https://github.com/JordyAaldering/paper-mtdynamic/blob/3360d7280d371aae0f2d5991da932a3ec7911ca9/src/scripts/threads_matmul.sh

CPU_STRING="0,8,1,9,2,10,3,11,4,12,5,13,6,14,7,15"

echo "size,threads,runtime,energy" > res/baseline_matmul.csv

for size in 500 1000 1500; do
    sac2c -t mt_pth scripts/matmul.sac -o matmul -DP=$size

    for threads in $(seq 1 16); do
        cpus=$(echo "$CPU_STRING" | tr ',' '\n' | head -n "$threads" | paste -sd,)
        echo "Running with $threads threads on cores: $cpus"

        ./matmul -mt_bind env -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 -mt $threads \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/baseline_matmul.csv
    done
done
