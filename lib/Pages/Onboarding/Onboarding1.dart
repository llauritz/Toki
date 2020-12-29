import 'package:Timo/Services/Data.dart';
import 'package:Timo/hiveClasses/Zeitnahme.dart';
import 'package:flutter/material.dart';

import '../../Services/Theme.dart';

class Onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Willkommen",
                    style:onboardingTitle.copyWith(color: getIt<Data>().primaryColor)),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    """Work in Progress hilft dir dabei, den Überblick über deine Überstunden zu behalten.""",
                    textAlign: TextAlign.center,
                    style: onboardingBody.copyWith(color: getIt<Data>().primaryColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
