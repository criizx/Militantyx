# Militantyx

Militantyx is a high-performance network traffic inspection system organized
as a monorepository. It is designed to combine a C++23 flow-based DPI core,
machine-learning anomaly detection, ClickHouse storage, and real-time web
visualization.

The project is currently in its initial development stage. The MVP scope,
architecture, technology stack, and implementation plan are available in the
[`docs`](docs/) directory.

Project components are organized under [`sources`](sources/):

- `core` contains the C++ DPI and backend code;
- `ml` is reserved for the Python anomaly-detection service;
- `dashboard` is reserved for the React web interface.

Development rules and local quality checks are described in
[`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md).

## Development

```bash
scripts/install-hooks.sh
scripts/verify.sh
```

C++ code follows the Microsoft clang-format style. Pull requests to `main`
must pass the repository quality gate.
