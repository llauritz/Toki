import 'dart:async';

import 'package:Timo/Services/timer.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'HiveDB.dart';

class Data{
  SharedPreferences prefs;
  final isRunningStream = StreamController<bool>.broadcast();
  bool isRunning = false;
  String username = "";
  double tagesstunden = 8.0;
  List<bool> wochentage = [true, true, true, true, true, false, false];
  Color primaryColor = Colors.blueAccent;
  AssetImage currentImage = AssetImage("assets/background/clouds/clouds4.jpg");
  final primaryColorStream = StreamController<Color>.broadcast();
  final currentImageStream = StreamController<AssetImage>.broadcast();
  List<int> korrekturAB = [6, 9];
  List<int> korrekturUM = [30, 45];
  bool pausenKorrektur = true;
  final backgroundHashStream = StreamController<String>.broadcast();
  String backgroundHash = "cCBYFk?a9K9Ht7of06Rm?Wa%M~WC~ks,9J";
  int backgroundNumber = 1;
  TimerText timerText = TimerText();


  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    print("Data - SharedPreferences initiated " + prefs.toString());
  }

  Future<void> initData() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initSharedPreferences();

    if (prefs != null) {
      prefs.containsKey("name")
          ? username = prefs.getString("name")
          //TODO: generate Random Name
          : updateName("");

      prefs.containsKey("tagesstunden")
          ? tagesstunden = prefs.getDouble("tagesstunden")
          : updateTagesstunden(tagesstunden);

      prefs.containsKey("MO")
          ? wochentage = [
              prefs.getBool("MO"),
              prefs.getBool("DI"),
              prefs.getBool("MI"),
              prefs.getBool("DO"),
              prefs.getBool("FR"),
              prefs.getBool("SA"),
              prefs.getBool("SO"),
            ]
          : updateWochentage(wochentage);

      prefs.containsKey("pausenKorrektur")
          ? pausenKorrektur = prefs.getBool("pausenKorrektur")
          : updatePausenKorrektur(pausenKorrektur);

      prefs.containsKey("korrekturAB")
      //converts List of Strings to List of Integers and stores them in local List
          ?
      korrekturAB = prefs.getStringList("korrekturAB").map(int.parse).toList()
      //and the other way round
          : prefs.setStringList(
          "korrekturAB", korrekturAB.map((e) => e.toString()).toList());
      print("Data - kAB in local List" + korrekturAB.toString());

      prefs.containsKey("korrekturUM")
      //converts List of Strings to List of Integers and stores them in local List
          ?
      korrekturAB = prefs.getStringList("korrekturUM").map(int.parse).toList()
      //and the other way round
          : prefs.setStringList(
          "korrekturUM", korrekturAB.map((e) => e.toString()).toList());
      print("Data - kUM in local List" + korrekturUM.toString());

      if(!prefs.containsKey("OvertimeOffset"))
        setOffset(0);

      print("Data - Data initialized");
    } else {
      print("Data - SHARED PREFERENCES NOT WORKING -------------------");
    }
  }

  void setUserName(String newName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", newName);
    username = newName;
    print(prefs.getString("Data - new username:" + prefs.getString("name")));
  }

  Future<String> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("Data - username is:" + prefs.getString("name")));
    return prefs.getString("name");
  }

  Future<void> updatePrimaryColor(AssetImage image) async {
    currentImageStream.sink.add(image);
    currentImage = image;
    PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(image);
    primaryColor = paletteGenerator.dominantColor.color;
    print(primaryColor.toString());
    primaryColorStream.sink.add(primaryColor);
  }

  void updateSettingsBackground(String hash) async {
    backgroundHashStream.sink.add(hash);
    backgroundHash = hash;
    print("Data - hash updated");
  }

  void updateTagesstunden(double newTagesstunden) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("tagesstunden", newTagesstunden);
    tagesstunden = newTagesstunden;
    print("Data - updated Tagesstunden: " +
        prefs.getDouble("tagesstunden").toString());
  }

  void updateName(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", newName);
    username = newName;
    print("Data - updated Username: " + prefs.getString("name").toString());
  }

  Future<void> updateWochentage(List<bool> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("MO", list[0]);
    prefs.setBool("DI", list[1]);
    prefs.setBool("MI", list[2]);
    prefs.setBool("DO", list[3]);
    prefs.setBool("FR", list[4]);
    prefs.setBool("SA", list[5]);
    prefs.setBool("SO", list[6]);
    print("Dayrow in Shared Preferences gespeichert");
  }

  Future<void> updateKorrekturenAB(int index, int value)async{
    prefs = await SharedPreferences.getInstance();
    korrekturAB[index] = value;
    //converts List of Integers to List of Strings and stores them in SharedPrefs
    prefs.setStringList("korrekturAB", korrekturAB.map((e) => e.toString()).toList());
    print("Data - kAB in SharedPrefs"+ prefs.getStringList("korrekturAB").toString());
  }

  Future<void> updateKorrekturenUM(int index, int value)async{
    prefs = await SharedPreferences.getInstance();
    korrekturAB[index] = value;
    //converts List of Integers to List of Strings and stores them in SharedPrefs
    prefs.setStringList("korrekturUM", korrekturUM.map((e) => e.toString()).toList());
    print("Data - kUM in SharedPrefs"+ prefs.getStringList("korrekturUM").toString());
  }

  Future<void> deleteKorrekturenAB(int index)async{
    prefs = await SharedPreferences.getInstance();
    korrekturAB.removeAt(index);
    //converts List of Integers to List of Strings and stores them in SharedPrefs
    prefs.setStringList("korrekturAB", korrekturAB.map((e) => e.toString()).toList());
    print("Data - kAB in SharedPrefs"+ prefs.getStringList("korrekturAB").toString());
  }

  Future<void> deleteKorrekturenUM(int index)async{
    prefs = await SharedPreferences.getInstance();
    korrekturUM.removeAt(index);
    //converts List of Integers to List of Strings and stores them in SharedPrefs
    prefs.setStringList("korrekturUM", korrekturUM.map((e) => e.toString()).toList());
    print("Data - kUM in SharedPrefs"+ prefs.getStringList("korrekturUM").toString());
  }

  Future<void> addKorrekturenAB(int value)async{
    prefs = await SharedPreferences.getInstance();
    korrekturAB.add(value);
    //converts List of Integers to List of Strings and stores them in SharedPrefs
    prefs.setStringList("korrekturAB", korrekturAB.map((e) => e.toString()).toList());
    print("Data - kAB in SharedPrefs"+ prefs.getStringList("korrekturAB").toString());
  }

  Future<void> addKorrekturenUM(int value)async{
    prefs = await SharedPreferences.getInstance();
    korrekturUM.add(value);
    //converts List of Integers to List of Strings and stores them in SharedPrefs
    prefs.setStringList("korrekturUM", korrekturUM.map((e) => e.toString()).toList());
    print("Data - kUM in SharedPrefs"+ prefs.getStringList("korrekturUM").toString());
  }

  Future<void> updatePausenKorrektur(bool b) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("pausenKorrektur", b);
    print("Data - pausenKorrekturBool " + prefs.getBool("pausenKorrektur").toString());
  }

  Future<void> addOffset(int milliseconds) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int newValue = prefs.containsKey("OvertimeOffset")
        ? prefs.getInt("OvertimeOffset") + milliseconds
        : milliseconds;
    prefs.setInt("OvertimeOffset", newValue);

    print("Data - addOffset - OvertimeOffset " + prefs.getInt("OvertimeOffset").toString());
    getIt<HiveDB>().updateGesamtUeberstunden();
  }

  Future<int> getOffset() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Data - getOffset");
    if (prefs.containsKey("OvertimeOffset")) {
      print("Data - getOffset" + prefs.getInt("OvertimeOffset").toString());
      return prefs.getInt("OvertimeOffset");
    } else {
      return 0;
    }
  }

  Future<void> setOffset(int milliseconds) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("OvertimeOffset", milliseconds);

    print("Data - OvertimeOffset " + prefs.getInt("OvertimeOffset").toString());
    getIt<HiveDB>().updateGesamtUeberstunden();
  }

  void dispose(){
    primaryColorStream.close();
    isRunningStream.close();
    currentImageStream.close();
    backgroundHashStream.close();
  }

}