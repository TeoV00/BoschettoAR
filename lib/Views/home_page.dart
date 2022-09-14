import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Views/infoPageView.dart/info_item_page.dart';
import 'package:tree_ar/utils.dart';

import '../constant_vars.dart';
import '../DataProvider/data_manager.dart';

///Main page of application, shows list of project and tree that has been
///discovered-scanned by user in scan-tree-ar page
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  InfoType _selectedType = InfoType.tree;

  void _onTapTab(InfoType typeSelected) {
    setState(() {
      _selectedType = typeSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    const tabButtonWidth = (topSectionTabWidth / 2) - 45;
    return Scaffold(
      appBar: AppBar(
        title: const Text("TreeAR"),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                //TODO: create info page
                log("open info page");
                //InfoAppPage();
              }),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomListView(dataType: _selectedType),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(radiusCorner),
                      color: secondColor),
                  height: 50,
                  width: topSectionTabWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(
                        label: const SizedBox(
                          width: tabButtonWidth,
                          child: Text(
                            "Alberi",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        selected: _selectedType == InfoType.tree,
                        onSelected: (_) => _onTapTab(InfoType.tree),
                        selectedColor: Colors.white,
                      ),
                      ChoiceChip(
                        label: const SizedBox(
                          width: tabButtonWidth,
                          child: Text(
                            "Progetti",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        selected: _selectedType == InfoType.project,
                        onSelected: (_) => _onTapTab(InfoType.project),
                        selectedColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListView extends StatefulWidget {
  final InfoType dataType;
  const CustomListView({Key? key, required this.dataType}) : super(key: key);

  @override
  State<CustomListView> createState() => _CustomListView();
}

class _CustomListView extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataManager>(builder: (context, dataManager, child) {
      return FutureBuilder<Map<InfoType, List<dynamic>>>(
        future: dataManager.getUserTreesProject(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var treeAndProj = snapshot.data!;

            if (treeAndProj[InfoType.tree] != null &&
                treeAndProj[InfoType.project] != null &&
                treeAndProj[InfoType.tree]!.isNotEmpty &&
                treeAndProj[InfoType.project]!.isNotEmpty) {
              int itemCount = treeAndProj[widget.dataType]!.length;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    var item = treeAndProj[widget.dataType]![index];

                    Widget rowItem = RowItem(item: item, type: widget.dataType);

                    if (index == itemCount - 1) {
                      rowItem = Padding(
                        padding: const EdgeInsets.only(bottom: grassHeight),
                        child: rowItem,
                      );
                    }

                    return GestureDetector(
                      child: rowItem,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return InfoItemPage(
                            proj: treeAndProj[InfoType.project]![index],
                            tree: treeAndProj[InfoType.tree]![index],
                            dataType: widget.dataType,
                          );
                        }),
                      ),
                    );
                  });
            } else {
              return const CenteredWidget(
                  widgetToCenter: Text(
                "Ahi ahi!! Ancora nessun albero scansionato!",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
            }
          } else if (snapshot.hasError) {
            return const CenteredWidget(
                widgetToCenter: Text("Errore caricamento dati"));
          } else {
            return const CenteredWidget(
              widgetToCenter: CircularProgressIndicator(
                color: mainColor,
              ),
            );
          }
        },
      );
    });
  }
}

class RowItem extends StatelessWidget {
  final ListItemInterface item;
  final InfoType type;

  static const margin5H = EdgeInsets.symmetric(horizontal: 5);

  const RowItem({Key? key, required this.item, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 85,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: grayColor,
      ),
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: item.getImageUrl()!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              height: 75,
              width: 75,
              errorWidget: (context, error, stackTrace) {
                log(error.toString());
                return ClipOval(
                  child: Container(
                    width: imageSizeDetailPage,
                    height: imageSizeDetailPage,
                    color: grayColor,
                    child: Icon(
                        type == InfoType.tree
                            ? Icons.nature
                            : Icons.construction,
                        size: 50),
                  ),
                );
              },
            )
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: const Color.fromARGB(255, 217, 217, 217),
            //   ),
            //   margin: const EdgeInsets.symmetric(horizontal: 15),
            //   height: 57,
            //   width: 57,
            //   child: item.getImageUrl(),
            // )
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      item.getTitle(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
              Flex(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      item.getDescr(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
