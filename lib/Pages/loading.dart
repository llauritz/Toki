
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_in_progress/Services/Data.dart';

final getIt = GetIt.instance;

class Loading extends StatefulWidget {

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void getData()async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    getIt<Data>().prefs = _prefs;
    mockData();
    getIt<Data>().initData();
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    prechacheImages();
    super.didChangeDependencies();
  }

  void prechacheImages (){
    precacheImage(AssetImage("assets/background/clouds/clouds1.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds2.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds3.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds4.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds5.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds6.jpg"), context);
  }

  void mockData(){
    getIt<Data>().prefs.setString("name", "Lauritz");
    getIt<Data>().prefs.setDouble("tagesstunden", 8.0);
    getIt<Data>().prefs.setBool("MO", true);
    getIt<Data>().prefs.setBool("DI", true);
    getIt<Data>().prefs.setBool("MI", true);
    getIt<Data>().prefs.setBool("DO", true);
    getIt<Data>().prefs.setBool("FR", true);
    getIt<Data>().prefs.setBool("SA", false);
    getIt<Data>().prefs.setBool("SO", false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff0EE796),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("loading", style: TextStyle(color: Colors.white),),
            ],
          )
      ),
    );

  }
}
