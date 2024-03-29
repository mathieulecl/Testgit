import 'package:flutter/material.dart';
import '../../../models/HighLowChange.dart';
import '../../../constants.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Highs and Lows",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Flexible( // This will allow it to take only the available space
          child: HighLowChange(),
        ),
      ],
    );
  }
}

