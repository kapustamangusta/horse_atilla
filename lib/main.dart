import 'package:attila_horse/services/state_generator.dart';
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
    final state = MyState(
          burningCells: [
            Position(1, 7),
            Position(4, 7),
            Position(4, 4),
          ],
          usedCells: [
           
          ],
          row: 11,
          column: 11,
          kingPosition: Position(0, 0),
          horsePostion: Position(7, 7),
        );
    StateGenerator(state).GenerateStates();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        state: state,
      ),
    );
  }
}
