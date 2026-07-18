# benchmarks — microbenchmarks instructions

This folder contains a small Dart benchmark harness (CPU) to measure hot-path functions such as:

- interpolate
- interpolateColor
- controller reset / reuse patterns

Example harness outline (bench_main.dart):

- Create deterministic inputs (arrays of doubles / colors).
- Run the target function in a tight loop (e.g. 100_000 iterations).
- Use Stopwatch to measure elapsed microseconds and print results.

Notes:
- For UI-level profiling run the app in profile mode and use Flutter DevTools.
- These harnesses are intended for quick comparisons before/after code changes.
