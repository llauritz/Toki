import 'package:Timo/Services/Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../Services/HiveDB.dart';
import '../../../Services/Theme.dart';
import '../../../Widgets/TimerTextWidget.dart';
import '../../../hiveClasses/Zeitnahme.dart';
import 'TimesList.dart';

final getIt = GetIt.instance;

class DefaultCardOpen extends StatefulWidget {
  const DefaultCardOpen({
    required this.i,
    required this.index,
    required this.zeitnahme,
    required this.callback,
    Key? key,
  }) : super(key: key);

  // index in Liste der Zeitnahmen // zeitenBox.length-1 ist gannz oben
  final int i;

  // Tatsächlicher Punkt in der ListView // 0 = ganz oben
  final int index;
  final Zeitnahme zeitnahme;
  final Function callback;

  @override
  _DefaultCardOpenState createState() => _DefaultCardOpenState();
}

class _DefaultCardOpenState extends State<DefaultCardOpen> {
  Color _colorAccent = Colors.black;
  Color _colorTranslucent = Colors.black;
  DateFormat uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");
  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");

  final GlobalKey _toolTipKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Zeitnahme _zeitnahme = widget.zeitnahme;
    final DateTime _day = _zeitnahme.day;

    return StreamBuilder<int>(
        stream: getIt<HiveDB>().listChangesStream.stream,
        builder: (context, snapshot) {
          print("build");

          final int ueberMilliseconds = widget.zeitnahme.getUeberstunden();
          if (!ueberMilliseconds.isNegative) {
            _colorAccent = Theme.of(context).accentColor;
            _colorTranslucent = Theme.of(context).primaryColor.withOpacity(0.2);
          } else {
            _colorAccent = Theme.of(context).colorScheme.onSurface;
            _colorTranslucent = grayTranslucent;
          }

          final int elapsedMilliseconds = _zeitnahme.getElapsedTime();
          final int elapsedHours = Duration(milliseconds: elapsedMilliseconds).inHours;
          final int elapsedMinutes = Duration(milliseconds: elapsedMilliseconds).inMinutes;

          final int pauseMilliseconds = _zeitnahme.getPause() + _zeitnahme.getKorrektur();
          final int pauseHours = Duration(milliseconds: pauseMilliseconds).inHours;
          final int pauseMinutes = Duration(milliseconds: pauseMilliseconds).inMinutes;

          final int ueberHours = Duration(milliseconds: ueberMilliseconds.abs()).inHours;
          final int ueberMinutes = Duration(milliseconds: ueberMilliseconds.abs()).inMinutes;

          print("ueberHoras $ueberHours");
          print("ueberMinutes $ueberMinutes");

          TextStyle numbers = openCardsNumbers.copyWith(color: _colorAccent);

          return Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Container(),
                      ),
                      Flexible(
                          flex: 7,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 65.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                                  child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: const Alignment(0, 0.8),
                                          colors: <Color>[
                                            Theme.of(context).cardColor.withAlpha(0),
                                            Theme.of(context).cardColor,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.dstATop,
                                      child: TimesList(zeitnahme: _zeitnahme, uhrzeit: uhrzeit, widget: widget)),
                                ),
                              ),
                              SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FlatButton(
                                            onPressed: () {
                                              if (widget.i == Hive.box<Zeitnahme>("zeitenBox").length - 1) getIt<Data>().timerText.stop();
                                              if (widget.zeitnahme.tag == "Stundenabbau") {
                                                getIt<HiveDB>().updateTag("Urlaub", widget.i);
                                              }
                                              getIt<HiveDB>().changeState("free", widget.i);
                                              widget.callback();
                                            },
                                            splashColor: free.withAlpha(150),
                                            highlightColor: free.withAlpha(80),
                                            shape: const StadiumBorder(),
                                            color: freeTranslucent,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.beach_access,
                                                    color: freeAccent,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "Urlaubstag",
                                                    style: openButtonText.copyWith(color: freeAccent),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        const SizedBox(width: 12),
                                        FlatButton(
                                            onPressed: () {
                                              if (widget.i == Hive.box<Zeitnahme>("zeitenBox").length - 1) getIt<Data>().timerText.stop();
                                              if (widget.zeitnahme.tag == "Stundenabbau") {
                                                getIt<HiveDB>().updateTag("Krankheitstag", widget.i);
                                              }
                                              getIt<HiveDB>().changeState("sickDay", widget.i);
                                              widget.callback();
                                            },
                                            splashColor: editColor.withAlpha(150),
                                            highlightColor: editColor.withAlpha(80),
                                            shape: const StadiumBorder(),
                                            color: Colors.red.withOpacity(0.2),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.local_hospital_rounded,
                                                    color: Colors.redAccent,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "Krankheitstag",
                                                    style: openButtonText.copyWith(color: Colors.redAccent),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        const SizedBox(width: 12),
                                        FlatButton(
                                            onPressed: () {
                                              if (widget.i == Hive.box<Zeitnahme>("zeitenBox").length - 1) getIt<Data>().timerText.stop();
                                              if (widget.zeitnahme.tag == "Stundenabbau") {
                                                getIt<HiveDB>().updateTag("Bearbeitet", widget.i);
                                              }
                                              getIt<HiveDB>().changeState("edited", widget.i);
                                              widget.callback();
                                            },
                                            splashColor: editColor.withAlpha(150),
                                            highlightColor: editColor.withAlpha(80),
                                            shape: const StadiumBorder(),
                                            color: editColorTranslucent,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: editColor,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "Zeit nachtragen",
                                                    style: openButtonText.copyWith(color: editColor),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 20),
                              decoration: BoxDecoration(
                                color: _colorTranslucent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          tooltip: "Speichern und schliessen",
                                          splashColor: _colorAccent.withAlpha(80),
                                          highlightColor: _colorAccent.withAlpha(50),
                                          padding: const EdgeInsets.all(0),
                                          visualDensity: const VisualDensity(),
                                          icon: Icon(Icons.done_rounded, color: _colorAccent, size: 30),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ],
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Text(
                                        tag.format(_day) + ', ' + datum.format(_day),
                                        style: openCardDate.copyWith(color: _colorAccent),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  elapsedHours.toString(),
                                                  style: numbers,
                                                ),
                                                Text(
                                                  ":",
                                                  style: numbers,
                                                ),
                                                DoubleDigit(i: elapsedMinutes % 60, style: numbers)
                                              ],
                                            ),
                                            Text(
                                              "Arbeitszeit",
                                              style: openCardsLabel.copyWith(color: _colorAccent),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                            child: Column(
                                              children: [
                                                //TODO: Nur anzeigen, wenn nicht erstes Element + isRunning true

                                                Row(
                                                  children: [
                                                    if (ueberMilliseconds.isNegative) Text("-", style: numbers),
                                                    Text(
                                                      ueberHours.toString(),
                                                      style: numbers,
                                                    ),
                                                    Text(
                                                      ":",
                                                      style: numbers,
                                                    ),
                                                    DoubleDigit(i: ueberMinutes % 60, style: numbers)
                                                  ],
                                                ),
                                                Text(
                                                  "Überstunden",
                                                  style: openCardsLabel.copyWith(color: _colorAccent),
                                                ),
                                              ],
                                            )),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (_zeitnahme.getKorrektur() > 0) {
                                                  final dynamic tooltip = _toolTipKey.currentState;
                                                  tooltip.ensureTooltipVisible();
                                                }
                                              },
                                              onLongPress: () {
                                                if (_zeitnahme.getKorrektur() > 0) {
                                                  final dynamic tooltip = _toolTipKey.currentState;
                                                  tooltip.ensureTooltipVisible();
                                                }
                                              },
                                              child: AbsorbPointer(
                                                absorbing: true,
                                                child: Tooltip(
                                                  textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                                  margin: EdgeInsets.only(left: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(1000),
                                                      color: Theme.of(context).cardColor,
                                                      boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3))]),
                                                  key: _toolTipKey,
                                                  verticalOffset: 40,
                                                  message: "Pause korrigiert",
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        pauseHours.toString(),
                                                        style: numbers.copyWith(color: _zeitnahme.getKorrektur() > 0 ? editColor : _colorAccent),
                                                      ),
                                                      Text(
                                                        ":",
                                                        style: numbers.copyWith(color: _zeitnahme.getKorrektur() > 0 ? editColor : _colorAccent),
                                                      ),
                                                      DoubleDigit(
                                                          i: pauseMinutes % 60,
                                                          style: numbers.copyWith(color: _zeitnahme.getKorrektur() > 0 ? editColor : _colorAccent))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Pause",
                                              style: openCardsLabel.copyWith(color: _zeitnahme.getKorrektur() > 0 ? editColor : _colorAccent),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      const Flexible(flex: 7, child: SizedBox())
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
