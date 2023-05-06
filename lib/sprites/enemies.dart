import 'package:basket/game/basket_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Spike extends SpriteComponent
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
    anchor: Anchor.center,
  ) {
    hitBox = PolygonHitbox.relative([Vector2(-0.5, 0.5),Vector2(0, -0.5),Vector2(0.5, 0.5),], parentSize: size);
    // hitBox = PolygonHitbox([
    //   Vector2(-0.5 * size.x, 0.5 * size.y),
    //   Vector2(0, -0.5 * size.y),
    //   Vector2(0.5 * size.x, 0.5 * size.y),
    // ]);
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
    sprite = await Sprite.load('game/spike.png');
  }

  // @override
  // void onGameResize(Vector2 size) {
  //   getHitBox();
  //   super.onGameResize(size);
  // }
  //
  double getCoefficient() {
    return coefficient;
  }
}

class Star extends SpriteComponent {
  late PolygonHitbox hitBox;
  final double coefficient;
  late final List<bool> deadlyVertices;

  Star({
    super.position,
    required Vector2 size,
    this.coefficient = 0.7,
    double angle = 0
  }) : super(
    size: size,
    priority: 3,
    angle: radians(angle),
    anchor: Anchor.center,
  ) {
    hitBox = PolygonHitbox([
      Vector2(0.0 * size.x, 0.5 * size.y),
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
      Vector2(0.22252093395631445 * size.x, -0.5 * size.y),
      //
      // Vector2(0.5 * size.x, 0.0 * size.y),
      // Vector2(0.5794168018485238 * size.x, 0.3568958678922094 * size.y),
      // Vector2(0.9009688679024191 * size.x, 0.1980622641951616 * size.y),
      // Vector2(0.6784479339461047 * size.x, 0.4842705284107428 * size.y),
      // Vector2(1.0 * size.x, 0.6431041321077905 * size.y),
      // Vector2(0.6431041321077907 * size.x, 0.6431041321077906 * size.y),
      // Vector2(0.7225209339563144 * size.x, 0.9999999999999999 * size.y),
      // Vector2(0.5 * size.x, 0.7137917357844188 * size.y),
      // Vector2(0.27747906604368566 * size.x, 1.0 * size.y),
      // Vector2(0.3568958678922095 * size.x, 0.6431041321077906 * size.y),
      // Vector2(0.0 * size.x, 0.6431041321077906 * size.y),
      // Vector2(0.32155206605389525 * size.x, 0.4842705284107428 * size.y),
      // Vector2(0.09903113209758083 * size.x, 0.19806226419516182 * size.y),
      // Vector2(0.42058319815147616 * size.x, 0.3568958678922095 * size.y),
      //
      // Vector2(0.5 * size.x, 0.0 * size.y),
      // Vector2(0.5794168018485238 * size.x, 0.6431041321077906 * size.y),
      // Vector2(0.9009688679024191 * size.x, 0.8019377358048384 * size.y),
      // Vector2(0.6784479339461047 * size.x, 0.5157294715892572 * size.y),
      // Vector2(1.0 * size.x, 0.3568958678922095 * size.y),
      // Vector2(0.6431041321077907 * size.x, 0.35689586789220945 * size.y),
      // Vector2(0.7225209339563144 * size.x, 0.0 * size.y),
      // Vector2(0.5 * size.x, 0.28620826421558115 * size.y),
      // Vector2(0.27747906604368566 * size.x, 0.0 * size.y),
      // Vector2(0.3568958678922095 * size.x, 0.35689586789220945 * size.y),
      // Vector2(0.0 * size.x, 0.3568958678922094 * size.y),
      // Vector2(0.32155206605389525 * size.x, 0.5157294715892572 * size.y),
      // Vector2(0.09903113209758083 * size.x, 0.8019377358048382 * size.y),
      // Vector2(0.42058319815147616 * size.x, 0.6431041321077905 * size.y),
    ]);
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
    sprite = await Sprite.load('game/star.png');
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
}