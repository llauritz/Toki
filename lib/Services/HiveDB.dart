import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../hiveClasses/Zeitnahme.dart';
import 'Data.dart';
import 'Theme.dart';

class HiveDB {
  Box zeitenBox;
  final GlobalKey<AnimatedListState> animatedListkey = GlobalKey<AnimatedListState>();
  final StreamController<int> listChangesStream = StreamController<int>.broadcast();
  int changeNumber = 0;
  int todayElapsedTime = 0;
  bool isRunning = false;
  final int ausVersehenWertSekunden = 5;

  final StreamController<int> ueberMillisekundenGesamtStream = StreamController<int>.broadcast();
  int ueberMillisekundenGesamt = 0;

  Future<void> initHiveDB() async {

    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    if (zeitenBox.length > 0) {
      urlaubsTageCheck();
      calculateTodayElapsedTime();
      updateGesamtUeberstunden();
    }
  }


  void startTime(int startTime) async{
    print("HiveDB - startTime - start");
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    // Heutiger Tag in Variable
    print("HiveDB - startTime - length is" + zeitenBox.length.toString());
    if (zeitenBox.length >= 1) {
      Zeitnahme latest = zeitenBox.getAt(zeitenBox.length - 1);
      // Checks if latest entry in list is from today
      if (latest.day.isSameDate(DateTime.now())) {
        print("HiveDB - startTime - today already exists");
        changeState("default", zeitenBox.length - 1);
        //Checks if the Lists are the same length before putting in new time
        if (latest.startTimes.length == latest.endTimes.length) {
          if (latest.endTimes.last > DateTime.now().millisecondsSinceEpoch) {
            print(
                "endTime wurde in die Zukunft korrigiert -> wieder auf kurz vor jetzt");
            latest.endTimes.last = DateTime.now().millisecondsSinceEpoch - 1;
          }

          // checks if at least a few seconds have passed
            int davor = latest.endTimes.last;
            if (startTime-davor < Duration.millisecondsPerSecond*ausVersehenWertSekunden){
              latest.endTimes.removeLast();
            }else{
              //Adds new Time to the List
              latest.startTimes.add(startTime);
            }

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
        animatedListkey.currentState.insertItem(0, duration: Duration(milliseconds: 1000));
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

      if(latest.startTimes.length>1){
        int davor = latest.startTimes.last;
        if (endTime - davor < (Duration.millisecondsPerSecond * ausVersehenWertSekunden)) {
          latest.startTimes.removeLast();
        } else {
          //Adds new Time to the List
          latest.endTimes.add(endTime);
        }
      }else{
        latest.endTimes.add(endTime);
      }

      zeitenBox.putAt(zeitenBox.length - 1, latest);
      logger.d('neue endTime an neuster Zeitnahme hinzugefügt' +
          latest.endTimes.toString());
    } else {
      logger.d('HiveDB - endTime - ERROR: StartTimes war nicht um eins größer');
    }

    listChangesStream.sink.add(changeNumber++);
  }

  Future<void> calculateTodayElapsedTime() async {
    zeitenBox = await Hive.openBox<Zeitnahme>('zeitenBox');
    if (zeitenBox.length>0){
      Zeitnahme neusete = zeitenBox.getAt(zeitenBox.length - 1) as Zeitnahme;
      if (neusete.day.isSameDate(DateTime.now())) {
        todayElapsedTime = neusete.getElapsedTime();
        logger.v("HiveDB - today Elapsed Time is " + Duration(milliseconds:todayElapsedTime).toString());
      }
    }
  }

  int getTodayElapsedTime(){
    if (zeitenBox.length>0){
      Zeitnahme neusete = zeitenBox.getAt(zeitenBox.length - 1) as Zeitnahme;
      if (neusete.day.isSameDate(DateTime.now())) {
        return neusete.getElapsedTime();
      }else{
        return 0;
      }
    }else{
      return 0;
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

      Zeitnahme z = zeitenBox.getAt(i) as Zeitnahme;
      ueberMillisekundenGesamt = ueberMillisekundenGesamt + z.getUeberstunden();
      print("HiveDB - ueberMSG: " + ueberMillisekundenGesamt.toString());
    }

    ueberMillisekundenGesamt = ueberMillisekundenGesamt
      + await getIt<Data>().getOffset();

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
      final DateTime latestDate = zeitenBox.getAt(zeitenBox.length - 1).day as DateTime;
      print("HiveDB - last date " + latestDate.toString());
      DateTime checkedDate = latestDate.add(const Duration(days: 1));

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
              animatedListkey.currentState.insertItem(0, duration: const Duration(milliseconds: 1000));
            }
            print("HiveDB - urlaubscheck Tag ergänzt");
          } else {
            print("HiveDB - urlaubscheck Wochentag kein Arbeitstag");
          }
          checkedDate = checkedDate.add(const Duration(days: 1));
        }
      }
    }

    print("HiveDB - urlaubscheck finished");
  }

  Future<void> changeState(String state, int index) async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    print("HiveDB - changeState - 1 $index");

    final Zeitnahme _updated = zeitenBox.getAt(index) as Zeitnahme;
    print("HiveDB - changeState - 2 ${_updated.state}");
    _updated.state = state;
    zeitenBox.putAt(index, _updated);

    listChangesStream.sink.add(changeNumber++);
    updateGesamtUeberstunden();
    print("HiveDB - changeState - 3 ${_updated.state}");
  }

  void dispose() {
    zeitenBox.close();
    listChangesStream.close();
    ueberMillisekundenGesamtStream.close();
  }

  Future<void> updateStartEndZeit(
      int zeitnahmeIndex, int startEndIndex, bool start, int value) async {
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");

    final Zeitnahme edit = zeitenBox.getAt(zeitnahmeIndex) as Zeitnahme;

    start
        ? edit.startTimes[startEndIndex] = value
        : edit.endTimes[startEndIndex] = value;

    zeitenBox.putAt(zeitnahmeIndex, edit);

    print("HiveDB - updateStartEndZeit - gespeichert");
  }

  Future<void> updateTag(String tag, int index) async{
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    print("HiveDB - changeTag - 1 $index");

    Zeitnahme _updated = zeitenBox.getAt(index) as Zeitnahme;
    print("HiveDB - changeTag - 2 ${_updated.tag}");
    _updated.tag = tag;
    zeitenBox.putAt(index, _updated);

    listChangesStream.sink.add(changeNumber++);
    print("HiveDB - changeTag - 3 ${_updated.tag}");
  }

  Future<void> updateEditMilli(int editMilli, int index) async{
    zeitenBox = await Hive.openBox<Zeitnahme>("zeitenBox");
    print("HiveDB - changeEditMilli - 1 $index");

    Zeitnahme _updated = zeitenBox.getAt(index) as Zeitnahme;
    print("HiveDB - changeEditMilli - 2 ${Duration(milliseconds: _updated.editMilli)}");
    _updated.editMilli = editMilli;
    zeitenBox.putAt(index, _updated);

    listChangesStream.sink.add(changeNumber++);
    print("HiveDB - changeEditMilli - 3 ${Duration(milliseconds: _updated.editMilli)}");
  }

}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
