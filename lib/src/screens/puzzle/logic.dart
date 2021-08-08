import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../../values/labels.dart';
import '../../values/regex.dart';

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

  final TextEditingController wordInputTextController = TextEditingController();

  final int rows;
  final int columns;

  /// [wordMaxLength] is the maximum possible length of word the matrix can contain
  late final int wordMaxLength;

  late final List<List<TextEditingController>> matrixTextControllers;

  final GlobalKey<FormState> matrixFormKey = GlobalKey();
  final GlobalKey<FormState> wordInputFormKey = GlobalKey();

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
      print('All Validated');
    }
  }
}
