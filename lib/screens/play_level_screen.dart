import 'package:basket/game/basket_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/game_state.dart';
import '../overlays/failed_overlay.dart';
import '../overlays/game_overlay.dart';
import '../overlays/tutorial_overlay.dart';
import '../overlays/victory_overlay.dart';
import 'main_menu.dart';

class PlayLevelScreen extends StatefulWidget {
  const PlayLevelScreen({super.key, required this.levelName});
  final String levelName;
  @override
  State<PlayLevelScreen> createState() => _PlayLevelScreenState();
}

class _PlayLevelScreenState extends State<PlayLevelScreen> {
  final Game basketGame = BasketBall();

  @override
  void initState() {
    GameState gameState = GameState();
    gameState.setLevel(name: widget.levelName);
    gameState.setExitCallBack(
        () {
          Navigator.pop(context);
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return GameWidget(
            game: basketGame,
            overlayBuilderMap: <String,
                Widget Function(BuildContext, Game)>{
              'gameOverlay': (context, basketGame) => GameOverlay(basketGame),
              'mainMenu': (context, basketGame) => MainMenu(basketGame),
              'victoryOverlay': (context, basketGame) => VictoryOverlay(basketGame),
              'failedOverlay': (context, basketGame) => FailedOverlay(basketGame),
              'tutorialOverlay': (context, basketGame) => TutorialOverlay(basketGame),
            },
          );
        }
        ),
      ),
    );
  }
}
