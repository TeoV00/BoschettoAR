import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';
import 'package:tree_ar/utils.dart';

const errorMessageInvalidQrCode =
    "Il QRcode è già stato scansionato\n o non valido";

class ArViewLoader extends StatefulWidget {
  final String qrData;
  const ArViewLoader({Key? key, required this.qrData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArViewLoaderState();
}

class _ArViewLoaderState extends State<ArViewLoader> {
  @override
  Widget build(BuildContext context) {
    bool anyNewScan = false;

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Consumer<DataManager>(
            builder: (context, dataManager, child) =>
                FutureBuilder<Map<InfoType, dynamic>?>(
              future: dataManager.isValidTreeCode(widget.qrData),
              builder: (context, snapshot) {
                Widget child = const ShowMessagePage(
                  message: "Errore nello sviluppo schermata !!",
                );

                //log("hasData: ${snapshot.hasData} \n data: ${snapshot.data ?? "null"}");
                if (snapshot.hasData) {
                  //new tree has been scanned --> when go back refresh prev screen

                  anyNewScan = true;

                  var data = snapshot.data!;

                  child = TreeViewInfoAr(
                      tree: data[InfoType.tree], proj: data[InfoType.project]);
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  child =
                      const ShowMessagePage(message: errorMessageInvalidQrCode);
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
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: mainColor),
                child: IconButton(
                    tooltip: "Torna in Home",
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => {
                          Navigator.pop(context, "home"), //go back home
                        }),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: mainColor),
                child: IconButton(
                  tooltip: "Nuova Scansione",
                  icon: const Icon(Icons.qr_code),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

class ShowMessagePage extends StatelessWidget {
  final String message;
  const ShowMessagePage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    return Container(
      color: secondColor,
      child: CenteredWidget(
        widgetToCenter: Column(children: [
          Icon(Icons.error, size: 100, color: textColor),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          )
        ]),
      ),
    );
  }
}
