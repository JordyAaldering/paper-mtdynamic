#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=$device
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=dynamic_nbody.out

if [ "$#" -ne 3 ]; then
    printf "Usage: %s <device> <threads> <idle>\n" "$0" >&2
    exit 1
fi

device=$1
threads=$2
idle=$3

make bin/ecodynamic
make bin/nbody_mtd

mkdir -p res/$device

# Energy-based (delta) approach
echo "size,threads,runtime,energy" > res/$device/delta_nbody.csv
./bin/ecodynamic --once -w $idle delta --energy-preference 1 &
SAC_PARALLEL=$threads ./bin/nbody_mtd 10000 25000 40000 >> res/$device/delta_nbody.csv

# Runtime-based (corridor) approach
echo "size,threads,runtime,energy" > res/$device/corridor_nbody.csv
./bin/ecodynamic --once -w $idle corridor --energy-preference 0 &
SAC_PARALLEL=$threads ./bin/nbody_mtd 10000 25000 40000 >> res/$device/corridor_nbody.csv
