import 'dart:math';

import 'package:basket/game/basket_game.dart';
import 'package:basket/sprites/backgrounds.dart';
import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/circles.dart';
import 'package:basket/sprites/enemies.dart';
import 'package:basket/sprites/goal.dart';
import 'package:basket/sprites/walls.dart';
import 'package:basket/utils/time_and_velocity.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../utils/ball_type.dart';

enum BallType {
  basket,
  metal,
  tennis,
  beach,
}

Map<BallType, String> ballNames = {
  BallType.basket: "Basket ball",
  BallType.metal: "Metal ball",
  BallType.tennis: "Tennis ball",
  BallType.beach: "Beach ball",
};

Map<BallType, int> ballSizes = {
  BallType.basket: 50,
  BallType.metal: 20,
  BallType.tennis: 30,
  BallType.beach: 80,
};

Map<BallType, double> momentOfIntertia = {
  BallType.basket: 0.2,
  BallType.metal: 0.2,
  BallType.tennis: 0.2,
  BallType.beach: 0.2,
};

Map<BallType, double> dragCoefficient = {
  BallType.basket: 0.2,
  BallType.metal: 0.2,
  BallType.tennis: 0.2,
  BallType.beach: 2.0,
};

class Player extends BasketSprite with HasGameRef, KeyboardHandler, CollisionCallbacks {
  final BallType type;
  final bool initialized;

  Player({
    required super.position,
    required Vector2 size,
    required this.type,
    required this.initialized,
  })
      : _radius = ballSizes[type]!.toDouble() / 2,
        _hitBox = CircleHitbox(radius: ballSizes[type]!.toDouble() / 2),
        super(size: size);

  Vector2 _velocity = Vector2(0,0);
  double _angularVelocity = 0;
  static const double _kickScale = 200;
  Vector2 oldPosition = Vector2(0, 0);
  final double _radius;
  final CircleHitbox _hitBox;
  bool pauseNextTick = false;
  double saveDT = 0.01;

  @override
  Future<void> onLoad() async {
    super.onLoad();
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
    oldPosition = position;
    await add(_hitBox);
  }

  @override
  void update(double dt) {
    saveDT = dt;
    Vector2 velocityBefore = Vector2(_velocity.x, _velocity.y);
    _velocity += (game as BasketBall).getLevelOptions.gravity;
    applyAirResistance();
    // save previous position
    oldPosition = Vector2(position.x, position.y);
    position += _velocity * dt;
    super.update(dt);
    if (pauseNextTick) {
      (game as BasketBall).pause();
      pauseNextTick = false;
    }
    angle += _angularVelocity * dt;
    debugPrint('position: $position  Old position: $oldPosition');
    debugPrint('update: velocity: $_velocity  Old velocity: $velocityBefore');
  }

