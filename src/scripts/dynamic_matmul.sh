#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_matmul.out

if [ "$#" -ne 2 ]; then
    printf "Usage: %s <device> <idle>\n" "$0" >&2
    exit 1
fi

device=$1
idle=$2

make bin/ecodynamic
make bin/matmul_mtd

mkdir -p res/$device

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/$device/delta_matmul.csv
./bin/ecodynamic --once -w $idle delta --energy-preference 1 &
SAC_PARALLEL=16 ./bin/matmul_mtd 500 1000 1500 -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 >> res/$device/delta_matmul.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/$device/corridor_matmul.csv
./bin/ecodynamic --once -w $idle corridor --energy-preference 0 &
SAC_PARALLEL=16 ./bin/matmul_mtd 500 1000 1500 -DSAC_NUM_SOCKETS=1 -DSAC_NUM_CORES=8 -DSAC_NUM_PUS=16 >> res/$device/corridor_matmul.csv
