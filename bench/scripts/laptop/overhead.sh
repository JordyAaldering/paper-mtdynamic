#!/bin/sh

cargo build --release --bin overhead

mkdir -p ../results/laptop

echo "runtime,energy" > ../results/laptop/overhead.csv

./target/release/overhead >> ../results/laptop/overhead.csv
