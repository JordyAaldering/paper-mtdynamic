#![allow(unused)]
use epy::prelude::*;
use serde::Deserialize;
use std::{collections::HashSet, fmt};

#[derive(Clone, Deserialize)]
pub struct Record {
    pub size: usize,
    pub threads: usize,
    runtime: f64,
    energy: f64,
}

#[derive(Clone, Copy)]
pub enum Device {
    CN125,
    Laptop,
}

impl fmt::Display for Device {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use Device::*;
        match self {
            CN125 => write!(f, "cn125"),
            Laptop => write!(f, "laptop"),
        }
    }
}

#[derive(Clone, Copy)]
pub enum Baseline {
    Matmul,
    Nbody,
    Stencil,
    Rust,
}

impl fmt::Display for Baseline {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        use Baseline::*;
        match self {
            Matmul => write!(f, "matmul"),
            Nbody => write!(f, "nbody"),
            Stencil => write!(f, "stencil"),
            Rust => write!(f, "rust"),
        }
    }
}

impl Record {
    pub fn runtime(&self) -> f64 {
        self.runtime
    }

    pub fn energy(&self) -> f64 {
        self.energy - self.runtime * 3.08
    }
}

pub fn max_threads(df: &DataFrame<Record>) -> usize {
    df.rows()
        .iter()
        .map(|r| r.threads)
        .max()
        .unwrap()
}

pub fn unique_threads(df: &DataFrame<Record>) -> Vec<usize> {
    let mut t = df.rows()
        .iter()
        .map(|r| r.threads)
        .collect::<HashSet<_>>()
        .into_iter()
        .collect::<Vec<_>>();
    t.sort_unstable();
    t
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
