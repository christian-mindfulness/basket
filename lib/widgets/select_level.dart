import 'package:basket/game/game_state.dart';
import 'package:flutter/material.dart';
import '../screens/play_level_screen.dart';
import 'number_in_circle.dart';

class SelectLevel extends StatelessWidget {
  final int startLevel;
  final int endLevel;

  const SelectLevel({
    super.key,
    required this.startLevel,
    required this.endLevel,
  });

  @override
  Widget build (BuildContext context) {
    return Center(
      child: Column(
          children: [
            const Text(
              'Choose level',
              style: TextStyle(
                fontSize: 24,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(
              height: 400,
              width: 300,
              child: GridView.count(
                childAspectRatio: 1,
                crossAxisCount: 3,
                children: getLevelList(context),
              ),
            ),
          ]
      ),
    );
  }

  List<Widget> getLevelList (BuildContext context) {
    List<int> levelNumbers = List.generate(endLevel - startLevel + 1, (index) => startLevel + index);
    return levelNumbers.map((element) => GestureDetector(
      onTap: (){
        debugPrint('Button $element tapped');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlayLevelScreen(
                  levelName: 'Level${element.toString().padLeft(3, '0')}.json',
                  isAsset: true,
                ),
          ),
        );
      },
      child: LevelIcon(
        size: 50,
        number: element,
        color: Colors.red,
        levelState: getLevelState(element),
      ),
    ),
    ).toList();
  }

  LevelState getLevelState(int value) {
    if (value % 4 == 0) {
      return LevelState.locked;
    } else if (value % 4 == 1) {
      return LevelState.unlocked;
    } else if (value % 4 == 2) {
      return LevelState.completed;
    } else if (value % 4 == 3) {
      return LevelState.starred;
    } else {
      return LevelState.locked;
    }
  }
}