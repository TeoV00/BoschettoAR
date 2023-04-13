import 'package:flutter/material.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/utils.dart';

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    return Container(
      color: secondColor,
      child: CenteredWidget(
        widgetToCenter: Column(children: [
          Icon(Icons.error, size: 100, color: textColor),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Torna in Home")),
        ]),
      ),
    );
  }
}
