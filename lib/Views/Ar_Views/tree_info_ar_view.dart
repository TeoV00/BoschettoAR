import 'package:flutter/material.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Utils/unit_converter.dart';
import 'package:tree_ar/Views/Ar_Views/ar_view.dart';
import 'package:tree_ar/Views/Ar_Views/hint_banner_ar.dart';
import 'package:tree_ar/Views/CustomWidget/round_back_button.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

const defaultMinAmountPapers = 50000;

class TreeViewInfoAr extends StatelessWidget {
  final Tree tree;
  final Project proj;
  final Map<TreeSpecs, Pair<num, num>> rangeInfoValues;

  const TreeViewInfoAr(
      {Key? key,
      required this.tree,
      required this.proj,
      required this.rangeInfoValues})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num totalSavedPaper = defaultMinAmountPapers;

    if (rangeInfoValues[TreeSpecs.paper] != null) {
      totalSavedPaper = rangeInfoValues[TreeSpecs.totalPaper]!.elem1;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ARWidget(
              savedCo2: proj.co2Saved,
              savedPaperProj: proj.paper,
              minMaxPaperValue: rangeInfoValues[TreeSpecs.paper]!,
              totalSavedPaper: totalSavedPaper,
            ), //AR view widget
            const HintBanner(),
            DraggableScrollableSheet(
              //Bottom Sheet that show scanned tree info
              minChildSize: 0.10,
              initialChildSize: 0.15,
              maxChildSize: 0.6,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return TreeInfoSheet(
                  tree: tree,
                  project: proj,
                  treeMaxValues: rangeInfoValues,
                  controller: scrollController,
                );
              },
            ),
            const Padding(
              padding: pagePadding,
              child: RoundBackButton(result: null),
            )
          ],
        ),
      ),
    );
  }
}

class TreeInfoSheet extends StatelessWidget {
  final ScrollController controller;
  final Tree tree;
  final Project project;
  final Map<TreeSpecs, Pair<num, num>> treeMaxValues;

  const TreeInfoSheet(
      {Key? key,
      required this.controller,
      required this.tree,
      required this.project,
      required this.treeMaxValues})
      : super(key: key);

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
        child: ListView(
          controller: controller,
          children: [
            Text(nameTree,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            Text(tree.descr),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  rowIndicator('Co2 (Kg/Anno)', TreeSpecs.co2, tree.co2,
                      treeMaxValues[TreeSpecs.co2]!.elem2, screenWidth),
                  rowIndicator('Altezza (metri)', TreeSpecs.height, tree.height,
                      treeMaxValues[TreeSpecs.height]!.elem2, screenWidth),
                ],
              ),
            ),
            const Divider(thickness: 1),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                "Progetto: ${project.projectName}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
              ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  rowLabelValue(
                      'Co2 Evitata', project.co2Saved.toString(), 'Kg'),
                  rowLabelValue('Carta', project.paper.toString(), 'fogli A4'),
                  rowLabelValue(
                      'Barili di Petrolio',
                      ValueConverter.fromCo2ToPetrolBarrels(project.co2Saved)
                          .toString(),
                      'barili'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
