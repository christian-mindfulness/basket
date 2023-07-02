import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/elevated_button.dart';

class FailedOverlay extends StatelessWidget {
  const FailedOverlay(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(      backgroundColor: const Color(0x66333333),
      body:
        SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Bang!',
          style: TextStyle(fontSize: 24,
              color: Colors.black),),
        MyElevatedButton(
            onPressed: (){
              (game as BasketBall).reset();
              },
            text: 'Replay level'),
        MyElevatedButton(
            onPressed: (){
              (game as BasketBall).quit();
              },
            text: 'Main menu'),
      ],
    ),),);
  }
}