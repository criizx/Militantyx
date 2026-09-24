# ML Service

This directory is reserved for the Militantyx anomaly-detection service.
The baseline uses Python, scikit-learn, and Isolation Forest.

The C++ core queues uncertain observations for asynchronous analysis.
A worker sends batches of numeric flow features or time-window features
to the service over an internal HTTP API. Packet payloads are not sent.
Flow and window observations use separate feature schemas and model artifacts.

The service returns the job ID, observation revision, model version,
anomaly score, threshold, and processing status. Anomaly scores are not
attack probabilities; detector context and policy determine alert categories.

Planned contents:

- Python project configuration and dependency lock file;
- shared feature validation and transformations for training and inference;
- offline training on verified normal traffic and threshold validation;
- versioned model artifacts and a batch inference API;
- schema, failure-handling, and model-quality tests;
- Dockerfile for the service.

Training and audit datasets include legitimate traffic, including remote
administration. Online inference primarily handles observations selected
by the routing policy. An experimental all-observations mode and a controlled
audit sample are used to measure routing errors.

No LLM is required for this baseline. See the
[architecture](../../docs/ARCHITECTURE_AND_DECISIONS.md) and tasks T35–T41
in the [implementation plan](../../docs/TASK_BREAKDOWN.md).

The service has not been implemented and is not included in Compose yet.
