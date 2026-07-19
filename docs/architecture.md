Architecture and design notes

This document describes the high-level architecture for the animation core and the decisions made to improve performance.

Core modules

- lib/v2/core/src/animation/interpolate.dart
  - Responsible for mapping input ranges to output ranges for numeric, color, and offset interpolation.
  - Optimized to avoid per-frame allocations: callers may pass precomputed numeric arrays (inputVals/outputVals) when ranges are known ahead of time.

- lib/v2/core/src/animation/repeat.dart
  - Implements repeated animations using an explicit index/state-machine rather than nested closures.
  - Reduces per-repeat listener allocations.

- lib/v2/core/src/animation/sequence.dart
  - Runs sequential animations with a reusable listener/lock pattern rather than per-step closure allocations.

- lib/v2/core/src/shared/shared.dart
  - Manages a single AnimationController for a logical animation instance; tries to reuse the controller where possible and only recreates it when necessary.

- lib/v2/core/hook.dart
  - Provides lightweight builder/listenable combination helpers. Optimized to avoid allocating merged Listenable objects when there are 0 or 1 dependencies.

Design choices and rationale

1. Avoid per-frame allocations
   - Interpolation and color/offset mixing are called every frame for running animations. Allocations here (map/toList, sort, temporary closures) cause GC churn and frame jank.
   - We precompute numeric arrays where possible and allow callers to reuse them.

2. Reduce closure and listener churn
   - Sequence and repeat were reworked to use explicit state variables and a single listener that is updated, avoiding many short-lived closures.

3. Defensive lifecycle management for AnimationController
   - Instead of relying on catching exceptions when calling into a disposed controller, the implementation tracks _isDisposed and only recreates controllers when necessary.

4. Keep correctness first
   - Changes favor compatibility: functions retain previous APIs where possible and accept optional precomputed data. Tests and analyzer runs are recommended after refactoring.

Performance hotspots to watch

- interpolate (color/offset channels)
- helpers.random (avoid creating Random per-call)
- Frequent short animations that allocate and dispose controllers repeatedly

Suggested future work

- Add microbenchmarks for core hot paths and include them in CI as optional performance checks.
- Consider pooling or lightweight state machines for very high-frequency short animations.
- Expand unit coverage for edge cases (non-monotonic ranges, degenerate steps, disposed controllers).