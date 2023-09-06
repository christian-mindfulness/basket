import 'package:flame/components.dart';

List<Vector2> cloneList(List<Vector2> input) {
  List<Vector2> result = [];
  for (Vector2 item in input) {
    result.add(Vector2(item.x, item.y));
  }
  return result;
}