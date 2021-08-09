import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../values/regex.dart';

class CharacterMatrix extends StatelessWidget {
  CharacterMatrix({
    Key? key,
    required this.columns,
    required this.rows,
    required this.characterValidator,
    required this.textControllers,
    // required this.textFieldKeys,
    required this.formKey,
    required this.cellHighlightMatrix,
  })  : assert(textControllers.length == rows),
        assert(textControllers.every((row) => row.length == columns)),
        assert(cellHighlightMatrix.length == rows),
        assert(cellHighlightMatrix.every((row) => row.length == columns)),
        // assert(textFieldKeys.length == rows),
        // assert(textFieldKeys.every((row) => row.length == columns)),
        super(key: key);

  final int columns;
  final int rows;
  final String? Function(String? input) characterValidator;
  final GlobalKey<FormState> formKey;

  final List<List<bool>> cellHighlightMatrix;

  final List<List<TextEditingController>> textControllers;
  // final List<List<GlobalKey<FormState>>> textFieldKeys;

  late final List<Widget> gridBlocks;

  Future<bool> initMatrix() async {
    /// Assign correct length
    gridBlocks = List.generate(
      rows * columns,
      (i) => Container(
        width: 40.0,
        height: 40.0,
        color: Colors.grey,
        child: Text('?'),
      ),
      growable: false,
    );

    /// Populate the grid blocks with widgets
    int gridIndex = 0;
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        gridBlocks[gridIndex++] = Container(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: TextFormField(
              // key: textFieldKeys[row][column],
              controller: textControllers[row][column],
              validator: characterValidator,
              inputFormatters: [
                FilteringTextInputFormatter.allow(Regexs.alphaNumeric),
              ],
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 1,
              minLines: null, //Required for the expands property to work
              maxLines: null, //Required for the expands property to work
              expands: true,
              style: TextStyle(
                fontSize: 24.0,
                color: cellHighlightMatrix[row][column]
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: cellHighlightMatrix[row][column]
                    ? Colors.blue
                    : Colors.grey.shade100,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                counterText: '',
                errorStyle: TextStyle(height: 0),
                hintText: '',
                hintStyle: TextStyle(
                  color: Colors.grey.shade200,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
        );
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initMatrix(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Container(
          constraints: BoxConstraints(
            maxWidth: 400.0,
          ),
          // clipBehavior: Clip.hardEdge,
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.grey.shade600),
          //   borderRadius: BorderRadius.circular(4.0),
          // ),
          child: Form(
            key: formKey,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: rows,
              children: gridBlocks,
            ),
          ),
        );
      },
    );
  }
}
