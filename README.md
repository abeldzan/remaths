**Table of Contents**

- [Project](#project)
- [Quick start](#quick-start)
- [Installation](#installation)
- [Basic usage](#basic-usage)
- [API highlights](#api-highlights)
- [Migration from v1](#migrating-from-v1)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

# remaths

remaths is a small Flutter package that makes animations, interpolations and animation helpers easier to use by providing a lightweight SharedValue abstraction and a set of animation functions (timing, spring, sequence, repeat, delay) plus interpolation and helper utilities.

This README improves discoverability and adds a concise quick-start and examples while keeping the original reference details.

## Quick start

Add remaths to your project and import it:

```bash
flutter pub add remaths
```

```dart
import 'package:remaths/remaths.dart';
```

## Installation

Alternatively add to your pubspec.yaml:

```yaml
dependencies:
  remaths: ^2.0.0
```

Run `flutter pub get` to install.

## Basic usage

- Use a StatefulWidget that mixes in TickerStateProviderMixin (or another vsync provider).
- Create a SharedValue and update it with animation helper functions.

```dart
class MyWidgetState extends State<MyWidget> with TickerStateProviderMixin {
  late SharedValue<double> opacity;

  @override
  void initState() {
    super.initState();
    opacity = SharedValue(0.0, this);
  }

  void fadeOut() {
    opacity.value = withTiming(0.0, duration: 300, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    // use opacity.value in your build
    return Container();
  }
}
```

## API highlights

- SharedValue<T>
  - Create: `SharedValue(0.0, vsync: this)` or `0.0.asSharedValue(this)`
  - Update with animation functions: `value = withTiming(...)`, `value = withSpring(...)`, `value = withSequence([...])`, `value = withRepeat(...)`, `value = withDelay(...)`
  - Helpers: `interpolate`, `interpolateColor`, `interpolateOffset` and math/logical helpers that accept SharedValue directly.

- Animation functions
  - withTiming(to, duration, curve, from, onComplete)
  - withSpring(to, duration, velocity, mass, stiffness, damping, onComplete)
  - withSequence(list, onComplete)
  - withRepeat(animation, reps, reverse, from, onComplete)
  - withDelay(animation, ms)

- Interpolation
  - interpolate(value, inputRange, outputRange, extrapolate, rightExtrapolate)
  - interpolateColor(value, inputRange, colors)
  - interpolateOffset(value, inputRange, outputRange)

- Helpers (examples)
  - cond(condition, ifBlock, [elseBlock])
  - range(stop, {start, step})
  - random(start, end, decimal)
  - clamp(value, min, max)
  - diff(value), diffClamp(value)
  - toRad, toDeg
  - logical: lessThan, greaterThan, eq, neq, and/or
  - maths & trig: add, subtract, multiply, divide, floor, ceil, round, abs, pow, sqrt, sin, cos, tan, acos, asin, atan, log

For full reference see the API docs: https://pub.dev/documentation/remaths/latest/remaths/remaths-library.html

## Migrating from v1

The main breaking change is renaming Tweenable to SharedValue.

OLD:
```dart
opacity = Tweenable(0.0, this);
// OR
opacity = 0.asTweenable(this);
```

NOW:
```dart
opacity = SharedValue(0.0, vsync: this);
// OR
opacity = 0.asSharedValue(this);
```

## Examples

Simple timing animation

```dart
opacity.value = withTiming(1.0, duration: 200);
```

Sequence example

```dart
width.value = withSequence([withTiming(20), withSpring(40)], () => print('done'));
```

Repeat example

```dart
y.value = withRepeat(withSpring(20.0), reps: 3);
```

Interpolation example

```dart
final yOffset = interpolate(opacity, [0, 1], [100.0, 0.0]);
// opacity: 0 -> yOffset 100, 1 -> yOffset 0
```

Color interpolation

```dart
final color = interpolateColor(opacity, [0, 1], [Colors.red, Colors.green]);
```

Helpers example

```dart
final isOpen = cond(greaterThan(x, 0.5), 1.0, 0.0);
final r = random(0, 1, 2);
```

## Contributing

Contributions welcome — open an issue or PR on the repository: https://github.com/AbelBlossom/remaths

- Follow the existing style.
- Add tests where relevant (package contains `test/`).
- Run `flutter test` before submitting.

## License

This project is MIT licensed — see the LICENSE file for details.

---

(Original README content retained as reference in the repository history.)
