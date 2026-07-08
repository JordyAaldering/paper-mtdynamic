mod prelude;
use prelude::*;
use epy::prelude::*;
use std::path::Path;

fn read_csv(benchmark: Benchmark) -> DataFrame<Record> {
    let path = format!("../src/res/baseline_{}.csv", benchmark);
    DataFrame::from_csv(Path::new(&path)).unwrap()
}

fn plot(df: &DataFrame<Record>, title: String) -> TikzPicture {
    let (mut ax0, mut ax1) = TwinPlot::new(
            |r: &Record| r.threads as f64,
            "Threads",
            "Energy (\\si{\\joule})",
            "Runtime (\\si{\\second})",
        )
        .ax0_bar(df,
            |r| r.energy(),
            AggregationMode::Quartiles,
            "Energy",
            "energycolor",
        )
        .ax1_line(df,
            |r| r.runtime(),
            AggregationMode::Quartiles,
            "Runtime",
            "runtimecolor",
        )
        .build_axes();

    let max = df.fold(0f64, |acc, r| acc.max(r.energy()));
    ax0 = ax0.line(Cs::Axis(7.5, 0.0), Cs::Axis(7.5, (max * 1.1).ceil()), None);

    ax0.style.title = Some(title);
    ax1.style.ymin = Some(0.0);
    filter_xticks(&mut ax0);
    remove_legend(&mut ax0);
    TikzPicture::from_twin(ax0, ax1)
}

fn plot_baseline(benchmark: Benchmark) {
    let df = read_csv(benchmark);

    for by_size in df.split_by(|r| r.size as f64) {
        let size = by_size.rows()[0].size;
        let title = if matches!(benchmark, Benchmark::Nbody) {
            format!("{} bodies", size)
        } else {
            format!("${} \\times {}$", size, size)
        };

        let tikz = plot(&by_size, title);
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
