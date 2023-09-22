import 'package:attila_horse/cells/cells.dart';
import 'package:attila_horse/models/my_state.dart';
import 'package:flutter/material.dart';

class Field extends StatefulWidget {
  final MyState state;
  const Field({super.key, required this.state});

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  List<Widget> cells = [];
  
  void LoadCells(){
    cells=[];
    cells.add(WhiteCell());

    //для отрисовки верхней панели
    for (int i = 0; i < widget.state.column; i++) {
      cells.add(WithNumberCell(number: i));
    }

    for (int i = 0; i < widget.state.row; i++) {
      cells.add(WithNumberCell(number: i));

      for (int j = 0; j < widget.state.column; j++) {
        if (Position(j, i) == widget.state.horsePostion) {
          cells.add(HorseCell());
        } else if (Position(j, i) == widget.state.kingPosition) {
          cells.add(KingCell());
        } else if (widget.state.usedCells
            .any((element) => element == Position(j, i))) {
          cells.add(UsedCell());
        } else if ((j + i) % 2 == 0) {
          if (widget.state.burningCells
              .any((element) => element == Position(j, i))) {
            cells.add(BurningWhiteCell());
          } else {
            cells.add(WhiteCell());
          }
        } else {
          if (widget.state.burningCells
              .any((element) => element == Position(j, i))) {
            cells.add(BurningBlackCell());
          } else {
            cells.add(BlackCell());
          }
        }
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    LoadCells();
    return Container(
      height: 50 * (widget.state.row + 1) + 2,
      width: 50 * (widget.state.column + 1) + 2,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Wrap(
        direction: Axis.horizontal,
        children: [...cells],
      ),
    );
  }
}
