import 'dart:io';
import 'package:tree_ar/main.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:tree_ar/constant_vars.dart';
import '../Database/dataModel.dart';
import 'ar_view.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  late QRView qrViewPage;
  QRViewController? controller;

  DateTime lastScanTime = DateTime.now();
  final Duration timeoutScan = const Duration(seconds: 4);

  @override
  void initState() {
    super.initState();

    qrViewPage = QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: mainColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 20),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
            tooltip: "Torna indietro",
            onPressed: () => {Navigator.pop(context)},
            backgroundColor: mainColor,
            child: const Icon(Icons.arrow_back)),
        body: SafeArea(
          child: Stack(children: [
            //qr data are not valid for this app or not contains valid tree id
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //   content: Text("QRcode non valido o albero non trovato"),
            //   duration: Duration(seconds: 2),
            // )),
            //qrCodeFound ? TreeViewInfoAr(proj: ,tree: ) : qrViewPage;
            qrViewPage,
            //}),
          ]),
        ));
  }

  void resetView() {
    setState(() {
      result = null;
      controller!.resumeCamera();
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
  }

  void streamData() {
    //get datamanager form top widget that istanciate it
    var dataManager = Repository.of(context).dataManager;
    if (controller != null) {
      controller!.scannedDataStream.listen((scanData) {
        if (DateTime.now().difference(lastScanTime) > timeoutScan) {
          lastScanTime = DateTime.now();
          dataManager.isValidTreeCode(scanData.code!);
        }
      });
    }
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
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
