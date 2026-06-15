use std::{io::{BufRead, BufReader, Write}, os::unix::net::UnixStream, time::Instant};

use controller::*;
use rapl_energy::Rapl;

pub fn threadpool(threads: usize) -> rayon::ThreadPool {
    rayon::ThreadPoolBuilder::new()
        .num_threads(threads)
        .build()
        .unwrap()
}

pub fn start_measurements() -> (Instant, Rapl) {
    let rapl = Rapl::new(false).unwrap();
    let time = Instant::now();
    (time, rapl)
}

pub fn stop_measurements((time, rapl): (Instant, Rapl)) -> Sample {
    let runtime = time.elapsed();
    let energy = rapl.elapsed();
    Sample {
        region_uid: 0,
        runtime: runtime.as_secs_f32(),
        energy: energy.values().sum(),
        usertime: None,
    }
}

pub struct Letterbox {
    stream: UnixStream,
    reader: BufReader<UnixStream>,
}

impl Letterbox {
    pub fn new(max_threads: u16) -> Self {
        let stream = UnixStream::connect("/tmp/mtd_letterbox").unwrap();
        let reader = BufReader::new(stream.try_clone().unwrap());

        let mut letterbox = Self { stream, reader };
        letterbox.write(&Capabilities {
            min_threads: Some(1),
            max_threads: Some(max_threads),
            ..Default::default()
        });
        letterbox
    }

    pub fn start_signal(&mut self) -> Demand {
        self.write(&Request {
            region_uid: 0,
            problem_size: None,
        });
        self.read()
    }

    pub fn end_signal(&mut self, sample: &Sample) {
        self.write(sample);
    }

    fn write<T: serde::Serialize>(&mut self, message: &T) {
        serde_json::to_writer(&mut self.stream, message).unwrap();
        self.stream.write_all(b"\n").unwrap();
    }

    fn read<T: serde::de::DeserializeOwned>(&mut self, ) -> T {
        let mut line = String::new();
        assert_ne!(self.reader.read_line(&mut line).unwrap(), 0);
        serde_json::from_str(line.trim_end()).unwrap()
    }
}
