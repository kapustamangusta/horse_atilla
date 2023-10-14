import 'package:attila_horse/field.dart';
import 'package:flutter/material.dart';

import 'models/my_state.dart';

class ResultsPage extends StatefulWidget {
  final List<MyState> results;
  const ResultsPage({super.key, required this.results});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Конь Aтиллы"),
      ),
      body: Center(
        child: Column(
        
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${i+1}/${widget.results.length}"),
            Field(state: widget.results[i]),
            SizedBox(
              height: 16,
            ),
            Text((widget.results[i].cost-widget.results[i].depth).toString()),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (i > 0) {
                      setState(() {
                        i--;
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  
                ),
                IconButton(
                  onPressed: () {
                    if (i < widget.results.length - 1) {
                      setState(() {
                        i++;
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
