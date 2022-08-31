import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/data_model.dart';
import 'package:tree_ar/Views/Ar_Views/tree_info_ar_view.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/DataProvider/data_manager.dart';
import 'package:tree_ar/utils.dart';

import '../CustomWidget/round_back_button.dart';

class LaunchArButton extends StatelessWidget {
  final Tree tree;
  final Project proj;

  const LaunchArButton({
    super.key,
    required this.tree,
    required this.proj,
  });

  @override
  Widget build(BuildContext context) {
    bool buttonIsEnable = false;
    TreeViewInfoAr? arViewPage;

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<DataManager>(
          builder: (context, dataManager, child) =>
              FutureBuilder<Map<TreeSpecs, Pair<num, num>>>(
            future: dataManager.getBoundsOfTreeVal(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  var rangeInfoValues = snapshot.data!;
                  buttonIsEnable = true;
                  arViewPage = TreeViewInfoAr(
                    tree: tree,
                    proj: proj,
                    rangeInfoValues: rangeInfoValues,
                  );
                }
              } else {
                buttonIsEnable = false;
              }

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 50),
                  backgroundColor: buttonIsEnable ? mainColor : grayColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: buttonIsEnable
                    ? () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => arViewPage!,
                              )),
                        }
                    : null,
                child: const Text(
                  'AR View',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              );
            },
          ),
        ));
  }
}
