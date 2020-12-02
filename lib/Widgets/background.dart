import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Services/Data.dart';

final getIt = GetIt.instance;



class Background extends StatefulWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}


class _BackgroundState extends State<Background> with WidgetsBindingObserver{

  AssetImage currentImage;
  AssetImage previousImage;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state.index == 0){
      print("background - resumed");
      updateBackground();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("background - init start 2");
    previousImage = currentBackground();
    updateBackground();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("background - init finished");
  }

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
      fadeInDuration: Duration(milliseconds: 1000),
        placeholder: previousImage,
        image: currentImage);
  }

  AssetImage currentBackground(){
    int hourNow = DateTime.now().hour;
    int minuteNow = DateTime.now().minute;

    double currentTime = hourNow + minuteNow/100;
    // example: 16:35 -> 16.35

    if(currentTime <= 6.59 || currentTime >= 20){
      return AssetImage("assets/background/clouds/clouds1.jpg");
    }else if(currentTime >= 7.00 && currentTime < 8.00){
      return AssetImage("assets/background/clouds/clouds2.jpg");
    }else if(currentTime >= 8.00 && currentTime < 11.00){
      return AssetImage("assets/background/clouds/clouds3.jpg");
    }else if(currentTime >= 11.00 && currentTime < 15.30){
      return AssetImage("assets/background/clouds/clouds4.jpg");
    }else if(currentTime >= 15.30 && currentTime < 17.30){
      return AssetImage("assets/background/clouds/clouds5.jpg");
    }else if(currentTime >= 17.30 && currentTime < 20.00){
      return AssetImage("assets/background/clouds/clouds6.jpg");
    }
      return AssetImage("assets/background/clouds/clouds3.jpg");
  }

  void updateBackground(){
    setState(() {
/*      if(previousImage==null){
        print("background - pref null");
        previousImage = currentBackground();
      }*/
      currentImage = currentBackground();
    });
    previousImage = currentImage;
    getIt<Data>().updatePrimaryColor(currentImage);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}