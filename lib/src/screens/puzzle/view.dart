import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic.dart';
import 'widgets/score_card.dart';

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
            body: Column(
              children: [
                // Score Cards + actions
                Row(
                  children: [
                    ScoreCard(score: 0 // Pass actual score here
                        ),
                    IconButton(
                      onPressed: () {
                        // Call method to reset the puzzle
                      },
                      icon: Icon(Icons.restart_alt_outlined),
                    ),
                  ],
                ),

                // Character Matrix

                // Word input + submit action
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    key: wordInputKey,
                    controller: controller.wordInputTextController,
                    validator: controller.validateWordInput,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue.shade700;
                      return Colors.blue;
                    }),
                  ),
                  child: Text('Find Match!'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
