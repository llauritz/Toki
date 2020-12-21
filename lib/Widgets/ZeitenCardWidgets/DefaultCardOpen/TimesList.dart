import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:work_in_progress/hiveClasses/Zeitnahme.dart';

import '../../../Services/Data.dart';
import 'Ausstempeln.dart';
import 'DefaultCardOpen.dart';
import 'Einstempeln.dart';

final getIt = GetIt.instance;

class TimesList extends StatelessWidget {
  const TimesList({
    Key key,
    @required Zeitnahme zeitnahme,
    @required this.uhrzeit,
    @required this.widget,
  })  : _zeitnahme = zeitnahme,
        super(key: key);

  final Zeitnahme _zeitnahme;
  final DateFormat uhrzeit;
  final DefaultCardOpen widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _zeitnahme.startTimes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              index == 0
                  ? SizedBox(
                      height: 30,
                    )
                  : Container(),

              Einstempeln(
                  uhrzeit: uhrzeit,
                  zeitnahme: _zeitnahme,
                  uhrzeitenIndex: index,
                  zeitnahmeIndex: widget.i,
                  closedCardIndex: widget.index),

              // Latest Widget of the Day, Timer is Running, Last Widget in Timeline
              widget.index == 0 &&
                      getIt<Data>().isRunning &&
                      index == _zeitnahme.startTimes.length - 1
                  ? SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blueGrey[50]),
                      ))
                  : Ausstempeln(
                      uhrzeit: uhrzeit,
                      zeitnahme: _zeitnahme,
                      uhrzeitenIndex: index,
                      zeitnahmeIndex: widget.i,
                      closedCardIndex: widget.index),

              // There is another Time coming after this -> break between them
              _zeitnahme.startTimes.length - 1 > index
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Container(
                              width: 50,
                              height: 3,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          Text(
                            Duration(
                                        milliseconds:
                                            _zeitnahme.startTimes[index + 1] -
                                                _zeitnahme.endTimes[index])
                                    .inMinutes
                                    .toString() +
                                " Minuten Pause",
                            style: TextStyle(color: Colors.orangeAccent),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Container(
                              width: 50,
                              height: 3,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(height: 50)
            ],
          );
        });
  }
}
