#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_matmul.out

make bin/ecodynamic
make bin/matmul_mtd

# Energy-based approach
{
    ./bin/ecodynamic --once -w 3.0 delta --energy-preference 1.0 &
    sleep 1  # Wait a bit for the server to start

    echo "size,threads,runtime,energy" > res/delta_matmul.csv
    SAC_PARALLEL=16 numactl --interleave all ./bin/matmul_mtd 500 1000 1500 \
        >> res/delta_matmul.csv
}

# Runtime-based approach
{
    ./bin/ecodynamic --once -w 3.0 corridor --energy-preference 0.0 &
    sleep 1  # Wait a bit for the server to start

    echo "size,threads,runtime,energy" > res/corridor_matmul.csv
    SAC_PARALLEL=16 numactl --interleave all ./bin/matmul_mtd 500 1000 1500 \
        >> res/corridor_matmul.csv
}
