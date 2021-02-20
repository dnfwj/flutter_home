import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'NestedScrollCoordinator.dart';
import 'NestedScrollPosition.dart';


class NestedScrollController extends ScrollController {
  NestedScrollController(
      this.coordinator, {
        double initialScrollOffset = 0.0,
        String debugLabel,
      }) : super(initialScrollOffset: initialScrollOffset, debugLabel: debugLabel);

  final NestedScrollCoordinator coordinator;

  @override
  ScrollPosition createScrollPosition(
      ScrollPhysics physics,
      ScrollContext context,
      ScrollPosition oldPosition,
      ) {
    return NestedScrollPosition(
      coordinator: coordinator,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  void attach(ScrollPosition position) {
    assert(position is NestedScrollPosition);
    super.attach(position);
    coordinator.updateParent();
    coordinator.updateCanDrag();
    position.addListener(_scheduleUpdateShadow);
    _scheduleUpdateShadow();
  }

  @override
  void detach(ScrollPosition position) {
    assert(position is NestedScrollPosition);
    position.removeListener(_scheduleUpdateShadow);
    super.detach(position);
    _scheduleUpdateShadow();
  }

  void _scheduleUpdateShadow() {
    // We do this asynchronously for attach() so that the new position has had
    // time to be initialized, and we do it asynchronously for detach() and from
    // the position change notifications because those happen synchronously
    // during a frame, at a time where it's too late to call setState. Since the
    // result is usually animated, the lag incurred is no big deal.
    SchedulerBinding.instance.addPostFrameCallback(
            (Duration timeStamp) {
          coordinator.updateShadow();
        }
    );
  }

  Iterable<NestedScrollPosition> get nestedPositions sync* {
    // TODO(vegorov): use instance method version of castFrom when it is available.
    yield* Iterable.castFrom<ScrollPosition, NestedScrollPosition>(positions);
  }
}
