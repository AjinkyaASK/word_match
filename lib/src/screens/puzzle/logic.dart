import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../../values/labels.dart';
import '../../values/regex.dart';

enum SearchDirection {
  TopDown,
  LeftRight,
  TopRightLeftBottom,
}

class PuzzleScreenController extends ChangeNotifier {
  PuzzleScreenController({
    required this.rows,
    required this.columns,
  }) {
    wordMaxLength = [rows, columns].reduce(max);
    matrixTextControllers = List.generate(
      rows,
      (i) => List.generate(
        columns,
        (i) => TextEditingController(),
        growable: false,
      ),
      growable: false,
    );
    cellHighlightMatrix = List.generate(
      rows,
      (i) => List.generate(
        columns,
        (i) => false,
        growable: false,
      ),
      growable: false,
    );
    // matrixTextFieldKeys = List.generate(
    //   rows,
    //   (i) => List.generate(
    //     columns,
    //     (i) => GlobalKey(),
    //     growable: false,
    //   ),
    //   growable: false,
    // );
  }

  final List<SearchDirection> searchDirections = List.unmodifiable([
    SearchDirection.TopDown,
    SearchDirection.LeftRight,
    SearchDirection.TopRightLeftBottom,
  ]);

  final Map<SearchDirection, int> rowOffsetFromSearchDirection = {
    SearchDirection.LeftRight: 0,
    SearchDirection.TopDown: 1,
    SearchDirection.TopRightLeftBottom: 1
  };

  final Map<SearchDirection, int> columnOffsetFromSearchDirection = {
    SearchDirection.LeftRight: 1,
    SearchDirection.TopDown: 0,
    SearchDirection.TopRightLeftBottom: 1
  };

  final TextEditingController wordInputTextController = TextEditingController();

  final int rows;
  final int columns;

  /// [wordMaxLength] is the maximum possible length of word the matrix can contain
  late final int wordMaxLength;

  late final List<List<TextEditingController>> matrixTextControllers;
  late List<List<bool>> cellHighlightMatrix;

  final GlobalKey<FormState> matrixFormKey = GlobalKey();
  final GlobalKey<FormState> wordInputFormKey = GlobalKey();

  int occuranceCount = 0;

  // late final List<List<GlobalKey<FormState>>> matrixTextFieldKeys;

  void refresh() => notifyListeners();

  String? validateCharacterInput(String? input) {
    /// `maxLengthAllowed` is always 1 as we are validating a single character
    const int maxLengthAllowed = 1;

    /// Here we are always returning empty string as we do not want to show any error text
    /// Instead just to trigger the behaviour
    if (input == null) return '';
    if (input.isEmpty) return '';
    if (input.length != maxLengthAllowed) return '';
    if (!Regexs.alphaNumeric.hasMatch(input)) return '';
    return null;
  }

  String? validateWordInput(String? input) {
    final int maxLengthAllowed = wordMaxLength;

    if (input == null) return Labels.requiredFieldErrorMessage;
    if (input.isEmpty) return Labels.requiredFieldErrorMessage;
    if (input.length > maxLengthAllowed)
      return '${Labels.wordLengthExceededErrorMessagePart1} $maxLengthAllowed ${Labels.wordLengthExceededErrorMessagePart2}';
    if (!Regexs.alphaNumeric.hasMatch(input))
      return Labels.onlyAlphanumericInputAllowedErrorMessage;
    return null;
  }

  Future<void> onWordSubmit() async {
    if (matrixFormKey.currentState != null &&
        matrixFormKey.currentState!.validate() &&
        wordInputFormKey.currentState != null &&
        wordInputFormKey.currentState!.validate()) {
      /// All validated, now begin the word search

      /// STEP 1: Clear any highlighted cells
      cellHighlightMatrix = List.generate(
        rows,
        (i) => List.generate(
          columns,
          (i) => false,
          growable: false,
        ),
        growable: false,
      );
      refresh();

      /// STEP 2: Get word occurances
      final List<WordOccurance> occurances =
          await searchForWord(wordInputTextController.text);
      this.occuranceCount = occurances.length;

      /// STEP 3: populate [cellHighlightMatrix] from word occurances
      occurances.forEach((occurance) {
        occurance.cells.forEach((cell) {
          cellHighlightMatrix[cell.row][cell.column] = true;
        });
      });

      /// STEP 3: Rebuild UI to show results
      refresh();
    }
  }

  Future<List<WordOccurance>> searchForWord(String word) async {
    /// STEP 0. Create list of word occurances
    final List<WordOccurance> wordOccurances = [];

    /// Iterating over all cells
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        List<Cell> tempCells = [];

        /// STEP 1. Check for next occurance of first char from word
        if (matrixTextControllers[row][column]
                .text
                .toLowerCase()
                .compareTo(word[0].toLowerCase()) ==
            0) {
          /// STEP 2. If found, add it to the temp list of cells
          tempCells.add(Cell(row, column));

          if (word.length > 1) {
            /// STEP 3. Iterate on directions list
            searchDirections.forEach((direction) {
              int rowWithOffset =
                  row + rowOffsetFromSearchDirection[direction]!;
              int columnWithOffset =
                  row + rowOffsetFromSearchDirection[direction]!;

              /// STEP 4. Check for occurance of next char from word in direction
              for (int charIndex = 1; charIndex < word.length; charIndex++) {
                //TODO: Made a dirty non-null promise in below line, make it better
                if (rowWithOffset < rows &&
                    columnWithOffset < columns &&
                    matrixTextControllers[rowWithOffset][columnWithOffset]
                            .text
                            .toLowerCase()
                            .compareTo(word[charIndex].toLowerCase()) ==
                        0) {
                  /// STEP 5. If found, add it to the temp list of cells and go to Step 4
                  tempCells.add(Cell(rowWithOffset, columnWithOffset));

                  rowWithOffset += rowOffsetFromSearchDirection[direction]!;
                  columnWithOffset +=
                      columnOffsetFromSearchDirection[direction]!;
                } else {
                  /// STEP 6. If not, clear temp list of cells, break and go to step 3
                  tempCells.clear();
                  break;
                }
              }

              /// STEP 7. If length of temp list of cells is equal to length of word, add these cells to word occurances list and go to step 3
              if (tempCells.length == word.length) {
                wordOccurances
                    .add(WordOccurance(List.from(tempCells, growable: false)));
              }
            });
          }
        }

        /// STEP 8. If its not end of columns, then go to step 1
      }

      /// STEP 9. If its not end of rows, then go to step 1
    }

    /// STEP 10. Return list of word occurances
    return wordOccurances;
  }
}

class Cell {
  Cell(this.row, this.column);

  final int row;
  final int column;
}

class WordOccurance {
  WordOccurance(this.cells);
  final List<Cell> cells;
}
