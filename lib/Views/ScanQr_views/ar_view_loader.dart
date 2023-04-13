import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/Views/ScanQr_views/scan_qr_view.dart';
import 'package:tree_ar/Views/Utils/error_view.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/utils.dart';

const errorMessageInvalidQrCode =
    "Il QRcode non è valido\nalbero o progetto non trovato";

class ArViewLoader extends StatelessWidget implements QRScanData {
  late final String qrData;
//TODO: fix that
  ArViewLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Consumer<DataManager>(
            builder: (context, dataManager, child) =>
                FutureBuilder<Map<InfoType, dynamic>?>(
              future: dataManager.isValidTreeCode(qrData),
              builder: (context, snapshot) {
                Widget child = const ErrorView(
                    message: "Errore nello sviluppo schermata !!");

                //log("hasData: ${snapshot.hasData} \n data: ${snapshot.data ?? "null"}");
                if (snapshot.hasData) {
                  //new tree has been scanned --> when go back refresh prev screen
                  var data = snapshot.data!;

                  child = TreeViewInfoAr(
                    tree: data[InfoType.tree],
                    proj: data[InfoType.project],
                    rangeInfoValues: data[InfoType.other],
                  );
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  child = const ErrorView(message: errorMessageInvalidQrCode);
                } else {
                  child = const CenteredWidget(
                    widgetToCenter: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  );
                }
                return child;
              },
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget getWidget() {
    return this;
  }

  @override
  void setScannedData(String qrCodeData) {
    qrData = qrCodeData;
  }
}
