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

    /// Subtract cn128 idle
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

pub fn filter_xticks(ax: &mut Axis) {
    ax.style.filter_xticks(|i| (i == 0) || ((i + 1) % 4 == 0));
}

pub fn remove_legend(ax: &mut Axis) {
    ax.data.retain(|e| !matches!(e, AxisElement::LegendEntry(_)));
}
