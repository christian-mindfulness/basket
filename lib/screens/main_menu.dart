import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/elevated_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SizedBox(
      width: double.infinity,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Basket',
        style: TextStyle(fontSize: 24,
        color: Colors.black),),
        BigCircle(
          onPressed: (){
            (game as BasketBall).setLevel(1, type: 'T');
            },
          text: 'Tutorial',
          backgroundColor: Colors.deepPurple,
          size: 150,
        ),
        BigCircle(
          onPressed: (){
            (game as BasketBall).setLevel(1);
          },
          text: 'Level 1',
          backgroundColor: Colors.deepPurple,
          size: 150,
        ),
        BigCircle(
          onPressed: (){
            (game as BasketBall).setLevel(2);
          },
          text: 'Level 2',
          backgroundColor: Colors.deepPurple,
          size: 150,
        ),
      ],
    ),),);
  }
}