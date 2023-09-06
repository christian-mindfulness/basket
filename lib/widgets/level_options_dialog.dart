import 'dart:ui';

import 'package:basket/game/world_editor.dart';
import 'package:basket/utils/level_options.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LevelOptionsOverlay extends StatefulWidget {
  const LevelOptionsOverlay(this.game, {Key? key}) : super(key: key);
  final Game game;

  @override
  State<LevelOptionsOverlay> createState() => _LevelOptionsOverlayState();
}

class _LevelOptionsOverlayState extends State<LevelOptionsOverlay> {
  late LevelOptions levelOptions;
  late final LevelOptions initialLevelOptions;

  @override
  void initState() {
    initialLevelOptions = (widget.game as WorldEditorGame).getLevelOptions();
    levelOptions = initialLevelOptions;
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
      const Text('Set level options ...',
        style: TextStyle(color: Colors.blue),),
    ];

    result += [
      const Text('Gravity',
        style: TextStyle(color: Colors.blue),),
      Text('Vertical: +ve is down ${levelOptions.gravity.y.toStringAsFixed(0)}',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: levelOptions.gravity.y,
          min: -40,
          max: 40,
          divisions: 80,
          onChanged: (double value) {
            setState(() {
              debugPrint('New gravity y = $value');
              setState(() {
                levelOptions.gravity.y = value;
                (widget.game as WorldEditorGame).setLevelOptions(levelOptions);
              });
            });
          }
      ),

      Text('Horizontal: +ve is right ${levelOptions.gravity.x.toStringAsFixed(0)}',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: levelOptions.gravity.x,
          min: -40,
          max: 40,
          divisions: 80,
          onChanged: (double value) {
            setState(() {
              debugPrint('New gravity x = $value');
              setState(() {
                levelOptions.gravity.x = value;
                (widget.game as WorldEditorGame).setLevelOptions(levelOptions);
              });
            });
          }),

      Text('Flick cool down ${levelOptions.flickCoolDown.toStringAsFixed(1)}s',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: levelOptions.flickCoolDown,
          min: 0,
          max: 5,
          divisions: 50,
          onChanged: (double value) {
            setState(() {
              debugPrint('New flick cool down = $value');
              setState(() {
                levelOptions.flickCoolDown = value;
                (widget.game as WorldEditorGame).setLevelOptions(levelOptions);
              });
            });
          }),

      Text('Flick strength ${levelOptions.flickPower.toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: levelOptions.flickPower,
          min: 0,
          max: 400,
          divisions: 40,
          onChanged: (double value) {
            setState(() {
              debugPrint('New flick power = $value');
              setState(() {
                levelOptions.flickPower = value;
                (widget.game as WorldEditorGame).setLevelOptions(levelOptions);
              });
            });
          }),

      Text('Flick max strength ${levelOptions.flickMaximum.toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: levelOptions.flickMaximum,
          min: 0,
          max: 400,
          divisions: 40,
          onChanged: (double value) {
            setState(() {
              debugPrint('New flick maximum = $value');
              setState(() {
                levelOptions.flickMaximum = value;
                (widget.game as WorldEditorGame).setLevelOptions(levelOptions);
              });
            });
          }),

      Text('Air resistance ${levelOptions.airResistance.toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: levelOptions.airResistance,
          min: 0,
          max: 1000,
          divisions: 100,
          onChanged: (double value) {
            setState(() {
              debugPrint('New air resistance = $value');
              setState(() {
                levelOptions.airResistance = value;
                (widget.game as WorldEditorGame).setLevelOptions(levelOptions);
              });
            });
          }),
      ];

    // Add the OK and cancel buttons
    result.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                (widget.game as WorldEditorGame).hideLevelOptionsDialogue();
              },
              child: const Text('OK', style: TextStyle(color: Colors.blue),),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  levelOptions.resetToDefault();
                });
              },
              child: const Text('Reset to\ndefault', style: TextStyle(color: Colors.blue),),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('Reset options $initialLevelOptions');
                (widget.game as WorldEditorGame).setLevelOptions(initialLevelOptions);
                (widget.game as WorldEditorGame).hideLevelOptionsDialogue();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue),),
            ),
          ],
        )
    );
    return result;
  }
}