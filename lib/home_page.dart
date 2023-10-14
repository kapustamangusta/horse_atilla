import 'package:attila_horse/constructor_page.dart';
import 'package:attila_horse/field.dart';
import 'package:attila_horse/models/my_state.dart';
import 'package:attila_horse/results_page.dart';
import 'package:attila_horse/services/search_methods.dart';
import 'package:flutter/material.dart';

import 'models/report.dart';

class HomePage extends StatefulWidget {
  final MyState state;

  const HomePage({super.key, required this.state});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Result? results = null;

  Report report = Report(0, 0, 0, 0);

  String search = '';

  void _showDialog(Result result) {
    if (result.result.length == 0) {
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
    } else {
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
    }
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
            SingleChildScrollView(
              child: Column(
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
                        Text(
                          search,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                      results = SearchMethods().searchInDepth(widget.state);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "Поиск в глубину";
                      });
                    },
                    child: Text("Поиск в глубину"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      results = SearchMethods()
                          .depthFirstSearchWithIterativeDeepening(widget.state);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "Поиск в глубину с итеративным углублением";
                      });
                    },
                    child: Text("Поиск в глубину с итеративным углублением"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      results = SearchMethods().searchInWidth(widget.state);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "Поиск в ширирну";
                      });
                    },
                    child: Text("Поиск в ширирну"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      MyState end = MyState(
                          burningCells: widget.state.burningCells,
                          usedCells: [],
                          row: widget.state.row,
                          column: widget.state.column,
                          kingPosition: widget.state.kingPosition,
                          horsePostion: widget.state.horsePostion,
                          kingIsDefeat: true);
                      results = SearchMethods()
                          .bidirectionalSearch(widget.state, end);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "Двунаправленный поиск";
                      });
                    },
                    child: Text("Двунаправленный поиск"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      results = SearchMethods().aStar(widget.state, 1);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "A* Чебышев";
                      });
                    },
                    child: Text("A* Чебышев"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      results = SearchMethods().aStar(widget.state, 2);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "A* Манхеттен";
                      });
                    },
                    child: Text("A* Манхеттен"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      results = SearchMethods().aStar(widget.state, 3);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "A* Евклид";
                      });
                    },
                    child: Text("A* Евклид"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      results = SearchMethods().aStar(widget.state, 4);
                      _showDialog(results!);
                      setState(() {
                        report = results!.report;
                        search = "A* матрица";
                      });
                    },
                    child: Text("A* матрица"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  (results != null && results!.result.length != 0)
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => ResultsPage(
                                  results: results!.result,
                                ),
                              ),
                            );
                          },
                          child: Text("Посмотреть результаты"),
                        )
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
