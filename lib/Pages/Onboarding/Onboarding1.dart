import 'package:Timo/Services/Data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Services/Theme.dart';

class Onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 30, 30, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Willkommen",
                        style:onboardingTitle.copyWith(color: getIt<Data>().primaryColor)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                        """timo hilft dir dabei, den Überblick über deine Überstunden zu behalten.""",
                        textAlign: TextAlign.start,
                        style: onboardingBody.copyWith(color: getIt<Data>().primaryColor)),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -30,
                left: 10,
                child: SvgPicture.asset("assets/timo/timo_happy_1.svg")),
          ],
          overflow: Overflow.visible,
        ),
      ],
    );
  }
}
