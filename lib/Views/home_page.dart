import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Views/HomePage/InfoPage/info_credit_page.dart';
import 'package:tree_ar/Views/HomePage/home_list_item.dart';
import 'package:tree_ar/Views/detailsPageView.dart/info_item_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, //Tree
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InfoCreditsPage(),
                  ),
                ),
              },
              icon: const Icon(Icons.info_outline),
            )
          ],
          title: const Text(appName),
          centerTitle: true,
          backgroundColor: mainColor,
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: secondColor,
            indicatorWeight: 3.0,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.nature),
                child: Text('Alberi'),
              ),
              Tab(
                icon: Icon(Icons.abc),
                child: Text('Progetti'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            CustomListView(dataType: InfoType.tree),
            CustomListView(dataType: InfoType.project),
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
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
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
