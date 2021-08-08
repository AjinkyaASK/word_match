import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../values/labels.dart';
import 'logic.dart';
import 'widgets/matrix.dart';
import 'widgets/occurance_count_card.dart';

class PuzzleScreen extends StatelessWidget {
  PuzzleScreen({
    Key? key,
    required this.rows,
    required this.columns,
  }) : super(key: key);

  final int rows;
  final int columns;
  final GlobalKey<FormState> wordInputKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PuzzleScreenController>(
      create: (_) => PuzzleScreenController(
        rows: rows,
        columns: columns,
      ),
      child: Consumer<PuzzleScreenController>(
        builder: (_, controller, ___) {
          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Occurances Count + Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OccuranceCountCard(
                          occurances: 0 // Pass actual occurances count here
                          ),
                      IconButton(
                        onPressed: () {
                          // Call method to reset the puzzle
                          controller.refresh();
                        },
                        icon: Icon(Icons.restart_alt_outlined),
                      ),
                    ],
                  ),

                  // Character Matrix
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CharacterMatrix(
                      rows: rows,
                      columns: columns,
                      // textFieldKeys: controller.matrixTextFieldKeys,
                      formKey: controller.matrixFormKey,
                      textControllers: controller.matrixTextControllers,
                      characterValidator: controller.validateCharacterInput,
                      cellHighlightMatrix: controller.cellHighlightMatrix,
                    ),
                  ),

                  // Word input + submit action
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Form(
                      key: controller.wordInputFormKey,
                      child: TextFormField(
                        controller: controller.wordInputTextController,
                        validator: controller.validateWordInput,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: controller.wordMaxLength,
                        decoration: InputDecoration(
                            counterText: '',
                            hintText:
                                '${Labels.wordInputTextFieldHint} (${Labels.maxLength} ${controller.wordMaxLength})'),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: controller.onWordSubmit,
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.symmetric(
                        vertical: 24.0,
                      )),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0))),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue.shade700;
                        return Colors.blue;
                      }),
                    ),
                    child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          Labels.findMatchButton,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


/// 0. Create list of word occurances
/// 1. Check for next occurance of first char from word
/// 2. If found, add it to the temp list of cells
/// 3. Iterate on directions list
/// 4. Check for occurance of next char from word in direction
/// 5. If found, add it to the temp list of cells and go to Step 4
/// 6. If not, clear temp list of cells, break and go to step 3
/// 7. If length of temp list of cells is equal to length of word, add these cells to word occurances list and go to step 3
/// 8. If its not end of word, then go to step 1
/// 9. If yes, return list of word occurances