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

  ///возвращает список состояний, переменная end используется только при двунапрваленном поиске
  List<MyState> _convertToList(MyState state, [MyState? end = null]) {
    MyState? currentState = state;
    List<MyState> results = [];
    while (currentState != null) {
      results.insert(0, currentState);
      currentState = currentState.prev;
    }

    if (end != null) {
      currentState = end.prev;
      while (currentState != null) {
        var uc = results.last.usedCells;
        uc.add(results.last.horsePostion);
        currentState.usedCells = [...uc];
        results.add(currentState);
        currentState = currentState.prev;
      }
    }

    return results;
  }

  ///проверяет на наличие хотябы 1 элемента, находящегося и в list1, и в list 2
  bool _duplicate(List<Position> list1, List<Position> list2) {
    for (int i = 0; i < list1.length; i++) {
      if (list2.contains(list1[i])) {
        return true;
      }
    }
    return false;
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

  ///поиск в глубину
  Result searchInDepth(MyState state) {
    Report report = Report(0, 0, 0, 0);
    List<MyState> O = [state], C = [];

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
    return Result(result: [], report: report);
  }

  ///поиск в ширину
  Result searchInWidth(MyState state) {
    Report report = Report(0, 0, 0, 0);
    List<MyState> O = [state], C = [];

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
    return Result(result: [], report: report);
  }

  ///поиск в глубину с интерактивным углублением
  Result depthFirstSearchWithIterativeDeepening(MyState state) {
    Report report = Report(0, 0, 0, 0);

    Position startPosition = state.horsePostion;

    int depthLimit = 0;
    //пока глубина меньше или равна максимальному количеству ходов, которые конь может совершить
    //(конь не может сделать шагов больше чем доступных клеток на поле)
    while (depthLimit <= state.row * state.column - state.burningCells.length) {
      List<MyState> O = [state], C = [];

      while (O.length != 0) {
        MyState x = O.removeLast();
        if (x.depth > depthLimit)
          continue; // Пропуск, если глубина узла превышает текущий предел

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
              depth: x.depth + 1,
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
      depthLimit++;
    }
    return Result(result: [], report: report);
  }

  ///двунаправленный поиск
  Result bidirectionalSearch(MyState start, MyState end) {
    List<MyState> forward_O = [start],
        backward_O = [end],
        forward_C = [],
        backward_C = [];
    Position startPosition = start.horsePostion;
    Report report = Report(0, 0, 0, 0);

    while (forward_O.length != 0 && backward_O.length != 0) {
      MyState forward_x = forward_O.removeAt(0);
      MyState backward_x = backward_O.removeAt(0);
      // прямой поиск
      

      // находим состояние их обратного поиска, являющиемся продолжением состояния прямого поиска
      final suitableStateForForwardX = backward_C.where((element) =>
          (element.kingIsDefeat == forward_x.kingIsDefeat &&
              element.horsePostion == forward_x.horsePostion &&
              !_duplicate(element.usedCells, forward_x.usedCells))).firstOrNull;

      if (suitableStateForForwardX != null) {
        report.maxLengthResultO = forward_O.length + backward_O.length;
        Result result = Result(
            result: _convertToList(forward_x, suitableStateForForwardX), report: report);
        return result;
      }

      forward_C.add(forward_x);

      for (int i = 0; i < 8; i++) {
        if (_moveIsValid(forward_x, _moveX[i], _moveY[i])) {
          var usedCells = [...forward_x.usedCells];
          usedCells.add(forward_x.horsePostion);
          if (forward_x.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          MyState newState = MyState(
            prev: forward_x,
            burningCells: forward_x.burningCells,
            usedCells: usedCells,
            row: forward_x.row,
            column: forward_x.column,
            kingPosition: forward_x.kingPosition,
            kingIsDefeat: forward_x.kingIsDefeat,
            horsePostion: Position(forward_x.horsePostion.x + _moveX[i],
                forward_x.horsePostion.y + _moveY[i]),
          );
          if (!forward_O.contains(newState) && !forward_C.contains(newState)) {
            forward_O.add(newState);
          }
        }
      }

      //обратный поиск
      // находим состояние их прямого поиска, являющиемся продолжением состояния обратного поиска
      final suitableStateForBackwardX = forward_C.where((element) =>
          (element.kingIsDefeat == backward_x.kingIsDefeat &&
              element.horsePostion == backward_x.horsePostion &&
              !_duplicate(element.usedCells, forward_x.usedCells))).firstOrNull;

      if (suitableStateForBackwardX != null) {
        report.maxLengthResultO = forward_O.length + backward_O.length;
        Result result = Result(
            result: _convertToList(suitableStateForBackwardX, backward_x), report: report);
        return result;
      }
      backward_C.add(backward_x);

      for (int i = 0; i < 8; i++) {
        if (_moveIsValid(backward_x, _moveX[i], _moveY[i])) {
          var usedCells = [...backward_x.usedCells];
          usedCells.add(backward_x.horsePostion);
          if (backward_x.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          MyState newState = MyState(
            prev: backward_x,
            burningCells: backward_x.burningCells,
            usedCells: usedCells,
            row: backward_x.row,
            column: forward_x.column,
            kingPosition: backward_x.kingPosition,
            kingIsDefeat: backward_x.kingIsDefeat,
            horsePostion: Position(backward_x.horsePostion.x + _moveX[i],
                backward_x.horsePostion.y + _moveY[i]),
          );
          if (!backward_O.contains(newState) &&
              !backward_C.contains(newState)) {
            backward_O.add(newState);
          }
        }
      }
      report.setData(forward_O + backward_O, forward_C + backward_C);
    }
    return Result(result: [], report: report);
  }
}
