import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/Views/CustomWidget/round_back_button.dart';
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
    bool toRefreshData = false;

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

                bool canShowSnackbar = true;

                controller.scannedDataStream.listen((scanData) {
                  if (scanData.code != null &&
                      DateTime.now().difference(lastScanTime) > timeoutScan) {
                    lastScanTime = DateTime.now();
                    canShowSnackbar = true;
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
                      (answer) => {
                        if (answer == 'home')
                          {
                            controller.pauseCamera(),
                            Navigator.pop(context),
                          }
                        else if (answer == 'newscan')
                          {
                            controller.resumeCamera(),
                          }
                        else
                          {
                            controller.pauseCamera(),
                            Navigator.pop(context),
                          }
                      },
                    );
                  } else if (canShowSnackbar) {
                    canShowSnackbar = false;
                    showSnackBar(
                        context,
                        const Text(
                            "Attendere un paio di secondi prima di una nuova scansione"),
                        null);
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
            const Padding(
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
