# AGENTS.md

## Project overview

Militantyx is a research prototype for detecting previously unknown malicious activity based on the structure of network interactions between workstations.

The project goal is to:
- ingest PCAP/network captures;
- build bidirectional flows;
- aggregate flows into time windows and interaction graphs;
- compute structural and interaction-based features;
- assess anomaly likelihood using offline training and validation.

Important: this project is still in an early research stage. At the moment, the repository mainly contains the build system, tooling, quality checks, and the skeleton of the architecture. The full detector is not yet implemented.

## Source of truth

If you need to understand the architecture, constraints, experimental plan, or development workflow, start with:
- `README.md`
- `docs/ARCHITECTURE_AND_DECISIONS.md`
- `docs/RESEARCH_PROTOCOL.md`
- `docs/TASK_BREAKDOWN.md`
- `docs/STACK_DECISIONS.md`
- `docs/ENVIRONMENT.md`
- `docs/CONTRIBUTING.md`

These files are more authoritative than assumptions or ad hoc implementation guesses.

## Repository structure

- `sources/core/` — C++23 core implementation. This is where logging, PCAP handling, flow processing, graph logic, and future feature extraction belong.
- `sources/ml/` — Python module for training, evaluation, model comparison, and threshold selection.
- `sources/dashboard/` — analysis interface for anomalous windows and related flows.
- `docs/` — technical and research documentation, methodology, architecture, and experiments.
- `scripts/` — local validation scripts, formatting tools, hooks, and build checks.
- `.github/workflows/` — CI workflow for build and quality validation.

## Current project status

The repository currently includes:
- a CMake-based project;
- C++ logging and smoke tests;
- Catch2 3 integration and CTest;
- Git hooks and validation scripts;
- GitHub Actions workflows;
- a project skeleton for future core logic.

What is not yet complete:
- final PCAP parser and packet processing pipeline;
- graph-based detector implementation;
- ML training and evaluation pipeline;
- dashboard integration and runtime workflow.

Do not describe the project as if it already fully detects malicious behavior. The project is still in a prototyping and research phase.

## Development rules

### 1) Do not overstate readiness

Avoid claims like:
- “the detector is working”;
- “the model is ready”; or
- “traffic analysis is fully implemented”.

The project is a research prototype and should be treated as such.

### 2) Preserve the intended architecture

When adding functionality:
- respect the separation between `core`, `ml`, and `dashboard`;
- keep the data flow consistent with the documented pipeline;
- avoid mixing concerns across components unless explicitly justified;
- do not add production-style integrations before the offline prototype is validated.

### 3) Keep early-stage implementation simple

Because the project is still in early development:
- avoid unnecessary external dependencies;
- avoid premature “production APIs”;
- keep logging and diagnostics readable and testable;
- prefer incremental, verifiable changes over large speculative rewrites.

### 4) Documentation is part of the code

If you change:
- architecture,
- feature schemas,
- data formats,
- experiment protocol,
- environment requirements,
- development workflow,

then update the corresponding docs as well.

### 5) Respect scientific correctness

The project has important research constraints:
- train/test splits must be handled correctly;
- unknown malicious scenarios used for testing must not leak into training and tuning;
- label noise and observation limitations must be treated explicitly;
- packet contents and decryption are not required for the initial feature set.

## Build and validation

Common build commands:

```bash
cmake -S . -B .build/checks -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build .build/checks --parallel
ctest --test-dir .build/checks --output-on-failure
scripts/verify.sh
```

Additional checks:

```bash
scripts/format.sh
scripts/check-format.sh
scripts/run-tests.sh
scripts/install-hooks.sh
```

Required tooling:
- CMake 3.25+
- a C++23 compiler
- spdlog
- Catch2 3
- clang-format
- clang-tidy
- ShellCheck

## C++ core behavior

For `sources/core/`:
- keep code in C++23;
- respect the existing clang-format configuration;
- do not hide experimental logic behind false claims of completion;
- keep responsibilities separated between logging, parsing, flow handling, graph construction, and feature extraction;
- add tests in `sources/core/tests/` for any new logic.

## Python and ML expectations

For `sources/ml/`:
- keep feature definitions and versions explicit;
- track model metadata and configuration;
- maintain a clear distinction between train, validation, and test data;
- document assumptions around threshold selection and anomaly scoring.

## Dashboard expectations

For `sources/dashboard/`:
- prioritize offline-analysis workflows;
- expose anomalous windows and associated flows clearly;
- make missing data, evaluation errors, and incomplete observations visible instead of hiding them.

## Commit and architecture review guidance

If a change affects:
- the interface between components,
- data contracts,
- the `core → ml → dashboard` pipeline,
- descriptions in `docs/ARCHITECTURE_AND_DECISIONS.md`,

then update both the implementation and the documentation together.

## Anti-patterns to avoid

- adding a pseudo-detector without describing the feature set and thresholding logic;
- changing the research protocol without updating the relevant documents;
- mixing packet-analysis logic with ML training logic in a single place without reason;
- pretending that a stub implementation is production-ready;
- making large changes without aligning them to the architecture docs.

## Short summary

This repository is not merely a C++ project. It is a research-oriented platform with a documented architecture and a defined experimental direction. Correct work here means keeping the code, docs, and scientific assumptions aligned, especially while the architecture is still evolving.

If you need to understand the project quickly, start with `README.md`, then read the documents in `docs/`, and only then inspect the implementation in `sources/`.
