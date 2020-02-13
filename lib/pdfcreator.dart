import 'dart:io';
import 'package:image/image.dart' as i;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

void PdfCreator({
  File imagemAnterior,
}) async {
  final Document pdf = Document();

  var image = i.decodeImage(imagemAnterior.readAsBytesSync());
  final img = PdfImage(
    pdf.document,
    image: image.data.buffer.asUint8List(),
    width: image.width,
    height: image.height,
  );

  pdf.addPage(
    MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Portable Document Format',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
        Text("oi"),
        Image(img)
      ],
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  String nomePDF = '${directory.path}/teste.pdf';
  final File file = File(nomePDF);
  await file.writeAsBytes(pdf.save());
  OpenFile.open(nomePDF);
}
