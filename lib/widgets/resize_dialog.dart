import 'dart:math';
import 'dart:ui';

import 'package:basket/game/world_editor.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ResizeOverlay extends StatelessWidget {
  const ResizeOverlay(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello')
    );
  }
}


class NewOverlay extends StatefulWidget {
  const NewOverlay(this.game, {Key? key}) : super(key: key);
  final Game game;

  @override
  State<NewOverlay> createState() => _NewOverlayState();
}

class _NewOverlayState extends State<NewOverlay> {
  late double sizeX;
  late double sizeY;
  late double angle;
  late final Vector2 initialSize;
  late final double initialAngle;

  @override
  void initState() {
    initialSize = (widget.game as WorldEditorGame).getSize().clone();
    initialAngle = (widget.game as WorldEditorGame).getAngle();
    sizeX = initialSize.x;
    sizeY = initialSize.y;
    angle = initialAngle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () {
          print('Outer tap');
          (widget.game as WorldEditorGame).hideResize();
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
                    children: getWidgetList((widget.game as WorldEditorGame).getOperations()),
                  ),
                ),
              ),
            ),
          ),
      );
  }

  List<Widget> getWidgetList(List<Operations> operationList) {
    List<Widget> result = [
      Text('Edit ${(widget.game as WorldEditorGame).getComponentName()}',
        style: const TextStyle(color: Colors.blue),),
    ];

    for (Operations operation in operationList) {
      switch (operation) {
        case Operations.resize:
          result += getResizeWidget();
          break;
        case Operations.rotate:
          result += getRotationWidget();
          break;
        case Operations.delete:
          result.add(getDeleteButton());
          break;
        case Operations.ballType:
        // TODO: Handle this case.
          break;
        case Operations.wallType:
        // TODO: Handle this case.
          break;
      }
    }

    // Add the OK and cancel buttons
    result.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              (widget.game as WorldEditorGame).hideResize();
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue),),
          ),
          GestureDetector(
            onTap: () {
              print('Reset size $initialSize');
              (widget.game as WorldEditorGame).setSize(initialSize);
              (widget.game as WorldEditorGame).setAngle(initialAngle);
              (widget.game as WorldEditorGame).hideResize();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.blue),),
          ),
        ],
      )
    );
    return result;
  }

  List<Widget> getRotationWidget() {
    return [
      Text('Angle ${angle.toInt()}',
      style: const TextStyle(color: Colors.blue),),
      Slider(
          value: angle,
          max: 360,
          divisions: 72,
          onChanged: (double value) {
            setState(() {
              angle = value;
              (widget.game as WorldEditorGame).setAngle(pi * value / 180);
            });
          }),
    ];
  }

  List<Widget> getResizeWidget() {
    return [
      Text('Width ${sizeX.toInt()}',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: sizeX,
          max: 800,
          divisions: 80,
          onChanged: (double value) {
            setState(() {
              sizeX = max(value, 10);
              Vector2 newSize = Vector2(sizeX.roundToDouble(),
                  sizeY.roundToDouble());
              (widget.game as WorldEditorGame).setSize(newSize);
            });
          }),
      Text('Height ${sizeY.toInt()}',
        style: const TextStyle(color: Colors.blue),),
      Slider(
          value: sizeY,
          max: 800,
          divisions: 80,
          onChanged: (double value) {
            setState(() {
              sizeY = max(value, 10);
              Vector2 newSize = Vector2(sizeX.roundToDouble(),
                  sizeY.roundToDouble());
              (widget.game as WorldEditorGame).setSize(newSize);
            });
          }),
    ];
  }

  Widget getDeleteButton() {
    return GestureDetector(
      onTap: () {
        (widget.game as WorldEditorGame).deleteComponent();
        (widget.game as WorldEditorGame).hideResize();
      },
      child: Container(
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.all(5),
          child: Text('Delete', style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}



