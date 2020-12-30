import 'package:Timo/Services/Data.dart';
import 'package:animations/animations.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Services/HiveDB.dart';
import '../Services/Theme.dart';

class OvertimeChangeWidget extends StatefulWidget {
  const OvertimeChangeWidget({
    Key key,
  }) : super(key: key);

  final Duration duration = const Duration(milliseconds: 700);
  final Duration durationShort = const Duration(milliseconds: 400);
  final Curve curve = Curves.ease;
  final double closedContainerWidth = 0.0;
  final double openContainerWidth = 100;
  final double closedDividerPadding = 0.0;
  final double opendividerPadding = 15;


  @override
  _OvertimeChangeWidgetState createState() => _OvertimeChangeWidgetState();
}

class _OvertimeChangeWidgetState extends State<OvertimeChangeWidget> with TickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animationFade;
  final Color offsetButtonColor = Colors.blueGrey[300];

  GlobalKey hoursTextEdit = GlobalKey();
  TextEditingController hoursTextController;
  int tmpHour;
  bool updateHr = true;
  int hourSnapshotSave = 0;

  GlobalKey minutesTextEdit = GlobalKey();
  TextEditingController minutesTextController;
  int tmpMinutes;
  bool updateMin = true;
  int minutesSnapshotSave = 0;

  bool isOpen = false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
    );

    animationFade = Tween<double>(
        begin: 0, end: 1
    ).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: isOpen? const EdgeInsets.only(top:10):EdgeInsets.zero,
      duration: widget.durationShort,
      curve: widget.curve,
      child: Stack(
        children: [
          Align(
            alignment:Alignment.centerRight,
            child: PageTransitionSwitcher(
              reverse: isOpen,
              transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                  ) {
                return SharedAxisTransition(
                  child: child,
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  fillColor: Colors.transparent,
                );
              },
              child: isOpen?Container(width: 75,height: 75,):Tooltip(
                message: "Zeit bearbeiten",
                verticalOffset: 30,
                textStyle: TextStyle(color: gray),
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3))
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right:20.0),
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        print("pressed");
                        isOpen = !isOpen;
                        !isOpen ? controller.reverse(): controller.forward();
                        getIt<Data>().addOffset(1);
                        updateHr = true;
                      });
                    },
                    splashColor: neon.withAlpha(80),
                    highlightColor: neonTranslucent.withAlpha(150),
                    shape: StadiumBorder(),
                    height: 75,
                    minWidth: 75,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: neonTranslucent,
                              borderRadius: BorderRadius.circular(1000)
                          ),
                          child: Icon(Icons.edit, color: neonAccent,size: 20,)),
                    ),

                  ),
                ),
              ),
              duration: const Duration(milliseconds: 600),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedPadding(
                  duration: widget.durationShort,
                  curve: widget.curve,
                  padding: isOpen? const EdgeInsets.only(top: 30):EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        color: Colors.transparent,
                          duration: widget.durationShort,
                          curve: widget.curve,
                          width: isOpen?30:0,
                          child: FadeTransition(opacity: animationFade,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.remove_circle_rounded, color: offsetButtonColor,),
                                onPressed: (){
                                  getIt<Data>().addOffset(-Duration.millisecondsPerHour);
                                  updateHr = true;
                                  updateMin = true;
                                },

                              )
                          )
                      ),
                      StreamBuilder<int>(
                          initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                          stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                          builder: (context, snapshot) {

                            if(hourSnapshotSave != snapshot.data){
                              hourSnapshotSave = snapshot.data;
                              updateHr = true;
                            }

                            if(updateHr){
                              tmpHour = snapshot.data;
                            }

                            Color _color = tmpHour.isNegative
                                ? gray
                                : neon;
                            int stunden = (tmpHour / Duration.millisecondsPerHour).truncate();
                            int realStunden = (snapshot.data / Duration.millisecondsPerHour).truncate();

                            String addMinus = tmpHour.isNegative && stunden==0
                              ? "-" : "";

                            if(updateHr){
                              print("update");
                              String initialString =
                                  addMinus + stunden.toString();
                              hoursTextController =
                                  TextEditingController.fromValue(
                                TextEditingValue(
                                  text: initialString ?? "",
                                  selection: TextSelection.collapsed(
                                      offset: initialString?.length ?? 0),
                                ),
                              );
                              updateHr = false;
                            }

                            Widget _widget = KeyedSubtree(
                                key: stunden==0?ValueKey<Color>(_color):ValueKey<int>(realStunden),
                                child: AbsorbPointer(
                                  absorbing: !isOpen,
                                  child: AnimatedFittedTextFieldContainer(
                                    growDuration: widget.durationShort,
                                    shrinkDuration: widget.durationShort,
                                    growCurve: widget.curve,
                                    shrinkCurve: widget.curve,
                                    child: TextField(
                                      enabled: isOpen,
                                      controller: hoursTextController,
                                      style: overTimeNumbers.copyWith(color: _color),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9, -]')),
                                      ],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(0, 0, -2.5, 0)
                                      ),
                                      onChanged: (v){
                                        setState(() {
                                          tmpHour = int.parse(v)*Duration.millisecondsPerHour;
                                          print(hoursTextController.value);
                                        });
                                      },
                                      onSubmitted: (v){
                                        int newOffset = int.parse(v)-realStunden;
                                        getIt<Data>().addOffset(newOffset*Duration.millisecondsPerHour);
                                        print("newOffset $newOffset");
                                        updateHr = true;
                                      },
                                    ),
                                  ),
                                )
                            );

                            return AnimatedContainer(
                              duration: widget.duration,
                              curve: widget.curve,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isOpen?_color.withAlpha(40):_color.withAlpha(0),
                              ),
                              padding: isOpen? const EdgeInsets.symmetric(horizontal: 4, vertical: 2): EdgeInsets.zero,
                              child: AnimatedSize(
                                vsync: this,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease,
                                child: PageTransitionSwitcher(
                                  transitionBuilder: (
                                      Widget child,
                                      Animation<double> primaryAnimation,
                                      Animation<double> secondaryAnimation,
                                      ) {
                                    return SharedAxisTransition(
                                      child: child,
                                      animation: primaryAnimation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.scaled,
                                      fillColor: Colors.transparent,
                                    );
                                  },
                                  child: _widget,
                                  duration: const Duration(milliseconds: 600),
                                ),
                              ),
                            );
                          }
                      ),
                      AnimatedContainer(
                          color: Colors.transparent,
                          duration: widget.durationShort,
                          curve: widget.curve,
                          width: isOpen?30:0,
                          child: FadeTransition(opacity: animationFade,
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(Icons.add_circle_rounded, color: offsetButtonColor,),
                                onPressed: (){
                                  getIt<Data>().addOffset(Duration.millisecondsPerHour);
                                  updateHr = true;
                                  updateMin = true;
                                },

                              )
                          )
                      ),
                      AnimatedPadding(
                        curve: widget.curve,
                          duration: widget.duration,
                          padding: EdgeInsets.symmetric(
                              horizontal: isOpen
                                  ? widget.opendividerPadding
                                  : widget.closedDividerPadding),
                          child: StreamBuilder<int>(
                              initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                              stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                              builder: (context, snapshot) {

                                Color _color = snapshot.data.isNegative
                                    ? gray
                                    : neon;

                                Widget _widget = KeyedSubtree(
                                    key: ValueKey<Color>(_color),
                                    child: AnimatedOpacity(
                                      duration: widget.durationShort,
                                      curve: widget.curve,
                                      opacity: isOpen?0.2:1,
                                      child: Text(":",
                                        style: overTimeNumbers.copyWith(color: _color),
                                      ),
                                    )
                                );

                                return PageTransitionSwitcher(
                                  transitionBuilder: (
                                      Widget child,
                                      Animation<double> primaryAnimation,
                                      Animation<double> secondaryAnimation,
                                      ) {
                                    return SharedAxisTransition(
                                      child: child,
                                      animation: primaryAnimation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.scaled,
                                      fillColor: Colors.transparent,
                                    );
                                  },
                                  child: _widget,
                                  duration: const Duration(milliseconds: 600),
                                );
                              }
                          )
                      ),
                      AnimatedContainer(
                          color: Colors.transparent,
                        duration: widget.durationShort,
                        curve: widget.curve,
                        width: isOpen?30:0,
                            child: FadeTransition(opacity: animationFade,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.remove_circle_rounded, color: offsetButtonColor,),
                                  onPressed: (){
                                    getIt<HiveDB>().ueberMillisekundenGesamt.isNegative
                                        ?   getIt<Data>().addOffset(Duration.millisecondsPerMinute)
                                        :   getIt<Data>().addOffset(-Duration.millisecondsPerMinute);
                                      updateHr = true;
                                      updateMin = true;
                                  },

                                )
                            )
                      ),
                      StreamBuilder<int>(
                          initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                          stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                          builder: (context, snapshot) {

                            if(minutesSnapshotSave != snapshot.data){
                              minutesSnapshotSave = snapshot.data;
                              updateMin = true;
                            }

                            if(updateMin){
                              tmpMinutes = snapshot.data;
                            }

                            Color _color = tmpMinutes.isNegative
                                ? gray
                                : neon;
                            int minutes = ((tmpMinutes.abs() / Duration.millisecondsPerMinute)%60).truncate();
                            int realMinutes = ((snapshot.data / Duration.millisecondsPerMinute)%60).truncate();

                            int negativityFactor = snapshot.data.isNegative
                              ? -1
                              :  1  ;

                            if(updateMin){
                              print("updateMin");
                              String initialString =minutes.toString();
                              print("$initialString");
                              minutesTextController =
                                  TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: initialString ?? "",
                                      selection: TextSelection.collapsed(
                                          offset: initialString?.length ?? 0),
                                    ),
                                  );
                              updateMin = false;
                            }

                            Widget _widget = KeyedSubtree(
                                key: ValueKey<int>(Duration(milliseconds: snapshot.data).inMinutes),
                                child: AbsorbPointer(
                                  absorbing: !isOpen,
                                  child: AnimatedDefaultTextStyle(
                                    duration: Duration(milliseconds: 300),
                                    style: overTimeNumbers.copyWith(color: _color),
                                    child: AnimatedFittedTextFieldContainer(
                                    growDuration: widget.durationShort,
                                    shrinkDuration: widget.durationShort,
                                    growCurve: widget.curve,
                                    shrinkCurve: widget.curve,
                                    child: TextField(
                                      enabled: isOpen,
                                      maxLength: 2,
                                      controller: minutesTextController,
                                      style: overTimeNumbers.copyWith(color: _color),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      decoration: const InputDecoration(
                                        counterText: "",
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(0, 0, -2.5, 0)
                                      ),
                                      onChanged: (v){
                                        setState(() {
                                          tmpMinutes = int.parse(v)*Duration.millisecondsPerMinute;
                                          print(minutesTextController.value);
                                        });
                                      },
                                      onSubmitted: (v){
                                        String value = v??"0";
                                        print("realMinutes $realMinutes");
                                        int newOffset;
                                        snapshot.data.isNegative
                                          ? newOffset = 59-int.parse(value)-realMinutes.abs()
                                          : newOffset = int.parse(value)-realMinutes.abs();
                                        getIt<Data>().addOffset(newOffset*Duration.millisecondsPerMinute);
                                        print("newOffset $newOffset");
                                        updateMin = true;
                                      },
                                    ),
                                  ),
                                ))
                            );

                            return AnimatedContainer(
                              duration: widget.duration,
                              curve: widget.curve,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isOpen?_color.withAlpha(40):_color.withAlpha(0),
                              ),
                              padding: isOpen? const EdgeInsets.symmetric(horizontal: 4, vertical: 2): EdgeInsets.zero,
                              child: AnimatedSize(
                                vsync: this,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease,
                                child: PageTransitionSwitcher(
                                  transitionBuilder: (
                                      Widget child,
                                      Animation<double> primaryAnimation,
                                      Animation<double> secondaryAnimation,
                                      ) {
                                    return SharedAxisTransition(
                                      child: child,
                                      animation: primaryAnimation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.scaled,
                                      fillColor: Colors.transparent,
                                    );
                                  },
                                  child: _widget,
                                  duration: const Duration(milliseconds: 600),
                                ),
                              ),
                            );
                          }
                      ),
                      AnimatedContainer(

                          duration: widget.durationShort,
                          curve: widget.curve,
                          width: isOpen?30:0,
                          child: FadeTransition(opacity: animationFade,
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(Icons.add_circle_rounded, color: offsetButtonColor,),
                                onPressed: (){
                                  getIt<HiveDB>().ueberMillisekundenGesamt.isNegative
                                      ?   getIt<Data>().addOffset(-Duration.millisecondsPerMinute)
                                      :   getIt<Data>().addOffset(Duration.millisecondsPerMinute);
                                  updateHr = true;
                                  updateMin = true;
                                },

                              )
                          )
                      ),
                    ],),
                ),
                AnimatedPadding(
                  duration: widget.duration,
                  curve: widget.curve,
                  padding: isOpen?const EdgeInsets.symmetric(vertical: 20):EdgeInsets.zero,
                  child: AnimatedContainer(
                    duration: widget.duration,
                    curve: widget.curve,
                    height: isOpen?40:30,
                    child: PageTransitionSwitcher(
                      reverse: !isOpen,
                      transitionBuilder: (
                          Widget child,
                          Animation<double> primaryAnimation,
                          Animation<double> secondaryAnimation,
                          ) {
                        return SharedAxisTransition(
                          child: child,
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.scaled,
                          fillColor: Colors.transparent,
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<bool>(isOpen),
                          child: isOpen
                              ?Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                        color: grayTranslucent,
                                        shape: const StadiumBorder(),
                                        onPressed: (){
                                          setState(() {
                                            print("pressed");
                                            getIt<Data>().setOffset(0);
                                            updateHr = true;
                                            updateMin = true;
                                          });
                                        },
                                        child: Center(
                                            child: Row(
                                              children: [
                                                Icon(Icons.replay_rounded, color: gray, size: 20,),
                                                const SizedBox(width: 5),
                                                Text("Zurücksetzen", style: openButtonText.copyWith(color: gray, fontSize: 14),),
                                              ],
                                            ))
                                    ),
                                    const SizedBox(width: 10,),
                                    FlatButton(
                                      highlightColor: neon.withAlpha(80),
                                      splashColor: neon.withAlpha(150),
                                      color: neonTranslucent,
                                      shape: const StadiumBorder(),
                                        onPressed: (){
                                          setState(() {
                                            print("pressed");
                                            isOpen = !isOpen;
                                            !isOpen ? controller.reverse(): controller.forward();

                                            /*// 0-99
                                            int typedMinutes = int.parse(minutesTextController.text);
                                            print("tMin $typedMinutes");
                                            // 0-inf
                                            int typedHours = int.parse(hoursTextController.text);
                                            print("tHr $typedHours");
                                            // 0-inf
                                            int previousOvertimeMinutes = (getIt<HiveDB>().ueberMillisekundenGesamt/Duration.millisecondsPerMinute).truncate();

                                            int goalMinutes = typedHours*60 + typedMinutes;

                                            int newOffsetMinutes = goalMinutes - previousOvertimeMinutes;

                                            print("prevMinutes $previousOvertimeMinutes");
                                            print("goalMin $goalMinutes");

                                            getIt<Data>().addOffset(newOffsetMinutes*Duration.millisecondsPerMinute);*/

                                            updateHr = true;
                                            updateMin = true;
                                          });
                                        },
                                        child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.done, color: neonAccent, size: 20,),
                                                const SizedBox(width: 5),
                                                Text("Fertig", style: openButtonText.copyWith(color: neonAccent, fontSize: 14),),
                                              ],
                                            ))
                                        )
                                  ],
                                )
                              :SizedBox(
                                height: 30,
                                child: StreamBuilder<int>(
                                initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                                stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                                builder: (context, snapshot) {

                                  String text = snapshot.data.isNegative
                                      ? "Stunden"
                                      : "Überstunden";

                                  Widget _widget = KeyedSubtree(
                                      key: ValueKey<String>(text),
                                      child: Text(text,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.blueGrey[300]),
                                      )
                                  );

                                  return PageTransitionSwitcher(
                                    reverse: text == "Stunden",
                                    transitionBuilder: (
                                        Widget child,
                                        Animation<double> primaryAnimation,
                                        Animation<double> secondaryAnimation,
                                        ) {
                                      return SharedAxisTransition(
                                        child: child,
                                        animation: primaryAnimation,
                                        secondaryAnimation: secondaryAnimation,
                                        transitionType: SharedAxisTransitionType.vertical,
                                        fillColor: Colors.transparent,
                                      );
                                    },
                                    child: _widget,
                                    duration: const Duration(milliseconds: 600),
                                  );
                                }
                          ),
                              ),
                      ),
                      duration: const Duration(milliseconds: 600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FadeTransition(opacity: animationFade,
                child: Text("Zeit bearbeiten", style: TextStyle(
                    color: gray,
                    fontSize: 16
                ),)
            ),
          )
        ],
      ),
    );
  }
}