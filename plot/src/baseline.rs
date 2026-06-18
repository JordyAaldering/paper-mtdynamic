mod prelude;
use prelude::*;
use epy::prelude::*;
use std::path::Path;

pub fn read_csv(device: Device, baseline: Baseline) -> DataFrame<Record> {
    let path = format!("../src/res/{}/{}.csv", device, baseline);
    DataFrame::from_csv(Path::new(&path)).unwrap()
}

fn plot(df: &DataFrame<Record>, title: String) -> TikzPicture {
    let (mut ax0, mut ax1) = TwinPlot::new(
            |r: &Record| r.threads as f64,
            "Threads",
            "Energy (J)",
            "Runtime (s)",
        )
        .ax0_bar(df,
            |r| r.energy(),
            AggregationMode::Quartiles,
            "Energy (J)",
            "energycolor",
        )
        .ax1_line(df,
            |r| r.runtime(),
            AggregationMode::meanstd(),
            "Runtime (s)",
            "runtimecolor",
        )
        .build_axes();
    ax0.style.title = Some(title);
    ax0.style.ymin = Some(0.0);
    ax1.style.ymin = Some(0.0);
    remove_legend(&mut ax0);
    ax0.style.filter_xticks(|i| filter_every(i, 3));
    TikzPicture::from_twin(ax0, ax1)
}

fn plot_baseline(device: Device, baseline: Baseline) {
    let df = read_csv(device, baseline);
    for size in unique_sizes(&df) {
        let title = if matches!(baseline, Baseline::Nbody) {
            format!("{} bodies", size)
        } else {
            format!("{} $\\times$ {}", size, size)
        };

        let doc = plot(&df.clone().filter(|_, r| r.size == size), title);
        let path = format!("../paper/img/{}_{}_{}.tex", device, baseline, size);
        doc.write(&path).unwrap();
    }
}

fn main() {
    plot_baseline(Device::CN125, Baseline::Stencil);
    plot_baseline(Device::CN125, Baseline::Matmul);
    plot_baseline(Device::CN125, Baseline::Nbody);
    plot_baseline(Device::CN125, Baseline::Rust);
}
