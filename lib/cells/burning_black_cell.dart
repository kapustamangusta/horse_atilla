import 'package:flutter/material.dart';

class BurningBlackCell extends StatelessWidget {
  const BurningBlackCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      color: Colors.black,
      child: Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      ),
    );
  }
}
