import 'dart:io';
import 'package:tree_ar/main.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:tree_ar/constant_vars.dart';
import '../Database/dataModel.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  bool qrCodeFound = false;
  QRViewController? controller;

  DateTime lastScanTime = DateTime.now();
  final Duration timeoutScan = const Duration(seconds: 4);

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
          child: Consumer<DataManager>(
            builder: (context, dataManager, child) {
              if (dataManager.loadHasFinished && dataManager.treeById != null) {
                //TODO: get all info from datamanager then call rest method to init buffer vars
                //save info in vars in order to pass them to the wiget to be returned
                //reset 'biffer vars'
                var id = dataManager.treeById?.treeId;
                // if (id != null) {
                //   dataManager.addUserTree(id);
                // }

                dataManager.resetConsumerVars();

                return Text("Albero info ottenute ID: ${id?.toString()}");
              } else if (qrCodeFound && !dataManager.loadHasFinished) {
                return loadingPage();
              } else {
                return QRView(
                  key: qrKey,
                  onQRViewCreated: (ctrl) => {
                    setState(() {
                      controller = ctrl;
                    }),
                    ctrl.scannedDataStream.listen((scanData) {
                      if (DateTime.now().difference(lastScanTime) >
                          timeoutScan) {
                        lastScanTime = DateTime.now();
                        setState(() {
                          qrCodeFound = true;
                        });
                        dataManager.isValidTreeCode(scanData.code!);
                      }
                    })
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
        ));
  }

  void resetView() {
    setState(() {
      result = null;
      controller!.resumeCamera();
    });
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

  Widget loadingPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [Text("Verifica del QR-Code e reperimento dati albero")],
    );
  }
}
