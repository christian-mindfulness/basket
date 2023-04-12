import 'dart:math';

import 'package:basket/game/basket_game.dart';
import 'package:basket/sprites/circles.dart';
import 'package:basket/sprites/enemies.dart';
import 'package:basket/sprites/goal.dart';
import 'package:basket/sprites/walls.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent with HasGameRef<BasketBall>, KeyboardHandler, CollisionCallbacks {
  Player()
      : super(
    size: Vector2.all(30.0),
    anchor: Anchor.center,
  );

  Vector2 _velocity = Vector2(0,0);
  static const double _kickScale = 200;
  static const double _gravity = 10;
  Vector2 oldPosition = Vector2(0, 0);
  static const double _radius = 15;
  final CircleHitbox _hitBox = CircleHitbox(radius: _radius);
  bool pauseNextTick = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('blue_ball.png');
    position = Vector2(200, 750);
    oldPosition = position;
    await add(_hitBox);
  }

  void resetPosition() {
    position = Vector2(200, 700);
    _velocity = Vector2(0, 0);
    print('Reset position $position $_velocity');
  }

  @override
  void update(double dt) {
    _velocity.y += _gravity;
    // save previous position
    oldPosition = Vector2(position.x, position.y);
    position += _velocity * dt;
    super.update(dt);
    if (pauseNextTick) {
      game.pause();
      pauseNextTick = false;
    }
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

    double coefficient;
    if (other is Wall) {
      coefficient = other.getCoefficient();
      rectangleCollision(other, coefficient);
      other.hitBox.globalVertices();
    } else if (other is MyCircle) {
      coefficient = other.getCoefficient();
      circleCollision(other, coefficient);
    } else if (other is Spike) {
      polygonCollision(
          other, other.hitBox.globalVertices(), other.deadlyVertices,
          other.getCoefficient());
    } else if (other is Star) {
      polygonCollision(
          other, other.hitBox.globalVertices(), other.deadlyVertices,
          other.getCoefficient());
    } else if (other is BasketGoal) {
      if (_hitBox.collidingWith(other.goalHitBox)) {
        game.victory();
      }
      polygonCollision(
          other, other.hitBox.globalVertices(), other.deadlyVertices,
          other.getCoefficient());
    } else {
      coefficient = 0.6;
      rectangleCollision(other, coefficient);
    }
  }

  void circleCollision(MyCircle other, double coefficient) {
    double startDistance = oldPosition.distanceTo(other.absoluteCenter);
    double endDistance = position.distanceTo(other.absoluteCenter);
    double collisionTime = calcTime(startDistance, endDistance, _radius + other.getRadius());
    Vector2 location = collisionLocation(collisionTime, oldPosition, position);
    Vector2 normal = (other.absoluteCenter - location).normalized();
    print('Normal: $normal');
    _velocity = reflect(_velocity, normal, coefficient);
    position = location + _velocity.normalized() * (1-collisionTime) * (position.distanceTo(oldPosition));
  }

  void rectangleCollision(PositionComponent other, double coefficient) {
    double cornerDistance = sqrt(pow(other.width / 2, 2) + pow(other.height / 2, 2));
    double theta = atan(other.height / other.width);
    Vector2 topLeft = Vector2(other.absoluteCenter.x + cornerDistance * cos(theta + other.angle),
        other.absoluteCenter.y + cornerDistance * sin(theta + other.angle));
    Vector2 topRight = Vector2(other.absoluteCenter.x + cornerDistance * cos(-theta + other.angle + pi),
        other.absoluteCenter.y + cornerDistance * sin(-theta + other.angle + pi));
    Vector2 bottomRight = Vector2(other.absoluteCenter.x + cornerDistance * cos(theta + other.angle + pi),
        other.absoluteCenter.y + cornerDistance * sin(theta + other.angle + pi));
    Vector2 bottomLeft = Vector2(other.absoluteCenter.x + cornerDistance * cos(other.angle - theta),
        other.absoluteCenter.y + cornerDistance * sin(other.angle - theta));

    // print('Centre: ${other.absoluteCenter}');
    // print('Corner distance = $cornerDistance');
    // print('Angles: $theta ${other.angle} ${theta + other.angle + pi/2} ${cos(theta + other.angle + pi/2)}');
    // print('Cos: ${cos(theta + other.angle)} ${cos(theta + other.angle + 0.5 * pi)} ${cos(theta + other.angle + pi)} ${cos(theta + other.angle + 1.5 * pi)}');

    List<Vector2> corners = [topLeft, topRight, bottomRight, bottomLeft];
    List<String> cornerNames = ['topLeft', 'topRight', 'bottomRight', 'bottomLeft'];

    // for (int i=0; i<corners.length; i++) {
    //   print('${cornerNames[i]}: ${corners[i]}');
    // }

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
      Vector2 tangent = Vector2(0,0);
      if (collisionCorners[colIndex].length == 2) {
        Vector2 diff = collisionCorners[colIndex][0] - collisionCorners[colIndex][1];
        normal = diff.scaleOrthogonalInto(1 / diff.length, normal);
        tangent = diff.normalized();
      } else {
        normal = (location - collisionCorners[colIndex][0]).normalized();
        normal.scaleOrthogonalInto(1, tangent);
        tangent = tangent.normalized();
      }
      _velocity = applyTangent(reflect(_velocity, normal, coefficient), tangent, 0.9);
      position = location + _velocity.normalized() * (1-colTime) * (position.distanceTo(oldPosition));
    } else {
      print('No collision');
      gameRef.pauseEngine();
    }
  }

  void polygonCollision(PositionComponent other, List<Vector2> corners, List<bool> deadlyVertices, double coefficient) {
    List<double> collisionTimes = [];
    List<List<Vector2>> collisionCorners = [];
    for (int i=0; i<corners.length; i++) {
      collisionTimes.add(collisionTimeLine(oldPosition, position, corners[i], corners[(i+1) % corners.length], _radius));
      collisionCorners.add([corners[i], corners[(i+1) % corners.length]]);
      collisionTimes.add(collisionTimeCorner(oldPosition, absoluteCenter, corners[i], _radius));
      collisionCorners.add([corners[i]]);
    }

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
      Vector2 tangent = Vector2(0,0);
      if (collisionCorners[colIndex].length == 2) {
        Vector2 diff = collisionCorners[colIndex][0] - collisionCorners[colIndex][1];
        normal = diff.scaleOrthogonalInto(1 / diff.length, normal);
        tangent = diff.normalized();
      } else {
        normal = (location - collisionCorners[colIndex][0]).normalized();
        normal.scaleOrthogonalInto(1, tangent);
        tangent = tangent.normalized();
        print('Actual corner');
        if (deadlyVertices[-1+(colIndex+1)~/2]) {
          game.failed();
        }
      }
      if (pauseNextTick) {
        position = location;
      } else {
        position = location + _velocity.normalized() * (1-colTime) * (position.distanceTo(oldPosition));
      }
      _velocity = applyTangent(reflect(_velocity, normal, coefficient), tangent, 0.8);
    } else {
      print('No collision');
      //gameRef.pauseEngine();
    }
  }

  Vector2 applyTangent(Vector2 velocity, Vector2 tangent, double coefficient) {
    return velocity - tangent.scaled((1-coefficient) * tangent.dot(velocity));
  }

  Vector2 reflect(Vector2 velocity, Vector2 normal, double coefficient) {
    return velocity - normal.scaled((1+coefficient) * normal.dot(velocity));
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

  void impulse(Vector2 size) {
    _velocity += size;
  }
}
