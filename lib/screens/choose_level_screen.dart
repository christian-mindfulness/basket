import 'package:basket/screens/play_level_screen.dart';
import 'package:basket/widgets/number_in_circle.dart';
import 'package:basket/widgets/select_level.dart';
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
  final _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      body: SafeArea(
        child: PageView(
          /// [PageView.scrollDirection] defaults to [Axis.horizontal].
          /// Use [Axis.vertical] to scroll vertically.
          controller: controller,
          children: const <Widget>[
            Center(
              child: SelectLevel(startLevel: 1, endLevel: 12),
            ),
            Center(
              child: SelectLevel(startLevel: 13, endLevel: 24),
            ),
            Center(
              child: SelectLevel(startLevel: 25, endLevel: 36),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}