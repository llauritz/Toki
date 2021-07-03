import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/TimerTextWidget.dart';
import 'Data.dart';
import 'HiveDB.dart';
import 'Theme.dart';

class TimerText extends StatefulWidget {
  TimerText({Key? key});

  final  _TimerTextState ts = _TimerTextState();
  final Timer t = Timer.periodic(const Duration(hours: 1), (Timer timer) {});

  void start() {
    ts.timerStart();
  }

  // ignore: missing_return
  Future<void> stop() async {
    ts.timerStop();
  }

  void update() {
    ts.updateTime(t);
  }

  @override
  _TimerTextState createState() => ts;
}

class _TimerTextState extends State<TimerText> with WidgetsBindingObserver {
  int _startTime = 0;
  int _elapsedTime = 0;
  //SharedPreferences prefs;
  Timer _timer = Timer.periodic(const Duration(hours: 1), (Timer timer) {});
  StreamController<int> _timeController = StreamController<int>();

  void initSharedPreferences() async {
    SharedPreferences prefs =
        await getIt<Data>().getSharedPreferencesInstance();
    if(prefs.containsKey("startTime"))_startTime = prefs.getInt("startTime")!;
    logger.d("timer - previous startTime is " +
       _startTime.toString());
    if (_startTime != 0) {
      logger.d("timer - restored Time" + _startTime.toString());
      _timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
      updateTime(_timer);
      getIt<Data>().isRunningStream.sink.add(true);
      getIt<Data>().isRunning = true;
      getIt<HiveDB>().isRunning = true;
    }
    await getIt<HiveDB>().calculateTodayElapsedTime();
    await getIt<HiveDB>().updateGesamtUeberstunden();
    updateTime(_timer);
    logger.d("timer - init ready");
  }

  @override
  void initState() {
    // TODO: implement initState
    _timer.cancel();
    initSharedPreferences();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return StreamBuilder(
        stream: _timeController.stream,
        initialData: 200,
        builder: (context, snapshot) {
          //TODO add error exceptions
          //print("timer - building stream");
          return Center(
              child: TimerTextWidget(
                  elapsedTime: snapshot.data as int,
                  constrainedWidth: constraints.maxWidth));
        },
      );
    });
  }

  void timerStart() async {
    logger.i("timer - start");
    logger.d("timer - timer " + _timer.isActive.toString());

    _timer = Timer.periodic(const Duration(milliseconds: 200), updateTime);
    _startTime = DateTime.now().millisecondsSinceEpoch;
    getIt<Data>().isRunningStream.sink.add(true);
    SharedPreferences prefs =
        await getIt<Data>().getSharedPreferencesInstance();
    prefs.setInt("startTime", _startTime);
    logger.d("timer - started, startTime = " + _startTime.toString());

    logger.d("timer - timer " + _timer.isActive.toString());

    getIt<Data>().isRunning = true;
    getIt<HiveDB>().isRunning = true;

    getIt<HiveDB>().startTime(_startTime);
    getIt<HiveDB>().updateGesamtUeberstunden();
  }

  Future<void> timerStop() async {
    logger.i("timer - stop");
    _timer.cancel();
    getIt<Data>().isRunningStream.sink.add(false);
    SharedPreferences prefs =
        await getIt<Data>().getSharedPreferencesInstance();
    //print("timer - afterTimerCancel" + _timer.isActive.toString());
    prefs.setInt("startTime", 0);
    //print("timer - newStartTime" + getIt<Data>().prefs.getInt("startTime").toString());
    _startTime = 0;

    getIt<Data>().isRunning = false;
    getIt<HiveDB>().isRunning = false;
    getIt<HiveDB>().endTime(DateTime.now().millisecondsSinceEpoch);
    await getIt<HiveDB>().calculateTodayElapsedTime();
    await getIt<HiveDB>().updateGesamtUeberstunden();
    updateTime(_timer);
  }

  void updateTime(Timer timer) {
    //print("timer + updateTime");
    //print("timer - update Time start Time" + startTime.toString());
    //print("timer - current Time" + DateTime.now().microsecondsSinceEpoch.toString());
    if (_startTime != 0) {
      int elapsedTimeMilliseconds = getIt<HiveDB>().getTodayElapsedTime();

      //print("timer - updateTime elapsed Time "+ _elapsedTime.toString());
      //print("timer - ${Duration(milliseconds: elapsedTimeMilliseconds).inSeconds}");
      //print("timer - ${Duration(milliseconds: _elapsedTime).inSeconds}");
      logger.v(
          "${Duration(milliseconds: elapsedTimeMilliseconds).inSeconds - Duration(milliseconds: _elapsedTime).inSeconds}");

      //rebuild only if value changed at least one Second
      if (Duration(milliseconds: elapsedTimeMilliseconds).inSeconds -
              Duration(milliseconds: _elapsedTime).inSeconds !=
          0) {
        logger.v("timer - update");
        _elapsedTime = elapsedTimeMilliseconds;
        _timeController.sink.add(_elapsedTime);
        getIt<HiveDB>().calculateTodayElapsedTime();
      }
    } else {
      _timeController.sink.add(getIt<HiveDB>().todayElapsedTime);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Make sure prefs is existing
    //Make sure Timer is running

    if (state.index == 0) {
      logger.i("timer - resumed $_timer");
      updateTime(_timer);
      getIt<HiveDB>().calculateTodayElapsedTime();
      getIt<HiveDB>().urlaubsTageCheck();
      getIt<HiveDB>().checkForForgottenStop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    _timeController.close();
    getIt<Data>().isRunningStream.close();
  }
}
