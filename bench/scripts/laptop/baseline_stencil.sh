#!/bin/sh

make bin/stencil

mkdir -p res/laptop

echo "size,threads,runtime,energy" > res/laptop/stencil.csv

for size in 10000 25000 40000; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./bin/stencil $size >> res/laptop/stencil.csv
    done
done
