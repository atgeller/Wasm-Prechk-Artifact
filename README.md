# Artifact Layout
## Appendix
The appendix is available in `appendix.pdf` as part of this package (outside the VM), it mostly contains proof details, as well as some additional typing rules, and experimental details.

### Our Results for Comparison
Raw data is available under the `data` folder as part of this package (outside the VM).
It should contain a version of every file that will be generated while reproducing the experiments, for comparison:
- `run_time.csv` contains the raw data on how long each benchmark takes to run.
- `run_time_relative.csv` contains data on how long each benchmark takes to run using different configurations compared to the configuration with dynamic checks.
- `run_time_relative.pdf` is the graph of the relative run time data.
- `sizes.csv` contains the binary sizes of all of the benchmarks.
- `validation_time.csv` contains raw data on how long it takes to typecheck each benchmark using wasm-tools.
- `compile_time.csv` contains raw data on how long it takes to compile each benchmark using wasmtime.

## Software artifacts
- The `wasmtime` folder contains our implementation of wasm-prechk on top of wasmtime.
It is also modified not to use any memory guard pages.
- The `no_checks` folder contains the configuration of wasmtime modified to produce no dynamic checks.
- The `vm_guards` folder contains the unmodified version of wasmtime.
- The `wasm-tools` folder contains our implementation of the wasm-prechk parser and typechecker.
- The `wasm-prechk` folder contains our redex model of wasm-prechk.
- The `PolybenchC-4.2.1` folder contains the benchmark suite, including scripts to generate the evaluation data, the version of wasm modules with annotations and manual checks added for each benchmark, and the unmodified wasm modules for each benchmark.

### Repositories
All of the software artifacts, and the data and dockerfile, are available via git.
For the software artifacts, the tags below show the versions used to originally run the experiments.
For the data and dockerfile, the tag is the version this package was based on, but later versions may contain bug fixes, or support new platforms, check out release notes on newer releases for more information.
- Our instrumented version of `wasmtime` is available at https://github.com/atgeller/wasmtime/releases/tag/prechk-v1.0, the version here is tag `prechk-v1.0`.
- `no_checks` is available at https://github.com/atgeller/wasmtime/releases/tag/no-checks-v1.0, the version here is tag `no-checks-v1.0`
- What we call `vm_guards` corresponds to wasmtime version 5.0.0, it is available at https://github.com/bytecodealliance/wasmtime/releases/tag/v5.0.0.
- Our instrumented version of `wasm-tools` is available at https://github.com/atgeller/wasm-tools/releases/tag/prechk-v1.0, the version here is tag `prechk-v1.0`.
- Our annotated PolyBenchC benchmarks are available at https://github.com/atgeller/PolyBenchC-4.2.1/releases/tag/prechk-v1.1, the version here is tag `prechk-v1.1`.
- The redex model `wasm-prechk` is available at https://github.com/atgeller/wasm-prechk/releases/tags/prechk-v1.2, the version here is tag `prechk-v1.2`.
- Finally, this readme and the docker files are available at https://github.com/atgeller/wasm-prechk-artifact/releases/tags/prechk-v1.2, the version here is tag `prechk-v1.2`, but newer versions may contain better support for running the above artifacts.

The VM image is available on Zenodo.

## Other Notes
The folders `run_time`, `compile_time`, and `validation_time` must be present in `~/PolybenchC-4.2.1` for the scripts to work.
The VM/Docker image should have these folders present, but if they are not then the scripts will fail.

# Download, Installation, and Sanity-Testing
## Download
### Docker

Use Dockerfile and compose.yaml, included as part of this artifact.

### Virtual Box
The files `POPL2024Artifact-IndexedTypesforaStaticallySafeWebAssembly-disk001.vmdk` and `POPL 2024 Artifact - Indexed Types for a Statically Safe WebAssembly.ovf` provide a VM image for VirtualBox, they are available as part of this package, they can be built from the dockerfile (see below), and they are accessible through zenodo: TODO.

Alternatively, run `make-virtualbox.sh` to build a new image. This builds the Virtual Box image from the Docker image, and so requires a Docker.

