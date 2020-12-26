
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/HiveDB.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class FreeCardClosed extends StatefulWidget {
  const FreeCardClosed({
    @required this.i,
    @required this.index,
    @required this.zeitnahme,
    Key key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _FreeCardClosedState createState() => _FreeCardClosedState();
}

class _FreeCardClosedState extends State<FreeCardClosed> {
  var fullDate = new DateFormat('dd.MM.yyyy');
  var Uhrzeit = DateFormat("H:mm");
  var wochentag = new DateFormat("EE", "de_DE");
  var datum = DateFormat("dd.MM", "de_DE");
  Color _color = Color(0xffFFB77F);
  Color _colorAccent = Color(0xffFFA55F);
  Color _colorTranslucent = Color(0xffFFB77F).withAlpha(40);

  @override
  Widget build(BuildContext context) {

    //getIt<HiveDB>().updateTag("Urlaub", widget.i);

    if (widget.i >= 0) {
      final Zeitnahme _zeitnahme = widget.zeitnahme;
      final DateTime _day = _zeitnahme.day;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: _colorTranslucent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(_day).substring(0, 2),
                    style: TextStyle(color: _colorAccent, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: TextStyle(color: _colorAccent, fontSize: 11.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            AnimatedContainer(
              width: 240,
              duration: Duration(milliseconds: 1000),
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: _color),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              child: Text(
                                _zeitnahme.tag.toString(),overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: _color),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: FlatButton(
                              onPressed: () {
                                if(widget.zeitnahme.startTimes.length>0){
                                  getIt<HiveDB>().changeState("default", widget.i);
                                }else{
                                  if(widget.zeitnahme.tag == "Urlaub"){
                                    getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                                  }
                                  getIt<HiveDB>().changeState("empty", widget.i);
                                }
                              },
                              child: Icon(
                                Icons.replay_rounded,
                                color: _colorAccent,
                                size: 24,
                              ),
                              splashColor: _colorAccent.withAlpha(80),
                              highlightColor: _colorAccent.withAlpha(50),
                              color: _colorTranslucent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000)),
                              padding: EdgeInsets.all(5),
                              minWidth: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30.0,
                      width: 65.0,
                      child: Text("0:00",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.white)),
                      decoration: BoxDecoration(
                        color: _color,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      print("DefaultCard - wtf");
      return Container(
        child: Text("wtf"),
      );
    }
  }
}