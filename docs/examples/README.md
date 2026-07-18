# docs/examples — Usage examples and microbenchmarks

This folder contains short examples and microbenchmarks to help you understand remaths and measure performance changes.

Files included:

- examples/README.md — simple widget examples showing SharedValue usage
- benchmarks/README.md — instructions and small benchmark harnesses to measure interpolate and controller reset performance

How to use

1. Examples
   - Open `docs/examples/examples.md` to see a minimal StatefulWidget using SharedValue, withTiming, and interpolate.
   - Copy the example into your app's State to try it.

2. Benchmarks
   - The benchmarks folder contains a simple Dart harness that runs interpolation and color interpolation 100k times and prints timings.
   - Run the benchmark with `dart run benchmarks/bench_main.dart` or adapt to a Flutter benchmark if you want frame-accurate metrics.

Notes
- These are microbenchmarks (CPU-only) and don't measure GPU or frame-build overhead. For UI-level profiling, run the app in profile mode and use Flutter DevTools.
