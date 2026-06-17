#![allow(unused)]
use epy::prelude::*;
use serde::Deserialize;
use std::{collections::HashSet, fmt, path::Path};

#[derive(Clone, Deserialize)]
pub struct Record {
    pub size: usize,
    pub threads: usize,
    runtime: f64,
    energy: f64,
}

impl Record {
    pub fn runtime(&self) -> f64 {
        self.runtime
    }

    pub fn energy(&self) -> f64 {
        self.energy - self.runtime * 3.08
    }
}

pub fn read_csv(filename: &str) -> DataFrame<Record> {
    let path = format!("../src/res/{}.csv", filename);
    DataFrame::from_csv(Path::new(&path)).unwrap()
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

pub fn max_threads(df: &DataFrame<Record>) -> usize {
    df.rows()
        .iter()
        .map(|r| r.threads)
        .max()
        .unwrap()
}
