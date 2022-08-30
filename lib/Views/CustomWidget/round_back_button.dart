import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class RoundBackButton extends StatelessWidget {
  final Object? result;

  const RoundBackButton({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: mainColor),
      child: IconButton(
        tooltip: "Torna in Home",
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, result),
      ),
    );
  }
}
