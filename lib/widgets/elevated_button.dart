import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const MyElevatedButton({required this.onPressed, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return const Color(0xAA444444);
          },
        ),),
        onPressed: () {onPressed();},
        child: Text(text),
      ),
    );
  }
}


class BigCircle extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color backgroundColor;
  final double size;

  const BigCircle({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.size,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: RawMaterialButton(
        fillColor: backgroundColor,
        shape: const CircleBorder(),
        onPressed: () {onPressed();},
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.add,
              size: size,
              color: const Color(0x00000000),
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        )
      ),
    );
  }
}
