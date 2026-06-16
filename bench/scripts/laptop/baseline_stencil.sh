#!/bin/sh

make bin/stencil

mkdir -p ../results/laptop

echo "size,threads,runtime,energy" > ../results/laptop/stencil.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./bin/stencil $size >> ../results/laptop/stencil.csv
    done
done
