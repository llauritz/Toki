import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  const DottedLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: SizedBox(
            width: 3,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: SizedBox(
            width: 3,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: SizedBox(
            width: 3,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: SizedBox(
            width: 3,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
      ],
    );
  }
}
