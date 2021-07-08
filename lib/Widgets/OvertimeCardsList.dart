import 'dart:io';
import 'dart:math';

import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Transitions/SizeScaleFadeTransition.dart';
import 'package:Timo/Widgets/OvertimeCards/SickCardClosed.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Services/Data.dart';
import '../Services/HiveDB.dart';
import '../Widgets/OvertimeCards/EmptyCardClosed.dart';
import '../hiveClasses/Zeitnahme.dart';
import 'OvertimeCards/DefaultCardClosed.dart';
import 'OvertimeCards/EditedCardClosed.dart';
import 'OvertimeCards/FirstCardClosed.dart';
import 'OvertimeCards/FreeCardClosed.dart';
import 'OvertimeCards/OpenCard.dart';
import 'firstWidget.dart';

final getIt = GetIt.instance;

class ZeitenPanel extends StatefulWidget {
  const ZeitenPanel({
    Key? key,
    required this.updateTimer,
    required this.panelController,
  }) : super(key: key);

  final PanelController panelController;
  final Function updateTimer;

  @override
  _ZeitenPanelState createState() => _ZeitenPanelState();
}

class _ZeitenPanelState extends State<ZeitenPanel> {
  //Tween<Size> _size = Tween(begin: Offset(0,-1), end: Offset(0,0));
  Box<Zeitnahme> box = Hive.box("zeitenBox");

  @override
  Widget build(BuildContext context) {
    //logger.d("OvertimeCardsList build - 1");

    return Card(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).backgroundColor,
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FirstWidget(panelController: widget.panelController),
          Flexible(
            child: StreamBuilder(
              stream: box.watch(),
              builder: (context, snapshot) {
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0, -0.9),
                      colors: <Color>[
                        Theme.of(context).backgroundColor.withAlpha(0),
                        Theme.of(context).backgroundColor,
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstATop,
                  child: ListContent(widget: widget, box: box),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListContent extends StatelessWidget {
  const ListContent({
    Key? key,
    required this.box,
    required this.widget,
  }) : super(key: key);

  final ZeitenPanel widget;
  final Box box;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        physics: BouncingScrollPhysics(),
        initialItemCount: box.length,
        key: getIt<HiveDB>().animatedListkey,
        padding: EdgeInsets.only(top: 20.0),
        itemBuilder: (context, index, animation) {
          //logger.d("OvertimeCardsList build - 3");

          //Liste wird umgekehrt
          int i = box.length - index - 1;
          Zeitnahme _zeitnahme = box.getAt(i);
          String _state = _zeitnahme.state;

          if (Hive.box<Zeitnahme>("zeitenBox").length == 0) return Container();

          return Container(
            color: Theme.of(context).backgroundColor,
            child: Dismissible(
                key: ValueKey<int>(i),
                onDismissed: (direction) async {
                  logger.d("i: " + i.toString());
                  logger.d("index: " + i.toString());

                  if (index == 0) {
                    await getIt<Data>().timerText.stop();
                    logger.d("timer gestoppt");
                  }

                  Zeitnahme _deleted = await box.getAt(i);
                  getIt<HiveDB>().deleteAT(i, index);

                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 5000),
                      content: Text("Tag gelöscht"),
                      action: SnackBarAction(
                        label: "Rückgängig",
                        onPressed: () {
                          getIt<HiveDB>().putAT(i, _deleted, index);
                        },
                      ),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red[400],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizeScaleFadeTransition(
                    animation: animation,
                    child: OpenContainer(
                      closedElevation: 0.0,
                      openElevation: 10.0,
                      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
                      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      transitionDuration: Duration(milliseconds: 500),
                      transitionType: ContainerTransitionType.fade,
                      openColor: Theme.of(context).cardColor,
                      closedColor: Theme.of(context).backgroundColor,
                      closedBuilder: (BuildContext context, void Function() action) {
                        //logger.d("OvertimeCardsList build - 4");

                        Widget _widget;

                        if (index == 0 && _state == "default") {
                          _widget = KeyedSubtree(
                            key: ValueKey<int>(1),
                            child: StreamBuilder<bool>(
                                stream: getIt<Data>().isRunningStream.stream,
                                initialData: getIt<Data>().isRunning,
                                builder: (context, snapshot) {
                                  return FirstCardClosed(i: i, index: index, zeitnahme: _zeitnahme, isRunning: snapshot.data!);
                                }),
                          );
                        } else {
                          switch (_state) {
                            case "default":
                              {
                                _widget = KeyedSubtree(
                                    key: ValueKey<int>(1), child: Center(child: DefaultCardClosed(i: i, index: index, zeitnahme: _zeitnahme)));
                                break;
                              }

                            case "free":
                              {
                                _widget = FreeCardClosed(i: i, index: index, zeitnahme: _zeitnahme);
                                break;
                              }

                            case "sickDay":
                              {
                                _widget = SickCardClosed(i: i, index: index, zeitnahme: _zeitnahme);
                                break;
                              }

                            case "empty":
                              {
                                _widget = EmptyCardClosed(i: i, index: index, zeitnahme: _zeitnahme, openCard: action);
                                break;
                              }

                            case "edited":
                              {
                                _widget = EditedCardClosedStl(i: i, index: index, zeitnahme: _zeitnahme);
                                break;
                              }

                            default:
                              {
                                _widget = Center(child: Text("error"));
                              }
                          }
                        }

                        return Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              height: 80,
                              child: PageTransitionSwitcher(
                                reverse: _state == "free" || _state == "edited" || _state == "sickDay",
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> primaryAnimation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return SharedAxisTransition(
                                    child: child,
                                    animation: primaryAnimation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType: SharedAxisTransitionType.horizontal,
                                    fillColor: Colors.transparent,
                                  );
                                },
                                child: _widget,
                                duration: const Duration(milliseconds: 600),
                              ),
                            ),
                          ),
                        );
                      },
                      openBuilder: (context, openContainer) {
                        MediaQuery.of(context).removePadding();
                        return OpenCard(
                          state: _state,
                          index: index,
                          i: i,
                          zeitnahme: _zeitnahme,
                        );
                      },
                      onClosed: (dynamic o) async {
                        getIt<HiveDB>().updateGesamtUeberstunden();
                        await getIt<HiveDB>().calculateTodayElapsedTime();
                        widget.updateTimer();
                      },
                    ),
                  ),
                )),
          );
        });
  }
}
