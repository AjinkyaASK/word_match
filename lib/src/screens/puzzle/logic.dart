import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:word_match/src/values/regex.dart';

class PuzzleScreenController extends ChangeNotifier {
  PuzzleScreenController({
    required this.rows,
    required this.columns,
  }) {
    matrixTextControllers = List.generate(
      rows,
      (i) => List.generate(
        columns,
        (i) => TextEditingController(),
        growable: false,
      ),
      growable: false,
    );
    matrixTextFieldKeys = List.generate(
      rows,
      (i) => List.generate(
        columns,
        (i) => GlobalKey(),
        growable: false,
      ),
      growable: false,
    );
  }

  final TextEditingController wordInputTextController = TextEditingController();

  final int rows;
  final int columns;

  late final List<List<TextEditingController>> matrixTextControllers;
  late final List<List<GlobalKey<FormState>>> matrixTextFieldKeys;

  void refresh() => notifyListeners();

  String? validateCharacterInput(String? input) {
    /// `maxLengthAllowed` is always 1 as we are validating a single character
    const int maxLengthAllowed = 1;

    if (input == null) return 'This is a required field';
    if (input.isEmpty) return 'This is a required field';
    if (input.length != maxLengthAllowed)
      return 'Only one character is allowed per block';
    if (!Regexs.alphaNumeric.hasMatch(input))
      return 'Only aphabets and numbers are allowed (No spaces or special characters)';
    return null;
  }

  String? validateWordInput(String? input) {
    /// `maxLengthAllowed` is the maximum possible length of word the matrix can contain
    final int maxLengthAllowed = <int>[rows, columns].reduce(max);

    if (input == null) return 'This is a required field';
    if (input.isEmpty) return 'This is a required field';
    if (input.length > maxLengthAllowed)
      return 'As per the matrix size, word cannot be more than $maxLengthAllowed characters in length';
    if (!Regexs.alphaNumeric.hasMatch(input))
      return 'Only aphabets and numbers are allowed (No spaces or special characters)';
    return null;
  }
}
