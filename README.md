## Energy-Aware Dynamic Adaptation of Runtime Systems[^1]

In recent years the energy-efficiency of software has become a key focus for both researchers and software developers, aiming to reduce greenhouse-gas emissions and operational costs.
Despite this growing awareness, developers still lack effective strategies to improve the energy-efficiency of their programs beyond the well-established approaches that optimize for runtime performance.
In this paper we present a dynamic adaptation algorithm that uses energy consumption feedback to optimize the energy-efficiency of data-parallel applications, by steering the level of parallelism during runtime through external control.
This approach is especially suited to functional languages, whose side-effect-free nature and strong semantic guarantees allow for easier code generation and straightforward scalability of the parallelism of programs.

Through a series of experiments we evaluate the effectiveness of our approach.
We measure how well the adaptation algorithm adapts to runtime changes, and we evaluate its effectiveness compared to a hypothesized oracle that knows the optimal level of parallelism, as well as a runtime-optimising-based approach.
We show that in a fixed-workload scenario we approach the theoretical best energy-efficiency, and that in changing workload scenarios the adaptation algorithm converges towards an optimal level of parallelism that minimizes energy consumption.

```bibtex
@inproceedings{aaldering2025energy,
  author={Aaldering, Jordy
    and van Gastel, Bernard
    and Scholz, Sven-Bodo},
  title={Energy-Aware Dynamic Adaptation of Runtime Systems},
  booktitle={Proceedings of the 26th International Symposium on Trends in Functional Programming},
  publisher={Springer Nature},
  series={TFP '25},
  location={Oxford, UK},
  year=2025,
  month=jan,
  pages={435--458},
  numpages={24},
  isbn={978-3-031-99751-8},
  doi={10.1007/978-3-031-99751-8_19}
}
```

[^1]: https://doi.org/10.1007/978-3-031-99751-8_19
