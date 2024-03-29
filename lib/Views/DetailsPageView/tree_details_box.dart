// import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/Views/DetailsPageView/details_box_container.dart';
import 'package:tree_ar/constant_vars.dart';
// import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';
// import 'package:provider/provider.dart';
import 'package:tree_ar/DataModel/data_model.dart';
import 'package:flutter/material.dart';

class TreeDetailsBox extends StatelessWidget {
  final Tree tree;
  const TreeDetailsBox({Key? key, required this.tree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const double pad = 10;
    // final double screenWidth = MediaQuery.of(context).size.width - (2 * pad);

    // return Consumer<DataManager>(
    //   builder: (context, dataManager, child) {
    // return
    // FutureBuilder<Map<TreeSpecs, Pair<num, num>>>(
    //   future: dataManager.getBoundsOfTreeVal(),
    //   builder: (context, snapshot) {
    List<Widget> childs;

    //     if (snapshot.hasData && false) {
    //       var bounds = snapshot.data!;

    //       childs = [
    //         rowIndicator('Co2/Anno', TreeSpecs.co2, tree.co2,
    //             bounds[TreeSpecs.co2]!.elem2, screenWidth),
    //         rowIndicator('Altezza (m) ', TreeSpecs.height, tree.height,
    //             bounds[TreeSpecs.height]!.elem2, screenWidth),
    //       ];
    //     } else {
    childs = [
      rowLabelValue(co2String, tree.co2, 'Kg/Anno'),
      rowLabelValue('Altezza', tree.height.toString(), 'metri'),
    ];
    // }

    if (tree.diameter > 0) {
      childs.add(rowLabelValue('Tronco', tree.diameter.toString(), 'cm'));
    }

    return DetailsBox(
      headerTitle: 'Dettagli',
      childBox: Column(
        children: childs,
      ),
    );
    //       },
    //     );
    //   },
    // );
  }
}
