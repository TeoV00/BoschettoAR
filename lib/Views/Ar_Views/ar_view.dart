import 'dart:developer';
import 'dart:io';
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
import 'package:tree_ar/Utils/unit_converter.dart';
import 'package:tree_ar/Views/Ar_Views/ar_constant.dart';
import 'package:tree_ar/utils.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ARWidget extends StatefulWidget {
  final double savedPaperProj;
  final double savedCo2;
  final Pair<num, num> minMaxPaperValue;
  final num totalSavedPaper;

  const ARWidget({
    Key? key,
    required this.savedPaperProj,
    required this.savedCo2,
    required this.minMaxPaperValue,
    required this.totalSavedPaper,
  }) : super(key: key);

  @override
  State<ARWidget> createState() => _ARWidgetState();
}

class _ARWidgetState extends State<ARWidget> {
  bool paperShowed = false;
  bool barrelShowed = false;

  int paperStackAmount = 1;
  int barrelAmount = 1;

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  late ARView arView;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void initState() {
    super.initState();

    initPaperStackAmount();
    barrelAmount = ValueConverter.fromCo2ToPetrolBarrels(widget.savedCo2);

    arView = ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
        permissionPromptButtonText: 'Permesso fotocamera',
        showPlatformType: false);
  }

  void initPaperStackAmount() {
    //use of mininum value of saved papaer as core unit for papaer satck
    int simpleDivision = widget.savedPaperProj ~/ widget.minMaxPaperValue.elem1;

    if (simpleDivision > maxCountStack) {
      //remapping project's paper value into a rnge of [0,20] in order to not
      paperStackAmount = maxCountStack *
          widget.savedPaperProj ~/
          widget.minMaxPaperValue.elem2;
    } else {
      paperStackAmount = simpleDivision;
    }
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        showAnimatedGuide: true);
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onNodeTap = onNodeTapped;
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var paperInStack =
        getMultiplierString(widget.savedPaperProj ~/ paperStackAmount);

    arSessionManager.onError(
        "Plico di ${paperInStack.elem1} ${paperInStack.elem2}fogli di carta");
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    log('''originale: ${widget.savedPaperProj} countStacks: $paperStackAmount''');
    log('''barrels count: $barrelAmount''');
    if (!paperShowed || !barrelShowed) {
      //if anchor is not already set
      var singleHitTestResult = hitTestResults.firstWhere(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

      var anchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);

      //show only one time ar objects
      if (!paperShowed) {
        paperShowed = true;

        _addNodesMatrixToARWorld(
          anchor,
          1,
          "assets/arModel/paper_stack/stack3/stack3.gltf",
          paperStackAmount,
          0.5, //stack3Size.width,
          0.5, //stack3Size.height,
        );
      } else if (!barrelShowed) {
        barrelShowed = true;
        _addNodesMatrixToARWorld(
          anchor,
          null,
          "assets/arModel/petrol_barrel/petrol_barrel.gltf",
          barrelAmount,
          1, // barrelSize.width,
          1, // barrelSize.height,
        );
      }
    }
  }

  void _addNodesMatrixToARWorld(ARPlaneAnchor anchor, double? scale,
      String modelUri, int objAmount, double objWidth, double objHeight) async {
    bool? didAddAnchor = (await arAnchorManager.addAnchor(anchor));

    if (didAddAnchor != null && didAddAnchor) {
      int xCount =
          objAmount ~/ 2 > 0 ? objAmount ~/ 2 : 1; //quantiti of element per row
      log("xcount: $xCount");
      int yCount = objAmount ~/ xCount; // row

      log("ycount: $yCount xCount: $xCount");

      if (xCount == 0) {
        xCount = 1;
      }

      double y = 0.0;

      for (int j = 0; j < yCount; j++) {
        double x = 0.0;

        for (int i = 0; i < xCount; i++) {
          var newNode = ARNode(
            type: NodeType.localGLTF2,
            uri: modelUri,
            scale: scale != null ? Vector3(scale, scale, scale) : null,
            //left-right offet(x), vertical-offset (z), (y)
            position: Vector3(x, 0, y),
          );

          bool? didAddWebNode =
              (await arObjectManager.addNode(newNode, planeAnchor: anchor));

          if (didAddWebNode != null && didAddWebNode) {
            log("nodo aggiunto");
            nodes.add(newNode);
            anchors.add(anchor);
          }
          x += objWidth;
        }
        y += objHeight;
        log("y: $y  x: $x");
      }
    } else {
      arSessionManager.onError("Adding Anchor failed");
    }
  }
}
