import 'dart:ui';

import 'package:basket/game/world_editor.dart';
import 'package:basket/utils/level_options.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class TextInfoOverlay extends StatefulWidget {
  const TextInfoOverlay(this.game, {Key? key}) : super(key: key);
  final Game game;

  @override
  State<TextInfoOverlay> createState() => _TextInfoOverlayState();
}

class _TextInfoOverlayState extends State<TextInfoOverlay> {
  String levelInfoTitle = '';
  String levelInfoText = '';
  late final String initialLevelInfoTitle;
  late final String initialLevelInfoText;

  @override
  void initState() {
    initialLevelInfoTitle = (widget.game as WorldEditorGame).getLevelInfoTitle;
    initialLevelInfoText = (widget.game as WorldEditorGame).getLevelInfoText;
    levelInfoTitle = initialLevelInfoTitle;
    levelInfoText = initialLevelInfoText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () {
          (widget.game as WorldEditorGame).hideLevelOptionsDialogue();
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
                height: 500,
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
                child: ListView(
                  children: getWidgetList(),
                ),
              ),
            ),
          ),
        ),
      );
  }

  List<Widget> getWidgetList() {
    List<Widget> result = [
      const Text('Set information text ...',
        style: TextStyle(color: Colors.blue),),
    ];

    result += [
      const SizedBox(height: 20,),

      TextFormField(
        initialValue: levelInfoTitle,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Title',
        ),
        onChanged: (String value){
          setState(() {
            levelInfoTitle = value;
          });
        },
      ),

      const SizedBox(height: 10,),

      TextFormField(
        minLines: 8,
        maxLines: null,
        initialValue: levelInfoText,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Main text',
        ),
        onChanged: (String value){
          setState(() {
            levelInfoText = value;
          });
        },
      ),

      const SizedBox(height: 10,),
    ];

    // Add the OK and cancel buttons
    result.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                (widget.game as WorldEditorGame).setLevelInfoTitle(levelInfoTitle);
                (widget.game as WorldEditorGame).setLevelInfoText(levelInfoText);
                (widget.game as WorldEditorGame).hideTextInfoDialog();
              },
              child: Container(
                  color: Colors.deepPurple,
                  padding: const EdgeInsets.all(10),
                  child: const Text('OK', style: TextStyle(color: Colors.blue),),
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('Reset text info');
                (widget.game as WorldEditorGame).hideTextInfoDialog();
              },
              child: Container(
                color: Colors.deepPurple,
                padding: const EdgeInsets.all(10),
                child: const Text('Cancel', style: TextStyle(color: Colors.blue),),
              ),
            ),
          ],
        )
    );
    return result;
  }
}