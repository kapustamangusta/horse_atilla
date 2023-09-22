import 'package:flutter/material.dart';

import 'home_page.dart';
import 'models/my_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        state: MyState(
          burningCells: [
            Position(1, 7),
            Position(4, 7),
            Position(4, 4),
          ],
          usedCells: [
           
          ],
          row: 8,
          column: 8,
          kingPosition: Position(1, 0),
          horsePostion: Position(2, 2),
        ),
      ),
    );
  }
}
