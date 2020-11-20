
import 'package:flutter/material.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getIt<Data>().prefs = prefs;
    print("loading - getIt prefs = " + getIt<Data>().prefs.toString());

    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  void initState() {
    super.initState();
    print("loading");
    getData();
    prechacheImages();
  }

  void prechacheImages (){
    precacheImage(AssetImage("assets/background/clouds/clouds1.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds2.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds3.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds4.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds5.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds6.jpg"), context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0x0EE796FF)),
      ),
    );


  }
}
