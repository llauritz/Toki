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
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                "Dein Name",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontSize: 18),
              )),
              /*
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      style: settingsBody,
                      cursorColor: neon,
                      cursorRadius: const Radius.circular(20),
                      cursorWidth: 3,
                      enableSuggestions: false,
                      initialValue: getIt<Data>().username,
                      focusNode: _focusNode,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: neon.withAlpha(250), fontSize: 24.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide:
                                BorderSide(color: neon.withAlpha(50), width: 4)),
                        focusedBorder: const UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            borderSide: BorderSide(color: neon, width: 5)),
                      ),
                      onEditingComplete: () {
                        setState(() {
                          _focusNode.unfocus();
                          _button = null;
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      disabledColor: neon.withAlpha(80),
                      onPressed: _button as void Function()?,
                      color: neon,
                      splashRadius: 30,
                      highlightColor: neon.withAlpha(80),
                      splashColor: neon.withAlpha(150),
                    ),
                  )
                ],
              ),*/
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      visualDensity: VisualDensity.compact,
                      color: Colors.transparent,
                      onPressed: () {},
                    ),
                    AnimatedFittedTextFieldContainer(
                        growDuration: const Duration(milliseconds: 200),
                        growCurve: Curves.easeOutQuart,
                        shrinkCurve: Curves.ease,
                        child: TextField(
                          maxLength: 50,
                          cursorColor: neonAccent,
                          cursorWidth: 3,
                          cursorRadius: const Radius.circular(20),
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          focusNode: _focusNode,
                          controller: _controller,
                          style: TextStyle(
                            color: neon,
                            fontSize: 28,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            prefixText: "",
                            counterText: "",
                            disabledBorder: InputBorder.none,
                            border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(1),
                                borderSide: BorderSide(
                                    color: neon.withAlpha(50), width: 4)),
                            enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(1),
                                borderSide: BorderSide(
                                    color: neon.withAlpha(50), width: 4)),
                            focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(1),
                                borderSide: BorderSide(
                                    color: neon.withAlpha(150), width: 4)),
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
                        )),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.check),
                      disabledColor: neon.withAlpha(80),
                      onPressed: _button as void Function()?,
                      color: neon,
                      splashRadius: 30,
                      highlightColor: neon.withAlpha(30),
                      splashColor: neon.withAlpha(100),
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
