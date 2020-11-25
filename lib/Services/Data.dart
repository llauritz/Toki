import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Data{
  SharedPreferences prefs;
  final isRunningStream = StreamController<bool>();
  String username;
  double tagesstunden;
  List<bool> wochentage;

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

}