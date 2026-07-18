part of v2.core;

double _interpolate(
  value,
  List<dynamic> inputRange,
  List<dynamic> outputRange, {
  Extrapolate extrapolate = Extrapolate.extend,
  Extrapolate? rightExtrapolate,
}) {
  final val = getValue(value).toDouble();

  // Convert ranges to numeric lists once to avoid repeated allocations.
  final input = inputRange.map((e) => getValue(e).toDouble()).toList();
  final output = outputRange.map((e) => getValue(e).toDouble()).toList();

  assert(
    input.length == output.length,
    "The length of inputRange must be equal to the outputRange",
  );
  assert(
    input.length > 1,
    "The length of the input must be 2 or more",
  );

  // Ensure input is non-decreasing without allocating a sorted copy.
  for (var i = 1; i < input.length; i++) {
    assert(input[i] >= input[i - 1], "Increasing error");
  }

  double singleInterpolate(double val_, List<double> input_, List<double> output_, int offset) {
    final inS = input_[offset];
    final inE = input_[offset + 1];
    final outS = output_[offset];
    final outE = output_[offset + 1];
    if (inS == inE) return cond(val_ <= inS, outS, outE);
    final progress = (val_ - inS) / (inE - inS);
    return outS + (progress * (outE - outS));
  }

  final left = extrapolate;
  final right = (defined(rightExtrapolate) ? rightExtrapolate : extrapolate)!;

  var index = 0;
  if (val < input.first) {
    // leave index = 0
  } else if (val > input.last) {
    index = input.length - 2;
  } else {
    for (var i = 1; i < input.length; i++) {
      index = i - 1;
      if (input[i] > val) break;
    }
  }

  var res = singleInterpolate(val, input, output, index);

  if (left != Extrapolate.extend) {
    if (left == Extrapolate.clamp) {
      res = cond(val < input.first, output.first, res);
    } else if (left == Extrapolate.identity) {
      res = cond(val < input.first, val, res);
    }
  }

  if (right != Extrapolate.extend) {
    if (right == Extrapolate.clamp) {
      res = cond(val > input.last, output.last, res);
    } else if (right == Extrapolate.identity) {
      res = cond(val > input.last, val, res);
    }
  }

  return res;
}

_interpolateColor(
  dynamic value,
  List<dynamic> inputRange,
  List<Color> outputRange,
) {
  // Build component lists once (faster than multiple map calls per channel).
  final len = outputRange.length;
  final reds = List<int>.generate(len, (i) => outputRange[i].red);
  final greens = List<int>.generate(len, (i) => outputRange[i].green);
  final blues = List<int>.generate(len, (i) => outputRange[i].blue);
  final alphas = List<int>.generate(len, (i) => outputRange[i].alpha);

  int getComponent(List<int> components) {
    return _interpolate(
      value,
      inputRange,
      components,
      extrapolate: Extrapolate.clamp,
    ).round();
  }

  return Color.fromARGB(
    getComponent(alphas),
    getComponent(reds),
    getComponent(greens),
    getComponent(blues),
  );
}

Offset _interpolateOffset(
  Offset value,
  List<Offset> inputRange,
  List<Offset> outputRange, {
  Extrapolate extrapolate = Extrapolate.extend,
  Extrapolate? rightExtrapolate,
}) {
  // Prepare separate numeric lists for x/y once to avoid duplicate mapping.
  final inputXs = inputRange.map((e) => e.dx).toList();
  final outputXs = outputRange.map((e) => e.dx).toList();
  final inputYs = inputRange.map((e) => e.dy).toList();
  final outputYs = outputRange.map((e) => e.dy).toList();

  return Offset(
    _interpolate(value.dx, inputXs, outputXs,
        extrapolate: extrapolate, rightExtrapolate: rightExtrapolate),
    _interpolate(value.dy, inputYs, outputYs,
        extrapolate: extrapolate, rightExtrapolate: rightExtrapolate),
  );
}
