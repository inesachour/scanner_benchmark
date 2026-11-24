import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:scanner_benchmark/pdf_result_page.dart';

Future<void> scanWithFlutterDocScanner(BuildContext context) async {
  final result = await FlutterDocScanner().getScannedDocumentAsPdf();
  final uri = result?.pdfUri;
  if (uri == null || uri.isEmpty) return; // user cancelled
  if (!context.mounted) return;

  final parsed = Uri.parse(uri);
  final path = parsed.scheme == 'file' ? parsed.toFilePath() : uri;

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PdfResultPage(title: 'flutter_doc_scanner', path: path),
    ),
  );
}
