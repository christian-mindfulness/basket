import 'package:flame/components.dart';

class LevelOptions {

  Vector2 gravity;
  double flickPower;
  double flickCoolDown;
  double flickMaximum;
  double airResistance;

  LevelOptions({
    required this.gravity,
    this.flickPower = 100,
    this.flickCoolDown = 1,
    this.flickMaximum = 100,
    this.airResistance = 100,
  });

  void resetToDefault() {
    gravity = Vector2(0, 10);
    flickPower = 100;
    flickCoolDown = 1;
    flickMaximum = 100;
    airResistance = 100;
  }

  LevelOptions.fromJson(Map<String, dynamic> json) :
      gravity = Vector2(json['gravity.x'], json['gravity.y']),
      flickPower = json['flickPower'],
      flickMaximum = json['flickMaximum'],
      flickCoolDown = json['flickCoolDown'],
      airResistance = json['airResistance'];

  Map<String, dynamic> toJson() {
    return {
      'gravity.x': gravity.x,
      'gravity.y': gravity.y,
      'flickPower': flickPower,
      'flickMaximum': flickMaximum,
      'flickCoolDown': flickCoolDown,
      'airResistance': airResistance,
    };
  }
}