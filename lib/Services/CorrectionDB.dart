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
    SharedPreferences prefs =
        await getIt<Data>().getSharedPreferencesInstance();
    if (prefs.containsKey("korrekturUM") || prefs.containsKey("korrekturAB")) {
      await migrateData(prefs);
    }
    resetBox();
  }

  Future<void> resetBox() async {
    Box correctionBox = Hive.box<Correction>("corrections");
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
    resetBox();
    prefs.remove("korrekturUM");
    prefs.remove("korrekturAB");
    // correctionBox.add(Correction(
    //     ab: 6 * Duration.millisecondsPerHour,
    //     um: 30 * Duration.millisecondsPerMinute));
    // correctionBox.add(Correction(
    //     ab: 9 * Duration.millisecondsPerHour,
    //     um: 45 * Duration.millisecondsPerMinute));
    logger.w("CORRECTION DB MIGRATED");
    print(correctionBox.length);
  }

  Future<void> switch12() async {
    Box correctionBox = Hive.box<Correction>("corrections");
    Correction one = correctionBox.getAt(0);
    Correction two = correctionBox.getAt(1);

    correctionBox.putAt(0, two);
    correctionBox.putAt(1, one);
  }

  Future<void> deleteCorrection(int index) async {
    Box correctionBox = Hive.box<Correction>("corrections");

    // listKey.currentState!.removeItem(
    //     index,
    //     (context, animation) => SizeTransition(
    //           sizeFactor: CurvedAnimation(
    //               parent: animation, curve: Curves.ease.flipped),
    //           child: AbsorbPointer(
    //             absorbing: true,
    //             child: CorrectionTile(
    //               correction: removedItem,
    //               listKey: listKey,
    //               index: index,
    //             ),
    //           ),
    //         ),
    //     duration: Duration(milliseconds: 300));
    // ScaffoldMessenger.of(listKey.currentContext!).showSnackBar(SnackBar(
    //   content: Card(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Text("hi"),
    //     ),
    //   ),
    //   padding: EdgeInsets.all(0),
    //   backgroundColor: Colors.transparent,
    //   elevation: 0,
    // ));
    correctionBox.deleteAt(index);
  }

  Future<void> changeAB(int index, int newMilli, Correction correction) async {
    Box correctionBox = Hive.box<Correction>("corrections");
    correction.ab = newMilli;
    correctionBox.putAt(index, correction);
  }
}
