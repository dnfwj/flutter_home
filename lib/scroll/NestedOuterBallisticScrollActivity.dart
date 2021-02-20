import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NestedScrollCoordinator.dart';
import 'NestedScrollMetrics.dart';
import 'NestedScrollPosition.dart';

class NestedOuterBallisticScrollActivity extends BallisticScrollActivity {
  NestedOuterBallisticScrollActivity(
      this.coordinator,
      NestedScrollPosition position,
      this.metrics,
      Simulation simulation,
      TickerProvider vsync,
      ) : assert(metrics.minRange != metrics.maxRange),
        assert(metrics.maxRange > metrics.minRange),
        super(position, simulation, vsync);

  final NestedScrollCoordinator coordinator;
  final NestedScrollMetrics metrics;

  @override
  NestedScrollPosition get delegate => super.delegate as NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(
        coordinator.createOuterBallisticScrollActivity(velocity)
    );
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(
        coordinator.createOuterBallisticScrollActivity(velocity)
    );
  }

  @override
  bool applyMoveTo(double value) {
    bool done = false;
    if (velocity > 0.0) {
      if (value < metrics.minRange)
        return true;
      if (value > metrics.maxRange) {
        value = metrics.maxRange;
        done = true;
      }
    } else if (velocity < 0.0) {
      if (value > metrics.maxRange)
        return true;
      if (value < metrics.minRange) {
        value = metrics.minRange;
        done = true;
      }
    } else {
      value = value.clamp(metrics.minRange, metrics.maxRange) as double;
      done = true;
    }
    final bool result = super.applyMoveTo(value + metrics.correctionOffset);
    assert(result); // since we tried to pass an in-range value, it shouldn't ever overflow
    return !done;
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'NestedOuterBallisticScrollActivity')}(${metrics.minRange} .. ${metrics.maxRange}; correcting by ${metrics.correctionOffset})';
  }
}