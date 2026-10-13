# Two-Hour Offline Session Plan

## Session Goal

Implement a minimal PCAP packet source in two hours. The test program must read packets in order and return each packet’s timestamp, original length, and captured bytes.

Leave Ethernet, IP, TCP, and UDP parsing for the next task. First verify PCAP reading independently of packet contents.

## 0-10 minutes: Prepare module structure

Create files:

```text
sources/core/include/militantyx/capture/captured_packet.h
sources/core/include/militantyx/capture/pcap_file_source.h
sources/core/src/capture/pcap_file_source.cpp
sources/core/tests/capture/pcap_file_source_test.cpp
sources/core/tests/fixtures/
```

In `CMakeLists.txt`:

1. find Catch2 via `find_package(Catch2 3 CONFIG REQUIRED)` only when `BUILD_TESTING` is enabled;
2. create the test executable `pcap_file_source_test`;
3. link `Catch2::Catch2WithMain`;
4. register tests via `catch_discover_tests`.

Definition of done: an empty Catch2 test compiles and runs via CTest.

## 10-30 minutes: Define the captured packet model

Proposed model:

```cpp
struct CapturedPacket {
    std::chrono::time_point<std::chrono::system_clock,
                            std::chrono::nanoseconds> timestamp;
    std::uint32_t original_length;
    std::vector<std::byte> data;
};
```

Requirements:

- `timestamp` contains the PCAP timestamp converted to nanoseconds;
- `original_length` contains the packet length before capture truncation;
- `data.size()` matches the number of saved bytes;
- the struct must own its data and contain no pointers to the reader’s buffer.

Ethernet, IP, and port fields belong in the later parser result. Leave them out of the packet source.

Definition of done: the header compiles independently and does not depend on libpcap.

## 30-75 minutes: Implement PCAP reading

Proposed interface:

```cpp
class PcapFileSource {
public:
    explicit PcapFileSource(const std::filesystem::path& path);

    [[nodiscard]] std::optional<CapturedPacket> next();
};
```

Minimal supported format for the first version:

- classic PCAP, not PCAPNG;
- little-endian headers;
- microsecond precision timestamps;
- preserve the link-layer type in the source metadata; only Ethernet (`LINKTYPE_ETHERNET`, value `1`) needs support in this session.

`next()` algorithm:

1. Open the file in binary mode when the source is created.
2. Read the global PCAP header and verify the magic number.
3. Verify version `2.4` and the link-layer type.
4. Read the next record header on each call.
5. Verify that the captured length does not exceed an acceptable limit, e.g., 16 MiB.
6. Read exactly the specified number of bytes.
7. Return `std::nullopt` at a valid end-of-file.
8. Throw a dedicated exception with a clear message if a header or packet payload is truncated.

Read headers into byte arrays and extract integers with `read_u16_le` and `read_u32_le`. Reading directly into C structs with `reinterpret_cast` makes the result depend on alignment and byte order.

Definition of done: the source reads all records of a valid file and distinguishes EOF from corrupted data.

## 75-110 minutes: Write tests

Required test cases:

```cpp
TEST_CASE("PCAP source reads packet data and metadata");
TEST_CASE("PCAP source returns no packet for an empty capture");
TEST_CASE("PCAP source rejects an invalid magic number");
TEST_CASE("PCAP source rejects a truncated global header");
TEST_CASE("PCAP source rejects a truncated packet payload");
TEST_CASE("PCAP source rejects an unsupported link type");
```

Use two fixtures: an empty PCAP and a PCAP with one Ethernet frame. Build corrupt inputs from small byte arrays in the tests.

In a valid test packet, verify:

- timestamp value;
- `original_length`;
- size of captured data;
- first and last byte of data;
- `std::nullopt` after the last packet.

Definition of done: all positive and negative test scenarios pass.

## 110-120 minutes: Verify and finalize results

Run:

```bash
cmake -S . -B .build -G Ninja -DBUILD_TESTING=ON
cmake --build .build --parallel
ctest --test-dir .build --output-on-failure
scripts/format.sh
scripts/verify.sh
git diff --check
git status --short
```

Commit after successful verification:

```bash
git add CMakeLists.txt sources/core
git commit -m "feat(capture): add PCAP file source"
```

## If work is completed early

Add support for PCAP with nanosecond timestamps. Leave big-endian PCAP and PCAPNG for separate tasks so this session ends with a tested reader.

## Installed local dependencies

Used for this session:

- CMake;
- Ninja;
- C++23 compliant compiler;
- spdlog;
- Catch2 3;
- clang-format and clang-tidy from LLVM.

The planned PCAP reader does not use libpcap. It shares the packet-source interface with future capture modules, while offline reading stays independent of Linux `AF_PACKET`.
