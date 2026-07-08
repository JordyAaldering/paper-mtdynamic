#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=adapt_rust.out

echo "size,threads,runtime,energy" > res/adapt_rust.sh

taskset -c 0-15 cargo run --release --example adapt 16 >> res/adapt_rust.sh
