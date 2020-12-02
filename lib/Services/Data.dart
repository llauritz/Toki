import 'dart:async';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data{
  SharedPreferences prefs;
  final isRunningStream = StreamController<bool>();
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

  Future<void> initSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
    print("Data - SharedPreferences initiated "+ prefs.toString());
  }

  void initData(){
    if(prefs!=null){
      username = prefs.getString("name");
      tagesstunden = prefs.getDouble("tagesstunden");
      wochentage = [
        prefs.getBool("MO"),
        prefs.getBool("DI"),
        prefs.getBool("MI"),
        prefs.getBool("DO"),
        prefs.getBool("FR"),
        prefs.getBool("SA"),
        prefs.getBool("SO"),
      ];
      updatePausenKorrektur(true);
      pausenKorrektur = prefs.get("pausenKorrektur");
      prefs.setStringList("korrekturAB", korrekturAB.map((e) => e.toString()).toList());
      //converts List of Strings to List of Integers and stores them in local List
      korrekturAB = prefs.getStringList("korrekturAB").map(int.parse).toList();
      print("Data - kAB in local List"+ korrekturAB.toString());
      //korrekturUM = prefs.getStringList("korrekturUM").cast<int>();
      print("Data - Data initialized");
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

  Future<void> updatePrimaryColor(AssetImage image)async{
    currentImageStream.sink.add(image);
    currentImage = image;
    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(image);
    primaryColor = paletteGenerator.dominantColor.color;
    print(primaryColor.toString());
    primaryColorStream.sink.add(primaryColor);
  }

  void updateTagesstunden(double newTagesstunden) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("tagesstunden", newTagesstunden);
    tagesstunden = newTagesstunden;
    print("Data - updated Tagesstunden: " + prefs.getDouble("tagesstunden").toString());
  }

  void updateName(String newName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", newName);
    username = newName;
    print("Data - updated Username: " + prefs.getString("name").toString());
  }

  Future<void> updateWochentage(List<bool> _selections) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Mo", _selections[0]);
    prefs.setBool("Di", _selections[1]);
    prefs.setBool("Mi", _selections[2]);
    prefs.setBool("Do", _selections[3]);
    prefs.setBool("Fr", _selections[4]);
    prefs.setBool("Sa", _selections[5]);
    prefs.setBool("So", _selections[6]);
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


  void dispose(){
    primaryColorStream.close();
    isRunningStream.close();
    currentImageStream.close();
  }

}