import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/Views/ScanQr_views/scan_qr_view.dart';
import 'package:tree_ar/Views/Utils/round_back_button.dart';
import 'package:tree_ar/Views/ScanQr_views/ar_view_loader.dart';

import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final Duration timeoutScan = const Duration(seconds: 4);

  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext buildContext) {
    DateTime lastScanTime = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: const [
            ScanQrView(afterScanChild: ArViewLoader()),
            Padding(
              padding: pagePadding,
              child: RoundBackButton(result: null),
            )
          ],
        ),
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    controller!.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera Permission')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
