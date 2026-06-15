mod letterbox;
mod matrix;

use crate::letterbox::*;
use crate::matrix::*;

use std::hint::black_box;

fn main() {
    let args: Vec<_> = std::env::args().collect();
    let max_threads: u16 = args[1].parse().unwrap();

    let mut letterbox = Letterbox::new(max_threads);

    for size in [500, 1000, 1500] {
        let x = Matrix::random(size, size);
        let y = Matrix::random(size, size);

        for _ in 0..250 {
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
