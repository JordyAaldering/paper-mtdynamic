mod prelude;
use prelude::*;
use epy::prelude::*;
use serde::Deserialize;
use std::path::Path;

#[derive(Clone, Deserialize)]
pub struct IntermediateRecord {
    size: usize,
    threads: usize,
    runtime: f64,
    #[serde(default)]
    runtimesd: f64,
    energy: f64,
    #[serde(default)]
    energysd: f64,
}

/// We need to be a bit hacky to make the aggregated results work with epy.
/// For every row, we keep that row and add two new rows, adjusted for the standard deviation.
/// Then, we use the Quartiles aggregation mode, which will select these two standard-deviation-adjusted rows.
/// (Thus, even though it is named Quartiles, in actuality it selects the inserted standard deviations.)
pub fn read_csv(benchmark: Benchmark) -> DataFrame<Record> {
    let path = format!("../src/res/baseline_{}.csv", benchmark);
    let intermediate_df = DataFrame::<IntermediateRecord>::from_csv(Path::new(&path)).unwrap();
    let adjusted_rows = intermediate_df.rows()
        .into_iter()
        .flat_map(|r| vec![
            Record { size: r.size, threads: r.threads as f64, runtime: r.runtime, energy: r.energy },
            Record { size: r.size, threads: r.threads as f64, runtime: r.runtime - r.runtimesd, energy: r.energy - r.energysd },
            Record { size: r.size, threads: r.threads as f64, runtime: r.runtime + r.runtimesd, energy: r.energy + r.energysd },
        ])
        .collect();
    DataFrame::from_vec(adjusted_rows)
}

fn plot(df: &DataFrame<Record>, title: String) -> TikzPicture {
    let (mut ax0, mut ax1) = TwinPlot::new(
            |r: &Record| r.threads as f64,
            "Threads",
            "Energy (\\si{\\joule})",
            "Runtime (\\si{\\second})",
        )
        .ax0_bar(df,
            |r| r.energy,
            AggregationMode::Quartiles,
            "Energy (\\si{\\joule})",
            "energycolor",
        )
        .ax1_line(df,
            |r| r.runtime,
            AggregationMode::Quartiles,
            "Runtime (\\si{\\second})",
            "runtimecolor",
        )
        .build_axes();

    let max = df.fold(0f64, |acc, r| acc.max(r.energy));
    ax0 = ax0.line(Cs::Axis(7.5, 0.0), Cs::Axis(7.5, (max * 1.1).ceil()), None);

    ax0.style.title = Some(title);
    ax0.style.ymin = Some(0.0);
    ax1.style.ymin = Some(0.0);
    remove_legend(&mut ax0);
    ax0.style.filter_xticks(|i| filter_every(i, 3));
    TikzPicture::from_twin(ax0, ax1)
}

fn plot_baseline(benchmark: Benchmark) {
    let df = read_csv(benchmark);
    for size in unique_sizes(&df) {
        let title = if matches!(benchmark, Benchmark::Nbody) {
            format!("{} bodies", size)
        } else {
            format!("${} \\times {}$", size, size)
        };

        let tikz = plot(&df.clone().filter(|_, r| r.size == size), title);
        let path = format!("../paper/fig_{}_{}.tex", benchmark, size);
        tikz.write(&path).unwrap();
    }
}

fn main() {
    plot_baseline(Benchmark::Nbody);
    plot_baseline(Benchmark::Stencil);
    plot_baseline(Benchmark::Matmul);
    plot_baseline(Benchmark::Rust);
}
