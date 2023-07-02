import 'package:flame/components.dart';

class LevelOptions {
  final Vector2 gravity;
  final double flickPower;
  final double flickCoolDown;
  final double flickMaximum;
  final double airResistance;

  LevelOptions({
    required this.gravity,
    this.flickPower = 3,
    this.flickCoolDown = 1,
    this.flickMaximum = 500,
    this.airResistance = 1,
  });

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