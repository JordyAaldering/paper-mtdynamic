#!/bin/sh

cargo build --release --bin baseline

mkdir -p res/laptop

echo "size,threads,runtime,energy" > res/laptop/rust.csv

for size in 500 1000 1500; do
    for threads in $(seq 16); do
        RAYON_NUM_THREADS=$threads taskset -c 0-$(($threads-1)) ./target/release/baseline $size >> res/laptop/rust.csv
    done
done
