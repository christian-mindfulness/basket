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
  Color boxColour1 = Colors.green;
  Color boxColour2 = Colors.green;
  Color boxColour3 = Colors.green;

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
            Vector2 impulseSize = (locationEnd - locationStart!) * (150.0 / (currentTime - startTime!));
            if (impulseSize.length > 500) {
              impulseSize *= 500 / impulseSize.length;
            }
            print('impulseSize = $impulseSize');
            (widget.game as BasketBall).playerImpulse(impulseSize);
            endTime = currentTime;
            locationStart = null;
            setState((){
              boxColour1 = Colors.red;
              boxColour2 = Colors.red;
              boxColour3 = Colors.red;
            });
            Future.delayed(const Duration(milliseconds: 333), (){
              if (mounted) {
                setState((){
                  boxColour1 = Colors.green;
                });
              }
            });
            Future.delayed(const Duration(milliseconds: 667), (){
              if (mounted) {
                setState((){
                  boxColour2 = Colors.green;
                });
              }
            });
            Future.delayed(const Duration(milliseconds: 1000), (){
              if (mounted) {
                setState((){
                  boxColour3 = Colors.green;
                });
              }
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Stack(
            children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const SizedBox(width: 10,),
                SizedBox(
                    width: 10,
                    height: 10,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: boxColour1
                        ))),
                const SizedBox(width: 10,),
                SizedBox(
                    width: 10,
                    height: 10,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: boxColour2
                        ))),
                const SizedBox(width: 10,),
                SizedBox(
                    width: 10,
                    height: 10,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: boxColour3
                        ))),
              ],)
]),
Positioned(
top: 0,
right: 20,
    child: ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              return Color(0xAA444444);
        },
      ),),
    child: (widget.game as BasketBall).isPaused()
    ? const Icon(
    Icons.play_arrow,
    size: 48,
    )
        : const Icon(
    Icons.pause,
    size: 48,
    ),
    onPressed: () {
    (widget.game as BasketBall).togglePauseState();
    },
    ),
    ),
              (widget.game as BasketBall).isPaused() ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return const Color(0xAA444444);
            },
          ),),
          child: const Text('Level 1'),
          onPressed: (){
            (widget.game as BasketBall).setLevel(1);
            (widget.game as BasketBall).togglePauseState();
            },),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return const Color(0xAA444444);
              },
            ),),
            child: const Text('Level 2'),
            onPressed: (){
              (widget.game as BasketBall).setLevel(2);
              (widget.game as BasketBall).togglePauseState();
            },),],),) :
              const SizedBox(height: 10),]
    )));
  }
}
