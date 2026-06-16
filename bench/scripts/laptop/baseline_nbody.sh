#!/bin/sh

make bin/nbody

mkdir -p ../results/laptop

echo "size,threads,runtime,energy" > ../results/laptop/nbody.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./bin/nbody $size >> ../results/laptop/nbody.csv
    done
done
