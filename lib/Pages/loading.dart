import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_in_progress/Services/Data.dart';

final getIt = GetIt.instance;

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getData() async {
    await Hive.initFlutter();
    //mockData();
    await getIt<Data>().initData();

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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /*CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white)
                ,
              ),*/
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text("loading", style: TextStyle(color: Colors.white),),
              ),
            ],
          )
      ),
    );
  }
}
