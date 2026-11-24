# scanner_benchmark

A Flutter app for benchmarking document-scanner packages. The goal is to pick a replacement for the scanner currently used in the Docic project (`scanbot_sdk`), which will be used on medical documents.

The home screen has one button per package. Each card shows the package's engine, supported platforms, pub.dev stats and warning notes. The scan logic for each package is implemented one at a time. Until then, the button shows "not implemented yet".

## Packages under test

| Package | Engine | Platforms | Notes |
|---|---|---|---|
| [cunning_document_scanner](https://pub.dev/packages/cunning_document_scanner) | ML Kit (Android), VisionKit (iOS) | Android, iOS | Native UI, no customization. |
| [flutter_doc_scanner](https://pub.dev/packages/flutter_doc_scanner) | ML Kit (Android), VisionKit (iOS) | Android, iOS | Can return a PDF. |
| [document_scanner_flutter](https://pub.dev/packages/document_scanner_flutter) | Older native wrappers | Android, iOS (unverified) | May be abandoned. It may not build on current Flutter or Android versions. |
| [doc_scan_flutter](https://pub.dev/packages/doc_scan_flutter) | ML Kit (Android), VisionKit (iOS) | Android, iOS | Unverified publisher and few likes. |
| [document_scan](https://pub.dev/packages/document_scan) | Apple Vision (iOS), OpenCV (Android) | Android, iOS | Headless, so there is no UI. Young package with low adoption. |

`google_mlkit_document_scanner` was dropped from the list because its document scanner is Android only.

pub.dev stats were checked on 2026-11-24. Some packages have not been checked yet. The cards say so.

## Baseline

`scanbot_sdk` is the commercial SDK Docic uses today. It is the reference for quality, speed and features.

## What gets compared

- Edge-detection success rate on skewed, low-light and glare images, and on busy backgrounds.
- Scan latency.
- Output quality, including OCR accuracy on prescriptions, lab results and stamped documents.
- Output format (JPEG, PDF) and file size.
- App size increase.
- iOS and Android support and minimum OS versions.
- Customizable UI.
- Licensing and maintenance status.
- Offline, on-device processing. This matters for medical data.

## Project layout

- `lib/main.dart` has the home screen and the package cards.
- `lib/scanner_package.dart` has the package data (engine, platforms, stats, notes) and the `onScan` hook for each package.

## Adding a package implementation

1. Add the package to `pubspec.yaml`.
2. Set `onScan` on its entry in `scannerPackages` in `lib/scanner_package.dart`.
3. Until `onScan` is set, the button shows a "not implemented yet" message.

## Requirements

- Flutter with Dart SDK `^3.11.5` (see `pubspec.yaml`).
- A physical Android or iOS device. Camera scanners do not work properly on emulators or desktop.
