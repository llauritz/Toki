import 'dart:async';

import 'package:Timo/Widgets/Settings/BreakCorrection.dart';
import 'package:Timo/Widgets/Settings/CorrectionTile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../hiveClasses/Correction.dart';
import 'Data.dart';
import 'Theme.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';

class CorrectionDB {
  Future<void> initCorrectionDB() async {
    SharedPreferences prefs = await getIt<Data>().getSharedPreferencesInstance();
    if (prefs.containsKey("korrekturUM") || prefs.containsKey("korrekturAB")) {
      await migrateData(prefs);
    }
  }

  Future<void> resetBox() async {
    Box correctionBox = Hive.box<Correction>("corrections");
    await correctionBox.clear();
    await correctionBox.add(Correction(ab: 6 * Duration.millisecondsPerHour, um: 30 * Duration.millisecondsPerMinute));
    await correctionBox.add(Correction(ab: 9 * Duration.millisecondsPerHour, um: 45 * Duration.millisecondsPerMinute));
    logger.w(correctionBox.length);
  }

  Future<void> migrateData(SharedPreferences prefs) async {
    Box correctionBox = Hive.box<Correction>("corrections");
    resetBox();
    prefs.remove("korrekturUM");
    prefs.remove("korrekturAB");
    logger.w("CORRECTION DB MIGRATED");
    print(correctionBox.length);
  }

  Future<void> deleteCorrection(int index) async {
    Box correctionBox = Hive.box<Correction>("corrections");
    correctionBox.deleteAt(index);
  }

  Future<void> changeAB(int index, int newMilli, Correction correction) async {
    Box correctionBox = Hive.box<Correction>("corrections");
    correction.ab = newMilli;
    correctionBox.putAt(index, correction);
    sortBox();
  }

  Future<void> changeUM(int index, int newMilli, Correction correction) async {
    Box correctionBox = Hive.box<Correction>("corrections");
    correction.um = newMilli;
    correctionBox.putAt(index, correction);
    sortBox();
  }

  Future<void> sortBox() async {
    Box correctionBox = Hive.box<Correction>("corrections");
    if (correctionBox.isEmpty) return;
    int n = correctionBox.length;
    int i, j;
    Correction temp;

    List<Correction> correctionList = List<Correction>.generate(correctionBox.length, (index) => correctionBox.getAt(index));

    for (i = 1; i < n; i++) {
      temp = correctionList[i];
      j = i - 1;
      while (j >= 0 && temp.ab < correctionList[j].ab) {
        correctionList[j + 1] = correctionList[j];
        --j;
      }
      correctionList[j + 1] = temp;
    }

    for (int x = 0; x < correctionList.length; x++) {
      correctionBox.putAt(x, correctionList[x]);
    }
  }
}
