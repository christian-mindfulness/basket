import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;

Future<Map<int, Sprite>> cropImage(
    img.Image fullImage,
    Vector2 targetSize
    ) async {
  final img.Image smallImage = img.copyCrop(
      fullImage,
      x: 0,
      y: 0,
      width: targetSize.x.toInt(),
      height: targetSize.y.toInt()
  );
  debugPrint('cropImage: ${smallImage.width} ${smallImage.height} ${smallImage.toUint8List().length}');
  final image = await ImageExtension.fromPixels(
      smallImage.toUint8List(),
      targetSize.x.toInt(),
      targetSize.y.toInt()
  );
  return <int, Sprite>{0: Sprite(image)};
}

