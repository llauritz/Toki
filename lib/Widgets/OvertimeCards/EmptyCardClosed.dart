import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../Services/Data.dart';
import '../../Services/HiveDB.dart';
import '../../Services/Theme.dart';
import '../../Widgets/TimerTextWidget.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class EmptyCardClosed extends StatefulWidget {
  const EmptyCardClosed({
    @required this.i,
    @required this.index,
    @required this.zeitnahme,
    Key key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _EmptyCardClosedState createState() => _EmptyCardClosedState();
}

class _EmptyCardClosedState extends State<EmptyCardClosed> {
  var fullDate = new DateFormat('dd.MM.yyyy');
  var Uhrzeit = DateFormat("H:mm");
  var wochentag = new DateFormat("EE", "de_DE");
  var datum = DateFormat("dd.MM", "de_DE");
  Color _color = Color(0xffFFB77F);
  Color _colorAccent = Color(0xffFFA55F);
  Color _colorTranslucent = Color(0xffFFF6EF);

  Color _editColor = editColor;
  Color _editColorTranslucent = editColorTranslucent;

  //Tagesstunden in Millisekunden
  int _tagesMillisekunden = (getIt<Data>().tagesstunden * 3600000).truncate();

  @override
  Widget build(BuildContext context) {
    if (widget.i >= 0) {
      final Zeitnahme _zeitnahme = widget.zeitnahme;
      final DateTime _day = _zeitnahme.day;
      final int index = widget.index;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: grayTranslucent.withAlpha(100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(_day).substring(0, 2),
                    style: TextStyle(color: gray, fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: TextStyle(color: gray, fontSize: 12.0),
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
                border: Border.all(width: 2.0, color: grayTranslucent),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 0, 6),
                      child: FlatButton(
                          minWidth: 0,
                          splashColor: _colorAccent.withAlpha(80),
                          highlightColor: _colorAccent.withAlpha(50),
                          color: _colorTranslucent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000)),
                          onPressed: () {
                            getIt<HiveDB>().changeState("free", widget.i);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.beach_access,
                                size: 22,
                                color: _colorAccent,
                              ),
                              Text(
                                "Urlaub",
                                style: TextStyle(
                                  fontFamily: "BandeinsSansRegular",
                                    color: _colorAccent, fontSize: 11.0),
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 0, 6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: editColorTranslucent
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 22,
                                color: editColor,
                              ),
                              Text(
                                "Bearbeiten",
                                style: TextStyle(
                                    fontFamily: "BandeinsSansRegular",
                                    color: editColor, fontSize: 11.0),
                              )
                            ],
                          ),
                        ),
                      ),

                      /*FlatButton(
                          clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.zero,
                          minWidth: 50,
                          height: 60,
                          splashColor: editColor.withAlpha(80),
                          highlightColor: editColor.withAlpha(50),
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000)),
                          onPressed: () async {
                            Navigator.push(context, HeroDialogRoute(
                                builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  Navigator.pop(context);
                                  print("EmptyCardClosed - popped");
                                  return true;
                                },
                                child: EditModal(
                                    index: index,
                                    colorAccent: _editColor,
                                    colorTranslucent: _editColorTranslucent),
                              );
                            }));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Hero(
                                tag: "container$index",
                                child: Container(
                                  width: 50,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: _editColorTranslucent,
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              Center(
                                child: Hero(
                                  tag: "icon$index",
                                  child: Icon(
                                    Icons.edit,
                                    size: 25,
                                    color: _editColor,
                                  ),
                                ),
                              ),
                            ],
                          )),*/
                    ),
                    Expanded(child: Text("")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "-",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: gray),
                        ),
                        Text(
                            Duration(milliseconds: _tagesMillisekunden.abs())
                                .inHours
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: gray)),
                        Text(":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: gray)),
                        DoubleDigit(
                            i: Duration(milliseconds: _tagesMillisekunden.abs())
                                    .inMinutes %
                                60,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: gray))
                      ],
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

class EditModal extends StatelessWidget {
  const EditModal({
    Key key,
    @required this.index,
    @required Color colorAccent,
    @required Color colorTranslucent,
  })  : _colorAccent = colorAccent,
        _colorTranslucent = colorTranslucent,
        super(key: key);

  final int index;
  final Color _colorAccent;
  final Color _colorTranslucent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Hero(
                tag: "container$index",
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: _colorTranslucent,
                      borderRadius: BorderRadius.circular(20)),
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                  tag: "icon$index",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 30,
                            color: _colorAccent,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Zeit nachtragen",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontSize: 22, color: Colors.blueAccent),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      EditFadeIn(
                        delay: 400,
                        fadeChild: FlutterSlider(
                          values: [
                            8.0 * 60,
                            (8.0 + getIt<Data>().tagesstunden) * 60
                          ],
                          minimumDistance: 30,
                          rangeSlider: true,
                          max: 24.0 * 60,
                          min: 0.0,
                          handlerAnimation: FlutterSliderHandlerAnimation(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.ease,
                              reverseCurve: Curves.easeIn,
                              scale: 2),
                          handler: FlutterSliderHandler(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: _colorAccent,
                                      borderRadius:
                                          BorderRadius.circular(1000)))),
                          rightHandler: FlutterSliderHandler(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: _colorAccent,
                                      borderRadius:
                                          BorderRadius.circular(1000)))),
                          tooltip: FlutterSliderTooltip(
                              positionOffset:
                                  FlutterSliderTooltipPositionOffset(top: -25),
                              alwaysShowTooltip: true,
                              custom: (value) {
                                print("EmptyCardClosed - value:" +
                                    value.toString());
                                int hours = (value / 60).truncate();
                                int minutes = (value % 60).truncate();

                                return Text("$hours:$minutes");
                              }),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

enum _AniProps { opacity, offset }

class EditFadeIn extends StatelessWidget {
  final int delay;
  final Widget fadeChild;

  EditFadeIn({this.delay, this.fadeChild});

  @override
  Widget build(BuildContext context) {
    var _tween = MultiTween<_AniProps>()
      ..add(_AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..add(_AniProps.offset, Tween(begin: 15.0, end: 0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: delay),
      tween: _tween,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
      builder: (context, child, value) {
        return Opacity(
            opacity: value.get(_AniProps.opacity),
            child: Transform.translate(
                offset: Offset(0, value.get(_AniProps.offset)),
                child: fadeChild));
      },
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => "Edit Time";

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
