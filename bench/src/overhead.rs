mod letterbox;

use crate::letterbox::*;

use std::time::Instant;

use rapl_energy::Rapl;

const CYCLES: usize = 1_000_000;

fn test(letterbox: &mut Letterbox) {
    for _ in 0..CYCLES {
        let _demand = letterbox.start_signal();
        let instant = start_measurements();
        /* Do nothing; directly send the stop signal. */
        let sample = stop_measurements(instant);
        letterbox.end_signal(&sample);
    }
}

fn main() {
    let mut letterbox = Letterbox::new(16);

    let mut rapl = Rapl::new(false).unwrap();

    // Warmup runs
    for _ in 0..10 {
        test(&mut letterbox);
    }

    for _ in 0..100 {
        rapl.reset();
        let instant = Instant::now();

        test(&mut letterbox);

        let runtime = instant.elapsed();
        let energy = rapl.elapsed();
        let runtime = runtime.as_secs_f64();
        let energy = energy.values().map(f32::to_string).collect::<Vec<_>>().join(",");
        println!("{},{}", runtime, energy);
    }
}
