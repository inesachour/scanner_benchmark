import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
