import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';
import 'package:tree_ar/utils.dart';

const errorMessageInvalidQrCode =
    "Il QRcode scansionato non è valido\nTorna indietro ed effettua una nuova scansione";

class ArViewLoader extends StatefulWidget {
  final String qrData;
  const ArViewLoader({Key? key, required this.qrData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArViewLoaderState();
}

class _ArViewLoaderState extends State<ArViewLoader> {
  final DataManager dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          FutureBuilder<Map<InfoType, dynamic>?>(
            future: dataManager.isValidTreeCode(widget.qrData),
            builder: (context, snapshot) {
              Widget child = const ShowMessagePage(
                message: "Errore nello sviluppo schermata !!",
              );

              log("hasData: ${snapshot.hasData} \n data: ${snapshot.data ?? "null"}");
              if (snapshot.hasData) {
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
          Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: mainColor),
            child: IconButton(
              tooltip: "Torna in Home",
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context,
                  true), //TODO: return depend on result of validation of code scanned
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
          widgetToCenter: Column(
        children: [
          Icon(Icons.warning, size: 100, color: textColor),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
