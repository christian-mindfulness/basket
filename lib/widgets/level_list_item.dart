import 'package:flutter/material.dart';

class LevelListItem extends StatelessWidget {
  final Function playFunction;
  final Function editFunction;
  final Function deleteFunction;
  final String text;

  const LevelListItem({
    required this.playFunction,
    required this.editFunction,
    required this.deleteFunction,
    required this.text,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        tileColor: const Color(0xffcccccc),
        leading: Text(text),
        trailing: SizedBox(
          width: 150,
          child: Row(
            children: [
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.delete,
                    size: 40,
                  ),
                ),
                onTap: (){
                  deleteFunction();
                },
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.play_circle,
                    size: 40,
                  ),
                ),
                onTap: (){
                  playFunction();
                },
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.edit,
                    size: 40,
                  ),
                ),
                onTap: (){
                  editFunction();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}