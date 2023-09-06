import 'package:basket/screens/editor_screen.dart';
import 'package:basket/screens/play_level_screen.dart';
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlayLevelScreen(
                  levelName: e,
                  isAsset: false,
                ),
          ),
        );
        debugPrint('Play $e');
      },
      editFunction: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              WorldEditorScreen(
                levelName: e,
                refreshList: getFileNames,
              ),
          ),
        );
        debugPrint('Edit $e');
      },
      deleteFunction: () async {
        debugPrint('Delete $e');
        var result = await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete'),
            content: Text('Do you want to delete $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (result == "OK") {
          await deleteFile(e);
          getFileNames();
        }
        debugPrint('Result = $result');
      },
    )).toList();

    return Scaffold(body:
    Column(
      children: [
        Expanded(
          child: ListView(
              children: widgetList
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: MyElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WorldEditorScreen(
                            levelName: '',
                            refreshList: getFileNames,
                          )
                  ),
                );
              },
              text: 'Create new level'
          ),
        ),
      ]
    ),
    );
  }
}