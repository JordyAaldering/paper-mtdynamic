mod matrix;

use crate::matrix::*;

use std::{env, hint::black_box, time::Instant};

use rapl_energy::Rapl;

const ITER: usize = 30;

fn main() {
    let args: Vec<String> = env::args().collect();
    let size: usize = args[1].parse().unwrap();
    let threads = rayon::max_num_threads();

    let x = Matrix::random(size, size);
    let y = Matrix::random(size, size);

    // Warmup runs
    for _ in 0..3 {
        let _ = black_box(x.mul(&y));
    }

    let mut rapl = Rapl::new(false).unwrap();

    for _ in 0..ITER {
        rapl.reset();
        let instant = Instant::now();

        let _ = black_box(x.mul(&y));

        let runtime = instant.elapsed();
        let energy = rapl.elapsed();
        let runtime = runtime.as_secs_f64();
        let energy = energy.values().map(f32::to_string).collect::<Vec<_>>().join(",");
        println!("{},{},{},{}", size, threads, runtime, energy);
    }
}
