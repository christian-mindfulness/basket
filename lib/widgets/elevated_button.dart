import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final Function onPressed;
  final Game game;
  final String text;

  const MyElevatedButton({required this.onPressed, required this.game, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return const Color(0xAA444444);
          },
        ),),
        onPressed: () {onPressed();},
        child: Text(text),
      ),);
  }
}