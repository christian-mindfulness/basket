import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../utils/movement.dart';

class Wall extends BasketSprite
    with CollisionCallbacks {
  final hitBox = RectangleHitbox();
  final Map<BallType, double> coefficient;
  Movement movement = Movement(
      allow: false,
      position: Vector2(0,0),
      time: 1,
      angle: 0
  );

  Wall({
    required super.position,
    required Vector2 size,
    this.coefficient = const {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.7,
      BallType.tennis: 0.7,
    },
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

  double getCoefficient(BallType ballType) {
    return coefficient[ballType]!;
  }

  @override
  String getName() {
    return "Wall";
  }

  Wall.fromJson(Map<String, dynamic> json) :
        coefficient = const {
          BallType.basket: 0.7,
          BallType.beach: 0.7,
          BallType.metal: 0.7,
          BallType.tennis: 0.7,
        },
        movement = Movement.fromJson(json['movement']),
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
    'movement': movement.toJson(),
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