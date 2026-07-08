#[path = "util/util.rs"]
mod util;
use util::*;
use mtdynamic::Mtd;
use rapl_energy::Rapl;
use std::{hint::black_box, time::Instant};

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let max_threads: usize = args[1].parse().unwrap();

    let mut mtd = Mtd::energy_controller(max_threads, 10);
    let mut rapl = Rapl::new(false).unwrap();

    for size in [500, 1000, 1500] {
        let x = Matrix::random(size, size);
        let y = Matrix::random(size, size);

        for _ in 0..250 {
            let num_threads = mtd.num_threads() as usize;
            let pool = threadpool(num_threads);

            rapl.reset();
            let instant = Instant::now();

            mtd.install(|| pool.install(|| black_box(x.mul(&y))));

            let runtime = instant.elapsed();
            let energy = rapl.elapsed();
            println!("{},{},{},{}", size, mtd.num_threads,
                runtime.as_secs_f32(), energy.values().sum::<f32>());
        }
    }
}