  void applyAirResistance() {
    double speed = _velocity.length;
    double newSpeed = speed - 0.0000001 * dragCoefficient[current]! * (game as BasketBall).getLevelOptions.airResistance * pow(speed, 2);
    debugPrint('newSpeed $speed ${dragCoefficient[current]} ${(game as BasketBall).getLevelOptions.airResistance}');
    newSpeed = max(0, newSpeed);
    _velocity = _velocity * newSpeed / speed;
    debugPrint('Air resistance ratio ${newSpeed/speed}');
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

  Player.fromJson(Map<String, dynamic> json)
      : type = getTypeFromString(json['ball_type']),
        _radius = ballSizes[getTypeFromString(json['ball_type'])]!.toDouble() / 2,
        _hitBox = CircleHitbox(radius: ballSizes[getTypeFromString(json['ball_type'])]!.toDouble() / 2),
        initialized = true,
        super(position: Vector2(json['position.x'], json['position.y']),
          size: Vector2(json['size.x'], json['size.y']),
          angle: json['angle']) {
    current = BallType.beach;
  }

  @override
  Map<String, dynamic> toJson() => {
    'position.x': position.x,
    'position.y': position.y,
    'size.x': size.x,
    'size.y': size.y,
    'angle': angle,
    'ball_type': ballNames[current],
  };

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    debugPrint('Collision with $other');
    // for (Vector2 point in intersectionPoints) {
    //   print('Collision points $point');
    // }

    double coefficient;
    if (other is OneWayPlatform) {
      debugPrint('Other should be one-way $other');
      if (_velocity.dot((game as BasketBall).getLevelOptions.gravity) > 0) {
        // We only consider collisions if the ball is moving downwards
        coefficient = other.getCoefficient(current);
        debugPrint('Calling with $coefficient');
        // The one-way platform only accepts collisions with the top edge
        List<int> topCorners = findTopEdge(other.hitBox.globalVertices());
        List<Vector2> newCorners = [other.hitBox.globalVertices()[topCorners[1]], other.hitBox.globalVertices()[topCorners[0]]];
        List<Vector2> oldCorners = [other.oldGlobalVertices[topCorners[1]], other.oldGlobalVertices[topCorners[0]]];
        polygonCollision(
            other, newCorners, oldCorners,
            [false, false, false, false],
            other.getCoefficient(current), other.localDT,
        );
        other.hitBox.globalVertices();
        debugPrint('${other.hitBox.globalVertices()}');
      }
    } else if (other is Wall) {
      coefficient = other.getCoefficient(current);
      debugPrint('Calling with $coefficient');
      polygonCollision(
          other, other.hitBox.globalVertices(), other.oldGlobalVertices,
          [false, false, false, false],
          other.getCoefficient(current), other.localDT);
      other.hitBox.globalVertices();
      debugPrint('${other.hitBox.globalVertices()}');
    } else if (other is MyCircle) {
      coefficient = other.getCoefficient();
      circleCollision(other, coefficient);
    } else if (other is Spike) {
      polygonCollision(
          other, other.hitBox.globalVertices(), other.hitBox.globalVertices(),
          other.deadlyVertices, other.getCoefficient(current),
          0.01);
      debugPrint('Absolute centre = ${other.absoluteCenter}');
      debugPrint('${other.hitBox.globalVertices()}');
    } else if (other is Star) {
      polygonCollision(
          other, other.hitBox.globalVertices(), other.hitBox.globalVertices(),
          other.deadlyVertices, other.getCoefficient(current), 0.01);
      debugPrint('Absolute centre = ${other.absoluteCenter}');
      debugPrint('${other.hitBox.globalVertices()}');
    } else if (other is BasketGoal) {
      if (_hitBox.collidingWith(other.goalHitBox)) {
        (game as BasketBall).victory();
      }
      polygonCollision(
          other, other.hitBox.globalVertices(), other.hitBox.globalVertices(),
          other.deadlyVertices, other.getCoefficient(current), 0.01);
    } else if (other is Background) {
      debugPrint('Collision with background sprite, do nothing');
    } else {
      coefficient = 0.6;
      throw Exception('I should not be here');
      //rectangleCollision(other, coefficient);
    }
  }

  void circleCollision(MyCircle other, double coefficient) {
    double startDistance = oldPosition.distanceTo(other.absoluteCenter);
    double endDistance = position.distanceTo(other.absoluteCenter);
    double collisionTime = calcTime(startDistance, endDistance, _radius + other.getRadius());
    Vector2 location = collisionLocation(collisionTime, oldPosition, position);
    Vector2 normal = (other.absoluteCenter - location).normalized();
    debugPrint('Normal: $normal');
    _velocity = reflect(_velocity, normal, coefficient);
    position = location + _velocity.normalized() * (1-collisionTime) * (position.distanceTo(oldPosition));
  }

