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
The comparison shows that our implementation, Wasm-prechk, gets an average speedup of 1.72x over wasm with only dynamic checks, and that wasm-no_checks, an unsafe version that disables all checks, gets an average speedup of 1.76x.
Below are instructions to generate the raw data and graph, but first, a few important disclaimers.

### Important Disclaimers
- The reviewers asked us to add a 4th configuration, wasm_vm, that is the default configuration of wasmtime when it is possible to use virtual memory guard pages. This does not appear in the paper, but a graph we submitted to the reviewers is available at `~/data/run_time_relative.pdf`.
- As a result of the above change, the 100% line was renamed from wasm to wasm_dyn.
- Two polybench benchmarks are missing from the graph in the paper due to a script error. Our results for those benchmarks are also available in `~/data/run_time_relative.pdf`.
- The results may fluctuate, especially for shorter lived benchmarks. The better the machine, the larger the speed-ups usually (as one may expect). The specs of the machine we used to run the benchmark, as well as various over environmental factors, can be found in the paper (lines 952-957).

### Instructions
The folder `run_time` must be present in `~/PolybenchC-4.2.1` for the scripts to work.
It is recommended to delete `run_time.csv` and `run_time_relative.csv` each time before re-running the script.
1. Navigate to `~/PolybenchC-4.2.1`.
2. Invoke the script that will measure the run-times `./utilities/measure_run_time.sh`. This will probably take a few hours to complete.
3. The raw data is now available in `run_time.csv`.
4. Use `python3 ./utilities/relative.py` to generate the relative data in `run_time_relative.csv`. This should execute very quickly.
5. Finally, use `python3 ./utilities/make_run_time_graph_relative.py` to generate the graph. The graph will then be available as an pdf: `run_time_relative.pdf`. This should execute very quickly.

Note: In `run_time.csv`, `mean1` and `sem1` correspond to Wasm-prechk, `mean2` and `sem2` to wasm_no_checks, `mean3` and `sem3` to wasm with dynamic checks (wasm_dyn), and `mean4` and `sem4` to the default wasm configuration wasm_vm.

## Type Checking Cost Analysis
Table 1 shows the raw data of the over head of typechecking using wasm-prechk.
It shows that wasm-prechk takes an average of .16 seconds longer to compile, and .22 seconds longer to validate (typecheck) than wasm.
In addition, it shows that wasm-prechk annotations and manually added checks result in an extra 1469 bytes in the binary size on average.

The folders `compile_time`, and `validation_time` must be present in `~/PolybenchC-4.2.1` for their respective scripts to work.

These results can be reproduced using the following instructions from within `~/PolybenchC-4.2.1`:
- `./utilities/measure_compile_time.sh` will produce `compile_time.csv`, with the compilation times. This command may take a while to run.
- `./utilities/measure_validation_time.sh` will produce `validation_time.csv`, with the validation times. This command may take a while to run.
- `./utilities/measure_sizes.sh` will produce `sizes.csv`, with the binary sizes. This should execute very quickly.

The binary sizes should be exactly equal.
The validation and compilation times may vary, perhaps significantly depending on the specs of the computer used, but the difference between the times for wasm and wasm-prechk shoudn't change significantly.

# Download, Installation, and Sanity-Testing
## Download
### Docker
Access the Dockerfile and compose.yaml from https://github.com/atgeller/Wasm-Prechk-Artifact.

### Virtual Box
TODO

## Installation
### Docker
 1. Build the dockerfile using `docker-compose build` (this will likely take a while, around half an hour, especially on less beefy machines).
 2. Run the docker image interactively using `docker-compose run wasm-prechk`.

### VirtualBox
First, you need to build or download `POPL 2024 Artifact - Indexed Types for a Statically Safe WebAssembly-disk001.vmdk` to the same directory as 
`POPL 2024 Artifact - Indexed Types for a Statically Safe WebAssembly.ovf`.

Run `make-virtualbox.sh` to build a new image; an image can be downloaded from TODO.

