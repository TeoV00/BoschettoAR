import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:tree_ar/constant_vars.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final DataManager dataManager = DataManager();

  Barcode? result;
  bool qrCodeFound = false;
  QRViewController? controller;

  DateTime lastScanTime = DateTime.now();
  final Duration timeoutScan = const Duration(seconds: 4);

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Consumer<DataManager>(
            builder: (context, dataMgr, child) {
              var tree = dataMgr.treeByQrCodeId;
              var proj = dataMgr.projByQrCodeId;
              var loadFinished = dataMgr.loadHasFinished;
              dataMgr.resetCacheVars();

              if (loadFinished && tree != null && proj != null) {
                return TreeViewInfoAr(
                  tree: tree,
                  proj: proj,
                );
              } else {
                print("Qr NON VALIDO");

                return QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    setState(() {
                      this.controller = controller;
                    });

                    //to fix black screen camera problem
                    if (Platform.isAndroid) {
                      controller.resumeCamera();
                    }
                    controller.scannedDataStream.listen((scanData) {
                      if (DateTime.now().difference(lastScanTime) >
                          timeoutScan) {
                        lastScanTime = DateTime.now();

                        var qrData = scanData.code ?? "";
                        dataMgr.isValidTreeCode(qrData);
                      }
                    });
                  },
                  overlay: QrScannerOverlayShape(
                      borderColor: mainColor,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 20),
                  onPermissionSet: (ctrl, p) =>
                      _onPermissionSet(context, ctrl, p),
                );
              }
            },
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: mainColor),
            child: IconButton(
              tooltip: "Torna in Home",
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {Navigator.pop(context, qrCodeFound)},
            ),
          ),
        ]),
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
