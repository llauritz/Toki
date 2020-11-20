import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:work_in_progress/Pages/home.dart';
import 'Pages/Onboarding/onboarding_1.dart';
import 'Pages/loading.dart';
import 'Services/Data.dart';

GetIt getIt = GetIt.instance;

void main() {

  getIt.registerSingleton<Data>(Data());

  runApp(MaterialApp(
    routes: {
      "/": (context) => Loading(),
      "/home": (context) => homePage(),
      "/onboarding": (context) => Onboarding_1(),
    },
    theme: ThemeData(
      backgroundColor: Colors.indigoAccent[700],
        fontFamily: "BandeinsSans",
        textTheme: TextTheme(

            headline1: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),

            headline2: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),

            button: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold)

        )),
  ));
}
