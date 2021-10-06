import 'package:Toki/Services/CorrectionDB.dart';
import 'package:Toki/Services/ThemeBuilder.dart';
import 'package:Toki/hiveClasses/Correction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  runApp(ThemeBuilder(builder: (context, thememode) {
    return MaterialApp(
      title: "Toki",
      themeMode: thememode,
      darkTheme: darkTheme,
      theme: lightTheme,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale("de")],
      //
      home: getIt<Data>().finishedOnboarding ? const HomePage() : const ThemedOnboarding(),
    );
  }));
}
