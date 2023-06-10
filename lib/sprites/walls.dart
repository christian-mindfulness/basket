import 'package:basket/sprites/basket_sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Wall extends BasketSprite
    with CollisionCallbacks {
  final hitBox = RectangleHitbox();
  final double coefficient;

  Wall({
    required super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
  );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    var wall = await Sprite.load('game/wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  double getCoefficient() {
    return coefficient;
  }

  @override
  String getName() {
    return "Wall";
  }

  Wall.fromJson(Map<String, dynamic> json) : coefficient = 0.7,
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']);

  @override
  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': degrees(angle),
  };
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
    var wall = await Sprite.load('game/brick_wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  BrickWall.fromJson(Map<String, dynamic> json) : super.fromJson(json);

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
    var wall = await Sprite.load('game/wood_wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  WoodWall.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {
    return "Wood Wall";
  }
}