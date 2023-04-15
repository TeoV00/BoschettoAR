import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/Views/ScanQr_views/scan_qr_view.dart';
import 'package:tree_ar/Views/UploadProgress/common_widgets.dart';
import 'package:tree_ar/Views/UploadProgress/upload_completed.dart';
import 'package:tree_ar/Views/UploadProgress/uploading_data_view.dart';
import 'package:tree_ar/Views/Utils/bottom_grass.dart';
import 'package:tree_ar/Views/Utils/error_view.dart';
import 'package:tree_ar/constant_vars.dart';

const String helpGuide =
    "Recati nel totem più vicino, clicca sul pulsante “Deposita Progressi APP” e scansiona il Qr code";

class ScanTotemQR extends StatefulWidget {
  const ScanTotemQR({super.key});

  @override
  State<StatefulWidget> createState() => ScanTotemQRState();
}

class ScanTotemQRState extends State<ScanTotemQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Scansione Totem", context),
      body: BottomGrass(
        childOnGrass: Image.asset(
          "$imagePath/arrow_vase.png",
          height: 120,
        ),
        child: ScanQrView(afterScanChild: SucessfullDataLoaded()),
      ),
    );
  }
}

class SucessfullDataLoaded implements QRScanData {
  String? data;

  @override
  Widget getWidget() {
    if (data != null) {
      String totemId = data!;
      return Scaffold(
        body: SafeArea(
          child: BottomGrass(
            child: Consumer<DataManager>(
              builder: (context, dataManager, child) => FutureBuilder<bool>(
                future: dataManager
                    .uploadUserData(totemId)
                    .timeout(const Duration(seconds: 8)),
                builder: (context, snap) {
                  ConnectionState conState = snap.connectionState;
                  bool uploadDone = snap.hasData ? snap.data! : false;

                  if (conState == ConnectionState.waiting) {
                    return const UploadingDataView();
                  } else if (conState == ConnectionState.done) {
                    if (uploadDone) {
                      return const CompletedUploadView();
                    } else {
                      return ErrorView(
                          message: "errore invio dati $uploadDone");
                    }
                  } else {
                    return const ErrorView(
                        message: "Si è verificato un problema");
                  }
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text("si è verificato un errore, nessun dato nel qr"),
      );
    }
  }

  @override
  void setScannedData(String qrCodeData) {
    data = qrCodeData;
  }
}
