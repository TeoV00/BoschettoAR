import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Views/Ar_Views/ar_view.dart';
import 'package:tree_ar/constant_vars.dart';

class TreeViewInfoAr extends StatelessWidget {
  final Tree tree;
  final Project proj;

  const TreeViewInfoAr({Key? key, required this.tree, required this.proj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ARWidget(savedPaperProj: proj.paper), //AR view widget
          DraggableScrollableSheet(
            //Bottom Sheet that show scanned tree info
            minChildSize: 0.10,
            initialChildSize: 0.15,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return TreeInfoSheet(
                tree: tree,
                project: proj,
                controller: scrollController,
              );
            },
          ),
        ],
      ),
    );
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
    const double pad = 10;
    final double screenWidth = MediaQuery.of(context).size.width - (2 * pad);

    return Container(
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: radiusCorner, topRight: radiusCorner),
          color: secondColor),
      child: Padding(
        padding: const EdgeInsets.only(top: pad, left: pad, right: pad),
        child: ListView(controller: controller, children: [
          Text(nameTree,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          Text(tree.descr),
          const Divider(thickness: 1),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text("Progetto: ${project.projectName}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              project.descr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          rowIndicator('Co2', StatsType.co2, tree.co2, 1000, screenWidth),
          rowIndicator(
              'Altezza (cm) ', StatsType.height, tree.height, 100, screenWidth),
          rowIndicator('Tronco (cm)', StatsType.diameter, tree.diameter, 90,
              screenWidth),
          rowIndicator('Acqua', StatsType.water, 30, 300, screenWidth),
        ]),
      ),
    );
  }

  Widget rowIndicator(
    String label,
    StatsType type,
    int value,
    int maxValue,
    double screenWidth,
  ) {
    const double iconSizeDefault = 24;
    const double textSize = 15;
    String labelValue = "$label: $value";

    if (value > maxValue) {
      value = maxValue;
    }

    double textPixel = textSize * labelValue.length;
    int maxIconCount = ((screenWidth - textPixel) / iconSizeDefault).ceil();
    int mappedVal = (maxIconCount * value) ~/ maxValue + 1;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(labelValue, style: const TextStyle(fontSize: textSize)),
        ),
        getIconIndicator(type, mappedVal),
      ],
    );
  }

  Widget getIconIndicator(StatsType type, int value) {
    return Row(
      children: <Icon>[
        for (var i = 0; i < value; i++) ...[
          Icon(statsIcon[type]),
        ],
      ],
    );
  }
}
