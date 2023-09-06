import 'dart:convert';
import 'package:basket/utils/component_list.dart';
import 'package:basket/utils/level_options.dart';

class ReadWriteGame {
  final ComponentList componentList;
  final LevelOptions levelOptions;
  final String levelInfoTitle;
  final String levelInfoText;

  ReadWriteGame({
    required this.componentList,
    required this.levelOptions,
    required this.levelInfoTitle,
    required this.levelInfoText,
  });

  ReadWriteGame.fromJson(Map<String, dynamic> json, Function showResize, bool isEditor) :
    componentList = ComponentList.fromJson(jsonDecode(json['componentList']), showResize, isEditor),
    levelOptions = LevelOptions.fromJson(jsonDecode(json['levelOptions'])),
    levelInfoTitle = jsonDecode(json['levelInfoTitle']),
    levelInfoText = jsonDecode(json['levelInfoText']);

  Map<String, dynamic> toJson() => {
    'componentList': jsonEncode(componentList),
    'levelOptions': jsonEncode(levelOptions),
    'levelInfoTitle': jsonEncode(levelInfoTitle),
    'levelInfoText': jsonEncode(levelInfoText),
  };
}