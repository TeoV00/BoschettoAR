import 'dart:io';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3, Vector4;

import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:flutter/material.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //TODO: it must contain id (tree/project) in order to get all info
  Barcode? result;
  late QRView qrViewPage;
  QRViewController? controller;
  bool qrCodeFound = false;

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
        body: SafeArea(
      child: Stack(children: [
        getViewToShow(),
        Padding(
          padding: pagePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: mainColor),
                child: IconButton(
                  tooltip: "Torna in Home",
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              qrCodeFound
                  ? Container(
                      margin: const EdgeInsets.only(left: 20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: mainColor),
                      child: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        tooltip: "Nuova scansione",
                        onPressed: () => {_resetView()},
                      ),
                    )
                  : const Text("")
            ],
          ),
        )
      ]),
    ));
  }

  Widget getViewToShow() {
    //TODO: from scan result get id then get all info to show from data manager or db
    bool debug = true;
    if (qrCodeFound && result != null || debug) {
      return Stack(
        children: [
          const ARWidget(), //AR view widget
          DraggableScrollableSheet(
            //Bottom Sheet that show scanned tree info
            minChildSize: 0.10,
            initialChildSize: 0.15,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return TreeInfoSheet(
                treeID: 23,
                controller: scrollController,
              );
            },
          )
        ],
      );
    } else {
      return qrViewPage;
    }
  }

  void _resetView() {
    setState(() {
      qrCodeFound = false;
      result = null;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (!qrCodeFound) {
          controller.pauseCamera();
          result = scanData;
          qrCodeFound = true;
        }
      });
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
}

class TreeInfoSheet extends StatelessWidget {
  final DataManager dataManager = DataManager();
  final ScrollController controller;
  final int treeID; //Id of tree to retrieve info from DataManager

  TreeInfoSheet({
    Key? key,
    required this.controller,
    required this.treeID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: radiusCorner, topRight: radiusCorner),
          color: secondColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListView(controller: controller, children: [
          Text(treeID.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: const Text("Progetto: Nome Progetto unibo",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam sed convallis quam. Phasellus ultrices lobortis enim interdum congue. Vivamus maximus faucibus nunc, in porta elit. Proin sed finibus neque. Donec imperdiet, ligula vel aliquet posuere, erat mi tincidunt diam, at aliquam ex magna eget nisl. Nullam lacinia malesuada lacus, convallis euismod nunc pharetra ac.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            children: [
              Text("Co2"),
              getIconIndicator(StatsType.co2, 3),
            ],
          ),
          Row(
            children: [
              Text("Carta"),
              getIconIndicator(StatsType.paper, 9),
            ],
          ),
        ]),
      ),
    );
  }

//TODO: get as param type of info (make an enum to define it)
  Widget getIconIndicator(StatsType type, int value) {
    return Row(
      children: <Icon>[
        for (var i = 0; i < value; i++) ...[
          Icon(statsIcon.elementAt(type.value)),
        ],
      ],
    );
  }
}

//________________AR______ZONE____________

class ARWidget extends StatefulWidget {
  const ARWidget({Key? key}) : super(key: key);

  @override
  State<ARWidget> createState() => _ARWidgetState();
}

class _ARWidgetState extends State<ARWidget> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        showPlatformType: false);
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
        showAnimatedGuide: false,
        handlePans: false,
        showFeaturePoints: true,
        handleRotation: false,
        showWorldOrigin: false);
    this.arObjectManager.onInitialize();
  }

  void onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    var newAnchor =
        ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    arAnchorManager.addAnchor(newAnchor);
    anchors.add(newAnchor);
    // Add note to anchor
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.5, 0.5, 0.5),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));

    arObjectManager.addNode(newNode, planeAnchor: newAnchor);
  }
}
