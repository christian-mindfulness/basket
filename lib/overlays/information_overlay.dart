import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/elevated_button.dart';

class InformationOverlay extends StatelessWidget {
  const InformationOverlay(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    String levelInfoTitle = (game as BasketBall).getLevelInfoTitle;
    String levelInfoText = (game as BasketBall).getLevelInfoText;
    return Scaffold(
      backgroundColor: const Color(0xccffffff),
      body:
      Padding(padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(levelInfoTitle,
                style: const TextStyle(fontSize: 36,
                    color: Colors.indigo),),
              Text(levelInfoText,
                style: const TextStyle(fontSize: 24,
                    color: Colors.black54),),
              MyElevatedButton(
                  onPressed: (){
                    (game as BasketBall).clearInformationOverlay();
                  },
                  text: 'OK'),
            ],
          ),),),);
  }
}

