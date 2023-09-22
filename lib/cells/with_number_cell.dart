import 'package:flutter/material.dart';

class WithNumberCell extends StatelessWidget {
  final int number;
  const WithNumberCell({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Center(
        child: Text(
          number.toString(),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );
  }
}
