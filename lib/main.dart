import 'package:basket/game/world_editor.dart';
import 'package:basket/overlays/editor_overlay.dart';
import 'package:basket/sprites/draggable.dart';
import 'package:basket/widgets/resize_dialog.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/basket_game.dart';
import 'overlays/failed_overlay.dart';
import 'overlays/game_overlay.dart';
import 'overlays/main_menu.dart';
import 'overlays/tutorial_overlay.dart';
import 'overlays/victory_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Basketball',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Basket'),
      debugShowCheckedModeBanner: false,
    );
  }
}

//final Game game = BasketBall();
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
        (game as WorldEditorGame).saveLevel();
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
