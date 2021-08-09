import 'package:flutter/material.dart';

import '../../../values/labels.dart';

class OccuranceCountCard extends StatelessWidget {
  const OccuranceCountCard({
    Key? key,
    required this.title,
    required this.occurances,
  }) : super(key: key);

  final String title;
  final int occurances;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 80.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            offset: Offset(0, 2),
            color: Colors.indigo.shade900.withOpacity(0.15),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              occurances.toString(),
              style: TextStyle(
                color: Colors.blue,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
