import 'package:basket/game/world_editor.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../widgets/elevated_button.dart';

class EditorOverlay extends StatelessWidget {
  const EditorOverlay(this.game,
      {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyElevatedButton(onPressed: (){
              (game as WorldEditorGame).addComponent(Components.brickWall);
            }, game: game, text: 'Add Brick'),
            MyElevatedButton(onPressed: (){
              (game as WorldEditorGame).addComponent(Components.woodWall);
            }, game: game, text: 'Add Wood'),
            MyElevatedButton(onPressed: (){
              (game as WorldEditorGame).addComponent(Components.spike);
            }, game: game, text: 'Add Spike'),
            MyElevatedButton(onPressed: (){
              (game as WorldEditorGame).addComponent(Components.star);
            }, game: game, text: 'Add Star'),
          ],
    );
  }
}