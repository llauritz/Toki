import 'package:Toki/Services/CorrectionDB.dart';
import 'package:Toki/hiveClasses/Correction.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../Services/Data.dart';
import '../Services/Theme.dart';

part 'Zeitnahme.g.dart';

@HiveType(typeId: 1)
class Zeitnahme {
  Zeitnahme({required this.day, required this.state, required this.endTimes, required this.startTimes});

  @HiveField(0)
  DateTime day;

  @HiveField(1)
  String state;

  @HiveField(2)
  List<int> startTimes;

  @HiveField(3)
  List<int> endTimes;

  @HiveField(4)
  String tag = "Stundenabbau";

  @HiveField(5)
  int editMilli = 0;

  @HiveField(6)
  bool? autoStoppedTime = false;

  int getElapsedTime() {
    int startLength = startTimes.length;
    int endLength = endTimes.length;
    int _elapsedTime = 0;
    for (int i = 0; i < startLength; i++) {
      int e = i == endLength ? DateTime.now().millisecondsSinceEpoch : endTimes[i];
      _elapsedTime = _elapsedTime + e - startTimes[i];
    }
    //print("Zeitnahme - elapsed time ${Duration(milliseconds: _elapsedTime)}");
    return _elapsedTime;
  }

  int getUeberstunden() {
    int weekday = getIt<Data>().individualTimes ? day.weekday - 1 : 0;
    int milliseconds = 0;
    // Nur, wenn der Tag auch ein Arbeitstag ist, wird die Stundenzahl mit der Arbeitszeit verrechnet.
    if (getIt<Data>().wochentage[day.weekday - 1]) {
      milliseconds = getIt<Data>().workingTime[weekday];
    }

    if (state == "default") {
      int uebermilliseconds = getElapsedTime() - milliseconds - getKorrektur();
      print("Zeitnahme - day" + day.toString());
      return uebermilliseconds;
    } else if (state == "edited") {
      int uebermilliseconds = editMilli - milliseconds;
      return uebermilliseconds;
    } else if (state == "empty") {
      return -milliseconds;
    } else {
      return 0;
    }
  }

  int getKorrektur() {
    Box corrections = Hive.box<Correction>("corrections");

    //logger.w("Korrektur" + corrections.length.toString());
    // geht davon aus, dass korrekturAB sortiert ist.
    if (getIt<Data>().pausenKorrektur == true && corrections.isNotEmpty) {
      Duration elapsed = Duration(milliseconds: getElapsedTime());

      for (int i = corrections.length - 1; i >= 0; i--) {
        int ab = corrections.getAt(i)!.ab;
        print("Zeitnahme - Korrektur - elapsedhrs ${elapsed.inHours}");

        if (elapsed.inMilliseconds >= ab) {
          int minPau = corrections.getAt(i)!.um;
          Duration pause = Duration(milliseconds: getPause());
          print("Zeitnahme - Korrektur - minPau $minPau");
          print("Zeitnahme - Korrektur - pause $pause");

          if (pause.inMilliseconds < minPau) {
            print("Zeitnahme - Korrektur${(minPau - pause.inMilliseconds) / Duration.millisecondsPerMinute}");
            return minPau - pause.inMilliseconds;
          }
          break;
        }
      }
    }
    return 0;
  }

  int getPause() {
    if (state != 'free' && endTimes.isNotEmpty) {
      int fromStartToFinish = 0;
      if (startTimes.length > endTimes.length) {
        fromStartToFinish = DateTime.now().millisecondsSinceEpoch - startTimes[0];
      } else {
        fromStartToFinish = endTimes.last - startTimes[0];
      }
      logger.v("elapsed" + Duration(milliseconds: getElapsedTime()).toString());
      logger.v("fromStartToFinish" + Duration(milliseconds: fromStartToFinish).toString());
      return fromStartToFinish - getElapsedTime();
    } else {
      return 0;
    }
  }
}
