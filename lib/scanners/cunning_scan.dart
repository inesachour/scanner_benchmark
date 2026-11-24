import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

Future<void> scanWithCunning(BuildContext context) async {
  final result = await CunningDocumentScanner.scanDocuments(
    scannerSource: ScannerSource.camera,
    output: ScanOutput.pdf,
  );

  final pdfPath = result?.pdf;
  if (pdfPath == null) return; // user cancelled
  if (!context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          PdfResultPage(title: 'cunning_document_scanner', path: pdfPath),
    ),
  );
}

class PdfResultPage extends StatelessWidget {
  const PdfResultPage({super.key, required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    final sizeKb = (File(path).lengthSync() / 1024).toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(title: Text('$title · $sizeKb KB')),
      body: PDFView(filePath: path),
    );
  }
}
