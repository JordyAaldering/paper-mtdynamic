mod prelude;
use prelude::*;
use epy::prelude::*;
use std::path::Path;

fn read_csv(benchmark: Benchmark) -> DataFrame<Record> {
    let path = format!("../src/res/baseline_{}.csv", benchmark);
    DataFrame::from_csv(Path::new(&path)).unwrap()
}

/// Find the bar with the lowest energy and replace it with a bar that is highlighted.
fn highlight_best_bar(ax: &mut Axis) {
    let (style, coordinates) = ax.data.iter_mut()
        .find_map(|e| {
            if let AxisElement::AddPlot { style, coordinates, .. } = e {
                Some((style, coordinates))
            } else {
                None
            }
        })
        .unwrap();

    let min_energy = coordinates.iter().cloned()
        .min_by(|c1, c2| {
            let Cs::Plain(_, y1) = c1 else { unreachable!() };
            let Cs::Plain(_, y2) = c2 else { unreachable!() };
            y1.partial_cmp(y2).unwrap()
        })
        .unwrap();

    // Remove the old bar from the original bar plot
    coordinates.retain(|c| *c != min_energy);

    // Insert the new bar into the plot, making sure to put it under the error bars
    let mut style = style.clone();
    style.fill = Some("energycolor!50!yellow".to_string());
    ax.data.insert(0, AxisElement::AddPlot {
        style,
        coordinates: vec![min_energy.clone()],
        closed_cycle: false,
    });
}

fn plot(df: &DataFrame<Record>, title: String) -> TikzPicture {
    let (mut ax0, mut ax1) = TwinPlot::new(
            |r: &Record| r.threads,
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

    highlight_best_bar(&mut ax0);

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

    for by_size in df.split_by(|r| r.size) {
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
