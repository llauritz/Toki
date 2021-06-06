import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt getIt = GetIt.instance;

var logger = Logger(
    //filter: MyFilter(),
    printer: PrefixPrinter(PrettyPrinter(
      methodCount: 2,
      colors: true,
      printEmojis: true,
      printTime: true,
    )));

// class ExampleLogOutput extends ConsoleOutput {
//   @override
//   void output(OutputEvent event) {
//     super.output(event); // bufferSize: log display number
//   }
// }

// class MyFilter extends LogFilter {
//   @override
//   bool shouldLog(LogEvent event) {
//     return true;
//   }
// }

const Color neon = Colors.tealAccent;
const Color neonAccent = Color(0xff00FFDC);
const Color neonTranslucent = Color(0xffE4FFFB);

const Color gray = Color(0xFF90A4AE); //bluegrey300
const Color grayAccent = Color(0xFF607D8B); //bluegrey 500
const Color grayTranslucent = Color(0xFFECEFF1); //bluegrey 50
const Color grayDark = Color(0xFF455A64); //bluegrey 700

const Color free = Color(0xffFFB77F);
const Color freeAccent = Color(0xffFFA55F);
const Color freeTranslucent = Color(0xffFFF6EF);

const Color editColor = Color(0xFF42A5F5); //blue 400
const Color editColorTranslucent = Color(0xFFE1F5FE); //lightblue 50

const Color darkBackground = Color(0xFF110744);

const TextStyle timerTextNumbers = TextStyle(
  fontSize: 70,
  color: Colors.white,
  height: 0.79,
);

const TextStyle dayNightNumbers = TextStyle(
    fontFamily: "Roboto-Mono_bold",
    fontSize: 46,
    letterSpacing: -2,
    color: grayDark);

const TextStyle openCardsNumbers = TextStyle(color: gray, fontSize: 28);

const TextStyle openButtonText = TextStyle(
    fontSize: 12, fontFamily: "BandeinsSansRegular", color: Colors.white);

const TextStyle closedCardsNumbers =
    TextStyle(fontSize: 16.0, height: 1.05, color: Colors.white);

const TextStyle openCardsLabel = TextStyle(
  fontSize: 13,
  //fontFamily: "BandeinsSansRegular"
);

const TextStyle openCardDate = TextStyle(fontSize: 36);

const TextStyle overTimeNumbers =
    TextStyle(fontSize: 46, height: 1.0, fontFamily: "BandeinsSans");

// Overtime Offset Title
const TextStyle headline2 = TextStyle(fontSize: 18, color: grayDark);

const TextStyle headline3 = TextStyle(fontSize: 16, color: grayDark);

const TextStyle onboardingTitle = TextStyle(
    color: editColor,
    height: 1.0,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    fontFamily: "BandeinsStrange");

const TextStyle onboardingBody = TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.bold, color: editColor, height: 1.4);

const TextStyle settingsHeadline = TextStyle(fontSize: 30, color: neon);

const TextStyle settingsTitle =
    TextStyle(fontSize: 12, color: grayAccent, fontFamily: "BandeinsSans");

const TextStyle settingsBody = TextStyle(fontSize: 20, color: neon);
