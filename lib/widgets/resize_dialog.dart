import 'dart:math';
import 'dart:ui';

import 'package:basket/game/world_editor.dart';
import 'package:basket/sprites/player.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/movement.dart';

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
  late BallType ballType;
  late Movement movement;
  late final Vector2 initialSize;
  late final double initialAngle;
  late final BallType initialBallType;
  late final Movement initialMovement;

  @override
  void initState() {
    initialSize = (widget.game as WorldEditorGame).getSize().clone();
    initialAngle = (widget.game as WorldEditorGame).getAngle();
    initialBallType = (widget.game as WorldEditorGame).getBallType();
    initialMovement = (widget.game as WorldEditorGame).getMovement();
    sizeX = initialSize.x;
    sizeY = initialSize.y;
    angle = initialAngle;
    ballType = initialBallType;
    movement = initialMovement;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () {
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
          result.add(getBallTypeWidget());
          break;
        case Operations.movement:
          result += getMovementWidget();
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
              (widget.game as WorldEditorGame).setBallType(initialBallType);
              (widget.game as WorldEditorGame).setMovement(initialMovement);
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

  List<Widget> getMovementWidget() {
    return [
      CheckboxListTile(
        value: movement.allow,
        secondary: const Text('Allow movement'),
        onChanged: (bool? value){
          debugPrint(value.toString());
          setState(() {
            movement.allow = value!;
            (widget.game as WorldEditorGame).setMovement(movement);
          });
        },),
      movement.allow ? Text('Start position: ${(widget.game as WorldEditorGame).currentComp.position.x.toInt()}, ${(widget.game as WorldEditorGame).currentComp.position.y.toInt()}') :
        const SizedBox.shrink(),
      movement.allow ? Row(children: [
        const Text('End position: '),
        SizedBox(
          width: 50,
          child: TextFormField(
            initialValue: movement.position.x.toInt().toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (String? value){
              setState(() {
                movement.position.x = int.parse(value!).toDouble();
                (widget.game as WorldEditorGame).setMovement(movement);
              });
            },),),
        const Text(' ,'),
        SizedBox(
          width: 50,
          child: TextFormField(
            initialValue: movement.position.y.toInt().toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (String? value){
              setState(() {
                movement.position.y = int.parse(value!).toDouble();
                (widget.game as WorldEditorGame).setMovement(movement);
              });
            },),),
        ],)
        : const SizedBox.shrink(),
      movement.allow ? Row(children: [
        Text('Start angle: ${angle.toInt()}  End angle: '),
        SizedBox(
          width: 50,
          child: TextFormField(
            initialValue: movement.angle.toInt().toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (String? value){
              setState(() {
                movement.angle = radians(double.parse(value!));
                (widget.game as WorldEditorGame).setMovement(movement);
              });
            },),),
      ],) :
      const SizedBox.shrink(),
      movement.allow ? Row(children: [
        const Text('Time taken: '),
        SizedBox(
          width: 50,
          child: TextFormField(
            initialValue: movement.time.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[\d.]"))],
            onChanged: (String? value){
              setState(() {
                movement.time = double.parse(value!);
                (widget.game as WorldEditorGame).setMovement(movement);
              });
            },),),
      ],) :
      const SizedBox.shrink(),
    ];
  }

  Widget getBallTypeWidget() {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.all(10),
          child: Text('Ball type:',
          style: TextStyle(color: Colors.blue),),),
        DropdownButton(
            value: ballType,
            items: [
          DropdownMenuItem(value: BallType.basket, child: Text(ballNames[BallType.basket]!),),
          DropdownMenuItem(value: BallType.tennis, child: Text(ballNames[BallType.tennis]!),),
          DropdownMenuItem(value: BallType.metal, child: Text(ballNames[BallType.metal]!),),
          DropdownMenuItem(value: BallType.beach, child: Text(ballNames[BallType.beach]!),),
        ], onChanged: (BallType? type){
          print('Chosen $type');
          (widget.game as WorldEditorGame).setBallType(type!);
          setState(() {
            ballType = type;
          });
        }),
      ],
    );
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



