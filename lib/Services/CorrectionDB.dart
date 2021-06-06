import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../hiveClasses/Correction.dart';
import 'Data.dart';
import 'Theme.dart';
import 'package:get_it/get_it.dart';

class CorrectionDB {
  Future<void> initCorrectionDB() async {
    SharedPreferences prefs =
        await getIt<Data>().getSharedPreferencesInstance();
    if (prefs.containsKey("korrekturUM") || prefs.containsKey("korrekturAB")) {
      await migrateData(prefs);
    }
    resetBox();
  }

  Future<void> resetBox() async {
    Box correctionBox =  Hive.box<Correction>("corrections");
    await correctionBox.clear();
    await correctionBox.add(Correction(
        ab: 6 * Duration.millisecondsPerHour,
        um: 30 * Duration.millisecondsPerMinute));
    await correctionBox.add(Correction(
        ab: 9 * Duration.millisecondsPerHour,
        um: 45 * Duration.millisecondsPerMinute));
    logger.w(correctionBox.length);
  }

  Future<void> migrateData(SharedPreferences prefs) async {
    Box correctionBox = Hive.box<Correction>("corrections");
    prefs.remove("korrekturUM");
    prefs.remove("korrekturAB");
    correctionBox.add(Correction(
        ab: 6 * Duration.millisecondsPerHour,
        um: 30 * Duration.millisecondsPerMinute));
    correctionBox.add(Correction(
        ab: 9 * Duration.millisecondsPerHour,
        um: 45 * Duration.millisecondsPerMinute));
    print("CORRECTION DB MIGRATED");
    print(correctionBox.length);
  }
}
