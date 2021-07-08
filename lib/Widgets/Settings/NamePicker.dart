import 'dart:math';

import 'package:Timo/Services/Theme.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class NamePicker extends StatefulWidget {
  @override
  _NamePickerState createState() => _NamePickerState();
}

class _NamePickerState extends State<NamePicker> {
  final FocusNode _focusNode = FocusNode();
  Function? _button;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller = TextEditingController(text: getIt<Data>().username);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(offset: Offset(0, 8), blurRadius: 8, color: Colors.black.withAlpha(15))],
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                "Dein Name",
                style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
              )),
              FittedBox(
                fit: BoxFit.fitWidth,
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      visualDensity: VisualDensity.compact,
                      disabledColor: Colors.transparent,
                      onPressed: null,
                    ),
                    AnimatedFittedTextFieldContainer(
                      calculator: (m) => (m.fixedWidths + max(m.labelWidth, max(m.hintWidth, m.textWidth)) * MediaQuery.textScaleFactorOf(context)),
                      growDuration: const Duration(milliseconds: 200),
                      growCurve: Curves.easeOutQuart,
                      shrinkCurve: Curves.ease,
                      child: TextField(
                        maxLength: 50,
                        cursorColor: neonAccent,
                        cursorWidth: 3,
                        cursorRadius: const Radius.circular(30),
                        enableInteractiveSelection: true,
                        enableSuggestions: false,
                        focusNode: _focusNode,
                        controller: _controller,
                        style: TextStyle(color: neon, fontSize: 28, height: 1),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(0, 3, -3, 3),
                          suffixText: " ",
                          prefixText: " ",
                          counterText: "",
                          disabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: neon.withAlpha(30), width: 100)),
                          enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(1)), borderSide: BorderSide(color: neon.withAlpha(80), width: 5)),
                          errorBorder: InputBorder.none,
                        ),
                        onEditingComplete: () {
                          setState(() {
                            _focusNode.unfocus();
                            _button = null;
                          });
                        },
                        onChanged: (String str) {
                          setState(() {
                            getIt<Data>().updateName(str);
                            _button = () {
                              _focusNode.unfocus();
                              setState(() {
                                _button = null;
                              });
                            };
                          });
                        },
                        onTap: () {
                          setState(() {
                            _button = () {
                              _focusNode.unfocus();
                              setState(() {
                                _button = null;
                              });
                            };
                          });
                        },
                      ),
                      builder: (context, child) {
                        Size _textSize(String text, TextStyle style) {
                          final TextPainter textPainter =
                              TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
                                ..layout(minWidth: 0, maxWidth: double.infinity);
                          return textPainter.size;
                        }

                        return SizedBox(width: 200, child: child);
                      },
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.check),
                      disabledColor: neon.withAlpha(80),
                      onPressed: _button as void Function()?,
                      color: neon,
                      splashRadius: 30,
                      highlightColor: neon.withAlpha(10),
                      splashColor: neon.withAlpha(70),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
