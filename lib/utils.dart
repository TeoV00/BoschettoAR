import 'dart:developer';
import 'dart:io';

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

Widget getUserImageWidget(String? userImgPath) {
  Widget image = Image.asset(
    "$imagePath/userPlaceholder.jpeg",
    height: 90,
    width: 90,
  );

  if (userImgPath != null) {
    File(userImgPath).exists().then((exist) => {
          if (exist)
            {
              log("Immagine esiste"),
              image = Image.file(
                File(userImgPath),
                height: 90,
                width: 90,
              )
            }
        });
  }
  log("Immagine default");
  return ClipOval(child: image);
}
