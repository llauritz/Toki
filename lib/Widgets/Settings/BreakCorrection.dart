import 'dart:ui';

import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Transitions/SizeScaleFadeTransition.dart';
import 'package:Timo/hiveClasses/Correction.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import '../../Services/Data.dart';
import 'CorrectionTile.dart';

final GlobalKey impicitListKey = GlobalKey();

class BreakCorrection extends StatefulWidget {
  const BreakCorrection({Key? key}) : super(key: key);

  @override
  _BreakCorrectionState createState() => _BreakCorrectionState();
}

class _BreakCorrectionState extends State<BreakCorrection> {
  bool active = true;
  Box<Correction> correctionBox = Hive.box("corrections");
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Correction> boxToList(Box box) {
    return List<Correction>.generate(box.length, (index) => box.getAt(index));
  }

  @override
  Widget build(BuildContext context) {
    active = getIt<Data>().pausenKorrektur;
    //logger.w(boxToList(correctionBox).length);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          shadowColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () {
                        showModal(
                            configuration: FadeScaleTransitionConfiguration(
                                transitionDuration: Duration(milliseconds: 300), reverseTransitionDuration: Duration(milliseconds: 100)),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Automatische Pausenkorrektur"),
                                titleTextStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
                                content: Text(
                                    """Sobald deine Arbeitszeit die Stundenzahl "Ab" überschreitet, wird deine Pausenzeit automatisch auf den Wert "Mindestens" erhöht. Wenn du mehr Pause gemacht hast, passiert nichts."""),
                                contentTextStyle: TextStyle(fontWeight: FontWeight.bold, color: grayAccent),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Okay"))
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                "Pausenkorrektur",
                                style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
                              ),
                              Positioned(
                                  right: -20,
                                  top: -5,
                                  child: Icon(
                                    Icons.help_rounded,
                                    size: 17,
                                    color: Colors.black.withAlpha(150),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: -13,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Switch(
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            activeColor: neon,
                            activeTrackColor: neon.withAlpha(100),
                            value: getIt<Data>().pausenKorrektur,
                            onChanged: (newValue) {
                              setState(() {
                                getIt<Data>().updatePausenKorrektur(newValue);
                                getIt<Data>().pausenKorrektur = newValue;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: active ? 1 : 0.4,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: AbsorbPointer(
                    absorbing: !active,
                    child: StreamBuilder(
                        stream: correctionBox.watch(),
                        builder: (context, snapshot) {
                          return ImplicitlyAnimatedList(
                            insertDuration: Duration(milliseconds: 350),
                            removeDuration: Duration(milliseconds: 400),
                            updateDuration: Duration(milliseconds: 400),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            key: impicitListKey,
                            itemBuilder: (context, animation, Correction correction, index) {
                              return SizeScaleFadeTransition(
                                animation: animation,
                                child: CorrectionTile(
                                  index: index,
                                  correction: correction,
                                  closeCallback: () {
                                    getIt<CorrectionDB>().deleteCorrection(index);
                                  },
                                ),
                              );
                            },
                            removeItemBuilder: (context, animation, Correction correction) {
                              return SizeFadeTransition(
                                sizeFraction: 0.75,
                                curve: Curves.easeInOutCubic,
                                animation: animation,
                                child: CorrectionTile(
                                  index: 0,
                                  correction: correction,
                                  closeCallback: () {},
                                ),
                              );
                            },
                            updateItemBuilder: (context, animation, Correction correction) {
                              return SizeFadeTransition(
                                sizeFraction: 0.75,
                                curve: Curves.easeInOutCubic,
                                animation: animation,
                                child: CorrectionTile(
                                  index: 0,
                                  correction: correction,
                                  closeCallback: () {},
                                ),
                              );
                            },
                            areItemsTheSame: (Correction oldItem, Correction newItem) {
                              return oldItem.ab == newItem.ab;
                            },
                            items: boxToList(correctionBox),
                          );
                        }),
                  ),
                ),
                AnimatedOpacity(
                  opacity: active ? 1 : 0.4,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: AbsorbPointer(
                    absorbing: !active,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: () async {
                              Box box = Hive.box<Correction>("corrections");
                              box.isNotEmpty
                                  ? await box.add(Correction(
                                      ab: box.getAt(box.length - 1)!.ab + Duration.millisecondsPerHour,
                                      um: box.getAt(box.length - 1)!.um + 10 * Duration.millisecondsPerMinute))
                                  : await box.add(Correction(ab: 6 * Duration.millisecondsPerHour, um: 30 * Duration.millisecondsPerMinute));
                              setState(() {
                                // _listKey.currentState!
                                //     .insertItem(correctionBox.length - 1);
                              });
                            },
                            shape: const StadiumBorder(),
                            color: grayTranslucent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 3),
                                  Text(
                                    "Regel hinzufügen",
                                    style: openButtonText.copyWith(color: grayAccent),
                                  ),
                                  const SizedBox(width: 1),
                                  Icon(
                                    Icons.add_rounded,
                                    color: grayAccent,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