### Locally
The artifact should work on any ubuntu:jammy machine (including a fresh virtual machine image), full installation instructions are provided below.

All software artifacts are available as part of this package. It's important to make sure these go into the right directories, so make sure you start in your local home directory `~` when running these commands.

### Other Files
The appendix is available in `appendix.pdf`, and raw data is available under the `data` folder in this package.

## Installation
### Docker
Known to work with at least Docker version 4.22
 1. Build the dockerfile provided with this package using `docker-compose build` (this will likely take a while, around half an hour, especially on less beefy machines).
 2. Run the docker image interactively using `docker-compose run wasm-prechk`.

### VirtualBox
Known to work with at least Virtualbox 7.0.10
1. Import `POPL 2024 Artifact - Indexed Types for a Statically Safe WebAssembly.ovf` into VirtualBox using "Import Appliance".
2. Start the virtual machine, and login using username `root` and password `root`.
   - The root password can be changed by modifying the `make-virtualbox.sh` script when generating the image.

### Locally
First, we list the necessary requirements, then we provide instructions for how to install them on an Ubuntu machine.

Requirements:
* Standard development libraries (see below command for a full list)
* `z3` version 4.12.1
* `cargo` version nightly-2023-03-31-x86_64-unknown-linux-gnu
* `hyperfine`
* `python3`, along with the following packages: `numpy`, `scipy`, `pandas`, `matplotlib`, and `uncertainties`.

Full instructions:
1. Install dependencies
```
apt-get -y --no-install-recommends install \
        cmake \
        build-essential \
        make \
        curl \
        default-jdk \
        python3 \
        python3-pip \
        python3-setuptools \
        python-is-python3 \
        sudo \
        locales \
        wget \
        unzip \
        git \
        libgtk-4-dev \
        llvm-dev \
        libclang-dev \
        clang \
        hyperfine \
        racket \
        libssl-dev
```

2. Install z3
```
wget https://github.com/Z3Prover/z3/releases/download/z3-4.12.1/z3-4.12.1-x64-glibc-2.35.zip
unzip z3-4.12.1-x64-glibc-2.35.zip
cp ./z3-4.12.1-x64-glibc-2.35/bin/z3 /usr/bin/z3
cp ./z3-4.12.1-x64-glibc-2.35/bin/libz3.so /usr/lib/libz3.so
cp ./z3-4.12.1-x64-glibc-2.35/bin/libz3.a /usr/lib/libz3.a
cp ./z3-4.12.1-x64-glibc-2.35/include/z3* /usr/include/
```
Afterwards, running `z3 --version` should return the correct version number

