import 'dart:math';

import 'package:basket/sprites/enemies.dart';
import 'package:basket/sprites/goal.dart';
import 'package:basket/sprites/player.dart';
import 'package:basket/sprites/basket_sprites.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/cupertino.dart';
import '../utils/ball_type.dart';
import 'walls.dart';

class DragBrickWall extends BrickWall with DragCallbacks, TapCallbacks {
  final Function showResize;

  DragBrickWall({required super.position,
                 required super.size,
                 required this.showResize,
                 super.angle,
  }) {
    _position = position;
  }

  late Vector2 _position;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _position += event.delta;
    position = dragUpdate(hitBox.globalVertices(), absoluteCenter, _position);
    super.onDragUpdate(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    showResize(this);
  }

  DragBrickWall.fromJson(Map<String, dynamic> json, this.showResize) : super.fromJson(json) {
    _position = position;
  }
}

class DragWoodWall extends WoodWall with DragCallbacks, TapCallbacks {
  final Function showResize;

  DragWoodWall({required super.position,
    required super.size,
    required this.showResize,
    super.angle,
  }) {
    _position = position;
  }

  late Vector2 _position;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _position += event.delta;
    position = dragUpdate(hitBox.globalVertices(), absoluteCenter, _position);
    super.onDragUpdate(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    showResize(this);
  }

  DragWoodWall.fromJson(Map<String, dynamic> json, this.showResize) : super.fromJson(json) {
    _position = position;
  }
}

class DragSpike extends Spike with DragCallbacks, TapCallbacks {
  final Function showResize;

  DragSpike({required super.position,
    required super.size,
    required this.showResize,
    super.angle,
  }) {
    _position = position;
  }

  late Vector2 _position;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _position += event.delta;
    position = Vector2(roundPosition(_position.x, 400), roundPosition(_position.y, 800));
    super.onDragUpdate(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    showResize(this);
  }

  DragSpike.fromJson(Map<String, dynamic> json, this.showResize) : super.fromJson(json) {
    _position = position;
  }
}

class DragStar extends Star with DragCallbacks, TapCallbacks {
  final Function showResize;

  DragStar({required super.position,
    required super.size,
    required this.showResize,
    super.angle,
  }) {
    _position = position;
  }

  late Vector2 _position;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _position += event.delta;
    position = Vector2(roundPosition(_position.x, 400), roundPosition(_position.y, 800));
    super.onDragUpdate(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    showResize(this);
  }

  DragStar.fromJson(Map<String, dynamic> json, this.showResize) : super.fromJson(json) {
    _position = position;
  }
}

class DragBasket extends BasketGoal with DragCallbacks, TapCallbacks {
  final Function showResize;

  DragBasket({required super.position,
    required super.size,
    required this.showResize,
    super.angle,
  }) {
    _position = position;
  }

  late Vector2 _position;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _position += event.delta;
    position = Vector2(roundPosition(_position.x, 400), roundPosition(_position.y, 800));
    super.onDragUpdate(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    showResize(this);
  }

  DragBasket.fromJson(Map<String, dynamic> json, this.showResize) : super.fromJson(json) {
    _position = position;
  }
}

class DragBall extends BasketSprite with DragCallbacks, TapCallbacks {
  final Function showResize;
  final BallType type;

  DragBall({
    required super.position,
    required Vector2 size,
    required this.showResize,
    required this.type,
  }) : super(
    size: size,
    priority: 3,
  );

  late Vector2 _position;

  @override
  Future<void> onLoad() async {
    _position = position;
    var basket = await Sprite.load('basket_ball.png');
    var beach = await Sprite.load('beach_ball.png');
    var metal = await Sprite.load('metal_ball.png');
    var tennis = await Sprite.load('tennis_ball.png');
    sprites = <BallType, Sprite>{
      BallType.metal: metal,
      BallType.basket: basket,
      BallType.tennis: tennis,
      BallType.beach: beach,
    };
    current = type;
    size = Vector2(ballSizes[current]!.toDouble(), ballSizes[current]!.toDouble());
    return super.onLoad();
  }

  void changeType(BallType newType) {
    current = newType;
    size = Vector2(ballSizes[newType]!.toDouble(),
        ballSizes[newType]!.toDouble());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _position += event.delta;
    position = Vector2(roundPosition(_position.x, 400), roundPosition(_position.y, 800));
    super.onDragUpdate(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    showResize(this);
  }

  DragBall.fromJson(Map<String, dynamic> json, this.showResize)
      : type = getTypeFromString(json['ball_type']),
        super(position: Vector2(json['position.x'], json['position.y']),
              size: Vector2(json['size.x'], json['size.y']),
              angle: json['angle']) {
    current = type;
  }

  @override
  Map<String, dynamic> toJson() => {
    'ball_type': ballNames[current],
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': angle,
  };

  @override
  String getName() {
    return 'Ball';
  }
}

double getPosition(double inPos, double minX, double maxX, double limit) {
  double newPos = ((inPos - minX) * 0.1).round().toDouble() / 0.1 + minX;
  newPos = min(newPos, limit - maxX);
  newPos = max(minX, newPos);
  return newPos;
}

double roundPosition(double inPos, double max) {
  double offset = 5;
  double newPos = ((inPos - offset) * 0.1).round().toDouble() / 0.1 + offset;
  if (newPos > max) {
    return max - offset;
  } else if (newPos < 0) {
    return offset;
  } else {
    return newPos;
  }
}

Vector2 minPos(List<Vector2> corners, Vector2 centre) {
  return centre - corners.reduce((value, element) => Vector2(min(element.x, value.x),
      min(element.y, value.y)));
}

Vector2 maxPos(List<Vector2> corners, Vector2 centre) {
  // for (Vector2 corner in corners) {
  //   debugPrint('corner = $corner');
  // }
  // debugPrint('centre = $centre');
  return corners.reduce((value, element) => Vector2(max(element.x, value.x),
      max(element.y, value.y))) - centre;
}

Vector2 dragUpdate(List<Vector2> vertices,
    Vector2 absoluteCenter,
    Vector2 inputPosition,
    {bool extraPrint=false}) {
  Vector2 minimum = minPos(vertices, absoluteCenter);
  Vector2 maximum = maxPos(vertices, absoluteCenter);
  Vector2 position = Vector2(getPosition(inputPosition.x, minimum.x, maximum.x, 400),
      getPosition(inputPosition.y, minimum.y, maximum.y, 800));
  if (extraPrint) {
    debugPrint('inputPosition = $inputPosition');
    debugPrint('minimum  = $minimum');
    debugPrint('maximum $maximum');
    debugPrint('position = $position');
  }
  return position;
}