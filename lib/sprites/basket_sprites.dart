import 'package:flame/components.dart';

class BasketSprite extends SpriteGroupComponent {
  BasketSprite({
    required super.position,
    required Vector2 size,
    double angle = 0,
    int priority = 1,
  }) : super(
    size: size,
    priority: priority,
    angle: radians(angle),
    anchor: Anchor.center,
  );

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
