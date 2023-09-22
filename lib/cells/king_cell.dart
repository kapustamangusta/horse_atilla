import 'package:flutter/material.dart';

class KingCell extends StatelessWidget {
  const KingCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.yellow,
      child: Icon(Icons.man),
    );
  }
}
