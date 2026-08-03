# Militantyx

Militantyx is a high-performance network traffic inspection system organized
as a monorepository. It is designed to combine a C++23 flow-based DPI core,
machine-learning anomaly detection, ClickHouse storage, and real-time web
visualization.

The project is currently in its initial development stage. The MVP scope,
architecture, technology stack, and implementation plan are available in the
[`docs`](docs/) directory.

Project components are organized under [`sources`](sources/):

- [`core`](sources/core/) contains the C++ DPI and backend code;
- [`ml`](sources/ml/) is reserved for the Python anomaly-detection service;
- [`dashboard`](sources/dashboard/) is reserved for the React web interface.

Development rules and local quality checks are described in
[`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md).
The target and development environments are documented in
[`docs/ENVIRONMENT.md`](docs/ENVIRONMENT.md).

## Development

```bash
scripts/install-hooks.sh
scripts/verify.sh
docker compose up --build
```

C++ code follows the Microsoft clang-format style. Pull requests to `main`
must pass the repository quality gate.

## License

Militantyx is licensed under the [Apache License 2.0](LICENSE).
