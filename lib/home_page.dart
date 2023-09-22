import 'package:attila_horse/constructor_page.dart';
import 'package:attila_horse/field.dart';
import 'package:attila_horse/models/my_state.dart';
import 'package:attila_horse/results_page.dart';
import 'package:flutter/material.dart';

import 'models/report.dart';

class HomePage extends StatefulWidget {
  final MyState state;

  const HomePage({super.key, required this.state});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyState> results = [];
  List<MyState> O = [], C = [];

  Report report = Report(0, 0, 0, 0);
  List<int> moveX = [2, -1, -2, -2, 1, 2, 1, -1];
  List<int> moveY = [1, 2, 1, -1, -2, -1, 2, -2];
  void ConvertToList(MyState state) {
    MyState? currentState = state;
    results = [];
    while (currentState != null) {
      results.insert(0, currentState);
      currentState = currentState.prev;
    }
  }

  bool moveIsValid(MyState state, int dx, int dy) {
    return state.horsePostion.x + dx < state.column &&
        state.horsePostion.x + dx >= 0 &&
        state.horsePostion.y + dy < state.row &&
        state.horsePostion.y + dy >= 0 &&
        !state.burningCells.any((element) =>
            element ==
            Position(state.horsePostion.x + dx, state.horsePostion.y + dy)) &&
        !state.usedCells.any((element) =>
            element ==
            Position(state.horsePostion.x + dx, state.horsePostion.y + dy));
  }

  // поиск в глубину
  void searchInDepth() {
    report = Report(0, 0, 0, 0);
    O = [widget.state];
    C = [];

    Position startPosition = widget.state.horsePostion;

    results = [];
    while (O.length != 0) {
      MyState x = O.removeLast();
      

      if (x.kingIsDefeat && x.horsePostion == startPosition) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Результат найден!",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            );
          },
        );
        setState(() {
          report.maxLengthResultO = O.length;
        });
        return ConvertToList(x);
      }
      C.add(x);
      for (int i = 0; i < 8; i++) {
        if (moveIsValid(x, moveX[i], moveY[i])) {
          var usedCells = [...x.usedCells];
          usedCells.add(x.horsePostion);
          if (x.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          O.add(MyState(
            prev: x,
            burningCells: x.burningCells,
            usedCells: usedCells,
            row: x.row,
            column: x.column,
            kingPosition: x.kingPosition,
            kingIsDefeat: x.kingIsDefeat,
            horsePostion: Position(
                x.horsePostion.x + moveX[i], x.horsePostion.y + moveY[i]),
          ));
        }
      }
      setState(() {
        report.setData(O, C);
      });
    }
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "Результат не найден!",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }

  // поиск в ширину
  void searchInWidth() {
    report = Report(0, 0, 0, 0);
    O = [widget.state];
    C = [];

    Position startPosition = widget.state.horsePostion;

    results = [];
    while (O.length != 0) {
      MyState x = O.removeAt(0);
      if (x.kingIsDefeat && x.horsePostion == startPosition) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Результат найден!",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            );
          },
        );
        setState(() {
          report.maxLengthResultO = O.length;
        });
        return ConvertToList(x);
      }
      C.add(x);
      for (int i = 0; i < 8; i++) {
        if (moveIsValid(x, moveX[i], moveY[i])) {
          var usedCells = [...x.usedCells];
          usedCells.add(x.horsePostion);
          if (x.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          O.add(MyState(
            prev: x,
            burningCells: x.burningCells,
            usedCells: usedCells,
            row: x.row,
            column: x.column,
            kingPosition: x.kingPosition,
            kingIsDefeat: x.kingIsDefeat,
            horsePostion: Position(
                x.horsePostion.x + moveX[i], x.horsePostion.y + moveY[i]),
          ));
        }
      }
      setState(() {
        report.setData(O, C);
      });
    }
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "Результат не найден!",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Конь Aтиллы"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Field(state: widget.state),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: 400,
                  //height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('Количество итераций: ${report.countIteration}'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Макс. длинна О: ${report.maxLengthO}'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Макс. длинна О в конце: ${report.maxLengthResultO}'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Макс. длинна О+С: ${report.lengthOC}'),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ConstructorPage(state: widget.state),
                      ),
                    );
                  },
                  child: Text("Конструктор"),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      results = [];
                    });
                    searchInDepth();
                    setState(() {});
                  },
                  child: Text("Поиск в глубину"),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      results = [];
                    });
                    searchInWidth();
                    setState(() {});
                  },
                  child: Text("Поиск в ширирну"),
                ),
                SizedBox(
                  height: 16,
                ),
                results.length != 0
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ResultsPage(
                                results: results,
                              ),
                            ),
                          );
                        },
                        child: Text("Посмотреть результаты"),
                      )
                    : SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
