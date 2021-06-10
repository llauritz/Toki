import 'dart:async';

import 'package:Timo/Services/timer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'HiveDB.dart';

class Data {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //SharedPreferences nullPrefs;
  final isRunningStream = StreamController<bool>.broadcast();
  bool isRunning = false;

  String username = "";

  @deprecated
  double tagesstunden = 8.0;

  @deprecated
  List<int> korrekturAB = [6, 9];
  @deprecated
  List<int> korrekturUM = [30, 45];

  bool pausenKorrektur = true;

  TimerText timerText = TimerText();
  bool finishedOnboarding = false;

  bool automatischAusstempeln = true;
  int automatischAusstempelnTimeMilli = 0;

  bool individualTimes = true;
  List<bool> wochentage = [true, true, true, true, true, false, false];
  //working time in milliseconds, 0 = free day
  List<int> workingTime = [
    8 * Duration.millisecondsPerHour, // 0: Monday
    8 * Duration.millisecondsPerHour, // 1: Tuesday
    8 * Duration.millisecondsPerHour, // 2: Wednesday
    8 * Duration.millisecondsPerHour, // 3: Thursday
    8 * Duration.millisecondsPerHour, // 4: Friday
    0, // 5: Saturday
    0 // 6: Sunday
  ];

  Future<void> initSharedPreferences() async {
    final SharedPreferences prefs = await _prefs;
    //nullPrefs = await SharedPreferences.getInstance();
    print("Data - SharedPreferences initiated " + prefs.toString());
  }

  Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await _prefs;
  }

  Future<void> initData() async {
    WidgetsFlutterBinding.ensureInitialized();

    final SharedPreferences prefs = await _prefs;

    prefs.containsKey("finishedOnboarding") ? finishedOnboarding = prefs.getBool("finishedOnboarding")! : setFinishedOnboarding(false);

    prefs.containsKey("name") ? username = prefs.getString("name")! : updateName("Name");

    if (prefs.containsKey("tagesstunden")) {
      tagesstunden = prefs.getDouble("tagesstunden")!;
      migrateWorkingTime();
    }

    prefs.containsKey("MO")
        ? wochentage = [
            prefs.getBool("MO")!,
            prefs.getBool("DI")!,
            prefs.getBool("MI")!,
            prefs.getBool("DO")!,
            prefs.getBool("FR")!,
            prefs.getBool("SA")!,
            prefs.getBool("SO")!,
          ]
        : updateWochentage(wochentage);

    prefs.containsKey("MOmilli")
        ? workingTime = [
            prefs.getInt("MOmilli")!,
            prefs.getInt("TUmilli")!,
            prefs.getInt("WEmilli")!,
            prefs.getInt("THmilli")!,
            prefs.getInt("FRmilli")!,
            prefs.getInt("SAmilli")!,
            prefs.getInt("SUmilli")!,
          ]
        : updateWorkingTime(workingTime);

    prefs.containsKey("individualTimes") ? individualTimes = prefs.getBool("individualTimes")! : toggleIndividualTimes();

    prefs.containsKey("pausenKorrektur") ? pausenKorrektur = prefs.getBool("pausenKorrektur")! : updatePausenKorrektur(pausenKorrektur);

    // prefs.containsKey("korrekturAB")
    //     //converts List of Strings to List of Integers and stores them in local List
    //     ? korrekturAB =
    //         prefs.getStringList("korrekturAB")!.map(int.parse).toList()
    //     //and the other way round
    //     : prefs.setStringList(
    //         "korrekturAB", korrekturAB.map((e) => e.toString()).toList());
    // print("Data - kAB in local List" + korrekturAB.toString());

    // prefs.containsKey("korrekturUM")
    //     //converts List of Strings to List of Integers and stores them in local List
    //     ? korrekturAB =
    //         prefs.getStringList("korrekturUM")!.map(int.parse).toList()
    //     //and the other way round
    //     : prefs.setStringList(
    //         "korrekturUM", korrekturAB.map((e) => e.toString()).toList());
    // print("Data - kUM in local List" + korrekturUM.toString());

    if (!prefs.containsKey("OvertimeOffset")) setOffset(0);
  }

  void setUserName(String newName) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("name", newName);
    username = newName;
    print(prefs.getString("Data - new username:" + prefs.getString("name")!));
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString("Data - username is:" + prefs.getString("name")!));
    return prefs.getString("name")!;
  }

  // Future<void> updatePrimaryColor(AssetImage image) async {
  //   currentImageStream.sink.add(image);
  //   currentImage = image;
  //   PaletteGenerator paletteGenerator =
  //       await PaletteGenerator.fromImageProvider(image);
  //   primaryColor = paletteGenerator.dominantColor.color;
  //   print(primaryColor.toString());
  //   primaryColorStream.sink.add(primaryColor);
  // }

  // void updateSettingsBackground(String hash) async {
  //   backgroundHashStream.sink.add(hash);
  //   backgroundHash = hash;
  //   print("Data - hash updated");
  // }

  @deprecated
  void updateTagesstunden(double newTagesstunden) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble("tagesstunden", newTagesstunden);
    tagesstunden = newTagesstunden;
    print("Data - updated Tagesstunden: " + prefs.getDouble("tagesstunden").toString());
  }

  void updateName(String newName) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("name", newName);
    username = newName;
    print("Data - updated Username: " + prefs.getString("name").toString());
  }

  void setFinishedOnboarding(bool b) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("finishedOnboarding", b);
    finishedOnboarding = b;
    print("Data - updated finishedOnboarding: " + prefs.getBool("finishedOnboarding").toString());
  }

  void toggleIndividualTimes() async {
    final SharedPreferences prefs = await _prefs;
    individualTimes = !individualTimes;
    prefs.setBool("individualTimes", individualTimes);
  }

  void updateWochentage(List<bool> list) async {
    final SharedPreferences prefs = await _prefs;
    wochentage = list;
    prefs.setBool("MO", list[0]);
    prefs.setBool("DI", list[1]);
    prefs.setBool("MI", list[2]);
    prefs.setBool("DO", list[3]);
    prefs.setBool("FR", list[4]);
    prefs.setBool("SA", list[5]);
    prefs.setBool("SO", list[6]);
    print("Dayrow in Shared Preferences gespeichert");
  }

  void updateWorkingTime(List<int> list) async {
    final SharedPreferences prefs = await _prefs;
    workingTime = list;
    prefs.setInt("MOmilli", list[0]);
    prefs.setInt("TUmilli", list[1]);
    prefs.setInt("WEmilli", list[2]);
    prefs.setInt("THmilli", list[3]);
    prefs.setInt("FRmilli", list[4]);
    prefs.setInt("SAmilli", list[5]);
    prefs.setInt("SUmilli", list[6]);
  }

  Future<void> migrateWorkingTime() async {
    final SharedPreferences prefs = await _prefs;
    if (!prefs.containsKey("MOmilli")) {
      if (prefs.containsKey("tagesstunden") && prefs.containsKey("MO")) {
        tagesstunden = prefs.getDouble("tagesstunden")!;
        List<bool> wochentageTMP = [
          prefs.getBool("MO")!,
          prefs.getBool("DI")!,
          prefs.getBool("MI")!,
          prefs.getBool("DO")!,
          prefs.getBool("FR")!,
          prefs.getBool("SA")!,
          prefs.getBool("SO")!,
        ];
        for (int i = 0; i < wochentageTMP.length; i++) {
          if (wochentageTMP[i]) workingTime[i] = (tagesstunden * Duration.millisecondsPerHour).toInt();
        }
      }
    }

    updateWorkingTime(workingTime);

    print("MIGRATED LIST: " + workingTime.toString());
  }

  Future<void> updatePausenKorrektur(bool b) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("pausenKorrektur", b);
    print("Data - pausenKorrekturBool " + prefs.getBool("pausenKorrektur").toString());
  }

  Future<void> addOffset(int milliseconds) async {
    final SharedPreferences prefs = await _prefs;
    int newValue = prefs.containsKey("OvertimeOffset") ? prefs.getInt("OvertimeOffset")! + milliseconds : milliseconds;
    prefs.setInt("OvertimeOffset", newValue);

    print("Data - addOffset - OvertimeOffset " + prefs.getInt("OvertimeOffset").toString());
    getIt<HiveDB>().updateGesamtUeberstunden();
  }

  Future<int> getOffset() async {
    final SharedPreferences prefs = await _prefs;
    print("Data - getOffset");
    if (prefs.containsKey("OvertimeOffset")) {
      print("Data - getOffset" + prefs.getInt("OvertimeOffset").toString());
      return prefs.getInt("OvertimeOffset")!;
    } else {
      return 0;
    }
  }

  Future<void> setOffset(int milliseconds) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("OvertimeOffset", milliseconds);

    print("Data - OvertimeOffset " + prefs.getInt("OvertimeOffset").toString());
    getIt<HiveDB>().updateGesamtUeberstunden();
  }

  void dispose() {
    isRunningStream.close();
  }
}
