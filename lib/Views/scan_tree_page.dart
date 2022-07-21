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
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3, Vector4;

import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:flutter/material.dart';

import '../Database/dataModel.dart';

class ScanTreePage extends StatefulWidget {
  final DataManager dataManager;
  const ScanTreePage({Key? key, required this.dataManager}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  late DataManager dataManager;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  late QRView qrViewPage;
  QRViewController? controller;
  bool qrCodeFound = false;
  DateTime lastScanTime = DateTime.now();
  final Duration timeoutScan = const Duration(seconds: 4);

  @override
  void initState() {
    super.initState();

    dataManager = widget.dataManager;

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
    bool debug = false;
    if (qrCodeFound && result != null || debug) {
      int treeId = int.parse((result!.code)!);
      Tree? tree = dataManager.getTreeById(treeId);
      Project? project = dataManager.getProjectById(treeId);

      return Stack(
        children: [
          const ARWidget(), //AR view widget
          DraggableScrollableSheet(
            //Bottom Sheet that show scanned tree info
            minChildSize: 0.10,
            initialChildSize: 0.15,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              if (tree != null && project != null) {
                return TreeInfoSheet(
                  tree: tree,
                  project: project,
                  controller: scrollController,
                );
              } else {
                return Text("Errore nel reperire le informazioni id: $treeId");
              }
            },
          )
        ],
      );
    } else {
      // Scan QrCode page
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
      if (DateTime.now().difference(lastScanTime) > timeoutScan) {
        lastScanTime = DateTime.now();
        final qrData = scanData.code!;

        if (scanData.code != null) {
          print(scanData.code);
        }

        dataManager.isValidTreeCode(qrData).then((isValidID) => {
              if (isValidID)
                {
                  setState(() {
                    if (!qrCodeFound) {
                      controller.pauseCamera();
                      result = scanData;
                      qrCodeFound = true;

                      int treeId = int.parse(qrData.toString());
                      //dataManager.addUserTree(treeId);
                    }
                  })
                }
              else
                {
                  //qr data are not valid for this app or not contains valid tree id
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "QRcode non valido o albero non trovato id: ${scanData.code}"),
                    duration: const Duration(seconds: 2),
                  ))
                }
            });
      }
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
  final ScrollController controller;
  final Tree tree;
  final Project project;

  const TreeInfoSheet({
    Key? key,
    required this.controller,
    required this.tree,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String nameTree = tree.name;
    return Container(
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: radiusCorner, topRight: radiusCorner),
          color: secondColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListView(controller: controller, children: [
          Text(nameTree,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text("Progetto: ${project.name}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              tree.descr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            children: [
              Text("Co2: ${tree.co2}"),
              getIconIndicator(StatsType.co2, 3),
            ],
          ),
          Row(
            children: [
              Text("Altezza: ${tree.height}"),
              getIconIndicator(StatsType.paper, 9),
            ],
          ),
          Row(
            children: [
              Text("Larghezza: ${tree.diameter}"),
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
