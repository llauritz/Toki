import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Data{
  SharedPreferences prefs;
  final isRunningStream = StreamController<bool>();

  Future<void> initSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
    print("Data - SharedPreferences initiated "+ prefs.toString());
  }
}