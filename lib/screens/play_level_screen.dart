import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/world_editor.dart';
import '../overlays/editor_overlay.dart';
import '../overlays/failed_overlay.dart';
import '../overlays/game_overlay.dart';
import '../overlays/save_overlay.dart';
import '../overlays/tutorial_overlay.dart';
import '../overlays/victory_overlay.dart';
import '../widgets/resize_dialog.dart';
import 'main_menu.dart';

final Game game = WorldEditorGame();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            game: game,
            overlayBuilderMap: <String,
                Widget Function(BuildContext, Game)>{
              'gameOverlay': (context, game) => GameOverlay(game),
              'mainMenu': (context, game) => MainMenu(game),
              'victoryOverlay': (context, game) => VictoryOverlay(game),
              'failedOverlay': (context, game) => FailedOverlay(game),
              'tutorialOverlay': (context, game) => TutorialOverlay(game),
              'editorOverlay': (context, game) => EditorOverlay(game),
              'resizeOverlay': (context, game) => NewOverlay(game),
              'saveOverlay': (context, game) => SaveOverlay(game),
            },
          );
        }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: _offsetPopup(),

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<PopupMenuItem<int>> extraItems = [
    PopupMenuItem(
      child: const Text(
        "Change gravity",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700),
      ),
      onTap: (){
        debugPrint('Change gravity');
        (game as WorldEditorGame).showGravityDialogue();
      },
    ),
    PopupMenuItem(
      child: const Text(
        "Load level",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700),
      ),
      onTap: (){
        debugPrint('Load level');
        (game as WorldEditorGame).loadLevel();
      },
    ),
    PopupMenuItem(
      child: const Text(
        "Save level",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700),
      ),
      onTap: (){
        debugPrint('Save level');
        (game as WorldEditorGame).startSaveRequest();
      },
    ),
  ];

  Widget _offsetPopup() => PopupMenuButton<int>(
      itemBuilder: (context) =>
      Components.values.map((e) =>
          PopupMenuItem<int>(
            child: Text(
              "Add ${(game as WorldEditorGame).getElementName(e)}",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
            onTap: (){
              debugPrint('Add ${(game as WorldEditorGame).getElementName(e)}');
              (game as WorldEditorGame).addComponent(e);
            },
          ),
      ).toList() + extraItems,
      icon: const Icon(
        Icons.add,
        size: 25,
        color: Colors.white,
      )
  );
}
