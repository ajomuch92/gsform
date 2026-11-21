import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen scanner. Pops once with the first decoded value (a `String`).
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key, this.title = 'QR scanner'});

  final String title;

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  // The detector fires for every frame; only the first hit may pop.
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: MobileScanner(
        onDetect: (capture) {
          final code = capture.barcodes.firstOrNull?.rawValue;
          if (_done || code == null) return;
          _done = true;
          Navigator.pop(context, code);
        },
      ),
    );
  }
}
