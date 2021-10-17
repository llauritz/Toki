import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:Toki/Services/Data.dart';
import 'package:Toki/Services/HiveDB.dart';
import 'package:Toki/hiveClasses/Zeitnahme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  pw.TextStyle textStyle = pw.TextStyle(fontSize: 9, font: bandeins, fontWeight: pw.FontWeight.bold);

  double spacing = 4;

  for (List<Zeitnahme> zList in monthList) {
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          // return pw.LayoutBuilder(builder: (context, constraints) {
          //   print(constraints);
          //   return pw.Container(height: constraints!.maxHeight, color: PdfColors.amber);
          // });
          final tileHeight = (PdfPageFormat.a4.availableHeight - 60 - 20) / 31 - spacing;
          return pw.Column(children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text("Stundenzettel von --", style: textStyle.copyWith(fontSize: 14)),
              pw.Text("Juli -- 2020", style: textStyle.copyWith(fontSize: 14))
            ]),
            pw.SizedBox(height: 25),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              // ARBEITSTAG

              pw.ListView.builder(
                  spacing: spacing,
                  itemCount: zList.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return pw.Container(width: 80, height: tileHeight, alignment: pw.Alignment.centerLeft, child: pw.Text("Tag", style: textStyle));
                    }
                    i--;
                    return pw.SizedBox(
                        width: 80,
                        child: pw.Container(
                            color: PdfColors.amber,
                            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                              pw.SizedBox(
                                height: tileHeight,
                                width: tileHeight,
                                child: pw.Container(
                                  alignment: pw.Alignment.center,
                                  decoration: pw.BoxDecoration(shape: pw.BoxShape.circle, border: pw.Border.all(width: 1.5, color: PdfColors.black)),
                                  child: pw.Text(zList[i].day.day.toString(), style: textStyle),
                                ),
                              ),
                              pw.SizedBox(width: 8),
                              pw.Text(tag.format(zList[i].day), style: textStyle),
                            ])));
                  }),

              // TAG BESCHREIBUNG

              pw.ListView.builder(
                  spacing: spacing,
                  itemCount: zList.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return pw.Container(height: tileHeight);
                    }

                    i--;

                    // Outlined Container with black Text
                    if (zList[i].state == "sickDay" || zList[i].state == "free" || zList[i].state == "empty") {
                      return pw.Container(
                          decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(tileHeight / 2), color: PdfColors.white, border: pw.Border.all()),
                          child: pw.Text(zList[i].tag, style: textStyle.copyWith(color: PdfColors.black)),
                          alignment: pw.Alignment.center,
                          height: tileHeight,
                          width: 75);
                    }
                    // Filled Container with white Text
                    else {
                      return pw.Container(
                          decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(tileHeight / 2), color: PdfColors.black),
                          child: pw.Text(
                              (() {
                                if (zList[i].tag == "Stundenabbau" && zList[i].startTimes.isNotEmpty) {
                                  return "Arbeitstag";
                                }
                                return zList[i].tag;
                              }()),
                              style: textStyle.copyWith(color: PdfColors.white)),
                          alignment: pw.Alignment.center,
                          height: tileHeight,
                          width: 75);
                    }
                  }),

              // ARBEITSZEIT

              pw.ListView.builder(
                  spacing: spacing,
                  itemCount: zList.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return pw.Container(
                          width: 80, height: tileHeight, alignment: pw.Alignment.center, child: pw.Text("Arbeistzeit", style: textStyle));
                    }
                    i--;
                    if (zList[i].startTimes.isNotEmpty)
                      return pw.Container(
                          alignment: pw.Alignment.center,
                          height: tileHeight,
                          width: 80,
                          child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
                            pw.Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(zList[i].startTimes.first)), style: textStyle),
                            pw.Padding(
                              padding: pw.EdgeInsets.fromLTRB(2, 1.5, 2, 0),
                              child: pw.Icon(pw.IconData(0xf1df), font: icons, size: 8),
                            ),
                            if (zList[i].startTimes.length == zList[i].endTimes.length)
                              pw.Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(zList[i].endTimes.last)), style: textStyle)
                            else
                              pw.Text(uhrzeit.format(DateTime.now()), style: textStyle)
                          ]));
                    else
                      return pw.Container(
                          alignment: pw.Alignment.center, height: tileHeight, width: 80, child: pw.Icon(pw.IconData(0xe1eb), font: icons, size: 8));
                  }),

              // PAUSENZEIT

              pw.ListView.builder(
                  spacing: spacing,
                  itemCount: zList.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return pw.Container(width: 80, height: tileHeight, alignment: pw.Alignment.center, child: pw.Text("Pause", style: textStyle));
                    }
                    i--;
                    return pw.Container(
                        alignment: pw.Alignment.center,
                        width: 80,
                        height: tileHeight,
                        child: pw.Text(
                            zList[i].startTimes.isNotEmpty ? Duration(milliseconds: zList[i].getPause()).inMinutes.toString() + " Minuten" : "",
                            style: textStyle));
                  }),

              // GEARBEITETE ZEIT

              pw.ListView.builder(
                  spacing: spacing,
                  itemCount: zList.length,
                  itemBuilder: (context, i) {
                    if (zList[i].startTimes.isNotEmpty)
                      return pw.Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(zList[i].getElapsedTime())), style: textStyle);
                    else
                      return pw.Text("", style: textStyle);
                  })
            ])
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
