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
        let data = (0..y).map(|_| {
            (0..x).map(|_| rand::random()).collect()
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
