#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_nbody.out

make bin/ecodynamic
make bin/nbody_mtd

mkdir -p res/cn125

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/cn125/delta_nbody.csv
./bin/ecodynamic --once -w 3.08 delta
SAC_PARALLEL=16 taskset -c 0-15 ./bin/nbody_mtd 10000 25000 40000 >> res/cn125/delta_nbody.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/cn125/corridor_nbody.csv
./bin/ecodynamic --once -w 3.08 corridor
SAC_PARALLEL=16 taskset -c 0-15 ./bin/nbody_mtd 10000 25000 40000 >> res/cn125/corridor_nbody.csv
