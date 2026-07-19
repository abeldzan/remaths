part of v2.core;

NodeFunc repeatAnimation(
  NodeFunc animation, {
  int reps = 2,
  bool reverse = false,
  void Function()? onComplete,
  num? from,
}) {
  return (node) {
    node._meta._lock.value = true;
    final start = from == null ? node.value : from.toDouble();
    node._setValue(start);

    // Use an explicit loop state instead of nested closures to reduce allocations.
    int index = reps;

    void startStep() {
      if (index <= 0) {
        node._meta._lock.value = false;
        if (onComplete != null) onComplete();
        return;
      }

      if (index == 1) {
        node._meta.completeListener = null;
        node.value = timingAnimation(start,
            duration: node._meta.duration,
            curve: node._meta.curve, onComplete: () {
          index = 0;
          startStep();
        });
        return;
      }

      // Prepare the completion listener for the current step.
      node._meta.completeListener = () {
        if (reverse) {
          if (index == 2) {
            index = 0;
            startStep();
            return;
          }
          index -= 1;
          node._meta.completeListener = () => startStep();
          node.value = timingAnimation(
            start,
            duration: node._meta.duration,
            curve: node._meta.curve,
          );
        } else {
          if (index != 2) {
            node.value = start;
          }
          index -= 1;
          startStep();
        }
      };

      // Execute the given animation for this step.
      animation(node);
    }

    startStep();
  };
}
