import 'dart:math';

import 'package:basket/game/world_editor.dart';
import 'package:basket/main.dart';
import 'package:basket/sprites/enemies.dart';
import 'package:basket/sprites/goal.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/cupertino.dart';
import 'walls.dart';

class DragBrickWall extends BrickWall with DragCallbacks, TapCallbacks {
  DragBrickWall({required super.position,
                 required super.size,
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
    (game as WorldEditorGame).showResize(this);
  }
}

class DragWoodWall extends WoodWall with DragCallbacks, TapCallbacks {
  DragWoodWall({required super.position,
    required super.size,
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
    (game as WorldEditorGame).showResize(this);
  }
}

class DragSpike extends Spike with DragCallbacks, TapCallbacks {
  DragSpike({required super.position,
    required super.size,
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
    (game as WorldEditorGame).showResize(this);
  }
}

class DragStar extends Star with DragCallbacks, TapCallbacks {
  DragStar({required super.position,
    required super.size,
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
    (game as WorldEditorGame).showResize(this);
  }
}

class DragBasket extends BasketGoal with DragCallbacks, TapCallbacks {
  DragBasket({required super.position,
    required super.size,
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
    (game as WorldEditorGame).showResize(this);
  }
}

class DragBall extends Player with DragCallbacks, TapCallbacks {
  DragBall() {
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
    (game as WorldEditorGame).showResize(this);
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