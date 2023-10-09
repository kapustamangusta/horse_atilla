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
  List<Result> res = [];
  List<Report> report = [Report(0, 0, 0, 0)];

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
    int index = -1;
    res =[];
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
                        ...report.map(
                          (e) {
                            index += 1;
                            List<String> searches = ['A* Чебышев','A* Манхеттен','A* Эвклид',];
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  res.length!=0 ? searches[index] : search,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Количество итераций: ${e.countIteration}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Макс. длинна О: ${e.maxLengthO}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'Макс. длинна О в конце: ${e.maxLengthResultO}'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Макс. длинна О+С: ${e.lengthOC}'),
                                SizedBox(
                                  height: 10,
                                ),
                                (res.length != 0 &&
                                        res[index].result.length != 0)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  ResultsPage(
                                                results: res[index].result,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Посмотреть результаты"),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ).toList(),
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
                        report = [results!.report];
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
                        report = [results!.report];
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
                        report = [results!.report];
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
                        report = [results!.report];
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
                      report = [];
                      results = SearchMethods().aStar(widget.state, 1);
                      res.add(results!);
                      _showDialog(results!);
                      report.add(results!.report);
                      results = SearchMethods().aStar(widget.state, 2);
                       res.add(results!);
                      _showDialog(results!);
                      report.add(results!.report);
                      results = SearchMethods().aStar(widget.state, 3);
                       res.add(results!);
                      _showDialog(results!);
                      report.add(results!.report);
                      setState(() {
                        //report.add(results!.report);
                        search = "A*";
                      });
                    },
                    child: Text("A*"),
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
