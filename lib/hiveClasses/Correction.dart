import 'package:hive/hive.dart';

import '../Services/Data.dart';
import '../Services/Theme.dart';

part 'Correction.g.dart';

@HiveType(typeId: 2)
class Correction {
  Correction({required this.ab, required this.um});

  @HiveField(0)
  //in Milliseconds
  int ab;

  @HiveField(1)
  //in Milliseconds
  int um;
}


