
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
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: 65,
              height: 65,
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
                    style: TextStyle(color: _colorAccent, fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: TextStyle(color: _colorAccent, fontSize: 12.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            AnimatedContainer(
              width: 260,
              duration: Duration(milliseconds: 1000),
              height: 65,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: _color),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _zeitnahme.tag.toString(),overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18, color: _color),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: FlatButton(
                            onPressed: () {
                              if(widget.zeitnahme.startTimes.length>0){
                                getIt<HiveDB>().changeState("default", widget.i);
                              }else{
                                getIt<HiveDB>().changeState("empty", widget.i);
                              }
                            },
                            child: Icon(
                              Icons.replay_rounded,
                              color: _colorAccent,
                              size: 28,
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
                    Expanded(child: Text("")),
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