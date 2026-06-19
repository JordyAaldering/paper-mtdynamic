#![allow(unused)]
use epy::prelude::*;
use serde::Deserialize;
use std::{collections::HashSet, fmt};

#[derive(Clone, Deserialize)]
pub struct Record {
    pub size: usize,
    pub threads: f64,
    pub runtime: f64,
    pub energy: f64,
}

#[derive(Clone, Copy)]
pub enum Benchmark {
    Nbody,
    Stencil,
    Matmul,
    Rust,
}

impl fmt::Display for Benchmark {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use Benchmark::*;
        match self {
            Nbody => write!(f, "nbody"),
            Stencil => write!(f, "stencil"),
            Matmul => write!(f, "matmul"),
            Rust => write!(f, "rust"),
        }
    }
}

impl fmt::Debug for Benchmark {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use Benchmark::*;
        match self {
            Nbody => write!(f, "N-body simulation"),
            Stencil => write!(f, "Nine-point stencil"),
            Matmul => write!(f, "Matrix multiplication"),
            Rust => write!(f, "Rust implementation"),
        }
    }
}

pub fn unique_sizes(df: &DataFrame<Record>) -> Vec<usize> {
    let mut t = df.rows()
        .iter()
        .map(|r| r.size)
        .collect::<HashSet<_>>()
        .into_iter()
        .collect::<Vec<_>>();
    t.sort_unstable();
    t
}

pub fn remove_legend(ax: &mut Axis) {
    ax.data.retain(|e| !matches!(e, AxisElement::LegendEntry(_)));
}
