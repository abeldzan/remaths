API overview

This document gives a quick reference to the main files and their responsibilities. It is not exhaustive — use the source files and generated API docs for full details.

lib/v2/core/src/

- animation/
  - interpolate.dart — Interpolation helpers for numeric ranges, colors, offsets. Use these when mapping input-value ranges to output values; optimized for low allocations.
  - repeat.dart — Utilities for repeating animations with onComplete hooks and safe lifecycle behavior.
  - sequence.dart — Run multiple animations in sequence with reduced allocation patterns.

- shared/
  - shared.dart — Shared animation controller management and lifecycle. Reuses AnimationController instances when possible.

- hook.dart — Lightweight hooks and builders that listen to one or more Listenables. Avoids merged listenable allocations when unnecessary.

Helpers and utilities

- helpers.dart — Misc helpers (random, sqrt, range). Some helpers were identified as candidates for optimization; prefer module-level Random reuse rather than per-call Random constructors.

Examples and docs

- docs/examples/ — Small runnable examples demonstrating how to use the SharedValue, sequences, and color interpolation.
- docs/benchmarks/ — Guidance and harness for microbenchmarks.

Where to start

1. Read docs/getting-started.md for build/test instructions.
2. Run an example from docs/examples/ to see the API in action.
3. Read architecture.md for the design trade-offs and hotspots.

If you would like I can produce an auto-generated API reference (dartdoc) or a minimal set of public-facing docs for publishing.