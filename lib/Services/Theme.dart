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
TextTheme textThemeLight = TextTheme(

    //Large Numbers (Hours, Minutes)
    headline1: TextStyle(fontSize: 70.0, height: 0.79, fontWeight: FontWeight.bold, color: Colors.white),

    //Smaller Numbers (Seconds), Mantra Text
    headline2: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: neon,
    ),

    //Widgets.Settings Cards Titles
    headline3: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.black.withOpacity(0.8),
    ),
    button: TextStyle(color: Colors.white, letterSpacing: 0.5, fontWeight: FontWeight.bold),

    // Wochentag in ZeitCard
    headline4: TextStyle(fontSize: 16.0, height: 1.05, color: grayAccent),

    // Datum in ZeitCard
    headline5: TextStyle(fontSize: 12.0, height: 1.1, color: Colors.black.withAlpha(150)),
    bodyText2: TextStyle(color: neon));

TextTheme textThemeDark = TextTheme(

    //Large Numbers (Hours, Minutes)
    headline1: TextStyle(fontSize: 70.0, height: 0.79, fontWeight: FontWeight.bold, color: Colors.white),

    //Smaller Numbers (Seconds), Mantra Text
    headline2: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: neonTranslucent,
    ),

    //Widgets.Settings Cards Titles
    headline3: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.black.withOpacity(0.8),
    ),
    button: TextStyle(color: Colors.white, letterSpacing: 0.5, fontWeight: FontWeight.bold),

    // Wochentag in ZeitCard
    headline4: TextStyle(fontSize: 16.0, height: 1.05, color: Colors.white),

    // Datum in ZeitCard
    headline5: TextStyle(fontSize: 12.0, height: 1.1, color: Colors.black.withAlpha(150)),
    bodyText2: TextStyle(color: neon));

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(onSurface: grayAccent, onSecondary: gray, primary: neon),
    primarySwatch: Colors.teal,
    backgroundColor: Colors.white,
    //textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: neon)))),
    primaryColor: neon,
    primaryColorLight: Color(0xffE4FFFB),
    buttonColor: grayTranslucent,
    accentColor: neonAccent,
    shadowColor: Colors.black38,
    timePickerTheme: TimePickerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        hourMinuteTextColor: neonAccent,
        hourMinuteColor: neonTranslucent,
        dialHandColor: neon),
    fontFamily: "BandeinsSans",
    textTheme: textThemeLight);
    
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(onSurface: Colors.blueGrey[100]!, primary: neon, onSecondary: Colors.blueGrey[100]!),
  primaryColorLight: Color(0xff25453D),
  primarySwatch: Colors.teal,
  cardColor: Color(0xff1C2124),
  backgroundColor: Color(0xff141718),
  scaffoldBackgroundColor: Color(0xff061212),
  primaryColor: neon,
  buttonColor: Colors.blueGrey[700],
  accentColor: neonAccent,
  shadowColor: Colors.black,
  textTheme: textThemeDark,
  timePickerTheme: TimePickerThemeData(
      backgroundColor: Color(0xff1C2124),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      hourMinuteTextColor: neonAccent,
      hourMinuteColor: neonTranslucent,
      //dialTextColor: Colors.white,
      dialHandColor: neon),
  fontFamily: "BandeinsSans",
);

const Color neon = Colors.tealAccent;
const Color neonAccent = Color(0xff00FFDC);
Color neonTranslucent = neon.withOpacity(0.2);

const Color gray = Color(0xFF90A4AE); //bluegrey300
const Color grayAccent = Color(0xFF607D8B); //bluegrey 500
Color grayTranslucent = gray.withOpacity(0.2); //bluegrey 50
const Color grayDark = Color(0xFF455A64); //bluegrey 700

const Color free = Color(0xffFFB77F);
const Color freeAccent = Color(0xffFFA55F);
Color freeTranslucent = free.withOpacity(0.18);

const Color editColor = Color(0xFF42A5F5); //blue 400
Color editColorTranslucent = editColor.withOpacity(0.2); //lightblue 50

//const Color sick = Colors.red;
const Color sickAccent = Colors.redAccent;
Color sickTranslucent = Colors.red.withOpacity(0.2);

const Color darkBackground = Color(0xFF110744);

const TextStyle timerTextNumbers = TextStyle(
  fontSize: 70,
  color: Colors.white,
  height: 0.79,
);

const TextStyle dayNightNumbers = TextStyle(fontFamily: "Roboto-Mono_bold", fontSize: 46, letterSpacing: -2, color: grayDark);

const TextStyle openCardsNumbers = TextStyle(color: gray, fontSize: 28);

const TextStyle openButtonText = TextStyle(fontSize: 12, fontFamily: "BandeinsSansRegular", color: Colors.white);

const TextStyle closedCardsNumbers = TextStyle(fontSize: 16.0, height: 1.05, color: Colors.white);

const TextStyle openCardsLabel = TextStyle(
  fontSize: 13,
  //fontFamily: "BandeinsSansRegular"
);

const TextStyle openCardDate = TextStyle(fontSize: 36);

const TextStyle overTimeNumbers = TextStyle(fontSize: 46, height: 1.0, fontFamily: "BandeinsSans");

// Overtime Offset Title
const TextStyle headline2 = TextStyle(fontSize: 18, color: grayDark);

const TextStyle headline3 = TextStyle(fontSize: 16, color: grayDark);

const TextStyle onboardingTitle =
    TextStyle(color: editColor, height: 1.0, fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: "BandeinsStrange");

const TextStyle onboardingBody = TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: editColor, height: 1.4);

const TextStyle settingsHeadline = TextStyle(fontSize: 30, color: neon);

const TextStyle settingsTitle = TextStyle(fontSize: 12, color: grayAccent, fontFamily: "BandeinsSans");

const TextStyle settingsBody = TextStyle(fontSize: 20, color: neon);
