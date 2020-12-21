import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../hiveClasses/Zeitnahme.dart';
import 'Data.dart';

class HiveDB {
  Box zeitenBox;
  final animatedListkey = GlobalKey<AnimatedListState>();
  final listChangesStream = StreamController<int>.broadcast();
  int changeNumber = 0;
  int todayElapsedTime = 0;
  bool isRunning = false;

  final ueberMillisekundenGesamtStream = StreamController<int>();
  int ueberMillisekundenGesamt = 0;

  Future<void> initHiveDB() async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    if (zeitenBox.length > 0) {
      calculateTodayElapsedTime();
      updateGesamtUeberstunden();
      //addMockData();
    }
    urlaubsTageCheck();
  }

  void addMockData() async {
    zeitenBox.clear();
/*    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    Zeitnahme z1 = Zeitnahme(day: DateTime(5, 3, 2000));
    print("HiveDB - " + DateTime(5, 3, 2000).toString());

    zeitenBox.add(z1);*/
  }

  void startTime(int startTime) async {
    print("HiveDB - startTime - start");
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    // Heutiger Tag in Variable
    print("HiveDB - startTime - length is" + zeitenBox.length.toString());
    if (zeitenBox.length >= 1) {
      Zeitnahme latest = zeitenBox.getAt(zeitenBox.length - 1);
      // Checks if latest entry in list is from tody
      if (latest.day.isSameDate(DateTime.now())) {
        print("HiveDB - startTime - today already exists");
        //Checks if the Lists are the same length before putting in new time
        if (latest.startTimes.length == latest.endTimes.length) {
          if (latest.endTimes.last > DateTime.now().millisecondsSinceEpoch) {
            print(
                "endTime wurde in die Zukunft korrigiert -> wieder auf kurz vor jetzt");
            latest.endTimes.last = DateTime.now().millisecondsSinceEpoch - 1;
          }
          //Adds new Time to the List
          latest.startTimes.add(startTime);
          //Saves the List
          zeitenBox.putAt(zeitenBox.length - 1, latest);
        } else {
          print(
              "HiveDB - startTime - ERROR: EndTimes and StartTimes were not same length");
        }
        print("HiveDB - startZeit hinzugefügt");
      } else {
        // No Entry for Today -> Create new Entry with default values
        zeitenBox.add(Zeitnahme(
            day: DateTime.now(),
            state: "default",
            startTimes: [startTime],
            endTimes: []));
        print("HiveDB - neue Zeitnahme + startZeit hinzugefügt");
        animatedListkey.currentState.insertItem(0);
      }
    } else {
      // First Entry ever -> Create new Entry with default values
      zeitenBox.add(Zeitnahme(
          day: DateTime.now(),
          state: "default",
          startTimes: [startTime],
          endTimes: []));
      print("HiveDB - neue Zeitnahme + startZeit hinzugefügt");
      animatedListkey.currentState.insertItem(0);
    }

    listChangesStream.sink.add(changeNumber++);

    await urlaubsTageCheck();
  }

  void endTime(int endTime) async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    //Adds the End time regardless of the Day -> You can end your workday at 3pm
    Zeitnahme latest = zeitenBox.getAt(zeitenBox.length - 1);

    if (latest.startTimes.length == latest.endTimes.length + 1) {
      latest.endTimes.add(endTime);
      zeitenBox.putAt(zeitenBox.length - 1, latest);
      print("neue endTime an neuster Zeitnahme hinzugefügt" +
          latest.endTimes.toString());
    } else {
      print("HiveDB - endTime - ERROR: StartTimes war nicht um eins größer");
    }

    listChangesStream.sink.add(changeNumber++);
  }

  Future<void> calculateTodayElapsedTime() async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    Zeitnahme neusete = zeitenBox.getAt(zeitenBox.length - 1);
    if (neusete.day.isSameDate(DateTime.now())) {
      todayElapsedTime = neusete.getElapsedTime();
      print("HiveDB - today Elapsed Time is " + todayElapsedTime.toString());
    }
  }

  Future<void> updateGesamtUeberstunden() async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    ueberMillisekundenGesamt = 0;

    for (int i = 0; i < zeitenBox.length; i++) {
      if (i == zeitenBox.length - 1 && isRunning) {
        print("HiveDB - skipped");
        continue;
      }

      Zeitnahme z = zeitenBox.getAt(i);
      ueberMillisekundenGesamt = ueberMillisekundenGesamt + z.getUeberstunden();
      print("HiveDB - ueberMSG: " + ueberMillisekundenGesamt.toString());
    }

    print("HiveDB - final ueberMSG: " + ueberMillisekundenGesamt.toString());

    ueberMillisekundenGesamtStream.sink.add(ueberMillisekundenGesamt);
  }

  bool isSameDate(DateTime first, DateTime other) {
    return first.year == other.year &&
        first.month == other.month &&
        first.day == other.day;
  }

  Future<void> urlaubsTageCheck() async {
    print("HiveDB - urlaubscheck start");
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    if (zeitenBox.length > 0) {
      DateTime latestDate = zeitenBox.getAt(zeitenBox.length - 1).day;
      print("HiveDB - last date " + latestDate.toString());
      DateTime checkedDate = latestDate.add(Duration(days: 1));

      if (!isSameDate(checkedDate, DateTime.now()) &&
          checkedDate.isBefore(DateTime.now())) {
        print("HiveDB - urlaubscheck Tag ergänzen");

        while (!isSameDate(checkedDate, DateTime.now())) {
          //Nur wenn es ein Arbeitstag ist
          if (getIt<Data>().wochentage[checkedDate.weekday - 1] == true) {
            zeitenBox.add(Zeitnahme(
                day: checkedDate,
                state: "empty",
                startTimes: [],
                endTimes: []));
            if (animatedListkey.currentState != null) {
              animatedListkey.currentState.insertItem(0);
            }
            print("HiveDB - urlaubscheck Tag ergänzt");
          } else {
            print("HiveDB - urlaubscheck Wochentag kein Arbeitstag");
          }
          checkedDate = checkedDate.add(Duration(days: 1));
        }
      }
    }

    print("HiveDB - urlaubscheck finished");
  }

  Future<void> changeState(String state, int index) async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    Zeitnahme _updated = zeitenBox.getAt(index);
    _updated.state = state;
    zeitenBox.putAt(index, _updated);

    listChangesStream.sink.add(changeNumber++);
    updateGesamtUeberstunden();
  }

  void dispose() {
    zeitenBox.close();
    listChangesStream.close();
    ueberMillisekundenGesamtStream.close();
  }

  Future<void> updateStartEndZeit(
      int zeitnahmeIndex, int startEndIndex, bool start, int value) async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    Zeitnahme edit = zeitenBox.getAt(zeitnahmeIndex);

    start
        ? edit.startTimes[startEndIndex] = value
        : edit.endTimes[startEndIndex] = value;

    zeitenBox.putAt(zeitnahmeIndex, edit);

    print("HiveDB - updateStartEndZeit - gespeichert");
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
