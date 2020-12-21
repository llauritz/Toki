import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

GetIt getIt = GetIt.instance;

class Onboarding3 extends StatefulWidget {
  @override
  _Onboarding3State createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  double tagesstunden = 8.0;

  @override
  void initState() {
    tagesstunden = getIt<Data>().tagesstunden;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
          child: Text(
            """Wie viele Stunden arbeitest du am Tag?""",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: "BandeinsSans"),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Slider.adaptive(
          value: tagesstunden,
          onChanged: (newTagesstunden) {
            setState(() {
              tagesstunden = newTagesstunden;
            });
          },
          onChangeEnd: (newTagesstunden) {
            setState(() {
              getIt<Data>().updateTagesstunden(newTagesstunden);
            });
          },
          min: 0,
          max: 12,
          divisions: 24,
          //label: "$tagesstunden Stunden",
          activeColor: Colors.white,
          inactiveColor: Colors.white.withAlpha(50),
        ),
        Text(
          tagesstunden.toString() + " Stunden",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: "BandeinsSans",
              color: Colors.white),
        )
      ],
    );
  }
}
