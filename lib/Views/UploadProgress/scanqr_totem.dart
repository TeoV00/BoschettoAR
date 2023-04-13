import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/DataModel/data_model.dart';
import 'package:tree_ar/Views/ScanQr_views/scan_qr_view.dart';
import 'package:tree_ar/Views/UploadProgress/common_widgets.dart';
import 'package:tree_ar/Views/Utils/bottom_grass.dart';
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
      return Scaffold(
        body: SafeArea(
          child: BottomGrass(
              child: Consumer<DataManager>(
            builder: (context, dataManager, child) =>
                FutureBuilder<List<TotemInfo>?>(
              future: dataManager.uploadUserData(data!),
              builder: (context, snapshot) {
                String res = snapshot.hasData.toString();
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    res = data!.length.toString();
                  }
                }
                return Text(res);
              },
            ),
          )),
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
