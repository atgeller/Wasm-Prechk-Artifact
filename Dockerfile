ARG DEBIAN_FRONTEND=noninteractive
FROM ubuntu:jammy

RUN apt-get update -y
RUN TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get -y --no-install-recommends install \
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
        hyperfine

# Fetch z3 and install
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.12.1/z3-4.12.1-x64-glibc-2.35.zip && \
    unzip z3-4.12.1-x64-glibc-2.35.zip && \
    cp ./z3-4.12.1-x64-glibc-2.35/bin/z3 /usr/bin/z3 ; \
    cp ./z3-4.12.1-x64-glibc-2.35/bin/libz3.so /usr/lib/libz3.so ; \
    cp ./z3-4.12.1-x64-glibc-2.35/bin/libz3.a /usr/lib/libz3.a ; \
    cp ./z3-4.12.1-x64-glibc-2.35/include/z3* /usr/include/

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup-init.sh
RUN chmod +x /rustup-init.sh
RUN /rustup-init.sh -y --profile minimal --default-toolchain nightly-2023-03-31
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo --version
RUN rustup toolchain list

# Install python libraries
RUN pip install numpy scipy pandas matplotlib

# Download software artifacts
ENV HOME_DIR=/root
ENV wasmtime=${HOME_DIR}/wasmtime
ENV no_checks=${HOME_DIR}/no_checks
ENV tools=${HOME_DIR}/wasm-tools
ENV polybench=${HOME_DIR}/PolyBenchC-4.2.1
WORKDIR ${HOME_DIR}
RUN git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/wasmtime wasmtime
RUN git clone --recursive --depth 1 --branch no-checks-v1.0 https://github.com/atgeller/wasmtime no_checks
RUN git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/wasm-tools wasm-tools
RUN git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/PolyBenchC-4.2.1 PolyBenchC-4.2.1

# Build projects
WORKDIR ${wasmtime}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release
WORKDIR ${no_checks}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release
WORKDIR ${tools}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release

# Set working directory for entry
WORKDIR ${polybench}
# Initialize folders scripts rely on being present
RUN mkdir run_time ; mkdir compile_time ; mkdir validation_time
