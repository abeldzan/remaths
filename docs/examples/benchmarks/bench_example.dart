// Bench example for interpolation functions.
// Run with:
//   dart run docs/examples/benchmarks/bench_example.dart

import 'dart:ui';
import 'dart:math';

import '../../../lib/v2/core/core.dart' as core;

typedef BenchFn = void Function();

void bench(String name, BenchFn fn, int iterations, {int warmup = 1000}) {
  for (int i = 0; i < warmup; i++) fn();
  final sw = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) fn();
  sw.stop();
  final avgNs = (sw.elapsedMicroseconds * 1000) / iterations;
  print('BENCH: $name -> avg ns/op: ${avgNs.toStringAsFixed(1)} (iterations: $iterations)');
}

void main() {
  const iterations = 100000;

  bench('interpolate scalar', () {
    final v = core.interpolate(0.37, [0, 0.5, 1.0], [10, 20, 40]);
    if (v.isNaN) print('bad');
  }, iterations);

  bench('interpolate color', () {
    final c = core.interpolateColor(
      0.37,
      [0, 0.5, 1.0],
      [Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF)],
    );
    if (c.value == 0) print('bad');
  }, iterations);

  bench('interpolate offset', () {
    final o = core.interpolateOffset(
      const Offset(0.37, 0.63),
      [const Offset(0, 0), const Offset(1, 1)],
      [const Offset(10, 20), const Offset(20, 10)],
    );
    if (o.dx.isNaN) print('bad');
  }, iterations);

  print('bench example complete');
}
