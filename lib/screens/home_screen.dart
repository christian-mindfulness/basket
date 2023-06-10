import 'package:basket/screens/editor_screen.dart';
import 'package:basket/screens/load_level.dart';
import 'package:basket/widgets/elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              MyElevatedButton(
                  onPressed: (){
                    print('Pressed select level');
                  },
                  text: 'Select level'
              ),
              MyElevatedButton(
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
              ),
              MyElevatedButton(
                  onPressed: (){
                    print('Pressed credits');
                  },
                  text: 'Credits'
              ),
            ],
          ),
        ),
      ),
    );
  }
}