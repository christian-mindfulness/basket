import 'package:basket/screens/play_level_screen.dart';
import 'package:basket/widgets/number_in_circle.dart';
import 'package:flutter/material.dart';

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  List<String> fNames = [];
  final int startLevel = 1;
  final int endLevel = 12;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> getLevelList () {
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
        child: NumberCircle(
          size: 50,
          number: element,
          color: Colors.red,
        ),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Center(
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
                children: getLevelList(),
              ),
            ),
          ]
        ),
      ),
    );
  }
}