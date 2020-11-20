

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/TimerTextWidget.dart';
import 'package:get_it/get_it.dart';
import 'Data.dart';

final getIt = GetIt.instance;

class TimerText extends StatefulWidget {
  final _TimerTextState ts = _TimerTextState();
  @override

  final Timer t = Timer.periodic(Duration(hours: 1), (timer) {});

  void start(){
    ts.timerStart();
  }

  void stop(){
    ts.timerStop();
  }

  void update(){
    ts.updateTime(t);
  }

  _TimerTextState createState() => ts;
}

class _TimerTextState extends State<TimerText> with WidgetsBindingObserver{

  int _startTime = 0;
  int _elapsedTime = 0;
  SharedPreferences prefs;
  Timer _timer = Timer.periodic(Duration(hours: 1), (timer) {});
  final _timeController = StreamController<int>();
  AppLifecycleState _appLifecycleState;

  void initSharedPreferences()async{
    _startTime = getIt<Data>().prefs.getInt("startTime");
    print(getIt<Data>().prefs.getInt("startTime").toString());
    if(_startTime == null) {
      _startTime = 0;
      getIt<Data>().prefs.setInt("startTime", 0);
    }else if(_startTime!=0){
      print("timer - restored Time" + _startTime.toString());
      _timer = Timer.periodic(Duration(seconds: 1), updateTime);
      updateTime(_timer);
      getIt<Data>().isRunningStream.sink.add(true);
    }
    print("timer - init ready");
  }

  @override
  void initState(){
    // TODO: implement initState
    _timer.cancel();
    initSharedPreferences();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _timeController.stream,
      initialData: 200,
      builder: (context, snapshot){
        //TODO add error exceptions
        //print("timer - building stream");
        return Center(child: TimerTextWidget(elapsedTime: snapshot.data));
      },
    );
  }

  void timerStart(){
    print("timer - start");
    print("timer - timer " + _timer.isActive.toString());
    if(_timer.isActive == false){
      _timer = Timer.periodic(Duration(seconds: 1), updateTime);
      _startTime = DateTime.now().microsecondsSinceEpoch;
      getIt<Data>().prefs.setInt("startTime", _startTime);
      print("timer - started, startTime = " + _startTime.toString());
    }
    getIt<Data>().isRunningStream.sink.add(true);
  }

  void timerStop() async{
    //print("timer - stop");
    _timer.cancel();
    //print("timer - afterTimerCancel" + _timer.isActive.toString());
    getIt<Data>().prefs.setInt("startTime", 0);
    //print("timer - newStartTime" + getIt<Data>().prefs.getInt("startTime").toString());
    _startTime = 0;
    updateTime(_timer);
    getIt<Data>().isRunningStream.sink.add(false);
  }

  void updateTime(Timer timer){
    //print("timer + updateTime");
    //print("timer - update Time start Time" + startTime.toString());
    //print("timer - current Time" + DateTime.now().microsecondsSinceEpoch.toString());
    if(_startTime != 0) {
        int elapsedTimeMilliseconds = DateTime
            .now()
            .microsecondsSinceEpoch - _startTime;
        _elapsedTime = elapsedTimeMilliseconds;
        //print("timer - updateTime elapsed Time "+ _elapsedTime.toString());
        _timeController.sink.add(_elapsedTime);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state.index == 0){
      print("timer - resumed");
      updateTime(_timer);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _timeController.close();
    getIt<Data>().isRunningStream.close();
  }
}