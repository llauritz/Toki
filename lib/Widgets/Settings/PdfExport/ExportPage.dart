import 'package:Timo/Services/Theme.dart';
import 'dart:io';
import 'package:Timo/Widgets/Settings/PdfExport/PdfExport.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path_provider/path_provider.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Center(
        child: OpenContainer(
          closedElevation: 5.0,
          openElevation: 10.0,
          closedShape: StadiumBorder(),
          openShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          transitionDuration: Duration(milliseconds: 400),
          transitionType: ContainerTransitionType.fade,
          openColor: Theme.of(context).cardColor,
          closedColor: Theme.of(context).primaryColorLight,
          closedBuilder: (BuildContext context, void Function() action) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text("Exportieren", style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            );
          },
          openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
            return Scaffold(
              body: Center(
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
              )),
            );
          },
        ),
      ),
    );
  }
}
