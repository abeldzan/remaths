Getting started

This short guide helps you build the package locally, run the example snippets, and execute the microbenchmarks we use for performance testing.

Prerequisites

- Flutter SDK (if you run the Flutter example) or Dart SDK for pure-Dart tests.
- A terminal with `flutter` / `dart` on PATH.

Build & run examples

1. Open the project root in your IDE (VS Code, IntelliJ, etc.).
2. To run the minimal examples in `docs/examples` open the corresponding `main.dart` or run the example harness described there.

Running analyzer & tests

- Static analysis:

  flutter analyze

- Unit tests (Dart or Flutter tests):

  flutter test

Microbenchmarks

We keep a simple Stopwatch-based harness under `docs/examples/benchmarks`. The harness demonstrates how to measure the hot paths (interpolate, color/offset interpolation, sequence/repeat). To run a Dart-based benchmark (non-Flutter) use:

  dart run docs/examples/benchmarks/bench_main.dart

To run a Flutter benchmark, create a small `flutter` app that imports the benchmark harness and runs it in `main()`.

If you want, I can add runnable Dart/Flutter benchmark files to the repo.