import 'package:flutter/material.dart';

const Color neon = Colors.tealAccent;
const Color neonAccent = Color(0xff00FFDC);
const Color neonTranslucent = Color(0xffE4FFFB);

final Color gray = Colors.blueGrey[300];
final Color grayAccent = Colors.blueGrey;
final Color grayTranslucent = Colors.blueGrey[50];
final Color grayDark = Colors.blueGrey[700];

const Color free = Color(0xffFFB77F);
const Color freeAccent = Color(0xffFFA55F);
const Color freeTranslucent = Color(0xffFFF6EF);

final Color editColor = Colors.blue[400];
final Color editColorTranslucent = Colors.lightBlue[50];

const TextStyle timerTextNumbers = TextStyle(
  fontSize: 80,
  color: Colors.white,
  height: 0.79,
);

final TextStyle dayNightNumbers = TextStyle(
    fontFamily: "Roboto-Mono_bold",
    fontSize: 46,
    letterSpacing: -2,
    color: grayDark);

final TextStyle openCardsNumbers = TextStyle(
    color: gray,
    fontSize: 28);

const TextStyle openButtonText = TextStyle(
    fontSize: 12,
  fontFamily: "BandeinsSansRegular"
);

const TextStyle closedCardsNumbers = TextStyle(
  fontSize: 16.0,
  height: 1.05,
color: Colors.white);

const TextStyle openCardsLabel = TextStyle(
  fontSize: 13,
    //fontFamily: "BandeinsSansRegular"
);

const TextStyle openCardDate = TextStyle(
  fontSize: 36
);

const TextStyle overTimeNumbers = TextStyle(
  fontSize: 46,
  height: 1.0,
  fontFamily: "BandeinsSans"
);

// Overtime Offset Title
final TextStyle headline2 = TextStyle(
  fontSize: 18,
  color: grayDark
);

final TextStyle headline3 = TextStyle(
    fontSize: 16,
    color: grayDark
);

final TextStyle onboardingTitle = TextStyle(
    color: editColor,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    fontFamily: "BandeinsStrange"
);

final TextStyle onboardingBody = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: editColor,
    height: 1.4
);