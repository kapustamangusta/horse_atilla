import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int x, y;

  Position(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}

class MyState extends Equatable {
  Position kingPosition;
  Position horsePostion;
  int row, column;
  List<Position> burningCells;
  List<Position> usedCells;
  bool kingIsDefeat;
  MyState? prev;

  MyState({
    required this.burningCells,
    required this.usedCells,
    required this.row,
    required this.column,
    required this.kingPosition,
    required this.horsePostion,
    this.kingIsDefeat = false,
    this.prev = null,
  }) {
    if (!kingIsDefeat) kingIsDefeat = (horsePostion == kingPosition);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        kingPosition,
        horsePostion,
        row,
        column,
        burningCells,
        usedCells,
        kingIsDefeat,
        prev,
      ];
}
