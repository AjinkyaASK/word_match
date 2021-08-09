import 'package:word_match/src/screens/puzzle/logic.dart';

import 'cell.dart';

class WordOccurance {
  WordOccurance(
    this.cells,
    this.direction,
  );
  final List<Cell> cells;
  final SearchDirection direction;
}
