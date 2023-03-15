import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});
  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  Vector2? locationStart;
  int? startTime;
  int endTime = DateTime.now().millisecondsSinceEpoch - 1000;

  @override
  Widget build(BuildContext context) {
    return Listener(onPointerDown: (PointerDownEvent details){
      locationStart = Vector2(details.position.dx, details.position.dy);
      startTime = DateTime.now().millisecondsSinceEpoch;
    },
        onPointerUp: (PointerUpEvent details) {
          Vector2 locationEnd = Vector2(details.position.dx, details.position.dy);
          //print('$locationStart  $locationEnd');
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int timeSinceLast = currentTime - endTime;
          // print('timeSinceLast = $timeSinceLast  $endTime   ${DateTime.now().millisecondsSinceEpoch}');
          if (locationStart != null && timeSinceLast > 1000) {
            //print('Change = ${locationEnd - locationStart!}');
            Vector2 impulseSize = (locationEnd - locationStart!) * (100.0 / (currentTime - startTime!));
            if (impulseSize.length > 400) {
              impulseSize *= 400 / impulseSize.length;
            }
            print('impulseSize = $impulseSize');
            (widget.game as BasketBall).playerImpulse(impulseSize);
            endTime = currentTime;
            locationStart = null;
          }
        },
        behavior: HitTestBehavior.translucent,
        child: const SizedBox(
      width: 800,
      height: 800,
    ));
  }
}
