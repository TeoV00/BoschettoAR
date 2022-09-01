import 'package:flutter/material.dart';

class HintBanner extends StatelessWidget {
  final String text;
  const HintBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100, top: 5, right: 5),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
