import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/HiveDB.dart';
import '../../hiveClasses/Zeitnahme.dart';
import 'DefaultCardOpen/DefaultCardOpen.dart';
import 'EditedCardOpen.dart';
import 'EmptyCardOpen.dart';
import 'FreeCardOpen.dart';

final getIt = GetIt.instance;

class OpenCard extends StatefulWidget {

  OpenCard({
    @required this.state,
    @required this.i,
    @required this.index,
    @required this.zeitnahme
  });

  final String state;

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _OpenCardState createState() => _OpenCardState();
}

class _OpenCardState extends State<OpenCard> {
  @override
  Widget build(BuildContext context) {
    Widget _widget;

    switch (widget.zeitnahme.state) {
      case "default":
        {
          _widget = DefaultCardOpen(
              i: widget.i,
              index: widget.index,
              zeitnahme:widget.zeitnahme,
              callback: (){
                setState(() {
                });
              }
          );
          break;
        }

      case "free":
        {
          _widget = FreeCardOpen(
              i:widget.i,
              index:widget.index,
              zeitnahme: widget.zeitnahme,
              callback: (){
                setState(() {
                });
              }
          );
          break;
        }

      case "edited":
        {
          _widget = EditedCardOpen(
              i:widget.i,
              index:widget.index,
              zeitnahme: widget.zeitnahme,
              callback: (){
                setState(() {
                });
              }
          );
          break;
        }

      case "empty":
        {
          _widget = EmptyCardOpen(
              i:widget.i,
              index:widget.index,
              zeitnahme: widget.zeitnahme,
              callback: (){
                setState(() {
                });
              }
          );
          break;
        }

      default:
        {
          _widget = Center(child: Text("error"));
        }
    }

    return StreamBuilder<int>(
      stream: getIt<HiveDB>().listChangesStream.stream,
      builder: (context, snapshot) {
        return PageTransitionSwitcher(
          reverse: widget.zeitnahme.state == "empty",
          transitionBuilder: (
              Widget child,
              Animation<double>
              primaryAnimation,
              Animation<double>
              secondaryAnimation,
              ) {
            return SharedAxisTransition(
              child: child,
              animation:
              primaryAnimation,
              secondaryAnimation:
              secondaryAnimation,
              transitionType:
              SharedAxisTransitionType
                  .scaled,
              fillColor: Colors
                  .transparent,
            );
          },
          child: _widget,
          duration: const Duration(
              milliseconds: 600),
        );
      }
    );
  }
}
