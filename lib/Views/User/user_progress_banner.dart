import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class TreeProgessBar extends StatefulWidget {
  final double progressPerc;
  const TreeProgessBar({Key? key, required this.progressPerc})
      : super(key: key);

  @override
  State<TreeProgessBar> createState() => _TreeProgressBar();
}

class _TreeProgressBar extends State<TreeProgessBar> {
  final double treeHeight = 130;
  final double treeWidth = 120;

  @override
  Widget build(BuildContext context) {
    final double percValue = ((widget.progressPerc / 100) / treeHeight) * 100;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height:
              treeHeight - 2, //sub 2 to remove green bar on right and bottom
          width: treeWidth - 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [mainColor, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [percValue, percValue],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text("${widget.progressPerc}%",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        ),
        Image.asset(
          '$imagePath/progressBarTree.png',
          alignment: Alignment.bottomCenter,
          height: treeHeight,
        ),
      ],
    );
  }
}
