import 'package:flutter/material.dart';

import '../utils/files.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<String> fNames = [];

  @override
  void initState() {
    setState(() async {
      fNames = await getLevelList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: fNames.map((e) => Text(e,
            style: const TextStyle(fontSize: 24,
                color: Colors.black),)).toList()
        ),
      ),
    );
  }
}