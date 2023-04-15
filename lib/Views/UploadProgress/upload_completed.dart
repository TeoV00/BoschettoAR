import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class CompletedUploadView extends StatelessWidget {
  const CompletedUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredWidget(
      widgetToCenter: Column(
        children: [
          SizedBox(
            height: 80,
            child: Image.asset('$imagePath/treeVase/5.png'),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Caricamento completato!!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
