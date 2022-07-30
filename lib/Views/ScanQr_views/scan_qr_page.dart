import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/Views/ScanQr_views/check_code_view.dart';
import 'package:tree_ar/data_manager.dart';

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
  bool qrCodeFound = false;
  QRViewController? controller;

  void goBack(BuildContext context) {
    Navigator.pop(context, qrCodeFound);
  }

  @override
  Widget build(BuildContext buildContext) {
    log("build qr view");
    DateTime lastScanTime = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                log("qr view created");
                setState(() {
                  this.controller = controller;
                });

                //to fix black screen camera problem
                if (Platform.isAndroid) {
                  controller.resumeCamera();
                }

                controller.scannedDataStream.listen((scanData) {
                  if (scanData.code != null) {
                    //when navigate to a new page stop scanning in order to prevent open multiple screens
                    controller.pauseCamera();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArViewLoader(qrData: scanData.code!),
                      ),
                    ).then(
                      //when come back to scan page resume camera
                      (value) => controller.resumeCamera(),
                    );
                  }

                  if (DateTime.now().difference(lastScanTime) > timeoutScan) {
                    lastScanTime = DateTime.now();
                    log("scna");
                  }
                });
              },
              overlay: QrScannerOverlayShape(
                  borderColor: mainColor,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 20),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: mainColor),
              child: IconButton(
                tooltip: "Torna in Home",
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, qrCodeFound),
              ),
            ),
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
