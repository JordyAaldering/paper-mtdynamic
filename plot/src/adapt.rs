mod prelude;
use prelude::*;
use epy::prelude::*;
use std::path::Path;

pub fn read_csv(benchmark: Benchmark) -> DataFrame<Record> {
    let path = format!("../src/res/adapt_{}.csv", benchmark);
    DataFrame::from_csv(Path::new(&path)).unwrap()
}

fn plot(benchmark: Benchmark, ymin: f64, ymax: f64) -> Axis {
    let df = read_csv(benchmark);

    let xlabel = if matches!(benchmark, Benchmark::Nbody) { "Bodies" } else { "Size" };

    let mut ax = TimeSeries::new(xlabel, "Threads")
        .series(&df, |r| r.threads as f64, "Threads", "colorblind0")
        .build_axis()
        .line(Cs::Axis(250.0, ymin), Cs::Axis(250.0, ymax), None)
        .line(Cs::Axis(500.0, ymin), Cs::Axis(500.0, ymax), None);
    ax.style.title = Some(format!("{:?}", benchmark));
    ax.style.xmin = Some(-30.0);
    ax.style.xmax = Some(780.0);
    ax.style.ymin = Some(ymin);
    ax.style.ymax = Some(ymax);
    remove_legend(&mut ax);

    ax.style.xticks = vec![125.0, 375.0, 625.0].into();
    let sizes = unique_sizes(&df).into_iter().map(|size| {
        if matches!(benchmark, Benchmark::Nbody) {
            format!("{}", size)
        } else {
            format!("{}$\\times${}", size, size)
        }
    }).collect::<Vec<_>>();
    ax.style.xtick_labels = Some(sizes.into());
    ax
}

fn nbody() {
    let ax = plot(Benchmark::Nbody, 6.0, 17.0)
        .line(Cs::Axis(0.0, 16.0), Cs::Axis(250.0, 16.0), "colorblind1".into())
        .line(Cs::Axis(250.0, 14.0), Cs::Axis(500.0, 14.0), "colorblind1".into())
        .line(Cs::Axis(500.0, 12.0), Cs::Axis(750.0, 12.0), "colorblind1".into());
    let tikz = TikzPicture::from_axis(ax);
    tikz.write("../paper/fig_adapt_nbody.tex").unwrap();
}

fn stencil() {
    let ax = plot(Benchmark::Stencil, 0.0, 17.0)
        .line(Cs::Axis(0.0, 16.0), Cs::Axis(250.0, 16.0), "colorblind1".into())
        .line(Cs::Axis(250.0, 14.0), Cs::Axis(500.0, 14.0), "colorblind1".into())
        .line(Cs::Axis(500.0, 12.0), Cs::Axis(750.0, 12.0), "colorblind1".into());
    let tikz = TikzPicture::from_axis(ax);
    tikz.write("../paper/fig_adapt_stencil.tex").unwrap();
}

fn matmul() {
    let ax = plot(Benchmark::Matmul, 0.0, 17.0)
        .line(Cs::Axis(0.0, 14.0), Cs::Axis(250.0, 14.0), "colorblind1".into())
        .line(Cs::Axis(250.0, 8.0), Cs::Axis(750.0, 8.0), "colorblind1".into());
    let tikz = TikzPicture::from_axis(ax);
    tikz.write("../paper/fig_adapt_matmul.tex").unwrap();
}

fn rust() {
    let ax = plot(Benchmark::Rust, 0.0, 17.0)
        .line(Cs::Axis(0.0, 16.0), Cs::Axis(250.0, 16.0), "colorblind1".into())
        .line(Cs::Axis(250.0, 8.0), Cs::Axis(750.0, 8.0), "colorblind1".into());
    let tikz = TikzPicture::from_axis(ax);
    tikz.write("../paper/fig_adapt_rust.tex").unwrap();
}

fn main() {
    nbody();
    stencil();
    matmul();
    rust();
}
