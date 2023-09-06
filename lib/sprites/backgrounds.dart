import 'package:basket/sprites/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../utils/clone_list.dart';
import 'basket_sprites.dart';

class Background extends MovementSprite
    with CollisionCallbacks {
  final hitBox = RectangleHitbox();

  Background({
    required super.startPosition,
    required super.size,
    super.startAngle,
  }) : super();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(hitBox);
    var wall = await Sprite.load('game/wall.png');
    sprites = <int, Sprite>{0: wall};
    current = 0;
  }

  @override
  String getName() {
    return "Wall";
  }

  Background.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}


class Arrow extends Background {
  Arrow({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    var image = await Sprite.load('game/arrow.png');
    sprites = <int, Sprite>{0: image};
    current = 0;
  }

  Arrow.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {return "Arrow";}
}
