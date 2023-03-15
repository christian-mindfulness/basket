import 'package:flame/components.dart';

class MyWorld extends SpriteComponent with HasGameRef {
  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('green_background.png');
    size = sprite!.originalSize;
    return super.onLoad();
  }
}