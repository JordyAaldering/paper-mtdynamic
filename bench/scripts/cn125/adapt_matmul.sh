#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_matmul.out

make bin/matmul_mtd

mkdir -p ../results/cn125

# TODO, for this and the other SaC cases:
# Running three separate instances is not sufficient, as the controller
# distinguishes between these seperate runs.
# Instead, a variant of matmul.sac should be made that sneakily adjusts
# input size, hidden from the controller.

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > ../results/cn125/delta_matmul.csv
./bin/ecodynamic --once -w 3.08 delta
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd >> ../results/cn125/delta_matmul.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > ../results/cn125/corridor_matmul.csv
./bin/ecodynamic --once -w 3.08 corridor
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd >> ../results/cn125/corridor_matmul.csv
