import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:tree_ar/utils.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ARWidget extends StatefulWidget {
  final double savedPaperProj;
  final num paperCountInStack;

  const ARWidget(
      {Key? key, required this.savedPaperProj, required this.paperCountInStack})
      : super(key: key);

  @override
  State<ARWidget> createState() => _ARWidgetState();
}

class _ARWidgetState extends State<ARWidget> {
  bool objShowed = false;

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  late ARView arView;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void initState() {
    super.initState();

    arView = ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
        permissionPromptButtonText: 'Permesso fotocamera',
        showPlatformType: false);
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Min PAper in sstack: ${widget.paperCountInStack}");
    return arView;
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
        showFeaturePoints: false,
        showPlanes: true,
        showWorldOrigin: false,
        handleTaps: true,
        customPlaneTexturePath: "assets/arModel/grass.png",
        showAnimatedGuide: false);
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onNodeTap = onNodeTapped;
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    double realPaperPerStack = widget.savedPaperProj /
        (widget.savedPaperProj ~/ widget.paperCountInStack);
    Pair<int, String?> pairVal = getMultiplierString(realPaperPerStack.toInt());

    arSessionManager
        .onError("Plico di ${pairVal.elem1} ${pairVal.elem1} folgi di carta");
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    //if anchor is not already set

    //show only one time ar objects stats
    if (!objShowed) {
      objShowed = true;

      var singleHitTestResult = hitTestResults.firstWhere(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

      var anchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);

      _addNodesToARWorld(
        anchor,
        0.5,
        "assets/arModel/paper_stack/stack3/stack3.gltf",
        widget.savedPaperProj ~/ widget.paperCountInStack,
        0.05,
      );

      // _addNodesToARWorld(
      //   anchor,
      //   2.0,
      //   "assets/arModel/petrol_barrel/petrol_barrel.gltf",
      //   4,
      //   0.05,
      // );
    }
  }

  double _calcSpaceBtwObj(int idx, double scale) {
    return 0.01 * idx * 5 / scale;
  }

  void _addNodesToARWorld(ARPlaneAnchor anchor, double scale, String modelUri,
      int objAmount, double vMargin) async {
    bool? didAddAnchor = (await arAnchorManager.addAnchor(anchor));

    if (didAddAnchor != null && didAddAnchor) {
      log("ancora aggiunta");

      int yCount = objAmount ~/ 2;
      int xCount = objAmount % 2 == 0 ? yCount : yCount + 1;

      log(xCount.toString());

      if (xCount == 0) {
        xCount = 1;
      }

      double y = 0.0;
      double h = 0.02;
      double offset = 0.0;

      for (int j = 0; j <= yCount; j++) {
        double x = 0.0;
        y = _calcSpaceBtwObj(j, scale) + offset;
        offset += vMargin;

        for (int i = 0; i <= xCount; i++) {
          x = _calcSpaceBtwObj(i + 1, scale);

          var newNode = ARNode(
            type: NodeType.localGLTF2,
            uri: modelUri,
            scale: Vector3(scale, scale, scale),
            //left-right offet(x), vertical-offset (z), (y)
            position: Vector3(x, h, y),
          );

          bool? didAddWebNode =
              (await arObjectManager.addNode(newNode, planeAnchor: anchor));

          if (didAddWebNode != null && didAddWebNode) {
            log("nodo aggiunto");
            nodes.add(newNode);
            anchors.add(anchor);
          }
        }
      }
    } else {
      arSessionManager.onError("Adding Anchor failed");
    }
  }
}
