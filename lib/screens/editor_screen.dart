import 'package:basket/widgets/level_options_dialog.dart';
import 'package:basket/widgets/text_info_dialog.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/world_editor.dart';
import '../game/game_state.dart';
import '../overlays/editor_overlay.dart';
import '../overlays/save_overlay.dart';
import '../widgets/resize_dialog.dart';

class WorldEditorScreen extends StatefulWidget {
  const WorldEditorScreen({
    super.key,
    required this.levelName,
    required this.refreshList,
  });
  final String levelName;
  final Function refreshList;

  @override
  State<WorldEditorScreen> createState() => _WorldEditorScreenState();
}

class _WorldEditorScreenState extends State<WorldEditorScreen> {
  final Game _game = WorldEditorGame();


  @override
  void initState() {
    GameState gameState = GameState();
    gameState.setLevel(name: widget.levelName);
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
            game: _game,
            overlayBuilderMap: <String,
                Widget Function(BuildContext, Game)>{
              'editorOverlay': (context, game) => EditorOverlay(game),
              'resizeOverlay': (context, game) => NewOverlay(game),
              'levelOptionsOverlay': (context, game) => LevelOptionsOverlay(game),
              'textInfoOverlay': (context, game) => TextInfoOverlay(game),
              'saveOverlay': (context, game) => SaveOverlay(game),
            },
          );
        }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: _offsetPopup(
            context,
            _game as WorldEditorGame,
            widget.refreshList,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


Widget _offsetPopup(
    BuildContext screenContext,
    WorldEditorGame game,
    Function refreshList,
    ) {
  List<PopupMenuItem<int>> extraItems = [
    PopupMenuItem(
      child: const Text(
        "Level options",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700),
      ),
      onTap: (){
        debugPrint('Level options');
        game.showLevelOptionsDialogue();
      },
    ),
    PopupMenuItem(
      child: const Text(
        "Edit information",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700),
      ),
      onTap: (){
        debugPrint('Level information dialogue');
        game.setLevelInformation();
      },
    ),
  ];

  return PopupMenuButton<int>(
      itemBuilder: (context) =>
      Components.values.map((e) =>
          PopupMenuItem<int>(
            child: Text(
              "Add ${game.getElementName(e)}",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
            onTap: (){
              debugPrint('Add ${game.getElementName(e)}');
              game.addComponent(e);
            },
          ),
      ).toList() + extraItems + [
        PopupMenuItem(
          child: const Text(
            "Save level",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700),
          ),
          onTap: (){
            debugPrint('Save level');
            game.startSaveRequest(exit: (){
              refreshList();
              Navigator.pop(screenContext);
            });
          },
        ),
        PopupMenuItem(
          child: const Text(
            "Exit without saving",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700),
          ),
          onTap: (){
            debugPrint('Exit');
            Navigator.pop(screenContext);
          },
        ),
      ],
      icon: const Icon(
        Icons.add,
        size: 25,
        color: Colors.white,
      )
  );
}


