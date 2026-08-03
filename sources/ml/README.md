# ML Service

This directory is reserved for the Militantyx anomaly-detection service.

The service will be implemented in Python using scikit-learn and Isolation
Forest. It will receive completed network-flow features from the C++ core over
a local HTTP API and return an anomaly score, anomaly label, and model version.

Planned contents:

- Python project configuration and dependency lock file;
- feature preparation and validation;
- model training, persistence, and loading;
- HTTP inference API;
- unit and model-quality tests;
- Dockerfile for the ML service.

The component has not been implemented yet and is therefore not included as a
service in Docker Compose.
