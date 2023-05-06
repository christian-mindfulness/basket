import 'package:basket/game/world_editor.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class MyWorld extends SpriteComponent with HasGameRef {
  MyWorld()
      : super(priority: 0,
    size: Vector2(400, 800),
    position: Vector2(200, 400),
    anchor: Anchor.center,
  );

  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('green_background.png');
    //size = sprite!.originalSize;
    debugPrint(size.toString());
    debugPrint(position.toString());
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    size = (gameRef as WorldEditorGame).worldSize;
    position = size / 2;
  }
}