import 'package:basket/game/basket_game.dart';
import 'package:basket/sprites/basket_sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Spike extends BasketSprite
    with CollisionCallbacks {
  late final PolygonHitbox hitBox;
  final double coefficient;
  late final List<bool> deadlyVertices;

  Spike({
    super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
  ) {
    hitBox = PolygonHitbox.relative([Vector2(-0.5, 0.5),Vector2(0, -0.5),Vector2(0.5, 0.5),], parentSize: size);
    deadlyVertices = [false, true, false];
  }

  List<Vector2> getHitBox() {
    return [Vector2(-0.5 * size.x, 0.5 * size.y),
      Vector2(0, -0.5 * size.y),
      Vector2(0.5 * size.x, 0.5 * size.y)];
  }
  void addHitBox() async {
    try {
      remove(hitBox);
    } catch (error) {
      print('error $error');
    }
    hitBox = PolygonHitbox(getHitBox());
    await add(hitBox);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    var spike = await Sprite.load('game/spike.png');
    sprites = <int, Sprite>{0: spike};
    current = 0;
  }

  double getCoefficient() {
    return coefficient;
  }

  @override
  String getName() {
    return "Spike";
  }

  Spike.fromJson(Map<String, dynamic> json) : coefficient = 0.7,
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']) {
    hitBox = PolygonHitbox.relative([Vector2(-0.5, 0.5),Vector2(0, -0.5),Vector2(0.5, 0.5),], parentSize: size);
    deadlyVertices = [false, true, false];
  }

  @override
  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': degrees(angle),
  };
}

class Star extends BasketSprite {
  late PolygonHitbox hitBox;
  final double coefficient;
  late final List<bool> deadlyVertices;
  final List<Vector2> hitBoxShape = [
    Vector2(0.0, 0.5),
    Vector2(-0.22252093395631434, -0.5),
    Vector2(0.40096886790241915, 0.3019377358048382),
    Vector2(-0.5, -0.14310413210779066),
    Vector2(0.5, -0.14310413210779055),
    Vector2(-0.4009688679024192, 0.3019377358048382),
    Vector2(0.22252093395631445, -0.5),
    Vector2(0.0, 0.5),
    Vector2(-0.22252093395631434, -0.5),
    Vector2(0.40096886790241915, 0.3019377358048382),
    Vector2(-0.5, -0.14310413210779066),
    Vector2(0.5, -0.14310413210779055),
    Vector2(-0.4009688679024192, 0.3019377358048382),
    Vector2(0.22252093395631445, -0.5)
  ];

  Star({
    super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
  ) {
    hitBox = PolygonHitbox(hitBoxShape.map((e) => Vector2(e.x*size.x, e.y*size.y)).toList());
    deadlyVertices = List.filled(14, true);
  }

  List<Vector2> getHitBox() {
    return [Vector2(0.0 * size.x, 0.5 * size.y),
    Vector2(-0.22252093395631434 * size.x, -0.5 * size.y),
    Vector2(0.40096886790241915 * size.x, 0.3019377358048382 * size.y),
    Vector2(-0.5 * size.x, -0.14310413210779066 * size.y),
    Vector2(0.5 * size.x, -0.14310413210779055 * size.y),
    Vector2(-0.4009688679024192 * size.x, 0.3019377358048382 * size.y),
    Vector2(0.22252093395631445 * size.x, -0.5 * size.y),
    Vector2(0.0 * size.x, 0.5 * size.y),
    Vector2(-0.22252093395631434 * size.x, -0.5 * size.y),
    Vector2(0.40096886790241915 * size.x, 0.3019377358048382 * size.y),
    Vector2(-0.5 * size.x, -0.14310413210779066 * size.y),
    Vector2(0.5 * size.x, -0.14310413210779055 * size.y),
    Vector2(-0.4009688679024192 * size.x, 0.3019377358048382 * size.y),
    Vector2(0.22252093395631445 * size.x, -0.5 * size.y)];
  }

  @override
  Future<void>? onLoad() async {
    print('onLoad');
    await super.onLoad();
    addHitBox();
    var star = await Sprite.load('game/star.png');
    sprites = <int, Sprite>{0: star};
    current = 0;
  }

  void addHitBox() async {
    try {
      remove(hitBox);
    } catch (error) {
      print('error $error');
    }
    hitBox = PolygonHitbox(getHitBox());
    await add(hitBox);
  }

  @override
  void onGameResize(Vector2 size) {
    print('onGameResize');
    addHitBox();
    super.onGameResize(size);
  }

  double getCoefficient() {
    return coefficient;
  }

  @override
  String getName() {
    return "Star";
  }

  Star.fromJson(Map<String, dynamic> json) : coefficient = 0.7,
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']) {
    hitBox = PolygonHitbox(hitBoxShape.map((e) => Vector2(e.x*size.x, e.y*size.y)).toList());
    deadlyVertices = List.filled(14, true);
  }

  @override
  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': degrees(angle),
  };
}