import 'package:flutter/material.dart';

import '../../../values/labels.dart';

class OccuranceCountCard extends StatelessWidget {
  const OccuranceCountCard({
    Key? key,
    required this.occurances,
  }) : super(key: key);

  final int occurances;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              Labels.wordOccurances,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            occurances.toString(),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
