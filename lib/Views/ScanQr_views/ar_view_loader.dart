import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/utils.dart';

const errorMessageInvalidQrCode =
    "Il QRcode non è valido\nalbero o progetto non trovato";

class ArViewLoader extends StatefulWidget {
  final String qrData;
  const ArViewLoader({Key? key, required this.qrData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArViewLoaderState();
}

class _ArViewLoaderState extends State<ArViewLoader> {
  @override
  Widget build(BuildContext context) {
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
                  var data = snapshot.data!;

                  child = TreeViewInfoAr(
                    tree: data[InfoType.tree],
                    proj: data[InfoType.project],
                    rangeInfoValues: data[InfoType.other],
                  );
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
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Torna in Home")),
        ]),
      ),
    );
  }
}
