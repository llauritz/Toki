import 'package:hive/hive.dart';

import '../Services/Data.dart';
import '../Services/Theme.dart';

part 'Zeitnahme.g.dart';

@HiveType(typeId: 1)
class Zeitnahme {
  Zeitnahme({this.day, this.state, this.endTimes, this.startTimes});

  @HiveField(0)
  DateTime day;

  @HiveField(1)
  String state;

  @HiveField(2)
  List<int> startTimes;

  @HiveField(3)
  List<int> endTimes;

  @HiveField(4)
  String tag = "Urlaub";

  @HiveField(5)
  int editMilli = 0;

  int getElapsedTime() {
    int startLength = startTimes.length;
    int endLength = endTimes.length;
    int _elapsedTime = 0;
    for (int i = 0; i < startLength; i++) {
      int e = i==endLength
        ? DateTime.now().millisecondsSinceEpoch
        : endTimes[i];
      _elapsedTime = _elapsedTime + e - startTimes[i];
    }
    //print("Zeitnahme - elapsed time ${Duration(milliseconds: _elapsedTime)}");
    return _elapsedTime;
  }

  int getUeberstunden() {
    if (state == "default") {
      int tagesHours = getIt<Data>().tagesstunden.truncate();
      int tagesMinutes =
          ((getIt<Data>().tagesstunden - tagesHours) * 60).toInt();

      int uebermilliseconds = getElapsedTime() -
          Duration(hours: tagesHours, minutes: tagesMinutes).inMilliseconds -
          getKorrektur();
      print("Zeitnahme - day" + day.toString());
      return uebermilliseconds;

    } else if(state == "edited"){
        int tagesHours = getIt<Data>().tagesstunden.truncate();
        int tagesMinutes =
            ((getIt<Data>().tagesstunden - tagesHours) * 60).toInt();
        print("Zeitnahme - tageshrs: $tagesHours");
        print("Zeitnahme - tagesmin: $tagesMinutes");
        int uebermilliseconds = editMilli - Duration(hours: tagesHours, minutes: tagesMinutes).inMilliseconds;
        print("Zeitnahme - uebermilliEDITED: ${Duration(milliseconds: uebermilliseconds)}");
        return uebermilliseconds;

    } else if(state == "empty"){
        int tagesHours = getIt<Data>().tagesstunden.truncate();
        int tagesMinutes =
        ((getIt<Data>().tagesstunden - tagesHours) * 60).toInt();
        return -Duration(hours: tagesHours, minutes: tagesMinutes).inMilliseconds;
    } else{
      return 0;
    }
  }

  int getKorrektur() {
    // geht davon aus, dass korrekturAB sortiert ist.
    if (getIt<Data>().pausenKorrektur == true) {
      Duration elapsed = Duration(milliseconds: getElapsedTime());

      for (int i = getIt<Data>().korrekturAB.length - 1; i >= 0; i--) {
        int ab = getIt<Data>().korrekturAB[i];
        print("Zeitnahme - Korrektur - elapsedhrs ${elapsed.inHours}");

        if (elapsed.inHours >= ab) {
          int minPau = getIt<Data>().korrekturUM[i];
          Duration pause = Duration(milliseconds: getPause());
          print("Zeitnahme - Korrektur - minPau $minPau");
          print("Zeitnahme - Korrektur - pause $pause");

          if (pause.inMinutes < minPau) {
            print("Zeitnahme - Korrektur${minPau - pause.inMinutes}");
            return Duration(minutes: minPau - pause.inMinutes).inMilliseconds;
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
      if(startTimes.length>endTimes.length){
        fromStartToFinish = DateTime.now().millisecondsSinceEpoch - startTimes[0];
      }else{
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
