mod prelude;
use prelude::*;
use epy::prelude::*;

fn plot(df: &DataFrame<Record>) -> TikzPicture {
    let (mut ax0, mut ax1) = TwinPlot::new(
            |r: &Record| r.threads as f64,
            "Threads",
            "Energy",
            "Runtime",
        )
        .ax0_bar(df,
            |r| r.energy(),
            AggregationMode::Quartiles,
            "Energy",
            "energycolor",
        )
        .ax1_line(df,
            |r| r.runtime(),
            AggregationMode::meanstd(),
            "Runtime",
            "runtimecolor",
        )
        .build_axes();
    ax0.style.ymin = Some(0.0);
    ax1.style.ymin = Some(0.0);
    TikzPicture::from_twin(ax0, ax1)
}

fn main() {
    let df = read_csv("cn125/matmul");

    let doc = plot(&df.clone().filter(|_, r| r.size == 500));
    println!("{}", doc.render());
    let doc = plot(&df.clone().filter(|_, r| r.size == 1000));
    println!("{}", doc.render());
    let doc = plot(&df.clone().filter(|_, r| r.size == 1500));
    println!("{}", doc.render());
}
