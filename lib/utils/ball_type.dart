import '../sprites/player.dart';

BallType getTypeFromString(String typeString) {
  BallType result = BallType.basket;
  for (var currentType in BallType.values) {
    if (ballNames[currentType] == typeString) {
      result = currentType;
    }
  }
  return result;
}
