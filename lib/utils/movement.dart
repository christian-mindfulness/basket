import 'package:flame/components.dart';

class Movement {
  bool allow;
  Vector2 position;
  double time;
  double angle;
  Movement({required this.allow, required this.position, required this.time, required this.angle});

  void set(bool newAllow,
      Vector2 newOther,
      double newTime,
      double newAngle) {
    allow = newAllow;
    if (newAllow) {
      position = newOther;
      time = newTime;
      angle = newAngle;
    }
  }
}