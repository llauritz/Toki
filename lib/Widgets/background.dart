import 'package:flutter/material.dart';




class Background extends StatefulWidget {
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _BackgroundState createState() => _BackgroundState();
}


class _BackgroundState extends State<Background> with WidgetsBindingObserver{

  Widget _backgroundImageContainer;
  Widget _oldBackgroundImageContainer;

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
    print("background - init start");
    updateBackground();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("background - init finished");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _oldBackgroundImageContainer,
        AnimatedSwitcher(
          transitionBuilder:(Widget child, Animation<double> animation){

            return FadeTransition(opacity: animation,child: child, );
          },

          /*switchInCurve: Curves.ease,
          switchOutCurve: Curves.easeOutExpo,*/
          switchInCurve: Curves.fastOutSlowIn,

          child: _backgroundImageContainer,
          duration: const Duration(milliseconds: 1000),
        ),
        widget.child,
      ],
    );
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
      Widget newImageContainer = Container(
        key: ValueKey<int>(getKeyInt()),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: currentBackground(), fit: BoxFit.cover
            )
        ),
      );
      _oldBackgroundImageContainer = newImageContainer;
      _backgroundImageContainer = newImageContainer;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int getKeyInt(){
    int hourNow = DateTime.now().hour;
    int minuteNow = DateTime.now().minute;

    double currentTime = hourNow + minuteNow/100;
    // example: 16:35 -> 16.35

    if(currentTime <= 6.59 || currentTime >= 20){
      return 1;
    }else if(currentTime >= 7.00 && currentTime < 8.00){
      return 2;
    }else if(currentTime >= 8.00 && currentTime < 11.00){
      return 3;
    }else if(currentTime >= 11.00 && currentTime < 15.30){
      return 4;
    }else if(currentTime >= 15.30 && currentTime < 17.30){
      return 5;
    }else if(currentTime >= 17.30 && currentTime < 20.00){
      return 6;
    }
    return 7;
  }

}