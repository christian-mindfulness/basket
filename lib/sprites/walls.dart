import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../utils/clone_list.dart';

class Wall extends MovementSprite
    with CollisionCallbacks {
  final hitBox = RectangleHitbox();
  final Map<BallType, double> _coefficient = const {
    BallType.basket: 0.7,
    BallType.beach: 0.7,
    BallType.metal: 0.7,
    BallType.tennis: 0.7,
  };
  late List<Vector2> oldGlobalVertices;

  Wall({
    required super.startPosition,
    required super.size,
    super.startAngle,
  }) : super() {
    oldGlobalVertices = List<Vector2>.from(hitBox.globalVertices());
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    var wall = await Sprite.load('game/wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  double getCoefficient(BallType ballType) {
    return _coefficient[ballType]!;
  }

  @override
  String getName() {
    return "Wall";
  }

  @override
  void update(double dt) {
    oldGlobalVertices = cloneList(hitBox.globalVertices());
    super.update(dt);
  }

  Wall.fromJson(Map<String, dynamic> json) :
        super.fromJson(json)
  {
    oldGlobalVertices = List<Vector2>.from(hitBox.globalVertices());
  }
}


class BrickWall extends Wall {
  BrickWall({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    var wall = await Sprite.load('game/brick_wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  @override
  double getCoefficient (BallType ballType) {
    const Map<BallType, double> coefficient = {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.8,
      BallType.tennis: 0.7,
    };
    return coefficient[ballType]!;
  }

  BrickWall.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {
    return "Brick Wall";
  }
}

class WoodWall extends Wall {
  WoodWall({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    var wall = await Sprite.load('game/wood_wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  @override
  double getCoefficient (BallType ballType) {
    const Map<BallType, double> coefficient = {
      BallType.basket: 0.7,
      BallType.beach: 0.7,
      BallType.metal: 0.5,
      BallType.tennis: 0.7,
    };
    return coefficient[ballType]!;
  }
  WoodWall.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {
    return "Wood Wall";
  }
}

class Slime extends Wall {
  Slime({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    var wall = await Sprite.load('game/slime.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  @override
  double getCoefficient (BallType ballType) {
    const Map<BallType, double> coefficient = {
      BallType.basket: 0.3,
      BallType.beach: 0.3,
      BallType.metal: 0.3,
      BallType.tennis: 0.3,
    };
    return coefficient[ballType]!;
  }

  Slime.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {
    return "Slime";
  }
}

class Trampoline extends Wall {
  Trampoline({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    var wall = await Sprite.load('game/trampoline.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  Trampoline.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  double getCoefficient (BallType ballType) {
    const Map<BallType, double> coefficient = {
      BallType.basket: 1.1,
      BallType.beach: 1.1,
      BallType.metal: 1.1,
      BallType.tennis: 1.1,
    };
    return coefficient[ballType]!;
  }

  @override
  String getName() {
    return "Trampoline";
  }
}


class OneWayPlatform extends Wall {
  OneWayPlatform({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    var wall = await Sprite.load('game/one_way_platform.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  OneWayPlatform.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {
    return "OneWayPlatform";
  }
}
