import 'package:flutter/material.dart';

import 'NestedScrollCoordinator.dart';
import 'NestedScrollPosition.dart';



class NestedInnerBallisticScrollActivity extends BallisticScrollActivity {
  NestedInnerBallisticScrollActivity(
      this.coordinator,
      NestedScrollPosition position,
      Simulation simulation,
      TickerProvider vsync,
      ) : super(position, simulation, vsync);

  final NestedScrollCoordinator coordinator;

  @override
  NestedScrollPosition get delegate => super.delegate as NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  bool applyMoveTo(double value) {
    return super.applyMoveTo(coordinator.nestOffset(value, delegate));
  }
}
