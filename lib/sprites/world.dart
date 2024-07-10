import 'package:basket/game/basket_game.dart';
import 'package:basket/game/world_editor.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class BackgroundImage extends SpriteComponent with HasGameRef {
  BackgroundImage()
      : super(priority: 0,
    size: Vector2(400, 800),
    position: Vector2(200, 400),
    anchor: Anchor.center,
  );

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('sports_hall.png');
    debugPrint(size.toString());
    debugPrint(position.toString());
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    if (gameRef is WorldEditorGame) {
      size = (gameRef as WorldEditorGame).worldSize;
    } else if (gameRef is BasketBall) {
      size = (gameRef as BasketBall).worldSize;
    }
    position = size / 2;
  }
}