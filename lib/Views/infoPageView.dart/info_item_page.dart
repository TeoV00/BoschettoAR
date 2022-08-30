import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';
import 'package:tree_ar/utils.dart';

class InfoItemPage extends StatelessWidget {
  final InfoType dataType;
  final dynamic item;
  const InfoItemPage({Key? key, required this.dataType, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget itemDetailsView = const CenteredWidget(
      widgetToCenter: Text('Dati non validi'),
    );
    String titlePage = 'Errore dati';

    if (item.runtimeType == Project) {
      Project proj = (item as Project);
      titlePage = proj.projectName;

      itemDetailsView = ScrollableListOfDetailsBoxes(
        item: proj,
        itemType: InfoType.project,
        childrenSections: [ProjectDetailsBox(proj: proj)],
      );
    } else if (item.runtimeType == Tree) {
      Tree tree = (item as Tree);
      titlePage = tree.name;
      itemDetailsView = ScrollableListOfDetailsBoxes(
        item: tree,
        itemType: InfoType.tree,
        childrenSections: [TreeDetailsBox(tree: tree)],
      );
    }

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: itemDetailsView),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: mainColor),
                child: IconButton(
                  tooltip: "Torna in Home",
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(radiusCorner),
                    color: secondColor,
                  ),
                  height: 51,
                  child: Text(
                    titlePage,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
              )
            ],
          ),
        ]),
      )),
    );
  }
}

class DetailsBox extends StatelessWidget {
  final String headerTitle;
  final Widget childBox;
  const DetailsBox(
      {Key? key, required this.headerTitle, required this.childBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(radiusCorner),
          color: Color.fromARGB(255, 244, 244, 244),
        ),
        child: Column(children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    headerTitle,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(153, 0, 0, 0)),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  children: [childBox],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}

class ScrollableListOfDetailsBoxes extends StatelessWidget {
  final ListItemInterface item;
  final InfoType itemType;
  final List<Widget> childrenSections;

  const ScrollableListOfDetailsBoxes(
      {Key? key,
      required this.item,
      required this.itemType,
      required this.childrenSections})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [
      ClipOval(
        child: Image.network(
          item.getImageUrl() ?? '',
          height: imageSizeDetailPage,
          width: imageSizeDetailPage,
          errorBuilder: (context, error, stackTrace) {
            log(error.toString());
            return ClipOval(
              child: Container(
                width: imageSizeDetailPage,
                height: imageSizeDetailPage,
                color: grayColor,
                child: Icon(
                    itemType == InfoType.tree
                        ? Icons.nature
                        : Icons.construction,
                    size: 50),
              ),
            );
          },
        ),
      ),
      DetailsBox(
        childBox: Text(
          item.getDescr(),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        headerTitle: 'Descrizione',
      ),
    ];

    childs.addAll(childrenSections);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: childs,
      ),
    );
  }
}

class TreeDetailsBox extends StatelessWidget {
  final Tree tree;
  const TreeDetailsBox({Key? key, required this.tree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double pad = 10;
    final double screenWidth = MediaQuery.of(context).size.width - (2 * pad);

    return Consumer<DataManager>(
      builder: (context, dataManager, child) {
        return FutureBuilder<Map<TreeSpecs, Pair<num, num>>>(
          future: dataManager.getBoundsOfTreeVal(),
          builder: (context, snapshot) {
            List<Widget> childs;

            if (snapshot.hasData) {
              var bounds = snapshot.data!;

              childs = [
                rowIndicator('Co2/Anno', TreeSpecs.co2, tree.co2,
                    bounds[TreeSpecs.co2]!.elem2, screenWidth),
                rowIndicator('Altezza (m) ', TreeSpecs.height, tree.height,
                    bounds[TreeSpecs.height]!.elem2, screenWidth),
                rowIndicator('Tronco (cm)', TreeSpecs.diameter, tree.diameter,
                    bounds[TreeSpecs.diameter]!.elem2, screenWidth),
              ];
            } else {
              childs = [
                rowLabelValue('Co2', tree.co2.toString(), 'Kg/Anno'),
                rowLabelValue('Altezza', tree.height.toString(), 'm'),
                rowLabelValue('Tronco', tree.diameter.toString(), 'cm'),
              ];
            }

            return DetailsBox(
              headerTitle: 'Dettagli',
              childBox: Column(
                children: childs,
              ),
            );
          },
        );
      },
    );
  }
}

class ProjectDetailsBox extends StatelessWidget {
  final Project proj;
  const ProjectDetailsBox({Key? key, required this.proj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsBox(
      headerTitle: 'Dettagli',
      childBox: Column(
        children: [
          rowLabelValue('Anni', proj.years.toString(), null),
          rowLabelValue('Alberi piantati', proj.treesCount.toString(), null),
          rowLabelValue('Carta', proj.paper.toString(), 'Fogli A4'),
          rowLabelValue('Co2 assorbita', proj.co2Saved.toString(), 'Kg'),
          rowLabelValue('Categoria', proj.category.toString(), null),
        ],
      ),
    );
  }
}
