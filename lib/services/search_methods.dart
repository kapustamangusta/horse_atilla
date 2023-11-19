import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:attila_horse/models/report.dart';
import 'package:collection/collection.dart';
import '../models/my_state.dart';

class Result {
  final List<MyState> result;
  final Report report;

  Result({required this.result, required this.report});
}

class SearchMethods {
  // напиши метод сортировки пузырьком
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
    List<MyState> forwardO = [start],
        backwardO = [end],
        forwardC = [],
        backwardC = [];
    Position startPosition = start.horsePostion;
    Report report = Report(0, 0, 0, 0);

    while (forwardO.length != 0 && backwardO.length != 0) {
      MyState forwardX = forwardO.removeAt(0);
      MyState backwardX = backwardO.removeAt(0);
      // прямой поиск

      // report.countIteration % 100 == 0
      //     ? print('b ${report.countIteration}')
      //     : null;

      // находим состояние их обратного поиска, являющиемся продолжением состояния прямого поиска
      final suitableStateForForwardX = backwardC
          .where((element) => (element.kingIsDefeat == forwardX.kingIsDefeat &&
              element.horsePostion == forwardX.horsePostion &&
              !_duplicate(element.usedCells, forwardX.usedCells)))
          .firstOrNull;

      if (suitableStateForForwardX != null) {
        report.maxLengthResultO = forwardO.length + backwardO.length;
        Result result = Result(
            result: _convertToList(forwardX, suitableStateForForwardX),
            report: report);
        return result;
      }

      forwardC.add(forwardX);

      for (int i = 0; i < 8; i++) {
        if (_moveIsValid(forwardX, _moveX[i], _moveY[i])) {
          var usedCells = [...forwardX.usedCells];
          usedCells.add(forwardX.horsePostion);
          if (forwardX.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          MyState newState = MyState(
            prev: forwardX,
            burningCells: forwardX.burningCells,
            usedCells: usedCells,
            row: forwardX.row,
            column: forwardX.column,
            kingPosition: forwardX.kingPosition,
            kingIsDefeat: forwardX.kingIsDefeat,
            horsePostion: Position(forwardX.horsePostion.x + _moveX[i],
                forwardX.horsePostion.y + _moveY[i]),
          );
          if (!forwardO.contains(newState) && !forwardC.contains(newState)) {
            forwardO.add(newState);
          }
        }
      }

      //обратный поиск
      // report.countIteration % 100 == 0
      //     ? print('b ${report.countIteration}')
      //     : null;
      // находим состояние их прямого поиска, являющиемся продолжением состояния обратного поиска
      final suitableStateForBackwardX = forwardC
          .where((element) => (element.kingIsDefeat == backwardX.kingIsDefeat &&
              element.horsePostion == backwardX.horsePostion &&
              !_duplicate(element.usedCells, forwardX.usedCells)))
          .firstOrNull;

      if (suitableStateForBackwardX != null) {
        report.maxLengthResultO = forwardO.length + backwardO.length;
        Result result = Result(
            result: _convertToList(suitableStateForBackwardX, backwardX),
            report: report);
        return result;
      }
      backwardC.add(backwardX);

      for (int i = 0; i < 8; i++) {
        if (_moveIsValid(backwardX, _moveX[i], _moveY[i])) {
          var usedCells = [...backwardX.usedCells];
          usedCells.add(backwardX.horsePostion);
          if (backwardX.kingIsDefeat) {
            usedCells.remove(startPosition);
          }
          MyState newState = MyState(
            prev: backwardX,
            burningCells: backwardX.burningCells,
            usedCells: usedCells,
            row: backwardX.row,
            column: forwardX.column,
            kingPosition: backwardX.kingPosition,
            kingIsDefeat: backwardX.kingIsDefeat,
            horsePostion: Position(backwardX.horsePostion.x + _moveX[i],
                backwardX.horsePostion.y + _moveY[i]),
          );
          if (!backwardO.contains(newState) && !backwardC.contains(newState)) {
            backwardO.add(newState);
          }
        }
      }
      report.setData(forwardO + backwardO, forwardC + backwardC);
    }
    return Result(result: [], report: report);
  }