1. Import `POPL 2024 Artifact - Indexed Types for a Statically Safe WebAssembly.ovf` into VirtualBox using "Import Appliance".
2. Start the virtual machine, and login using username `root` and password `root`.
   - The root password can be changed by modifying the `make-virtualbox.sh` script when generating the image.

## Sanity testsing
To sanity check that the pre-loaded software artifacts work properly, try running the following commands:
* `~/wasmtime/target/release/wasmtime --version`
* `~/vm_guards/target/release/wasmtime --version`
* `~/no_checks/target/release/wasmtime --version`
They should all succeed.

# Evaluation Instructions
Evaluation instructions for each claim are inlined in the list of claims.

To use our implementation of wasm-prechk, you can invoke `~/wasmtime/target/release/wasmtime <wasm file>`, where `<wasm file>` is a wasm module in text or binary format.
Alternatively, you can precompile wasm code using `~/wasmtime/target/release/wasmtime --allow-precompiled <wasm file> -o <output file name>.cwasm`, and then execute the precompiled code using `~/wasmtime/target/release/wasmtime --allow-precompiled <output file name>.cwasm`.

To typecheck a wasm module, you can use our implementation of wasm-tools: `~/wasm-tools/target/release/wasm-tools validate <wasm file>`.

You can test both the typechecker (wasm-tools) and compiler/runtime (wasmtime) on the example program `~/wasmtime/tests/wasm-prechk/bubblesort_stripped.wat`, which implements a prechecked version of bubblesort, compiled from C, within Wasm-prechk.
You should notice that if you change the annotations to constraints which no longer hold, you will receive a typechecking error.

# Artifact Layout
## Appendix
The appendix is available in `~/appendix.pdf`, it mostly contains proof details, as well as some additional typing rules, and experimental details.

### Our Results for Comparison
Raw data is available under the `~/data/` folder.
It should contain a version of every file that will be generated while reproducing the experiments, for comparison:
- `run_time.csv` contains the raw data on how long each benchmark takes to run.
- `run_time_relative.csv` contains data on how long each benchmark takes to run using different configurations compared to the configuration with dynamic checks.
- `run_time_relative.pdf` is the graph of the relative run time data.
- `sizes.csv` contains the binary sizes of all of the benchmarks.
- `validation_time.csv` contains raw data on how long it takes to typecheck each benchmark using wasm-tools.
- `compile_time.csv` contains raw data on how long it takes to compile each benchmark using wasmtime.

#### Important Disclaimer
To reiterate.
The reviewers asked us to add a 4th configuration, wasm_vm, that is the default configuration of wasmtime when it is possible to use virtual memory guard pages.
As a result, the 100% line was renamed from wasm to wasm_dyn.
These changes do not appear in the paper, but is contained in a version of the graph that we submitted to the reviewers, which is the graph in `~/data/run_time_relative.pdf`.
The graph from the paper is `~/data/run_time_relative_paper.pdf`.
Two polybench benchmarks are missing from the graph in the paper due to a script error.
Our results for those benchmarks are present in the raw run time data.

For the above mentioned reasons, the run time results (in `run_time.csv`, `run_time_relative.csv`, and `run_time_relative.pdf`) we provide here for comparision will contain additional data that is not currently in the paper, but was submitted to the reviewers.
All data in the paper is intact in the run time results provided here.

This disclaimer does not apply to the sizes, validation times, or compilation times.

## Software artifacts
- `~\wasmtime` contains our implementation of wasm-prechk on top of wasmtime.
It is also modified not to use any memory guard pages.
- `~\no_checks` contains the configuration of wasmtime modified to produce no dynamic checks.
- `~\vm_guards` contains the unmodified version of wasmtime.
- `~\wasm-tools` contains our implementation of the wasm-prechk parser and typechecker.
- `~\wasm-prechk` contains our redex model of wasm-prechk.
- `~\PolybenchC-4.2.1` contains the benchmark suite, including scripts to generate the evaluation data, the version of wasm modules with annotations and manual checks added for each benchmark, and the unmodified wasm modules for each benchmark.

## Other Notes
The folders `run_time`, `compile_time`, and `validation_time` must be present in `~/PolybenchC-4.2.1` for the scripts to work.