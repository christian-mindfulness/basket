import 'package:basket/sprites/basket_sprites.dart';
import 'package:basket/sprites/player.dart';
// import 'package:basket/utils/crop_image.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
//import 'package:flame/extensions.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
//import 'package:image/image.dart' as img;
//import 'dart:io';
import 'dart:ui';

import '../utils/clone_list.dart';
import '../utils/crop_image.dart';

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


class BrickWall extends Wall with HasGameRef {
  BrickWall({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  // late ByteData imageBytes;
  // late img.Image fullImage;
  late Image brickWall;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    brickWall = await gameRef.images.load('game/large_brick_wall.png');
    // imageBytes = await rootBundle.load('assets/images/game/large_brick_wall.png');
    // fullImage = img.decodePng(imageBytes.buffer.asUint8List())!;
    sprites = {
      0: Sprite(brickWall, srcSize: size)
    };
    current = 0;
    size.addListener(() async {
      sprites = {
        0: Sprite(brickWall, srcSize: size)
      };
    });
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

class WoodWall extends Wall with HasGameRef {
  WoodWall({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  // late ByteData imageBytes;
  // late img.Image fullImage;
  late Image woodWall;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    woodWall = await gameRef.images.load('game/large_wood_wall.png');
    sprites = {0: Sprite(woodWall, srcSize: size)};
    current = 0;
    size.addListener(() async {
      sprites = {0: Sprite(woodWall, srcSize: size)};
    });
    // imageBytes = await rootBundle.load('assets/images/game/large_wood_wall.png');
    // fullImage = img.decodePng(imageBytes.buffer.asUint8List())!;
    // sprites = await cropImage(fullImage, size*2);
    // current = 0;
    // size.addListener(() async {
    //   sprites = await cropImage(fullImage, size*2);
    // });
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

class Slime extends Wall with HasGameRef {
  Slime({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  // late ByteData imageBytes;
  // late img.Image fullImage;
  late Image slime;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    slime = await gameRef.images.load('game/large_slime.png');
    sprites = {0: Sprite(slime, srcSize: size)};
    current = 0;
    size.addListener(() async {
      sprites = {0: Sprite(slime, srcSize: size)};
    });
    // imageBytes = await rootBundle.load('assets/images/game/large_slime.png');
    // fullImage = img.decodePng(imageBytes.buffer.asUint8List())!;
    // sprites = await cropImage(fullImage, size*2);
    // current = 0;
    // size.addListener(() async {
    //   debugPrint('Slime resize: ${fullImage.width} ${fullImage.height}');
    //   sprites = await cropImage(fullImage, size*2);
    // });
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


class OneWayPlatform extends Wall with HasGameRef {
  OneWayPlatform({
    required super.startPosition,
    required super.size,
    super.startAngle,
  });

  // late ByteData imageBytes;
  // late img.Image fullImage;
  late Image oneWay;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    oneWay = await gameRef.images.load('game/large_one_way.png');
    sprites = {0: Sprite(oneWay, srcSize: size)};
    current = 0;
    size.addListener(() async {
      sprites = {0: Sprite(oneWay, srcSize: size)};
    });
    // imageBytes = await rootBundle.load('assets/images/game/large_one_way.png');
    // fullImage = img.decodePng(imageBytes.buffer.asUint8List())!;
    // sprites = await cropImage(fullImage, size*2);
    // current = 0;
    // size.addListener(() async {
    //   sprites = await cropImage(fullImage, size*2);
    // });
  }

  OneWayPlatform.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String getName() {
    return "OneWayPlatform";
  }
}
