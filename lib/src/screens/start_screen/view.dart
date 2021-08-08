import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../values/labels.dart';
import 'logic.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StartScreenController>(
      create: (_) => StartScreenController(),
      child: Consumer<StartScreenController>(
        builder: (__, controller, ___) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        Labels.welcomeMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Spacer(),
                      Text(Labels.enterMatrixSizeMessage),
                      Form(
                        key: controller.formKey,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Rows
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SizedBox(
                                width: 80.0,
                                child: TextFormField(
                                  controller:
                                      controller.rowsCountTextController,
                                  validator: controller.validateInput,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: Labels.rowsTextInputHint,
                                    errorStyle: TextStyle(height: 0),
                                  ),
                                ),
                              ),
                            ),

                            /// Separator
                            Text(Labels.rowsAndColumnsSeparator),

                            /// Columns
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: SizedBox(
                                width: 80.0,
                                child: TextFormField(
                                  controller:
                                      controller.columnsCountTextController,
                                  validator: controller.validateInput,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: Labels.columnsTextInputHint,
                                    errorStyle: TextStyle(height: 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        controller.errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextButton(
                          onPressed: () => controller.onSubmit(context),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                              vertical: 24.0,
                            )),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
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
                              Labels.goButton,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
