import 'package:flame/components.dart';

class Movement {
  bool allow;
  Vector2 position;
  double time;
  double angle;
  bool continuousAngle;
  Movement({
    required this.allow,
    required this.position,
    required this.time,
    required this.angle,
    required this.continuousAngle,
  });

  void set(bool newAllow,
      Vector2 newOther,
      double newTime,
      double newAngle,
      bool newContinuous) {
    allow = newAllow;
    if (newAllow) {
      position = newOther;
      time = newTime;
      angle = newAngle;
      continuousAngle = newContinuous;
    }
  }

  Movement.fromJson(Map<String, dynamic> json) :
      allow = json['allow'],
      position = Vector2(json['position.x'], json['position.y']),
      time = json['time'],
      angle = json['angle'],
      continuousAngle = json['continuousAngle'];

  Map<String, dynamic> toJson() => {
    'allow': allow,
    'position.x': position.x,
    'position.y': position.y,
    'time': time,
    'angle': angle,
    'continuousAngle': continuousAngle,
  };

  @override
  String toString() {
    return 'Movement: allow=$allow, position=$position, time=$time, angle=$angle, continuousAngle=$continuousAngle';
  }
}