import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:Timo/Services/Data.dart';
import 'package:Timo/Services/HiveDB.dart';
import 'package:Timo/hiveClasses/Zeitnahme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

final getIt = GetIt.instance;

Future<void> pdfExport() async {
  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");
  DateFormat uhrzeit = DateFormat("H:mm");
  print("pdfExport");
  final pdf = pw.Document();

  final ByteData fontByte = (await rootBundle.load("assets/fonts/BandeinsSansBold.ttf"));
  final bandeins = pw.Font.ttf(fontByte);

  final ByteData boldByte = (await rootBundle.load("assets/fonts/RobotoMono-SemiBold.ttf"));
  final robot = pw.Font.ttf(boldByte);
  final ByteData iconByte = (await rootBundle.load("assets/fonts/MaterialIcons-Regular.ttf"));
  final icons = pw.Font.ttf(iconByte);

  List<List<Zeitnahme>> monthList = await getIt<HiveDB>().getMonthLists();

  pw.TextStyle textStyle = pw.TextStyle(fontSize: 8, font: bandeins, fontWeight: pw.FontWeight.bold);

  double spacing = 5;

  for (List<Zeitnahme> zList in monthList) {
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.ListView.builder(
                spacing: spacing,
                itemCount: zList.length,
                itemBuilder: (context, i) {
                  return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, border: pw.Border.all(width: 3, color: PdfColors.black)),
                      child: pw.Padding(padding: pw.EdgeInsets.all(5), child: pw.Text(zList[i].day.day.toString(), style: textStyle)),
                    ),
                    pw.Text(zList[i].day.day.toString(), style: textStyle),
                    pw.Text(tag.format(zList[i].day), style: textStyle),
                  ]);
                }),
            pw.ListView.builder(
                spacing: spacing,
                itemCount: zList.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return pw.Text("Tag", style: textStyle);
                  }

                  i--;

                  return pw.Row(children: [
                    pw.Text(zList[i].tag, style: textStyle),
                  ]);
                }),
            pw.ListView.builder(
                spacing: spacing,
                itemCount: zList.length,
                itemBuilder: (context, i) {
                  if (zList[i].startTimes.isNotEmpty)
                    return pw.Row(children: [
                      pw.Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(zList[i].startTimes.first)), style: textStyle),
                      pw.Icon(pw.IconData(0xf1df), font: icons, size: 8),
                      if (zList[i].startTimes.length == zList[i].endTimes.length)
                        pw.Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(zList[i].endTimes.last)), style: textStyle)
                      else
                        pw.Text(uhrzeit.format(DateTime.now()), style: textStyle)
                    ]);
                  else
                    return pw.Icon(pw.IconData(0xe1eb), font: icons, size: 8);
                }),
            pw.ListView.builder(
                spacing: spacing,
                itemCount: zList.length,
                itemBuilder: (context, i) {
                  if (zList[i].startTimes.isNotEmpty)
                    return pw.Text(Duration(milliseconds: zList[i].getPause()).inMinutes.toString() + " Minuten", style: textStyle);
                  else
                    return pw.Text("v", style: textStyle);
                }),
            pw.ListView.builder(
                spacing: spacing,
                itemCount: zList.length,
                itemBuilder: (context, i) {
                  if (zList[i].startTimes.isNotEmpty)
                    return pw.Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(zList[i].getElapsedTime())), style: textStyle);
                  else
                    return pw.Text("v", style: textStyle);
                })
          ]);

          // Center
        }));
  }
  // Page

  await savePdf(pdf);
}

Future<void> savePdf(pw.Document savePdf) async {
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String documentPath = documentDirectory.path;

  File file = File("$documentPath/example.pdf");

  file.writeAsBytesSync(await savePdf.save());

  print("pdf saved to $documentPath");
}
