#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_stencil.out

make bin/ecodynamic
make bin/stencil_mtd

# Energy-based approach
{
    ./bin/ecodynamic --once -w 3.0 delta --energy-preference 1.0 &
    sleep 1  # Wait a bit for the server to start

    echo "size,threads,runtime,energy" > res/delta_stencil.csv
    SAC_PARALLEL=16 taskset -c 0-15 ./bin/stencil_mtd 10000 25000 40000 \
        >> res/delta_stencil.csv
}

# Runtime-based approach
{
    ./bin/ecodynamic --once -w 3.0 corridor --energy-preference 0.0 &
    sleep 1  # Wait a bit for the server to start

    echo "size,threads,runtime,energy" > res/corridor_stencil.csv
    SAC_PARALLEL=16 taskset -c 0-15 ./bin/stencil_mtd 10000 25000 40000 \
        >> res/corridor_stencil.csv
}
