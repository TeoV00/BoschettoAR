import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/dataModel.dart';

import '../constant_vars.dart';
import '../data_manager.dart';

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
      body: SafeArea(
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(child: CustomListView(dataType: _selectedType))
              ],
            ),
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
    return Consumer<DataManager>(
      builder: (context, dataManager, child) {
        dataManager.getUserTreesProject;
        var treeAndProj = dataManager.userTreeAndProj;

        if (treeAndProj[InfoType.tree] != null &&
            treeAndProj[InfoType.project] != null &&
            treeAndProj[InfoType.tree]!.isNotEmpty) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
            itemCount: treeAndProj[widget.dataType]!.length,
            itemBuilder: (BuildContext context, int index) {
              return RowItem(
                  item: treeAndProj[widget.dataType]![index],
                  type: widget.dataType);
            },
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Ahi ahi!! Ancora nessun albero scansionato!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          );
        }
      },
    );
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 19),
              height: 57,
              width: 57,
              //TODO: remove black square and put an image of tree or project logo
              color: Colors.black,
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: margin5H,
              child: Text(
                item.getTitle(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Padding(
              padding: margin5H,
              child: Text(
                item.getDescr(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
