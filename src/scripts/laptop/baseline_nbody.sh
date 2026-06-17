#!/bin/sh

make bin/nbody

mkdir -p res/laptop

echo "size,threads,runtime,energy" > res/laptop/nbody.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./bin/nbody $size >> res/laptop/nbody.csv
    done
done
