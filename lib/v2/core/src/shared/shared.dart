part of v2.core;

typedef NodeFunc = void Function(Shared node);

typedef AnimationListener = void Function();

abstract class Shared {
  double? _prev;
  double _val;
  late ValueNotifier<double> _notifier;
  late ValueNotifier<AnimationStatus?> _status;
  late AnimationController controller;
  final TickerProvider vsync;
  bool _sequenceLocked = false;
  void Function()? _onComplete;
  late _AnimationInfo _meta;
  bool _isDisposed = false;

  Shared(this._val, {required this.vsync}) {
    _notifier = ValueNotifier(_val);
    _status = ValueNotifier(null);
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: _kDuration),
    );
    _meta = _AnimationInfo(
        curve: Curves.linear, duration: _kDuration, from: 0.0, to: 0.0);
  }

  _resetController(int? duration) {
    // Avoid disposing and recreating the controller to reduce overhead.
    // Just stop current animation and update duration.
    // If the controller was disposed, recreate it. Track disposed state to
    // avoid relying on exceptions for control flow.
    _stopCurrent();

    if (_isDisposed) {
      controller = AnimationController(
        vsync: vsync,
        duration: Duration(milliseconds: duration ?? _kDuration),
      );
      _isDisposed = false;
    }

    // Update duration in place when possible to avoid allocation.
    controller.duration = Duration(milliseconds: duration ?? _kDuration);

    // Reset and prepare the controller for use. If the controller has been
    // disposed unexpectedly, recreate as a defensive fallback.
    try {
      controller.reset();
    } catch (e) {
      controller = AnimationController(
        vsync: vsync,
        duration: Duration(milliseconds: duration ?? _kDuration),
      );
      _isDisposed = false;
    }
  }

  _statusListener(AnimationStatus status) {
    _status.value = status;
    if (status == AnimationStatus.completed) {
      _onComplete?.call();
      _meta.callComplete();
    }
  }

  _setAnimation(Animation<double> animation, [void Function()? onComplete]) {
    // Remove any previous listeners before attaching new ones to avoid leaks.
    _meta.removeListener();
    _meta.animation = animation;

    // Use a local function that avoids capturing outer scope variables
    // unnecessarily. This reduces closure allocations when this method is
    // called frequently.
    void _localListener() {
      _setValue(animation.value);
    }

    _meta.listener = _localListener;
    _onComplete = onComplete;
    _meta.animation?.addStatusListener(_statusListener);
    _meta.animation!.addListener(_meta.listener!);
  }

  double get value => _val;

  double operator +(dynamic other) => value + getValue(other);

  double operator -(dynamic other) => value - getValue(other);

  double operator /(dynamic other) => value / getValue(other);

  double operator *(dynamic other) => value * getValue(other);

  set status(AnimationStatus? status) {
    _status.value = status;
  }

  /// return the status of the currently running Animation
  AnimationStatus? get status => _status.value;

  set value(dynamic val) {
    assert(val is NodeFunc || num.tryParse(val.toString()) != null);
    if (_sequenceLocked) {
      _sequenceLocked = false;
    }

    _stopCurrent();
    _meta.completeListener = null;
    _meta.stopDelayed();

    val is NodeFunc ? val(this) : _setValue(val);
  }

  double get diff {
    if (_prev != null) {
      return _val - _prev!;
    }
    return 0.0;
  }

  _setValue(double val) {
    _prev = _val;
    _val = val;
    if (_prev != val) {
      _notifier.value = _val;
    }
  }

  ValueNotifier<double> get notifier => _notifier;

  dispose() {
    _stopCurrent();
    // Track disposed state so _resetController can avoid relying on
    // exceptions as control flow and know to recreate the controller later.
    try {
      controller.dispose();
    } finally {
      _isDisposed = true;
    }
    _notifier.dispose();
  }

  @protected
  _stopCurrent() {
    // Stopping a disposed controller can throw; guard against that.
    if (_isDisposed) return;
    controller.stop();
  }
}
