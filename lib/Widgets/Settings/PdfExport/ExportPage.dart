import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Widgets/Settings/FadeIn.dart';
import 'dart:io';
import 'package:Timo/Widgets/Settings/PdfExport/PdfExport.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path_provider/path_provider.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  bool pdf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.5),
            child: FadeIn(
              delay: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: neonTranslucent,
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeIn(
                delay: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.file_upload_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 48,
                  ),
                ),
              ),
              FadeIn(delay: 20, child: Text("Arbeitszeigen", style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor))),
              FadeIn(delay: 50, child: Text("exportieren", style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor))),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FadeIn(
                        delay: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                border: Border.all(color: pdf ? neon : neon.withAlpha(0), width: pdf ? 2.5 : 0),
                                color: Color.lerp(Theme.of(context).cardColor, Colors.white, 0.1),
                                boxShadow: [BoxShadow(offset: Offset(0, 8), blurRadius: 8, color: Colors.black.withAlpha(15))],
                                borderRadius: BorderRadius.circular(20)),
                            child: Material(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              color: Theme.of(context).cardColor,
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                splashColor: neon.withAlpha(50),
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  pdf = true;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        color: pdf ? neonTranslucent : grayTranslucent,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Dokument (.pdf)",
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            """Gut geeignet zum Drucken oder verschicken.""",
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Flexible(
                    child: FadeIn(
                        delay: 130,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                border: Border.all(color: !pdf ? neon : neon.withAlpha(0), width: !pdf ? 2.5 : 0),
                                color: Color.lerp(Theme.of(context).cardColor, Colors.white, 0.1),
                                boxShadow: [BoxShadow(offset: Offset(0, 8), blurRadius: 8, color: Colors.black.withAlpha(15))],
                                borderRadius: BorderRadius.circular(20)),
                            child: Material(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              color: Theme.of(context).cardColor,
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                splashColor: neon.withAlpha(50),
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  pdf = false;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        color: !pdf ? neonTranslucent : grayTranslucent,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tabelle (.csv)",
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            """Gut geeignet zum Drucken oder verschicken.""",
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ],
          )),
          Align(
            alignment: Alignment(0, 0.9),
            child: TextButton(
              onPressed: () async {
                await pdfExport();

                Directory documentDirectory = await getApplicationDocumentsDirectory();
                String documentPath = documentDirectory.path;

                final pdfController = PdfController(document: PdfDocument.openFile("$documentPath/example.pdf"));

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Scaffold(body: PdfView(controller: pdfController));
                }));
              },
              child: Text("Export"),
            ),
          ),
        ],
      ),
    );
  }
}
