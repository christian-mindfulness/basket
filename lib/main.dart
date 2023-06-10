import 'package:basket/game/world_editor.dart';
import 'package:basket/overlays/editor_overlay.dart';
import 'package:basket/screens/home_screen.dart';
import 'package:basket/sprites/draggable.dart';
import 'package:basket/widgets/resize_dialog.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/basket_game.dart';
import 'overlays/failed_overlay.dart';
import 'overlays/game_overlay.dart';
import 'screens/main_menu.dart';
import 'overlays/save_overlay.dart';
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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//final Game game = BasketBall();
