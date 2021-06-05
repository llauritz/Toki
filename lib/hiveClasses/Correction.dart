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

// void insertionSort(Box<Correction> box) {
//   if (box.length == 0) return;
//   int n = box.length;
//   int temp, i, j;

//   for (i = 1; i < n; i++) {
//     temp = list[i];
//     j = i - 1;
//     while (j >= 0 && temp < list[j]) {
//       list[j + 1] = list[j];
//       --j;
//     }
//     list[j + 1] = temp;
//   }
// }
