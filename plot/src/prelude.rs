#![allow(unused)]
use epy::prelude::*;
use serde::Deserialize;
use std::{collections::HashSet, fmt};

#[derive(Clone, Deserialize)]
pub struct Record {
    pub size: usize,
    pub threads: f64,
    runtime: f64,
    energy: f64,
}

impl Record {
    pub fn runtime(&self) -> f64 {
        self.runtime
    }

    /// Subtract cn125 idle
    pub fn energy(&self) -> f64 {
        self.energy - 3.08 * self.runtime
    }
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

pub fn filter_xticks(ax: &mut Axis) {
    ax.style.filter_xticks(|i| (i == 0) || ((i + 1) % 4 == 0));
}

pub fn remove_legend(ax: &mut Axis) {
    ax.data.retain(|e| !matches!(e, AxisElement::LegendEntry(_)));
}
