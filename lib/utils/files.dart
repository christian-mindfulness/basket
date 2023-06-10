import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String fName) async {
  final path = await localPath;
  return File('$path/$fName.json');
}

Future<List<String>> getLevelList() async {
  final directory = await localPath;
  final fileList = Directory(directory).listSync();
  debugPrint('File list = $fileList');
  List<String> result = [];
  for (var file in fileList) {
    String fName = basename(file.path);
    debugPrint('fName = $fName ${fName.endsWith('.json')}');
    if (fName.endsWith('.json')) {
      result.add(fName.substring(0, fName.length - 5));
    }
  }
  return result;
}