  // void rectangleCollision(PositionComponent other, double coefficient) {
  //   double cornerDistance = sqrt(pow(other.width / 2, 2) + pow(other.height / 2, 2));
  //   double theta = atan(other.height / other.width);
  //   Vector2 topLeft = Vector2(other.absoluteCenter.x + cornerDistance * cos(theta + other.angle),
  //       other.absoluteCenter.y + cornerDistance * sin(theta + other.angle));
  //   Vector2 topRight = Vector2(other.absoluteCenter.x + cornerDistance * cos(-theta + other.angle + pi),
  //       other.absoluteCenter.y + cornerDistance * sin(-theta + other.angle + pi));
  //   Vector2 bottomRight = Vector2(other.absoluteCenter.x + cornerDistance * cos(theta + other.angle + pi),
  //       other.absoluteCenter.y + cornerDistance * sin(theta + other.angle + pi));
  //   Vector2 bottomLeft = Vector2(other.absoluteCenter.x + cornerDistance * cos(other.angle - theta),
  //       other.absoluteCenter.y + cornerDistance * sin(other.angle - theta));
  //
  //   // print('Centre: ${other.absoluteCenter}');
  //   // print('Corner distance = $cornerDistance');
  //   // print('Angles: $theta ${other.angle} ${theta + other.angle + pi/2} ${cos(theta + other.angle + pi/2)}');
  //   // print('Cos: ${cos(theta + other.angle)} ${cos(theta + other.angle + 0.5 * pi)} ${cos(theta + other.angle + pi)} ${cos(theta + other.angle + 1.5 * pi)}');
  //
  //   List<Vector2> corners = [topLeft, topRight, bottomRight, bottomLeft];
  //   List<String> cornerNames = ['topLeft', 'topRight', 'bottomRight', 'bottomLeft'];
  //
  //   for (int i=0; i<corners.length; i++) {
  //     debugPrint('${cornerNames[i]}: ${corners[i]}');
  //   }
  //   debugPrint('Centre $absoluteCenter  radius $_radius');
  //
  //   List<TimeAndVelocity> collisionTimes = [];
  //   List<String> collisionNames = [];
  //   List<List<Vector2>> collisionCorners = [];
  //   for (int i=0; i<corners.length; i++) {
  //     collisionTimes.add(collisionTimeLine(oldPosition, position, corners[i],
  //         corners[(i+1) % corners.length], corners[i], corners[(i+1) % corners.length], _radius, ));
  //     collisionNames.add('${cornerNames[i]} + ${cornerNames[(i+1) % corners.length]}');
  //     collisionCorners.add([corners[i], corners[(i+1) % corners.length]]);
  //     collisionTimes.add(collisionTimeCorner(oldPosition, absoluteCenter, corners[i], _radius));
  //     collisionNames.add(cornerNames[i]);
  //     collisionCorners.add([corners[i]]);
  //   }
  //
  //   // for (int i=0; i<collisionTimes.length; i++) {
  //   //   print('${collisionNames[i]}: ${collisionTimes[i]}');
  //   // }
  //
  //   debugPrint('Collision times $collisionTimes');
  //   double colTime = 100;
  //   int colIndex = -1;
  //   for (int i=0; i<collisionTimes.length; i++) {
  //     if (collisionTimes[i] < colTime) {
  //       colIndex = i;
  //       colTime = collisionTimes[i];
  //     }
  //     colTime = max(colTime, 0);
  //   }
  //
  //   if (colIndex >= 0) {
  //     Vector2 location = collisionLocation(colTime, oldPosition, absoluteCenter);
  //     Vector2 normal = Vector2(0,0);
  //     Vector2 tangent = Vector2(0,0);
  //     if (collisionCorners[colIndex].length == 2) {
  //       Vector2 diff = collisionCorners[colIndex][0] - collisionCorners[colIndex][1];
  //       normal = diff.scaleOrthogonalInto(1 / diff.length, normal);
  //       tangent = diff.normalized();
  //     } else {
  //       normal = (location - collisionCorners[colIndex][0]).normalized();
  //       normal.scaleOrthogonalInto(1, tangent);
  //       tangent = tangent.normalized();
  //     }
  //     _velocity = applyTangent(reflect(_velocity, normal, coefficient), tangent, 0.9);
  //     position = location + _velocity.normalized() * (1-colTime) * (position.distanceTo(oldPosition));
  //   } else {
  //     print('No collision');
  //     (gameRef as BasketBall).pauseEngine();
  //   }
  // }

