import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/Views/CustomWidget/round_back_button.dart';
import 'package:tree_ar/Views/infoPageView.dart/ar_view_button.dart';
import 'package:tree_ar/Views/infoPageView.dart/details_box_container.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InfoItemPage extends StatelessWidget {
  final InfoType dataType;
  final Tree tree;
  final Project proj;
  const InfoItemPage(
      {Key? key,
      required this.dataType,
      required this.tree,
      required this.proj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget itemDetailsView = const CenteredWidget(
      widgetToCenter: Text('Dati non validi'),
    );
    String titlePage = 'Errore dati';

    if (dataType == InfoType.project) {
      titlePage = proj.projectName;

      itemDetailsView = ScrollableListOfDetailsBoxes(
        item: proj,
        itemType: InfoType.project,
        childrenSections: [ProjectDetailsBox(proj: proj)],
      );
    } else if (dataType == InfoType.tree) {
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
        child: Stack(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: itemDetailsView,
                ),
                LaunchArButton(
                  proj: proj,
                  tree: tree,
                ),
                //
              ],
            ),
            Row(
              children: [
                const RoundBackButton(result: null),
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
          ],
        ),
      )),
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
        child: (item.getImageUrl() != null && item.getImageUrl()!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: item.getImageUrl()!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                height: imageSizeDetailPage,
                width: imageSizeDetailPage,
                errorWidget: (context, error, stackTrace) {
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
              )
            : ClipOval(
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
