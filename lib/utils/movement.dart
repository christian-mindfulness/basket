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

  Movement.fromJson(Map<String, dynamic> json) :
      allow = json['allow'],
      position = Vector2(json['position.x'], json['position.y']),
      time = json['time'],
      angle = json['angle'];

  Map<String, dynamic> toJson() => {
    'allow': allow,
    'position.x': position.x,
    'position.y': position.y,
    'time': time,
    'angle': degrees(angle),
  };
}