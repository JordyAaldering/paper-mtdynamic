#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_matmul.out

echo "size,threads,runtime,energy" > res/adapt_matmul.csv

# Static approaches
for size in 500 1000 1500; do
    sac2c -t mt_pth scripts/matmul.sac -o matmul -DP=$size

    for threads in 1 8 12 14 16; do
        ./matmul -mt_bind env -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 -mt $threads \
            | awk -v size=$size -v threads=$threads '{
                printf "%f,%f,%s\n", size, threads, $0;
            }' >> res/adapt_matmul.csv
    done
done

# Energy-based approach
for size in 500 1000 1500; do
    sac2c -t mt_pth_rt scripts/matmul.sac -o matmul -DP=$size

    numactl --interleave all ./matmul -mt 16 \
        | awk -v size=$size '{
            printf "%f,mt,%s\n", size, $0;
        }' >> res/adapt_matmul.csv
done

# Runtime-based approach
for size in 500 1000 1500; do
    sac2c -t mt_pth_rt -domtdrt scripts/matmul.sac -o matmul -DP=$size

    numactl --interleave all ./matmul -mt 16 \
        | awk -v size=$size '{
            printf "%f,rt,%s\n", size, $0;
        }' >> res/adapt_matmul.csv
done