  void polygonCollision(
      PositionComponent other,
      List<Vector2> corners,
      List<Vector2> oldCorners,
      List<bool> deadlyVertices,
      double coefficient,
      double otherDT,
      {double minColTime = -1}
      ) {

    debugPrint('New corners = $corners');
    debugPrint('Old corners = $oldCorners');

    List<TimeAndVelocity> collisionTimes = [];
    List<List<Vector2>> collisionCorners = [];
    List<List<Vector2>> oldCollisionCorners = [];
    for (int i=0; i<corners.length; i++) {
      collisionTimes.add(collisionTimeLine(oldPosition, position,
          oldCorners[i], oldCorners[(i+1) % oldCorners.length],
          corners[i], corners[(i+1) % corners.length], _radius, otherDT));
      collisionCorners.add([corners[i], corners[(i+1) % corners.length]]);
      oldCollisionCorners.add([oldCorners[i], oldCorners[(i+1) % oldCorners.length]]);
      collisionTimes.add(collisionTimeCorner(
          oldPosition, absoluteCenter, oldCorners[i], corners[i],
          _radius, otherDT
      ));
      collisionCorners.add([corners[i]]);
      oldCollisionCorners.add([oldCorners[i]]);
    }

    double colTime = 100;
    Vector2 otherVelocity = Vector2(0, 0);
    int colIndex = -1;
    for (int i=0; i<collisionTimes.length; i++) {
      if (collisionTimes[i].time < colTime && collisionTimes[i].time > minColTime) {
        colIndex = i;
        colTime = collisionTimes[i].time;
        otherVelocity = collisionTimes[i].velocity;
      }
      colTime = max(colTime, 0);
    }

    if (colIndex >= 0) {
      Vector2 location = collisionLocation(colTime, oldPosition, absoluteCenter);
      debugPrint('Collision location: $location');
      Vector2 normal = Vector2(0,0);
      Vector2 tangent = Vector2(0,0);
      if (collisionCorners[colIndex].length == 2) {
        // Find the velocity of the point on the line that was collided with
        //Vector2 otherVelocity = getLineVelocity(collisionCorners[colIndex][0], oldCollisionCorners[colIndex][0], otherDT);
        Vector2 diff = collisionCorners[colIndex][0] - collisionCorners[colIndex][1];
        normal = diff.scaleOrthogonalInto(1 / diff.length, normal);
        tangent = diff.normalized();
      } else {
        // Find the velocity of the corner
        // Vector2 otherVelocity = getCornerVelocity(collisionCorners[colIndex][0], oldCollisionCorners[colIndex][0], otherDT);
        // Vector2 cornerLocation = getCornerLocation(
        //     collisionCorners[colIndex][0],
        //     oldCollisionCorners[colIndex][0],
        //     collisionTimes[colIndex]);
        normal = (location - collisionCorners[colIndex][0]).normalized();
        normal.scaleOrthogonalInto(1, tangent);
        tangent = tangent.normalized();
        debugPrint('Actual corner');
        if (deadlyVertices[-1+(colIndex+1)~/2]) {
          (game as BasketBall).failed();
        }
      }
      // We treat the "other" object as having infinite mass, so we treat it as a
      // frame of reference, subtracting and adding back this reference velocity.
      // debugPrint('Position before $position');
      debugPrint('Velocity before: $_velocity  $otherVelocity');
      _velocity = applyTangent(
          reflect(_velocity - otherVelocity, normal, coefficient),
          tangent,
          0.8
      ) + otherVelocity;
      position = location + _velocity * saveDT * (1-colTime);
      debugPrint('Position after: $position');
      debugPrint('Velocity after: $_velocity');
    } else {
      debugPrint('No collision');
    }
  }

  List<int> findTopEdge(List<Vector2> corners) {
    // Returns the indices of the corners which define the top-most edge of a given shape
    // For all the corners, find the two which have the largest projection in -gravity
    Vector2 minusGrav = -(game as BasketBall).getLevelOptions.gravity;
    double biggest = -1e20;
    double second = -1e20;
    int bigIndex = -1;
    int secIndex = -1;
    int i = 0;
    for (var corner in corners) {
      double projection = minusGrav.dot(corner);
      if (projection > biggest) {
        second = biggest;
        secIndex = bigIndex;
        biggest = projection;
        bigIndex = i;
      } else if (projection > second) {
        second = projection;
        secIndex = i;
      }
      i++;
    }
    if (bigIndex < 0 || secIndex < 0) {
      debugPrint('Error: Found top edge indices to be: $bigIndex $secIndex');
      return [0, 1];
    } else {
      debugPrint('Found top edges as $bigIndex $secIndex');
      return [bigIndex, secIndex];
    }
  }

