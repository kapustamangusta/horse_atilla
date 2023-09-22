import 'my_state.dart';

class Report {
  int countIteration = 0;
  int maxLengthO = 0;
  int maxLengthResultO = 0;
  int lengthOC = 0;

  Report(
    this.countIteration,
    this.lengthOC,
    this.maxLengthO,
    this.maxLengthResultO,
  );

  void setData(List<MyState> O, List<MyState> C) {
    countIteration++;
    if (maxLengthO < O.length) {
      maxLengthO = O.length;
    }
    if (lengthOC < O.length + C.length) {
      lengthOC = O.length + C.length;
    }
  }
}
