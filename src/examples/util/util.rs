use rand::Rng;
use rayon::prelude::*;

pub struct Matrix {
    rows: usize,
    cols: usize,
    data: Vec<Vec<f64>>,
}

impl Matrix {
    pub fn new(data: Vec<Vec<f64>>) -> Self {
        Self { rows: data.len(), cols: data[0].len(), data }
    }

    pub fn random(x: usize, y: usize) -> Self {
        let mut rng = rand::thread_rng();
        let data = (0..y).map(|_| {
            let mut row = vec![0.0; x];
            rng.fill(row.as_mut_slice());
            row
        }).collect();
        Self::new(data)
    }

    pub fn mul(&self, other: &Matrix) -> Matrix {
        let mut res = vec![vec![0.0; other.cols]; self.rows];

        res.par_iter_mut().enumerate().for_each(|(row_a, data)| {
            for col_b in 0..other.cols {
                for i in 0..self.cols {
                    data[col_b] += self.data[row_a][i] * other.data[i][col_b];
                }
            }
        });

        Matrix::new(res)
    }
}

pub fn threadpool(num_threads: usize) -> rayon::ThreadPool {
    let cores = core_affinity::get_core_ids().unwrap();
    rayon::ThreadPoolBuilder::new()
        .num_threads(num_threads)
        .start_handler(move |idx| {
            assert!(core_affinity::set_for_current(cores[idx]));
        })
        .build()
        .unwrap()
}

#[allow(unused)]
pub fn stddev(xs: &Vec<f32>) -> f32 {
    let n = xs.len() as f32;
    let mean = xs.iter().sum::<f32>() / n;
    let variance = xs.iter().map(|x| (x - mean).powi(2)).sum::<f32>() / n;
    variance.sqrt()
}
