import 'package:flutter/material.dart';
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
