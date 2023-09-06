import 'dart:math';

import 'package:basket/utils/movement.dart';
import 'package:basket/utils/time_and_velocity.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

TimeAndVelocity updatePosition(
    Movement movement,
    double timeSinceStart,
    Vector2 startPosition,
    double startAngle,
    ) {
  Vector2 position = startPosition;
  double angle = startAngle;

  if (movement.allow) {
    if (movement.time <= 0) {
      debugPrint('Time is zero, will not move $movement');
    } else {
      double weightToStart = _getWeight(timeSinceStart / movement.time);
      position = startPosition + movement.position * (1 - weightToStart);
      if (movement.continuousAngle) {
        angle = startAngle + timeSinceStart * movement.angle;
      } else {
        angle = startAngle + movement.angle * (1 - weightToStart);
      }
    }
  }
  return TimeAndVelocity(time: angle, velocity: position);
}

double _getWeight(double time) {
  double result = 0.5;
  for (int order=1; order<14; order+=2) {
    result += 4 / pow(pi, 2) * pow(-1, (order-1)/2) * sin(pi * order * (time+0.5)) / pow(order, 2);
  }
  return result;
}