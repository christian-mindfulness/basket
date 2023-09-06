import 'package:flame/components.dart';

import '../utils/movement.dart';
import '../utils/time_and_velocity.dart';
import '../utils/update_position.dart';

class BasketSprite extends SpriteGroupComponent {
  BasketSprite({
    required super.position,
    required Vector2 size,
    double angle = 0,
    int priority = 1,
  }) : super(
    size: size,
    priority: priority,
    angle: angle,
    anchor: Anchor.center,
  ) {
    print('Called super.angle with $angle');
  }

  String getName() {
    return "Unknown";
  }

  BasketSprite.fromJson(Map<String, dynamic> json) {
    position.x = json['position.x'];
    position.y = json['position.y'];
    size.x = json['size.x'];
    size.y = json['size.y'];
    angle = json['angle'];
  }

  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': angle,
  };
}


class MovementSprite extends BasketSprite {
  double timeSinceStart = 0;
  Vector2 startPosition;
  double startAngle;
  double localDT = 0.01;
  Movement movement = Movement(
      allow: false,
      position: Vector2(0,0),
      time: 1,
      angle: 0,
      continuousAngle: false
  );

  MovementSprite({
    required this.startPosition,
    required Vector2 size,
    this.startAngle = 0,
    super.priority = 3,
  }) :
      super(
        position: startPosition,
        size: size,
        angle: startAngle,
      );

  MovementSprite.fromJson(Map<String, dynamic> json) :
        movement = Movement.fromJson(json['movement']),
        startPosition = Vector2(json['position.x'], json['position.y']),
        startAngle = json['angle'],
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']);

  @override
  void update(double dt) {
    localDT = dt;
    timeSinceStart += dt;
    TimeAndVelocity timeAndVelocity = updatePosition(movement, timeSinceStart, startPosition, startAngle);
    position = timeAndVelocity.velocity;
    angle = timeAndVelocity.time;
    super.update(dt);
  }

  @override
  Map<String, dynamic> toJson() => {
    'position.x': startPosition.x,
    'position.y': startPosition.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': startAngle,
    'movement': movement.toJson(),
  };

  @override
  String toString() {
    return '${getName()} position = $startPosition  size = $size  angle = ${degrees(angle)}  movement = $movement';
  }

}