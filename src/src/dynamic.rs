mod letterbox;
mod matrix;

use crate::letterbox::*;
use crate::matrix::*;

use std::{env, hint::black_box};

const ITER: usize = 250;

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let n1: usize = args[1].parse().unwrap();
    let n2: usize = args[2].parse().unwrap();
    let n3: usize = args[3].parse().unwrap();
    let max_threads: u16 = env::var("RAYON_NUM_THREADS").unwrap().parse().unwrap();

    let mut letterbox = Letterbox::new(max_threads);

    for size in [n1, n2, n3] {
        let x = Matrix::random(size, size);
        let y = Matrix::random(size, size);

        for _ in 0..ITER {
            let demand = letterbox.start_signal();
            let threads = demand.num_threads as usize;
            let pool = threadpool(threads);

            let instant = start_measurements();

            let _ = pool.install(|| black_box(x.mul(&y)));

            let sample = stop_measurements(instant);
            letterbox.end_signal(&sample);

            println!("{},{},{},{}", size, threads, sample.runtime, sample.energy);
        }
    }
}
