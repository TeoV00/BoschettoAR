import 'dart:developer';
import 'dart:math' as math;
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
import 'package:tree_ar/Views/Utils/unit_converter.dart';
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
    barrelAmount = ValueConverter.fromCo2ToFuelTanks(widget.savedCo2);

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
        showPlanes: false,
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
          0.30, //space between rows
          0.30, //space between cols
        );
      } else if (!barrelShowed) {
        barrelShowed = true;
        _addNodesMatrixToARWorld(
          anchor,
          null,
          "assets/arModel/tanica/tanica.gltf",
          barrelAmount,
          0.50, //space between rows
          0.30, //space between cols
        );
      }
    }
  }

  void _addNodesMatrixToARWorld(ARPlaneAnchor anchor, double? scale,
      String modelUri, int objAmount, double objWidth, double objHeight) async {
    bool? didAddAnchor = (await arAnchorManager.addAnchor(anchor));

    if (didAddAnchor != null && didAddAnchor) {
      double edgeAmount = math.sqrt(objAmount);

      int yCount =
          edgeAmount > 0 ? edgeAmount.round() : 1; //quantity of element per row

      int xCount = yCount - 1;
      int xCountRemains = yCount - (math.pow(yCount, 2) - objAmount).toInt();

      if (xCount == 0) {
        xCount = 1;
      }

      double x = 0.0;

      for (int j = 0; j < yCount; j++) {
        double y = 0.0;

        for (int i = 0; i < xCount; i++) {
          addNode(modelUri, scale, x, y, anchor, arObjectManager);
          y += objWidth;
        }
        x += objHeight;
      }

      //add remaining objs
      double y = 0.0;
      for (int i = 0; i < xCountRemains; i++) {
        addNode(modelUri, scale, x, y, anchor, arObjectManager);
        y += objWidth;
      }
    } else {
      arSessionManager.onError("Adding Anchor failed");
    }
  }

  void addNode(
    String modelUri,
    double? scale,
    double x,
    double y,
    ARPlaneAnchor anchor,
    ARObjectManager arObjectManager,
  ) async {
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
      nodes.add(newNode);
      anchors.add(anchor);
    }
  }
}
