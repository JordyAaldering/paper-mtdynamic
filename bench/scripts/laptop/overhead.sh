#!/bin/sh

cargo build --release --bin overhead

mkdir -p res/laptop

echo "runtime,energy" > res/laptop/overhead.csv

./target/release/overhead >> res/laptop/overhead.csv
