import 'package:flutter/material.dart';

class BurningWhiteCell extends StatelessWidget {
  const BurningWhiteCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      ),
    );
  }
}
