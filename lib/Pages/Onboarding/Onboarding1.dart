import 'package:flutter/material.dart';

import '../../Services/Theme.dart';

class Onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*SvgPicture.asset("assets/Toki/Toki_happy_1_white.svg"),*/
                  SizedBox(height: 70),
                  Text("Willkommen", style: onboardingTitle.copyWith(color: Colors.white)),
                  SizedBox(
                    height: 15,
                  ),
                  Text("""Toki hilft dir dabei, den Überblick über deine Überstunden zu behalten.""",
                      textAlign: TextAlign.center, style: onboardingBody.copyWith(color: Colors.white)),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            /*Positioned(
                top: -45,
                left: 20,
                child: SvgPicture.asset("assets/Toki/Toki_happy_1.svg")),*/
          ],
        ),
      ],
    );
  }
}
