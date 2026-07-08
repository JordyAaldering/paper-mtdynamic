#[path = "util/util.rs"]
mod util;
use util::*;
use mtdynamic::Mtd;
use rapl_energy::Rapl;
use std::{hint::black_box, time::Instant};

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let size: usize = args[1].parse().unwrap();
    let max_threads: usize = args[2].parse().unwrap();
    let mode: char = args[3].chars().next().unwrap();

    let threads_str = match mode {
        'e' => "mt".to_string(),
        'r' => "rt".to_string(),
        _ => max_threads.to_string(),
    };

    let mut mtd = match mode {
        's' => Mtd::fixed_controller(max_threads),
        'e' => Mtd::energy_controller(max_threads, 10),
        'r' => Mtd::runtime_controller(max_threads),
        s => unreachable!("{}", s),
    };

    let mut rapl = Rapl::new(false).unwrap();

    let x = Matrix::random(size, size);
    let y = Matrix::random(size, size);

    for _ in 0..250 {
        let num_threads = mtd.num_threads() as usize;
            let pool = rayon::ThreadPoolBuilder::new()
                .num_threads(num_threads)
                .build()
                .unwrap();

        rapl.reset();
        let instant = Instant::now();

        let _ = mtd.install(|| pool.install(|| black_box(x.mul(&y))));

        let runtime = instant.elapsed();
        let energy = rapl.elapsed();
        println!("{},{},{},{}", threads_str, size,
            runtime.as_secs_f32(), energy.values().sum::<f32>());
    }
}
