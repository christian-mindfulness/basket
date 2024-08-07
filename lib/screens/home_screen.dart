import 'package:basket/screens/choose_level_screen.dart';
import 'package:basket/screens/editor_screen.dart';
import 'package:basket/screens/load_level_screen.dart';
import 'package:basket/widgets/elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Basket!',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 33,
                ),
              ),
              BigCircle(
                onPressed: () {
                    debugPrint('Pressed select level');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ChooseLevelScreen(),
                      ),
                    );
                  },
                text: 'Select level',
                backgroundColor: Colors.deepPurple,
                size: 150,
              ),
              BigCircle(
                onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoadLevelScreen(),
                        ),
                    );
                  },
                text: 'Level designer',
                backgroundColor: Colors.indigoAccent,
                size: 150,
              ),
              BigCircle(
                onPressed: (){
                  print('Pressed credits');
                },
                text: 'Credits',
                backgroundColor: Colors.indigo,
                size: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}