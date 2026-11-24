import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:scanner_benchmark/pdf_result_page.dart';

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