  Vector2 applyTangent(Vector2 velocity, Vector2 tangent, double coefficient) {
    // Deal with adding spin and improve small bounces
    double tangentMomentum = tangent.dot(velocity) + momentOfIntertia[current]! * _angularVelocity * _radius;
    debugPrint('tangent.dot = ${tangent.dot(velocity)}  angular = ${- momentOfIntertia[current]! * _angularVelocity * _radius}');
    double newTangentMomentum = 0.01 * tangentMomentum;
    double newSpeed = (tangentMomentum - newTangentMomentum) / (1 + momentOfIntertia[current]!);
    debugPrint('angularVelocity (start) = $_angularVelocity');
    debugPrint('calculation = $tangentMomentum   $newTangentMomentum   $_radius');
    _angularVelocity = newSpeed / _radius;
    debugPrint('angularVelocity (end) = $_angularVelocity');
    return velocity - tangent.scaled(tangent.dot(velocity) - newSpeed);
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


  TimeAndVelocity collisionTimeLine(Vector2 startPosition, Vector2 endPosition,
      Vector2 startCorner1, Vector2 startCorner2,
      Vector2 endCorner1, Vector2 endCorner2, double radius, double otherDT) {
    // Calculate the time of a collision between a line and the sprite
    double startDistance = pointLineDistance(startPosition, startCorner1, startCorner2);
    double endDistance = pointLineDistance(endPosition, endCorner1, endCorner2);
    double collisionTime = calcTime(startDistance, endDistance, radius);
    debugPrint('CTL: $startDistance, $endDistance, $collisionTime');
    if (collisionTime < 10) {
      // If we have a valid collision, then calculate the collision location
      // and whether that is between the two corners, by first finding the
      // projection of the point onto the line.
      Vector2 location = collisionLocation(collisionTime, startPosition, endPosition);
      Vector2 corner1 = collisionLocation(collisionTime, startCorner1, endCorner1);
      Vector2 corner2 = collisionLocation(collisionTime, startCorner2, endCorner2);
      Vector2 pointOnLine = pointProjection(location, corner1, corner2);
      double cornerDistance = corner1.distanceTo(corner2);
      if (pointOnLine.distanceTo(corner1) < cornerDistance && pointOnLine.distanceTo(corner2) < cornerDistance) {
        Vector2 velocity1 = (endCorner1 - startCorner1) / otherDT;
        Vector2 velocity2 = (endCorner2 - startCorner2) / otherDT;
        double weight = (cornerDistance - pointOnLine.distanceTo(corner1)) / cornerDistance;
        debugPrint('Getting velocities $velocity1  $velocity2  $weight');
        debugPrint('Returning velocity ${velocity1 * weight + velocity2 * (1-weight)}');
        return TimeAndVelocity(time: collisionTime, velocity: velocity1 * weight + velocity2 * (1-weight));
      } else {
        return TimeAndVelocity(time: 1000, velocity: Vector2(0, 0));
      }
    } else {
      return TimeAndVelocity(time: 1000, velocity: Vector2(0, 0));
    }
  }

  Vector2 getCornerVelocity(Vector2 endCorner, Vector2 startCorner, double otherDT) {
    return (endCorner - startCorner) / otherDT;
  }

  double calcTime(double startDistance, double endDistance, double radius) {
    // Calculate the collision time, accounting for the case where the sprite
    // is intersecting the point/line at both times.
    if (startDistance < radius && endDistance < radius) {
      if (endDistance > startDistance) {
        // We're already heading away from the collision, so do nothing.
        return 1000;
      } else {
        debugPrint('Result would have been ${(radius - startDistance) / (endDistance - startDistance)}');
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

  TimeAndVelocity collisionTimeCorner(Vector2 startPosition, Vector2 endPosition,
      Vector2 startCorner, Vector2 endCorner, double radius, double otherDT) {
    // Find the collision time between a corner and the sprite
    double startDistance = startPosition.distanceTo(startCorner);
    double endDistance = endPosition.distanceTo(endCorner);
    TimeAndVelocity result = TimeAndVelocity(
        time: calcTime(startDistance, endDistance, radius),
        velocity: (endCorner - startCorner) / otherDT,
    );
    return result;
  }

  void impulse(Vector2 impulseSize) {
    debugPrint('Adding impulse to velocity: $_velocity $impulseSize');
    _velocity += impulseSize;
    debugPrint('After adding $_velocity');
  }

  @override
  String getName() {
    return 'Ball ${ballNames[type]}';
  }
}
