import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/constant_vars.dart';
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

      itemDetailsView = Column(
        children: [
          DetailsBox(
            childBox: Text(
              proj.descr,
              style: const TextStyle(color: Colors.black),
            ),
            headerTitle: 'Descrizione',
          ),
          DetailsBox(
            childBox: Text(proj.category),
            headerTitle: 'Dettagli',
          )
        ],
      );
    } else if (item.runtimeType == Tree) {
      Tree tree = (item as Tree);
      itemDetailsView = Text('corpo');
      titlePage = tree.name;
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(radiusCorner),
        color: grayColor,
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
    );
  }
}
