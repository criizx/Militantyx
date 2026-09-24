# Militantyx

Militantyx is a C++23 network traffic inspection project organized as a
monorepository. It is being developed as a passive sensor for detecting signs
of TLS command-and-control communication, unauthorized DoH/DoT usage, and
selected unauthorized VPN protocols in a corporate network.

The planned pipeline combines flow tracking, selective DPI, policy rules,
asynchronous machine-learning analysis, ClickHouse storage, and a real-time
web dashboard. Traffic is not decrypted or blocked. Detection quality and
processing performance will be evaluated experimentally.

The project is at an early implementation stage: logging and build tooling
are present; packet capture files and a placeholder test have been added.
The detection pipeline, ML service, and dashboard are not implemented yet.

- [Scope and acceptance criteria](docs/MVP.md)
- [Architecture and decisions](docs/ARCHITECTURE_AND_DECISIONS.md)
- [Implementation tasks](docs/TASK_BREAKDOWN.md)
- [Technology choices](docs/STACK_DECISIONS.md)

Project components are organized under [sources](sources/):

- [core](sources/core/) contains the C++ sensor and backend;
- [ml](sources/ml/) is reserved for the Python anomaly-detection service;
- [dashboard](sources/dashboard/) is reserved for the React web interface.

Development rules and quality checks are described in
[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).
Target and development environments are documented in
[docs/ENVIRONMENT.md](docs/ENVIRONMENT.md).

## Development

```bash
scripts/install-hooks.sh
scripts/verify.sh
docker compose up --build
```

C++ code follows the Microsoft clang-format style. Pull requests to main
must pass the repository quality gate.

The current Compose file is an infrastructure scaffold. The core image runs
the logger smoke test rather than a traffic sensor. Its build dependencies
still need to be aligned with the Catch2 requirement in CMake; see T09 in
the implementation plan.

## License

Militantyx is licensed under the [Apache License 2.0](LICENSE).
