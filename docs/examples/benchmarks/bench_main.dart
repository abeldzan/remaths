// Simple micro-benchmark harness
// Usage:
//  - From the project root run:
//      dart run docs/examples/benchmarks/bench_main.dart
//  - Edit the `bench()` calls in main() to benchmark target functions.
//  - To benchmark functions from the package sources, add a relative import such as:
//      import '../../../lib/v2/core/src/animation/interpolate.dart' as interp;
//    and then call interp.someFunction(...) inside a bench closure.

import 'dart:math';
import 'dart:core';

typedef BenchFn = void Function();

void bench(String name, BenchFn fn, int iterations, {int warmup = 1000}) {
  // Warm-up
  for (int i = 0; i < warmup; i++) {
    fn();
  }

  // Measure
  final sw = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    fn();
  }
  sw.stop();

  final totalMs = sw.elapsedMilliseconds;
  final avgNs = (sw.elapsedMicroseconds * 1000) / iterations;

  print('BENCH: $name');
  print('  iterations : $iterations');
  print('  total ms   : $totalMs');
  print('  avg ns/op  : ${avgNs.toStringAsFixed(1)}');
  print('');
}

// Example lightweight micro-workloads. Replace or extend these with calls
// to the actual functions you want to benchmark (interpolate, color/palette
// helpers, sequence/repeat runners, controller reset paths, etc.).

void main() {
  const iterations = 200000;

  // Example 1: math-heavy microbenchmark
  bench('math.sqrt loop', () {
    double s = 0.0;
    for (int i = 1; i <= 10; i++) {
      s += sqrt(i.toDouble());
    }
    // Use s so the compiler doesn't optimize the loop away
    if (s.isNaN) print('unreachable');
  }, iterations);

  // Example 2: small allocation test
  bench('allocate-list-10', () {
    final List<double> a = List<double>.generate(10, (i) => i.toDouble());
    double t = 0.0;
    for (final v in a) t += v;
    if (t.isNaN) print('unreachable');
  }, iterations);

  // Example 3: how to benchmark an interpolate function from the package
  // 1) Uncomment the import at the top of this file (relative path):
  //      import '../../../lib/v2/core/src/animation/interpolate.dart' as interp;
  // 2) Replace the following closure with a real call to your interpolate API.
  // bench('interpolate (placeholder)', () {
  //   // example: interp.interpolate(0.5, [0,1], [10,20]);
  // }, iterations);

  print('Benchmarks complete');
}
