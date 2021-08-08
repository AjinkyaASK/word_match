import 'package:flutter/material.dart';
import 'package:word_match/src/values/labels.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    Key? key,
    required this.score,
  }) : super(key: key);

  final int score;

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
            score.toString(),
          ),
        ],
      ),
    );
  }
}
