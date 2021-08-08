import 'package:flutter/material.dart';

class CharacterMatrix extends StatelessWidget {
  CharacterMatrix({
    Key? key,
    required this.columns,
    required this.rows,
    required this.characterValidator,
    required this.textControllers,
    required this.textFieldKeys,
  })  : assert(textControllers.length == rows),
        assert(textControllers.every((row) => row.length == columns)),
        assert(textFieldKeys.length == rows),
        assert(textFieldKeys.every((row) => row.length == columns)),
        super(key: key);

  final int columns;
  final int rows;
  final String? Function(String? input) characterValidator;

  final List<List<TextEditingController>> textControllers;
  final List<List<GlobalKey<FormState>>> textFieldKeys;

  late final List<Widget?> gridBlocks;

  Future<void> initMatrix() async {
    /// Assign correct length
    gridBlocks = List.generate(
      rows * columns,
      (i) => null,
      growable: false,
    );

    /// Populate the grid blocks with widgets
    int gridIndex = 0;
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        gridBlocks[gridIndex++] = TextFormField(
          key: textFieldKeys[row][column],
          controller: textControllers[row][column],
          validator: characterValidator,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
