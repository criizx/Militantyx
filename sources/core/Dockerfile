FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake \
    libspdlog-dev catch2 ninja-build && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY CMakeLists.txt ./
COPY sources/core/ ./sources/core/

RUN cmake -S . -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_TESTING=ON && \
    cmake --build build --parallel && \
    ctest --test-dir build --output-on-failure

FROM ubuntu:24.04 AS runtime

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates libspdlog1.12 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /workspace/build/logger_smoke_test /usr/local/bin/logger_smoke_test

ENTRYPOINT ["/usr/local/bin/logger_smoke_test"]
