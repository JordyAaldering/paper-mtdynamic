#!/bin/sh

make bin/ecodynamic
cargo build --release --bin overhead

mkdir -p res/laptop

echo "runtime,energy" > res/laptop/overhead.csv

./bin/ecodynamic --once -w 2.4 delta --energy-preference 1
./target/release/overhead >> res/laptop/overhead.csv
