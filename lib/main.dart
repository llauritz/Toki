import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/hiveClasses/Correction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'Pages/home.dart';
import 'Services/Data.dart';
import 'Services/HiveDB.dart';
import 'Services/Theme.dart';
import 'hiveClasses/Zeitnahme.dart';
import 'Pages/Onboarding/Onboarding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

GetIt getIt = GetIt.instance;

void main() async {
  Logger.level = Level.debug;
  logger.i("Logger is working!");

  await Hive.initFlutter();
  Hive.registerAdapter(ZeitnahmeAdapter());
  Hive.registerAdapter(CorrectionAdapter());
  await Hive.openBox<Zeitnahme>("zeitenBox");
  await Hive.openBox<Correction>("corrections");

  getIt.registerSingleton<Data>(Data());
  getIt.registerSingleton<HiveDB>(HiveDB());
  getIt.registerSingleton<CorrectionDB>(CorrectionDB());

  //await getIt<CorrectionDB>().initCorrectionDB();
  await getIt<Data>().initData();
  await getIt<HiveDB>().initHiveDB();
  //await initializeDateFormatting("de_DE", null);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  TextTheme textTheme = TextTheme(

      //Large Numbers (Hours, Minutes)
      headline1: TextStyle(
        fontSize: 80.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "Roboto-Mono",
      ),

      //Smaller Numbers (Seconds), Mantra Text
      headline2: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
      headline5: TextStyle(fontSize: 12.0, height: 1.1, color: Colors.black.withAlpha(150)));

  runApp(GetMaterialApp(
    routes: {
      "/": (context) => const HomePage(),
      "/home": (context) => const HomePage(),
      "/onboarding": (context) => const Onboarding(),
    },
    initialRoute: getIt<Data>().finishedOnboarding ? "/" : "/onboarding",
    title: "Timo ",
    themeMode: ThemeMode.system,
    darkTheme: ThemeData(
      primarySwatch: Colors.teal,
      backgroundColor: Colors.blueGrey[900],
      //scaffoldBackgroundColor: Colors.black,
      primaryColor: neon,
      buttonColor: neon,
      accentColor: neonAccent,
      brightness: Brightness.dark,
      textTheme: textTheme,
      timePickerTheme: TimePickerThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          hourMinuteTextColor: neonAccent,
          hourMinuteColor: neonTranslucent,
          dialHandColor: neon),
      fontFamily: "BandeinsSans",
    ),
    theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.white,
        //textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: neon)))),
        primaryColor: neon,
        brightness: Brightness.light,
        buttonColor: neon,
        accentColor: neonAccent,
        shadowColor: Colors.black38,
        timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            hourMinuteTextColor: neonAccent,
            hourMinuteColor: neonTranslucent,
            dialHandColor: neon),
        fontFamily: "BandeinsSans",
        textTheme: textTheme),
    localizationsDelegates: [GlobalMaterialLocalizations.delegate],
    supportedLocales: [const Locale("de")],
  ));
}
