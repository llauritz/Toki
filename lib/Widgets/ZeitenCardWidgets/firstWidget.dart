import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:work_in_progress/Widgets/ZeitenCardWidgets/UeberstundenTextWidget.dart';

import '../../Services/HiveDB.dart';

final getIt = GetIt.instance;

class FirstWidget extends StatefulWidget {
  FirstWidget({@required this.panelController});

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
      highlightColor: Colors.transparent,
      onTap: () {
        widget.panelController.open();
      },
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24.0, 0, 10),
              child: SizedBox(
                  height: 10,
                  width: 60,
                  child: Center(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(100)),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: StreamBuilder<int>(
                  initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                  stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                  builder: (context, snapshot) {
                    i == 0 ? i = 1 : i = 0;

                    Widget _widget = KeyedSubtree(
                        key: ValueKey<int>(i),
                        child: UeberstundenTextWidget(
                            ueberMilliseconds: snapshot.data));

                    print("firstWidget key" + i.toString());

                    return Column(
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
                        Text(
                          "Überstunden",
                          style: TextStyle(
                              fontSize: 20, color: Colors.blueGrey[300]),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
