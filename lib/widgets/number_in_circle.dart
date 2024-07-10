import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game/game_state.dart';

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


class NumberCircle2 extends StatelessWidget {
  final double size;
  final int number;
  final Color color;
  final LevelState levelState;

  const NumberCircle2({
    super.key,
    required this.size,
    required this.number,
    required this.color,
    required this.levelState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.circle_outlined,
            size: size,
            color: Colors.red,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
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
          Positioned(
            bottom: size / 6,
            left: size / 2,
            child: bottomLeft(),
          ),
          // Positioned(
          //   bottom: size / 6,
          //   left: 5 * size / 6,
          //   child: Icon(
          //     Icons.star_border,
          //     size: size / 3,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget bottomLeft() {
    Widget result;
    switch (levelState) {
      case LevelState.locked:
        result = Icon(
          Icons.lock_outline,
          size: size / 3,
          color: Colors.grey,
          weight: 100,
        );
      case LevelState.unlocked:
        result = Icon(
          Icons.lock_open,
          size: size / 3,
          color: Colors.green,
        );
      case LevelState.completed:
        result = Container(
          color: const Color(0xaaffffff),
          child: Icon(
            CupertinoIcons.checkmark,
            size: size / 2,
            color: Colors.green,
            weight: 100,
          ),
        );
      case LevelState.starred:
        result = Icon(
          Icons.star,
          size: size / 3,
          color: Colors.yellow,
        );
    }
    return result;
  }
}

class LevelIcon extends StatelessWidget {
  final double size;
  final int number;
  final Color color;
  final LevelState levelState;

  const LevelIcon({
    super.key,
    required this.size,
    required this.number,
    required this.color,
    required this.levelState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Container(
              height: 2*size/3,
              width: 2*size/3,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.dstATop
                  ),
                  image: const AssetImage('assets/images/basket_ball.png')
                ),
              ),
              child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 20,
                      color: levelState == LevelState.locked ? Colors.black38 : Colors.black,
                    ),
                  ),
              ),
            ),
          ),
          Positioned(
            bottom: size / 6,
            child: levelState == LevelState.starred || levelState == LevelState.completed ? SizedBox(
              width: 2*size/3,
              height: size/2.5,
              child: AspectRatio(
                aspectRatio: 2,
                child: Image.asset(
                  'assets/images/game/basket.png',
                  fit: BoxFit.fill,
                ),
              ),
            ) : SizedBox(
              width: 2*size/3,
              height: size/2.5,
            ),
          ),
          Positioned(
            top: size/8,
            child: levelState == LevelState.starred ? Image.asset(
              'assets/images/game/gold-cup-icon.png',
              width: size/2,
              height: size/2,
            ) : SizedBox(
              width: size/2,
              height: size/2,
            )
          ),
        ],
      ),
    );
  }

  Widget bottomLeft() {
    Widget result;
    switch (levelState) {
      case LevelState.locked:
        result = Icon(
          Icons.lock_outline,
          size: size / 3,
          color: Colors.grey,
          weight: 100,
        );
      case LevelState.unlocked:
        result = Icon(
          Icons.lock_open,
          size: size / 3,
          color: Colors.green,
        );
      case LevelState.completed:
        result = Container(
          color: const Color(0xaaffffff),
          child: Icon(
            CupertinoIcons.checkmark,
            size: size / 2,
            color: Colors.green,
            weight: 100,
          ),
        );
      case LevelState.starred:
        result = Icon(
          Icons.star,
          size: size / 3,
          color: Colors.yellow,
        );
    }
    return result;
  }
}