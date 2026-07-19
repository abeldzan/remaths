
import '../core/core.dart';
import 'dart:math' as math;

// Reusable Random instance to avoid allocating a new Random on every call.
final math.Random _random = math.Random();

double getValue(dynamic data) {
  assert(
    data is SharedValue || data is num || data is double,
    "Value Must be a SharedValue or a number, got ${data.runtimeType}",
  );
  // print(data is num);
  return data is SharedValue ? data.value : (data as num).toDouble();
}

/// add [a] to [b] <br>
/// values
double add(dynamic a, dynamic b) => (getValue(a) + getValue(b)).toDouble();

double multiply(dynamic a, dynamic b) => (getValue(a) * getValue(b)).toDouble();

double divide(dynamic a, dynamic b) => (getValue(a) / getValue(b)).toDouble();

double sub(dynamic a, dynamic b) => (getValue(a) - getValue(b)).toDouble();

double pow(dynamic a, dynamic b) =>
    (math.pow(getValue(a), getValue(b))).toDouble();

double sqrt(dynamic a) => math.sqrt(getValue(a));

double modulo(dynamic a, dynamic b) =>
    (((getValue(a) % getValue(b)) + getValue(b)) % getValue(b)).toDouble();

double log(dynamic a) => math.log(getValue(a));

double sin(dynamic a) => math.sin(getValue(a));

double tan(dynamic a) => math.tan(getValue(a));

double atan(dynamic a) => math.atan(getValue(a));

double asin(dynamic a) => math.asin(getValue(a));

double acos(dynamic a) => math.acos(getValue(a));

double exp(dynamic a) => math.exp(getValue(a));

int round(dynamic a) => getValue(a).round();

int floor(dynamic a) => getValue(a).floor();

int ceil(dynamic a) => getValue(a).ceil();

min<T extends num>(dynamic a, dynamic b) =>
    math.min(getValue(a) as T, getValue(b) as T);

T max<T extends num>(dynamic a, dynamic b) =>
    math.max<T>(getValue(a) as T, getValue(b) as T);

num abs(dynamic a) => getValue(a).abs();

double toRad(dynamic a) => getValue(a) * math.pi / 180;

double toDeg(dynamic a) => getValue(a) * 180 / math.pi;

bool defined(a) => a != null;

bool or(bool a, bool b) => a || b;

cond(bool condition, ifBlock, [elseBlock]) {
  if (condition) {
    if (ifBlock is Function) return ifBlock();
    return ifBlock;
  } else {
    if (defined(elseBlock)) {
      if (elseBlock is Function) return elseBlock();
      return elseBlock;
    }
    return;
  }
}

bool lessThan(a, b) => getValue(a) < getValue(b);

bool greaterThan(a, b) => getValue(a) > getValue(b);

bool eq(a, b) => getValue(a) == getValue(b);

bool neq(a, b) => getValue(a) != getValue(b);

bool lessOrEq(a, b) => getValue(a) <= getValue(b);

bool greaterOrEq(a, b) => getValue(a) >= getValue(b);

double decimalRound(dynamic a, dynamic dec) {
  final aVal = getValue(a);
  final decVal = getValue(dec).toInt();
  assert(decVal >= 0, "decimal must be 0 or greater");
  if (decVal == 0) return aVal.round().toDouble();
  final factor = math.pow(10, decVal).toDouble();
  return (aVal * factor).round() / factor;
}

double random([int start = 0, int end = 1, int decimal = 1]) {
  final minV = math.min(start, end);
  final maxV = math.max(start, end);
  if (minV == maxV) return decimalRound(minV.toDouble(), decimal);
  final value = _random.nextDouble() * (maxV - minV) + minV;
  return decimalRound(value, decimal);
}

List<num> range(dynamic stop, {dynamic start = 0, dynamic step = 1}) {
  final start_ = getValue(start).toInt();
  final stop_ = getValue(stop).toInt();
  final step_ = getValue(step).toInt();
  assert(step_ != 0, "step cannot be 0");

  final result = <num>[];
  if (step_ > 0) {
    for (var i = start_; i < stop_; i += step_) {
      result.add(i);
    }
  } else {
    for (var i = start_; i > stop_; i += step_) {
      result.add(i);
    }
  }
  return result;
}

T call<T>(T Function() func) {
  return func();
}

double clamp(dynamic value, dynamic min_, dynamic max_) =>
    max(min(value, max_), min_);

double diff(SharedValue value) => value.diff;

double diffClamp(SharedValue value, num min_, num max_) =>
    clamp(add(value, value.diff), min_, max_);
