import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../values/labels.dart';
import '../../values/regex.dart';
import '../puzzle/view.dart';

class StartScreenController extends ChangeNotifier {
  refresh() => notifyListeners();

  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController rowsCountTextController = TextEditingController();
  final TextEditingController columnsCountTextController =
      TextEditingController();

  String errorMessage = '';

  String? validateInput(String? input) {
    if (input == null) {
      errorMessage = Labels.requiredFieldErrorMessage;
      refresh();
      return '';
    }
    if (input.isEmpty) {
      errorMessage = Labels.requiredFieldErrorMessage;
      refresh();
      return '';
    }
    if (!Regexs.numeric.hasMatch(input)) {
      errorMessage = Labels.onlyNumberAllowedErrorMessage;
      refresh();
      return '';
    }
    try {
      final number = int.parse(input);
      if (number < 1) {
        errorMessage = '${Labels.minimumSupportedLengthErrorMessage} 1';
        refresh();
        return '';
      }
      if (number > 20) {
        errorMessage = '${Labels.maximumSupportedLengthErrorMessage} 20';
        refresh();
        return '';
      }
    } catch (e) {
      print('Enable to process $input, error thrown while parsing: $e');
      errorMessage = Labels.invalidInputErrorMessage;
      refresh();
      return '';
    }
    refresh();
    return null;
  }

  void onSubmit(BuildContext context) {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      errorMessage = '';
      refresh();

      final int rows = int.parse(rowsCountTextController.text);
      final int columns = int.parse(columnsCountTextController.text);

      rowsCountTextController.clear();
      columnsCountTextController.clear();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PuzzleScreen(
            rows: rows,
            columns: columns,
          ),
        ),
      );
    }
  }
}
