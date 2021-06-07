import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:Timo/hiveClasses/Correction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../Services/Data.dart';

class CorrectionTile extends StatefulWidget {
  const CorrectionTile(
      {Key? key,
      required this.correction,
      required this.listKey,
      required this.index})
      : super(key: key);
  final Correction correction;
  final GlobalKey<AnimatedListState> listKey;
  final int index;

  @override
  _CorrectionTileState createState() => _CorrectionTileState();
}

class _CorrectionTileState extends State<CorrectionTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 260,
            height: 65,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: gray),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ab",
                      style: TextStyle(fontSize: 12, color: gray),
                    ),
                    Row(
                      children: [
                        Text((widget.correction.ab /
                                Duration.millisecondsPerHour)
                            .toString()),
                        Text(
                          "Stunden",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mindestens",
                      style: TextStyle(fontSize: 12, color: gray),
                    ),
                    Row(
                      children: [
                        Text((widget.correction.um /
                                Duration.millisecondsPerMinute)
                            .toString()),
                        Text(
                          "Minuten",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                getIt<CorrectionDB>()
                    .deleteCorrection(widget.index, widget.listKey, context);
              },
              icon: Icon(Icons.close_rounded))
        ],
      ),
    );
  }
}
