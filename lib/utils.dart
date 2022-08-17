import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tree_ar/constant_vars.dart';

class Pair<T, R> {
  late T elem1;
  late R elem2;

  Pair(T e1, R e2) {
    elem1 = e1;
    elem2 = e2;
  }

  @override
  String toString() {
    return '(${elem1.toString()}, ${elem2.toString()})';
  }
}

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

Pair<int, String?> getMultiplierString(int value) {
  int amountCifer = value.toString().length;

  if (amountCifer > 3 && amountCifer <= 6) {
    return Pair(value ~/ 1000, 'x10^3');
  } else if (amountCifer > 6 && amountCifer <= 9) {
    return Pair(value ~/ 1000000, 'x10^6');
  } else if (amountCifer > 9 && amountCifer <= 12) {
    return Pair(value ~/ 1000000000, 'x10^9');
  } else {
    return Pair(value, null);
  }
}

Widget rowIndicator(
  String label,
  StatsType type,
  int value,
  int maxValue,
  double screenWidth,
) {
  const double iconSizeDefault = 24;
  const double textSize = 15;
  String labelValue = "$label: $value";

  if (value > maxValue) {
    value = maxValue;
  }

  double textPixel = textSize * labelValue.length;
  int maxIconCount = ((screenWidth - textPixel) / iconSizeDefault).ceil();
  int mappedVal = (maxIconCount * value) ~/ maxValue + 1;

  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Text(labelValue, style: const TextStyle(fontSize: textSize)),
      ),
      getIconIndicator(type, mappedVal),
    ],
  );
}

Widget getIconIndicator(StatsType type, int value) {
  return Row(
    children: <Icon>[
      for (var i = 0; i < value; i++) ...[
        Icon(statsIcon[type]),
      ],
    ],
  );
}
