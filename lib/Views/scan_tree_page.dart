import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/main.dart';
import 'Ar_Views/ar_info_ar_screen.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool showNewScanBtn = false;
  bool showErrorSnackBar = false;
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

              if (!showNewScanBtn &&
                  loadFinished &&
                  tree != null &&
                  proj != null) {
                showNewScanBtn = true;
                return TreeViewInfoAr(
                  tree: tree,
                  proj: proj,
                );
              } else {
                //showSnackError(); //TODO: da un mega errore!!!!
                showNewScanBtn = false;
                return QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    setState(() {
                      this.controller = controller;
                    });

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
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
        ]),
      ),
    );
  }

  void showSnackError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("QRcode non valido o albero non trovato"),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
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
