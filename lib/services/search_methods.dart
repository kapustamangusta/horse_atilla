import 'package:attila_horse/models/report.dart';

import '../models/my_state.dart';

class Result {
  final List<MyState> result;
  final Report report;

  Result({required this.result, required this.report});
}

class SearchMethods {
  List<int> _moveX = [2, -1, -2, -2, 1, 2, 1, -1];
  List<int> _moveY = [1, 2, 1, -1, -2, -1, 2, -2];

  List<MyState> _convertToList(MyState state) {
    MyState? currentState = state;
    List<MyState> results = [];
    while (currentState != null) {
      results.insert(0, currentState);
      currentState = currentState.prev;
    }
    return results;
  }

  bool _moveIsValid(MyState state, int dx, int dy) {
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

  Result searchInDepth(MyState state) {
    Report report = Report(0, 0, 0, 0);
    List<MyState> O = [state], C = [];
    List<MyState> results = [];
    Position startPosition = state.horsePostion;

    while (O.length != 0) {
      MyState x = O.removeLast();

      if (x.kingIsDefeat && x.horsePostion == startPosition) {
        report.maxLengthResultO = O.length;
        Result result = Result(result: _convertToList(x), report: report);
        return result;
      }

      C.add(x);
      for (int i = 0; i < 8; i++) {
        if (_moveIsValid(x, _moveX[i], _moveY[i])) {
          var usedCells = [...x.usedCells];
          usedCells.add(x.horsePostion);
          if (x.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          MyState newState = MyState(
            prev: x,
            burningCells: x.burningCells,
            usedCells: usedCells,
            row: x.row,
            column: x.column,
            kingPosition: x.kingPosition,
            kingIsDefeat: x.kingIsDefeat,
            horsePostion: Position(
                x.horsePostion.x + _moveX[i], x.horsePostion.y + _moveY[i]),
          );
          if (!O.contains(newState) && !C.contains(newState)) {
            O.add(newState);
          }
        }
      }

      report.setData(O, C);
    }
    return Result(result: results, report: report);
  }

  Result searchInWidth(MyState state) {
    Report report = Report(0, 0, 0, 0);
    List<MyState> O = [state], C = [];
    List<MyState> results = [];
    Position startPosition = state.horsePostion;

    while (O.length != 0) {
      MyState x = O.removeAt(0);

      if (x.kingIsDefeat && x.horsePostion == startPosition) {
        report.maxLengthResultO = O.length;
        Result result = Result(result: _convertToList(x), report: report);
        return result;
      }

      C.add(x);
      for (int i = 0; i < 8; i++) {
        if (_moveIsValid(x, _moveX[i], _moveY[i])) {
          var usedCells = [...x.usedCells];
          usedCells.add(x.horsePostion);
          if (x.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          MyState newState = MyState(
            prev: x,
            burningCells: x.burningCells,
            usedCells: usedCells,
            row: x.row,
            column: x.column,
            kingPosition: x.kingPosition,
            kingIsDefeat: x.kingIsDefeat,
            horsePostion: Position(
                x.horsePostion.x + _moveX[i], x.horsePostion.y + _moveY[i]),
          );
          if (!O.contains(newState) && !C.contains(newState)) {
            O.add(newState);
          }
        }
      }

      report.setData(O, C);
    }
    return Result(result: results, report: report);
  }
}
