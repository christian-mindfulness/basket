import 'dart:math';

import 'package:basket/game/basket_game.dart';
import 'package:basket/utils/level_options.dart';
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
  int endTime = DateTime.now().millisecondsSinceEpoch - 10000;
  double progress = 1;
  static const Color lightGrey = Color(0x44ffffff);
  static const Color darkGrey = Color(0x44777777);
  static const Color clear = Color(0x00ffffff);
  Color progressBackground = clear;
  Color progressForeground = clear;

  @override
  Widget build(BuildContext context) {
    LevelOptions levelOptions = (widget.game as BasketBall).getLevelOptions;
    return Listener(
      onPointerDown: (PointerDownEvent details){
        locationStart = Vector2(details.position.dx, details.position.dy);
        startTime = DateTime.now().millisecondsSinceEpoch;
        },
      onPointerUp: (PointerUpEvent details) {
        Vector2 locationEnd = Vector2(details.position.dx, details.position.dy);
        //print('$locationStart  $locationEnd');
        int currentTime = DateTime.now().millisecondsSinceEpoch;
        //int timeSinceLast = currentTime - endTime;
        debugPrint('Flick: Time difference:  $endTime   ${DateTime.now().millisecondsSinceEpoch}  $progress');
        if (locationStart != null && progress > 0) {
          //print('Change = ${locationEnd - locationStart!}');
          Vector2 impulseSize = (locationEnd - locationStart!) * (1.5 * levelOptions.flickPower / (currentTime - startTime!));
          if (impulseSize.length > 5 * levelOptions.flickMaximum) {
            impulseSize *= 5 * levelOptions.flickMaximum / impulseSize.length;
          }
          impulseSize *= progress;
          debugPrint('impulseSize = $impulseSize');
          (widget.game as BasketBall).playerImpulse(impulseSize);
          setState(() {
            endTime = currentTime;
            progress = 0;
            progressBackground = lightGrey;
            progressForeground = darkGrey;
          });
          locationStart = null;
          // setState((){
          //   boxColour1 = red;
          //   boxColour2 = red;
          //   boxColour3 = red;
          // });
          Future.delayed(const Duration(milliseconds: 10), (){
            updateCoolDown();
            // if (mounted) {
            //   setState((){
            //     boxColour1 = green;
            //   });
            // }
          });
          // Future.delayed(Duration(milliseconds: (666.66 * levelOptions.flickCoolDown).toInt()), (){
          //   if (mounted) {
          //     setState((){
          //       boxColour2 = green;
          //     });
          //   }
          // });
          // Future.delayed(Duration(milliseconds: (1000 * levelOptions.flickCoolDown).toInt()), (){
          //   if (mounted) {
          //     setState((){
          //       boxColour3 = green;
          //     });
          //   }
          // });
        }
      },
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        child: Stack(
            children: [
              Center(
                child:
                  CircularProgressIndicator(
                    value: progress,
                    color: progressForeground,
                    backgroundColor: progressBackground,
                  )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const SizedBox(width: 10,),
                //     SizedBox(
                //         width: 10,
                //         height: 10,
                //         child: DecoratedBox(
                //             decoration: BoxDecoration(
                //                 color: boxColour1
                //             ))),
                //     const SizedBox(width: 10,),
                //     SizedBox(
                //         width: 10,
                //         height: 10,
                //         child: DecoratedBox(
                //             decoration: BoxDecoration(
                //                 color: boxColour2
                //             ))),
                //     const SizedBox(width: 10,),
                //     SizedBox(
                //       width: 10,
                //       height: 10,
                //       child: DecoratedBox(
                //         decoration: BoxDecoration(
                //             color: boxColour3
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
              Positioned(
                top: 0,
                right: 20,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return const Color(0xAA444444);
                    },
                  ),
                  ),
                  child: (widget.game as BasketBall).isPaused() ? const Icon(
                    Icons.play_arrow,
                    size: 48,
                  ) : const Icon(
                    Icons.pause,
                    size: 48,
                  ),
                  onPressed: () {
                    setState(() {
                      debugPrint('Toggle pause: endTime = $endTime');
                      endTime = (DateTime.now().millisecondsSinceEpoch - 1000 * levelOptions.flickCoolDown).toInt();
                      progress = 1;
                      updateCoolDown();
                    });
                    (widget.game as BasketBall).togglePauseState();
                  },
                ),
              ),
              (widget.game as BasketBall).isPaused() ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                        return const Color(0xAA444444);
                      },
                      ),
                      ),
                      child: const Text('Restart'),
                      onPressed: (){
                        (widget.game as BasketBall).reset();
                        (widget.game as BasketBall).unPause();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            return const Color(0xAA444444);
                          },
                        ),
                      ),
                      child: const Text('Quit'),
                      onPressed: (){
                        (widget.game as BasketBall).quit();
                      },
                    ),
                  ],
                ),
              ) : const SizedBox(height: 10),]
        ),
      ),
    );
  }

  double getCoolDownFraction() {
    double coolDown = (widget.game as BasketBall).getLevelOptions.flickCoolDown;
    double fraction = (DateTime.now().millisecondsSinceEpoch - endTime) / (1000 * coolDown);
    fraction = max(min(1.0, fraction), 0);
    return fraction;
  }

  void updateCoolDown() {
    double fraction = getCoolDownFraction();
    const double threshold = 0.3;
    if (mounted) {
      if (fraction < 0.9999) {
        setState(() {
          progressForeground = darkGrey;
          if (fraction < threshold) {
            progress = 0;
          } else {
            progress = (fraction - threshold) / (1 - threshold);
          }
        });
        Future.delayed(const Duration(milliseconds: 10), (){
          updateCoolDown();
        });
      } else {
        setState(() {
          progress = 1;
        });
        Future.delayed(const Duration(milliseconds: 200), (){
          if (getCoolDownFraction() > 0.9999) {
            setState(() {
              progressForeground = clear;
              progressBackground = clear;
            });
          }
        });
      }
    }
  }
}
