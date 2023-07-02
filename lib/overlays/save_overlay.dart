import 'dart:ui';
import 'package:basket/game/game_state.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/world_editor.dart';

class SaveOverlay extends StatefulWidget {
  const SaveOverlay(this.game, {Key? key}) : super(key: key);
  final Game game;

  @override
  State<SaveOverlay> createState() => _NewOverlayState();
}

class _NewOverlayState extends State<SaveOverlay> {
  final GameState gameState = GameState();
  late String fName = gameState.getLevelName;

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () {
          (widget.game as WorldEditorGame).hideSaveOverlay();
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Level description:'),
                    SizedBox(
                        width: 230,
                        child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),),),
                          initialValue: gameState.getLevelName,
                          keyboardType: TextInputType.text,
                          onChanged: (String? value){
                            setState(() {
                              fName = value ?? '';
                            });
                          },),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            debugPrint('File name in dialogue $fName');
                            (widget.game as WorldEditorGame).saveFile(fName);
                          },
                          child: const Text('OK', style: TextStyle(color: Colors.blue),),
                        ),
                        GestureDetector(
                          onTap: () {
                            (widget.game as WorldEditorGame).hideSaveOverlay();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                    ],
                ),
              ),
            ),
          ),
        ),
      );
  }

}



