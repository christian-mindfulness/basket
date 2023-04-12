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
        MyElevatedButton(onPressed: (){
          (game as BasketBall).setLevel(1, type: 'T');
        }, game: game, text: 'Tutorial'),
        MyElevatedButton(onPressed: (){
          (game as BasketBall).setLevel(1);
        }, game: game, text: 'Level 1'),
        MyElevatedButton(onPressed: (){
          (game as BasketBall).setLevel(2);
        }, game: game, text: 'Level 2'),
      ],
    ),),);
  }
}