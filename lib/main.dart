import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import 'Pages/Onboarding/onboarding.dart';
import 'Pages/home.dart';
import 'Services/Data.dart';
import 'Services/HiveDB.dart';
import 'Services/Theme.dart';
import 'hiveClasses/Zeitnahme.dart';

GetIt getIt = GetIt.instance;

void main() async {
  Logger.level = Level.debug;
  logger.i("Logger is working!");

  await Hive.initFlutter();
  getIt.registerSingleton<Data>(Data());
  getIt.registerSingleton<HiveDB>(HiveDB());
  Hive.registerAdapter(ZeitnahmeAdapter());

  await getIt<Data>().initData();
  await getIt<HiveDB>().initHiveDB();
  await initializeDateFormatting("de_DE", null);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MaterialApp(
    routes: {
      "/": (context) => const HomePage(),
      "/home": (context) => const HomePage(),
      "/onboarding": (context) => const Onboarding(),
    },
    initialRoute: getIt<Data>().finishedOnboarding ? "/" : "/onboarding",
    title: "Timo",
    theme: ThemeData(
        backgroundColor: Colors.indigoAccent[700],
        fontFamily: "BandeinsSans",
        textTheme: TextTheme(

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
            button: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold),

            // Wochentag in ZeitCard
            headline4: TextStyle(
                fontSize: 16.0,
                height: 1.05,
                color: Colors.black.withAlpha(150)),

            // Datum in ZeitCard
            headline5: TextStyle(
                fontSize: 12.0,
                height: 1.1,
                color: Colors.black.withAlpha(150)))),
  ));
}
