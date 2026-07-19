Benchmarks guide

We use small Stopwatch-based microbenchmarks to measure allocations and elapsed time for hot functions (interpolate, color mixing, sequence/repeat running many short animations).

Bench harness guidelines

- Keep harnesses deterministic: avoid random durations unless you're measuring distribution.
- Run each bench many iterations (e.g., 1000+) and warm up the VM first.
- Measure both elapsed time and allocations (Flutter DevTools / Observatory) when possible.

Example flow

1. Warm up the VM with the function under test for ~100 iterations.
2. Run `N` iterations while measuring Stopwatch.elapsed.
3. Print mean and percentile timings.

Example pseudocode (Dart)

```
void bench(Function f, int iterations) {
  // warmup
  for (int i = 0; i < 100; i++) f();

  final sw = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) f();
  sw.stop();
  print('Elapsed: ${sw.elapsedMilliseconds} ms for $iterations iterations');
}
```

Running the benchmarks

- Non-Flutter (pure Dart):
  dart run docs/examples/benchmarks/bench_main.dart

- Flutter: embed the bench in a minimal app and run with `flutter run --profile`.

CI integration

- Add optional benchmark steps that run on a schedule (nightly) to detect regressions.

If you want, I can add a ready-to-run bench_main.dart that exercises the interpolate/color/sequence/repeat hot paths and prints timings.