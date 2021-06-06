import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../hiveClasses/Correction.dart';
import 'Data.dart';
import 'Theme.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

class CorrectionDB {
  Future<void> initCorrectionDB() async {
    SharedPreferences prefs =
        await getIt<Data>().getSharedPreferencesInstance();
    if (prefs.containsKey("korrekturUM") || prefs.containsKey("korrekturAB")) {
      await migrateData(prefs);
    }
  }

  Future<void> resetBox() async {
    Box<Correction> correctionBox = Hive.box("corrections");
    correctionBox.clear();
    correctionBox.putAt(
        1,
        Correction(
            ab: 6 * Duration.millisecondsPerHour,
            um: 30 * Duration.millisecondsPerMinute));
    correctionBox.putAt(
        2,
        Correction(
            ab: 9 * Duration.millisecondsPerHour,
            um: 45 * Duration.millisecondsPerMinute));
  }

  Future<void> migrateData(SharedPreferences prefs) async {
    Box<Correction> correctionBox = Hive.box("corrections");
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
