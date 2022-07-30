import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';

class Statistics {
  int papers;
  int co2;
  double progress;

  Statistics(this.papers, this.co2, this.progress);
}

void showSnackBar(BuildContext context, Widget content, Duration? duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: content, duration: duration ?? const Duration(seconds: 4)),
  );
}

class CenteredWidget extends StatelessWidget {
  final Widget widgetToCenter;

  const CenteredWidget({Key? key, required this.widgetToCenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [widgetToCenter],
        )
      ],
    );
  }
}

Widget scaffoldTopFloatingButton(
    Widget pageWidget, BuildContext context, void onPressedFunc) {
  return Scaffold(
    body: SafeArea(
      child: Stack(children: [
        pageWidget,
        Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: mainColor),
          child: IconButton(
            tooltip: "Indietro",
            icon: const Icon(Icons.arrow_back),
            onPressed: () => onPressedFunc,
          ),
        ),
      ]),
    ),
  );
}
