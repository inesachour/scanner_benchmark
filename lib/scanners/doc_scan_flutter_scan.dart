import 'package:doc_scan_flutter/doc_scan.dart';
import 'package:flutter/material.dart';

import '../pdf_result_page.dart';

Future<void> scanWithDocScanFlutter(BuildContext context) async {
  final result = await DocumentScanner.scan(format: DocScanFormat.pdf);

  if (result == null || result.isEmpty) return; // user cancelled
  if (!context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          PdfResultPage(title: 'doc_scan_flutter', path: result.first),
    ),
  );
}
