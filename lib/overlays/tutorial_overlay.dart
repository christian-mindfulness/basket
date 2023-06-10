import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/elevated_button.dart';

class TutorialOverlay extends StatelessWidget {
  const TutorialOverlay(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    int level = (game as BasketBall).getLevel();
    return Scaffold(
      backgroundColor: const Color(0xccffffff),
      body:
          Padding(padding: const EdgeInsets.all(10),
          child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: getLevelInfo(level),
        ),),),);
  }

  List<Widget> getLevelInfo(int level) {
    switch (level) {
      case 1: {
        return [
          const Text('Objective:',
            style: TextStyle(fontSize: 36,
                color: Colors.indigo),),
          const Text('Get the ball into the basket',
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          const Text('Controls:',
            style: TextStyle(fontSize: 36,
                color: Colors.indigo),),
          const Text('Flick the screen to give a nudge to the ball',
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          MyElevatedButton(
              onPressed: (){
                (game as BasketBall).clearTutorialOverlay();
                },
              text: 'OK'),
        ];
      }

      case 2: {
        return [
          const Text('Congratulations!',
            style: TextStyle(fontSize: 36,
                color: Colors.indigo),),
          const SizedBox(height: 30,),
          const Text('The direction of your flick will set the direction of the nudge',
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          const Text('The faster your flick, the bigger the nudge',
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          const Text("There's a 1s cool-down between nudges",
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          MyElevatedButton(
              onPressed: (){
                (game as BasketBall).clearTutorialOverlay();
                },
              text: 'OK'),
        ];
      }

      case 3: {
        return [
          const Text('Congratulations!',
            style: TextStyle(fontSize: 36,
                color: Colors.indigo),),
          const SizedBox(height: 30,),
          const Text('By timing your nudges you can bounce very high',
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          const Text("Here's a tough one",
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          MyElevatedButton(
              onPressed: (){
                (game as BasketBall).clearTutorialOverlay();
                },
              text: 'OK'),
        ];
      }

      case 4: {
        return [
          const Text('Congratulations!',
            style: TextStyle(fontSize: 36,
                color: Colors.indigo),),
          const SizedBox(height: 30,),
          const Text('Avoid the spiky things',
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          const Text("You don't want your ball to pop!",
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          MyElevatedButton(
              onPressed: (){
                (game as BasketBall).clearTutorialOverlay();
                },
              text: 'OK'),
        ];
      }

      default: {
        return [
          const Text('Well done!',
            style: TextStyle(fontSize: 36,
                color: Colors.indigo),),
          const SizedBox(height: 30,),
          const Text("Now let's try some of the main levels",
            style: TextStyle(fontSize: 24,
                color: Colors.black54),),
          const SizedBox(height: 30,),
          MyElevatedButton(
              onPressed: (){
                (game as BasketBall).mainMenu();
                },
              text: 'Main menu'),
        ];
      }
    }
  }
}