3. Install cargo
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /rustup-init.sh
chmod +x /rustup-init.sh
/rustup-init.sh -y --profile minimal --default-toolchain nightly-2023-03-31-x86_64-unknown-linux-gnu
```
Afterwards, running rustup toolchain list should should the relevant toolchain.

You may need to add cargo to your path. Try `cargo --version`, and add cargo to your path if it fails.

4. Install Python dependencies

`pip install numpy scipy pandas matplotlib uncertainties`

5. Copy sources

Make sure to place the following folders in your root directory, `~`:
* wasmtime
* no_checks
* vmguards
* wasm-tools
* PolyBenchC-4.2.1

The folder wasm-prechk can be used from anywhere on your machine.

5. (OPTIONAL) Download sources from github instead

It's important to make sure these go into the right directories, so make sure you start in your local home directory ~ when running these commands.

```
git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/wasmtime wasmtime
git clone --recursive --depth 1 --branch no-checks-v1.0 https://github.com/atgeller/wasmtime no_checks
git clone --recursive --depth 1 --branch v5.0.0 https://github.com/atgeller/wasmtime vmguards
git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/wasm-tools wasm-tools
git clone --recursive --depth 1 --branch prechk-v1.1 https://github.com/atgeller/PolyBenchC-4.2.1 PolyBenchC-4.2.1
git clone --recurse-submodules --recursive --depth 1 --branch prechk-v1.2 https://github.com/atgeller/wasm-prechk wasm-prechk
```

6. Build sources
Run the following command `cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release` inside each of the following directories:
```
~/wasmtime
~/no_checks
~/wasm-tools
~/vmguards
```

## Sanity testsing
To sanity check that the pre-loaded software artifacts work properly, try running the following commands (from within the VM/Docker image):
* `~/wasmtime/target/release/wasmtime --version`
* `~/vmguards/target/release/wasmtime --version`
* `~/no_checks/target/release/wasmtime --version`
They should all succeed.

To ensure the redex model works properly, run `raco test` from inside the redex model folder (`~/wasm-prechk`), it should succeed silently.

To typecheck a wasm module, you can use our implementation of wasm-tools: `~/wasm-tools/target/release/wasm-tools validate <wasm file>`.

# Evaluation Instructions
Evaluation instructions for each claim are inlined in the list of claims.

Each of the following usage instructions are from within the VM/Docker image/locally.

To use our implementation of wasm-prechk, you can invoke `~/wasmtime/target/release/wasmtime <wasm file>`, where `<wasm file>` is a wasm module in text or binary format.
Alternatively, you can precompile wasm code using `~/wasmtime/target/release/wasmtime --allow-precompiled <wasm file> -o <output file name>.cwasm`, and then execute the precompiled code using `~/wasmtime/target/release/wasmtime --allow-precompiled <output file name>.cwasm`.

# List of Claims
## Section 4 - Metatheory

## Theorem 1: Well Typed Embedding
The proof is available in the appendix starting on line 707.
Section B1 of the appendix generally contains definitions and theorems/lemmas related to embedding.

## Theorem 2: Erasure Preserves Typing 
The proof is available in the appendix starting on line 1780.
Section B2 of the appendix generally contains definitions and theorems/lemmas related to erasure.

### Lemma 1: Instruction Erasure Preserves Typing
The proof is available in the appendix starting on line 1592 (note that the lemma in the appendix, lemma 5, has a different name).

## Theorem 3: Type Safety
The proof is available in the paper.

## Lemma 2: Subject Reduction
The proof is available in the appendix starting on line 2553 (note that the lemma in the appendix, lemma 18, has a different name).
Sections C1 and C2 of the appendix generally contains definitions and theorems/lemmas related to erasure.

## Lemma 3: Subject Reduction for Instructions
The proof is available in the appendix starting on line 2576.

## Lemma 4: Progress
The proof is available in the appendix starting on line 4011.
Sections C1 and C3 of the appendix generally contains definitions and theorems/lemmas related to erasure.

## Lemma 5: Progress for Instructions
The proof is available in the appendix starting on line 4081.

## Section 5 - Implementation

## Implementation of limited version of Wasm-prechk in Wasmtime (Section 5)
Our implementation of Wasm-prechk within Wasmtime is available in `~/wasmtime`.
You can test it on the example program `tests/wasm-prechk/bubblesort_stripped.wat`, which implements a prechecked version of bubblesort, compiled from C, within Wasm-prechk.
The implementation is also used for the claims within the evaluation.

## Implementation of Call Indirect in Redex (Section 5.3)
In section 5.3, we describe how our redex model encodes constraints on call_indirect.
The redex model is available in `~/wasm-prechk`.
The implementation of validation of safe call_indirect is in the `TableValidation.rkt` file, and the usage can be seen in the judgement rule for call_indirect in the `IndexTypingRules.rkt` file.
An example test case in `Tests/IndexTableTest.rkt` demonstrates the ability of the implementation to typecheck a safe call_indirect instruction.

# Section 6 - Evaluation
## Benchmark setup (Section 6.1)
The benchmarks can be viewed under `~/PolybenchC-4.2.1`.
A full list of the benchmarks and their C source files is available in `utilities/annotated_benchmark_list`.
Then, the two versions of the benchmarks (unchanged and annotated), can be looked at from there.
For example, the first entry, `./datamining/correlation/correlation.c`, will have `./datamining/correlation/correlation_plain.wat`, the unchanged version, and `./datamining/correlation/correlation_prechk.wat`, the annotated version.

## Run-time Performance Analysis (Section 6.2)
Figure 6 shows a relative run-time performance comparison between several configurations of wasmtime.
The comparison shows that our implementation, Wasm-prechk, gets an average speedup of 1.71x over wasm with only dynamic checks (line 965), and that wasm-no_checks, an unsafe version that disables all checks, gets an average speedup of 1.76x (line 960).
Below are instructions to generate the raw data and graph, but first, some important notes.

### Important Notes
- The results may fluctuate, especially for shorter lived benchmarks. The specs of the machine we used to run the benchmark, as well as various other environmental factors, can be found in the paper.
- In case running all the benchmarks at once is an issue, modified instructions are provided to run the benchmarks in arbitrary pieces.

## Selecting benchmarks to run
The file `~/PolybenchC-4.2.1/utilities/annotated_benchmarks` contains the list of benchmarks that will be run. By default, it includes all the benchmarks. To avoid running a benchmark (or several), simply delete them from the file. It is recommended to first make a back-up of the file before modifying it.

To run the entire benchmark suite in pieces, following the instructions below, but before step 4, move the newly produced `run_time.csv` to a new file `run_time<n>.csv`. Rinse and repeat until all of the benchmarks have been run. Then combine the data in the various `run_time<n>.csv` files, making sure that the header only appears once at the top. Finally, continue onto step 4 and beyond (only once).

### Instructions
The folder `run_time` must be present in `~/PolybenchC-4.2.1` for the scripts to work.
It is recommended to delete/rename `run_time.csv` and `run_time_relative.csv` each time before re-running the script.
1. Navigate to `~/PolybenchC-4.2.1`.
2. Invoke the script that will measure the run-times `./utilities/measure_run_time.sh`. This will probably take a few hours to complete (it took about 4 hours on the machine we used, the specs of which can be found in the paper, lines 952-957).
3. The raw data is now available in `run_time.csv`.
4. Use `python3 ./utilities/relative.py` to generate the relative data in `run_time_relative.csv`. This should execute very quickly.
5. Finally, use `python3 ./utilities/make_run_time_graph_relative.py` to generate the graph. The graph will then be available as an pdf: `run_time_relative.pdf`. This should execute very quickly.

Note: In `run_time.csv`, `mean1` and `sem1` correspond to Wasm-prechk, `mean2` and `sem2` to wasm\_no\_checks, `mean3` and `sem3` to wasm with dynamic checks (wasm_dyn), and `mean4` and `sem4` to the default wasm configuration wasm\_vm.

The raw and processed data, as well as the graph, can be compared to the provided data in the `data` folder.

## Type Checking Cost Analysis
Table 1 shows the raw data of the over head of typechecking using wasm-prechk.
It shows that wasm-prechk takes an average of .16 seconds longer to compile, and .22 seconds longer to validate (typecheck) than wasm.
In addition, it shows that wasm-prechk annotations and manually added checks result in an extra 1469 bytes in the binary size on average.

The folders `compile_time`, and `validation_time` must be present in `~/PolybenchC-4.2.1` for their respective scripts to work.

As above, `~/PolybenchC-4.2.1/utilities/annotated_benchmarks` controls which benchmarks the scripts will include, and can be included to evaluate the benchmark suite in pieces.

These results can be reproduced using the following instructions from within `~/PolybenchC-4.2.1`:
- `./utilities/measure_compile_time.sh` will produce `compile_time.csv`, with the compilation times. This command may take a while to run (it took around an hour and a half on the machine we used, the specs of which can be found in the paper, lines 952-957).
- `./utilities/measure_validation_time.sh` will produce `validation_time.csv`, with the validation times. This command may take a while to run (it similarly took around an hour and a half).
- `./utilities/measure_sizes.sh` will produce `sizes.csv`, with the binary sizes. This should execute very quickly.

The binary sizes should be exactly equal.
The validation and compilation times may vary, perhaps significantly depending on the specs of the computer used, but the difference between the times for wasm and wasm-prechk shoudn't change significantly.
