#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=overhead.out

cargo build --release --bin overhead

mkdir -p res/cn125

echo "runtime,energy" > res/cn125/overhead.csv

./target/release/overhead >> res/cn125/overhead.csv
