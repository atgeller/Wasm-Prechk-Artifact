ARG DEBIAN_FRONTEND=noninteractive
FROM ubuntu:jammy

USER root

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
        hyperfine \
        racket \
        libssl-dev

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

ENV PATH="/root/.cargo/bin:${PATH}"

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /rustup-init.sh
RUN chmod +x /rustup-init.sh
RUN /rustup-init.sh -y --profile minimal --default-toolchain nightly-2023-03-31
RUN rustup toolchain list

# Install python libraries
RUN pip install numpy scipy pandas matplotlib

# Download software artifacts
ENV wasmtime=/root/wasmtime
ENV no_checks=/root/no_checks
ENV vm_guards=/root/vmguards
ENV tools=/root/wasm-tools
ENV polybench=/root/PolyBenchC-4.2.1
ENV redex=/root/wasm-prechk
WORKDIR /root/
RUN git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/wasmtime wasmtime
RUN git clone --recursive --depth 1 --branch no-checks-v1.0 https://github.com/atgeller/wasmtime no_checks
RUN git clone --recursive --depth 1 --branch v5.0.0 https://github.com/atgeller/wasmtime vmguards
RUN git clone --recursive --depth 1 --branch prechk-v1.0 https://github.com/atgeller/wasm-tools wasm-tools
RUN git clone --recursive --depth 1 --branch prechk-v1.1 https://github.com/atgeller/PolyBenchC-4.2.1 PolyBenchC-4.2.1
RUN git clone --recurse-submodules --recursive --depth 1 --branch prechk-v1.2 https://github.com/atgeller/wasm-prechk wasm-prechk

# Build projects
WORKDIR ${wasmtime}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release
WORKDIR ${no_checks}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release
WORKDIR ${vm_guards}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release
WORKDIR ${tools}
RUN cargo +nightly-2023-03-31-x86_64-unknown-linux-gnu build --release

# Set working directory for entry
WORKDIR ${polybench}
# Initialize folders scripts rely on being present
RUN mkdir run_time ; mkdir compile_time ; mkdir validation_time

WORKDIR /root/