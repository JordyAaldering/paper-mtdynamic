#![allow(unused)]
use epy::prelude::*;
use serde::Deserialize;
use std::{collections::HashSet, fmt};

#[derive(Clone, Deserialize)]
pub struct Record<T> {
    pub size: usize,
    pub threads: T,
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
        match self {
            Self::Nbody => write!(f, "nbody"),
            Self::Stencil => write!(f, "stencil"),
            Self::Matmul => write!(f, "matmul"),
            Self::Rust => write!(f, "rust"),
        }
    }
}

impl fmt::Debug for Benchmark {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Nbody => write!(f, "N-body simulation"),
            Self::Stencil => write!(f, "Nine-point stencil"),
            Self::Matmul => write!(f, "Matrix multiplication"),
            Self::Rust => write!(f, "Rust implementation"),
        }
    }
}

pub fn unique_sizes<T>(df: &DataFrame<Record<T>>) -> Vec<usize> {
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
