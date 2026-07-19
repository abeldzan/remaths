part of v2.core;

// Lightweight, allocation-reduced interpolate implementation.
// Improvements:
// - Avoid map/toList and temporary lists where possible.
// - Allow callers to supply precomputed numeric input/output lists (inputVals/outputVals)
//   to reuse across multiple channel interpolations (used by color/offset helpers).
// - Validate input order without creating a sorted copy.

double _interpolate(
  dynamic value,
  List<dynamic> inputRange,
  List<dynamic> outputRange, {
  Extrapolate extrapolate = Extrapolate.extend,
  Extrapolate? rightExtrapolate,
  List<double>? inputVals,
  List<double>? outputVals,
}) {
  final val = getValue(value).toDouble();

  final int len = inputRange.length;
  assert(
    len == outputRange.length,
    "The length of inputRange must be equal to the outputRange",
  );
  assert(
    len > 1,
    "The length of the input must be 2 or more",
  );

  // Populate numeric arrays only if caller didn't provide them.
  final List<double> input = inputVals ?? List<double>.filled(len, 0.0);
  final List<double> output = outputVals ?? List<double>.filled(len, 0.0);

  if (inputVals == null || outputVals == null) {
    for (var i = 0; i < len; i++) {
      if (inputVals == null) input[i] = getValue(inputRange[i]).toDouble();
      if (outputVals == null) output[i] = getValue(outputRange[i]).toDouble();
    }
  }

  // Verify non-decreasing order without extra allocation (equal adjacent entries allowed).
  for (var i = 1; i < len; i++) {
    assert(input[i] >= input[i - 1], "Increasing error");
  }

  int index = 0;
  if (val < input.first) {
    // index 0
  } else if (val > input.last) {
    index = len - 2;
  } else {
    // linear search; fast for small lists and avoids temporary allocations
    for (var i = 1; i < len; i++) {
      if (input[i] > val) {
        index = i - 1;
        break;
      }
    }
  }

  double singleInterpolate(int offset) {
    final inS = input[offset];
    final inE = input[offset + 1];
    final outS = output[offset];
    final outE = output[offset + 1];
    if (inS == inE) return val <= inS ? outS : outE;
    final progress = (val - inS) / (inE - inS);
    return outS + (progress * (outE - outS));
  }

  var res = singleInterpolate(index);

  final left = extrapolate;
  final right = rightExtrapolate ?? extrapolate;

  if (left != Extrapolate.extend) {
    if (left == Extrapolate.clamp) {
      res = val < input.first ? output.first : res;
    } else if (left == Extrapolate.identity) {
      res = val < input.first ? val : res;
    }
  }

  if (right != Extrapolate.extend) {
    if (right == Extrapolate.clamp) {
      res = val > input.last ? output.last : res;
    } else if (right == Extrapolate.identity) {
      res = val > input.last ? val : res;
    }
  }

  return res;
}

_interpolateColor(
  dynamic value,
  List<dynamic> inputRange,
  List<Color> outputRange,
) {
  final int len = outputRange.length;
  if (len == 0) return Color(0);

  // Precompute numeric input once and channel outputs in one pass (no map/alloc per channel).
  final inputVals = List<double>.filled(inputRange.length, 0.0);
  for (var i = 0; i < inputRange.length; i++) {
    inputVals[i] = getValue(inputRange[i]).toDouble();
  }

  final reds = List<double>.filled(len, 0.0);
  final greens = List<double>.filled(len, 0.0);
  final blues = List<double>.filled(len, 0.0);
  final alphas = List<double>.filled(len, 0.0);

  for (var i = 0; i < len; i++) {
    final c = outputRange[i];
    reds[i] = c.red.toDouble();
    greens[i] = c.green.toDouble();
    blues[i] = c.blue.toDouble();
    alphas[i] = c.alpha.toDouble();
  }

  int comp(List<double> outputs) {
    return _interpolate(
      value,
      inputRange,
      outputs,
      extrapolate: Extrapolate.clamp,
      inputVals: inputVals,
      outputVals: outputs,
    ).round();
  }

  return Color.fromARGB(
    comp(alphas),
    comp(reds),
    comp(greens),
    comp(blues),
  );
}

Offset _interpolateOffset(
  Offset value,
  List<Offset> inputRange,
  List<Offset> outputRange, {
  Extrapolate extrapolate = Extrapolate.extend,
  Extrapolate? rightExtrapolate,
}) {
  final int len = inputRange.length;
  final inputDx = List<double>.filled(len, 0.0);
  final inputDy = List<double>.filled(len, 0.0);
  for (var i = 0; i < len; i++) {
    inputDx[i] = getValue(inputRange[i].dx).toDouble();
    inputDy[i] = getValue(inputRange[i].dy).toDouble();
  }

  final outDx = List<double>.filled(len, 0.0);
  final outDy = List<double>.filled(len, 0.0);
  for (var i = 0; i < len; i++) {
    outDx[i] = getValue(outputRange[i].dx).toDouble();
    outDy[i] = getValue(outputRange[i].dy).toDouble();
  }

  return Offset(
    _interpolate(value.dx, inputRange, outDx,
        inputVals: inputDx, outputVals: outDx),
    _interpolate(value.dy, inputRange, outDy,
        inputVals: inputDy, outputVals: outDy),
  );
}
