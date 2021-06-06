import 'package:Timo/Services/Theme.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

class WorkingTimePicker extends StatefulWidget {
  const WorkingTimePicker({ Key? key }) : super(key: key);

  @override
  _WorkingTimePickerState createState() => _WorkingTimePickerState();
}

class _WorkingTimePickerState extends State<WorkingTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("hi"),),
    );
  }
}