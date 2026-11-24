import 'package:flutter/material.dart';

import 'scanner_package.dart';

// Docic brand colors (ThemeUtils in ../Docic).
const docicPrimary = Color(0xff0F818F);
const docicDark = Color(0xff075C67);
const docicLight = Color(0xff148291);
const docicBackground = Color(0xffF6F8FC);

void main() {
  runApp(const ScannerBenchmarkApp());
}

class ScannerBenchmarkApp extends StatelessWidget {
  const ScannerBenchmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner Benchmark',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: docicPrimary,
        ).copyWith(primary: docicPrimary),
        useMaterial3: true,
        scaffoldBackgroundColor: docicBackground,
      ),
      home: const BenchmarkHomePage(),
    );
  }
}

class BenchmarkHomePage extends StatelessWidget {
  const BenchmarkHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Scanner Benchmark',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [docicDark, docicLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            itemCount: scannerPackages.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, i) =>
                PackageCard(index: i + 1, package: scannerPackages[i]),
          ),
        ),
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.index, required this.package});

  final int index;
  final ScannerPackage package;

  Future<void> _scan(BuildContext context) async {
    final onScan = package.onScan;
    if (onScan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${package.name}: not implemented yet'),
        ),
      );
      return;
    }
    try {
      await onScan(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${package.name} failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: docicDark.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [docicDark, docicLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  package.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: docicDark,
                  ),
                ),
              ),
            ],
          ),
          if (package.notes.isNotEmpty) const SizedBox(height: 6),
          for (final note in package.notes) _NoteTile(note: note),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _scan(context),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              icon: const Icon(Icons.document_scanner_outlined),
              label: const Text('Scan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final PackageNote note;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (note.level) {
      NoteLevel.info => (Icons.info_outline, Colors.blueGrey),
      NoteLevel.warning => (Icons.warning_amber_rounded, Colors.orange),
      NoteLevel.danger => (Icons.error_outline, Colors.red),
    };
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note.text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(height: 1.35, color: const Color(0xff333333)),
            ),
          ),
        ],
      ),
    );
  }
}
