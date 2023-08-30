# Wasm-Prechk-Artifact
Contains software artifacts, benchmarks, and a dockerfile for Wasm-prechk

## Getting started
 1. Build the dockerfile using `docker build --tag wasm-prechk .` (this will likely take a while, around half an hour, especially on less beefy machines).
 2. Run the docker image interactively using `docker run -it wasm-prechk`.
 3. You should start in the correct directory `~/PolyBenchC-4.2.1`.
 4. Use `~/wasmtime/target/release/wasmtime --version`, `~/no_checks/target/release/wasmtime --version`, and `~/wasm-tools/target/release/wasmtime --version` to ensure the software artifacts were built correctly.
 5. Use the scripts to generate csv files with experiment data (running all 4 should take a few hours, beefy machine recommended):
    * `./utilities/measure_run_time.sh`
    * `./utilities/measure_compile_time.sh`
    * `./utilities/measure_validation_time.sh`
    * `./utilities/measure_sizes.sh`
    These will each produce a csv file with the name based on the script.
    For example, `measure_run_time.sh` will produce `run_time.csv`.
 6. To generate the relative run-time graph as it appeared in the paper:
    * Use `python3 ./utilities/relative.py` to generate the relative data, and
    * Use `python3 ./utilities/make_run_time_graph_relative.py` to generate the graph.
    The graph will then be available as an svg: `run_time_relative.svg`.
