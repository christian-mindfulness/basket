import 'dart:math';

import 'package:basket/game/basket_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent with HasGameRef<BasketBall>, KeyboardHandler, CollisionCallbacks {
  Player()
      : super(
    size: Vector2.all(50.0),
    anchor: Anchor.center,
  );

  Vector2 _velocity = Vector2(0,0);
  static const double _kickScale = 200;
  static const double _gravity = 10;
  Vector2 oldPosition = Vector2(0, 0);
  static const double _radius = 25;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('blue_ball.png');
    position = gameRef.size / 2;
    oldPosition = position;
    await add(CircleHitbox(radius: _radius));
  }

  @override
  void update(double dt) {
    _velocity.y += _gravity;
    // save previous position
    oldPosition = Vector2(position.x, position.y);
    position += _velocity * dt;
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _velocity += Vector2(-_kickScale, 0);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _velocity += Vector2(_kickScale, 0);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _velocity += Vector2(0, -_kickScale);
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // for (Vector2 point in intersectionPoints) {
    //   print('Collision points $point');
    // }

    Vector2 topLeft = Vector2(other.absoluteTopLeftPosition.x, other.absoluteTopLeftPosition.y);
    Vector2 topRight = Vector2(other.absoluteTopLeftPosition.x + other.width, other.absoluteTopLeftPosition.y);
    Vector2 bottomLeft = Vector2(other.absoluteTopLeftPosition.x, other.absoluteTopLeftPosition.y + other.height);
    Vector2 bottomRight = Vector2(other.absoluteTopLeftPosition.x + other.width, other.absoluteTopLeftPosition.y + other.height);

    List<Vector2> corners = [topLeft, topRight, bottomRight, bottomLeft];
    List<String> cornerNames = ['topLeft', 'topRight', 'bottomRight', 'bottomLeft'];

    List<double> collisionTimes = [];
    List<String> collisionNames = [];
    List<List<Vector2>> collisionCorners = [];
    for (int i=0; i<corners.length; i++) {
      collisionTimes.add(collisionTimeLine(oldPosition, position, corners[i], corners[(i+1) % corners.length], _radius));
      collisionNames.add('${cornerNames[i]} + ${cornerNames[(i+1) % corners.length]}');
      collisionCorners.add([corners[i], corners[(i+1) % corners.length]]);
      collisionTimes.add(collisionTimeCorner(oldPosition, absoluteCenter, corners[i], _radius));
      collisionNames.add(cornerNames[i]);
      collisionCorners.add([corners[i]]);
    }

    // for (int i=0; i<collisionTimes.length; i++) {
    //   print('${collisionNames[i]}: ${collisionTimes[i]}');
    // }

    double colTime = 100;
    int colIndex = -1;
    for (int i=0; i<collisionTimes.length; i++) {
      if (collisionTimes[i] < colTime) {
        colIndex = i;
        colTime = collisionTimes[i];
      }
      colTime = max(colTime, 0);
    }

    if (colIndex >= 0) {
      Vector2 location = collisionLocation(colTime, oldPosition, absoluteCenter);
      Vector2 normal = Vector2(0,0);
      if (collisionCorners[colIndex].length == 2) {
        Vector2 diff = collisionCorners[colIndex][0] - collisionCorners[colIndex][1];
        normal = diff.scaleOrthogonalInto(1 / diff.length, normal);
      } else {
        normal = (location - collisionCorners[colIndex][0]).normalized();
      }
      _velocity.reflect(normal);
      position = location + _velocity.normalized() * (1-colTime) * (position.distanceTo(oldPosition));
    } else {
      print('No collision');
      gameRef.pauseEngine();
    }
  }

  double pointLineDistance(Vector2 point, Vector2 corner1, Vector2 corner2) {
    // Find the orthogonal distance between a point and a line
    double numerator = ((corner2.x - corner1.x) * (corner1.y - point.y) -
        (corner1.x - point.x) * (corner2.y - corner1.y)).abs();
    double denominator = sqrt(pow(corner2.x - corner1.x, 2) + pow(corner2.y - corner1.y, 2));
    if (denominator > 0) {
      return numerator / denominator;
    } else {
      return 1000;
    }
  }

  Vector2 pointProjection(Vector2 point, Vector2 corner1, Vector2 corner2) {
    // Gives the location of the orthogonal projection of point onto the line
    // defined by the two corners.
    Vector2 difference = (corner2 - corner1).normalized();
    Vector2 projection = difference * difference.dot(point - corner1) + corner1;
    return projection;
  }


  Vector2 collisionLocation(double collisionTime, Vector2 startPosition, Vector2 endPosition) {
    // Give the location of the collision point
    return startPosition * (1 - collisionTime) + endPosition * collisionTime;
  }


  double collisionTimeLine(Vector2 startPosition, Vector2 endPosition,
      Vector2 corner1, Vector2 corner2, double radius) {
    // Calculate the time of a collision between a line and the sprite
    double startDistance = pointLineDistance(startPosition, corner1, corner2);
    double endDistance = pointLineDistance(endPosition, corner1, corner2);
    double collisionTime = calcTime(startDistance, endDistance, radius);
    // print('CTL: $startDistance, $endDistance, $collisionTime');
    if (collisionTime < 10) {
      // If we have a valid collision, then calculate the collision location
      // and whether that is between the two corners, by first finding the
      // projection of the point onto the line.
      Vector2 location = collisionLocation(collisionTime, startPosition, endPosition);
      Vector2 pointOnLine = pointProjection(location, corner1, corner2);
      double cornerDistance = corner1.distanceTo(corner2);
      if (pointOnLine.distanceTo(corner1) < cornerDistance && pointOnLine.distanceTo(corner2) < cornerDistance) {
        return collisionTime;
      } else {
        return 1000;
      }
    } else {
      return 1000;
    }
  }

  double calcTime(double startDistance, double endDistance, double radius) {
    // Calculate the collision time, accounting for the case where the sprite
    // is intersecting the point/line at both times.
    if (startDistance < radius && endDistance < radius) {
      if (endDistance > startDistance) {
        // We're already heading away from the collision, so do nothing.
        return 1000;
      } else {
        return 0;
      }
    } else if (startDistance < radius || endDistance < radius) {
      // The normal case that we intersect the object only once.
      if (endDistance > startDistance) {
        // We're already heading away from the collision, so do nothing.
        return 1000;
      } else {
        return (radius - startDistance) / (endDistance - startDistance);
      }
    } else {
      // No collision detected
      return 1000;
    }
  }

  double collisionTimeCorner(Vector2 startPosition, Vector2 endPosition, Vector2 corner, double radius) {
    // Find the collision time between a corner and the sprite
    double startDistance = startPosition.distanceTo(corner);
    double endDistance = endPosition.distanceTo(corner);
    return calcTime(startDistance, endDistance, radius);
  }

}
