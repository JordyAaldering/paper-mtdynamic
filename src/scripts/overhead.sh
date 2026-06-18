#!/bin/sh

#SBATCH --account=csmpi
#SBATCH --partition=csmpi_long
#SBATCH --nodelist=cn125
#SBATCH --mem=0
#SBATCH --cpus-per-task=16
#SBATCH --time=10:00:00
#SBATCH --output=overhead.out

if [ "$#" -ne 2 ]; then
    printf "Usage: %s <device> <idle>\n" "$0" >&2
    exit 1
fi

device=$1
idle=$2

make bin/ecodynamic
cargo build --release --bin overhead

mkdir -p res/$device

echo "runtime,energy" > res/$device/overhead.csv

./bin/ecodynamic --once -w $idle delta --energy-preference 1 &
./target/release/overhead >> res/$device/overhead.csv
