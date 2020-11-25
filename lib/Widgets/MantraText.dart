import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Services/Data.dart';

GetIt getIt = GetIt.instance;

class MantraText extends StatelessWidget {
  const MantraText({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    String name = getIt<Data>().username;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Text(
        "Guten Morgen, $name",
        //style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}