
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberCircle extends StatelessWidget {
  final double size;
  final int number;
  final Color color;

  const NumberCircle({
    super.key,
    required this.size,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 5.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              color: color,
              fontSize: size / 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}