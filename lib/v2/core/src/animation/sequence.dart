part of v2.core;

// Run a list of animations sequentially with minimal allocations.
// The previous implementation used nested closures and listeners per-step which
// caused allocations when running many short animations. This version uses an
// explicit index state and reuses a single lockListener callback where possible.
NodeFunc sequenceAnimation(List<NodeFunc> animations,
    {void Function()? onComplete}) {
  final anim = animations;
  return (node) {
    int index = 0;

    void step() {
      if (index >= anim.length) {
        if (onComplete != null) onComplete();
        return;
      }

      final current = anim[index];
      // Reset any previous completeListener to avoid capturing per-step closures
      node._meta.completeListener = null;

      // Run the animation for this step.
      current(node);

      if (node._meta._lock.value) {
        // The animation locked (likely using repeat/delay). Install a single lock listener
        // that advances the sequence when unlocked.
        node._meta.lockListener = () {
          if (!node._meta._lock.value) {
            node._meta.removeLockListener();
            index += 1;
            // next step will run after the current completes
            node._meta.completeListener = () {
              step();
            };
          }
        };
        return;
      }

      // If not locked, rely on completeListener to progress or advance immediately.
      if (node._meta.completeListener != null) {
        final prev = node._meta.completeListener;
        node._meta.completeListener = () {
          if (prev != null) prev();
          index += 1;
          step();
        };
      } else {
        // No async completion; advance synchronously.
        index += 1;
        step();
      }
    }

    step();
  };
}
