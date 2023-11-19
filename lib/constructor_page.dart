import 'package:attila_horse/field.dart';
import 'package:attila_horse/home_page.dart';
import 'package:attila_horse/models/my_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ConstructorPage extends StatefulWidget {
  MyState state;
  ConstructorPage({super.key, required this.state});

  @override
  State<ConstructorPage> createState() => _ConstructorPageState();
}

class _ConstructorPageState extends State<ConstructorPage> {
  TextEditingController rowController = TextEditingController();
  TextEditingController columnController = TextEditingController();
  List<ValueItem> allPosition = [];
  @override
  void initState() {
    rowController.text = widget.state.row.toString();
    widget.state.usedCells=[];
    columnController.text = widget.state.column.toString();
    super.initState();
  }

  void loadPositions() {
    allPosition = [];
    for (int i = 0; i < widget.state.row; i++) {
      for (int j = 0; j < widget.state.column; j++) {
        allPosition.add(ValueItem(label: "($i, $j)", value: "$i $j"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPositions();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Контсруктор"),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      child: TextField(
                        controller: rowController,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 0) {
                              widget.state.row = int.parse(value);
                            }
                          });
                        },
                        decoration: new InputDecoration(labelText: "Строки"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.cancel),
                    Container(
                      width: 50,
                      child: TextField(
                        controller: columnController,
                        textAlign: TextAlign.center,
                        decoration: new InputDecoration(labelText: "Колонки"),
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 0) {
                              widget.state.column = int.parse(value);
                            }
                          });
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Field(state: widget.state),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Координаты коня'),
                        Container(
                          width: 200,
                          child: MultiSelectDropDown(
                            
                            onOptionSelected: (List<ValueItem> selectedOptions) {
                              var param = selectedOptions[0].value!.split(' ');
                              setState(() {
                                widget.state.horsePostion =
                                    Position(int.parse(param[0]), int.parse(param[1]));
                              });
                            },
                            options: <ValueItem>[...allPosition],
                            disabledOptions: [
                              ValueItem(
                                  label:
                                      "(${widget.state.kingPosition.x}, ${widget.state.kingPosition.y})",
                                  value:
                                      "${widget.state.kingPosition.x} ${widget.state.kingPosition.y}"),
                              ...widget.state.burningCells.map((e) {
                                return ValueItem(
                                    label: "(${e.x}, ${e.y})", value: "${e.x} ${e.y}");
                              }).toList()
                            ],
                            selectedOptions: [
                              ValueItem(
                                  label:
                                      "(${widget.state.horsePostion.x}, ${widget.state.horsePostion.y})",
                                  value:
                                      "${widget.state.horsePostion.x} ${widget.state.horsePostion.y}"),
                            ],
                            selectionType: SelectionType.single,
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 16),
                            selectedOptionIcon: const Icon(Icons.check_circle),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text('Координаты короля'),
                        Container(
                          width: 200,
                          child: MultiSelectDropDown(
                            onOptionSelected: (List<ValueItem> selectedOptions) {
                              var param = selectedOptions[0].value!.split(' ');
                              setState(() {
                                widget.state.kingPosition =
                                    Position(int.parse(param[0]), int.parse(param[1]));
                              });
                            },
                            options: <ValueItem>[...allPosition],
                            disabledOptions: [
                              ValueItem(
                                  label:
                                      "(${widget.state.horsePostion.x}, ${widget.state.horsePostion.y})",
                                  value:
                                      "${widget.state.horsePostion.x} ${widget.state.horsePostion.y}"),
                              ...widget.state.burningCells.map((e) {
                                return ValueItem(
                                    label: "(${e.x}, ${e.y})", value: "${e.x} ${e.y}");
                              }).toList()
                            ],
                            selectedOptions: [
                              ValueItem(
                                  label:
                                      "(${widget.state.kingPosition.x}, ${widget.state.kingPosition.y})",
                                  value:
                                      "${widget.state.kingPosition.x} ${widget.state.kingPosition.y}"),
                            ],
                            selectionType: SelectionType.single,
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 16),
                            selectedOptionIcon: const Icon(Icons.check_circle),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16,),
                    Column(
                      children: [
                        Text('Координаты горящих клеток'),
                        Container(
                          width: 300,
                          child: MultiSelectDropDown(
                            padding: EdgeInsets.all(16),
                            onOptionSelected: (List<ValueItem> selectedOptions) {
                              List<Position> pos = [];
                              selectedOptions.forEach((element) {
                                var param = element.value!.split(' ');
                                pos.add(
                                    Position(int.parse(param[0]), int.parse(param[1])));
                              });
                              setState(() {
                                widget.state.burningCells = pos;
                              });
                            },
                            options: <ValueItem>[...allPosition],
                            disabledOptions: [
                              ValueItem(
                                  label:
                                      "(${widget.state.kingPosition.x}, ${widget.state.kingPosition.y})",
                                  value:
                                      "${widget.state.kingPosition.x} ${widget.state.kingPosition.y}"),
                              ValueItem(
                                  label:
                                      "(${widget.state.horsePostion.x}, ${widget.state.horsePostion.y})",
                                  value:
                                      "${widget.state.horsePostion.x} ${widget.state.horsePostion.y}"),
                            ],
                            selectedOptions: [
                              ...widget.state.burningCells.map((e) {
                                return ValueItem(
                                    label: "(${e.x}, ${e.y})", value: "${e.x} ${e.y}");
                              }).toList()
                            ],
                            selectionType: SelectionType.multi,
                            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 16),
                            selectedOptionIcon: const Icon(Icons.check_circle),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                            HomePage(state: widget.state),
                      ),
                    );
                  },
                  child: Text("Сохранить"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
