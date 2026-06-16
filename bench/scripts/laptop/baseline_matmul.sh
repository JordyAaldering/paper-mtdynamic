#!/bin/sh

make bin/matmul

mkdir -p res/laptop

echo "size,threads,runtime,energy" > res/laptop/matmul.csv

for size in 500 1000 1500; do
    for threads in $(seq 16); do
        SAC_PARALLEL=$threads taskset -c 0-$(($threads-1)) ./bin/matmul $size >> res/laptop/matmul.csv
    done
done
