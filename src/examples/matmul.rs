#[path = "util/util.rs"]
mod util;
use util::*;

use std::{hint::black_box, time::Instant};

use rapl_energy::{EnergyProbe, Rapl};

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let size: usize = args[1].parse().unwrap();
    let max_threads: usize = args[2].parse().unwrap();

    let mut rapl = Rapl::now(false).unwrap();
    let pool = threadpool(max_threads);

    for _ in 0..250 {
        let x = black_box(Matrix::random(size, size));
        let y = black_box(Matrix::random(size, size));

        rapl.reset();
        let instant = Instant::now();

        black_box(pool.install(|| x.mul(&y)));

        let runtime = instant.elapsed();
        let energy = rapl.elapsed();
        println!("{},{}", runtime.as_secs_f32(), energy.values().sum::<f32>());
    }
}
