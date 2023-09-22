import 'package:flutter/material.dart';

class HorseCell extends StatelessWidget {
  const HorseCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.green,
      child: Icon(Icons.adb_sharp),
    );
  }
}
