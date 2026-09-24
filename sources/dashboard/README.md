# Dashboard

This directory is reserved for the Militantyx web dashboard, using React,
TypeScript, and Vite. Historical data will be loaded through the Drogon
REST API, with persisted updates delivered through WebSocket.

Planned views:

- traffic summary and active/completed flows;
- alerts with detector category, evidence, and rule/ML source;
- anomaly score and analysis status, including unavailable or skipped analysis;
- sensor health: capture losses, queue occupancy, processing and export failures;
- filters and connection status, with REST resynchronization after reconnect.

The interface must distinguish observed protocol usage, policy violations,
and suspected C2 activity. It must not present an anomaly score as an attack
probability or a pending/failed analysis as a benign verdict.

The component has not been implemented and is not included in Compose yet.
See tasks T32–T34 and T41 in the
[implementation plan](../../docs/TASK_BREAKDOWN.md).