  int _h(MyState state, Position startPosition, int evristic) {
    int dx = state.kingIsDefeat
        ? (state.horsePostion.x - startPosition.x).abs()
        : (state.horsePostion.x - state.kingPosition.x).abs();
    int dy = state.kingIsDefeat
        ? (state.horsePostion.y - startPosition.y).abs()
        : (state.horsePostion.y - state.kingPosition.y).abs();

    int dxStart = (startPosition.x - state.kingPosition.x).abs();
    int dyStart = (startPosition.y - state.kingPosition.y).abs();

    if (evristic == 1) {
      int horseToKing = dx >= dy ? dx : dy;
      int startToKing = dxStart >= dyStart ? dxStart : dyStart;
      startToKing = !state.kingIsDefeat ? startToKing : 0;
      return (horseToKing / 2).ceil() + (startToKing / 2).ceil();
    } else if (evristic == 2) {
      int sStart = !state.kingIsDefeat ? ((dxStart + dyStart) / 3).ceil() : 0;
      return ((dy + dx) / 3).ceil() + sStart;
    } else if (evristic == 3) {
      int sStart = !state.kingIsDefeat
          ? (sqrt(dxStart * dxStart + dyStart * dyStart)).ceil()
          : 0;

      return (sqrt(dx * dx + dy * dy)).ceil() + sStart;
    } else {
      List<List<int>> table =
          List.generate(state.row, (index) => List.filled(state.column, -1));
      List<int> dxHorse = [1, 2, 2, 1, -1, -2, -2, -1];
      List<int> dyHorse = [2, 1, -1, -2, -2, -1, 1, 2];

      Queue<Position> queue = Queue();
      queue.add(Position(0, 0));
      table[0][0] = 0;

      while (queue.isNotEmpty) {
        Position currentPosition = queue.removeFirst();
        int x = currentPosition.x;
        int y = currentPosition.y;

        for (int i = 0; i < 8; i++) {
          int nx = x + dxHorse[i];
          int ny = y + dyHorse[i];

          if (0 <= nx &&
              nx < state.column &&
              0 <= ny &&
              ny < state.row &&
              table[nx][ny] == -1) {
            table[nx][ny] = table[x][y] + 1;
            queue.add(Position(nx, ny));
          }
        }
      }
      print('\n${table.toString().replaceAll(RegExp(r'],'), '\n')}');
      int sStart = !state.kingIsDefeat ? table[dxStart][dyStart] : 0;
      // for(int i=0;i<table.length;i++){
      //   for(int j=0;j<table[i].length;j++){
      //     print(table[i].toString());
      //   }
      // }
      return table[dx][dy] + sStart;
    }
  }

  bool _containsInOAndC(
      MyState state, PriorityQueue<MyState> O, List<MyState> C) {
    return _containsInC(state, C) != null || _containsInO(state, O) != null;
  }

  MyState? _containsInO(MyState state, PriorityQueue<MyState> O) {
    var OList = O.toList();
    for (int i = 0; i < O.length; i++) {
      if (state.kingIsDefeat == OList[i].kingIsDefeat &&
          state.horsePostion == OList[i].horsePostion) {
        return OList[i];
      }
    }

    return null;
  }

  MyState? _containsInC(MyState state, List<MyState> C) {
    for (int i = 0; i < C.length; i++) {
      if (state.kingIsDefeat == C[i].kingIsDefeat &&
          state.horsePostion == C[i].horsePostion) {
        return C[i];
      }
    }

    return null;
  }

  Result aStar(MyState state, int evristic) {
    Report report = Report(0, 0, 0, 0);

    final O = PriorityQueue<MyState>((a, b) => a.cost.compareTo(b.cost));
    Position startPosition = state.horsePostion;

    state.cost = state.depth + _h(state, startPosition, evristic);
    O.add(state);
    List<MyState> C = [];

    while (O.length != 0) {
      MyState x = O.removeFirst();

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
            depth: x.depth + 1,
            horsePostion: Position(
                x.horsePostion.x + _moveX[i], x.horsePostion.y + _moveY[i]),
          );
          newState.cost =
              newState.depth + _h(newState, startPosition, evristic);
          if (!_containsInOAndC(newState, O, C)) {
            O.add(newState);
          } else {
            var st = _containsInO(newState, O);
            if (st != null) {
              if (st.cost > newState.cost) {
                O.remove(st);
                O.add(newState);
              }
            } else {
              var st1 = _containsInC(newState, C);
              if (st1 != null) {
                if (st1.cost > newState.cost) {
                  C.remove(st1);
                  O.add(newState);
                }
              }
            }
          }
        }

        
      }
      report.setData(O.toList(), C);
    }

    return Result(result: [], report: report);
  }
}
