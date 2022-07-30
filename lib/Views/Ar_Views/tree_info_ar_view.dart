import 'package:flutter/material.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Views/Ar_Views/ar_view.dart';
import 'package:tree_ar/constant_vars.dart';

class TreeViewInfoAr extends StatelessWidget {
  final Tree tree;
  final Project proj;
  static ARWidget arWidget = const ARWidget();

  const TreeViewInfoAr({Key? key, required this.tree, required this.proj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //arWidget, //AR view widget
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
          )
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
          Text(tree.descr),
          const Divider(thickness: 1),
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
              project.descr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
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
              getIconIndicator(StatsType.paper, 5),
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
