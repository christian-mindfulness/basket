import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Wall extends SpriteComponent
    with CollisionCallbacks {
  final hitBox = RectangleHitbox();
  final double coefficient;

  Wall({
    super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
    anchor: Anchor.center,
  );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    sprite = await Sprite.load('game/wall.png');
  }

  double getCoefficient() {
    return coefficient;
  }

  String getName() {
    return "Wall";
  }
}


class BrickWall extends Wall {
  BrickWall({super.position,
    required super.size,
    super.coefficient,
    super.angle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('game/brick_wall.png');
  }

  @override
  String getName() {
    return "Brick Wall";
  }
}

class WoodWall extends Wall {
  WoodWall({super.position,
    required super.size,
    super.coefficient,
    super.angle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('game/wood_wall.png');
  }

  @override
  String getName() {
    return "Wood Wall";
  }
}