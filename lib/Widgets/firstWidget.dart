import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'OvertimeChangeWidget.dart';

final getIt = GetIt.instance;

class FirstWidget extends StatefulWidget {
  const FirstWidget({required this.panelController});

  final PanelController panelController;

  @override
  _FirstWidgetState createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.tealAccent.withAlpha(100),
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        widget.panelController.open();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 27.0, 0, 20),
            child: SizedBox(
                height: 8,
                width: 50,
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(100)),
                ))),
          ),
          const OvertimeChangeWidget(),

          /*Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: StreamBuilder<int>(
                    initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                    stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                    builder: (context, snapshot) {

                      Widget _widget = KeyedSubtree(
                          key: ValueKey<int>(snapshot.data),
                          child: UeberstundenTextWidget(
                              ueberMilliseconds: snapshot.data));

                      String text = snapshot.data.isNegative?"Stunden":"Überstunden";
                      Widget _textWidget = KeyedSubtree(
                          key: ValueKey<String>(text),
                          child: Text(
                            text,
                            style: TextStyle(
                                fontSize: 20, color: Colors.blueGrey[300]),
                          ));

                      return AnimatedAlign(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.ease,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PageTransitionSwitcher(
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
                              PageTransitionSwitcher(
                                reverse:text =="Stunden",
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
                                child: _textWidget,
                                duration: const Duration(milliseconds: 600),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )*/
        ],
      ),
    );
  }
}
