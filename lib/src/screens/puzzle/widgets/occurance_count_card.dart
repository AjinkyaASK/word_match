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
            child: Text(Labels.wordOccurances),
          ),
          Text(
            occurances.toString(),
          ),
        ],
      ),
    );
  }
}
