import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../values/labels.dart';
import '../../values/regex.dart';
import 'domain/entity/cell.dart';
import 'domain/entity/word_occurance.dart';

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

  /// [searchDirections] contains Search Directions considered for finding occurances
  final List<SearchDirection> searchDirections = List.unmodifiable([
    SearchDirection.LeftRight,
    SearchDirection.TopDown,
    SearchDirection.TopRightLeftBottom,
  ]);

  /// [rowOffsetFromSearchDirection] maps the row offset to be used with the search direction, useful when searching in a particular direction
  final Map<SearchDirection, int> rowOffsetFromSearchDirection = {
    SearchDirection.LeftRight: 0,
    SearchDirection.TopDown: 1,
    SearchDirection.TopRightLeftBottom: 1
  };

  /// [columnOffsetFromSearchDirection] maps the column offset to be used with the search direction, useful when searching in a particular direction
  final Map<SearchDirection, int> columnOffsetFromSearchDirection = {
    SearchDirection.LeftRight: 1,
    SearchDirection.TopDown: 0,
    SearchDirection.TopRightLeftBottom: 1
  };

  /// [wordInputTextController] to be used with the text field which accept user input for the word to be searched in the matrix
  final TextEditingController wordInputTextController = TextEditingController();

  /// [rows] indicates the number of rows matrix has
  final int rows;

  /// [columns] indicates the number of columns matrix has
  final int columns;

  /// [wordMaxLength] is the maximum possible length of word the matrix can contain
  /// This is late as it is initialized in the body of default constructor of this class
  late final int wordMaxLength;

  /// [matrixTextControllers] are used for the cells of the word matrix
  /// This is late as it is initialized in the body of default constructor of this class
  late final List<List<TextEditingController>> matrixTextControllers;

  /// [cellHighlightMatrix] contains a matrix of boolean values endicating status of cells highlighted
  /// here `true` means the cell is highlighted and `false` means not
  /// This is late as it is initialized in the body of default constructor of this class
  late List<List<bool>> cellHighlightMatrix;

  /// [matrixFormKey] is used for the form added as parent widget of all the cells for the input validation purpose
  final GlobalKey<FormState> matrixFormKey = GlobalKey();

  /// [wordInputFormKey] is used for the form widget of word input for validation purpose
  final GlobalKey<FormState> wordInputFormKey = GlobalKey();

  /// [occuranceCount] indicates the count of occurances of the word in the matrix
  int occuranceCount = 0;

  // late final List<List<GlobalKey<FormState>>> matrixTextFieldKeys;

  void refresh() => notifyListeners();

  /// [validateCharacterInput] to be used for the validation of single character input from the matrix cells
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

  /// [validateWordInput] to be used for the validation of word input
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

  /// The method [onWordSubmit] to be called when user submits the word to be searched in the matrix
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
          await _searchForWord(wordInputTextController.text);
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

  /// The method [_searchForWord] is a private one, used internally by [onWordSubmit] method
  /// This method takes a [String] and returns a list of [WordOccurance] for the provided string from the matrix
  Future<List<WordOccurance>> _searchForWord(String word) async {
    /// STEP 0: Start by creating a empty list of word occurances
    final List<WordOccurance> wordOccurances = [];

    /// STEP 1: Iterate over all cells
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        /// STEP 2: Create a empty list of cells for holding temporarily
        final List<Cell> tempCells = [];

        /// STEP 3: Check for next occurance of first char from word
        if (matrixTextControllers[row][column]
                .text
                .toLowerCase()
                .compareTo(word[0].toLowerCase()) ==
            0) {
          /// STEP 4: If found, add it to the temp list of cells
          tempCells.add(Cell(row, column));

          if (word.length > 1) {
            /// STEP 5: Iterate on directions list
            searchDirections.forEach((direction) {
              /// STEP 6: Clear the temporary cells list and add the cell with first character to it
              tempCells.clear();
              tempCells.add(Cell(row, column));

              /// STEP 7: Create new row and column indexes with offset added
              int rowWithOffset =
                  row + rowOffsetFromSearchDirection[direction]!;
              int columnWithOffset =
                  column + columnOffsetFromSearchDirection[direction]!;

              for (int charIndex = 1; charIndex < word.length; charIndex++) {
                /// STEP 8. Check for occurance of next char from word in direction selected in STEP 5
                if (rowWithOffset < rows &&
                    columnWithOffset < columns &&
                    matrixTextControllers[rowWithOffset][columnWithOffset]
                            .text
                            .toLowerCase()
                            .compareTo(word[charIndex].toLowerCase()) ==
                        0) {
                  /// STEP 9: If found, add it to the temp list of cells
                  tempCells.add(Cell(rowWithOffset, columnWithOffset));

                  /// STEP 10: Recalculate new row and column indexes by adding the offset, go to STEP 8
                  if (!rowOffsetFromSearchDirection.containsKey(direction) ||
                      !columnOffsetFromSearchDirection.containsKey(direction))
                    throw 'The selected search direction not found in the Direction-Offset relationship map';

                  rowWithOffset += rowOffsetFromSearchDirection[direction]!;
                  columnWithOffset +=
                      columnOffsetFromSearchDirection[direction]!;
                } else {
                  /// STEP 11: If not found, clear temp list of cells, break and go to STEP 5
                  tempCells.clear();
                  break;
                }
              }

              /// STEP 12: If length of temp list of cells is equal to the length of word, add these cells to word occurances list and go to STEP 5
              if (tempCells.length == word.length) {
                wordOccurances
                    .add(WordOccurance(List.from(tempCells, growable: false)));
              }
            });
          } else {
            wordOccurances
                .add(WordOccurance(List.from(tempCells, growable: false)));
          }
        }

        /// STEP 13: If its not end of columns, then go to STEP 1
      }

      /// STEP 14: If its not end of rows, then go to STEP 1
    }

    /// STEP 15: Once all cells have been visited, return the list of word occurances and stop
    return wordOccurances;
  }
}
