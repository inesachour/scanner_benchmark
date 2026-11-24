import 'package:flutter/material.dart';
import 'scanners/cunning_scan.dart';

enum NoteLevel { warning, danger }

class PackageNote {
  final NoteLevel level;
  final String text;
  const PackageNote(this.level, this.text);
}

/// Describes one scanner package under test.
///
/// [onScan] stays null until the package is implemented; the UI then shows
/// a "not implemented yet" state. To implement one, set [onScan] in
/// [scannerPackages] below.
class ScannerPackage {
  final String name;
  final String pubUrl;
  final String engine;
  final String platforms;
  final String stats;
  final List<PackageNote> notes;
  final Future<void> Function(BuildContext context)? onScan;

  const ScannerPackage({
    required this.name,
    required this.pubUrl,
    required this.engine,
    required this.platforms,
    required this.stats,
    required this.notes,
    this.onScan,
  });

  bool get implemented => onScan != null;

  /// Most severe note level, used for the card's accent colour.
  NoteLevel get worstLevel {
    var worst = NoteLevel.warning;
    for (final n in notes) {
      if (n.level.index > worst.index) worst = n.level;
    }
    return worst;
  }
}

// Stats come from pub.dev (checked 2026-11-24). "?" = not checked yet.
const scannerPackages = <ScannerPackage>[
  ScannerPackage(
    name: 'cunning_document_scanner',
    pubUrl: 'https://pub.dev/packages/cunning_document_scanner',
    engine: 'ML Kit (Android) / VisionKit (iOS)',
    platforms: 'Android, iOS',
    stats: 'Stats not checked yet',
    notes: [
      PackageNote(
        NoteLevel.warning,
        'Verify publisher, maintenance and likes on pub.dev.',
      ),
    ],
    onScan: scanWithCunning,
  ),
  ScannerPackage(
    name: 'flutter_doc_scanner',
    pubUrl: 'https://pub.dev/packages/flutter_doc_scanner',
    engine: 'ML Kit (Android) / VisionKit (iOS)',
    platforms: 'Android, iOS',
    stats: 'Stats not checked yet',
    notes: [
      PackageNote(
        NoteLevel.warning,
        'Verify publisher, maintenance and likes on pub.dev.',
      ),
    ],
  ),
  ScannerPackage(
    name: 'document_scanner_flutter',
    pubUrl: 'https://pub.dev/packages/document_scanner_flutter',
    engine: 'Native Android/iOS libs (older wrapper)',
    platforms: 'Android, iOS (unverified)',
    stats: 'Stats not checked yet',
    notes: [
      PackageNote(
        NoteLevel.danger,
        'Possibly abandoned / not updated for recent Flutter or Android '
        'versions. May not even build. Check last publish date.',
      ),
      PackageNote(NoteLevel.warning, 'Keep as a legacy data point only.'),
    ],
  ),
  ScannerPackage(
    name: 'doc_scan_flutter',
    pubUrl: 'https://pub.dev/packages/doc_scan_flutter',
    engine: 'ML Kit (Android) / VisionKit (iOS)',
    platforms: 'Android (API 21+), iOS 13+',
    stats:
        'v2.0.0 · 150 pts · 13 likes · 1.3k downloads · UNVERIFIED publisher',
    notes: [
      PackageNote(
        NoteLevel.warning,
        'Unverified publisher and few likes. Not widely used.',
      ),
      PackageNote(
        NoteLevel.warning,
        'Output files go to the temp folder; they must be moved to keep.',
      ),
    ],
  ),
  ScannerPackage(
    name: 'document_scan',
    pubUrl: 'https://pub.dev/packages/document_scan',
    engine: 'Apple Vision (iOS) / OpenCV (Android)',
    platforms: 'Android, iOS',
    stats: 'v0.5.0 · 160 pts · 13 likes · 2.3k downloads · verified publisher',
    notes: [
      PackageNote(
        NoteLevel.warning,
        'Very young, low adoption (13 likes). Check stability.',
      ),
      PackageNote(
        NoteLevel.warning,
        'Different detectors per platform: same photo can be detected on '
        'one and missed on the other. iOS may miss long receipts.',
      ),
      PackageNote(
        NoteLevel.warning,
        'Warp runs on CPU in Dart (~1 s on a full-size photo).',
      ),
    ],
  ),
];
