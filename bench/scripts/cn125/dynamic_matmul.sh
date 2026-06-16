#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_matmul.out

make bin/ecodynamic
make bin/matmul_mtd

mkdir -p res/cn125

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/cn125/delta_matmul.csv
./bin/ecodynamic --once -w 3.08 delta --energy-preference 1
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd 500 1000 1500 >> res/cn125/delta_matmul.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/cn125/corridor_matmul.csv
./bin/ecodynamic --once -w 3.08 corridor --energy-preference 0
SAC_PARALLEL=16 taskset -c 0-15 ./bin/matmul_mtd 500 1000 1500 >> res/cn125/corridor_matmul.csv
