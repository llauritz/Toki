import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:Timo/hiveClasses/Correction.dart';
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
    logger.w(boxToList(correctionBox).length);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          shadowColor: Colors.black26,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AnimatedOpacity(
                                opacity: active ? 1 : 0.2,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                                child: Text(
                                  "Pausenkorrektur",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(fontSize: 18),
                                ),
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
                        Positioned(
                          right: 0,
                          top: -13,
                          child: Switch(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
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
                      ],
                    ),
                    // AnimatedList(
                    //     padding: EdgeInsets.only(top: 25),
                    //     physics: BouncingScrollPhysics(),
                    //     shrinkWrap: true,
                    //     key: _listKey,
                    //     initialItemCount: correctionBox.length,
                    //     itemBuilder: (BuildContext context, int index,
                    //         Animation<double> animation) {
                    //       return SizeTransition(
                    //         sizeFactor: CurvedAnimation(
                    //             parent: animation, curve: Curves.ease),
                    //         child: CorrectionTile(
                    //           correction: correctionBox.getAt(index)!,
                    //           listKey: _listKey,
                    //           index: index,
                    //         ),
                    //       );
                    //     }),

                    StreamBuilder(
                        stream: correctionBox.watch(),
                        builder: (context, snapshot) {
                          return ImplicitlyAnimatedList(
                            insertDuration: Duration(milliseconds: 400),
                            removeDuration: Duration(milliseconds: 300),
                            updateDuration: Duration(milliseconds: 500),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            key: impicitListKey,
                            itemBuilder: (context, animation,
                                Correction correction, index) {
                              return SizeTransition(
                                axisAlignment: -1.0,
                                sizeFactor: CurvedAnimation(
                                    parent: animation, curve: Curves.ease),
                                child: FadeTransition(
                                  opacity: CurvedAnimation(
                                      parent: animation, curve: Curves.ease),
                                  child: CorrectionTile(
                                    index: index,
                                    correction: correction,
                                    closeCallback: () {
                                      getIt<CorrectionDB>()
                                          .deleteCorrection(index);
                                    },
                                  ),
                                ),
                              );
                            },
                            removeItemBuilder:
                                (context, animation, Correction correction) {
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
                            areItemsTheSame:
                                (Correction oldItem, Correction newItem) {
                              return oldItem.ab == newItem.ab;
                            },
                            items: boxToList(correctionBox),
                          );
                        }),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              setState(() async {
                                await getIt<CorrectionDB>().resetBox();
                                //_listKey.currentState!.insertItem(0);
                              });
                            },
                            icon: Icon(Icons.ac_unit)),
                        IconButton(
                            onPressed: () async {
                              Box box = Hive.box<Correction>("corrections");
                              await box.add(Correction(
                                  ab: box.getAt(box.length - 1)!.ab +
                                      Duration.millisecondsPerHour,
                                  um: box.getAt(box.length - 1)!.um +
                                      10 * Duration.millisecondsPerMinute));
                              setState(() {
                                // _listKey.currentState!
                                //     .insertItem(correctionBox.length - 1);
                              });
                            },
                            icon: Icon(Icons.help)),
                        IconButton(
                            onPressed: () async {
                              setState(() async {
                                //_listKey.currentState!.insertItem(0);
                              });
                            },
                            icon: Icon(Icons.ac_unit)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
