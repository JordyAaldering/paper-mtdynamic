#[path = "util/util.rs"]
mod util;
use util::*;
use rapl_energy::Rapl;
use std::{hint::black_box, time::Instant};

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let size: usize = args[1].parse().unwrap();
    let max_threads: usize = args[2].parse().unwrap();

    let mut rapl = Rapl::new(false).unwrap();
    let pool = threadpool(max_threads);

    let x = Matrix::random(size, size);
    let y = Matrix::random(size, size);

    for _ in 0..50 {
        rapl.reset();
        let instant = Instant::now();

        pool.install(|| black_box(x.mul(&y)));

        let runtime = instant.elapsed();
        let energy = rapl.elapsed();
        println!("{},{}", runtime.as_secs_f32(), energy.values().sum::<f32>());
    }
}
