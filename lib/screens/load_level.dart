import 'package:basket/screens/editor_screen.dart';
import 'package:basket/widgets/elevated_button.dart';
import 'package:basket/widgets/level_list_item.dart';
import 'package:flutter/material.dart';

import '../utils/files.dart';

class LoadLevelScreen extends StatefulWidget {
  const LoadLevelScreen({super.key});

  @override
  State<LoadLevelScreen> createState() => _LoadLevelScreenState();
}

class _LoadLevelScreenState extends State<LoadLevelScreen> {
  List<String> fNames = [];

  @override
  void initState() {
    getFileNames();
    super.initState();
  }

  Future<void> getFileNames () async {
    List<String> fNamesTemp = await getLevelList();
    debugPrint('File names: $fNamesTemp');
    setState(() {
      fNames = fNamesTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the list of widgets to show
    List<Widget> widgetList = fNames.map<Widget>((e) => LevelListItem(
      text: e,
      playFunction: (){
        debugPrint('Play $e');
      },
      editFunction: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              WorldEditorScreen(levelName: e),
          ),
        );
        debugPrint('Edit $e');
      })).toList();

    widgetList.add(MyElevatedButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const WorldEditorScreen(levelName: '')
            ),
          );
        },
        text: 'Create new level'
    ));

    return Scaffold(body:
    SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgetList
      ),
      ),
    );
  }
}