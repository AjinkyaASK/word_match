import 'package:flutter/material.dart';

import 'screens/puzzle/view.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PuzzleScreen(
        rows: 4,
        columns: 5,
      ),
    );
  }
}
