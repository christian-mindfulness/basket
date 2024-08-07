import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/elevated_button.dart';

class VictoryOverlay extends StatelessWidget {
  const VictoryOverlay(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    debugPrint('Is user level : ${(game as BasketBall).gameState.getIsUserLevel}');
    debugPrint('Is asset : ${(game as BasketBall).gameState.getIsAsset}');
    return Scaffold(
      backgroundColor: const Color(0x66bbbbbb),
      body:
        SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Congratulations',
          style: TextStyle(fontSize: 24,
              color: Colors.black),),
        MyElevatedButton(
            onPressed: (){
              debugPrint('Calling reset');
              (game as BasketBall).reset();
              },
            text: 'Replay level'),
        !(game as BasketBall).gameState.getIsAsset ?
          const SizedBox() :
          MyElevatedButton(
            onPressed: (){
              (game as BasketBall).nextLevel();
              },
            text: 'Next level'),
        MyElevatedButton(
            onPressed: (){
              (game as BasketBall).quit();
              },
            text: 'Main menu'),
      ],
    ),),);
  }
}
