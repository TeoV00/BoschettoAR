import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class UserStatisticCounter extends StatelessWidget {
  final String type;
  final int amount;
  final String unit;

  const UserStatisticCounter(
      {Key? key, required this.type, required this.amount, required this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pair<int, String?> valueAndUnit = getMultiplierString(amount);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            valueAndUnit.elem1.toString(),
            style: const TextStyle(fontSize: 22),
          ),
        ),
        valueAndUnit.elem2 != null
            ? Text(
                valueAndUnit.elem2!,
                style: const TextStyle(fontSize: 16),
              )
            : Container(),
        Text(
          unit,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

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
    final double percValue = (widget.progressPerc / 100) * treeHeight;

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
        Text("${widget.progressPerc} %",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        Image.asset(
          '$imagePath/progressBarTree.png',
          alignment: Alignment.bottomCenter,
          height: treeHeight,
        ),
      ],
    );
  }
}
