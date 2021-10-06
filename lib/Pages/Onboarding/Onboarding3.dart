import 'package:Toki/Services/Theme.dart';
import 'package:Toki/Widgets/Settings/WorkTimePicker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

GetIt getIt = GetIt.instance;

class Onboarding3 extends StatefulWidget {
  @override
  _Onboarding3State createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: AnimatedCrossFade(
              duration: Duration(milliseconds: 400),
              sizeCurve: Curves.ease,
              crossFadeState: getIt<Data>().individualTimes ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(
                  """Wie viele Stunden arbeitest du am Tag?""",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "BandeinsSans"),
                ),
              ),
              secondChild: Container()),
        ),
        Listener(
          onPointerUp: (_) {
            setState(() {});
          },
          child: SingleChildScrollView(
            child: WorkTimePicker(
              color: Theme.of(context).brightness == Brightness.light ? editColor : neon,
              onboarding: true,
            ),
          ),
        ),
        /* Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            """Wie viele Stunden arbeitest du am Tag?""",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "BandeinsSans"),
          ),
        ), */
        /*SizedBox(
          height: 20,
        ),
        Text(
          tagesstunden.toString() + " Stunden",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: "BandeinsSans",
              color: Colors.white),
        ),*/
        /* SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(60.0, 0, 0, 0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: OnboardingSliderThumbRect(
                min: 0,
                max: 12,
                thumbHeight: 40.0,
                thumbWidth: 100.0,
                thumbRadius: 0,
                color: Colors.white,
                textcolor: editColor,
              ),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              inactiveTrackColor: Colors.white.withAlpha(50),
              activeTrackColor: Colors.white.withAlpha(200),
              //valueIndicatorShape: RectangularSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: settingsTitle.copyWith(color: editColor),
            ),
            child: Slider(
              value: tagesstunden,
              onChanged: (newTagesstunden) {
                setState(() {
                  tagesstunden = newTagesstunden;
                });
              },
              onChangeEnd: (newTagesstunden) {
                setState(() {
                  // getIt<Data>().updateTagesstunden(newTagesstunden);
                });
              },
              min: 0,
              max: 12,
              divisions: 24,
              //label: "$tagesstunden Stunden",
            ),
          ),
        ), */
      ],
    );
  }
}
