#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_stencil.out

make bin/stencil_mtd

mkdir -p ../results/cn125

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > ../results/cn125/delta_stencil.csv
./bin/ecodynamic --once -w 3.08 delta
SAC_PARALLEL=16 taskset -c 0-15 ./bin/stencil_mtd 10000 25000 40000 >> ../results/cn125/delta_stencil.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > ../results/cn125/corridor_stencil.csv
./bin/ecodynamic --once -w 3.08 corridor
SAC_PARALLEL=16 taskset -c 0-15 ./bin/stencil_mtd 10000 25000 40000 >> ../results/cn125/corridor_stencil.csv
