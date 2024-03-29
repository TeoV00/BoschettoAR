import 'package:flutter/material.dart';
import 'package:tree_ar/utils.dart';

class UserStatisticCounter extends StatelessWidget {
  final String type;
  final int amount;
  final String unit;

  const UserStatisticCounter({
    Key? key,
    required this.type,
    required this.amount,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pair<num, int?> valueAndUnit = getMultiplierString(amount);

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
              fit: BoxFit.cover,
              child: Text(
                type,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                double.parse(valueAndUnit.elem1.toStringAsFixed(1)).toString(),
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          valueAndUnit.elem2 != null
              ? getExponentWidget(valueAndUnit.elem2!, null)
              : Container(),
          Text(
            unit,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
