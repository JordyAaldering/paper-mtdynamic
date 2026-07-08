#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn128
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_stencil.out

echo "size,threads,runtime,energy" > res/adapt_stencil.csv

# Static approaches
for size in 10000 25000 40000; do
    sac2c -t mt_pth scripts/stencil.sac -o stencil -DP=$size

    for threads in 1 8 12 14 16; do
        numactl --interleave all ./stencil -mt $threads \
            | awk -v size=$size -v threads=$threads '{
                printf "%d,%d,%s\n", size, threads, $0;
            }' >> res/adapt_stencil.csv
    done
done

# Energy-based approach
for size in 10000 25000 40000; do
    sac2c -t mt_pth_rt scripts/stencil.sac -o stencil -DP=$size

    numactl --interleave all ./stencil -mt 16 \
        | awk -v size=$size '{
            printf "%d,mt,%s\n", size, $0;
        }' >> res/adapt_stencil.csv
done

# Runtime-based approach
for size in 10000 25000 40000; do
    sac2c -t mt_pth_rt -domtdrt scripts/stencil.sac -o stencil -DP=$size

    numactl --interleave all ./stencil -mt 16 \
        | awk -v size=$size '{
            printf "%d,rt,%s\n", size, $0;
        }' >> res/adapt_stencil.csv
done
