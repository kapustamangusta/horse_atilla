import 'dart:io';
import 'dart:math';

import 'package:attila_horse/models/my_state.dart';

class StateGenerator {
  final MyState state;
  StateGenerator(this.state) {}

  void GenerateStates() async {
    List<int> d = [2, 4, 6, 8, 10];
    List<int> dx = [2, 3, 5, 6, 6];
    List<int> dy = [1, 3, 4, 6, 7];
    // текст для записи
    File file = File("hello.txt");
    await file.writeAsString("");
    for (int i = 0; i < dx.length; i++) {
      await file.writeAsString("-------------------------------\n",
          mode: FileMode.append);
      await file.writeAsString("d: ${d[i]}\n", mode: FileMode.append);
      int count = 0;
      for (int y = 0; y <= state.row - dy[i] - 1; y++) {
        for (int x = 0; x <= state.column - dx[i] - 1; x++) {
          await file.writeAsString("-------------------------------\n",
              mode: FileMode.append);
          int xKing = x;
          int yKing = y;
          int xHorse = x + dx[i];
          int yHorse = y + dy[i];
          await file.writeAsString("Король: ${xKing} ${yKing}\n",
              mode: FileMode.append);
          await file.writeAsString("Конь: ${xHorse} ${yHorse}\n",
              mode: FileMode.append);
          Random random = Random();
          int countCells = random.nextInt(10);
          await file.writeAsString("Клетки: ", mode: FileMode.append);
          for (int indC = 0; indC < countCells; indC++) {
            int xCell = random.nextInt(state.column);
            int yCell = random.nextInt(state.row);
            await file.writeAsString("[${xCell},${yCell}], ", mode: FileMode.append);
          }
           await file.writeAsString("\n", mode: FileMode.append);
          // int xCell = random.x
          // Position posCell = Position(x, y)
          count++;
          if (count == 10) break;
        }
        if (count == 10) break;
      }
    }
    print("File has been written");
  }
}
